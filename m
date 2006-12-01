From: sho@tnes.nec.co.jp
Subject: Re:[RFC][PATCH 0/3] Extent base online defrag
Date: Fri, 1 Dec 2006 19:29:59 +0900
Message-ID: <20061201192959sho@rifu.tnes.nec.co.jp>
References: <014901c71509$94f435f0$4168010a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rupesh@clusterfs.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: girish@clusterfs.com
In-reply-to: <014901c71509$94f435f0$4168010a@bsd.tnes.nec.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Thank you for your further testing.

>From the test the file seems to be pretty fragmented, still the defrag
>utility gives ENOSPC error.

I found the problem of the workaround code related to journal in my
patches.  2048 blocks was always passed to ext3_journal_start so that
the journal blocks in transaction didn't exceed j_max_transaction_buffers.
However, j_max_transaction_buffers could be adjusted to the number of
filesystem blocks.  Maybe your filesystem's j_max_transaction_buffers
would be less than 2048, so the error would occur.

When the above problem occurs, the following message will be output
in syslog.  Could you check your syslog?

"JBD: e4defrag wants too many credits (2048 > XXXX)"

I am working for fixing the workaround code, but the work isn't
finished yet.  I will update my patches next week.
If you need to run my defrag soon, you can use the following
patch to avoid the above problem as the provisional solution.

After Alex's patches and my previous patches are applied,
you can apply the following patch.
---
diff -uprN -X linux-2.6.16.8-tnes-org/Documentation/dontdiff linux-2.6.16.8-tnes-org/fs/ext3/extents.c linux-2.6.16.8-work/fs/ext3/extents.c
--- linux-2.6.16.8-tnes-org/fs/ext3/extents.c	2006-12-01 10:37:28.000000000 +0900
+++ linux-2.6.16.8-work/fs/ext3/extents.c	2006-12-01 17:23:38.000000000 +0900
@@ -2738,6 +2738,7 @@ ext3_ext_replace_branches(struct ext3_ex
 	handle_t *handle = NULL;
 	unsigned jnum;
 	struct inode *inode;
+	journal_t	*journal;
 
 
 	from = from_page << (PAGE_CACHE_SHIFT - dest_tree->inode->i_blkbits);
@@ -2752,10 +2753,11 @@ ext3_ext_replace_branches(struct ext3_ex
 	 */
 	/* TODO:
 	 * Need to consider the way of calculating journal blocks
-	 * because j_max_transaction_buffer may exceed 2048
+	 * because the journal blocks may exceed j_max_transaction_buffer
 	 * if we have a deep depth.
 	 */
-	jnum = 2048;
+	journal = EXT3_JOURNAL(inode);
+	jnum = journal->j_max_transaction_buffers;
 	handle = ext3_journal_start(inode, jnum);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
@@ -3093,6 +3095,7 @@ ext3_ext_new_extent_tree(struct inode *t
 	unsigned jnum;
 	int ret = 0, err = 0, depth;
 	int last_extent = 0;
+	journal_t	*journal;
 
 	/* (blocks_per_page * count) * (extent_blocks + index_blocks)
 	 * + super_block + block_bitmap + group_descriptor
@@ -3100,10 +3103,11 @@ ext3_ext_new_extent_tree(struct inode *t
 	 */
 	/* TODO:
 	 * Need to consider the way of calculating journal blocks
-	 * because j_max_transaction_buffer may exceed 2048
+	 * because the journal blocks may exceed j_max_transaction_buffer
 	 * if we have a deep depth.
 	 */
-	jnum = 2048;
+	journal = EXT3_JOURNAL(tmp_inode);
+	jnum = journal->j_max_transaction_buffers; 
 	eh = EXT_ROOT_HDR(dest_tree);
 	eh->eh_depth = 0;
 	handle = ext3_journal_start(tmp_inode, jnum);

Cheers, Takashi
