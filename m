From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: Re: [PATCH] ext4: remove filemap_fdatawrite() when synchronizing a
 data journaled file
Date: Tue, 28 Jul 2015 21:56:10 +0000 (GMT)
Message-ID: <254116019.131881438120569873.JavaMail.weblogic@epmlwas02d>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: =?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"daehojng@gmail.com" <daehojng@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40692 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbG1V4N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jul 2015 17:56:13 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NS7033MAWXMO240@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 29 Jul 2015 06:56:10 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

U29ycnksIEkgcmUtY2hlY2tlZCB0aGUgc291cmNlIGNvZGVzIGFuZCBJIGZvdW5kIG15IG1pc3Rh
a2UuIEFjdHVhbGx5LCBJIG1lYW50IHRvDQpyZW1vdmUgdGhlIGZpbGUgZGF0YSB3cml0ZXMgaW50
byB0aGUgb3JpZ2luYWwgZmlsZSdzIGRhdGEgbG9jYXRpb24sIG5vdCBpbiBqb3VybmFsIGFyZWEs
DQp3aGVuIHRoZSBkYXRhIGpvdXJuYWxlZCBmaWxlIGlzIGZzeW5jLWVkLiBBZnRlciBtb3JlIGNv
bnNpZGVyYXRpb24gYWJvdXQgdGhhdA0KYW5kIHRlc3RpbmcgZm9yIGNvcnJlY3RuZXNzLEkgd2ls
bCBzdWJtaXQgaXQgYWdhaW4uDQoNCg==


