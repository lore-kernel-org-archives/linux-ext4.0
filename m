Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020106.outbound.protection.outlook.com [52.101.84.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD98B49C4CE
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399902; cv=fail; b=KK3E87QL5BZUtMDZ4vc34b8DQeq0+EeAZKbeEOD/49cChQQhBg3ykNc9vi9lvMqtol0aCb3qw4xxPlkJEPsDjrcOO5ypZBzC7Nuh8aLT1qMifZsVI95jzPXsBqvQIvZuGU8C12xPJgzbfMWqSFhxYQNbKvN292oLe1CXtFI6j20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399902; c=relaxed/simple;
	bh=uJK/MAYdOMEZTk4SLPExU/wSKVf9+zVYF2lWSJfZtEs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e9MfZiS/MRFwN/8/fDleKH0n4ONsOjdyO86p0PlgIbS9H52gZsiIHwUjH2QK8t2OAb3QDE3iSRcSvipmNj6Q8S+IxnDx5EPOAntrq6rzojhhh2BKZWrRuuYtxGYqchAMVclQZSKsGgSISO1sNgOgKw23BwsgT8GW7yDhnCwfTcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=anton-paar.com; spf=pass smtp.mailfrom=anton-paar.com; dkim=pass (2048-bit key) header.d=anton-paar.com header.i=@anton-paar.com header.b=YvZaPzyF; arc=fail smtp.client-ip=52.101.84.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=anton-paar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anton-paar.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anton-paar.com header.i=@anton-paar.com header.b="YvZaPzyF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CaXw9P9ISaK61qcOkPShqks5wUVZifRCv7CS/8ZBD+E0Fqix3Alq5buzY0EI/ILFeyIwOv34bC9arZx7e87sDO5xDrcmRl2vriE+Jdxb4dmd4X8mpNyNwMFtVomdtqYBvZdu1r5diGbbf4lhqnerfG12uKcLWfsUt3u7zoa5oI0ihcPzG92Bd0zJqwbo77CKma/t/CljR4+k4hqR97EZzjjgYDNQNIUhmTUPdicA7NiqJ/fZhJoRezNnP0ObE2BoKjtrw7n4eKdZiuNbnkUvmUX1E7/KIcK+A8opq/653fzWRf+YR2hpxOpG6bV9HKycW4HCrzSGavFdIdOOnzqSgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJK/MAYdOMEZTk4SLPExU/wSKVf9+zVYF2lWSJfZtEs=;
 b=U/18dLPYGUxJAZLepT+rw557mYx2UZQVQtgKnOcqYpvrTHTl15EovrS8uGMHFm5cvPUBtWTdVA1mg0ZFprkNMxZHlJxxmXDHag5tipkrWl7oZd8NVv4/Mk3jVCfhclWf0ska4mY74sEukJbkBbO0VsUYAKC5yeemnbdIxPtVplt3N/7ByJv7xYbf2ey6BYmxelRW5ZjFoU6OYNXk9YXNOGdkJXUcCorYrrlOYGC0yvv/Ktb3FfEmTFlcS4ZpwFva79PYz6axkuwz8k48wPQUrYYTO1rkC1HxBzFvtn4MvN4SzHGf79C3+yb9RPrwRyML3MdCF8WI2tZjKtHYR7xbRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=anton-paar.com; dmarc=pass action=none
 header.from=anton-paar.com; dkim=pass header.d=anton-paar.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anton-paar.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJK/MAYdOMEZTk4SLPExU/wSKVf9+zVYF2lWSJfZtEs=;
 b=YvZaPzyF1RAjtMxbQ5DlcaK7kip8ado0nwVequi5P0/5vPKVNq076RoH96i6aspxYXMUcljNk0GW9M3j5AVmBXAaqD1adJxFwekKI+bAKbzCdnON9r7PITEegMbQZyUXWNI2JH4KARWlklCsxcSu2KC/jRvbu5dJBVwvT6Q1lwB9YL1/+rW2F1rAjl3dIY5PzCI/UASqPQnmnixIXqtKx31amYAWVkyGo9JTsh8cuFHmt678R3cjCh9ZREfBaDISnekf+qCHtWu0ySiGALuACxoBKgThAr4Dk0RULWY6mVSe5H9Rwtu/DpRA8codcaFE21i8Xs4AN7wBZ5BTta8fyg==
Received: from AM0PR03MB5714.eurprd03.prod.outlook.com (2603:10a6:208:177::23)
 by VI0PR03MB11653.eurprd03.prod.outlook.com (2603:10a6:800:322::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 08:51:33 +0000
Received: from AM0PR03MB5714.eurprd03.prod.outlook.com
 ([fe80::632b:9566:1361:5740]) by AM0PR03MB5714.eurprd03.prod.outlook.com
 ([fe80::632b:9566:1361:5740%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 08:51:33 +0000
From: "Korber, Markus" <markus.korber@anton-paar.com>
To: Theodore Tso <tytso@mit.edu>, Gabriele Moabiti <gabmoa@gmail.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: RE: ext4 data=journal deprecation: long-standing industrial use case
Thread-Topic: ext4 data=journal deprecation: long-standing industrial use case
Thread-Index: AQJe7lEtanpk7txC6V2h/QI8XBITzwFQhtZstfbrjkA=
Date: Mon, 19 Oct 2026 08:51:33 +0000
Message-ID:
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
References:
 <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
In-Reply-To: <as0U-lfet5slrD8o@mit.edu>
Accept-Language: de-AT, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=anton-paar.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR03MB5714:EE_|VI0PR03MB11653:EE_
x-ms-office365-filtering-correlation-id: 726fa8c5-e808-4378-818d-08df2dbe2d50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|56012099006|22082099003|18002099003|4143699003|38070700021;
x-microsoft-antispam-message-info:
 V0GhN1HwIQidfTc4ia0qq2ffvynwcg23M9W/Lo/NOvxRNFkgXYyK81mB/4hRv/Q9tRPWG7T9f2AgGlPMw/YiJqLak//eHx6WDwFA1mYrv4hrikwMRm1eaEjfwOZ2TrhB3zOlyFczG/ggmBgxc3MNZILSZZkhzKW6Mw2iQTBQDr5IUvJi5znQMbrmQ4uutf6D97xfUOCm9y35fiXBdgw0ztGWNEsN4ZREECjrMrLAqTpzs5rbfFu6sXcZQOlgkA8w4S5duDPxseyQvdzJZnnkRIdJirxAUvb6nYjKN/u1XzMm4ea/QVTE652DolezDejRvGXvdtj0go/LbqUl0KiOwN9B68tpK/tf52HyMUVRygy5JU+riGupHL2ttV/HSllevjeHAVa5v7hwGJ1CBX1fR0kSQtY8Vy2dMNcCAkMihzaIYLDACkdZ3gx+0AC91V0u0EFHUuiAL+bXbAHmgx4ASEsc7EGOWvV7uP+hzVGCbddwhXMZzY1KfU0dFByGjjB2I9quuiNPEP+npdtlHyfEZiuuppZWNHPDLQ5tFEHk2B41mG0kiHiPGZw9/qQKqxhGxqAe6SgymAzb+kiL6C+d23l/Pyf9TYNYLr4c9X23CClVtrjjW/+na+knUQjkOSUAsk00NncqHxKMQkIsQQ5KcX+KGhTSHejO9t4vSXJCBj06wW81qEoCo+8X4q9Gc1b/zV4Q8OCOje9uhWLN17byEjRiJZzQPQapUQiloWR7CvM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR03MB5714.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R3BnUXlDeDVlVmJTU0pDeXdrY1RtbDhpeDdnL29LMGtqckwvN1dsWjN5bTB3?=
 =?utf-8?B?ZnU0Zi9KNjBWS0JYQ1dyV1luYmNuQnhBVFIxbmVqOWVubXFSQjhVRWlnU3I2?=
 =?utf-8?B?V1BTUzJiWWRkaUFxNHl6emNWRFJsRmRxNS9mYlN0ZEIzVHBqSWRLQkNBeHFN?=
 =?utf-8?B?VE44STQya0d4ZC9MM2hVQzhwcWl6ZE9Zd2s4VUpYYUF0VlZmZDVESnJITWs2?=
 =?utf-8?B?akVHdXlNVFpveDhpWitlWGNTdGpsMXlHalFJWStDZUJvR2YvM3JKaFM0OEpm?=
 =?utf-8?B?TFRNN3pEeXgxSTdSenNTWnNidnZUU0ZMY3JENjAzbXZYT2dNbS9VQnVjZi9s?=
 =?utf-8?B?ZFRqMUdicXNuMktscXI0QW9SUFBncmJWV05XbG1tMzdKZy95MDRmWGV4NXhv?=
 =?utf-8?B?b1A2OVhOT3BQbVoxWmdTcGsxdHJOWDRlM1E1NDZ2ekNyd3BFak5CeFdsR0k0?=
 =?utf-8?B?cmpENW5scmV5WnlPbTJ0RG8rbTVrZTI5c2NNUm1yTUk0VWY0UFFDRkxMM2l6?=
 =?utf-8?B?eXBZZW5vYkMrSlpiM09tWGVwc2hzeVNFNmxYYit3RDNlOWdGbVhkRTQ1QlNJ?=
 =?utf-8?B?c2hJZlFZY3FJTUNQZXU1TlBRSXlxZDBzWTh0L3RmZFIzVHc1TTNPRDRFTkNP?=
 =?utf-8?B?SFFRU2VScjBDaW9ZUW9Nc0kxUDdQN0ZvK25zMkZmdmZNMUJDaHB3dmFScVVX?=
 =?utf-8?B?QW9ESVJXOWpmR0ZqKzVSdTJ6dFlTQ3BhTkRDQlZZZGIyckRjU0tvVFQyWmNZ?=
 =?utf-8?B?eVRVOWpGWXlYRXA3WWtCN0JjY1YyM3B6ZHp4MUlGN2VQRlRpUklGN2dTQlg4?=
 =?utf-8?B?RWZ5VnphM1BUY3NFaFFtMzAvUVFUREU0NUwxdUlsMjltZGxQb1BORVAyOEF5?=
 =?utf-8?B?cTBkUGZjMnFTdkliSkUwRk1FOG13azdQOHdsUjlJbEZCUXhuY2YxY3ZOMjZC?=
 =?utf-8?B?RDhJSFU4emMrZSt3NmJTVHVTRmhqV05aSmlwVlVuYXdod1FWdVZtVHNWRFo5?=
 =?utf-8?B?bDZ1TElnZkcwUDFPTnlJMHlKNWsyQ2QraUhQSlJQbmpSYlNCY000U3c2SGJq?=
 =?utf-8?B?dVgvc0pCWElUcDBNbzFlNU1XbEVWUzRjZi9Cb1FqazZ6czF1YUdEQ1kxMlVv?=
 =?utf-8?B?WXByQ2NvYm9LcE9nclc0TVlvUTVLOFZaNHJRc2I3ZTdxZWprWWdGYXBPdFlt?=
 =?utf-8?B?YnBTc0o2ZHB2Wk5XSWtudEJRdmFjL1NRKzVKMUx6ejNyZU1hY2xXanNaSjhm?=
 =?utf-8?B?SHM3bTVjSVY1b3p0WndPU3B3aGE1elFyN2FBUjRsZHpYY0w0dHRUSXNLNjVt?=
 =?utf-8?B?NGt1N2JLaUlKSjZXWFJvWFFKaXFsZnlRS1U3cTUzNm1obU5ZejA0aVVuYUJp?=
 =?utf-8?B?THFaZzJQK0d2SzZMMlhkcUVIdG8vUGVsUDZSVmtFNGlYZ0ozaHk3dTVHeDRG?=
 =?utf-8?B?aUhNeC9KV0RSZXl3R1NrR05ld1MvVjltVGNOcGdGY0JaUHF0SGxyckdrbEUz?=
 =?utf-8?B?WEZUU2xvVEU0QmJiK3BUS1lKZWVsNDFRWWdISStwR3krcExYcmFlV1o2YVpZ?=
 =?utf-8?B?RXpjN1lzMDN6c0ZIVTlBSHlLU1piUGlhbXRZektyTVN1YWU1NVhCQWFkS0Zy?=
 =?utf-8?B?SmhiV3N1RGhoOXM0SWVJeWNaelpqUnhGMHc0eldUL01ZYWVKS2M0Z1ZiS0xC?=
 =?utf-8?B?dnZqbnQyc0lVNkhtWE5BLzdQaDlFc0hremRZeXhZOS9sMkVvcUJkaFdBdlNG?=
 =?utf-8?B?TGZybWFSQ1h1L3oyZ2lhU1laQjFkWFNiT1R6ZnNTNUtxNkhMYXNLQUVna3NX?=
 =?utf-8?B?UUs0RnE4Z0xsRzBoU2JteW1ROWRiOXRXTm93SG5LQ1gzOHBnVjRlZGRVMTVl?=
 =?utf-8?B?clNnSUE5Y0t2RWRGYmJJYUsvZVczNkR5Y3pMSDF2bVNDRDg1czh1OFdjRTZp?=
 =?utf-8?B?b0pEeGJqcUNIQlArcE8xT3dnQ3lPV281ZGRwUmtUZHpvKzNiS1FmaXVTdzlR?=
 =?utf-8?B?TTZHV1dmeTZMcDVWYmhzRDFXMFVsdzBicnl6STBabHFZaXNVVVRyN1EvWC84?=
 =?utf-8?B?aDMrYlk5c3ZlR3ZxeGlObysyQzA4b1VPS0ZQUXlOV0FsV24rSWdIWjROUlBN?=
 =?utf-8?B?UlJjdER1R2hzOGxNWGZ4Vk1DQ0hlaHJiRm9nWDZNY2M0U3dzSDJMZkZIdU8z?=
 =?utf-8?B?UmZDTmkyMWxyVzUvTzluNGU5US9lZ2lwY0k2Z2tkdHRjVCtnamNKWWQrOU0v?=
 =?utf-8?B?WitDdmp4RW9FSlR0TGpJckdPaDZYYzlxVG9JOVlzUEZ0ZmliSVl6OHRjUlpa?=
 =?utf-8?B?VnRsMWtUOXhCV0VIbTVXaUM5NHo2ZkEzalZqMTJZd1hLYTBERStTZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: anton-paar.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR03MB5714.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726fa8c5-e808-4378-818d-08df2dbe2d50
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 08:51:33.7158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1650d056-0824-4040-8341-61f3c6069bbd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yTiWXUkdWgNqa7YeiOn0E1cge8XWqPfqGHFAlKxNCH/nymSX0Yg+WTdeZD6yohlPAQEhkVaJ4If6dzLjBFHauEEi9EfNbz1bRjTR+xG53N0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR03MB11653

T24gTW9uLCBPY3QgMTIsIDIwMjYsIFRoZW9kb3JlIFRzbyB3cm90ZToNCj4gR2l2ZW4gdGhhdCB0
aGVyZSBpcyBubyBndWFyYW50ZWVzIG9mIHdoYXQgd3JpdGVzIHdpbGwgYmUgcGVyc2lzdGVkDQo+
IHdpdGggcmVzcGVjdCB0byBwcm9ncmFtIGV4ZWN1dGlvbiwgaXQncyB1bmNsZWFyIGV4YWN0bHkg
d2hhdCB5b3VyDQo+IGRlcGxveW1lbnRzIGFyZSByZXF1aXJpbmcgb3IgYXNzdW1pbmcuDQoNCkkn
ZCBsaWtlIHRvIGFkZCBhbm90aGVyIGRhdGEgcG9pbnQgaW4gc3VwcG9ydCBvZiBHYWJyaWVsZSdz
IHVzZSBjYXNlLg0KDQpXZSBhbHNvIHVzZSBleHQ0IGRhdGE9am91cm5hbCBvbiBlbWJlZGRlZCBz
eXN0ZW1zIHdoZXJlIHVuZXhwZWN0ZWQNCnBvd2VyIGxvc3MgaXMgcG9zc2libGUuIE91ciBtYWlu
IGNvbmNlcm4gaXMgbm90IGxvc2luZyB0aGUgbW9zdCByZWNlbnQNCmZldyBzZWNvbmRzIG9mIGRh
dGEuIFRoYXQgaXMgYWNjZXB0YWJsZSBmb3Igb3VyIHVzZSBjYXNlLiBXaGF0IHdlIHdhbnQNCnRv
IGF2b2lkIGlzIGNvcnJ1cHRpb24gb2YgZmlsZSBjb250ZW50cyBhZnRlciBhbiB1bmV4cGVjdGVk
IHBvd2VyIGxvc3MuDQoNCldlIHBlcmZvcm1lZCByZXBlYXRlZCBoYXJkIHBvd2VyLWN1dCB0ZXN0
cyB1c2luZyBib3RoIGRhdGE9b3JkZXJlZCBhbmQNCmRhdGE9am91cm5hbC4gV2l0aCBkYXRhPW9y
ZGVyZWQgd2Ugb2JzZXJ2ZWQsIGFtb25nIG90aGVyIGV4cGVjdGVkDQpmYWlsdXJlIG1vZGVzLCBm
aWxlcyBjb250YWluaW5nIE5VTHMgYW5kIHBhcnRpYWxseSB3cml0dGVuIGZpbGVzIHdoZXJlDQp0
aGUgdW53cml0dGVuIHBhcnQgY29udGFpbmVkIE5VTHMuIFRoZXNlIGZhaWx1cmUgbW9kZXMgYXJl
IHBhcnRpY3VsYXJseQ0KZGlmZmljdWx0IGZvciBhcHBsaWNhdGlvbnMgdG8gcmVjb3ZlciBmcm9t
Lg0KDQpXaXRoIGRhdGE9am91cm5hbCB3ZSBzdGlsbCBvYnNlcnZlZCBsb3N0IHJlY2VudCBmaWxl
cywgemVyby1sZW5ndGgNCmZpbGVzIGFuZCB0cnVuY2F0ZWQgY3VycmVudCB3cml0ZXMsIGJ1dCB3
ZSBkaWQgbm90IG9ic2VydmUgdGhvc2UNCk5VTC1maWxsZWQgY29ycnVwdGlvbiBwYXR0ZXJucy4N
Cg0KU28gYXQgbGVhc3QgZm9yIG91ciB1c2UgY2FzZSwgdGhlIHVzZWZ1bCBwcm9wZXJ0eSBvZiBk
YXRhPWpvdXJuYWwgaXMNCm5vdCBwcmltYXJpbHkgcmVkdWNpbmcgdGhlIGFtb3VudCBvZiByZWNl
bnQgZGF0YSB0aGF0IGNhbiBiZSBsb3N0Lg0KSXQgaXMgdGhlIGRpZmZlcmVudCBmYWlsdXJlIGJl
aGF2aW9yIHdoZW4gcG93ZXIgaXMgcmVtb3ZlZCBkdXJpbmcgZmlsZQ0KSS9PLg0KDQpSZWdhcmRz
LA0KTWFya3VzDQo=
