From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Fri, 06 May 2016 05:35:56 +0000 (GMT)
Message-ID: <1656879517.452811462512954933.JavaMail.weblogic@ep2mlwas08c>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>,
	=?utf-8?Q?=EC=9D=B4=EA=B8=B0=ED=83=9C?= <kitae87.lee@samsung.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39318 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbcEFFf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2016 01:35:58 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O6Q02LTFQ7WRM90@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 06 May 2016 14:35:56 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PiBTbyBjYW4geW91IHNoYXJlIGEgcmVwcm9kdWNlciBmb3IgdGhpcyBpc3N1ZT8gQmVjYXVzZSBt
eSBpbml0aWFsIHRoaW5raW5nDQo+IGlzIHRoYXQgY2hlY2tzIGR1cmluZyByZW1vdW50IHNob3Vs
ZCBmYWlsIHRoZSByZW1vdW50IHdpdGggRUJVU1kgaWYgdGhlcmUNCj4gaXMgYW55IG1vZGlmaWNh
dGlvbiBvdXRzdGFuZGluZy4uLiBJZiB0aGV5IGRvbid0IHdlIGhhdmUgYSByYWN5IHJlbW91bnQg
YW5kDQo+IGZzLWZyZWV6aW5nIGNvZGUsIHdoaWNoIGlzIGEgYnVnLg0KDQpIaSBKYW4sDQoNClNv
cnJ5IHRvIG1ha2UgeW91IGNvbmZ1c2VkLiBNeSBwYXRjaCBkZXNjcmlwdGlvbiB3YXMgbGl0dGxl
IHdyb25nLg0KSSBtZWFudCBvbmx5IHRoZSBlbWVyZ2VuY3kgcmVhZC1vbmx5IHJlbW91bnQgY2Fz
ZSwgbm90IHRoZSBub3JtYWwgcmVhZC1vbmx5DQpyZW1vdW50IGNhc2UuIEFuZHJvaWQgaXMgY3Vy
cmVudGx5IHVzaW5nIGVtZXJnZW5jeSBybyByZW1vdW50IGZvciB0aGUgZGV2aWNlDQpzaHV0ZG93
biBwcm9jZWR1cmUuDQoNCldlIGNhbiBlYXNpbHkgcmVwcm9kdWNlIHRoaXMgcHJvYmxlbSwgYnV0
IHdlIGRpZG4ndCBtYWtlIGEgVEMgZm9yIHhmc3Rlc3QgeWV0Lg0KSWYgd2UgZGlkIHRoYXQsIEkg
d2lsbCBsZXQgeW91IGtub3cuDQo=


