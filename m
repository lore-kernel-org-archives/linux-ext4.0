From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH 2/3] ext4: remove incorrect check for inode journal mode in
 ext4_writepages()
Date: Tue, 01 Dec 2015 04:50:58 +0000 (GMT)
Message-ID: <1763434694.90931448945457404.JavaMail.weblogic@epmlwas04c>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:54806 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbLAEu7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Nov 2015 23:50:59 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYN016Q5XGYG490@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 01 Dec 2015 13:50:58 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PiBBY3R1YWxseSB3aGF0IHlvdSBkbyBvbmx5IGhpZGVzIHRoZSByZWFsIHByb2JsZW0gLSB0aGF0
IGV4dDRfd3JpdGVwYWdlcygpDQo+IGluIG5vbi1qb3VybmFsbGVkIG1vZGUgY2FuIGJlIHN0aWxs
IHJ1bm5pbmcgZm9yIGFuIGlub2RlIHdoaWNoIGlzIGFscmVhZHkNCj4gc3dpdGNoZWQgdG8gam91
cm5hbGxlZCBtb2RlLiBJbiB0aGVvcnkgaWYgd2UgbWFuYWdlIHRvIGRpcnR5IHNvbWUgcGFnZXMN
Cj4gYWZ0ZXIgdGhlIHN3aXRjaCwgbm9uLWpvdXJuYWxsZWQgd3JpdGVwYWdlcyAqY2FuKiBzZWUg
dGhlbSBhbiB0cnkgdG8gd3JpdGUNCj4gdGhlbSBiYWNrIHdoaWNoIHdpbGwgYnJlYWsgc3BlY3Rh
Y3VsYXJseS4gU28gdG8gZml4IHRoaXMgd2UgbmVlZCBzb21ldGhpbmcNCj4gbGlrZSBhIHdyaXRl
YmFjayBiYXJyaWVyIGZvciB0aGUgaW5vZGUgLSBtYWtlIHN1cmUgYWxsIGV4dDRfd3JpdGVwYWdl
cygpDQo+IGNhbGxzIGhhdmUgY29tcGxldGVkIGJlZm9yZSBzd2l0Y2hpbmcgYW9wcy4gTm93IEkn
ZCBoYXRlIHRvIGdyb3cgc3RydWN0DQo+IGV4dDRfaW5vZGVfaW5mbyBvbmx5IGZvciB0aGlzIGV4
dHJhIHJhcmUgY2FzZSBzbyB3ZSBjb3VsZCBwcm9iYWJseQ0KPiBpbXBsZW1lbnQgdGhlIGJhcnJp
ZXIgb24gcGVyLWZpbGVzeXN0ZW0gYmFzaXMgLSBhIGZzLXdpZGUgcGVyLWNwdSBydw0KPiBzZW1h
cGhvcmUgYWNxdWlyZWQgZm9yIHJlYWRpbmcgd2hpbGUgZXh0NF93cml0ZXBhZ2VzKCkgcnVucyBh
bmQgYWNxdWlyZWQNCj4gZm9yIHdyaXRpbmcgd2hlbiB3ZSBzd2l0Y2ggYW9wcyBmb3Igc29tZSBp
bm9kZS4NCg0KWWVzLCB0aGVyZSBpcyBhbm90aGVyIGlzc3VlIHRoYXQgbmV3bHkgZGlydGllZCBw
YWdlcyBhZnRlciB0aGUgc3dpdGNoIGNhbiBiZQ0Kc2hvd24gaW4gZXh0NF93cml0ZXBhZ2VzKCkg
aW4gbm9uLWpvdXJuYWxsZWQgbW9kZS4gSSBvdmVybG9va2VkIHRoYXQgcG9pbnQuDQpBY2NvcmRp
bmcgdG8geW91ciBjb21tZW50LCBJIHdpbGwgbW9kaWZ5IHRoaXMgcGF0Y2guDQoNClRoYW5rIHlv
dSwgYWdhaW4uDQo=


