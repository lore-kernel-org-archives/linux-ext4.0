From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Mon, 13 May 2013 07:26:55 +0000 (GMT)
Message-ID: <17643170.28271368430013771.JavaMail.weblogic@epml07>
Reply-To: eunb.song@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Tony Luck <tony.luck@gmail.com>,
	Mike Galbraith <bitbucket@online.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3EMH05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 03:26:57 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMQ00AIU7CJ3ZX0@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 13 May 2013 16:26:56 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

DQoNCkhpLA0KSSBoYXZlIHNvbWUgcHJvYmxlbSB0byBib290IHdpdGggMy4xMC1yYzEuICBTbyBp
IHdpbGwgdGVzdCB3aXRoIGUwZmQ5YWZmZWI2NDA4OGVmZjQwN2RmYzk4YmJkM2E1YzE3ZWE0Nzku
DQpUaGUgY29tbWl0IG1lc3NhZ2UgaXMgYXMgZm9sbG93Lg0KY29tbWl0IGUwZmQ5YWZmZWI2NDA4
OGVmZjQwN2RmYzk4YmJkM2E1YzE3ZWE0NzkNCk1lcmdlOiAzZDE1Yjc5IGVhOTYyN2MNCkF1dGhv
cjogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KRGF0ZTog
ICBXZWQgTWF5IDggMTU6Mjk6NDggMjAxMyAtMDcwMA0KDQogICAgTWVyZ2UgdGFnICdyZG1hLWZv
ci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3JvbGFuZC9pbmZpbmliYW5kDQoNCg0KVXN1YWxseSwgdGhlIHByb2JsZW0gd2FzIHJlcHJvZHVj
ZWQgaW4gMzAgc2Vjb25kcyBpbiBteSBib2FyZC4gDQpJIHdpbGwgdGVzdCBvbmx5IHJldmVydCBh
ZTQ2NDdmYjc2NTQ2NzZmYzQ0YTk3ZTg2ZWIzNWY5ZjA2Yjk5ZjY2KGpiZDI6IHJlZHVjZSBqb3Vy
bmFsX2hlYWQgc2l6ZSkgYW5kIA0KaSB3aWxsIGxldCB5b3Uga25vdyB0aGUgdGVzdCByZXN1bHQu
IA0KDQpUaGFua3Mu


