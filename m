From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 09/10] ext4: serialize truncate with owerwrite DIO workers V2
Date: Mon, 24 Sep 2012 15:44:19 +0400
Message-ID: <1348487060-19598-10-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54781 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2IXLoo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:44 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6549370lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:43 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara have spotted interesting issue:
There are  potential data corruption issue with  direct IO overwrites
racing with truncate:
 Like:
  dio write                      truncate_task
  ->ext4_ext_direct_IO
   ->overwrite == 1
    ->down_read(&EXT4_I(inode)->i_data_sem);
    ->mutex_unlock(&inode->i_mutex);
                               ->ext4_setattr()
                                ->inode_dio_wait()
                                ->truncate_setsize()
                                ->ext4_truncate()
                                 ->down_write(&EXT4_I(inode)->i_data_sem);
    ->__blockdev_direct_IO
     ->ext4_get_block
     ->submit_io()
    ->up_read(&EXT4_I(inode)->i_data_sem);
                                 # truncate data blocks, allocate them to
                                 # other inode - bad stuff happens because
                                 # dio is still in flight.

In order to serialize with truncate dio worker should grab extra i_dio_count
reference before drop i_mutex.

Changes agains V1:
- wake up dio waiters before i_mutex.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d3f86e7..00c3222 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3011,6 +3011,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		overwrite = *((int *)iocb->private);
 
 		if (overwrite) {
+			atomic_inc(&inode->i_dio_count);
 			down_read(&EXT4_I(inode)->i_data_sem);
 			mutex_unlock(&inode->i_mutex);
 		}
@@ -3108,6 +3109,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	retake_lock:
 		/* take i_mutex locking again if we do a ovewrite dio */
 		if (overwrite) {
+			inode_dio_done(inode);
 			up_read(&EXT4_I(inode)->i_data_sem);
 			mutex_lock(&inode->i_mutex);
 		}
-- 
1.7.7.6

