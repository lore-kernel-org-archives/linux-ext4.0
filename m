From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH 1/3] ext4: handle unwritten or delalloc buffers before
 enabling per-file data journaling
Date: Tue, 01 Dec 2015 04:42:57 +0000 (GMT)
Message-ID: <172779421.90491448944976300.JavaMail.weblogic@epmlwas04c>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48073 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbbLAEm7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Nov 2015 23:42:59 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYN018DXX3LU980@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 01 Dec 2015 13:42:57 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

VGhhbmsgeW91LCBKYW4uDQoNCj4gQ2FuIHdlIG1heWJlIHJlcGhyYXNlIHRoZSB3aG9sZSBjb21t
ZW50IGxpa2U6DQo+IA0KPiAvKiANCj4gKiBCZWZvcmUgZmx1c2hpbmcgdGhlIGpvdXJuYWwgYW5k
IHN3aXRjaGluZyBpbm9kZSdzIGFvcHMsIHdlIGhhdmUNCj4gKiB0byBmbHVzaCBhbGwgZGlydHkg
ZGF0YSB0aGUgaW5vZGUgaGFzLiBUaGVyZSBjYW4gYmUgb3V0c3RhbmRpbmcNCj4gKiBkZWxheWVk
IGFsbG9jYXRpb25zLCB0aGVyZSBjYW4gYmUgdW53cml0dGVuIGV4dGVudHMgY3JlYXRlZCBieQ0K
PiAqIGZhbGxvY2F0ZSBvciBidWZmZXJlZCB3cml0ZXMgaW4gZGlvcmVhZF9ub2xvY2sgbW9kZSBj
b3ZlcmVkIGJ5DQo+ICogZGlydHkgZGF0YSB3aGljaCBjYW4gYmUgY29udmVydGVkIG9ubHkgYWZ0
ZXIgZmx1c2hpbmcgdGhlIGRpcnR5DQo+ICogZGF0YSAoYW5kIGpvdXJuYWxsZWQgYW9wcyBkb24n
dCBrbm93IGhvdyB0byBoYW5kbGUgdGhlc2UgY2FzZXMpLg0KPiAqLw0KDQpZb3VyIGNvbW1lbnQg
aXMgbW9yZSB1bmRlcnN0YW5kYWJsZSwgc28gSSB3aWxsIGNoYW5nZSB0aGUgY29tbWVudCBpbg0K
dGhlIHBhdGNoLg0KDQo+IEJUVywgdGhlIGNvZGUgaXMgc3RpbGwgcmFjeSB3cnQgbW1hcCB3cml0
ZSBmYXVsdHMuIE9uY2UgVGVkIG1lcmdlcyBteQ0KPiBwYXRjaGVzIGZvciBob2xlIHB1bmNoaW5n
IHJhY2VzLCB3ZSBuZWVkIHRvIGdyYWIgaV9tbWFwX3NlbSBmb3Igd3JpdGluZw0KPiBoZXJlIGFz
IHdlbGwgdG8gYXZvaWQgd3JpdGUgcGFnZSBmYXVsdCBmcm9tIGNyZWF0aW5nIGRpcnR5IHBhZ2Ug
d2hpbGUgd2UNCj4gYXJlIHN3aXRjaGluZyBhb3BzLi4uIEknbSBtb3N0bHkgd3JpdGluZyB0aGlz
IGhlcmUgc28gdGhhdCB0aGVyZSdzIGxvd2VyDQo+IGNoYW5jZSB0aGlzIGdldHMgbG9zdC4NCg0K
T2suIEkndmUgcmVjb2duaXplZCBhbm90aGVyIHJhY3kgY29uZGl0aW9uIHdoZW4gc3dpdGNoaW5n
IGFvcHMgb2YgYW4gaW5vZGUuDQpJIHdpbGwgYWxzbyBjb25zaWRlciB0aGUgcG9pbnQgaW4gdjIg
b2YgdGhpcyBwYXRjaC4NCg==


