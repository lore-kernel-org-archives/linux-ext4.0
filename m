From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH] ext4: make sure to revoke all the freeable blocks in
 ext4_free_blocks
Date: Thu, 17 Dec 2015 00:21:40 +0000 (GMT)
Message-ID: <1384180737.796401450311698973.JavaMail.weblogic@epmlwas02b>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:44287 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbbLQAVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Dec 2015 19:21:41 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NZH0323B7O44740@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Dec 2015 09:21:40 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SXQgbG9va3MgY2xlYXJlci4gSSB3aWxsIG1vZGlmeSB0aGUgY29uZGl0aW9uIGFzIHlvdSBtZW50
aW9uZWQuDQoNClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcuIDotKQ==


