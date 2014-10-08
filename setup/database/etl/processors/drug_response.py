from decimal import Decimal
from setup.database.etl.data_sources.drug_information import DrugInformationDataSource
from setup.database.etl.data_sources.drug_response import DrugResponseDataSource
from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class DrugResponseETLProcessor(ETLProcessor):

    def __init__(self, dataset_id, cancer_cell_line_etl_processor):
        super(self.__class__, self).__init__(dataset_id, [DrugInformationDataSource, DrugResponseDataSource],
                                             null_value='NULL')
        self.drug_responses = CCLEDatabase().drug_responses
        self.drug_response_doses = CCLEDatabase().drug_response_doses
        self.therapy_compounds = CCLEDatabase().therapy_compounds
        self._cancer_cell_line_etl_processor = cancer_cell_line_etl_processor

    def load(self):
        self._load_therapy_compounds()
        self._load_drug_responses()

    def _load_therapy_compounds(self):
        for row_number, row in self.extract(DrugInformationDataSource).iterrows():
            self._load_therapy_compound(row)

    def _load_therapy_compound(self, row):
        tc = self.therapy_compounds

        name = self._get_value_or_none_if_equals_null(row['Compound (code or generic name)'])
        brand_name = self._get_value_or_none_if_equals_null(row['Compound (brand name)'])
        mechanism_of_action = self._get_value_or_none_if_equals_null(row['Mechanism of action'])
        drug_class = self._get_value_or_none_if_equals_null(row['Class'])
        if drug_class is not None:
            drug_class = drug_class.lower()
        highest_phase = self._get_value_or_none_if_equals_null(row['Highest Phase'])
        organization = self._get_value_or_none_if_equals_null(row['Organization'])
        target = self._get_value_or_none_if_equals_null(row['Target(s)'])

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            tc, {
                tc.c.name: name,
                tc.c.brandName: brand_name,
                tc.c.mechanismOfAction: mechanism_of_action,
                tc.c['class']: drug_class,
                tc.c.highestPhase: highest_phase,
                tc.c.organization: organization,
                tc.c.target: target,
            },
            [tc.c.name]
        )

    def _load_drug_responses(self):
        for row_number, row in self.extract(DrugResponseDataSource).iterrows():
            self._load_drug_response(row)

    def _load_drug_response(self, row):
        r = self.drug_responses

        ccle_cell_line_name = self._get_value_or_none_if_equals_null(row['CCLE Cell Line Name'])
        cancer_cell_line_id = self._cancer_cell_line_etl_processor.get_cancer_cell_line_id_by_name(ccle_cell_line_name)
        compound_name = self._get_value_or_none_if_equals_null(row['Compound'])
        therapy_compound_id = self._get_compound_id_by_name(compound_name)

        if therapy_compound_id is None:
            self._add_therapy_compound_with_name(compound_name)
            therapy_compound_id = self._get_compound_id_by_name(compound_name)

        fit_type = self._get_value_or_none_if_equals_null(row['FitType'])
        ec50_um = self._get_value_or_none_if_equals_null(row['EC50 (uM)']) or -1
        ic50_um = self._get_value_or_none_if_equals_null(row['IC50 (uM)'])
        a_max = self._get_value_or_none_if_equals_null(row['Amax'])
        act_area = self._get_value_or_none_if_equals_null(row['ActArea'])

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            r, {
                r.c.fitType: fit_type,
                r.c.ec50UM: ec50_um,
                r.c.ic50UM: ic50_um,
                r.c.aMax: a_max,
                r.c.actArea: act_area,
                r.c.CancerCellLines_idCancerCellLine: cancer_cell_line_id,
                r.c.TherapyCompounds_idTherapyCompound: therapy_compound_id,
            },
            [r.c.CancerCellLines_idCancerCellLine, r.c.TherapyCompounds_idTherapyCompound]
        )

        self._load_drug_response_doses(row)

    def _add_therapy_compound_with_name(self, name):
        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.therapy_compounds, {
                self.therapy_compounds.c.name: name,
            },
            [self.therapy_compounds.c.name]
        )

    def _get_compound_id_by_name(self, name):
        table = self.therapy_compounds
        return self._get_id_by_column_values(table, {table.c.name: name})

    def _load_drug_response_doses(self, row):
        rd = self.drug_response_doses

        doses = self._get_value_or_none_if_equals_null(row['Doses (uM)'])
        activity_data = self._get_value_or_none_if_equals_null(row['Activity Data (median)'])
        activity_sd = self._get_value_or_none_if_equals_null(row['Activity SD'])

        ccle_cell_line_name = self._get_value_or_none_if_equals_null(row['CCLE Cell Line Name'])
        cancer_cell_line_id = self._cancer_cell_line_etl_processor.get_cancer_cell_line_id_by_name(ccle_cell_line_name)
        compound_name = self._get_value_or_none_if_equals_null(row['Compound'])
        therapy_compound_id = self._get_compound_id_by_name(compound_name)

        drug_response_id = self._get_drug_response_id_from_cancer_cell_line_id_and_therapy_compound_id(
            cancer_cell_line_id, therapy_compound_id)

        single_doses = doses.split(',')
        single_activity_data = activity_data.split(',')
        single_activity_sd = activity_sd.split(',')

        for index in xrange(0, len(single_doses)):
            single_dose = Decimal(single_doses[index])
            single_ad = Decimal(single_activity_data[index])
            single_sd = Decimal(single_activity_sd[index])

            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                rd, {
                    rd.c.doseUM: single_dose,
                    rd.c.activityMedian: single_ad,
                    rd.c.activitySD: single_sd,
                    rd.c.DrugResponses_idDrugResponse: drug_response_id
                },
                [rd.c.DrugResponses_idDrugResponse, rd.c.doseUM]
            )

    def _get_drug_response_id_from_cancer_cell_line_id_and_therapy_compound_id(
            self, cancer_cell_line_id, therapy_compound_id):
        table = self.drug_responses
        return self._get_id_by_column_values(table, {
            table.c.CancerCellLines_idCancerCellLine: cancer_cell_line_id,
            table.c.TherapyCompounds_idTherapyCompound: therapy_compound_id
        })
