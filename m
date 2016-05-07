From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Sat, 07 May 2016 13:05:50 +0000 (GMT)
Message-ID: <945936769.469311462626349850.JavaMail.weblogic@ep2mlwas09a>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>,
	=?utf-8?Q?=EC=9D=B4=EA=B8=B0=ED=83=9C?= <kitae87.lee@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40445 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcEGNFx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 May 2016 09:05:53 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O6T00Q8I5PRM450@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Sat, 07 May 2016 22:05:51 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PiBUaGUgcmVhbCBwcm9ibGVtIGhlcmUgaXMgdGhhdCB3ZSB3YW50IGVtZXJnZW5jeSB1bm1vdW50
IHRvIGJlDQo+IGNvbXBsZXRlbHkgc2FmZSwgYnV0dGluZyBNU19SRE9OTFkgcmFuZG9tbHkgaXNu
J3Qgc2FmZSBhZ2FpbnN0IGZpbGUNCj4gc3lzdGVtIGNvcnJ1cHRpb24uICBUaGUgaWRlYSBpcyB5
b3UgZG8gdGhpcyBvbmx5IHdoZW4geW91IGhhdmUgbm8NCj4gb3RoZXIgY2hvaWNlLCBhbmQgdGhl
IGNvbnNlcXVlbmNlcyB3b3VsZCBiZSB3b3JzZSAtLS0gYW5kIHdoZXJlIHlvdQ0KPiB3b3VsZCBi
ZSBwcmVwYXJlZCB0byBkbyBhIGZpbGUgc3lzdGVtIGNvbnNpc3RlbmN5IGNoZWNrIGFmdGVyd2Fy
ZHMuDQoNCj4gV2UgY2FuIGVpdGhlciBmaXggQW5kcm9pZCB1c2Vyc3BhY2UsIG9yIHdlIGNvdWxk
IGFkZCBhIHBlci1maWxlIHN5c3RlbQ0KPiBjYWxsYmFjayB3aGljaCB0cmllcyAoYXMgbXVjaCBh
cyBwb3NzaWJsZSkgdG8gbWFrZSBhbiBlbWVyZ2VuY3kNCj4gdW5tb3VudCBzYWZlLiAgSW4gdGhp
cyBwYXJ0aWN1bGFyIGNhc2UsIGl0IHdvdWxkIHByb2JhYmx5IGludm9sdmUNCj4gc2V0dGluZyB0
aGUgImZpbGUgc3lzdGVtIGlzIGNvcnJ1cHQgZmxhZyIgdG8gZm9yY2UgYSBmaWxlIHN5c3RlbQ0K
PiBjb25zaXN0ZW5jeSBjaGVjayBhdCB0aGUgbmV4dCByZWJvb3QuICBCZWNhdXNlIGlmIHlvdSB1
c2UgZW1lcmdlbmN5DQo+IHVubW91bnQsIGFsbCBiZXRzIGFyZSBvZmYsIGFuZCB0aGVyZSBtYXkg
YmUgb3RoZXIgcHJvYmxlbXMuLi4uDQoNCkFjdHVhbGx5LCB3ZSBoYWQgZXhlY3V0ZWQgcG93ZXIg
b24vb2ZmIHRlc3QgcmVwZWF0ZWRseSB3aXRoIDEwIEFuZHJvaWQNCmRldmljZXMgZm9yIGEgbW9u
dGguIEJ1dCwgZHVyaW5nIHRoZSB0ZXN0LCBqdXN0IHRoaXMgcHJvYmxlbSBvbmx5IGhhcHBlbmVk
DQpyZXBlYXRlZGx5LCBldmVuIGlmIGl0IG9jY3VycmVkIHZlcnkgcmFyZWx5LiBTbyB3ZSBoYWQg
Y29uY2x1ZGVkIHRoYXQgd2UNCmhhZCB0byBmaXggdGhpcyBwcm9ibGVtIGNlcnRhaW5seS4NCg0K
SG93ZXZlciwgSSBjYW4gc2VlIHRoZSBwb2ludCBub3cuIEFuZHJvaWQgaGF2ZSBtaXN1c2VkIHRo
ZSBlbWVyZ2VuY3kNCnJvLXJlbW91bnQgYW5kIHRoZSBmaWxlc3lzdGVtIGNyYXNoIGJ5IGVtZXJn
ZW5jeSByby1yZW1vdW50IGlzIG5vdCBhbiBpc3N1ZS4NCkkgY2FuIHVuZGVyc3RhbmQgdGhlIHB1
cnBvc2Ugb2YgdGhlIGVtZXJnZW5jeSByby1yZW1vdW50Lg0KDQpJIGhlYXJkIHRoYXQgdGhlIG5l
eHQgdmVyc2lvbiBvZiBBbmRyb2lkIHdpbGwgZG8gZnVsbCBzY2FuIG9mIGV4dDQgZmlsZXN5c3Rl
bXMNCnVzaW5nIGUyZnNjayBldmVyeSBib290LXVwLCBzbyB0aGUgZXhpc3RpbmcgcHJvYmxlbSB3
aWxsIGJlIG5hdHVyYWxseSByZXNvbHZlZCwNCmV2ZW4gaWYgaXQgbWlnaHQgbm90IGJlIHRoZSBy
aWdodCBzb2x1dGlvbi4NCg0KVGhhbmsgeW91IGZvciB5b3VyIHZhbHVhYmxlIGNvbW1lbnRzLg0K


