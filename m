From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 12/12] resize2fs: moving xattr inodes is not supported
Date: Mon, 26 Jun 2017 06:43:48 -0700
Message-ID: <20170626134348.1240-12-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36129 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbdFZNoO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:14 -0400
Received: by mail-pg0-f50.google.com with SMTP id u62so692728pgb.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:13 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In some cases, resize2fs needs to move inodes because their inode
number is greater than the maximum allowed. Moving extended attribute
inodes would require updating all the references to them. This
is currently not supported.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 lib/ext2fs/ext2_err.et.in | 3 +++
 resize/resize2fs.c        | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index ac96964d93d0..c5a9ffcc420c 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -542,4 +542,7 @@ ec	EXT2_ET_CORRUPT_JOURNAL_SB,
 ec	EXT2_ET_INODE_CORRUPTED,
 	"Inode is corrupted"
 
+ec	EXT2_ET_CANNOT_MOVE_EA_INODE,
+	"Cannot move extended attribute inode"
+
 	end
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 8f6d95e76dc8..a54564f08ae5 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2057,6 +2057,15 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		if (ino <= start_to_move)
 			goto remap_blocks; /* Don't need to move inode. */
 
+		/*
+		 * Moving an extended attribute inode requires updating all inodes
+		 * that reference it which is a lot more involved.
+		 */
+		if (inode->i_flags & EXT4_EA_INODE_FL) {
+			retval = EXT2_ET_CANNOT_MOVE_EA_INODE;
+			goto errout;
+		}
+
 		/*
 		 * Find a new inode.  Now that extents and directory blocks
 		 * are tied to the inode number through the checksum, we must
-- 
2.13.1.611.g7e3b11ae1-goog
