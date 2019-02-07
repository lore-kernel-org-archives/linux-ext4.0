Return-Path: <SRS0=8lV0=QP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35664C169C4
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Feb 2019 04:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FC3821916
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Feb 2019 04:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfBHEKQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Feb 2019 23:10:16 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:49780 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726793AbfBHEKP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2019 23:10:15 -0500
X-Greylist: delayed 22691 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2019 23:10:14 EST
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x17Lk7qP029423;
        Thu, 7 Feb 2019 21:51:59 GMT
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        by mx0b-002e3701.pphosted.com with ESMTP id 2qgtnxh4ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Feb 2019 21:51:58 +0000
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com [16.197.64.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2354.austin.hpe.com (Postfix) with ESMTPS id 348E8B4;
        Thu,  7 Feb 2019 21:51:58 +0000 (UTC)
Received: from G9W8456.americas.hpqcorp.net (2002:10d8:a15f::10d8:a15f) by
 G2W6309.americas.hpqcorp.net (2002:10c5:4033::10c5:4033) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Thu, 7 Feb 2019 21:51:58 +0000
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (15.241.52.10) by
 G9W8456.americas.hpqcorp.net (16.216.161.95) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Thu, 7 Feb 2019 21:51:57 +0000
Received: from TU4PR8401MB0607.NAMPRD84.PROD.OUTLOOK.COM (10.169.44.137) by
 TU4PR8401MB1120.NAMPRD84.PROD.OUTLOOK.COM (10.169.48.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 21:51:55 +0000
Received: from TU4PR8401MB0607.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f5e1:9059:8c64:1c71]) by TU4PR8401MB0607.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f5e1:9059:8c64:1c71%2]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 21:51:55 +0000
From:   "Kani, Toshi" <toshi.kani@hpe.com>
To:     "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
Thread-Topic: [LSF/MM TOPIC] The end of the DAX experiment
Thread-Index: AQHUvmDRoPtITM9aSECll6lKVoCE0aXU4asA
Date:   Thu, 7 Feb 2019 21:51:54 +0000
Message-ID: <d7790ae27161db2fcf0b10a7d5d67de833f2d3fe.camel@hpe.com>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.219.147.3]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TU4PR8401MB1120;6:+QfvfiFlfVqyHg2SQiaaNTptd5Te7769xrURlKFlmn5bQOrkkpcxXmPXBEJwjiX4vALMBEwPk7XKQXQY6IvWzvSW7Qnt3+7/gje0rygxKpoj+wC32qMxkwVqDYz01LbskDfTFmUx0Ye/E25/uUyJmQmC3Rw3tlTMwxn5gU92d9Sw4TfYeVnzkoNA5slKcs6zBwpP3M5bhyQVEJrzIX9A1hMJEWzVWwBGzssda2e3ardX4/pleD2zYxVgzKh3QWFJ3ov3fCmMP0MxXJ6Q+Uy4D6csDu7Wh2NsHfU6vZxR0mU18TotAmORZUyjfhVxUt0drFumn08MLY73pvHg1D98i1wlr0iFyCds94Fa8SkWvE3xTfBDB2V3KxwGIdD10olvGCmPJ8SoV+u5i2dtm0haMHyMOoF2qfQBeRIC5xxE3B30/+oLwIBk3qYoMauRVF0f3mKeRzJCQFZVwvxTrTA2pg==;5:N5SDbWflqZbGFz0R6Li4RhNVJbMHyXCtUuHadNcLD36Qcp2yt9h6yp1qRhNJXvo/GZzI3CeZQHMurZERHtATfqXWjnkMZQYtM7tvGLFEil5zKyJHCZ/8+kJC8orGO+7wxrvh6DzfcVOWCGoFN50FjAwUSqW+Tqm1C/UxEv6TmDAPFchTq0QTY1PInzcSW4rts4FSzB5wJnhjQRyBFdqlpg==;7:Vzynm416z9ZkiCX8noXGvpeKlwDS8ucsX77Yk/JTaAxKSLmseigWcG/g4P4IMq0MXeE1s5fYWGnpInQhCtj12Ao0GPeuousXjSD1HXHLKH47Ei7iu7EXkGYLTrcPtsgTl9yCmyjtCPOu/ViIINH8Gw==
x-ms-office365-filtering-correlation-id: 51b906c0-d1e2-4145-abcb-08d68d4679d5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:TU4PR8401MB1120;
x-ms-traffictypediagnostic: TU4PR8401MB1120:
x-microsoft-antispam-prvs: <TU4PR8401MB112054C050EBD9EFBBB98E9282680@TU4PR8401MB1120.NAMPRD84.PROD.OUTLOOK.COM>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(39860400002)(366004)(189003)(199004)(2501003)(316002)(53936002)(97736004)(66066001)(561944003)(6116002)(102836004)(86362001)(6512007)(3846002)(8936002)(478600001)(7736002)(6436002)(36756003)(305945005)(106356001)(256004)(14444005)(486006)(26005)(105586002)(71190400001)(71200400001)(6506007)(6486002)(76176011)(14454004)(4326008)(6246003)(68736007)(81156014)(8676002)(81166006)(446003)(118296001)(2906002)(54906003)(229853002)(11346002)(476003)(25786009)(2616005)(186003)(110136005)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB1120;H:TU4PR8401MB0607.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eAJEF5Q3c92yBA/obEvP0EV+dGVCEe+WIp3PJJ46M1mRvFGa28+gjrXSyDzOy03BFthbBpdfqwhlWo6H9Dzj6k3W30LdaC6WUnezFJRSc6oru/yb3EkpHDddMf6Pp9/RtRaGmKiwvuRNFWhWhFoQF2EmFuIhbKHnnbJ4o96brvhNKrRbaDOoQDe3mFhiJXt1XrBIegP5MY0PHpapiV/Rbj4w897JcZOJdWoKos0ILobVRhhNxBUVc8NltfBhzOtES753hNAe4nR6aYz+NJhIxcSzTu4XWrwIG5T+OWtUDkT61MvRHKhFZ2bZcQqiGIbMo5cJDb3+N/8PiRLwrz0kuD6QFl7b+aaEnszn7k6eloe+Kjg4PCmkcMk1txDpze9xz0YRhZHznB8dHiyMeLm4CEBEzAhf4r+2uCshiIqwJwc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8985FFB9EA129A48918CC8ABDA67F384@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b906c0-d1e2-4145-abcb-08d68d4679d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 21:51:54.8925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1120
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-07_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902070157
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

T24gV2VkLCAyMDE5LTAyLTA2IGF0IDEzOjEyIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEJlZm9yZSBwZW9wbGUgZ2V0IHRvbyBleGNpdGVkIHRoaXMgaXNuJ3QgYSBwcm9wb3NhbCB0byBr
aWxsIERBWC4gVGhlDQo+IHRvcGljIHByb3Bvc2FsIGlzIGEgZGlzY3Vzc2lvbiB0byByZXNvbHZl
IGxpbmdlcmluZyBvcGVuIHF1ZXN0aW9ucw0KPiB0aGF0IGN1cnJlbnRseSBtb3RpdmF0ZSBleHQ0
IGFuZCB4ZnMgdG8gc2NyZWFtICJFWFBFUklNRU5UQUwiIHdoZW4gdGhlDQo+IGN1cnJlbnQgREFY
IGZhY2lsaXRpZXMgYXJlIGVuYWJsZWQuIFRoZSBhcmUgMiBwcmltYXJ5IGNvbmNlcm5zIHRvDQo+
IHJlc29sdmUuIEVudW1lcmF0ZSB0aGUgcmVtYWluaW5nIGZlYXR1cmVzL2ZpeGVzLCBhbmQgaWRl
bnRpZnkgYSBwYXRoDQo+IHRvIGltcGxlbWVudCBpdCBhbGwgd2l0aG91dCByZWdyZXNzaW5nIGFu
eSBleGlzdGluZyBhcHBsaWNhdGlvbiB1c2UNCj4gY2FzZXMuDQo+IA0KPiBBbiBlbnVtZXJhdGlv
biBvZiByZW1haW5pbmcgcHJvamVjdHMgZm9sbG93cywgcGxlYXNlIGV4cGFuZCB0aGlzIGxpc3QN
Cj4gaWYgSSBtaXNzZWQgc29tZXRoaW5nOg0KPiANCj4gKiAiREFYIiBoYXMgbm8gc3BlY2lmaWMg
bWVhbmluZyBieSBpdHNlbGYsIHVzZXJzIGhhdmUgMiB1c2UgY2FzZXMgZm9yDQo+ICJEQVgiIGNh
cGFiaWxpdGllczogdXNlcnNwYWNlIGNhY2hlIG1hbmFnZW1lbnQgdmlhIE1BUF9TWU5DLCBhbmQg
cGFnZQ0KPiBjYWNoZSBhdm9pZGFuY2Ugd2hlcmUgdGhlIGxhdHRlciBhc3BlY3Qgb2YgREFYIGhh
cyBubyBjdXJyZW50IGFwaSB0bw0KPiBkaXNjb3ZlciAvIHVzZSBpdC4gVGhlIHByb2plY3QgaXMg
dG8gc3VwcGxlbWVudCBNQVBfU1lOQyB3aXRoIGENCj4gTUFQX0RJUkVDVCBmYWNpbGl0eSBhbmQg
TUFEVl9TWU5DIC8gTUFEVl9ESVJFQ1QgdG8gaW5kaWNhdGUgdGhlIHNhbWUNCj4gZHluYW1pY2Fs
bHkgdmlhIG1hZHZpc2UuIFNpbWlsYXIgdG8gT19ESVJFQ1QsIE1BUF9ESVJFQ1Qgd291bGQgYmUg
YW4NCj4gYXBwbGljYXRpb24gaGludCB0byBhdm9pZCAvIG1pbmltaWl6ZSBwYWdlIGNhY2hlIHVz
YWdlLCBidXQgbm8gc3RyaWN0DQo+IGd1YXJhbnRlZSBsaWtlIHdoYXQgTUFQX1NZTkMgcHJvdmlk
ZXMuDQoNCkFncmVlZCB0aGF0IGJhc2ljIGRheCBwcm9ncmFtbWluZyBtb2RlbCBuZWVkcyB0byBi
ZSBzZXR0bGVkLg0KDQo+ICogUmVzb2x2ZSBhbGwgImlmIChkYXgpIGdvdG8gZmFpbDsiIHBhdHRl
cm5zIGluIHRoZSBrZXJuZWwuIE91dHNpZGUgb2YNCj4gbG9uZ3Rlcm0tR1VQIChhIHRvcGljIGlu
IGl0cyBvd24gcmlnaHQpIHRoZSBwcm9qZWN0cyBoZXJlIGFyZQ0KPiBYRlMtcmVmbGluayBhbmQg
WEZTLXJlYWx0aW1lLWRldmljZSBzdXBwb3J0LiBEQVgrcmVmbGluayBlZmZlY3RpdmVseQ0KPiBy
ZXF1aXJlcyBhIGdpdmVuIHBoeXNpY2FsIHBhZ2UgdG8gYmUgbWFwcGVkIGludG8gdHdvIGRpZmZl
cmVudCBpbm9kZXMNCj4gYXQgZGlmZmVyZW50IChwYWdlLT5pbmRleCkgb2Zmc2V0cy4gVGhlIGNo
YWxsZW5nZSBpcyB0byBzdXBwb3J0DQo+IERBWC1yZWZsaW5rIHdpdGhvdXQgdmlvbGF0aW5nIGFu
eSBleGlzdGluZyBhcHBsaWNhdGlvbiB2aXNpYmxlDQo+IHNlbWFudGljcywgdGhlIG9wZXJhdGlu
ZyBhc3N1bXB0aW9uIC8gc3RyYXdtYW4gdG8gZGViYXRlIGlzIHRoYXQNCj4gZXhwZXJpbWVudGFs
IHN0YXR1cyBpcyBub3QgYmxhbmtldCBwZXJtaXNzaW9uIHRvIGdvIGNoYW5nZSBleGlzdGluZw0K
PiBzZW1hbnRpY3MgaW4gYmFja3dhcmRzIGluY29tcGF0aWJsZSB3YXlzLg0KDQpJIGRvIG5vdCB0
aGluayAiaWYgKGRheCkgZ290byBmYWlsOyIgaXMgYWN0dWFsbHkgYmFkLiAgSXQgaGVscHMgdXNl
cnMgdG8NCmltbWVkaWF0ZWx5IHJlYWxpemUgdGhhdCBkYXggbWF5IG5vdCBiZSBlbmFibGVkIGFu
ZCB0aGV5IGhhdmUgYSBzZXR1cA0KaXNzdWUuICBJIGFsc28gdGhpbmsgdGhhdCBGUy1zcGVjaWZp
YyBlbmhhbmNlbWVudHMgbGlrZSBEQVgtcmVmbGluaz0xDQpzdXBwb3J0IHNob3VsZCBiZSBtYW5h
Z2VkIHNlcGFyYXRlbHkgYW5kIHNob3VsZCBiZSBwb3NzaWJsZSBhZnRlcg0KRVhQRVJJTUVOVEFM
IGlzIHJlbW92ZWQgZnJvbSAnbW91bnQgLW8gZGF4Jy4gIFRoYXQgaXMsIHJlbW92aW5nDQpFWFBF
UklNRU5UQUwgZm9yIERBWC1yZWZsaW5rPTAgc2hvdWxkIG5vdCByZXF1aXJlIHN1cHBvcnQgb2Yg
REFYLQ0KcmVmbGluaz0xLg0KDQpJJ3ZlIGFsc28gaGFkIG11bHRpcGxlIHVzZXJzIGNvbXBsYWlu
ZWQgYWJvdXQgJ21vdW50IC1vIGRheCcgc3VjY2VlZGVkDQpieSBmYWxsaW5nIGJhY2sgdG8gbm9u
LWRheCBkZXNwaXRlIG9mIHRoZWlyIGludGVudC4gIFN1Y2ggdXNlcnMgd2FzdGVkDQptYW55IGhv
dXJzIHdpdGhvdXQga25vd2luZyB0aGVpciBzZXR1cCBlcnJvciAvIGN1cnJlbnQgcmVzdHJpY3Rp
b25zLiANClRoZSBuZXh0IHRoaW5rIHRoZXkgYWx3YXlzIGFzayBpcyBob3cgdG8gY2hlY2sgaWYg
ZGF4IGlzIGVuYWJsZWQgaW4gc3VjaA0KY2FzZSwgYW5kIHRoZXkgYXJlIG5vdCBoYXBweSBhYm91
dCBsaW1pdGVkIGludGVyZmFjZXMgKGV4LiBsb29rIGZvcg0KbW91bnQgZW50cnkgaW4gL3Byb2Mv
bW91bnRzKSwgZWl0aGVyLg0KDQo+ICogRGVwcmVjYXRlLCBidXQgbm90IHJlbW92ZSwgdGhlIERB
WCBtb3VudCBvcHRpb24uIFRvbyBtYW55IGZsb3dzDQo+IGRlcGVuZCBvbiB0aGUgb3B0aW9uIHNv
IGl0IHdpbGwgbmV2ZXIgZ28gYXdheSwgYnV0IHRoZSBmYWNpbGl0eSBpcyB0b28NCj4gY29hcnNl
LiBQcm92aWRlIGFuIG9wdGlvbiB0byBlbmFibGUgTUFQX1NZTkMgYW5kDQo+IG1vcmUtbGlrZWx5
LXRvLWRvLXNvbWV0aGluZy11c2VmdWwtTUFQX0RJUkVDVCBvbiBhIHBlci1kaXJlY3RvcnkNCj4g
YmFzaXMuIFRoZSBjdXJyZW50IHByb3Bvc2FsIGlzIHRvIGFsbG93IHRoaXMgcHJvcGVydHkgdG8g
b25seSBiZQ0KPiB0b2dnbGVkIHdoaWxlIHRoZSBkaXJlY3RvcnkgaXMgZW1wdHkgdG8gYXZvaWQg
dGhlIGNvbXBsaWNhdGlvbnMgb2YNCj4gcmFjaW5nIHBhZ2UgaW52YWxpZGF0aW9uIHdpdGggbmV3
IERBWCBtYXBwaW5ncy4NCg0KU2FtZSBhcyBhYm92ZS4gIFN1Y2ggZW5oYW5jZW1lbnQgc2hvdWxk
IGJlIHBvc3NpYmxlIGFmdGVyIEVYUEVSSU1FTlRBTA0KaXMgcmVtb3ZlZCBmcm9tICdtb3VudCAt
byBkYXgnLiAgSU9XLCBhIHNlcGFyYXRlIEVYUEVSSU1FTlRBTCBtZXNzYWdlDQpjYW4gYmUgc2hv
d24gd2hlbiB1c2VyIHJlcXVlc3RzIHBlci1kaXJlY3RvcnkgZGF4Lg0KDQpUaGFua3MsDQotVG9z
aGkNCg==
