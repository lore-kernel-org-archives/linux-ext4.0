Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27419C282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 14:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03482218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 14:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfAXOsa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:48:30 -0500
Received: from mxo2.nje.dmz.twosigma.com ([208.77.214.162]:52123 "EHLO
        mxo2.nje.dmz.twosigma.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfAXOsa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2019 09:48:30 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2019 09:48:29 EST
Received: from localhost (localhost [127.0.0.1])
        by mxo2.nje.dmz.twosigma.com (Postfix) with ESMTP id C1BD610004C;
        Thu, 24 Jan 2019 14:40:13 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo2.nje.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo2.nje.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iKqCA4-FYy0l; Thu, 24 Jan 2019 14:40:13 +0000 (GMT)
Received: from exmbdft8.ad.twosigma.com (exmbdft8.ad.twosigma.com [172.22.2.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo2.nje.dmz.twosigma.com (Postfix) with ESMTPS id AE4518002E;
        Thu, 24 Jan 2019 14:40:13 +0000 (GMT)
Received: from exmbdft5.ad.twosigma.com (172.22.1.56) by
 exmbdft8.ad.twosigma.com (172.22.2.84) with Microsoft SMTP Server (TLS) id
 15.0.1365.1; Thu, 24 Jan 2019 14:40:13 +0000
Received: from exmbdft5.ad.twosigma.com ([fe80::6817:c8d6:1df1:1f91]) by
 exmbdft5.ad.twosigma.com ([fe80::6817:c8d6:1df1:1f91%17]) with mapi id
 15.00.1365.000; Thu, 24 Jan 2019 14:40:13 +0000
From:   Elana Hashman <Elana.Hashman@twosigma.com>
To:     Liu Bo <obuil.liubo@gmail.com>
CC:     "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Thomas Walker <Thomas.Walker@twosigma.com>
Subject: RE: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
Thread-Topic: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
Thread-Index: AdR3jGRwKFdVUP13R1+Va2EpnAzRHg7+1j0AABqlvCA=
Date:   Thu, 24 Jan 2019 14:40:13 +0000
Message-ID: <c8a7a059fb334920bdf020e0b7c050bd@exmbdft5.ad.twosigma.com>
References: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
 <CANQeFDD78G0f8V2YYKq+wMpiVPzmZ8SJ_6xWtgyZ6FvAUKpe8w@mail.gmail.com>
In-Reply-To: <CANQeFDD78G0f8V2YYKq+wMpiVPzmZ8SJ_6xWtgyZ6FvAUKpe8w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.20.187.133]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

RnJvbTogTGl1IEJvIDxvYnVpbC5saXVib0BnbWFpbC5jb20+IA0KDQo+IEkgd29uZGVyIGlmIHRo
aXMgZXh0NCBlbmFibGVkIGJpZ2FsbG9jIChjYW4gYmUgY2hlY2tlZCBieSBkdW1wZTJmcyAtaCAk
ZGlzaykuDQo+IFNvIGJpZ2FsbG9jIGlzIGtub3duIHRvIGNhdXNlIGxlYWsgc3BhY2UsIGFuZCBp
dCdzIGJlZW4ganVzdCBmaXhlZCByZWNlbnRseS4NCg0KRG9lc24ndCBsb29rIHRoYXQgd2F5Og0K
DQokIHVuYW1lIC1hDQpMaW51eCA8aG9zdG5hbWU+IDQuMTQuNjctdHMxICMxIFNNUCBXZWQgQXVn
IDI5IDEzOjI4OjI1IFVUQyAyMDE4IHg4Nl82NCBHTlUvTGludXgNCiQgc3VkbyBkdSAtaHhzIC8N
CjIwRyAgICAgLw0KJCBkZiAtaCAvDQpGaWxlc3lzdGVtICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFNpemUgIFVzZWQgQXZhaWwgVXNlJSBNb3VudGVkIG9uDQov
ZGV2L2Rpc2svYnktdXVpZC88c29tZS11dWlkPiAgIDUwRyAgIDQ2RyAgMS4xRyAgOTglIC8NCiQg
c3VkbyBkdW1wZTJmcyAtaCAvZGV2L2Rpc2svYnktdXVpZC88c29tZS11dWlkPg0KZHVtcGUyZnMg
MS40Mi41ICgyOS1KdWwtMjAxMikNCkZpbGVzeXN0ZW0gdm9sdW1lIG5hbWU6ICAgUk9PVA0KTGFz
dCBtb3VudGVkIG9uOiAgICAgICAgICAvDQpGaWxlc3lzdGVtIFVVSUQ6ICAgICAgICAgIDxzb21l
LXV1aWQ+DQpGaWxlc3lzdGVtIG1hZ2ljIG51bWJlcjogIDB4RUY1Mw0KRmlsZXN5c3RlbSByZXZp
c2lvbiAjOiAgICAxIChkeW5hbWljKQ0KRmlsZXN5c3RlbSBmZWF0dXJlczogICAgICBoYXNfam91
cm5hbCBleHRfYXR0ciByZXNpemVfaW5vZGUgZGlyX2luZGV4IGZpbGV0eXBlIG5lZWRzX3JlY292
ZXJ5IGV4dGVudCBmbGV4X2JnIHNwYXJzZV9zdXBlciBsYXJnZV9maWxlIGh1Z2VfZmlsZSB1bmlu
aXRfYmcgZGlyX25saW5rIGV4dHJhX2lzaXplDQpGaWxlc3lzdGVtIGZsYWdzOiAgICAgICAgIHNp
Z25lZF9kaXJlY3RvcnlfaGFzaA0KRGVmYXVsdCBtb3VudCBvcHRpb25zOiAgICB1c2VyX3hhdHRy
IGFjbA0KRmlsZXN5c3RlbSBzdGF0ZTogICAgICAgICBjbGVhbg0KRXJyb3JzIGJlaGF2aW9yOiAg
ICAgICAgICBDb250aW51ZQ0KRmlsZXN5c3RlbSBPUyB0eXBlOiAgICAgICBMaW51eA0KSW5vZGUg
Y291bnQ6ICAgICAgICAgICAgICAzMjc2ODAwDQpCbG9jayBjb3VudDogICAgICAgICAgICAgIDEz
MTA3MjAwDQpSZXNlcnZlZCBibG9jayBjb3VudDogICAgIDY1NTM2MA0KRnJlZSBibG9ja3M6ICAg
ICAgICAgICAgICA5MjYwNzUxDQpGcmVlIGlub2RlczogICAgICAgICAgICAgIDMwNzgzNDgNCkZp
cnN0IGJsb2NrOiAgICAgICAgICAgICAgMA0KQmxvY2sgc2l6ZTogICAgICAgICAgICAgICA0MDk2
DQpGcmFnbWVudCBzaXplOiAgICAgICAgICAgIDQwOTYNClJlc2VydmVkIEdEVCBibG9ja3M6ICAg
ICAgMTAyMA0KQmxvY2tzIHBlciBncm91cDogICAgICAgICAzMjc2OA0KRnJhZ21lbnRzIHBlciBn
cm91cDogICAgICAzMjc2OA0KSW5vZGVzIHBlciBncm91cDogICAgICAgICA4MTkyDQpJbm9kZSBi
bG9ja3MgcGVyIGdyb3VwOiAgIDUxMg0KRmxleCBibG9jayBncm91cCBzaXplOiAgICAxNg0KRmls
ZXN5c3RlbSBjcmVhdGVkOiAgICAgICBUdWUgSmFuIDE2IDE4OjQ4OjEzIDIwMTgNCkxhc3QgbW91
bnQgdGltZTogICAgICAgICAgTW9uIE9jdCAgMSAyMDo0Mzo1OSAyMDE4DQpMYXN0IHdyaXRlIHRp
bWU6ICAgICAgICAgIE1vbiBPY3QgIDEgMjA6NDM6NTggMjAxOA0KTW91bnQgY291bnQ6ICAgICAg
ICAgICAgICA3DQpNYXhpbXVtIG1vdW50IGNvdW50OiAgICAgIC0xDQpMYXN0IGNoZWNrZWQ6ICAg
ICAgICAgICAgIFR1ZSBKYW4gMTYgMTg6NDg6MTMgMjAxOA0KQ2hlY2sgaW50ZXJ2YWw6ICAgICAg
ICAgICAwICg8bm9uZT4pDQpMaWZldGltZSB3cml0ZXM6ICAgICAgICAgIDcxNTkgR0INClJlc2Vy
dmVkIGJsb2NrcyB1aWQ6ICAgICAgMCAodXNlciByb290KQ0KUmVzZXJ2ZWQgYmxvY2tzIGdpZDog
ICAgICAwIChncm91cCByb290KQ0KRmlyc3QgaW5vZGU6ICAgICAgICAgICAgICAxMQ0KSW5vZGUg
c2l6ZTogICAgICAgICAgICAgICAyNTYNClJlcXVpcmVkIGV4dHJhIGlzaXplOiAgICAgMjgNCkRl
c2lyZWQgZXh0cmEgaXNpemU6ICAgICAgMjgNCkpvdXJuYWwgaW5vZGU6ICAgICAgICAgICAgOA0K
Rmlyc3Qgb3JwaGFuIGlub2RlOiAgICAgICAyMjMxNDc3DQpEZWZhdWx0IGRpcmVjdG9yeSBoYXNo
OiAgIGhhbGZfbWQ0DQpEaXJlY3RvcnkgSGFzaCBTZWVkOiAgICAgIDhhNmY2ZDAzLTM3ZTctNDA5
Yy1iOGM5LWQ3MzhlMGIwYTk0YQ0KSm91cm5hbCBiYWNrdXA6ICAgICAgICAgICBpbm9kZSBibG9j
a3MNCkpvdXJuYWwgZmVhdHVyZXM6ICAgICAgICAgam91cm5hbF9pbmNvbXBhdF9yZXZva2UNCkpv
dXJuYWwgc2l6ZTogICAgICAgICAgICAgMTI4TQ0KSm91cm5hbCBsZW5ndGg6ICAgICAgICAgICAz
Mjc2OA0KSm91cm5hbCBzZXF1ZW5jZTogICAgICAgICAweDAyYTA5MTE2DQpKb3VybmFsIHN0YXJ0
OiAgICAgICAgICAgIDI0Njg4DQoNCg0KLS0NCkVsYW5hIEhhc2htYW4NCmVoYXNobWFuQHR3b3Np
Z21hLmNvbQ0K
