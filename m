From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
Date: Sun, 12 May 2013 13:05:00 +0000 (GMT)
Message-ID: <31302271.2821368363898561.JavaMail.weblogic@epml17>
Reply-To: eunb.song@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:11485 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3ELNFC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 May 2013 09:05:02 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMO00HOPSCAFF90@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Sun, 12 May 2013 22:05:00 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

DQoNCj4+IFNpbmNlIGF0IHRoaXMgcG9pbnQgaXQncyBzYWZlciB0byByb2xsYmFjayB0aGUgY2hh
bmdlIGFuZCB3ZSBjYW4NCj4+IGludmVzdGlnYXRlIG1vcmUgZGVlcGx5IGhvdyB0byBmaXggaXQg
Y29ycmVjdGx5IGZvciB0aGUgbmV4dA0KPj4gZGV2ZWxvcG1lbnQgY3ljbGUsIHRoaXMgaXMgdGhl
IHBhdGNoIHdoaWNoIEknbSB0ZXN0aW5nLg0KDQo+PiAgICAgICAgICAgICAgICAgICAgIC0gVGVk
DQoNCj4gSGVsbG8sIEkndmUgdGVzdGVkIHdpdGggeW91ciBwYXRjaC4gQnV0IHRoZSBzYW1lIHBy
b2JsZW0gd2FzIHJlcHJvZHVjZWQuDQo+IEN1cnJlbnRseSwgSSdtIHRyeWluZyB0byBnaXQgYmlz
ZWN0LiBJZiBpIGRvbmUgZ2l0IGJpc2VjdCwgaSB3aWxsIGxldCB5b3Uga25vdy4NCg0KSGksIEkn
dmUgZG9uZSBnaXQgYmlzZWN0LiBhbmQgcGFuaWMgYXQgamJkMl9qb3VybmFsX3B1dF9qb3VybmFs
X2hlYWQoKSBpcyBjYXVzZWQgYnkgDQphZTQ2NDdmYjc2NTQ2NzZmYzQ0YTk3ZTg2ZWIzNWY5ZjA2
Yjk5ZjY2OiAiamJkMjogcmVkdWNlIGpvdXJuYWxfaGVhZCBzaXplLiINCkkgd3JpdGUganVzdCBj
b2RlIHBhdGNoIHdoaWNoIHJldmVydCBhZTQ2NDdmYjc2NTQ2NzZmYzQ0YTk3ZTg2ZWIzNWY5ZjA2
Yjk5ZjY2IGJlY2F1c2UNCkkgZG9uJ3Qga25vdyB0aGUgcm9vdCBjYXVzZS4gDQoNCg0KU2lnbmVk
LW9mZi1ieTogRXVuYm9uZyBTb25nIDxldW5iLnNvbmdAc2Ftc3VuZy5jb20+DQotLS0NCiBpbmNs
dWRlL2xpbnV4L2pvdXJuYWwtaGVhZC5oIHwgICAxMSArKysrKysrKystLQ0KIDEgZmlsZXMgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9qb3VybmFsLWhlYWQuaCBiL2luY2x1ZGUvbGludXgvam91cm5hbC1oZWFkLmgN
CmluZGV4IDEzYTNkYTIuLmMxOGI0NmYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2pvdXJu
YWwtaGVhZC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2pvdXJuYWwtaGVhZC5oDQpAQCAtMzEsMTQg
KzMxLDIxIEBAIHN0cnVjdCBqb3VybmFsX2hlYWQgew0KIAkvKg0KIAkgKiBKb3VybmFsbGluZyBs
aXN0IGZvciB0aGlzIGJ1ZmZlciBbamJkX2xvY2tfYmhfc3RhdGUoKV0NCiAJICovDQotCXVuc2ln
bmVkIGJfamxpc3Q6NDsNCisJdW5zaWduZWQgYl9qbGlzdDsNCiANCiAJLyoNCiAJICogVGhpcyBm
bGFnIHNpZ25hbHMgdGhlIGJ1ZmZlciBoYXMgYmVlbiBtb2RpZmllZCBieQ0KIAkgKiB0aGUgY3Vy
cmVudGx5IHJ1bm5pbmcgdHJhbnNhY3Rpb24NCiAJICogW2piZF9sb2NrX2JoX3N0YXRlKCldDQog
CSAqLw0KLQl1bnNpZ25lZCBiX21vZGlmaWVkOjE7DQorCXVuc2lnbmVkIGJfbW9kaWZpZWQ7DQor
DQorCS8qDQorCSAqIFRoaXMgZmVpbGQgdHJhY2tzIHRoZSBsYXN0IHRyYW5zYWN0aW9uIGlkIGlu
IHdoaWNoIHRoaXMgYnVmZmVyDQorCSAqIGhhcyBiZWVuIGNvd2VkDQorCSAqIFtqYmRfbG9ja19i
aF9zdGF0ZSgpXQ0KKwkgKi8NCisJdGlkX3QgYl9jb3dfdGlkOw0KIA0KIAkvKg0KIAkgKiBDb3B5
IG9mIHRoZSBidWZmZXIgZGF0YSBmcm96ZW4gZm9yIHdyaXRpbmcgdG8gdGhlIGxvZy4NCi0tIA0K
MS43LjAuNA0KDQoNClRoYW5rcy4g


