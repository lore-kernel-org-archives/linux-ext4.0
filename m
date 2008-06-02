From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Mon, 02 Jun 2008 15:29:57 +0200
Message-ID: <4843F5D5.3000101@bull.net>
References: <48402253.8040407@bull.net> <1212169712.8596.76.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41568 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYFBNaV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 09:30:21 -0400
In-Reply-To: <1212169712.8596.76.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming wrote:
> I also wondering if you get a chance to test larger inode (>256 bytes=
)
> with uninit group and flex bg?=20
I already made some tests with 512-byte inodes with the above options,
and that's ok, but I didn't launch stress tests and performance tests
in this configuration.
No problem to do it.
   Val=C3=A9rie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
