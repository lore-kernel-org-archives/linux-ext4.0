From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 7/9] ext4: serialize truncate with owerwrite DIO workers V2
Date: Thu, 13 Sep 2012 19:01:12 +0400
Message-ID: <1347548474-31897-8-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37387 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842Ab2IMPBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 11:01:31 -0400
Received: by lagy9 with SMTP id y9so1991658lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:29 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
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
index a295b3a..ce4d44a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3014,6 +3014,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		overwrite = *((int *)iocb->private);
 
 		if (overwrite) {
+			atomic_inc(&inode->i_dio_count);
 			down_read(&EXT4_I(inode)->i_data_sem);
 			mutex_unlock(&inode->i_mutex);
 		}
@@ -3111,6 +3112,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	retake_lock:
 		/* take i_mutex locking again if we do a ovewrite dio */
 		if (overwrite) {
+			inode_dio_done(inode);
 			up_read(&EXT4_I(inode)->i_data_sem);
 			mutex_lock(&inode->i_mutex);
 		}
-- 
1.7.7.6

