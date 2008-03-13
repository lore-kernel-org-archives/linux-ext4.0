From: Christian Kujau <lists@nerdbynature.de>
Subject: e2fsck -D segfaults in pass 3A
Date: Thu, 13 Mar 2008 21:23:19 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803132116430.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:37232 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYCMUXW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 16:23:22 -0400
Received: from [89.49.156.246] (helo=[192.168.178.25])
	by mail.g-house.de with esmtpa (Exim 4.63)
	(envelope-from <lists@nerdbynature.de>)
	id 1JZtxQ-0000eI-SB
	for linux-ext4@vger.kernel.org; Thu, 13 Mar 2008 21:23:21 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After playing around with e2fsck (today's git of the "pu" branch) a bit 
more, I still cannot use -D on this filesystem. I've tried with earlier 
version, but it still dumps core in pass 3A (Optimizing directories). I've 
compiled e2fsprogs with "CFLAGS="-g" ./configure --enable-htree; make", 
too get a few more results when this happens. Running under gdb gives:

(gdb) run -Dfv /dev/md4
Starting program: /opt/e2fsprogs/sbin/e2fsck -Dfv /dev/md4
e2fsck 1.40.7 (28-Feb-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories

Program received signal SIGSEGV, Segmentation fault.
0x08065bb9 in ino_cmp (a=0x8898fe90, b=0x898feb0) at rehash.c:173
173	rehash.c: No such file or directory.
 	in rehash.c

The full backtrace: http://nerdbynature.de/bits/e2fsprogs.pu/e2fsck-1.40.7-Dfv.log

The filesystem in question has been created in 11/2007 - maybe I missed 
some on-disk changes since then and have to recreate the fs?

Thanks,
Christian.
-- 
BOFH excuse #86:

Runt packets
