From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/2] ext[34]: Make sure we initialize the b_bdev field of dummy buffer_heads
Date: Thu, 12 Nov 2009 00:01:00 +0530
Message-ID: <1257964260-14020-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1257964260-14020-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53337 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbZKKSbF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Nov 2009 13:31:05 -0500
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id nABIV9Bk000999
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:31:09 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nABIRxYt1769664
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:27:59 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nABIV81R020727
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:31:08 +1100
In-Reply-To: <1257964260-14020-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

buffer_head flag update trace point look at the b_bdev field to track
the backing device. For dummy buffer_heads used we expect this to be
NULL.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c       |    1 +
 fs/ext3/inode.c   |    1 +
 fs/ext4/inode.c   |    1 +
 fs/jbd/journal.c  |    1 +
 fs/jbd2/journal.c |    2 ++
 fs/mpage.c        |    1 +
 6 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6f441aa..5c60fa3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2923,6 +2923,7 @@ sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 	struct inode *inode = mapping->host;
 	tmp.b_state = 0;
 	tmp.b_blocknr = 0;
+	tmp.b_bdev = NULL;
 	tmp.b_size = 1 << inode->i_blkbits;
 	get_block(inode, block, &tmp, 0);
 	return tmp.b_blocknr;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index acf1b14..c7508aa 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1007,6 +1007,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
+	dummy.b_bdev = NULL;
 	buffer_trace_init(&dummy.b_history);
 	err = ext3_get_blocks_handle(handle, inode, block, 1,
 					&dummy, create);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..dcb362d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1392,6 +1392,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
+	dummy.b_bdev = NULL;
 	buffer_trace_init(&dummy.b_history);
 	if (create)
 		flags |= EXT4_GET_BLOCKS_CREATE;
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index bd3c073..1572a08 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -303,6 +303,7 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
 	/* keep subsequent assertions sane */
 	new_bh->b_state = 0;
+	new_bh->b_bdev = NULL;
 	init_buffer(new_bh, NULL, NULL);
 	atomic_set(&new_bh->b_count, 1);
 	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b0ab521..f18af08 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2250,6 +2250,8 @@ const char *jbd2_dev_to_name(dev_t device)
 	struct block_device *bd;
 	static struct devname_cache *new_dev;
 
+	if (!device)
+		return "NULL";
 	rcu_read_lock();
 	if (devcache[i] && devcache[i]->device == device) {
 		ret = devcache[i]->devname;
diff --git a/fs/mpage.c b/fs/mpage.c
index 42381bd..eb72426 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -381,6 +381,7 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
+	map_bh.b_bdev = NULL;
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
-- 
1.6.5.2.74.g610f9

