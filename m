From: "PaX Team" <pageexec@freemail.hu>
Subject: possible unintended integer truncation in fs/ext4/extents.c:get_implied_cluster_alloc
Date: Sat, 14 Dec 2013 23:29:18 +0100
Message-ID: <52ACDBBE.32014.145F911E@pageexec.freemail.hu>
Reply-To: pageexec@freemail.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: re.emese@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from r00tworld.com ([212.85.137.150]:36610 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3LNWov (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Dec 2013 17:44:51 -0500
Content-description: Mail message body
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello folks,

while running a simple analyzer plugin on linux 3.12.5 written by Emese Revfy
we found a case in ext4 that looks like a potential problem. the code looks
like this:

4082 		map->m_pblk = (ee_start & ~(sbi->s_cluster_ratio - 1)) +
4083 			c_offset;

here the expression ~(sbi->s_cluster_ratio - 1) will first do the negation
on an unsigned int then extend the result to unsigned long long (i.e, there's
a 32->64 bit conversion on both 32 and 64 bit archs) and stores it as such.
now this will obviously lose the higher 32 bits of ee_start and the question
is: is this intended behaviour or a bug? later the code compares map->m_pblk
against ee_block which is as unsigned int only so there's some mixture of
integer types here that may warrant further review.

cheers,
 PaX Team

