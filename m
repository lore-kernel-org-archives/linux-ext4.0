From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH] e2fsck: update j_tail_sequence after recovery
Date: Wed, 01 Jun 2016 07:13:25 +0000 (GMT)
Message-ID: <159772701.338101464765204534.JavaMail.weblogic@epmlwas09b>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: =?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>,
	=?utf-8?Q?=EA=B8=B8=EC=98=81=EC=A7=84?= <youngjin.gil@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750697AbcFAHNj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2016 03:13:39 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O8300KJZ02D6F80@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 01 Jun 2016 16:13:25 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SGksDQoNClBpbmcgb24gdGhpcy4NCg0KPiBXaGVuIGpvdXJuYWwgaXMgcmVsZWFzZWQsIHNfc2Vx
dWVuY2UgaXMgc2V0IHRvIGpfdGFpbF9zZXF1ZW5jZS4NCj4gQnV0LCBjdXJyZW50bHksIGV2ZW4g
aWYgdGhlIHJlY292ZXJ5IHByb2Nlc3MgaXMgc3VjY2Vzc2Z1bGx5IGNvbXBsZXRlZCwNCj4gdGhl
IGpfdGFpbF9zZXF1ZW5jZSBhbmQsIGZpbmFsbHksIHNfc2VxdWVuY2UgYXJlIG5ldmVyIGNoYW5n
ZWQuIEJ5IHRoaXMsDQo+IHdoZW4gd2UgcmVwZWF0IGRvaW5nIHBvd2VyLW9mZiB0aGUgZGV2aWNl
IHN1ZGRlbmx5IGFuZCBleGVjdXRpbmcgZTJmc2NrDQo+IHdpdGhvdXQgZnVsbCBzY2FuIGJlZm9y
ZSBtb3VudCwgdGhlIHNfc2VxdWVuY2UgbnVtYmVyIHdpbGwgbmV2ZXIgY2hhbmdlDQo+IGFuZCwg
aW4gYSB2ZXJ5IHJhcmUgY2FzZSwgbmV3bHkgZ2VuZXJhdGVkIGpvdXJuYWwgbG9ncyB3aWxsIGJl
DQo+IHN1cnByaXNpbmdseSBncmFmdGVkIHRvIHRoZSBvbGQgam91cm5hbCBsb2dzLiBJbiB0aGlz
IGNhc2UsIG91dC1vZi1kYXRlDQo+IG1ldGFkYXRhIGxvZyBjYW4gYmUgcmVwbGF5ZWQgb24gdGhl
IGZpbGVzeXN0ZW0gYXJlYSBhbmQgdGhlIGZpbGVzeXN0ZW0NCj4gY2FuIGJlIGNyYXNoZWQgdW5p
bnRlbnRpb25hbGx5IGJ5IGpvdXJuYWwgcmVjb3ZlcnkgcHJvY2Vzcy4gVGhlcmVmb3JlLA0KPiB3
ZSBuZWVkIHRvIHVwZGF0ZSBqX3RhaWxfc2VxdWVuY2UgYWZ0ZXIgcmVjb3ZlcnkgcHJvY2VzcyBp
cyBzdWNjZXNzZnVsbHkNCj4gY29tcGxldGVkIGluIGUyZnNjay4=


