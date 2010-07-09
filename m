From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: Repost (from LKML): EXT3 FS and 64K blocks error
Date: Thu, 8 Jul 2010 17:10:15 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AEE9@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam1.wdc.com ([129.253.170.130]:17129 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab0GIAUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jul 2010 20:20:20 -0400
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We're getting the following error with an EXT3 file sytem that
has 64K blocks (2.6.32.12, on a powerpc), although I don't see
any fixes for later kernels in a diff against 2.6.35-rc3):

ext3_readdir: bad entry in directory #11: rec_len is smaller than minimal -
offset=0, inode=0, rec_len=0, name_len=0

That message is generated in fs/ext3/dir.c:ext3_check_dir_entry()
when called from fs/ext3/dir.c:ext3_readdir(), AFAICT.

Did something get missed when EXT3 handling for 64K blocks was
implemented or when a new feature was added?

FWIW, I do NOT see this on EXT4.

Dan Taylor

Dan Taylor
Sr. Staff Engineer
WD Branded Products
949.672.7761 
