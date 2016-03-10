From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH v3 2/3] ext4: fix races between changing inode journal mode
 and ext4_writepages
Date: Thu, 10 Mar 2016 22:20:51 +0000 (GMT)
Message-ID: <1215152764.118411457648450728.JavaMail.weblogic@ep2mlwas08b>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:59687 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbcCJWUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Mar 2016 17:20:54 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O3U001SXGQR6BA0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 11 Mar 2016 07:20:51 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PiBZb3UgbmVlZCB0byBjaGFuZ2UgaG93IGRheF93cml0ZWJhY2tfbWFwcGluZ19yYW5nZSgpIGlz
IGNhbGxlZCBhIGZldyBsaW5lcw0KPiBiZWxvdyBzbyB0aGF0IGl0IGFsc28gZXhpdHMgdmlhIG91
dF93cml0ZXBhZ2VzOiBhbmQgbm90IGRpcmVjdGx5Lg0KDQpPb3BzLCBJIGZvdW5kIHRoYXQgSSBt
YWRlIHRoaXMgcGF0Y2ggb24gYSBsaXR0bGUgb2xkIHZlcnNpb24gd2hlcmUgZXh0NF93cml0ZXBh
Z2VzKCkNCmRvZXNuJ3QgdXNlIGRheF93cml0ZWJhY2tfbWFwcGluZ19yYW5nZSgpIGZ1bmN0aW9u
LiBTb3JyeSBhYm91dCB0aGF0Lg0KSSdsbCBmaXggdGhpcyBwcm9ibGVtLg0KDQpUaGFuayB5b3Uu
IDotKQ==


