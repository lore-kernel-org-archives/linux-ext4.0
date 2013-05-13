From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Mon, 13 May 2013 09:53:27 +0000 (GMT)
Message-ID: <12945098.35291368438804981.JavaMail.weblogic@epv6ml07>
Reply-To: eunb.song@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: base64
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>, Tony Luck <tony.luck@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:37830 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3EMJxy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 05:53:54 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMQ00NO3E4J0DB0@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 13 May 2013 18:53:27 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

DQoNCj4gSGkgYWxsLA0KDQo+IEZpcnN0IG9mIGFsbCBJIGNvdWxkbid0IHJlcHJvZHVjZSB0aGlz
IHJlZ3Jlc3Npb24gaW4gbXkgc2FuZCBib3guICBTbw0KPiB0aGUgZm9sbG93aW5nIHNwZWN1bGF0
aW9uIGlzIG9ubHkgbXkgZ3Vlc3MuICBJIHN1c3BlY3QgdGhhdCB0aGUgY29tbWl0DQo+IChhZTQ2
NDdmYikgaXNuJ3Qgcm9vdCBjYXVzZS4gIEl0IGp1c3QgdW5jb3ZlciBhIHBvdGVudGlhbCBidWcg
dGhhdCBoYXMNCj4gYmVlbiB0aGVyZSBmb3IgYSBsb25nIHRpbWUuICBJIGxvb2sgYXQgdGhlIGNv
ZGUsIGFuZCBmb3VuZCB0d28NCj4gc3VzcGljaW91cyBzdHVmZiBpbiBqYmQyLiAgVGhlIGZpcnN0
IG9uZSBpcyBpbiBkb19nZXRfd3JpdGVfYWNjZXNzKCkuDQo+IEluIHRoaXMgZnVuY3Rpb24gd2Ug
Zm9yZ290IHRvIGxvY2sgYmggc3RhdGUgd2hlbiB3ZSBjaGVjayBiX2psaXN0ID09DQo+IEJKX1No
YWRvdy4gIEkgZ2VuZXJhdGUgYSBwYXRjaCB0byBmaXggaXQsIGFuZCBJIHJlYWxseSB0aGluayBp
dCBpcyB0aGUNCj4gcm9vdCBjYXVzZS4gIEZ1cnRoZXIsIGluIF9fam91cm5hbF9yZW1vdmVfam91
cm5hbF9oZWFkKCkgd2UgY2hlY2sNCj4gYl9qbGlzdCA9PSBCSl9Ob25lLiAgQnV0LCB3aGVuIHRo
aXMgZnVuY3Rpb24gaXMgY2FsbGVkLCBiaCBzdGF0ZSB3b24ndA0KPiBiZSBsb2NrZWQgc29tZXRp
bWVzLiAgU28gSSBzdXNwZWN0IHRoaXMgaXMgd2h5IHdlIGhpdCBhIEJVRyBpbg0KPiBqYmQyX2pv
dXJuYWxfcHV0X2pvdXJuYWxfaGVhZCgpLiAgQnV0IEkgZG9uJ3QgaGF2ZSBhIGdvb2Qgc29sdXRp
b24gdG8NCj4gZml4IHRoaXMgdW50aWwgbm93IGJlY2F1c2UgSSBkb24ndCBrbm93IHdoZXRoZXIg
d2UgbmVlZCB0byBsb2NrIGJoIHN0YXRlDQo+IGhlcmUsIG9yIG1heWJlIHdlIHNob3VsZCByZW1v
dmUgdGhpcyBhc3NlcnRhdGlvbi4NCj4NCj4gU28sIGdlbmVyYWxseSwgVG9ueSwgRXVuYm9uZywg
Y291bGQgeW91IHBsZWFzZSB0cnkgdGhlIGZvbGxvd2luZyBwYXRjaD8NCj4NCj4gVGhhbmtzIGlu
IGFkdmFuY2UsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIC0gWmhlbmcNCg0KDQpIaSwgSSB0ZXN0ZWQgeW91ciBwYXRjaC4gVW5mb3J0dW5hdGVseSwg
dGhlIHNhbWUgcHJvYmxlbSB3YXMgcmVwcm9kdWNlZC4NClRoYW5rcy4NCg==


