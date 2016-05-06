From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Fri, 06 May 2016 06:01:12 +0000 (GMT)
Message-ID: <593570881.453531462514471895.JavaMail.weblogic@ep2mlwas08c>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: jack@suse.cz,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=9D=B4=EA=B8=B0=ED=83=9C?= <kitae87.lee@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52488 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbcEFGBQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2016 02:01:16 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O6Q023Z9RE1Z2C0@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 06 May 2016 15:01:13 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PiBIbW0sIEknbSBub3QgcmVhbGx5IGNvbWZvcnRhYmxlIHdpdGggcHV0dGluZyB0aGlzIGhhY2sg
aW4sIHNpbmNlIHRoaXMNCj4gaXMgcGFwZXJpbmcgb3ZlciB0aGUgcmVhbCBwcm9ibGVtLCB3aGlj
aCBpcyB0aGF0IEFuZHJvaWQgaXMgdHJ5aW5nIHRvDQo+IHVzZSB0aGUgZW1lcmdlbmN5IHJlbW91
bnQgcmVhZC1vbmx5IHN5c3JxIG9wdGlvbiBhbmQgdGhpcyBpcw0KPiBmdW5kYW1lbnRhbGx5IHVu
c2FmZS4gIEknbSBub3Qgc3VyZSB3aGF0IGVsc2UgY291bGQgYnJlYWsgaWYgaXQgaXMNCj4gc2l0
dWF0aW9uIG5vcm1hbCB0aGF0IHRoZXJlIGlzIGFjdGl2ZSBwcm9jZXNzZXMgYnVzaWx5IHdyaXRp
bmcgdG8gdGhlDQo+IGZpbGUgc3lzdGVtIGFuZCBzeXNycS11IGZvbGxvd2VkIGJ5IHJlYm9vdCBp
cyB0aGUgbm9ybWFsIHdheSB0aGUNCj4gQW5kcm9pZCBrZXJuZWwgZG9lcyBhIHJlYm9vdC4NCg0K
PiBBIG11Y2ggYmV0dGVyIHNvbHV0aW9uIHdvdWxkIGJlIHRvIGNoYW5nZSB0aGUgQW5kcm9pZCB1
c2Vyc3BhY2UgdG8NCj4gY2FsbCB0aGUgRklGUkVFWkUgaW9jdGwgb24gZWFjaCBtb3VudGVkIGZp
bGUgc3lzdGVtLCBhbmQgdGhlbiBjYWxsIGZvcg0KPiBhIHJlYm9vdC4NCg0KSSBhZ3JlZSB3aXRo
IHlvdS4gSSBrbm93IHRoYXQgY3VycmVudCBBbmRyb2lkIHNodXRkb3duIHByb2NlZHVyZSBpcw0K
bm90IGEgc2FmZSB3YXkuIEJ1dCwgd2l0aG91dCB0aGlzIHBhdGNoLCAiZXZlbiBub3QgaW4gQW5k
cm9pZCBzeXN0ZW0iLA0Kd2hlbiB3ZSB0cmlnZ2VyIHRoZSBlbWVyZ2VuY3kgcmVhZC1vbmx5IHJl
bW91bnQgd2hpbGUgZXZpY3RpbmcgaW5vZGVzLA0KaV9zaXplIG9mIHRoZSBpbm9kZSBiZWNvbWVz
IHplcm8gYW5kIHRoZSBpbm9kZSBpcyBub3QgaW4gb3JwaGFuIGxpc3QsDQpidXQgYmxvY2tzIG9m
IHRoZSBpbm9kZSBhcmUgc3RpbGwgYWxsb2NhdGVkIHRvIHRoZSBpbm9kZSwgYmVjYXVzZQ0KZXh0
NF90cnVuY2F0ZSgpIHdpbGwgZmFpbCB3aGlsZSBzdGF0aW5nIHRoZSBoYW5kbGUgd2hpY2ggd2Fz
IGFscmVhZHkgc3RhcnRlZA0KYnkgZXh0NF9ldmljdF9pbm9kZSgpLiBUaGlzIGNhdXNlcyB0aGUg
ZmlsZXN5c3RlbSBpbmNvbnNpc3RlbmN5IGFuZA0Kd2Ugd2lsbCBlbmNvdW50ZXIgYW4gZXh0NCBr
ZXJuZWwgcGFuaWMgaW4gdGhlIG5leHQgYm9vdCBieSB0aGlzIHByb2JsZW0uDQoNCkkgdGhpbmsg
dGhhdCB0aGlzIGtpbmQgb2YgZmlsZXN5c3RlbSBjcmFzaCBjYW4gb2NjdXIgYW55d2hlcmUgdGhh
dA0KdGhlIHNhbWUgam91cm5hbCBoYW5kbGUgaXMgcmVwZWF0bHkgdXNlZC4gRHVyaW5nIGFuIGF0
b21pYyBmaWxlc3lzdGVtDQpvcGVyYXRpb24sIGEgcGFydCBvZiB0aGUgb3BlcmF0aW9uIHdpbGwg
c3VjY2VlZCBhbmQgdGhlIG90aGVyIG9uZSB3aWxsIGZhaWwuDQo=


