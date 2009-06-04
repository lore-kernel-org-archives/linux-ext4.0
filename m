From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 4/4] ext4: Add WARN_ON on unmapped dirty buffer_heads in writepage
Date: Thu,  4 Jun 2009 11:40:05 +0530
Message-ID: <1244095805-17015-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1244095805-17015-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34480 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZFDGK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 02:10:56 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5467n9I005128
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:07:49 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n546AvXX880694
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:10:57 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n546Aur8013311
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:10:57 +1000
In-Reply-To: <1244095805-17015-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now we have block_lock_hole_extend clearing the dirty flag of
buffer_heads outside i_size we should not find buffer_heads
which are unmapped and dirty in writepage. If we find do a WARN_ON.
We can still continue because block_write_full page look at the mapped
flag only.

Following sequence of events would result in the above condition.
1) truncate(f, 1024)
2) mmap(f, 0, 4096)
3) a[0] = 'a'
4) truncate(f, 4096)
5) writepage(...)

After step 3 we would have unmapped buffer_heads outside i_size.
After step 4 we would have unmapped buffer_heads within i_size.

Now that truncate is calling block_lock_hole_extend which in turn
is clearing the dirty flag, we can safely assume that we won't
find unmapped dirty buffer_heads in write page. If we did find one
we should find out why.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2219daa..9bba474 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2488,6 +2488,10 @@ static int __ext4_journalled_writepage(struct page *page,
 	return ret;
 }
 
+static int ext4_bh_unmapped_and_dirty(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh) && buffer_dirty(bh);
+}
 
 /*
  * Note that we don't need to start a transaction unless we're journaling data
@@ -2602,6 +2606,14 @@ static int ext4_writepage(struct page *page,
 		/* now mark the buffer_heads as dirty and uptodate */
 		block_commit_write(page, 0, len);
 	}
+	/*
+	 * There should not be any unmapped and dirty
+	 * buffer_heads at this point. Look at block_lock_hole_extend
+	 * for more info. If we find one print more info
+	 */
+	 WARN(walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+				 ext4_bh_unmapped_and_dirty),
+		 "Unmapped dirty buffer_heads found in %s\n", __func__);
 
 	if (PageChecked(page) && ext4_should_journal_data(inode)) {
 		/*
-- 
1.6.3.1.244.gf9275

