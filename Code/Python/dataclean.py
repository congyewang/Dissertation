import pandas as pd
from fancyimpute import KNN


class DataClean(object):

    def __init__(self):
        self.dict_filepath = "../../Data/CSV/财务指标.csv"
        self.data_filepath = "../../Data/CSV/data.csv"
        self.result_filepath = "../../Data/CSV/res.csv"

    def get_dick(self, choice: str) -> dict:
        dict_en2zh = {}
        dict_en2var = {}
        dict_var2zh = {}

        with open(self.dict_filepath, "r") as f:
            lines = [lines.rstrip('\n') for lines in f]

        for i in lines:
            line = i.split(",")
            dict_en2zh[line[0]] = line[1]
            dict_en2var[line[0]] = line[2]
            dict_var2zh[line[2]] = line[1]

        if choice == "en2zh":
            res = dict_en2zh
        elif choice == "en2var":
            res = dict_en2var
        elif choice == "var2zh":
            res = dict_var2zh
        else:
            raise ValueError('Choose "en2zh", "en2var", or "var2zh"')

        return res

    def merge_data_res(self):
        df = pd.read_csv(self.data_filepath, header=0)
        y = pd.read_csv(self.result_filepath, header=0)
        tag = []

        y['end_date'] = y['end_date'].astype("str")
        y['add'] = y["ts_code"] + y["end_date"]
        df['end_date'] = df['end_date'].astype('str')
        df['add'] = df["ts_code"] + df["end_date"]
        no_stand = list(y['add'])

        for j in range(len(df)):
            if df['add'].iloc[j] in no_stand:
                tag.append(1)
            else:
                tag.append(0)
        df["y"] = tag

        return df

    def knn_fill_nan(self):
        df = self.merge_data_res()

        right = df[df['y'] == 0]
        wrong = df[df['y'] == 1]
        right = right.drop(
            ["ts_code", "ann_date", "end_date", "update_flag", "add"], axis=1)
        wrong = wrong.drop(
            ["ts_code", "ann_date", "end_date", "update_flag", "add"], axis=1)

        right = pd.DataFrame(KNN(k=6).fit_transform(right))
        wrong = pd.DataFrame(KNN(k=6).fit_transform(wrong))

        df_no_nan = pd.concat([right, wrong], axis=0)

        right = df_no_nan[df_no_nan['y'] == 0]
        wrong = df_no_nan[df_no_nan['y'] == 1]
        right_ts_code = list(right["ts_code"])
        right_end_date = list(right["end_date"])
        wrong_ts_code = list(wrong["ts_code"])
        wrong_end_date = list(wrong["end_date"])
        ts_code = right_ts_code + wrong_ts_code
        end_date = right_end_date + wrong_end_date

        df_total = pd.read_csv("../../Data/new.csv", header=0)
        df_total["ts_code"] = ts_code
        df_total["end_date"] = end_date

        return df_total

    def rename_X(self):
        df = self.knn_fill_nan()
        dict_en2var = self.get_dick("en2var")
        columns_name = list(df.columns)

        columns_name.remove('end_date')
        en2var_columns = [dict_en2var[i] for i in columns_name]
        en2var_columns.append('end_date')

        df.columns = en2var_columns

        return df
