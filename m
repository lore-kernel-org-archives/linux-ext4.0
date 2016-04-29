From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH v4 2/3] ext4: fix races between changing inode journal mode
 and ext4_writepages
Date: Fri, 29 Apr 2016 01:06:22 +0000 (GMT)
Message-ID: <526058841.218421461891981863.JavaMail.weblogic@ep2mlwas06b>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52687 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbcD2BG1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Apr 2016 21:06:27 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O6D01GJSF2NP6C0@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 29 Apr 2016 10:06:23 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SGkgVGVkLA0KDQpJIGZ1bGx5IHVuZGVyc3Rvb2QgeW91ciB3b3JkcyBhbmQgSSBoYXZlIGJlZW4g
ZXhlY3V0aW5nIGdlbmVyaWMvMjMxIHRlc3QgY2FzZQ0KYWdhaW4gYW5kIGFnYWluIHdpdGggbGlu
dXgtNC42LjAtcmM0LCBsaW51eC00LjYuMC1yYzUgYW5kIHRoZSBsYXRlc3Qgc291cmNlIGNvZGVz
DQpvZiBleHQ0IGdpdCBzZXJ2ZXIuDQoNCkJ1dCwgd2hlbmV2ZXIgSSBleGVjdXRlIHRoZSB0ZXN0
IGNhc2UsIGl0IGlzIGFsd2F5cyBwYXNzZWQuDQpJIHRoaW5rIHRoZSBkaWZmZXJlbmNlIG9mIHRo
ZSB0ZXN0IHJlc3VsdHMgaXMgb3JpZ2luYXRlZCBmcm9tIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4N
CnlvdXIgdGVzdCBlbnZpcm9ubWVudCBhbmQgbWluZSwgaG93ZXZlciBJIGNhbm5vdCBmaWd1cmUg
b3V0IHRoYXQuDQoNCkFjdHVhbGx5LCBJIGp1c3QgdXNlZCBrdm0teGZ0ZXN0cyBiZWNhdXNlIEdD
RSBzaXRlIGNhbm5vdCBiZSBhY2Nlc3NlZCBpbg0Kb3VyIGNvbXBhbnkgYnkgc2VjdXJpdHkgcmVh
c29ucy4NCg0KQ291bGQgeW91IHN1Z2dlc3Qgc29tZSBkaXJlY3Rpb25zIGZvciBtZT8NCg==


