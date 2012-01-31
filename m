From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] libext2fs: quiet spurious group checksum errors
Date: Tue, 31 Jan 2012 15:15:30 -0700
Message-ID: <1328048130-40981-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4, Andreas Dilger" <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49057 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2AaWQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jan 2012 17:16:29 -0500
Received: by bkcjm19 with SMTP id jm19so437985bkc.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jan 2012 14:16:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have to read the backup group descriptor checksums, the UNINIT
flags are cleared to ensure that all of the inodes in the filesystem
are scanned.  However, the code that reset the UNINIT flags did not
reset the group checksum, and this produced many spurious error
messages in e2fsck.

Group descriptor 0 checksum is invalid.  FIXED.
Group descriptor 1 checksum is invalid.  FIXED.
:
:

Recompute checksums after modifying group descriptors to avoid these
error messages.  Remove expected error messages in f_illitable_flexbg.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
lib/ext2fs/openfs.c               |    3 +++
tests/f_illitable_flexbg/expect.1 |    8 ++------
2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 40a52c5..b1b68ad 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -378,6 +378,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
			ext2fs_bg_itable_unused_set(fs, group, 0);
+			/* The checksum will be reset later, but fix it here
+			 * anyway to avoid printing a lot of spurious errors. */
+			ext2fs_group_desc_csum_set(fs, group);
		}
		ext2fs_mark_super_dirty(fs);
	}
diff --git a/tests/f_illitable_flexbg/expect.1 b/tests/f_illitable_flexbg/expect.1
index 2d8bd0c..af30bd4 100644
--- a/tests/f_illitable_flexbg/expect.1
+++ b/tests/f_illitable_flexbg/expect.1
@@ -1,17 +1,13 @@
../e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
-One or more block group descriptor checksums are invalid.  Fix? yes
