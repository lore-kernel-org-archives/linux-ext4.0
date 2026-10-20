Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.96
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792469921;
	b=QihV1RHKzTegSxWk6ZAel2Ep2+etkzsn6++EIWZKakuHHW71FtL8j5z/lDNr8iY3uQzl
	 WVodvNHuxd0KeG15+C6lpBBUNzFRuQ+AU56CfTKS0dJFXvfh/8L1UbziRzbZNNa4sqlo5
	 WVeVE6N3wKpO5ncRAB5qTDCCmgtX2gtvShEpbKbxb75ueDIVT6QZVhHOltIqh5/LSjRhj
	 a99O9CPR9GKvjo9IlHRUcD/APcOabDpz7MZ33dR3267AxzjYuYxTuRc2kwwhcG2rIoQG6
	 hNNrwsILwKGQYq1RbkstMLGip1zzUZ/C0ye7nFvrakkLLJ1Vgokv8EuQHKaKo2id+yQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792469921;
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
	bh=nTe5/Yw2Aa0rrwebondwpBzRS4LtoKjh/4ebZmM9eT0=;
	b=0mWLDojSYV+YmGi3MCQeMSCM2zHVOq/q+QRka5U5SstPdQzeafCGwtgCLRrazRIcN6Ij
	 L1qyYiT/hFYY3XzkA8cpMbaRNewf5Xrxe3sLIdec52pos0kWW7ZA0czndxKO6/4yLo16j
	 2ZSZCjmwlYOuXq8XVrzvedMMJPO2aOTSViXqTUei3hEtH5TEYQ0rth9hqVtMdYewCHTse
	 FXvC/xw6R1/f53GOw4gUMKmIffkLH41CBbq6uYimxHJYguq5ZuwJrqQ2jUuo9ZXaJMCZU
	 IIWwg8fh8bJFxGksPlTBdqdqxPgcmdcEZCTkXh0FItMjHsacYLTqLoNe9LBfVKWQEfQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=anton-paar.com;
	spf=pass smtp.mailfrom=anton-paar.com;
	dkim=pass header.d=anton-paar.com header.i=@anton-paar.com header.a=rsa-sha256 header.s=selector1 header.b=a2f31W5Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.96
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023096.outbound.protection.outlook.com [52.101.72.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96543606A319
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 04:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96543606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=anton-paar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anton-paar.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=anton-paar.com header.i=@anton-paar.com header.a=rsa-sha256 header.s=selector1 header.b=a2f31W5Q
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tk7AWAW5ZBWDMOW6Q5pP9vcN5+yNUYIKRWpgiRI3z0iqGqlRKmQsAvwE0hU3efiuBpShYvhUM8MwO/Ajpmf5xUMNlgKJuP/wn3uMmnDgHs8oVhjufwazDqoS1PHbWGxgpyP3K962jHeD7SZuB//o2gvnnXxMT9QmyXXGKjKHw0rBpo5jkOpWZrCuW88WAvl+epaNLgWcPk8Pkx4WSJ/b7r2Xcaox86R6po18M7MQzZWUqOZdDKGeCxq0vVI5OzcA85eCNA1q3mojeLYZ9Y7IrtBA2rUVzAg/AE85XsdxXPRo3ViUxowbh2iQHQIFSnfHAa/kT3MSsyjAaiVjjDOStQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTe5/Yw2Aa0rrwebondwpBzRS4LtoKjh/4ebZmM9eT0=;
 b=uvcbKB829sK9jOiDlQgd0zHqL7Q6NVUhaIzMyGQ+AS3NPv69YY77K+K77nhnKgcfQegfLpk7Q4Nkw9W6q8RasdwqECuuLRMhybegFS+J4GMWSZbLaQUUep/0cM56GZVyjI4EkxDGFUxVzXcjxjrQMVTYOwLXJjIrGKNThsIUespci2ZqPxhj/q/aC0bZxgrbpZ05pyQ0y0wtLtiO1IaS2ioHVdwwAncXke3zkoPC5uYTEp9Ks3ZciVScqXkGyJ1vvzQGYpdtawXzzXCrKbuNBTKhOxoGquLD2OPr6g8pGWLhKDo1QdKuS47MoTeK4qNRAD9xXerNz9cSYO0kAA7W1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=anton-paar.com; dmarc=pass action=none
 header.from=anton-paar.com; dkim=pass header.d=anton-paar.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anton-paar.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTe5/Yw2Aa0rrwebondwpBzRS4LtoKjh/4ebZmM9eT0=;
 b=a2f31W5QrkHA19RPNxJJqA2mZGR08KYzRk6CxHf7sPWcawFmEuFqbbgM7JkeOwCb5GVgzeBrScKmYD/RGas8eFGZ3M7kt+qY0XvN3XghON33mKyQQ3Bn1DpJE0FK23TfV0/SkttqpAQgaTbQUM2seHnSRQ1ZIfwm9P06KJp1qype5Td50TcejBKz7A11UiwC6EsQ96Ofn75Vj4hariIai6jeE+CrBkAHiVPjc/K3fsJYwEIX39D6KhIfKnZcd29jvjX3Q4V3ej4UZsIRR1jFlI/K+u07httRF3ezFpyT3yQYbwHIJRb6NoqL7EZZhn7ZyHZra95jnZIjNcTsX2ny+Q==
Received: from AM0PR03MB5714.eurprd03.prod.outlook.com (2603:10a6:208:177::23)
 by AS8PR03MB6744.eurprd03.prod.outlook.com (2603:10a6:20b:292::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 04:18:34 +0000
Received: from AM0PR03MB5714.eurprd03.prod.outlook.com
 ([fe80::632b:9566:1361:5740]) by AM0PR03MB5714.eurprd03.prod.outlook.com
 ([fe80::632b:9566:1361:5740%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 04:18:34 +0000
From: "Korber, Markus" <markus.korber@anton-paar.com>
To: Andreas Dilger <adilger@dilger.ca>
CC: Theodore Tso <tytso@mit.edu>, Gabriele Moabiti <gabmoa@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: RE: ext4 data=journal deprecation: long-standing industrial use case
Thread-Topic: ext4 data=journal deprecation: long-standing industrial use case
Thread-Index: AQJe7lEtanpk7txC6V2h/QI8XBITzwFQhtZstfbrjkCAAR5+gIAAJspg
Date: Tue, 20 Oct 2026 04:18:34 +0000
Message-ID:
 <AM0PR03MB57141FD8462BD0C6D075863DDE672@AM0PR03MB5714.eurprd03.prod.outlook.com>
References:
 <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
In-Reply-To: <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
Accept-Language: de-AT, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=anton-paar.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR03MB5714:EE_|AS8PR03MB6744:EE_
x-ms-office365-filtering-correlation-id: d868ea0e-c42c-40cc-a02b-08df2e61351d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|18002099003|22082099003|38070700021|4143699003|10067099003|56012099006;
x-microsoft-antispam-message-info:
 HCIXcvwLn4v0sVtTXljVhErM7QbQm/Z7lhFFBHkTPUhd9j6m56wGXMUNhOebjbJWo2at+y1Clu57rr3XCpxDmBEV/R5o38gS3oZIo8ji0Dmq5/EOnks2kdCOoxPOkb7q6jk8T6NbdXx0MivISgwRg4cd30cpN7JB37DKy8ws7iPwDeX1aNjcoLjgvzdNHC4zQAxfSptZgR05ceFzOO8JU20/5j9ufBqMpwLCiljUmAwbV1MAZijCdgxCtL293FeIHYyrXiztUcoEiCqnfJUWHFFBpHOrm7WBxZnMWpvT9+ZYdtCBhMtH4V4JsUPBNJ8qu1iJ40LpOelQRh0U/VTS7mGftNeMv/5LPAVpGBGqsDoyoKZW6Q/xjSyq2pP3CnWsvwocpkWRBxb851XmzK5i837+2zfe5n4HDqscT4L7VAYrlODZISmirfdeDRcnWdPsj88BWaF7SKaEoMRq3Y21e7FfRhbY5ApseVKnzKhqesiyihDrPOMaADiV6S4m8kTzbpHavTnwerPTALzjs9RQAiigg6B6XIHgw1AfE2kZAIEPKBAxiYtCqSTvEljvKLxeCoHZLyg//EoFBwnflkI98Aj3m7anz5on3WhzhgxUR54vL39WKnLdJNDGEYLXvdojDeM/hg8rpFAafE6C5wydbgGhN4D0+lNBVQxcp4lU5KzLaqtT7AyimQTud6QQ2rEdvWVJ7XQxoyN5MkF6YhYxXnzCp9bc2QWfG8dl3r1QPiI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR03MB5714.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(18002099003)(22082099003)(38070700021)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?amQrZjZ4d0pQR09DVE9kQ2xxN3Nwa2h3Wm9BZ0pPSllqZHZhRlp6OTBlY2Iv?=
 =?utf-8?B?enlPYjU0Y0ZsdnE1MHVna0JZc0lxTWIzLzJlZkdxYWNzZXlZNUVPSWFGVnFl?=
 =?utf-8?B?YmV6czZuamg1dGdYN0I5WjRoTDgvd3BjRW8xWm53elE0emQwWXlHcm9vYVRk?=
 =?utf-8?B?VUVsWmdPQnpIVkRhZS9MZVNSbHN3OVZyT1hNK3NMUzJ1QmZSRE9jMmNaMGtr?=
 =?utf-8?B?WmhNTENyU2c0bjFaeW9ucHB1TDZCQkoxc2dlTVdvYStYb05MM2hib0d1WHpv?=
 =?utf-8?B?Zytxblg5U1Bhc1RCckRFRVp6ZUVwRGtjTE9mMzZZdDQ5ZmhBb3dzTDJrbjY4?=
 =?utf-8?B?R0pqYzZjMXhOU0xTNlZZQ1BhUXNEUmd0RUE4c3JvVWN1UDZkV3JEQ2NUM3VX?=
 =?utf-8?B?NkdOT0xOa3c3bVZ4d3prTEV4TGs2T3p6ZmlxRXVQL3Z5ZTloVHdZM1ZVaTVs?=
 =?utf-8?B?SGFIc1RMMFg0SW5JczhhZE91NmcyYzc5SWlDb2dtVEw4ZFQ4blQrampmbWNB?=
 =?utf-8?B?VWlUR0NFRWRQbVc2SjcwaUJpRmsreHNYQXJxdkE2Z1Yva2EwME9ydXJCenZ3?=
 =?utf-8?B?S0JtaTEyd3hKblFnU2p5WndHeXhyREQzRnNkRVlsbzBqZWNmQzQ4MmdYalRP?=
 =?utf-8?B?eE1PcTY0a1lhN3dmdkZFL0s0Tlk4N0g5RzZic1pLTjd6RW9ZUGJZL3FmdE1s?=
 =?utf-8?B?akQwMU9VOHozZFNlWXJoWVJzdWtaRGovL2VXR1plU01neE45WmJ6VWVLVHg0?=
 =?utf-8?B?Yzg2T1dTKzdYeUZFV1ZKWWNJM3FxUitVaWg2aWV0UnBBWnlCK3RtVTBSMkkr?=
 =?utf-8?B?ZTNNUCtaUkp1RlFyNE4wT0g3RG1iNGFaK24wRmxjNHJtMjY5TWYvcUkrOWlk?=
 =?utf-8?B?czFaWjBDRE4ybTRMbVFrK0x6ZENKME1oSC8zeWlFaVZReGorck13QUxLK1pV?=
 =?utf-8?B?aUdGM0MwUVFHU3VMZjhkWmJaZlN4ZWozYVBSYUxjeTJGRDFPbTE2WUlJTTc5?=
 =?utf-8?B?ZFdlbitZYWxhOTYzNUJaUElleUFUbVVnZEZ3aENVSWxGdW5Td01IRzVBZEU4?=
 =?utf-8?B?VGhaUU1jRjlodUpiZGtSM2w4c2ZSRVNyU2tFLzVBbTZOcVdtZmRtK01mUEo1?=
 =?utf-8?B?WkNtMDMwNUJHVGxxZExIUncvUWsvc1VROTVYUmFBUjZZMGZja01kRFB3Skll?=
 =?utf-8?B?ZytlUnBxMDMxcEdCUWl2VVRIRk5xN2ZsdmZ1Y3psYzZWNHhjODltakdKNlh3?=
 =?utf-8?B?VEExbHQwREM3TGN3aHpTa1RhcVJ6ckptdTE4OTA4VDIvWEVOMDduTFpLeUoz?=
 =?utf-8?B?QzZJWXVNNHVSSHZZNEFEYW5lNDZZMDhsRWEydWh6WmpZcVJTcTRFYmxFVFhx?=
 =?utf-8?B?TUVOUTk2U25JMXAwNFN1UHh1UzZmOXgrSnBxYjBCc21XbjZFZmFJOE5vTVZN?=
 =?utf-8?B?NGpSWU12MnRCTkxRMzRZN2tTK1kxZFk3dERpR0ZVSGJsdlNWSU4vL2ZKV1Yw?=
 =?utf-8?B?ejBwcGx1SDJjcEcyQ01abkVSSWJhU2paWUlvSkozQnBCb2JibWJ3N2VXNHZk?=
 =?utf-8?B?LzErMVlCaUd1ZkNQSGF4eTc3djFyVkd6ZkdielVYb0lzdVFyN3pyRHZ2emhE?=
 =?utf-8?B?VHM1ay9RVXBCSW5QelM2VlhyTER4ZWcxd0dQeXdtVWMwUzJvOFpkNkpJdWY1?=
 =?utf-8?B?eTZRNkJPM0RXcWNXYUxBMHVwOUdHTE92L3NNQWxkSHk1cmxuTXh3STUwaXJn?=
 =?utf-8?B?N0g0ZHlLVjFMa1ZWemFmVzk0TVozK3gzMG1VVldDZ0JGa1dQRDhzak9VSW9q?=
 =?utf-8?B?QkxNRWtZMWRReFlkeHZGdUNrUUdiNEZHYzQ5a2VLSXFXSFhTU1dYTW01ZlZp?=
 =?utf-8?B?Rm1GKytlOVdtRnNuVEhONytHQktOMFhtbTVLcHlneE13alNucVJzTUdJSVgy?=
 =?utf-8?B?ck92bHZZREg4NnVzOE1qKzR1U0JpdlIzYjd1UEx5a0ZKWmVEK2ttKzZuOEli?=
 =?utf-8?B?akJkdG5hZGFFMjdUTTk1VVh0ZklZSlZnQW42Ly9Ea21GSFlnQjNwTHlnSzgz?=
 =?utf-8?B?WS9UcWJwbWlvNDVXZVl4dEw5UEtOU0QyZEZZM01LWTVVUHZPOTJPWGtlRGUz?=
 =?utf-8?B?NU9hQWtuaUtRYzgwckhYNzUzMlRQcTZYTDJEZ2tZVzI5YkZLT2owOVViR3ZF?=
 =?utf-8?B?TWMyQjBGbjNPUXJheDhIdWdTZFZ3T2hFazZlbWtxU1BWd0xZWlE2NTczejVG?=
 =?utf-8?B?RGhRYW9UcjFEYTBTMnJPcXc4eENGZDROZjNxRmFDdGEyUktyL2NuU25lcmpj?=
 =?utf-8?B?V2pmWjRwVnAzUGlhRGdWM0hCTGF4TFNCZ2tKMDhmdzhDb0lOc3NYMzMvR2l5?=
 =?utf-8?Q?/RyJjMImgQnstB3s=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM0PR03MB5714.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d868ea0e-c42c-40cc-a02b-08df2e61351d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2026 04:18:34.7352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1650d056-0824-4040-8341-61f3c6069bbd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zd3O4P7JgsNyPc7EY2hak+Bfy9mVAs6Ib4HSqvaC4gig0g6lm44BkkNLNJny4JG9LFKrjCLBPNMx+dchs7uF/gECKDnZi/fa3rJ5PFuFSkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6744

T24gT2N0IDE5LCAyMDI2LCBBbmRyZWFzIERpbGdlciB3cm90ZToNCg0KPiBhcmUgeW91IHJ1bm5p
bmcgd2l0aCBkZWxhbGxvYyBkaXNhYmxlZCB3aGVuIHRlc3Rpbmcgb3JkZXJlZCBtb2RlPw0KPiBU
aGF0IG1pZ2h0IGJlIHRoZSBzb3VyY2Ugb2YgTlVMcyBpbiByZWNlbnRseSB3cml0dGVuIGZpbGVz
Lg0KDQpObywgd2UgZGlkIG5vdCBleHBsaWNpdGx5IGRpc2FibGUgZGVsYXllZCBhbGxvY2F0aW9u
Lg0KDQpUaGUgZGF0YT1vcmRlcmVkIHRlc3RzIHdlcmUgcnVuIHdpdGg6DQoNCiAgICBkYXRhPW9y
ZGVyZWQsY29tbWl0PTIsbm9hdGltZSxlcnJvcnM9Y29udGludWUNCg0Kc28gZGVsYXllZCBhbGxv
Y2F0aW9uIHNob3VsZCBoYXZlIGJlZW4gZW5hYmxlZCB3aXRoIHRoZSBub3JtYWwgZXh0NA0KZGVm
YXVsdC4NCg0KTWFya3VzDQo=
