From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] use ext4_update_i_disksize instead of opencoded ones
Date: Fri, 22 Aug 2014 15:32:23 +0400
Message-ID: <1408707147-22482-2-git-send-email-dmonakhov@openvz.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
Cc: lczerner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:28854 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaHVLcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 07:32:54 -0400
In-Reply-To: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 367a60c..b3b755b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2670,10 +2670,7 @@ static int ext4_da_write_end(struct file *file,
 	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
 		if (ext4_has_inline_data(inode) ||
 		    ext4_da_should_update_i_disksize(page, end)) {
-			down_write(&EXT4_I(inode)->i_data_sem);
-			if (new_i_size > EXT4_I(inode)->i_disksize)
-				EXT4_I(inode)->i_disksize = new_i_size;
-			up_write(&EXT4_I(inode)->i_data_sem);
+			ext4_update_i_disksize(inode, new_i_size);
 			/* We need to mark inode dirty even if
 			 * new_i_size is less that inode->i_size
 			 * bu greater than i_disksize.(hint delalloc)
-- 
1.7.1

