From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [BUG][PATCH 1/4] ext3: fix a cause of __schedule_bug via
 blkdev_releasepage
Date: Tue, 2 Dec 2008 20:06:47 +0900
Message-ID: <20081202200647.72cc5807.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34317 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYLBLUW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 06:20:22 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mB2BKIG1002324
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 2 Dec 2008 20:20:18 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id D4D6D45DD77
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:20:17 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id A13EF45DD79
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:20:17 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 775681DB803F
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:20:17 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2D99F1DB803A
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:20:14 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3: fix a cause of __schedule_bug via blkdev_releasepage
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

A cause of this problem is calling log_wait_commit() on 
journal_try_to_free_buffers() with a read-lock via blkdev_releasepage(). This 
logic is for uncommitted data buffers. And a read/write-lock is required for a 
client usage of blkdev_releasepage.

By the way, we want to release only metadata buffers on ext3_release_metadata().
Because a page which binds to blkdev is used as metadata for ext3.

Therefore we don't need to wait for a commit on journal_try_to_free_buffers() 
via ext3_release_matadata().
As a result, we add a journal_try_to_free_metadata_buffers() almost same 
as journal_try_to_free_buffers() except not calling log_wait_commit.
So, we change journal_try_to_free_buffers() with 
journal_try_to_free_metadata_buffers().

This issue was reported by Aneesh Kumar K.V.
http://marc.info/?l=linux-ext4&m=122814568309893&w=2

Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: "Theodore Ts'o" <tytso@mit.edu>
--
 fs/ext3/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -Nurp linux-2.6.28-rc6/fs/ext3/inode.c linux-2.6.28-rc6.2/fs/ext3/inode.c
--- linux-2.6.28-rc6/fs/ext3/inode.c	2008-12-02 09:32:27.000000000 +0900
+++ linux-2.6.28-rc6.2/fs/ext3/inode.c	2008-12-02 10:19:53.000000000 +0900
@@ -1696,7 +1696,7 @@ int ext3_release_metadata(void *client, 
 	BUG_ON(EXT3_SB(sb) == NULL);
 	journal = EXT3_SB(sb)->s_journal;
 	if (journal != NULL)
-		return journal_try_to_free_buffers(journal, page, wait);
+		return journal_try_to_free_metadata_buffers(journal, page, wait);
 	else
 		return try_to_free_buffers(page);
 }
