From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH v2 2/3] ext4: fix races between changing inode journal mode
 and ext4_writepages
Date: Wed, 02 Mar 2016 01:21:35 +0000 (GMT)
Message-ID: <199292570.46101456881693870.JavaMail.weblogic@ep2mlwas09c>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "kbuild-all@01.org" <kbuild-all@01.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	daeho.jeong@samsung.com
To: kbuild test robot <lkp@intel.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"jack@suse.cz" <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48268 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708AbcCBBVk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2016 20:21:40 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O3E01SLF140W610@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 02 Mar 2016 10:21:36 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T29wcywgVGhpcyBidWlsZCBlcnJvciBsb2cgaXMgZ2VuZXJlYXRlZCB3aGVuIGJ1aWxkaW5nIGV4
dDQgZmlsZXN5c3RlbSBhcyBhIG1vZHVsZSBhbmQNCnRoaXMgaXMgb3JpZ2luYXRlZCBmcm9tIHRo
YXQgInBlcmNwdV9mcmVlX3J3c2VtKCkiIGZ1bmN0aW9uIHdhcyBub3QgZGVmaW5lZCBhcyBhbiBl
eHBvcnRlZA0KZnVuY3Rpb24uDQoNCkNvdWxkIEkgZGVmaW5lIHRoZSAicGVyY3B1X2ZyZWVfcndz
ZW0oKSIgZnVuY3Rpb24gYXMgYW4gZXhwb3J0ZWQgZnVuY3Rpb24gZGlyZWN0bHkgaW4gdGhpcyBw
YXRjaD8NCk9yIGRvIEkgaGF2ZSB0byByZXF1ZXN0IHRoZSBtYWludGFpbmVyIG9mIHBlcmNwdV9y
d3NlbSB0byBkbyB0aGlzPw0KDQpUaGFuayB5b3UgaW4gYWR2YW5jZS4gOi0pDQoNCj4gdXJsOiAg
ICBodHRwczovL2dpdGh1Yi5jb20vMGRheS1jaS9saW51eC9jb21taXRzL0RhZWhvLUplb25nL2V4
dDQtaGFuZGxlLXVud3JpdHRlbi1vci1kZWxhbGxvYy1idWZmZXJzLWJlZm9yZS1lbmFibGluZy1w
ZXItZmlsZS1kYXQ+IGEtam91cm5hbGluZy8yMDE2MDIyOS0wNzUxMTcNCj4gYmFzZTogICBodHRw
czovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90eXRzby9leHQ0Lmdp
dCBkZXYNCj4gY29uZmlnOiB4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMjI5MDgyOCAoYXR0YWNoZWQg
YXMgLmNvbmZpZykNCj4gcmVwcm9kdWNlOg0KPiAgICAgICAgICMgc2F2ZSB0aGUgYXR0YWNoZWQg
LmNvbmZpZyB0byBsaW51eCBidWlsZCB0cmVlDQo+ICAgICAgICAgbWFrZSBBUkNIPXg4Nl82NCAN
Cg0KPiBBbGwgZXJyb3JzIChuZXcgb25lcyBwcmVmaXhlZCBieSA+Pik6DQoNCj4gPj4gRVJST1I6
ICJwZXJjcHVfZnJlZV9yd3NlbSIgW2ZzL2V4dDQvZXh0NC5rb10gdW5kZWZpbmVkIQ==


