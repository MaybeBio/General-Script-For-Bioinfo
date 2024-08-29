# 原始数据
data = {
    'Sample': [
        'BT549_rep1', 'BT549_rep2',
        'HCC70_rep1', 'HCC70_rep2',
        'HMEC_rep1', 'HMEC_rep2',
        'MB231'
    ],
    'valid_interaction': [
        224246910, 202868946,
        299891225, 287985409,
        249747489, 242683175,
        235793172
    ],
    'valid_interaction_rmdup': [
        161020707, 149583853,
        220372799, 218767093,
        200157661, 175844215,
        200168329
    ],
    'trans_interaction': [
        17562487, 17664632,
        23958485, 22517745,
        15284940, 12657263,
        20676310
    ],
    'cis_interaction': [
        143458220, 131919221,
        196414314, 196249348,
        184872721, 163186952,
        179492019
    ],
    'cis_shortRange': [
        66564454, 58050688,
        63057572, 66109409,
        80356797, 83465879,
        50110554
    ],
    'cis_longRange': [
        76893766, 73868533,
        133356742, 130139939,
        104515924, 79721073,
        129381465
    ]
}

# 计算比例并添加新列
for i, sample in enumerate(data['Sample']):
    # 计算每个样本的重复比例
    valid_interaction = data['valid_interaction'][i]
    valid_interaction_rmdup = data['valid_interaction_rmdup'][i]
    trans_interaction = data['trans_interaction'][i]
    cis_interaction = data['cis_interaction'][i]
    cis_shortRange = data['cis_shortRange'][i]
    cis_longRange = data['cis_longRange'][i]

    ratios = {
        'valid_interaction_rmdup_ratio': valid_interaction_rmdup / valid_interaction,
        'trans_interaction_ratio': trans_interaction / valid_interaction_rmdup,
        'cis_interaction_ratio': cis_interaction / valid_interaction_rmdup,
        'cis_shortRange_ratio': cis_shortRange / cis_interaction,
        'cis_longRange_ratio': cis_longRange / cis_interaction
    }

    # 添加新列到数据字典中
    data[sample + '_valid_interaction_rmdup_ratio'] = ratios['valid_interaction_rmdup_ratio']
    data[sample + '_trans_interaction_ratio'] = ratios['trans_interaction_ratio']
    data[sample + '_cis_interaction_ratio'] = ratios['cis_interaction_ratio']
    data[sample + '_cis_shortRange_ratio'] = ratios['cis_shortRange_ratio']
    data[sample + '_cis_longRange_ratio'] = ratios['cis_longRange_ratio']

# 假设 data 字典已经被正确填充了比例值
# 这里我们只需要打印每个样本的计算比例
for key, value in data.items():
    # 确保 value 是一个浮点数，然后格式化输出
    if isinstance(value, float) or isinstance(value, int):
        print(f"{key}: {value:.6f}")
    else:
        print(f"{key}: {value}")
    

