Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A902C10F04
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 01:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472F12192D
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 01:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="Uw99IMMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbfBOB5q (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 20:57:46 -0500
Received: from mail-eopbgr30072.outbound.protection.outlook.com ([40.107.3.72]:17254
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726443AbfBOB5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 20:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUI64zD1eJQF+006r8qhDNpO5faHwQKdcgCMcHTNIos=;
 b=Uw99IMMboa7Mw24RWLTUodi7lRQXo5tM72LEs1uwtbg6wpVVOG2SW7zCAoTvlSMc1EfKOxWKjlKUJr75J11/pKCOaddWsw0d9MK7/GOZaaGcILdYqXw2W5Yuv3jM+Z8t1Hhg2hn2Y5FTA+jCXdaBa1yv0viG3ZvJ8FaqTLm1dP4=
Received: from DB7PR06MB5767.eurprd06.prod.outlook.com (20.177.193.208) by
 DB7PR06MB5865.eurprd06.prod.outlook.com (20.178.106.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Fri, 15 Feb 2019 01:57:40 +0000
Received: from DB7PR06MB5767.eurprd06.prod.outlook.com
 ([fe80::c575:c4a8:1776:a21e]) by DB7PR06MB5767.eurprd06.prod.outlook.com
 ([fe80::c575:c4a8:1776:a21e%4]) with mapi id 15.20.1622.018; Fri, 15 Feb 2019
 01:57:40 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Omar Sandoval <osandov@osandov.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Thread-Topic: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Thread-Index: AQHUxEwyy8uC6XsJfEapprTWnlJQYaXgGw8A
Date:   Fri, 15 Feb 2019 01:57:39 +0000
Message-ID: <1190dcc0-7054-72b4-2a88-33d0b97e332c@mendix.com>
References: <cover.1550136164.git.osandov@fb.com>
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6P194CA0103.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::44) To DB7PR06MB5767.eurprd06.prod.outlook.com
 (2603:10a6:10:5f::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d39013a1-8f90-4add-9a15-08d692e8f710
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB5865;
x-ms-traffictypediagnostic: DB7PR06MB5865:
x-ms-exchange-purlcount: 2
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtEQjdQUjA2TUI1ODY1OzIzOnRJUHZOOUN5cnI3QlRjVkYwUVd5bGRjUGVU?=
 =?utf-8?B?VWZENUovRmt0bjNFQUxpcFVQclFYTVJjdm50TWkzZWV0VHU3ZEZIRzZ0ZWhS?=
 =?utf-8?B?R1ZyUEIwaUNkMERxUXdST2FFbnM1NUduOU0vaWVaNzFLc0ZtV2Q1TjY3aDUr?=
 =?utf-8?B?UmZyUE5NUXhld3hCeVpZd3d2ZVFJMytzR1lYT2d6VXFsdHVRdXVqOXJ3MHJp?=
 =?utf-8?B?ODBVaG9neTVXZ3lXUGpXOFpZT2RUZ0RYbERiSjJuMUNLQnZRUVhsWHlvVmFm?=
 =?utf-8?B?bU5YOEpvdngwVTVtMVZjc2hyOTlEV0dqa0hkeWVmbWZVbldZZ0VYelBMN1BW?=
 =?utf-8?B?WFhtVVc0cTluMVBvOXpiRGtVd0haenRQS3dURXpUdXNCOFFuOVBOWWdMdnIx?=
 =?utf-8?B?WDdpQ1hCWTBMQTZFS2orTEFrdUF0Wnc5aWsyMklTY0NGaEh3dUY1YnFxbmk1?=
 =?utf-8?B?SXpvdzVIQmIwQlhsUFN3YkU5cVQ1TlQ5eVA2Qkt2amp6RkF4TytMZkFPQzlC?=
 =?utf-8?B?NlUrUExxVFBIL0l5QWxJRjlXZ21oYW9TVFdQclhqWFZYanF4QWl3cFRTZU0x?=
 =?utf-8?B?K1Y2K0pvZ3pKWXFiYnllWi81cmw3c0tGbjBDZGZIWk1xeFJybzVZTXlEai9u?=
 =?utf-8?B?ZnhXM3Q3Wlc3eFB3bGdNbE9DeEhyYlUzZzNGdDUzeDd5YXowcTZOV1VVUC8r?=
 =?utf-8?B?M2V3T1RFMDd6R1ovUm9JRWo5bUp0U3JzWlgweHRhb2F3MDJaQlFEUmxtT2VG?=
 =?utf-8?B?MnEyeTNRQjJCTWpvYURGK2ltR096RWF4dVNLQms3SWtLZUg5ckdKRk1yVnF6?=
 =?utf-8?B?bnAzRDZDZFpFTXFSY0tpQVFsWk9vNmd5THBNSHowbkdLektEMlNGeXgvNEZx?=
 =?utf-8?B?TFR1ZzFKN20zV1ZWN08wV0dlNjM1WFovc1VUQXlmK0pMM0xxVGhJTjVRRlR0?=
 =?utf-8?B?UzhMTlp4dHJ0TGtkWk9vZE1pT1V1em8wYXVUdFZ6MjJKSThKS1ViaURNNFlJ?=
 =?utf-8?B?cVRENjA0aGpFTDVwTjZoZ3VnSzVUa2dFS0w3OFdLUkUxQ0pOL241cnhvUFpK?=
 =?utf-8?B?VXZkaStodHBRTXVPUUY4VXNLbld3TDNxZ2c4TGxBTjNNSzIwNGJLNkhtbmFT?=
 =?utf-8?B?UXdGR2NnQkI0RkdDdGZSN2dCRVJwRTdKeHI0L3NWV0d5QUFKT24xUS9pYmdT?=
 =?utf-8?B?MGExakc0VHVkdlBvTVRycGNLTjJEaGR2NlpsdU1HK29LSnlkSTVxbE9zVjk1?=
 =?utf-8?B?RVBsUlNLZ1lPYnJEempRbHVtSjJQbTNGMVhWbHZHWVlGcFNrZTY5U2ZLam0y?=
 =?utf-8?B?aGV0NmtaYnJBV2pnL3ZQdzAvUkl0OEROVUd6WXJrNFdHRnRVdjhEa0xDK0Fr?=
 =?utf-8?B?Z2dib1IwNldGTXppU3VrTDFmU28xNDQrUDNmejFkZXc0dU5RWHhxN2RpVUhY?=
 =?utf-8?B?N0VFMnhsSWJlWFpGUHMvTTE5NVhZN0wzd0hYVE5MVEo1MjBQRVkxY1JIZ29M?=
 =?utf-8?B?ZUEzZUJkTDNyRlVuNnBJb3ZTRlBoUkZxN3pSSUhQOEFaU3d1UVpsdUhOZlVs?=
 =?utf-8?B?TGgxaktoU3NNUmduWDVYMDI0QVNBREFadHBBT0RZSUI4bU1WSmJJd08wUmhX?=
 =?utf-8?B?MysxY2QxeFBOQXl5TGtaNVJhWUgxZnB2K0Y2blAxZVJMSm9aU2FidzRUclZx?=
 =?utf-8?B?b2ZQMHNOREcveDRBL1FHWlQvaFI1anFkV1VTb3FoWkNiTnl2SVpOV1dsREFs?=
 =?utf-8?B?YXlET2lxNTZ3Wi94LzZTSnhSYXh3ZFZMRzd5SjdNTmlCQnhmdlFoM2VTamNK?=
 =?utf-8?B?MThGa1NpVzl1Q2E3U290QUR6NklsSTJlU1E0c2t2N1p2aVJOTFBLTTRncjBl?=
 =?utf-8?B?eU9kZ3E1VkVpUmVHYW9NN1I5TElOVkd0cG9MYzRGNk80RnFmUjlwU3RodWw1?=
 =?utf-8?B?UFNBMVl1b3BRPT0=?=
x-microsoft-antispam-prvs: <DB7PR06MB586550088A17FA644C0755C3D4600@DB7PR06MB5865.eurprd06.prod.outlook.com>
x-forefront-prvs: 09497C15EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(366004)(39850400004)(396003)(376002)(199004)(189003)(53936002)(6436002)(966005)(106356001)(97736004)(65826007)(229853002)(72206003)(105586002)(64126003)(6116002)(478600001)(31696002)(86362001)(68736007)(25786009)(6306002)(6512007)(36756003)(2501003)(2906002)(14454004)(305945005)(65956001)(65806001)(81156014)(31686004)(8676002)(7736002)(71190400001)(4326008)(486006)(11346002)(52116002)(14444005)(256004)(217873002)(99286004)(6506007)(58126008)(6486002)(316002)(53546011)(76176011)(386003)(446003)(46003)(71200400001)(476003)(6246003)(110136005)(81166006)(54906003)(102836004)(2616005)(8936002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB5865;H:DB7PR06MB5767.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dnETkM6cfUjtFvfjjLpNbgiBfsN6d2pjopwqQ2v5m48Yu+eswlw4IYDE1B2tgpUMv/rHjesTppYP2hRNPi+YeTDN2Rez5dYoAVRF6JLEl1jmu+3VABi2B0szbaF1ZYRAvoJQk/24Pc0hGyvgQnP2Bq8hJ2k8Ei9sba24F5RwTrpqcCIft/g3/sfSpv3zV8tDedZnV/i+dmdS5OBI9zSsa7jA7ioLYp9x14v1/MiQxrCmtff34Btbf6fO2vDZlggLyD4iE3ZWFRKxT57YrRpRaC//c5YuBWESfzKZXtVrBgYoxkSaHe3hDBJnNICbPuBhZvwTa3rA8w0IZ2/CUnVgSvA3mEqT/DO4FupcXnytD6lRGBjEwwiCgXccFMQp7uCZJWLLyleFi19f+GChNguWnlNm8ZAcrAs8VdOf1sDTMTQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FEA03B290DAE14C969E15CD47BE9B4F@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39013a1-8f90-4add-9a15-08d692e8f710
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2019 01:57:39.0689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5865
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

SGksDQoNCk9uIDIvMTQvMTkgMTE6MDAgQU0sIE9tYXIgU2FuZG92YWwgd3JvdGU6DQo+IEZyb206
IE9tYXIgU2FuZG92YWwgPG9zYW5kb3ZAZmIuY29tPg0KPiANCj4gU2luY2Ugc3RhdHggd2FzIGFk
ZGVkIGluIDQuMTEsIHVzZXJzcGFjZSBoYXMgaGFkIGFuIGludGVyZmFjZSBmb3INCj4gcmVhZGlu
ZyBidGltZSAoZmlsZSBjcmVhdGlvbiB0aW1lKSwgYnV0IG5vIHdheSB0byBzZXQgaXQuIFRoaXMg
UkZDIHBhdGNoDQo+IHNlcmllcyBhZGRzIHN1cHBvcnQgZm9yIGNoYW5naW5nIGJ0aW1lIHdpdGgg
dXRpbWVuc2F0KCkuIFBhdGNoIDEgYWRkcw0KPiB0aGUgVkZTIGluZnJhc3RydWN0dXJlLCBwYXRj
aCAyIGFkZHMgdGhlIHN1cHBvcnQgdG8gdXRpbWVuc2F0KCkgd2l0aCBhDQo+IG5ldyBmbGFnLCBh
bmQgdGhlIHJlc3Qgb2YgdGhlIHBhdGNoZXMgYWRkIGZpbGVzeXN0ZW0gc3VwcG9ydDsgSSBleGNs
dWRlZA0KPiBDSUZTIGZvciBub3cgYmVjYXVzZSBJIGRvbid0IGhhdmUgYSBDSUZTIHNldHVwIHRv
IHRlc3QgaXQgb24uDQo+IA0KPiBVcGRhdGluZyBidGltZSBpcyB1c2VmdWwgZm9yIGF0IGxlYXN0
IGEgY291cGxlIG9mIHVzZSBjYXNlczoNCj4gDQo+IC0gQmFja3VwL3Jlc3RvcmUgcHJvZ3JhbXMg
KG15IG1vdGl2YXRpb24gZm9yIHRoaXMgZmVhdHVyZSBpcyBidHJmcyBzZW5kKQ0KDQpDYW4geW91
IGdpdmUgYW4gZXhhbXBsZSBvZiBzdWNoIHVzZWZ1bG5lc3M/IFdoYXQncyB0aGUgdGhpbmcgeW91
IHJ1bg0KaW50byB0aGF0IHlvdSBjYW4ndCBkbyB3aXRob3V0IGhhdmluZyB0aGlzPw0KDQpZb3Ug
Z3V5cyBhcmUgaGF2aW5nIGEgdGVjaG5pY2FsIGRpc2N1c3Npb24gYWJvdXQgJ2ltcGxlbWVudGF0
aW9uIG9yIHRoZQ0KaW50ZXJmYWNlJyBpbiB0aGlzIHRocmVhZCwgd2hpbGUgSSdtIHdvbmRlcmlu
ZyB3aGF0IEknbSBtaXNzaW5nIGFzIGJ0cmZzDQpzZW5kL3JlY2VpdmUgdXNlciBieSBub3QgaGF2
aW5nIHRoaXMuIEkgbmV2ZXIgbmVlZGVkIGl0IGluIG15IHVzZSBjYXNlcy4NCg0KVGhlcmUncyB0
d28gbGV2ZWxzIG9mIHVzZSBjYXNlIGhpZGRlbiBpbiB0aGUgYWJvdmUgbGluZS4gU28sIEkgZG9u
J3QNCm1lYW4gd2h5IGJ0cmZzIHNlbmQvcmVjZWl2ZSBpcyB1c2VmdWwgKGl0IGlzLCBmb3IgcXVp
Y2sgZWZmaWNpZW50DQpyZXBsaWNhdGlvbiBvZiBjaGFuZ2VzKSBidXQsIHdoYXQncyBhbiBpbXBv
cnRhbnQgdXNlY2FzZSBmb3IgYnRpbWUgb24NCnRvcCBvZiB0aGF0Pw0KDQo+IC0gRmlsZSBzZXJ2
ZXJzIHdoaWNoIGludGVyb3BlcmF0ZSB3aXRoIG9wZXJhdGluZyBzeXN0ZW1zIHRoYXQgYWxsb3cN
Cj4gICB1cGRhdGluZyBmaWxlIGNyZWF0aW9uIHRpbWUsIGluY2x1ZGluZyBNYWMgT1MgWzFdIGFu
ZCBXaW5kb3dzIFsyXQ0KPiANCj4gSSd2ZSBhbHNvIGluY2x1ZGVkIGEgbWFuIHBhZ2UgcGF0Y2gs
IHhmc19pbyBzdXBwb3J0LCBhbmQgYW4geGZzdGVzdC4NCj4gDQo+IFRob3VnaHRzIG9uIHRoZSBp
bXBsZW1lbnRhdGlvbiBvciB0aGUgaW50ZXJmYWNlPw0KPiANCj4gVGhhbmtzIQ0KPiANCj4gMTog
aHR0cHM6Ly9kZXZlbG9wZXIuYXBwbGUuY29tL2xpYnJhcnkvYXJjaGl2ZS9kb2N1bWVudGF0aW9u
L1N5c3RlbS9Db25jZXB0dWFsL01hblBhZ2VzX2lQaG9uZU9TL21hbjIvc2V0YXR0cmxpc3QuMi5o
dG1sDQo+IDI6IGh0dHBzOi8vZG9jcy5taWNyb3NvZnQuY29tL2VuLXVzL3dpbmRvd3MvZGVza3Rv
cC9hcGkvZmlsZWFwaS9uZi1maWxlYXBpLXNldGZpbGV0aW1lDQo+IA0KPiBPbWFyIFNhbmRvdmFs
ICg2KToNCj4gICBmczogYWRkIGJ0aW1lIHRvIHN0cnVjdCBpYXR0cg0KPiAgIGZzOiBhZGQgQVRf
VVRJTUVfQlRJTUUgZm9yIHV0aW1lbnNhdCgpDQo+ICAgQnRyZnM6IGFkZCBzdXBwb3J0IGZvciBz
ZXR0aW5nIGJ0aW1lDQo+ICAgZXh0NDogYWRkIHN1cHBvcnQgZm9yIHNldHRpbmcgYnRpbWUNCj4g
ICBmMmZzOiBhZGQgc3VwcG9ydCBmb3Igc2V0dGluZyBidGltZQ0KPiAgIHhmczogYWRkIHN1cHBv
cnQgZm9yIHNldHRpbmcgYnRpbWUNCj4gDQo+ICBmcy9hdHRyLmMgICAgICAgICAgICAgICAgICAg
ICAgfCAgNiArKysNCj4gIGZzL2J0cmZzL2lub2RlLmMgICAgICAgICAgICAgICB8ICAyICsNCj4g
IGZzL2J0cmZzL3N1cGVyLmMgICAgICAgICAgICAgICB8ICA0ICstDQo+ICBmcy9leHQ0L2lub2Rl
LmMgICAgICAgICAgICAgICAgfCAxNSArKysrKy0NCj4gIGZzL2V4dDQvc3VwZXIuYyAgICAgICAg
ICAgICAgICB8ICAyICstDQo+ICBmcy9mMmZzL2ZpbGUuYyAgICAgICAgICAgICAgICAgfCAxOSAr
KysrKystLQ0KPiAgZnMvZjJmcy9zdXBlci5jICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gIGZz
L3V0aW1lcy5jICAgICAgICAgICAgICAgICAgICB8IDg2ICsrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0NCj4gIGZzL3hmcy9saWJ4ZnMveGZzX2Zvcm1hdC5oICAgICB8ICAyICstDQo+
ICBmcy94ZnMvbGlieGZzL3hmc19sb2dfZm9ybWF0LmggfCAgMiArLQ0KPiAgZnMveGZzL3hmc19p
b3BzLmMgICAgICAgICAgICAgIHwgMTEgKysrKy0NCj4gIGZzL3hmcy94ZnNfc3VwZXIuYyAgICAg
ICAgICAgICB8ICAyICstDQo+ICBpbmNsdWRlL2xpbnV4L2ZzLmggICAgICAgICAgICAgfCAgNCAr
Kw0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L2ZjbnRsLmggICAgIHwgIDIgKw0KPiAgMTQgZmlsZXMg
Y2hhbmdlZCwgMTExIGluc2VydGlvbnMoKyksIDQ4IGRlbGV0aW9ucygtKQ0KPiANCg0KDQotLSAN
CkhhbnMgdmFuIEtyYW5lbmJ1cmcNCg==
