Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.135
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795513841;
	b=2HMA7XwdB7pYdHD3XtLu5kfSnjcLT5SSxi0wZtMeNSgCrJGVYibCo60p0puzQtFXnoJa
	 /F3ZMkgESugT/8UD67hNiqoOuKB8MNbxJbPtMOPjBbnjH7A5X9K2J/4z131ldRS6EbJk2
	 wJhMy89y4cdGaf2XlRDDHjBjj9Tw5Ff8OfaJP8HucVYvwEQvgBuBdBhoM2SBgjJmimXcT
	 MR7YadcijVO3Zfnp7QV57DScN1tsN9obDsH4jAv2VPd0M1fD8UYf3cUoW+C4F/YCXSRq9
	 940Wt2v9tVEjz1JD+9r1nflGtCPIDPkJYxcAAjydFyxGDvQTQK/43RiO0evitEw7l1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513841;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-ms-exchange-senderadcheck:
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
	bh=JkrPP7AsbeuIDoW/Uf2Ky4hO1zrp3mJ40eVqQKT9UnA=;
	b=kfBzH84lIUrWl4PVf5PQ/TECJg5WSO5arwOwrhThzRpIB4BUe1oMk0xMMGjR5XEIG/WE
	 9ddiBh4TSo/wJawyXQymr1uXjwpKDfXCoCQR7Gu9ibASaLIumv2RQTEVHzXpujbZUC1u+
	 PvFjf03e4pqg2ZYj59w+VjqXdqYJaoGFan4+PZ43m+VSVP4Y4/M2+Xt3av0i6B+ACkO9F
	 tONHZ/LDWfziwIPhdd90wKeLsBmO7sP2auKe4RUNGnTbYor9OX71cUrVzTjtAgvca8+pN
	 l8zE3nYc+Xf3mr4YC6wgQeojVfchnWWcAhr6Pp569UUiHcjSPmx3/jUCoal+/D0f/2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ieiworld.com.cn;
	spf=pass smtp.mailfrom=ieiworld.com.cn;
	dkim=pass header.d=ieiworld.com.cn header.i=@ieiworld.com.cn header.a=rsa-sha256 header.s=selector2 header.b=ia6LqSIv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.135
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022135.outbound.protection.outlook.com [52.101.126.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66033606A68C;
	Tue, 24 Nov 2026 09:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66033606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieiworld.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieiworld.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ieiworld.com.cn header.i=@ieiworld.com.cn header.a=rsa-sha256 header.s=selector2 header.b=ia6LqSIv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wz5m14YqSLyv8ISqrqXG9KABiguW+u/E2SPzi3ctO9W4dNBMyeIT9a7phdIxmDw/8mRm3CF5Zf+bXbiZCJFXXsfp1kDBf7ugkHd6pSKRbzt0o6YzBLupsF5n7xJXU7r6YKeHHPuzw/i/+7TJkRco5MFUKldYJqkffdZKn3DJlKcW3nQDuOwoh2AxGAzEP1UeTQ1QF5svPHkB4a/NV//TDC4OeteMCviL12QdI2x4Vbl5Syr52pKnD02UbFBTXsdw8W9VtZfuk/otYabgMoUGi4Bviq4Aw279nxqNbORVVeUbRkvoMiqWE3+QDOWVA5Sgans6wzBAkhm3KmjgRDrIOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkrPP7AsbeuIDoW/Uf2Ky4hO1zrp3mJ40eVqQKT9UnA=;
 b=MbecxMjfHROWzltBNgHyFPLRHdmaZErN/436tZarwLQpcUwYm/3nTcm3Bzr9Y40hfWTgh9Do1iD+g0Rk+xxZ0ZBHGGcJUavP3AvgEd1NzvOGG73Gz5KTGNl4VcPWeZbIPojzKVQi+A/gXoYoFYPBxa85ycy0+boDApluJgeJF4GyKB6egkEM4UuECQXORI4pWVLVMZ9FXOJ8vs/1bIgzTBUFTAP25w/YLW4BIOSFYFE5scBoB7qt5UOabD2lBexj0xZjA8WybP1VcEfmHSf8GESuRENSi7ZOycMMNPrPlum/gfnGUlyMlPFhdSJJrTKTzbY/49de7FLrpOF9tItseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ieiworld.com.cn; dmarc=pass action=none
 header.from=ieiworld.com.cn; dkim=pass header.d=ieiworld.com.cn; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ieiworld.com.cn;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkrPP7AsbeuIDoW/Uf2Ky4hO1zrp3mJ40eVqQKT9UnA=;
 b=ia6LqSIvX3nq5nVZSVurXaxbL7eHOmW6h2iW0yaye8b5s81qqS91NC41FHJUCagVkhPHsss+wQi+NKpnI20skhhqZUOlxI/kE0kugfKmwncZyXiHPoJkx83k5WNKPUUUdcWkpzj6pvaEJHsi+zLY1Sp8B7tOtplL70Q+VYb7MmTG260FTvvPyJI6JBjHJVKgmeQUKlkYFlBETN8hfcx/2EAh2JIU1qTW/9ZGMP5+oCwsMAvKsPR1SBayrEnA4HTW/WwWtzhHhAReppDXtSFwhW/tLdJspUFbyQ+NRMyhKE1MeLaq1ULqD34rEfEZtQ32j3r/iz02pspYvbFYC3y7eg==
Received: from JH0PR04MB7464.apcprd04.prod.outlook.com (2603:1096:990:6b::7)
 by SEYPR04MB5617.apcprd04.prod.outlook.com (2603:1096:101:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 09:50:37 +0000
Received: from JH0PR04MB7464.apcprd04.prod.outlook.com
 ([fe80::d51e:67dc:2342:9e5]) by JH0PR04MB7464.apcprd04.prod.outlook.com
 ([fe80::d51e:67dc:2342:9e5%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 09:50:37 +0000
From: =?gb2312?B?RnVzb25nIExpIMDuuKPLyQ==?= <fusongli@ieiworld.com.cn>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Jan Kara
	<jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, "sashal@kernel.org"
	<sashal@kernel.org>, Edward Adam Davis <eadavis@qq.com>, "cve@kernel.org"
	<cve@kernel.org>
Subject: 6.1.y: missing "ext4: avoid infinite loops caused by residual data"
 (CVE-2026-31448)
Thread-Topic: 6.1.y: missing "ext4: avoid infinite loops caused by residual
 data" (CVE-2026-31448)
Thread-Index: AQHde/ith3/3Epg7iEqwUUfSIz+gHg==
Date: Tue, 24 Nov 2026 09:50:37 +0000
Message-ID:
 <JH0PR04MB74644C65BBF68069425C8B8392442@JH0PR04MB7464.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ieiworld.com.cn;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR04MB7464:EE_|SEYPR04MB5617:EE_
x-ms-office365-filtering-correlation-id: aca27b7b-0e40-47b0-09a8-08df4a10643d
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261102123227099003|38070700021|261028144727099003|261021121427099003|261022105027099003|261022075727099003|261026121527099003|11063799006|261026140227099003|10067099003|56012099006|18002099003|55112099003;
x-microsoft-antispam-message-info:
 YGycOuagoT3jaYlD5f5oRSM2Z9scHUDXO3nH/ntq5WzbzZ0MzX4C9RZB5+OQ9ymH45AU1OTzWXf2vVnqBNH7EsqGJJSapV3snFt21cH5UIiio2d44IQoPhn1zZ4Q/2eDxHFuAq3bAzSxEwKKzHXww1Ugc26CiarK3ppxENhoOZND9+WURaJpyiO+e4kIIcM/gosvgFUrSPJDbjTzAbOfhgPmI4HH8Rh3rF+t85A+ZjFk57HdcE/zwUXrJz/R446xWIr1CIeTdWAcKFvofR+UMAFszNF7Wl3TKTqmLBxecIfwPCHwfM5fj7vk3h9P9P9aU04Uz6Uj5JnRj2bgQbnTKOnnlrXRl/WHggisYmh7f6lzQS89UuaZNzegGEv9/7A0nGR2G223FYvYR9TWrcHOZl95fZ9TN0toLeAAkFYsEjy8fhKCI71ZmTtoMt/grtABTSWFs8oUPJICJcq8/5g+qEz7/PJuulyAv87PAnJaGM1XMKkR5+8kJRdo0DLpTkymynuJSKfW4giBmBL/RXe9mCOSsViYGCHPU/50G/mO0mcS993Mo1lblxRnUfQtBL71uk91V0mUIQA608K6IRX/xI3EAqsy9Xgy4oJFozMwwu0CJ6gQeDTgG05pVoeHBMqOtneZBFdQ/uG20LVwK6n+yllAx2D7WxgwsGincbBpdvSicL7CvHhKGPc9LhcPlxSZtIFJ/Dq13hfE5qWl8MQ6Nm/e3mDHg/lpm2HVY329Wzw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:JH0PR04MB7464.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261102123227099003)(38070700021)(261028144727099003)(261021121427099003)(261022105027099003)(261022075727099003)(261026121527099003)(11063799006)(261026140227099003)(10067099003)(56012099006)(18002099003)(55112099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?Vk5JNkFoZlJGMHZNeWNOU0JvRUg4aTBiQzh1YjNoYmgrWUMyOHk4TEc0dEl0?=
 =?gb2312?B?R25zaFZBWUdJcXMxL3FybnNuQ21KUHBPRmVEU05jYVo1d2JwemluaHlFNzNx?=
 =?gb2312?B?a1dITDFrQ3ZURHRJblV6WFhqbzNuYjRiNG5Uanc0ZGtkQnVuUnIrWENtcXBI?=
 =?gb2312?B?Y05SQ1VsOXhxTno0Q0c4YzJRanpMVldkYU0vTkg5M2FjRFpLTi9KTWFTUDB0?=
 =?gb2312?B?eFljbHhIOFNOaGN5eGlMbE16dmFVQUlJeTlUYTRpWGpTK1pnaFdGS3FMZEpN?=
 =?gb2312?B?Qjk5blhQcWlPU1RWdlFzTWVIK0Jya3pFdlZ5a3BCdjZTTEF1YkZRUGludy9K?=
 =?gb2312?B?dlRucGNiekVQejA1MW52RFZ6SXFiQ0ViUmdwN0NXczFrY3MwakpNNWdPZ2Uv?=
 =?gb2312?B?VStqVmpQa0RlVVl0Y1VycGRTRVU5OGcrVmFNWTBqTm5ibDFoa1hhNGZIYW5m?=
 =?gb2312?B?QVdIUFQxamVZWXRNa2lPSHdLeWVWeno2RlJJL3g4TkU1eC9FSkgwWkhvSDhK?=
 =?gb2312?B?WkpJeFZCSEVzQUdPUTJDa0dweVAyRmhJMmRiMWlpTWdodzY5MWQzYXV1WW1Z?=
 =?gb2312?B?ZXZOMlV3ckxWRWpBbW1GaXBSQmVQTHRpUDNOR2hwbGF6MEF1LytQbXo4eElV?=
 =?gb2312?B?Q0ZiMG9WN2FjZG5VNHF4ZzM5MEhIeEFPZlUvL1lidVFlVzhXcngwTml3aGpO?=
 =?gb2312?B?SmRYcmpKT2ZKSUZXNmZrdnVoditKbllVQXhBZnBYNEVHZTEwbmZMWWxuZlJV?=
 =?gb2312?B?b1YzaUNteFFMTHUvd1ZibDFQN1Q2RXZ4dm1WSkpIVm1mTWN2OUljMWlneGor?=
 =?gb2312?B?bDNIbWo4OVZyL1V1dDljam1qQitzNWlUcE5mMVU3ank2VG0wK1N5bnFOcXZs?=
 =?gb2312?B?ZWR2Z2ZmNzYxTUVXQThNdXlYVjl6Tyt0UHl5Z0Z5a3MxbzRqcXVKSXJJQWRp?=
 =?gb2312?B?YkhLSmNYV0l5SDJvbjRTTmNEcEhqVjdhci9HQ3Znd3JINlNUSTlnVHhEOXV4?=
 =?gb2312?B?eXdMeHZIZlprajRuVkVlRjA4QXo5dUppdzNpckNpUlFqLzVWSWVzUUt3M0Ey?=
 =?gb2312?B?djJCY2sreE5HcURjQTRiSEtGMS8rU3VaUDZFMDZLZ0JPdDkvV0tBUjBENTgw?=
 =?gb2312?B?UXZFZzhQcWkrZUM2WXdXN1V3ZER0QTRQem5LbDhTU1JZRVJyNUx5N1AydEhz?=
 =?gb2312?B?MS8vT1Y3RzFQcEVpTXhWVUNyb1dyZlJKd0pvbDRjeW84cWdyZ2tpdFJXZTRP?=
 =?gb2312?B?Y3lyK0xjbUlDK2dxTWJPc2QybzE0Z25DMHM4K0JSTGpBb2w4c1pKSFdLZis5?=
 =?gb2312?B?eTcxTm1WdjMzNVVodmZNbjNVMGQ3amJ0a2tEcFJZVDczTk1QWTZ1UmQrdGJO?=
 =?gb2312?B?RTNsS2VtYkFrNWF1TmhUZ0dlamJHR2I0c1pnWlVRRzdlenlkWnl6Q0hlbENl?=
 =?gb2312?B?VHloWUwzY1g3M3ViVUhxU2QvTjZiT0NlZXlpRHNsd3dOL3JQWU1sNkduZDh6?=
 =?gb2312?B?MW96RFhGdFpkVDVwS2FvQWRoTEJxSXEvalNYc1RFblYyN3ZkcmFRZ2pYemJJ?=
 =?gb2312?B?eTJSWTlsZUNxZmdGQ0hZNFpkbXB4S1FlNGc3UGY1T0ViWlNoSUh1M0JkL3VM?=
 =?gb2312?B?R2lxV2gwVHQwTHJEb0sxU2R1b2hDSmRCYlFndUUySjF3ckR1QURtcDlPaHcy?=
 =?gb2312?B?UWY0NGJGQnRhbXd0S3luQUN2WmMxTGxXUExiaXdRNE9iMCt1UmFLTXRkcDdG?=
 =?gb2312?B?Rk00Z2dsTUEwb3VGNGVJWHptcjZ1bkRtTEgvRWRUdm9XUjNBWkJQR3hkeUNs?=
 =?gb2312?B?UFhLWTJPZHN3Z3J5MVF3blNhZTg0N2s3SUdYSTFnMlNaSFhMR0hsQ1pyN25P?=
 =?gb2312?B?NEE2T1MzOXUwMFord3psd3l6ZWtXTGg5VVJNbVpqR2Zmbng4ZEo0VDVHYitw?=
 =?gb2312?B?ZG9VRng4d1E0MHphVXFKWHkvb2RKSkdySGNVSWJNSjRLTzhwL3prcG9zVDFQ?=
 =?gb2312?B?eXBibDh3ZTR5WThyZWJQNnYxcmd4NXl2aGtHd2ExOFo5REJ4ZTdDUjFmcU9M?=
 =?gb2312?B?bzZpSDlXRDdQSHI4WWJzME44ZEZmVE04YUkwa0RsY2RTUzlqb084SmZqV21V?=
 =?gb2312?B?YWJBOWxEYVVtdXdSSWkzSENtSUhXQS9VWFBsSTRxWEl5ai9SdVpINWZac2NQ?=
 =?gb2312?B?YUoycUViNmoveGMrRnhvL09LN1lXR3FBMitaTzQrUEx5am5qVUF0YkxXblhr?=
 =?gb2312?B?UXBTU3BFU29tU2dUaG4vdmttNXJmN2l6NmV0Vi91b0RUZFZma2I4WHV2TUF6?=
 =?gb2312?B?RjlrcFhtc1hKcXRYaDY3YUw5eHhWbkNOTjQwRHg5RDd5Y0ZsWFZnQT09?=
Content-Type: text/plain; charset="gb2312"
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
X-OriginatorOrg: ieiworld.com.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: JH0PR04MB7464.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca27b7b-0e40-47b0-09a8-08df4a10643d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 09:50:37.1417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: io2vZioZEx41dYUSKMwoOy0ngUu4l/iGbf3Sfu19lr04V75AzHrEgfiRQy/OtaOINNAOqYajd6CP/T8AO+zOBE5FCum6f21GNA+fFc6gGnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB5617

SGksCgpVcHN0cmVhbSBjb21taXQgNTQyMmZlNzFkMjZkICgiZXh0NDogYXZvaWQgaW5maW5pdGUg
bG9vcHMgY2F1c2VkIGJ5CnJlc2lkdWFsIGRhdGEiKSBpcyBpbiA2LjYuMTMxLCA2LjEyLjgwLCA2
LjE4LjIxIGFuZCA2LjE5LjExLCBidXQgNi4xLnkKaGFzIG5vIGNvcHkgb2YgaXQ6CgotIGM2NjU0
NWU4M2E4MCBhZGRlZCBpdCB0byA2LjEueSwgYW5kIDk1OTQ2MjJmOGEzOSByZXZlcnRlZCBpdCBp
biB0aGUKICBzYW1lIHJlbGVhc2UgKDYuMS4xNjgpLCB0b2dldGhlciB3aXRoIHRoZSAiZ2V0IHJp
ZCBvZiBwcGF0aCIgc2VyaWVzCiAgdGhhdCBpdCB3YXMgd3JpdHRlbiBhZ2FpbnN0LgotIHY2LjEu
MTkzIHN0aWxsIGhhcyB0aGUgb2xkIGNvZGUgaW4gZXh0NF9leHRfbWFwX2Jsb2NrcygpOgoKICAg
ICAgZXJyID0gZXh0NF9leHRfaW5zZXJ0X2V4dGVudChoYW5kbGUsIGlub2RlLCAmcGF0aCwgJm5l
d2V4LCBmbGFncyk7CiAgICAgIGlmIChlcnIpIHsKICAgICAgICAgICAgICBpZiAoYWxsb2NhdGVk
X2NsdXN0ZXJzKSB7CiAgICAgICAgICAgICAgICAgICAgICAuLi4KICAgICAgICAgICAgICAgICAg
ICAgIGV4dDRfZnJlZV9ibG9ja3MoLi4uKTsKCgoKVGhlIGZpeCBkb2VzIG5vdCBkZXBlbmQgb24g
dGhlIHBwYXRoIHJld29yazogb24gNi4xIGl0IG9ubHkgbmVlZHMgdGhlCmNvbmRpdGlvbiBjaGFu
Z2Ugb24gdGhlIG9sZCBBUEksIGkuZS4KCiAgICAgIGlmIChhbGxvY2F0ZWRfY2x1c3RlcnMgJiYg
KGVyciA9PSAtRURRVU9UIHx8IGVyciA9PSAtRU5PU1BDKSkgewoKQ291bGQgdGhpcyBiZSBiYWNr
cG9ydGVkIHRvIDYuMS55PyBBIHBhdGNoIGFkYXB0ZWQgdG8gdGhlIDYuMSBBUEkgY2FuCmZvbGxv
dyBpZiB0aGF0IGhlbHBzLgoKTm90ZSBmb3IgY3ZlQGtlcm5lbC5vcmc6IHRoZSBDVkUtMjAyNi0z
MTQ0OCByZWNvcmQgbGlzdHMgNi4xLjE2OCBhcwp1bmFmZmVjdGVkLCBidXQgdGhlIGZpeCBhbmQg
aXRzIHJldmVydCBhcmUgYm90aCBpbiA2LjEuMTY4LCBzbyBubyA2LjEKcmVsZWFzZSBjdXJyZW50
bHkgY29udGFpbnMgaXQuCgoK
