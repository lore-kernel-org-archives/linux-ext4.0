From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: Remove unneeded test of ret variable
Date: Mon, 31 Mar 2014 11:11:34 +0200
Message-ID: <1396257094-10386-2-git-send-email-lczerner@redhat.com>
References: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Cc: dan.carpenter@oracle.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbaCaJLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 05:11:41 -0400
In-Reply-To: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_fallocate() and ext4_zero_range() we're testing ret
variable along with new_size. However in ext4_fallocate() we just tested
ret before and in ext4_zero_range() if will always be zero when we get
there so there is no need to test it in both cases.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 491208c..8c09e1d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4816,12 +4816,12 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 
-	if (!ret && new_size) {
+	if (new_size) {
 		if (new_size > i_size_read(inode))
 			i_size_write(inode, new_size);
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
-	} else if (!ret && !new_size) {
+	} else {
 		/*
 		* Mark that we allocate beyond EOF so the subsequent truncate
 		* can proceed even if the new size is the same as i_size.
@@ -4923,14 +4923,14 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	tv = inode->i_ctime = ext4_current_time(inode);
 
-	if (!ret && new_size) {
+	if (new_size) {
 		if (new_size > i_size_read(inode)) {
 			i_size_write(inode, new_size);
 			inode->i_mtime = tv;
 		}
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
-	} else if (!ret && !new_size) {
+	} else {
 		/*
 		* Mark that we allocate beyond EOF so the subsequent truncate
 		* can proceed even if the new size is the same as i_size.
-- 
1.8.3.1

