From: Jan Kara <jack@suse.com>
Subject: [PATCH 10/21] ext2fs: Fixup inline directory test
Date: Wed, 26 Aug 2015 18:22:25 +0200
Message-ID: <1440606156-5754-11-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbbHZQWy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:54 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inline directory test had hardwired number of reserved inodes. Fix the
test to read the first available inode number from the superblock.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/inline_data.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 6260c5f35c1a..98c732bb2e3c 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -706,22 +706,23 @@ static errcode_t dir_test(ext2_filsys fs)
 	errcode_t retval;
 	char dirname[PATH_MAX];
 	int i;
+	ext2_ino_t ino = EXT2_FIRST_INO(fs->super);
 
-	retval = ext2fs_mkdir(fs, 11, 11, stub_name);
+	retval = ext2fs_mkdir(fs, ino, ino, stub_name);
 	if (retval) {
 		com_err("dir_test", retval, "while creating %s dir", stub_name);
 		return retval;
 	}
 
-	retval = ext2fs_mkdir(fs, 11, 0, parent_name);
+	retval = ext2fs_mkdir(fs, ino, 0, parent_name);
 	if (retval) {
 		com_err("dir_test", retval,
 			"while creating %s dir", parent_name);
 		return retval;
 	}
 
-	retval = ext2fs_lookup(fs, 11, parent_name, strlen(parent_name),
-			       0, &parent);
+	retval = ext2fs_lookup(fs, ino, parent_name,
+			       strlen(parent_name), 0, &parent);
 	if (retval) {
 		com_err("dir_test", retval,
 			"while looking up %s dir", parent_name);
@@ -742,7 +743,7 @@ static errcode_t dir_test(ext2_filsys fs)
 		return 1;
 	}
 
-	for (i = 0, dir = 13; i < 4; i++, dir++) {
+	for (i = 0, dir = ino + 2; i < 4; i++, dir++) {
 		tmp = 0;
 		snprintf(dirname, sizeof(dirname), "%d", i);
 		retval = ext2fs_mkdir(fs, parent, 0, dirname);
-- 
2.1.4

