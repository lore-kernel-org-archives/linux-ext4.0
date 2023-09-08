Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5751CEE57E7
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Sep 2023 09:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbjIHJdU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 8 Sep 2023 05:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjIHJdT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Sep 2023 05:33:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A6711B
        for <linux-ext4@vger.kernel.org>; Fri,  8 Sep 2023 02:33:15 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RhrTQ1NtWzrSct;
        Fri,  8 Sep 2023 17:31:22 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 8 Sep
 2023 17:33:12 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <chengzhihao1@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH] jbd2: Fix potential data lost in recovering journal raced with synchronizing fs bdev
Date:   Fri, 8 Sep 2023 17:28:08 +0800
Message-ID: <20230908092808.2929317-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

JBD2 makes sure journal data is fallen on fs device by sync_blockdev(),
however, other process could intercept the EIO information from bdev's
mapping, which leads journal recovering successful even EIO occurs during
data written back to fs device.

We found this problem in our product, iscsi + multipath is chosen for block
device of ext4. Unstable network may trigger kpartx to rescan partitions in
device mapper layer. Detailed process is shown as following:

  mount          kpartx          irq
jbd2_journal_recover
 do_one_pass
  memcpy(nbh->b_data, obh->b_data) // copy data to fs dev from journal
  mark_buffer_dirty // mark bh dirty
         vfs_read
	  generic_file_read_iter // dio
	   filemap_write_and_wait_range
	    __filemap_fdatawrite_range
	     do_writepages
	      block_write_full_folio
	       submit_bh_wbc
	            >>  EIO occurs in disk  <<
	                     end_buffer_async_write
			      mark_buffer_write_io_error
			       mapping_set_error
			        set_bit(AS_EIO, &mapping->flags) // set!
	    filemap_check_errors
	     test_and_clear_bit(AS_EIO, &mapping->flags) // clear!
 err2 = sync_blockdev
  filemap_write_and_wait
   filemap_check_errors
    test_and_clear_bit(AS_EIO, &mapping->flags) // false
 err2 = 0

Filesystem is mounted successfully even data from journal is failed written
into disk, and ext4/ocfs2 could become corrupted.

Fix it by comparing the wb_err state in fs block device before recovering
and after recovering.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217888
Cc: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/jbd2/recovery.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index c269a7d29a46..0fecaa6a3ac6 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -289,6 +289,8 @@ int jbd2_journal_recover(journal_t *journal)
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
+	errseq_t		wb_err;
+	struct address_space	*mapping;
 
 	memset(&info, 0, sizeof(info));
 	sb = journal->j_superblock;
@@ -306,6 +308,8 @@ int jbd2_journal_recover(journal_t *journal)
 		return 0;
 	}
 
+	mapping = journal->j_fs_dev->bd_inode->i_mapping;
+	errseq_check_and_advance(&mapping->wb_err, &wb_err);
 	err = do_one_pass(journal, &info, PASS_SCAN);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REVOKE);
@@ -327,6 +331,9 @@ int jbd2_journal_recover(journal_t *journal)
 
 	jbd2_journal_clear_revoke(journal);
 	err2 = sync_blockdev(journal->j_fs_dev);
+	if (!err)
+		err = err2;
+	err2 = errseq_check_and_advance(&mapping->wb_err, &wb_err);
 	if (!err)
 		err = err2;
 	/* Make sure all replayed data is on permanent storage */
-- 
2.39.2

