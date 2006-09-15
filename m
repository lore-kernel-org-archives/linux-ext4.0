From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: ext2 lock contention
Date: Fri, 15 Sep 2006 20:33:46 +0000
Message-ID: <1158352426.12076.57.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53962 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751415AbWIOUds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 16:33:48 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8FKXlTO006328
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 16:33:47 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8FKXlJL270490
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 16:33:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8FKXlqB013789
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 16:33:47 -0400
To: Valerie Henson <val_henson@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Val,
Do you remember this patch:
[PATCH] Make EXT2_DEBUG work again
http://www.kernel.org/git/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=21730eed11de42f22afcbd43f450a1872a0b5ea1

The second part causes a 30% performance degradation running dbench with
16 threads.

> Second, debug versions of ext2_count_free_{inodes/blocks} reacquires
> superblock lock.  Moved lock into callers.

The problem is that before your patch, the superblock lock was taken
only when EXT2_DEBUG was enabled, but with your patch, the superblock
lock is held during the entire call to ext2_statfs() with our without
EXT2_DEBUG defined.

Was there a reason the lock needed to be held across both calls?  Since
the patch didn't mention fixing the non-debug case, I assume the lack of
the lock in the non-debug case was okay.
-- 
David Kleikamp
IBM Linux Technology Center

