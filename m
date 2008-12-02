From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [BUG][PATCH 2/4] ext4: fix a cause of __schedule_bug via
 blkdev_releasepage
Date: Tue, 2 Dec 2008 20:09:12 +0900
Message-ID: <20081202200912.493b2e8c.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54147 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbYLBLWm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 06:22:42 -0500
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mB2BMdD5020499
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 2 Dec 2008 20:22:39 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 901D045DE53
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:22:39 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 6039245DE3A
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:22:39 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 3201FE08001
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:22:39 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id DD2951DB8041
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:22:38 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: fix a cause of __schedule_bug via blkdev_releasepage
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

A cause of this problem is calling jbd2_log_wait_commit() on 
jbd2_journal_try_to_free_buffers() with a read-lock via blkdev_releasepage(). 
This logic is for uncommitted data buffers. And a read/write-lock is required 
for a client usage of blkdev_releasepage.

By the way, we want to release only metadata buffers on ext4_release_metadata().
Because a page which binds to blkdev is used as metadata for ext4.

Therefore we don't need to wait for a commit on 
jbd2_journal_try_to_free_buffers() via ext4_release_matadata().
As a result, we add a jbd2_journal_try_to_free_metadata_buffers() almost same 
as jbd2_journal_try_to_free_buffers() except not calling jbd2_log_wait_commit().
So, we change jbd2_journal_try_to_free_buffers() with 
jbd2_journal_try_to_free_metadata_buffers().

This issue was reported by Aneesh Kumar K.V.
http://marc.info/?l=linux-ext4&m=122814568309893&w=2

Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: "Theodore Ts'o" <tytso@mit.edu>
--
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -Nurp linux-2.6.28-rc6/fs/ext4/inode.c linux-2.6.28-rc6.2/fs/ext4/inode.c
--- linux-2.6.28-rc6/fs/ext4/inode.c	2008-12-02 09:32:27.000000000 +0900
+++ linux-2.6.28-rc6.2/fs/ext4/inode.c	2008-12-02 09:52:46.000000000 +0900
@@ -3018,7 +3018,7 @@ int ext4_release_metadata(void *client, 
 	BUG_ON(EXT4_SB(sb) == NULL);
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal != NULL)
-		return jbd2_journal_try_to_free_buffers(journal, page, wait);
+		return jbd2_journal_try_to_free_metadata_buffers(journal, page, wait);
 	else
 		return try_to_free_buffers(page);
 }
