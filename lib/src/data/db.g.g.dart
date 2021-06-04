import 'dart:ui';

import './db.dart';

final products = [
  Product(
    ProductCategory.slow,
    name: 'Verde digito',
    sku: 20.0,
    ref: 'N20',
    ml: '520cc/400',
    color: Color.fromRGBO(201, 229, 141, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde refrigerante',
    sku: 92.0,
    ref: 'N92',
    ml: '520cc/400',
    color: Color.fromRGBO(182, 196, 148, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde gamuso',
    sku: 93.0,
    ref: 'N93',
    ml: '520cc/400',
    color: Color.fromRGBO(169, 195, 108, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde laser',
    sku: 57.0,
    ref: 'N57',
    ml: '520cc/400',
    color: Color.fromRGBO(140, 177, 67, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde alga',
    sku: 120.0,
    ref: 'N120',
    ml: '520cc/400',
    color: Color.fromRGBO(100, 132, 98, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde selvático',
    sku: 91.0,
    ref: 'N91',
    ml: '520cc/400',
    color: Color.fromRGBO(95, 116, 94, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde alternativo',
    sku: 88.0,
    ref: 'N88',
    ml: '520cc/400',
    color: Color.fromRGBO(63, 93, 84, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde monte',
    sku: 122.0,
    ref: 'N122',
    ml: '520cc/400',
    color: Color.fromRGBO(58, 103, 84, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde roquefort',
    sku: 24.0,
    ref: 'N24',
    ml: '520cc/400',
    color: Color.fromRGBO(24, 125, 84, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde musgo',
    sku: 23.0,
    ref: 'N23',
    ml: '520cc/400',
    color: Color.fromRGBO(92, 157, 90, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Eco green',
    sku: 153.0,
    ref: 'N153',
    ml: '520cc/400',
    color: Color.fromRGBO(79, 143, 76, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde transgenico',
    sku: 121.0,
    ref: 'N121',
    ml: '520cc/400',
    color: Color.fromRGBO(64, 164, 129, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde Outdoor',
    sku: 90.0,
    ref: 'N90',
    ml: '520cc/400',
    color: Color.fromRGBO(136, 184, 138, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo esponja',
    sku: 68.0,
    ref: 'N68',
    ml: '520cc/400',
    color: Color.fromRGBO(253, 204, 141, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja fresh',
    sku: 105.0,
    ref: 'N105',
    ml: '520cc/400',
    color: Color.fromRGBO(236, 187, 134, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo necora',
    sku: 6.0,
    ref: 'N06',
    ml: '520cc/400',
    color: Color.fromRGBO(229, 172, 98, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo tóxico',
    sku: 107.0,
    ref: 'N107',
    ml: '520cc/400',
    color: Color.fromRGBO(218, 150, 55, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo desierto',
    sku: 108.0,
    ref: 'N108',
    ml: '520cc/400',
    color: Color.fromRGBO(198, 147, 80, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre cereales',
    sku: 96.0,
    ref: 'N96',
    ml: '520cc/400',
    color: Color.fromRGBO(196, 142, 56, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre terrenal',
    sku: 67.0,
    ref: 'N67',
    ml: '520cc/400',
    color: Color.fromRGBO(179, 136, 57, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre hera',
    sku: 48.0,
    ref: 'N48',
    ml: '520cc/400',
    color: Color.fromRGBO(181, 128, 63, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron toffe',
    sku: 109.0,
    ref: 'N109',
    ml: '520cc/400',
    color: Color.fromRGBO(164, 121, 67, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre cuco',
    sku: 94.0,
    ref: 'N94',
    ml: '520cc/400',
    color: Color.fromRGBO(138, 110, 68, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre verdoso',
    sku: 95.0,
    ref: 'N95',
    ml: '520cc/400',
    color: Color.fromRGBO(120, 102, 69, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre colina',
    sku: 104.0,
    ref: 'N104',
    ml: '520cc/400',
    color: Color.fromRGBO(198, 150, 105, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Ocre avena',
    sku: 64.0,
    ref: 'N64',
    ml: '520cc/400',
    color: Color.fromRGBO(200, 157, 105, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde bajo',
    sku: 113.0,
    ref: 'N113',
    ml: '520cc/400',
    color: Color.fromRGBO(225, 213, 176, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde palido',
    sku: 114.0,
    ref: 'N114',
    ml: '520cc/400',
    color: Color.fromRGBO(204, 187, 135, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde wisha',
    sku: 22.0,
    ref: 'N22',
    ml: '520cc/400',
    color: Color.fromRGBO(176, 166, 104, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde aceituna',
    sku: 115.0,
    ref: 'N115',
    ml: '520cc/400',
    color: Color.fromRGBO(143, 137, 102, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde mata',
    sku: 116.0,
    ref: 'N116',
    ml: '520cc/400',
    color: Color.fromRGBO(128, 125, 100, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde pistilo',
    sku: 65.0,
    ref: 'N65',
    ml: '520cc/400',
    color: Color.fromRGBO(168, 142, 104, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde mimetizado',
    sku: 66.0,
    ref: 'N66',
    ml: '520cc/400',
    color: Color.fromRGBO(148, 132, 103, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo nuclear',
    sku: 51.0,
    ref: 'N51',
    ml: '520cc/400',
    color: Color.fromRGBO(221, 221, 55, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo ácido',
    sku: 69.0,
    ref: 'N69',
    ml: '520cc/400',
    color: Color.fromRGBO(202, 212, 57, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde indor',
    sku: 21.0,
    ref: 'N21',
    ml: '520cc/400',
    color: Color.fromRGBO(180, 196, 79, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde residuo',
    sku: 112.0,
    ref: 'N112',
    ml: '520cc/400',
    color: Color.fromRGBO(151, 136, 63, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde espiritual',
    sku: 63.0,
    ref: 'N63',
    ml: '520cc/400',
    color: Color.fromRGBO(128, 121, 65, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde sabana',
    sku: 117.0,
    ref: 'N117',
    ml: '520cc/400',
    color: Color.fromRGBO(133, 139, 95, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde camu',
    sku: 118.0,
    ref: 'N118',
    ml: '520cc/400',
    color: Color.fromRGBO(116, 121, 93, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde militar',
    sku: 119.0,
    ref: 'N119',
    ml: '520cc/400',
    color: Color.fromRGBO(103, 108, 90, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde paciente',
    sku: 89.0,
    ref: 'N89',
    ml: '520cc/400',
    color: Color.fromRGBO(176, 209, 177, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde laguna',
    sku: 123.0,
    ref: 'N123',
    ml: '520cc/400',
    color: Color.fromRGBO(131, 204, 164, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Turquesa mediterraneo',
    sku: 77.0,
    ref: 'N77',
    ml: '520cc/400',
    color: Color.fromRGBO(74, 150, 136, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Turquesa cala',
    sku: 25.0,
    ref: 'N25',
    ml: '520cc/400',
    color: Color.fromRGBO(59, 155, 152, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul quirofano',
    sku: 150.0,
    ref: 'N150',
    ml: '520cc/400',
    color: Color.fromRGBO(76, 143, 147, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul turquesa',
    sku: 58.0,
    ref: 'N58',
    ml: '520cc/400',
    color: Color.fromRGBO(54, 98, 104, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Verde pepino',
    sku: 56.0,
    ref: 'N56',
    ml: '520cc/400',
    color: Color.fromRGBO(58, 73, 69, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Beig dermos',
    sku: 2.0,
    ref: 'N02',
    ml: '520cc/400',
    color: Color.fromRGBO(218, 205, 184, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Crema sogado',
    sku: 3.0,
    ref: 'N03',
    ml: '520cc/400',
    color: Color.fromRGBO(228, 198, 165, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron arena',
    sku: 142.0,
    ref: 'N142',
    ml: '520cc/400',
    color: Color.fromRGBO(167, 121, 102, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron caries',
    sku: 46.0,
    ref: 'N46',
    ml: '520cc/400',
    color: Color.fromRGBO(148, 111, 94, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron tejado',
    sku: 73.0,
    ref: 'N73',
    ml: '520cc/400',
    color: Color.fromRGBO(143, 86, 63, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron coco',
    sku: 162.0,
    ref: 'N162',
    ml: '520cc/400',
    color: Color.fromRGBO(130, 85, 75, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron peca',
    sku: 47.0,
    ref: 'N47',
    ml: '520cc/400',
    color: Color.fromRGBO(121, 87, 72, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron puro',
    sku: 144.0,
    ref: 'N144',
    ml: '520cc/400',
    color: Color.fromRGBO(89, 68, 66, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron barro',
    sku: 55.0,
    ref: 'N55',
    ml: '520cc/400',
    color: Color.fromRGBO(92, 77, 71, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron bombón',
    sku: 97.0,
    ref: 'N97',
    ml: '520cc/400',
    color: Color.fromRGBO(80, 73, 69, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron roca',
    sku: 145.0,
    ref: 'N145',
    ml: '520cc/400',
    color: Color.fromRGBO(126, 109, 104, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron roña',
    sku: 44.0,
    ref: 'N44',
    ml: '520cc/400',
    color: Color.fromRGBO(136, 113, 100, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron haya',
    sku: 143.0,
    ref: 'N143',
    ml: '520cc/400',
    color: Color.fromRGBO(172, 141, 129, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron duna',
    sku: 157.0,
    ref: 'N157',
    ml: '520cc/400',
    color: Color.fromRGBO(199, 157, 136, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Brown box',
    sku: 160.0,
    ref: 'N160',
    ml: '520cc/400',
    color: Color.fromRGBO(199, 168, 149, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron dieta',
    sku: 159.0,
    ref: 'N159',
    ml: '520cc/400',
    color: Color.fromRGBO(213, 195, 174, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Brown camel',
    sku: 161.0,
    ref: 'N161',
    ml: '520cc/400',
    color: Color.fromRGBO(177, 134, 110, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron combi',
    sku: 158.0,
    ref: 'N158',
    ml: '520cc/400',
    color: Color.fromRGBO(169, 118, 92, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron arcilla',
    sku: 141.0,
    ref: 'N141',
    ml: '520cc/400',
    color: Color.fromRGBO(197, 131, 102, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta funki',
    sku: 34.0,
    ref: 'N34',
    ml: '520cc/400',
    color: Color.fromRGBO(195, 183, 202, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta chuche',
    sku: 129.0,
    ref: 'N129',
    ml: '520cc/400',
    color: Color.fromRGBO(184, 172, 198, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta jipi',
    sku: 35.0,
    ref: 'N35',
    ml: '520cc/400',
    color: Color.fromRGBO(160, 148, 179, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta vaticano',
    sku: 130.0,
    ref: 'N130',
    ml: '520cc/400',
    color: Color.fromRGBO(153, 129, 163, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta hematoma',
    sku: 37.0,
    ref: 'N37',
    ml: '520cc/400',
    color: Color.fromRGBO(113, 94, 133, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta paramecia',
    sku: 83.0,
    ref: 'N83',
    ml: '520cc/400',
    color: Color.fromRGBO(100, 79, 125, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta amatis',
    sku: 38.0,
    ref: 'N38',
    ml: '520cc/400',
    color: Color.fromRGBO(81, 67, 91, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta joker',
    sku: 131.0,
    ref: 'N131',
    ml: '520cc/400',
    color: Color.fromRGBO(116, 98, 125, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta varices',
    sku: 36.0,
    ref: 'N36',
    ml: '520cc/400',
    color: Color.fromRGBO(134, 108, 146, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta ahumado',
    sku: 132.0,
    ref: 'N132',
    ml: '520cc/400',
    color: Color.fromRGBO(170, 139, 153, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo caña',
    sku: 17.0,
    ref: 'N17',
    ml: '520cc/400',
    color: Color.fromRGBO(137, 91, 92, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Crema dromeda',
    sku: 4.0,
    ref: 'N04',
    ml: '520cc/400',
    color: Color.fromRGBO(252, 209, 172, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja pastel',
    sku: 140.0,
    ref: 'N140',
    ml: '520cc/400',
    color: Color.fromRGBO(254, 171, 137, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja crin',
    sku: 71.0,
    ref: 'N71',
    ml: '520cc/400',
    color: Color.fromRGBO(255, 160, 128, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja sirope',
    sku: 70.0,
    ref: 'N70',
    ml: '520cc/400',
    color: Color.fromRGBO(245, 133, 85, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja sin',
    sku: 9.0,
    ref: 'N09',
    ml: '520cc/400',
    color: Color.fromRGBO(242, 110, 52, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja con',
    sku: 10.0,
    ref: 'N10',
    ml: '520cc/400',
    color: Color.fromRGBO(226, 93, 52, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja oxidado',
    sku: 72.0,
    ref: 'N72',
    ml: '520cc/400',
    color: Color.fromRGBO(180, 89, 60, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja gazpacho',
    sku: 52.0,
    ref: 'N52',
    ml: '520cc/400',
    color: Color.fromRGBO(231, 121, 102, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja eclipsado',
    sku: 7.0,
    ref: 'N07',
    ml: '520cc/400',
    color: Color.fromRGBO(216, 134, 100, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja salpicon',
    sku: 74.0,
    ref: 'N74',
    ml: '520cc/400',
    color: Color.fromRGBO(246, 189, 167, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris humo',
    sku: 40.0,
    ref: 'N40',
    ml: '520cc/400',
    color: Color.fromRGBO(193, 196, 195, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris alẽrgico',
    sku: 41.0,
    ref: 'N41',
    ml: '520cc/400',
    color: Color.fromRGBO(154, 158, 159, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris menhir',
    sku: 42.0,
    ref: 'N42',
    ml: '520cc/400',
    color: Color.fromRGBO(105, 110, 115, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris magnum',
    sku: 60.0,
    ref: 'N60',
    ml: '520cc/400',
    color: Color.fromRGBO(83, 85, 89, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris delfin',
    sku: 148.0,
    ref: 'N148',
    ml: '520cc/400',
    color: Color.fromRGBO(102, 99, 106, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris baday',
    sku: 43.0,
    ref: 'N43',
    ml: '520cc/400',
    color: Color.fromRGBO(104, 97, 105, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris roble',
    sku: 146.0,
    ref: 'N146',
    ml: '520cc/400',
    color: Color.fromRGBO(121, 108, 104, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris distante',
    sku: 100.0,
    ref: 'N100',
    ml: '520cc/400',
    color: Color.fromRGBO(138, 133, 141, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris luna',
    sku: 147.0,
    ref: 'N147',
    ml: '520cc/400',
    color: Color.fromRGBO(175, 170, 177, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris llanta',
    sku: 103.0,
    ref: 'N103',
    ml: '520cc/400',
    color: Color.fromRGBO(136, 136, 133, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris nublado',
    sku: 102.0,
    ref: 'N102',
    ml: '520cc/400',
    color: Color.fromRGBO(158, 154, 147, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Gris nivel',
    sku: 101.0,
    ref: 'N101',
    ml: '520cc/400',
    color: Color.fromRGBO(193, 179, 161, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo frambuesa',
    sku: 75.0,
    ref: 'N75',
    ml: '520cc/400',
    color: Color.fromRGBO(194, 86, 105, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo distante',
    sku: 79.0,
    ref: 'N79',
    ml: '520cc/400',
    color: Color.fromRGBO(160, 91, 104, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo congestionado',
    sku: 80.0,
    ref: 'N80',
    ml: '520cc/400',
    color: Color.fromRGBO(135, 76, 82, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo costra',
    sku: 18.0,
    ref: 'N18',
    ml: '520cc/400',
    color: Color.fromRGBO(112, 69, 68, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo otoño',
    sku: 138.0,
    ref: 'N138',
    ml: '520cc/400',
    color: Color.fromRGBO(114, 65, 66, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo vino',
    sku: 139.0,
    ref: 'N139',
    ml: '520cc/400',
    color: Color.fromRGBO(104, 66, 66, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo torelis',
    sku: 19.0,
    ref: 'N19',
    ml: '520cc/400',
    color: Color.fromRGBO(90, 71, 72, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo calimocho',
    sku: 15.0,
    ref: 'N15',
    ml: '520cc/400',
    color: Color.fromRGBO(142, 54, 59, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo coagulo',
    sku: 16.0,
    ref: 'N16',
    ml: '520cc/400',
    color: Color.fromRGBO(163, 61, 66, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo puro',
    sku: 152.0,
    ref: 'N152',
    ml: '520cc/400',
    color: Color.fromRGBO(178, 53, 58, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rojo capicua',
    sku: 76.0,
    ref: 'N76',
    ml: '520cc/400',
    color: Color.fromRGBO(176, 65, 84, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul celestial',
    sku: 126.0,
    ref: 'N126',
    ml: '520cc/400',
    color: Color.fromRGBO(129, 201, 219, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul trade',
    sku: 27.0,
    ref: 'N27',
    ml: '520cc/400',
    color: Color.fromRGBO(92, 183, 220, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul oceano',
    sku: 127.0,
    ref: 'N127',
    ml: '520cc/400',
    color: Color.fromRGBO(96, 160, 182, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul pitufo',
    sku: 29.0,
    ref: 'N29',
    ml: '520cc/400',
    color: Color.fromRGBO(3, 150, 198, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul osmosis',
    sku: 28.0,
    ref: 'N28',
    ml: '520cc/400',
    color: Color.fromRGBO(66, 144, 187, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Just blue',
    sku: 151.0,
    ref: 'N151',
    ml: '520cc/400',
    color: Color.fromRGBO(23, 103, 153, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul electro',
    sku: 59.0,
    ref: 'N59',
    ml: '520cc/400',
    color: Color.fromRGBO(56, 72, 100, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul tatu',
    sku: 31.0,
    ref: 'N31',
    ml: '520cc/400',
    color: Color.fromRGBO(79, 89, 120, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul Yin',
    sku: 32.0,
    ref: 'N32',
    ml: '520cc/400',
    color: Color.fromRGBO(91, 120, 157, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul ozono',
    sku: 33.0,
    ref: 'N33',
    ml: '520cc/400',
    color: Color.fromRGBO(100, 155, 198, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul bebe',
    sku: 128.0,
    ref: 'N128',
    ml: '520cc/400',
    color: Color.fromRGBO(130, 181, 214, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul relax',
    sku: 149.0,
    ref: 'N149',
    ml: '520cc/400',
    color: Color.fromRGBO(168, 202, 201, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul refrigerante',
    sku: 26.0,
    ref: 'N26',
    ml: '520cc/400',
    color: Color.fromRGBO(169, 219, 219, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul cristalino',
    sku: 124.0,
    ref: 'N124',
    ml: '520cc/400',
    color: Color.fromRGBO(144, 206, 204, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul medusa',
    sku: 125.0,
    ref: 'N125',
    ml: '520cc/400',
    color: Color.fromRGBO(95, 177, 176, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul marea',
    sku: 87.0,
    ref: 'N87',
    ml: '520cc/400',
    color: Color.fromRGBO(67, 120, 139, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Turquesa hondo',
    sku: 30.0,
    ref: 'N30',
    ml: '520cc/400',
    color: Color.fromRGBO(53, 85, 105, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Turquesa poderoso',
    sku: 84.0,
    ref: 'N84',
    ml: '520cc/400',
    color: Color.fromRGBO(64, 75, 83, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul pirata',
    sku: 86.0,
    ref: 'N86',
    ml: '520cc/400',
    color: Color.fromRGBO(104, 128, 137, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Azul plástico',
    sku: 85.0,
    ref: 'N85',
    ml: '520cc/400',
    color: Color.fromRGBO(107, 153, 168, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa cerdito',
    sku: 12.0,
    ref: 'N12',
    ml: '520cc/400',
    color: Color.fromRGBO(219, 172, 171, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa placenta',
    sku: 13.0,
    ref: 'N13',
    ml: '520cc/400',
    color: Color.fromRGBO(189, 127, 143, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa deformación',
    sku: 135.0,
    ref: 'N135',
    ml: '520cc/400',
    color: Color.fromRGBO(166, 122, 125, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa ahumado',
    sku: 78.0,
    ref: 'N78',
    ml: '520cc/400',
    color: Color.fromRGBO(178, 108, 124, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta berenjena',
    sku: 133.0,
    ref: 'N133',
    ml: '520cc/400',
    color: Color.fromRGBO(127, 97, 110, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta apagado',
    sku: 134.0,
    ref: 'N134',
    ml: '520cc/400',
    color: Color.fromRGBO(82, 71, 74, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Lila comodín',
    sku: 81.0,
    ref: 'N81',
    ml: '520cc/400',
    color: Color.fromRGBO(127, 110, 115, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa pate',
    sku: 14.0,
    ref: 'N14',
    ml: '520cc/400',
    color: Color.fromRGBO(151, 125, 133, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Piel con',
    sku: 99.0,
    ref: 'N99',
    ml: '520cc/400',
    color: Color.fromRGBO(163, 144, 140, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Piel sin',
    sku: 98.0,
    ref: 'N98',
    ml: '520cc/400',
    color: Color.fromRGBO(195, 178, 175, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa tiquis',
    sku: 11.0,
    ref: 'N11',
    ml: '520cc/400',
    color: Color.fromRGBO(235, 189, 199, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Rosa colorete',
    sku: 136.0,
    ref: 'N136',
    ml: '520cc/400',
    color: Color.fromRGBO(221, 139, 160, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Magenta claro',
    sku: 53.0,
    ref: 'N53',
    ml: '520cc/400',
    color: Color.fromRGBO(205, 129, 170, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Magenta ',
    sku: 39.0,
    ref: 'N39',
    ml: '520cc/400',
    color: Color.fromRGBO(186, 91, 132, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Magenta afilado',
    sku: 154.0,
    ref: 'N154',
    ml: '520cc/400',
    color: Color.fromRGBO(190, 90, 130, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Reina purpura',
    sku: 156.0,
    ref: 'N156',
    ml: '520cc/400',
    color: Color.fromRGBO(155, 73, 128, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Purpura pocion',
    sku: 54.0,
    ref: 'N54',
    ml: '520cc/400',
    color: Color.fromRGBO(137, 72, 108, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Violeta fiesta',
    sku: 137.0,
    ref: 'N137',
    ml: '520cc/400',
    color: Color.fromRGBO(122, 78, 107, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Purpura lacado',
    sku: 82.0,
    ref: 'N82',
    ml: '520cc/400',
    color: Color.fromRGBO(110, 76, 102, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo paseo',
    sku: 61.0,
    ref: 'N61',
    ml: '520cc/400',
    color: Color.fromRGBO(244, 217, 148, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo danger',
    sku: 110.0,
    ref: 'N110',
    ml: '520cc/400',
    color: Color.fromRGBO(238, 197, 92, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo capa',
    sku: 155.0,
    ref: 'N155',
    ml: '520cc/400',
    color: Color.fromRGBO(237, 189, 17, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo peseta',
    sku: 5.0,
    ref: 'N05',
    ml: '520cc/400',
    color: Color.fromRGBO(226, 180, 27, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo mustard',
    sku: 111.0,
    ref: 'N111',
    ml: '520cc/400',
    color: Color.fromRGBO(202, 167, 47, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo gastado',
    sku: 62.0,
    ref: 'N62',
    ml: '520cc/400',
    color: Color.fromRGBO(188, 160, 49, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Marron tochano',
    sku: 45.0,
    ref: 'N45',
    ml: '520cc/400',
    color: Color.fromRGBO(160, 108, 65, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Amarillo fetido',
    sku: 8.0,
    ref: 'N08',
    ml: '520cc/400',
    color: Color.fromRGBO(247, 158, 36, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Naranja meloco',
    sku: 106.0,
    ref: 'N106',
    ml: '520cc/400',
    color: Color.fromRGBO(255, 180, 91, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Blanco',
    sku: 1.0,
    ref: 'N01',
    ml: '520cc/400',
    color: Color.fromRGBO(240, 239, 231, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Blanco Translucido',
    sku: 501.0,
    ref: 'N501',
    ml: '520/400',
    color: Color.fromRGBO(238, 239, 226, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Negro',
    sku: 50.0,
    ref: 'N50',
    ml: '520cc/400',
    color: Color.fromRGBO(55, 55, 56, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Negro Translucido',
    sku: 502.0,
    ref: 'N502',
    ml: '520/400',
    color: Color.fromRGBO(86, 83, 78, 1.0),
  ),
  Product(
    ProductCategory.slow,
    name: 'Plata',
    sku: 49.0,
    ref: 'N49',
    ml: '520cc/400',
    color: Color.fromRGBO(213, 215, 218, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Oro',
    sku: 702.0,
    ref: 'F02',
    ml: '520/400',
    color: Color.fromRGBO(213, 192, 126, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Blanco ',
    sku: 704.0,
    ref: 'F04',
    ml: '520/400',
    color: Color.fromRGBO(240, 239, 231, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Violeta ',
    sku: 705.0,
    ref: 'F05',
    ml: '520/400',
    color: Color.fromRGBO(100, 79, 125, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Amarillo',
    sku: 706.0,
    ref: 'F06',
    ml: '520/400',
    color: Color.fromRGBO(238, 197, 92, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Azul ',
    sku: 707.0,
    ref: 'F07',
    ml: '520/400',
    color: Color.fromRGBO(95, 177, 176, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Verde',
    sku: 708.0,
    ref: 'F08',
    ml: '520/400',
    color: Color.fromRGBO(24, 125, 84, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Rojo',
    sku: 709.0,
    ref: 'F09',
    ml: '520/400',
    color: Color.fromRGBO(163, 61, 66, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Plata',
    sku: 710.0,
    ref: 'F10',
    ml: '520/400',
    color: Color.fromRGBO(213, 215, 218, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Negro',
    sku: 711.0,
    ref: 'F11',
    ml: '520/400',
    color: Color.fromRGBO(55, 55, 56, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Rojo',
    sku: 712.0,
    ref: 'F12',
    ml: '520/400',
    color: Color.fromRGBO(255, 115, 119, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Cereza',
    sku: 713.0,
    ref: 'F13',
    ml: '520/400',
    color: Color.fromRGBO(255, 65, 180, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Naranja',
    sku: 714.0,
    ref: 'F14',
    ml: '520/400',
    color: Color.fromRGBO(255, 144, 109, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Amarillo',
    sku: 715.0,
    ref: 'F15',
    ml: '520/400',
    color: Color.fromRGBO(227, 232, 42, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Verde',
    sku: 716.0,
    ref: 'F16',
    ml: '520/400',
    color: Color.fromRGBO(56, 23, 48, 1.0),
  ),
  Product(
    ProductCategory.fast,
    name: 'Azul',
    sku: 717.0,
    ref: 'F17',
    ml: '520/400',
    color: Color.fromRGBO(0, 131, 203, 1.0),
  ),
  Product(
    ProductCategory.pro,
    name: 'Plata',
    sku: 601.0,
    ref: 'P01',
    ml: '1000/750',
    color: Color.fromRGBO(213, 215, 218, 1.0),
  ),
  Product(
    ProductCategory.pro,
    name: 'Negro',
    sku: 603.0,
    ref: 'P03',
    ml: '1000/750',
    color: Color.fromRGBO(55, 55, 56, 1.0),
  ),
  Product(
    ProductCategory.pro,
    name: 'Blanco',
    sku: 617.0,
    ref: 'P17',
    ml: '1000/750',
    color: Color.fromRGBO(255, 255, 255, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'White cargo',
    sku: null,
    ref: 'W001',
    ml: 'WTF',
    color: Color.fromRGBO(240, 239, 231, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Grey bullet',
    sku: null,
    ref: 'W002',
    ml: '520/400',
    color: Color.fromRGBO(132, 143, 149, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Black swan',
    sku: null,
    ref: 'W003',
    ml: '520/400',
    color: Color.fromRGBO(58, 58, 59, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Citric yellow',
    sku: null,
    ref: 'W004',
    ml: '520/400',
    color: Color.fromRGBO(221, 218, 61, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Melon yellow',
    sku: null,
    ref: 'W005',
    ml: '520/400',
    color: Color.fromRGBO(254, 160, 0, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Pink powder',
    sku: null,
    ref: 'W006',
    ml: '520/400',
    color: Color.fromRGBO(231, 184, 187, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Antique fuchsia',
    sku: null,
    ref: 'W007',
    ml: '520/400',
    color: Color.fromRGBO(198, 105, 147, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Purple music',
    sku: null,
    ref: 'W008',
    ml: '520/400',
    color: Color.fromRGBO(141, 70, 100, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Clean violet',
    sku: null,
    ref: 'W009',
    ml: '520/400',
    color: Color.fromRGBO(163, 149, 203, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Chakra violet',
    sku: null,
    ref: 'W010',
    ml: '520/400',
    color: Color.fromRGBO(103, 82, 151, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Tangerine red',
    sku: null,
    ref: 'W011',
    ml: '520/400',
    color: Color.fromRGBO(207, 78, 76, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Red cherry',
    sku: null,
    ref: 'W012',
    ml: '520/400',
    color: Color.fromRGBO(176, 64, 78, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Green algae',
    sku: null,
    ref: 'W013',
    ml: '520/400',
    color: Color.fromRGBO(0, 121, 77, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Green army',
    sku: null,
    ref: 'W014',
    ml: '520/400',
    color: Color.fromRGBO(112, 132, 100, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Dark green',
    sku: null,
    ref: 'W015',
    ml: '520/400',
    color: Color.fromRGBO(59, 68, 64, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Green clover',
    sku: null,
    ref: 'W016',
    ml: '520/400',
    color: Color.fromRGBO(96, 159, 71, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Turquoise',
    sku: null,
    ref: 'W017',
    ml: '520/400',
    color: Color.fromRGBO(54, 145, 146, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Dirty blue',
    sku: null,
    ref: 'W018',
    ml: '520/400',
    color: Color.fromRGBO(95, 192, 202, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Dawn blue',
    sku: null,
    ref: 'W019',
    ml: '520/400',
    color: Color.fromRGBO(65, 176, 208, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Mechanical blue',
    sku: null,
    ref: 'W020',
    ml: '520/400',
    color: Color.fromRGBO(19, 101, 147, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Black swan',
    sku: null,
    ref: 'W203',
    ml: '800/600',
    color: Color.fromRGBO(58, 58, 59, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Citric yellow',
    sku: null,
    ref: 'W204',
    ml: '800/600',
    color: Color.fromRGBO(221, 218, 61, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Clean violet',
    sku: null,
    ref: 'W209',
    ml: '800/600',
    color: Color.fromRGBO(163, 149, 203, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Red cherry',
    sku: null,
    ref: 'W212',
    ml: '800/600',
    color: Color.fromRGBO(176, 64, 78, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Green army',
    sku: null,
    ref: 'W214',
    ml: '800/600',
    color: Color.fromRGBO(112, 132, 100, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Dwan blue',
    sku: null,
    ref: 'W219',
    ml: '800/600',
    color: Color.fromRGBO(65, 176, 208, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Matt varnish',
    sku: null,
    ref: 'W021',
    ml: '520/400',
    color: Color.fromRGBO(255, 255, 255, 1.0),
  ),
  Product(
    ProductCategory.wtf,
    name: 'Gloss varnish',
    sku: null,
    ref: 'W022',
    ml: '520/400',
    color: Color.fromRGBO(255, 255, 255, 1.0),
  ),
];