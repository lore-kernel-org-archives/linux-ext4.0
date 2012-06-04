From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Don't set i_flags in EXT4_IOC_SETFLAGS.
Date: Mon,  4 Jun 2012 11:18:18 +0800
Message-ID: <1338779898-3146-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:48593 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755614Ab2FDDSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jun 2012 23:18:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

7990696 uses the ext4_{set,clear}_inode_flags() functions to change
the i_flags automatically but fails to remove the error setting of
i_flags. So we still have the problem of trashing  state flags. So
remove it.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 8ad112a..e34deac 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -123,7 +123,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			else
 				ext4_clear_inode_flag(inode, i);
 		}
-		ei->i_flags = flags;
 
 		ext4_set_inode_flags(inode);
 		inode->i_ctime = ext4_current_time(inode);
-- 
1.7.4.1

