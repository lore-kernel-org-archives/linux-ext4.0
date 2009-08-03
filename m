From: Nick Dokos <nicholas.dokos@hp.com>
Subject: ll_ver_fs data verification failure - 96TB fs
Date: Mon, 03 Aug 2009 09:54:36 -0400
Message-ID: <28623.1249307676@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173019pub.verizon.net ([206.46.173.19]:44192 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbZHCNyn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 09:54:43 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173019.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KNS003DOZYQJ4U3@vms173019.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Mon, 03 Aug 2009 08:54:31 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a heads-up for now. I ran ll_ver_fs on a 96TB fs - the write phase
finished without problems, but the read phase encountered a problem:

...
read File name: /mnt/dir00373/file026

liverfs: verify /mnt/dir00373/file026 failed offset/timestamp/inode 3244298240/1248819541/1096796: found 3243249664/1248819541/1096796 instead

liverfs: Data verification failed
770.45user 218639.65system 67:38:18elapsed 90%CPU (0avgtext+0avgdata 0maxresident)k
100357573552inputs+195522668184outputs (1major+414minor)pagefaults 0swaps
make: *** [llver] Error 2


The offset difference is exactly 1M, and it occurs about 3GB into the file.

In total, there are 726 directories, each with 32 4GB files (except the last,
which only has 12 files). So directory 373 is roughly half-way. I'll take a look
at the block allocation of both the directory and the file and see if they are
straddling the 16TB boundary (or other such).

Running a fsck now to see if there are other problems.

Thanks,
Nick
