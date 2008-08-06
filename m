From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH][e2fsprogs] fix 0 file creation time
Date: Wed, 06 Aug 2008 17:09:19 +0800
Message-ID: <48996A3F.3050607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50009 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758820AbYHFJKn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 05:10:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

$ lsattr -c
1970-01-01 08:00:00.0 +0800 --------------- ./lost+found

It turns out that the crtime of files created by e2fsprogs is 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/ext2fs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index ba15dda..66ddae4 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -767,6 +767,7 @@ errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
 	large_inode = (struct ext2_inode_large *) buf;
 	large_inode->i_extra_isize = sizeof(struct ext2_inode_large) - 
 		EXT2_GOOD_OLD_INODE_SIZE;
+	large_inode->i_crtime = large_inode->i_atime;
 
 	retval = ext2fs_write_inode_full(fs, ino, buf, size);
 	free(buf);
-- 
1.5.4.rc3
