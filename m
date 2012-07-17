From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] ext4: locking issue on error path
Date: Tue, 17 Jul 2012 09:31:06 +0300
Message-ID: <20120717063106.GA14985@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24546 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab2GQGbb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jul 2012 02:31:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We recently changed how the locking worked here, but this error path was
missed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8c84070..2728fb7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3031,8 +3031,10 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		if (!is_sync_kiocb(iocb)) {
 			ext4_io_end_t *io_end =
 				ext4_init_io_end(inode, GFP_NOFS);
-			if (!io_end)
-				return -ENOMEM;
+			if (!io_end) {
+				ret = -ENOMEM;
+				goto retake_lock;
+			}
 			io_end->flag |= EXT4_IO_END_DIRECT;
 			iocb->private = io_end;
 			/*
@@ -3094,6 +3096,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 			ext4_clear_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		}
 
+retake_lock:
 		/* take i_mutex locking again if we do a ovewrite dio */
 		if (overwrite) {
 			up_read(&EXT4_I(inode)->i_data_sem);
