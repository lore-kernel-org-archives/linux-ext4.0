Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793363345;
	b=gdz2AlHl0fW289rue1kS8GYo5yuK1GE3qzPMjE8A4yCxkiCgPQm+LU/czh5ie66zJpuk
	 0QMw8KF7euI4/2VvpbRRZ1Q2/bWSygvpURLEZ7a5hfZL1+kii3McHRTc6a3BNcd8aT2HJ
	 4jSPrgetdiGaew0eaCci5oOnmyaI+fY6lEr5we9j+NzlZU+0kcBUbO39s9AwDJlZaPJcg
	 mR9ercfaVyuTMxRYMdecJQCnkSCTUs1tReWpFlXxPldGnxx1dg/5VaBAoic89Y9ovWonD
	 hMxhwrAgW9aZmu6nJ3hOSHCzmCkbuX2bgvoZarVUvSuN5rdapWaFcX9GiuXyfQ6sB4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793363345;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=tzyoj7lfIve0odxM7Uw/YmgpqguBW6hT3irm7CGn2YY=;
	b=OzNbD6xa0mD01t0ohctMZexqEEuH6Dq8eZc6RUbWSgRmO/LKm576i14tP341XncKKj5s
	 TiXkxNj49HAwZ9pzmKcxfFjyBO2bCfq4yKNX8j4IGhlIKnBCmAOMpvE8e4e0S7v9g3eIC
	 HaHYIR7zDdP2CuWCTLYbcAaSI1NyUbZOzgu5z+M9yvgbGsFbMl0Iz4qYfS7iUvcXVCz4y
	 cFRT4FoMbqmjYN7NuS1+U1iYnHlWOh+Dw+PAIgcWxkiQqZ0MhSnjrGooG6LHvNUxCZOn8
	 0GFlKbaxyvEkxf/smD5cF49Im+tGr0StrbeI4324q88dZ45i1ObsaLfdnDwcUqvvxjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=anton-paar.com;
	spf=pass smtp.mailfrom=anton-paar.com;
	dkim=pass header.d=anton-paar.com header.i=@anton-paar.com header.a=rsa-sha256 header.s=selector1 header.b=GNSpC8tL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.83
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020083.outbound.protection.outlook.com [52.101.84.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0940D606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 12:29:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0940D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=anton-paar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anton-paar.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=anton-paar.com header.i=@anton-paar.com header.a=rsa-sha256 header.s=selector1 header.b=GNSpC8tL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWN2MlXtQQh/rJ/4Y1vPYZgXFR183bmSi94g0eJ36L1Ekq7zicAmpHvh4An1rhXb46F3QqOtEocQig6SDRxp/6FxT13ERIXJdmpEGmaP3QJO1Qy7mStW6Y4lEozDxmfrRg28VjneHRLFCDyrIHMldfXP3opHUdBMjcgNFxCghct+z7gWWLX7hU5Q1Y1hjaJrTHA36pTJnbimmvFh5Dgp3XHnQO+Uz3aUQGyjOXZks5kiQQu9HG29hXcWOVThutymQ+A6qRzUG8AT77Gi9j+PPJ+RFGm0hzEXXeFhEB9VyUt139G1lmx4pZ9G9eRh0BnvZo2dYAwhbKmePA3vi+w+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzyoj7lfIve0odxM7Uw/YmgpqguBW6hT3irm7CGn2YY=;
 b=lgMbTxLqr2GmFyayDZW9+QyUnUMmdH1J/Ynfb8E1D0KLMCx9oWo1D7ALYP5/WooC/RrudW9Cqzx4rF7ZtTkxdN1rdZS3Xe15lEvJjRPvfdsOOzkowk0D+HXVaHAG/ciUXyasl3TjTnEZwvq6SCnyi1lLl/g/maM82WTegEd1cffmznxB3bBtvjPdROlXzEBJj0eBiTbmqoqJStawluE8o9+m27GtdXQdHUeh5ocYjt1wSI1XF/k7dv6JXAmYpK/pYgHtTqaxtAS0SNT4rjQ+86F3zKDEXLR5V4P7QKivlghtwVb6xXxPxhJ0qaZearvzCSpQepTsuZwB+hKP3jWRug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=anton-paar.com; dmarc=pass action=none
 header.from=anton-paar.com; dkim=pass header.d=anton-paar.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anton-paar.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzyoj7lfIve0odxM7Uw/YmgpqguBW6hT3irm7CGn2YY=;
 b=GNSpC8tLDf0EP8RcjHLXFYBSymcWpaV5kqCC2fa8deiIC9zUabtsHopGYbL0vSKLELD+XsLk8VOYM6W/Odtoqd895sy3AC1kb7Z/VUQ3mVIPV7/TsW1P8LwGiSXSPUYeu8DzpyypJI+KhAnoNuJ1FgDWzqZbDcneLsCo1EuWroyae0wm1Lsfqqge2zTIq/Q6ms3Vdiv4YDhdxmUzmUXq0V/YQnqOlvJe38yRjF+71TPIEfw5gslLVl1pkInpFKI+tf3WVJ6sbzlEALiY6h/Qj9dDmQBBdj8T4Q6KqYRpjUleXr7ZAKhxl68knQ3twL6R+235J0x3DEPqH+p9S2C7mQ==
Received: from VE1PR03MB5725.eurprd03.prod.outlook.com (2603:10a6:803:123::33)
 by MI9PR03MB911530.eurprd03.prod.outlook.com (2603:10a6:290:b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 12:28:59 +0000
Received: from VE1PR03MB5725.eurprd03.prod.outlook.com
 ([fe80::2971:ebfb:bb79:cc65]) by VE1PR03MB5725.eurprd03.prod.outlook.com
 ([fe80::2971:ebfb:bb79:cc65%3]) with mapi id 15.21.0546.021; Fri, 30 Oct 2026
 12:28:59 +0000
From: "Korber, Markus" <markus.korber@anton-paar.com>
To: Zhang Yi <yizhang089@gmail.com>, Andreas Dilger <adilger@dilger.ca>
CC: Theodore Tso <tytso@mit.edu>, Gabriele Moabiti <gabmoa@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: AW: ext4 data=journal deprecation: long-standing industrial use case
Thread-Topic: ext4 data=journal deprecation: long-standing industrial use case
Thread-Index:
 AQJe7lEtanpk7txC6V2h/QI8XBITzwFQhtZstfbrjkCAAR5+gIAAJspggARmvICAACQMAIALt7gQ
Date: Fri, 30 Oct 2026 12:28:59 +0000
Message-ID:
 <VE1PR03MB572567B1A74FD7DA9FC6BB59DE6D2@VE1PR03MB5725.eurprd03.prod.outlook.com>
References:
 <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
 <AM0PR03MB57141FD8462BD0C6D075863DDE672@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <8B27CFE7-E4AD-4679-B772-6473C3849964@dilger.ca>
 <3e774e32-fa5c-43ad-bc2a-c6d29f7ec7df@gmail.com>
In-Reply-To: <3e774e32-fa5c-43ad-bc2a-c6d29f7ec7df@gmail.com>
Accept-Language: de-AT, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=anton-paar.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR03MB5725:EE_|MI9PR03MB911530:EE_
x-ms-office365-filtering-correlation-id: 183922de-992a-4c4a-06fa-08df36815fd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|22082099003|18002099003|38070700021|56012099006|4143699003|261026140227099003|261026121527099003|261028144727099003|261021123027099003|261022075727099003|261022105027099003|261009223027099003;
x-microsoft-antispam-message-info:
 jqV8cuxIYSBxeZs2lFJ1ZIw4KFVvwIMG1zdDWwcMs3pqVNjut5GAIxPapmB65OxnBHkTsb4w+HTZeSNdSvnczmcLCna9tCsnkS9I8AwUTpG+P5yYpX7dVCoAXcoePef1wNUusNHmQSkDAShRUS/K62rMnvLjPxPa2+/DVu6i9WE/3TwhNAPpbSxKAqyOf8ENNuXXI9eSzRzpSO6zmIYoRKLN7J1tZmSvQkqcR+ovtx+GJQP6eTh8CTGPC8PQtXZ18+2J4FhciOiyahdq7rQmQo4sUQ16KjPMWN14jIGKM2hsFUThytrmz0Pr4Ea2Rr9d6s/9c4x0SFUEBG0maZslYXjR9PEV7lzRXlhXIX6IDz6He8oyT1QK6j3MwvJ9Y3xiT/YGtNMwFKqzlv4T9pwvBFD77ObF375K0+QQEvT4ACCjibSDJaXZiYQwQEHGdZ+vP1t6lLK0IigwKG8OXkTU0YiVisLrgOCs4qEfiME35ItBKOVoHu0MssyPd/Y4WZb1m829ibYvc9oMks/x20TjW7SWSpXlYXfRZJH8jrhZUGcm0qfaC2/FuGcXAtWJGimYQRTVfMrgznNWj+MbqHviFCDoKe86rcKydEpHOJIUkeOQzHiwAM8kS56wd1ftOw3KcvWhEnVMAZ0xnS4n2V02SGqDc2UhSxtxVXV81ZgnfXHSaBGe4OD6l2+yJ2/1SzhPhcr6mcP0r0In5QpI17nhLW1YhOXXCnQY/xajOslG7UY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR03MB5725.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(38070700021)(56012099006)(4143699003)(261026140227099003)(261026121527099003)(261028144727099003)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NFhkaVZCVW1kQjBMVFIwL0x3Sk5Ra3Q1K0o5emtCQzFROXRvMzI3dWVPZDd2?=
 =?utf-8?B?aTh2SXhqeXhmaXdhOU5XendiQmkvNTY5aXBWSXhKMHQ0OUtRTmlOY2lpWHV0?=
 =?utf-8?B?M0NFeHNZUjFxNU1IejhPL1lNMU5GczlCdTVWRk4zZ085dWhOTGVrZzA3WnJw?=
 =?utf-8?B?YktYRkNsVFE5cWppYVh6ZTZxVFdoMVU1YzdWUU5LbkdUUWJKTytIWEhwZVdp?=
 =?utf-8?B?MzJPelFYaFJ1WGpobE1JUjRSbkNPOUpHZXd2MnJER2ovQUg3Z3V3cE4xV1VU?=
 =?utf-8?B?MmlWNUNnVEZyQ3l4NlJsM1RVejNwbzE2dTduMWh4T2M2aWhZQzhjd3plQU9Z?=
 =?utf-8?B?RGpsQTdFdmxxbThmOHZldS9LL1FRSUloVXlRaXF5MEpadmUvaUxrQzhLUzRG?=
 =?utf-8?B?Z3ZCWGJiM3NlQkdoalRDVEVDZ3RHd3pQblpKS2p1R0ZFWlcxQ0I0YytCY3hV?=
 =?utf-8?B?Zkg4NTBCMHZWMnRWeGpkeHlwYkdyMTNJbk82RkJHSVBIMFkxMTE1dTdXU05C?=
 =?utf-8?B?MDBxVUpYc2pLdk52QWQ4Y0hoVjJ2QzJ2cmZnVnlwUnlYZTB0Y3ZvRFQwQmR0?=
 =?utf-8?B?UlE1TE44TStxTzRlSXc4ZFhuYVg2YktHZWh5M2phcnZ5YzhpcCtBV2N4cmJn?=
 =?utf-8?B?L3lnRk9oT01iN0JLcWxNb2pWTVJDYjdYY3kyNGE4WUw2WEY0R2d2RjAvTDhR?=
 =?utf-8?B?aGozSGgxY3M1QkZoRk9YUHhGaDhHeDE5RnZMRmpUMkRrN3gzR2lDU1ZaWEVK?=
 =?utf-8?B?RWNvdWtobzVaVG5RUnBiZWY2YUlEUnRWa0E3RXhXL3BhOS9Sa01HNkFDS0to?=
 =?utf-8?B?WHJPcDhoS245dHBBS1FQNS9KbjZiR2hkK1V4NE9OL25WOGdBWkYxdDMxd2E2?=
 =?utf-8?B?aGh4WG1BM0ExMTBBU0ZFYlZsNDBwc0cwSUxaTkxkVnc5bHptNDdGSFdyTE9Y?=
 =?utf-8?B?WVNCcVo2WmpPZU9sTTRKbkdWZTAzMkVSeGJDb2o3VTNISTZUOTB0Y2gwdWc1?=
 =?utf-8?B?NXpQR0JtWEovcUdGYWVQZXpvcVlHWjhwajZ5eEI1TU5LY3hlaXdRUjJyRmxw?=
 =?utf-8?B?c1o0SVVrbGh6MmRVUjdqRENpRnJQbG8xMkNDS0hIaXhCcHBkNENJelJQc3lB?=
 =?utf-8?B?K2RuYzd4N01MOWEreHhadXJNTkNCSWZ0d0ZZZ0QvTk5rWmdkekxOcXZFazdq?=
 =?utf-8?B?OUZiVjBmSm02YW9vNkNHL1VUSWt1ZlpRTXJxcXUvcUFuNjYyNm1EZVduSzQ0?=
 =?utf-8?B?UkFhUGYrdXNBUzI2b2FDdjZYL0NGUGxSU1BscUo3WWJwUXNWbGJrM215YlFq?=
 =?utf-8?B?ZUdjMEhpdE5VM28xVmdFSVl4YU8yTys3QlZva2lUV1BJenlzajlNMjA3S0hB?=
 =?utf-8?B?ZUJnS3phQ2RTbWpGU3hQdGlMUDBxcjNyWFBmbkRJTXcwMXc3TFdZTldrc2k1?=
 =?utf-8?B?L001MVJFeFVlQy9scUU5Z0xIV3UzSFVMbC8vaUtUYXQwR1RObGVmTXpVWksw?=
 =?utf-8?B?L0gwcTlUbXdIWXhlSklZaVJQUGREZktncUJjbzh1UEFheEc4OWcrTjF6N0Z4?=
 =?utf-8?B?eFRHMXBQSEFyRit5Q3pIYlpRWFk2ZVdRcEpkY1F4STZnMmd0MStFTWp1QWFs?=
 =?utf-8?B?b21MLy9odTR2UmxsbUNFYjUvWGVlNXFzWUpFR0Q0cVBoUk5BRW5hL3czdndz?=
 =?utf-8?B?NGtQUk8waS9SSm03THdyc0FDM0szQ1hKT1B5dEJYR2lCaGJvSG5oQllkSzBp?=
 =?utf-8?B?bXErTHoyV0hhcFJhd0xiWVBZRVlOcmt5WTNxYlZHdE5kUXFEY2YxUGRNLzBz?=
 =?utf-8?B?dE9XWmd3WDBSODMyWThKTm01Z1VlVUluYXphQ1NmR0RZNGR5MGYzVjJpQ0pC?=
 =?utf-8?B?QVRaajdaYWNuNDVYelhNY216TUVaSXZUVDU4RndnVUJjeVMzT24xNWFuV1Vw?=
 =?utf-8?B?U2UxS0lIVWNQa0haRkgrODI3M1BRSFhPL0RralVqbnE5MGRGLzY4SEFoY1F6?=
 =?utf-8?B?YncwQWl2bW9qUVlkdFZKbW5ra0dnR3BRUWgvWWVMMEtXaGxnVjlINk5XV3pP?=
 =?utf-8?B?eHczVXA3aVlpWHlVWkNYMmdCZmRIZXBOQlNuRmQ1RlF4VTUwM2ZWOXh4cEh6?=
 =?utf-8?B?Uy9RTlExbExGZ2IxSERZOGhSSEpjeUJqUkRtcUJnRkRiUXB3R2Vac3VTbVNT?=
 =?utf-8?B?MDJFUnFtY0NjMGNzaGNJWnlOVGU0Q2hMMndCRWlvbEtVWnRBUHJYVCtTaDc0?=
 =?utf-8?B?YVNyd0ZaQlA3OHpEZi93TFE3VDNGbGNWRm1mR1E2aVo5UGhmQTdxTVZxenAy?=
 =?utf-8?B?WE15Y0pQY29tNkxheklKUXFXOWQwanNVYjU0K3NsZmErZTYrTTlWZnJ2SkNM?=
 =?utf-8?Q?6KkV4vxK613Byidc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: anton-paar.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR03MB5725.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183922de-992a-4c4a-06fa-08df36815fd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2026 12:28:59.5444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1650d056-0824-4040-8341-61f3c6069bbd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vrUCThOv1wjT20/2NMUxrnhohM2O610Zz/h3f/4XDTIXoWDXpHbeXqlLsUcWMlCtrMluT4LDfg1dBT7jvO9/hEMVxBWQ7cD06ZPZ9ke4z2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI9PR03MB911530

PiBPbiBPY3QgMjMsIDIwMjYsIEFuZHJlYXMgRGlsZ2VyIHdyb3RlOg0KPg0KPj4gV2hhdCBJIG1l
YW4gaXMgdGhhdCBpZiB5b3UgKmRvKiBkaXNhYmxlIGRlbGFsbG9jIHRoZW4gdGhpcyBtaWdodCBz
dG9wDQo+PiB0aGUgYXBwZWFyYW5jZSBvZiBOVUxzIGF0IHRoZSBlbmQgb2YgYSBmaWxlIGFmdGVy
IGEgY3Jhc2guIFRoZSBub3JtYWwNCj4+ICJvcmRlcmVkIiBtb2RlIHdyaXRlcyBzaG91bGQgc3lu
YyBkYXRhIHRvIHRoZSBmaWxlc3lzdGVtIGJlZm9yZSB0aGUNCj4+IHNpemUgaXMgdXBkYXRlZCBp
biB0aGUgaW5vZGUsIGJ1dCBkZWxhbGxvYyBkb2VzIG5vdCBkbyB0aGF0Lg0KPg0KPiBZaSB3cm90
ZToNCj4NCj4+IEkgdGhpbmsgdGhpcyBpcyBjYXVzZWQgYnkgdGhlIGRlZmF1bHQgZGlvcmVhZF9u
b2xvY2sgYmVoYXZpb3IuIE9uY2UNCj4+IGRpb3JlYWRfbm9sb2NrIGlzIGVuYWJsZWQsIHRoZSBl
eHRlbnRzIGFsbG9jYXRlZCBkdXJpbmcgd3JpdGViYWNrIGFyZQ0KPj4gdW53cml0dGVuLCBzbyBv
cmRlcmVkIG1vZGUgZG9lc24ndCB0YWtlIGVmZmVjdCwgYW5kIHRoZSB0cmFuc2FjdGlvbg0KPj4g
dGhhdCB1cGRhdGVzIGlfZGlza3NpemUgbWF5IGhpdCB0aGUgZGlzayBiZWZvcmUgdGhlIGRhdGEg
SS9PIGlzDQo+PiBwZXJzaXN0ZWQuDQoNCkhpIEFuZHJlYXMsIFlpLA0KDQp3ZSBkaWQgc29tZSBh
ZGRpdGlvbmFsIHBvd2VyLWZhaWwgdGVzdGluZyBiYXNlZCBvbiB5b3VyIHN1Z2dlc3Rpb25zLg0K
DQpUaGUgdGVzdHMgaW50ZW50aW9uYWxseSB1c2Ugbm9ybWFsIGZpbGUgSS9PIHdpdGhvdXQgb3Vy
IGFwcGxpY2F0aW9uLWxldmVsDQpmaWxlIGhlbHBlcnMsIGluIG9yZGVyIHRvIGlzb2xhdGUgdGhl
IGZpbGVzeXN0ZW0gYmVoYXZpb3IuDQoNCk91ciBpbnRlcm1lZGlhdGUgcmVzdWx0cyBhcmU6DQoN
Ci0gV2l0aCBkYXRhPW9yZGVyZWQgd2UgY2FuIHN0aWxsIGdldCBOVUxzIGF0IHRoZSBlbmQgb2Yg
ZmlsZXMgdGhhdCBhcmUNCiAgYmVpbmcgd3JpdHRlbiBpbiBhIHN0cmVhbWluZy9hcHBlbmQgZmFz
aGlvbiB3aGVuIHBvd2VyIGlzIHJlbW92ZWQuDQotIG5vZGVsYWxsb2MgbWFrZXMgdGhpcyBzaWdu
aWZpY2FudGx5IGxlc3MgbGlrZWx5LCBidXQgZG9lcyBub3QgZWxpbWluYXRlDQogIHRoZSBOVUwg
dGFpbHMgY29tcGxldGVseS4NCi0gZGlvcmVhZF9ub2xvY2svbm9kaW9yZWFkX25vbG9jayBkaWQg
bm90IHNob3cgYSBub3RpY2VhYmxlIGluZmx1ZW5jZSBpbg0KICBvdXIgdGVzdHMuDQoNClNvLCBh
dCBsZWFzdCB3aXRoIG91ciB3b3JrbG9hZCwgbmVpdGhlciBkaXNhYmxpbmcgZGVsYXllZCBhbGxv
Y2F0aW9uIG5vcg0KY2hhbmdpbmcgZGlvcmVhZF9ub2xvY2sgaXMgc3VmZmljaWVudCBieSBpdHNl
bGYgdG8gcHJldmVudCB0aGlzIGZhaWx1cmUNCm1vZGUuDQoNClRoYW5rcywNCk1hcmt1cw0K
