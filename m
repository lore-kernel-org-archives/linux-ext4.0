Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9506C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 18:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F4A52192C
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 18:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="hCRvaWI5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbfBOSZ0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 13:25:26 -0500
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:64320
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388405AbfBOSZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 15 Feb 2019 13:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1pnFuVQn6mwBWmhArg6PuWd5aRs7crgF1OfviLcxHE=;
 b=hCRvaWI5/LQHinFAxwHjgmQ+Yi8TN8WvtLi5rRdZwDzFV+fgjkPrcrRi1F7umazGtTi38+WcKn1es/FOxUft9BCTjeLXkegqIcCFQmjJSgMvM1QkezB1C0wfNfDY6KXx9qvDohlPY135BZgmKbG8lhfNVM3C/4eDSR/8tOD0yeY=
Received: from DB7PR06MB5767.eurprd06.prod.outlook.com (20.177.193.208) by
 DB7PR06MB6011.eurprd06.prod.outlook.com (20.178.107.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Fri, 15 Feb 2019 18:25:19 +0000
Received: from DB7PR06MB5767.eurprd06.prod.outlook.com
 ([fe80::c575:c4a8:1776:a21e]) by DB7PR06MB5767.eurprd06.prod.outlook.com
 ([fe80::c575:c4a8:1776:a21e%4]) with mapi id 15.20.1622.018; Fri, 15 Feb 2019
 18:25:19 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Omar Sandoval <osandov@osandov.com>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Thread-Topic: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Thread-Index: AQHUxEwyy8uC6XsJfEapprTWnlJQYaXgK9IAgAAtUgCAANXagA==
Date:   Fri, 15 Feb 2019 18:25:18 +0000
Message-ID: <d0f971c8-5b86-0f4f-7009-fdb199b7e820@mendix.com>
References: <cover.1550136164.git.osandov@fb.com>
 <1190dcc0-7054-72b4-2a88-33d0b97e332c@mendix.com>
 <20190215053950.GF9819@vader>
In-Reply-To: <20190215053950.GF9819@vader>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6PR08CA0027.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::15) To DB7PR06MB5767.eurprd06.prod.outlook.com
 (2603:10a6:10:5f::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52815c91-cd30-4a88-9f1a-08d69372ef0e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB6011;
x-ms-traffictypediagnostic: DB7PR06MB6011:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtEQjdQUjA2TUI2MDExOzIzOjRqTVNxYXdpc1pEZ2RaOS82THhHaFNYMXUy?=
 =?utf-8?B?akI2RWZLc1I0dWlEdW5nQnhsU1ovdXI2MkJkY055eUhkcjZncHBZQkliQ2Fp?=
 =?utf-8?B?UUZDb0xkdk1ZNEZwUmtrenNNWk9hSy9OTWVrNWdXellIQ1V3QTdXdk1FQWp6?=
 =?utf-8?B?ejF3c3V0cFpHZkZaVHFLUHJ0dWRJbEJoSTBkNHNXeHp6eGNNU21UVXFyUGRK?=
 =?utf-8?B?WmZXS2VZNDJtRHZ3MXdiMVpxSTExNytNd2N4SWx2UEFTaGZQcWh6c29DeXJM?=
 =?utf-8?B?N2N5RnQ0aE5KVlZYbFNtNUhLMnVmUFlrcjBsVUdYZ0FwcThpTVNNd0pwMDhr?=
 =?utf-8?B?c3ExZnFkQmhqYnFXRW9wbGZjOXFCT1BvOEVKK0RVNDFCWUQ5RkJ0akhrbFNG?=
 =?utf-8?B?dTBPNHV5WWExT2s2N2lzV3RQVGhZWUpTWTl6a2JZVmlSU0RGUGZ2UGJySG1U?=
 =?utf-8?B?R2ZKNHBKSkRUNkFYdTRtNGZMbWhFdS9sMU4wMmxxZUtWQ3VIbkd2c2hDL21q?=
 =?utf-8?B?RTN6TGFDTkpPeTN3ZXd2UmdIRExqWHptcnFqQnpFV3hmS1ZKRytsZzJ5bTZF?=
 =?utf-8?B?alhIQ3d3YWFtdmJqS0JpbFJHejA2YXRmVW0wQmpCeS9iRkk2dThIeGJ3Lyth?=
 =?utf-8?B?VW9hbTJDMDlDcjdtTi9Cc1ErWnZCbmtieDcrMGNnNENlaFFpZFBBYWs0QzRM?=
 =?utf-8?B?dGVnM0JiZmY4bTh3R1I3SUUwbUVLV3BsNUVkeG9yUm8vdnNGbW9iUExyZ0Ro?=
 =?utf-8?B?dGE0SEtqWDhCbENHODg3TGk4QkV2T0NmbUM2VzlvRTFGcXYzTUVyRlU5V2Nx?=
 =?utf-8?B?VzNhZFdib2VnMUJNVUZkcE5SRWlLQ0hIYVg5NHU2QlJCeWd6ZzFQZ2QrbFBq?=
 =?utf-8?B?bWUxVnd5aXMwb0lYQTVQRjlpNHFqTThqRWU4bmxrNHcwZTFneGxYOSsvSXVO?=
 =?utf-8?B?RzhZY3ZvaUlCclhqTWhkSTI3RGFmZmYwbDZtTFcrQVRmYlhOS0tWaUpsVVZ0?=
 =?utf-8?B?RXVjdHkwWnV2SEdFM2cwUU5iTGo0aisxWm0zUnMzUGY1WVBLTlhONEZ6VWRk?=
 =?utf-8?B?UHRnY0xTeXhpMVJnbHcrVmNNTDRGVitjSWFRdEVXL2N0M3RZQ21PNGxIZkJ0?=
 =?utf-8?B?Y2lzR0lGbGN4SC9wYXhtejN1UWtzWGl3MUYrdmRxRGJuZ2tEOFFQY0J2ME5y?=
 =?utf-8?B?WGU1Y0gvY28wM01md0VWem9aODZIdStaMjVBSDhFb1VtRE5PUFU5c2ZyUjBB?=
 =?utf-8?B?dEdLU0drMGxFbFZqQm44NFM2d21NUFF6NFZadnRITm9mOTFESTV0endaa0Jq?=
 =?utf-8?B?blh4T0hUUFl4WTVSdmI1TVUwY0MvN0pnUXlpZEE5Y0NFOVlDRzcrUUNzNWVz?=
 =?utf-8?B?VlhveEU5cVpscXFJeTV3eFhTdCtXSW9UUEF0MG4wNnhEWklWMTU0REdyNVFI?=
 =?utf-8?B?dWhnWWV5WTJQcjMrNndWcm5CdjRUck92Vk9pVFk3Qks5WFN6TnRRT3ZlTXN3?=
 =?utf-8?B?blUvQ2J1U284eVp4aUp1UnlmdFBsazdzdTl1OTludE51alhidWlrRGVFYnFR?=
 =?utf-8?B?dGhOTXZranpSSFdNeVV1ZkVoK0ZSVlBBVWkzWDBlcVd5OHc2bjByU3AwSE94?=
 =?utf-8?B?TVRuMlFDcGxFb1VGNFh0SXNKOGh4R0RBaXRVZTVFR3kxNVlyOEhQdDZ3Mkgx?=
 =?utf-8?B?OW95UDJraFFZZHJWVkVFaFZmTGYxMEpnbnVpbStSMllMRlVwanh5QVIxcTdC?=
 =?utf-8?B?S2dyTTRYbC9ZUlZhY3BSbmJXR2hJRlZMa2krNm12bCttNHI1bGc1UlFNdVM3?=
 =?utf-8?B?NW5MT2t5bSttdzl6VFJ3SDVjTW5MZTlnNnpVUjRKZU5tRno5RSt5aW1LTFAx?=
 =?utf-8?Q?M1CsLeiVTta3d1Dlb3bePoTbY8TF+wLE?=
x-microsoft-antispam-prvs: <DB7PR06MB6011B72C1C5A5C3D38DC95BED4600@DB7PR06MB6011.eurprd06.prod.outlook.com>
x-forefront-prvs: 09497C15EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39850400004)(396003)(366004)(51914003)(199004)(189003)(217873002)(8676002)(106356001)(8936002)(99286004)(68736007)(81156014)(53546011)(65826007)(186003)(81166006)(6486002)(386003)(25786009)(86362001)(2906002)(6506007)(31696002)(31686004)(305945005)(7736002)(229853002)(105586002)(6916009)(97736004)(65956001)(65806001)(53936002)(46003)(11346002)(6512007)(54906003)(6436002)(256004)(476003)(14444005)(76176011)(446003)(14454004)(2616005)(58126008)(52116002)(6246003)(316002)(64126003)(478600001)(102836004)(71190400001)(71200400001)(72206003)(36756003)(4326008)(6116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB6011;H:DB7PR06MB5767.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XiBlu9/hRqqxl28LFk6WheutPWc2NVdc8jGNXFr1T/gdjvjNaVSDiXW+KZiUhoaw8yJVP2L4STWcxZ/dJX53x/U0tm55o4DRfhuR6QbbzSErlJk6pFeJwubd00sVuwKT1m5bQ8WgSBPS7dv45olkn09e2ZZruo5hyajMEXjEJpNWeSFMLvREkQbhsrJ31O6cf3n8o/yto7XFnzOv8l2OvjxywjtVcK1MT3IiSpQXjEKgUq3NLHgi2uE/x9snFPafVsp20UTefxazLcQUWA/OCRwveHDdl/7YszEBtPFT7LokgYydOpS4S/2DA4Jprn0JMZjyQxI9WG3Vi82SLWqslaLZp6SjaDhQXEAb6ly9RWuXo1wb2+P767Z4mzdBDybKMCI2Hkisy7VE0onK2teGIPJb8p7rpVeYXfNdTAfeL78=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAC717E3C0B1D14DA7B8988A46B27A8D@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52815c91-cd30-4a88-9f1a-08d69372ef0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2019 18:25:16.1118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB6011
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

T24gMi8xNS8xOSA2OjM5IEFNLCBPbWFyIFNhbmRvdmFsIHdyb3RlOg0KPiBPbiBGcmksIEZlYiAx
NSwgMjAxOSBhdCAwMTo1NzozOUFNICswMDAwLCBIYW5zIHZhbiBLcmFuZW5idXJnIHdyb3RlOg0K
Pj4gSGksDQo+Pg0KPj4gT24gMi8xNC8xOSAxMTowMCBBTSwgT21hciBTYW5kb3ZhbCB3cm90ZToN
Cj4+PiBGcm9tOiBPbWFyIFNhbmRvdmFsIDxvc2FuZG92QGZiLmNvbT4NCj4+Pg0KPj4+IFNpbmNl
IHN0YXR4IHdhcyBhZGRlZCBpbiA0LjExLCB1c2Vyc3BhY2UgaGFzIGhhZCBhbiBpbnRlcmZhY2Ug
Zm9yDQo+Pj4gcmVhZGluZyBidGltZSAoZmlsZSBjcmVhdGlvbiB0aW1lKSwgYnV0IG5vIHdheSB0
byBzZXQgaXQuIFRoaXMgUkZDIHBhdGNoDQo+Pj4gc2VyaWVzIGFkZHMgc3VwcG9ydCBmb3IgY2hh
bmdpbmcgYnRpbWUgd2l0aCB1dGltZW5zYXQoKS4gUGF0Y2ggMSBhZGRzDQo+Pj4gdGhlIFZGUyBp
bmZyYXN0cnVjdHVyZSwgcGF0Y2ggMiBhZGRzIHRoZSBzdXBwb3J0IHRvIHV0aW1lbnNhdCgpIHdp
dGggYQ0KPj4+IG5ldyBmbGFnLCBhbmQgdGhlIHJlc3Qgb2YgdGhlIHBhdGNoZXMgYWRkIGZpbGVz
eXN0ZW0gc3VwcG9ydDsgSSBleGNsdWRlZA0KPj4+IENJRlMgZm9yIG5vdyBiZWNhdXNlIEkgZG9u
J3QgaGF2ZSBhIENJRlMgc2V0dXAgdG8gdGVzdCBpdCBvbi4NCj4+Pg0KPj4+IFVwZGF0aW5nIGJ0
aW1lIGlzIHVzZWZ1bCBmb3IgYXQgbGVhc3QgYSBjb3VwbGUgb2YgdXNlIGNhc2VzOg0KPj4+DQo+
Pj4gLSBCYWNrdXAvcmVzdG9yZSBwcm9ncmFtcyAobXkgbW90aXZhdGlvbiBmb3IgdGhpcyBmZWF0
dXJlIGlzIGJ0cmZzIHNlbmQpDQo+Pg0KPj4gQ2FuIHlvdSBnaXZlIGFuIGV4YW1wbGUgb2Ygc3Vj
aCB1c2VmdWxuZXNzPyBXaGF0J3MgdGhlIHRoaW5nIHlvdSBydW4NCj4+IGludG8gdGhhdCB5b3Ug
Y2FuJ3QgZG8gd2l0aG91dCBoYXZpbmcgdGhpcz8NCj4gDQo+IFRoYXQgYm9pbHMgZG93biB0byB3
aGF0J3MgdXNlZnVsIGFib3V0IGhhdmluZyB0aGUgZmlsZSBjcmVhdGlvbiB0aW1lLA0KPiBhbmQg
aXQncyByZWFsbHkganVzdCBhbm90aGVyIHRpZGJpdCBvZiBpbmZvcm1hdGlvbiB3aGljaCB5b3Ug
bWF5IG9yIG1heQ0KPiBub3QgY2FyZSBhYm91dC4gTWF5YmUgeW91IGhhdmUgYSBkb2N1bWVudCB0
aGF0IHlvdSd2ZSBiZWVuIGVkaXRpbmcgZm9yDQo+IGF3aGlsZSwgYW5kIHlvdSB3YW50IHRvIGtu
b3cgd2hlbiB5b3Ugc3RhcnRlZCB3b3JraW5nIG9uIGl0LiBPciwgeW91DQo+IHdhbnQgdG8ga25v
dyB3aGVuIGEgdXNlciBjcmVhdGVkIHNvbWUgZGlyZWN0b3J5IHRoYXQgdGhleSBrZWVwIGFkZGlu
Zw0KPiBmaWxlcyB0by4NCj4gDQo+IElmIHRoZSBmaWxlIGNyZWF0aW9uIHRpbWUgaXMgdXNlZnVs
IHRvIHlvdSwgdGhlbiB5b3UgbGlrZWx5IHdhbnQgaXQNCj4gcHJlc2VydmVkIGlmIHlvdSBoYXZl
IHRvIHJlc3RvcmUgZnJvbSBiYWNrdXBzLiBJZiBJIGhhZCB0byByZXN0b3JlIGZyb20NCj4gYmFj
a3VwcyB5ZXN0ZXJkYXkgYW5kIEknbSB0cnlpbmcgdG8gZmlndXJlIG91dCB3aGVuIEkgc3RhcnRl
ZCB0aGF0DQo+IGRvY3VtZW50LCBJIGRvbid0IGNhcmUgdGhhdCBJIHJlc3RvcmVkIHRoYXQgZmls
ZSB5ZXN0ZXJkYXksIEkgd2FudCB0aGUNCj4gcmVhbCBjcmVhdGlvbiBkYXRlLg0KPiANCj4gSWYg
eW91J3ZlIG5ldmVyIHdvbmRlcmVkIHdoZW4gYSBmaWxlIHdhcyBjcmVhdGVkLCB0aGVuIEknbSBz
dXJlIHlvdQ0KPiB3b24ndCBjYXJlIHdoZXRoZXIgYnRyZnMgc2VuZC9yZWNlaXZlIHByZXNlcnZl
cyBpdCA6KQ0KDQpUaGFua3MgZm9yIHRoZSBlbGFib3JhdGUgYW5zd2VyLiBJIHdhcyBqdXN0IGN1
cmlvdXMgaWYgdGhpcyB3YXMgdG8gbWFrZQ0Kc2VuZCAibW9yZSBmZWF0dXJlIGNvbXBsZXRlIiBv
ciBpZiB0aGVyZSB3YXMgc29tZXRoaW5nIGVsc2Ugc3BlY2lhbCB0bw0KaXQsIGFuZCBpdCBzZWVt
cyB0byBiZSB0aGUgZmlyc3Qgb25lLiA7XQ0KDQpBbmQgZm9yIG15c2VsZiwgSSBtb3N0bHkgdHJl
YXQgYnRyZnMgc2VuZC9yZWNlaXZlIGxpa2UgYSBpbXByb3ZlZA0KcmVwbGFjZW1lbnQgZm9yIHJz
eW5jIGFuZCB1c3VhbGx5IGRvbid0IGNhcmUgdGhhdCBtdWNoIGFib3V0IGJ0aW1lICBpbmRlZWQu
DQoNClRoYW5rcywNCi0tIA0KSGFucyB2YW4gS3JhbmVuYnVyZw0K
