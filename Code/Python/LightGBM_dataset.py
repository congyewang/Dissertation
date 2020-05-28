import pandas as pd
# import dataclean


def main():
    # 读取正交旋转荷载因子矩阵
    ORLFM = pd.read_excel("../../Data/Excel/正交旋转荷载因子矩阵.xlsx",
                          header=0, index_col=0)
    # 读取处理后数据
    df = pd.read_csv(
        "../../Data/CSV/MANOVA_positive_dataset.csv.csv", header=0)
    # 读取原始文件
    d_o = dataclean.DataClean().rename_X()

    # 分别求正交旋转荷载因子矩阵行最大值及最大值所在索引
    ORLFM['max_value'] = ORLFM.max(axis=1)
    ORLFM['max_index'] = ORLFM.idxmax(axis=1)

    # 列切片出旋转后变量
    new_ORLFM = ORLFM.loc[:, ["max_value", "max_index"]]

    new_ORLFM["max_value"] = new_ORLFM["max_value"].apply(str)
    new_ORLFM['index'] = new_ORLFM.index
    new_ORLFM['fo'] = new_ORLFM["max_value"] + " * " + new_ORLFM['index']

    # 打印结果
    d = {}
    for i in set(new_ORLFM["max_index"]):
        l = []
        for j in new_ORLFM[new_ORLFM["max_index"] == i]["fo"]:
            l.append(j)
        # print(i + " = " + " + ".join(l))
        d[i] = " + ".join(l)
    for i in range(len(d)):
        j = eval(f"d['PA{i + 1}']")
        print(f"PA{i + 1}" + " = " + j)

    # 新建处理后表格并输出
    df_new = pd.DataFrame()
    new_ORLFM["trans"] = new_ORLFM["max_value"] + \
        " * df['" + new_ORLFM["index"] + "']"
    for i in set(new_ORLFM["max_index"]):
        l = []
        for j in new_ORLFM[new_ORLFM["max_index"] == i]["trans"]:
            l.append(j)
        s = "df_new['" + i + "']" + " = " + " + ".join(l)
        exec(s)
    df_new['y'] = d_o['y']
    # df_new.to_csv("data_3_trans.csv", index=False)

    return df_new


if __name__ == "__main__":
    print(main().head())
