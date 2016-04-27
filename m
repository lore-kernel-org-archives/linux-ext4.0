From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH v4 2/3] ext4: fix races between changing inode journal mode
 and ext4_writepages
Date: Wed, 27 Apr 2016 08:04:11 +0000 (GMT)
Message-ID: <1319414639.152111461744250568.JavaMail.weblogic@ep2mlwas01c>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "jack@suse.cz" <jack@suse.cz>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40355 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbcD0IET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Apr 2016 04:04:19 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O6A01UXF92ZOB10@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 27 Apr 2016 17:04:11 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T29wcywgc29ycnkgYWJvdXQgY2F1c2luZyB0aGUgcmVncmVzc2lvbi4NCg0KQnV0IGluIHRoZSB2
ZXJzaW9uIEkgd29ya2VkIG9uLCB3ZSBwYXNzZWQgdGhlIHRlc3QgY2FzZSBhbmQNCndlIHN0aWxs
IHBhc3MgdGhhdC4gSSBleGVjdXRlZCB0aGUgdGVzdCBjYXNlIGFzIGJlbG93cy4NCg0Ka3ZtLXhm
c3Rlc3RzIC1jIDFrIC1DIDEwIGdlbmVyaWMvMjMxDQoNCkkgYW0gZ29pbmcgdG8gcmV0cnkgdGhl
IHRlc3QgdXNpbmcgR0NFIHdpdGggdGhlIGxhdGVzdCBrZXJuZWwgdmVyc2lvbi4NClNvcnJ5IGFn
YWluLg0K


