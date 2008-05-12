From: Tiger Yang <tiger.yang@oracle.com>
Subject: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Mon, 12 May 2008 11:24:40 +0800
Message-ID: <4827B878.50903@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090404060705000207050604"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:20896 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYELD24 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 May 2008 23:28:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090404060705000207050604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I met a bug when I try to replace a xattr entry in ibody with a big size 
value. But in ibody there has no space for the new value. So it should 
set new xattr entry in block and remove the old xattr entry in ibody.

Best regards,
tiger

--------------090404060705000207050604
Content-Type: text/x-patch;
 name="xattr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xattr.patch"

This fix the uninitialized bs when we try to replace a xattr entry in ibody with the new value which require more than free space.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index a6ea4d6..e1af9bd 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -1000,6 +1000,11 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 			i.value = NULL;
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
+			if (EXT3_I(inode)->i_file_acl && !bs.s.base) {
+				error = ext3_xattr_block_find(inode, &i, &bs);
+				if (error)
+					goto cleanup;
+			}
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 			if (error)
 				goto cleanup;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d796213..182a7a2 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1011,6 +1011,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 			i.value = NULL;
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
+			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
+				error = ext4_xattr_block_find(inode, &i, &bs);
+				if (error)
+					goto cleanup;
+			}
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 			if (error)
 				goto cleanup;

--------------090404060705000207050604--
