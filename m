From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: git ignore generated files
Date: Tue, 10 Oct 2017 16:40:41 -0600
Message-ID: <1507675241-70077-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:34684 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbdJJWsv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 18:48:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Git ignore automatically files.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 .gitignore | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.gitignore b/.gitignore
index baf9b1a..8a63e9f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,6 +27,7 @@ debugfs/debug_cmds.c
 debugfs/debugfs
 debugfs/debugfs.8
 debugfs/extent_cmds.c
+debugfs/tst_set_fields
 doc/libext2fs.aux
 doc/libext2fs.cp
 doc/libext2fs.dvi
@@ -108,11 +109,17 @@ lib/ext2fs/tst_bitops
 lib/ext2fs/tst_cmds.c
 lib/ext2fs/tst_csum
 lib/ext2fs/tst_crc32c
+lib/ext2fs/tst_digest_encode
+lib/ext2fs/tst_getsectsize
+lib/ext2fs/tst_getsize
 lib/ext2fs/tst_icount
 lib/ext2fs/tst_inline
+lib/ext2fs/tst_inline_data
 lib/ext2fs/tst_inode_size
 lib/ext2fs/tst_iscan
 lib/ext2fs/tst_libext2fs
+lib/ext2fs/tst_sha256
+lib/ext2fs/tst_sha512
 lib/ext2fs/tst_super_size
 lib/ext2fs/tst_types
 lib/quota/subdirs
@@ -126,6 +133,9 @@ lib/ss/test.diff
 lib/ss/test_cmd.c
 lib/ss/test_out
 lib/ss/test_ss
+lib/support/prof_err.c
+lib/support/prof_err.h
+lib/support/subdirs
 lib/uuid/subdirs
 lib/uuid/tst_uuid
 lib/uuid/uuid.3
@@ -170,6 +180,8 @@ misc/findfs.8
 misc/findsuper
 misc/fsck
 misc/fsck.8
+misc/fuse2fs
+misc/fuse2fs.1
 misc/logsave
 misc/logsave.8
 misc/lsattr
-- 
1.8.0
