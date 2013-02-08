From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 10/10 v5] ext4: remove bogus wait for unwritten extents in ext4_ind_direct_IO
Date: Fri,  8 Feb 2013 16:44:06 +0800
Message-ID: <1360313046-9876-11-git-send-email-wenqing.lz@taobao.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Jan kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42438 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029Ab3BHIai (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2013 03:30:38 -0500
Received: by mail-pa0-f51.google.com with SMTP id hz1so1887895pad.38
        for <linux-ext4@vger.kernel.org>; Fri, 08 Feb 2013 00:30:38 -0800 (PST)
In-Reply-To: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After converting unwritten extents from extent status tree in end_io, we
can safely remove this bogus wait and don't worry about read stale data
because we always try to lookup a block mapping in extent status tree
firstly and unwritten extents in the tree has been converted at this
time.

Before that commit, we need to flush unwritten ios before a dio read
when dioread_nolock is enabled because in ext4_end_io_buffer_write and
ext4_end_bio end_page_writeback() is called before converting unwritten
extents in disk.  So here is a window that a dio reader will read stale
data as below if we don't wait for unwritten extents:

   dio read                         buffered write
                                    ->ext4_file_write
                                      ->ext4_da_write_begin
                                      ->ext4_da_write_end
                                      [buffered write has finished, but
                                       the data and metadata has not
                                       been flushed]
   ->generic_file_aio_read
     ->filemap_write_and_wait_range
       ->do_writepages
         ->ext4_da_writepages
     ->filemap_fdatawait_range
       ->wait_on_page_writeback
                                    ->ext4_end_bio
                                      ->end_page_writeback
                                        [unwritten extent has not been
                                         converted]
     ->ext4_ind_direct_IO
       [here we need to flush unwritten io]

After that commit, we never need to wait for unwritten extents.

   dio read                         buffered write
                                    ->ext4_file_write
                                      ->ext4_da_write_begin
                                      ->ext4_da_write_end
                                      [buffered write has finished, but
                                       the data and metadata has not
                                       been flushed]
   ->generic_file_aio_read
     ->filemap_write_and_wait_range
       ->do_writepages
         ->ext4_da_writepages
     ->filemap_fdatawait_range
       ->wait_on_page_writeback
                                    ->ext4_end_bio
                                      ->ext4_es_convert_unwritten_extents
                                      ->end_page_writeback
                                        [unwritten extent has not been
                                         converted in disk, but they are
                                         converted in extent status tree]
     ->ext4_ind_direct_IO
       [here we will see the written
        extents in extent status tree]


Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 20862f9..993247c 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -807,11 +807,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 retry:
 	if (rw == READ && ext4_should_dioread_nolock(inode)) {
-		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
-			mutex_lock(&inode->i_mutex);
-			ext4_flush_unwritten_io(inode);
-			mutex_unlock(&inode->i_mutex);
-		}
 		/*
 		 * Nolock dioread optimization may be dynamically disabled
 		 * via ext4_inode_block_unlocked_dio(). Check inode's state
-- 
1.7.12.rc2.18.g61b472e

