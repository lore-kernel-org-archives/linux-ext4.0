From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/39] libext2fs: directory iteration mustn't walk off the
 buffer end
Date: Sat, 25 Oct 2014 13:56:42 -0700
Message-ID: <20141025205642.532.35826.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43674 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaJYU5T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:19 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're iterating a directory, the loop control code reads the
length of the next directory record, failing to account for the fact
that there must be at least 8 bytes (the minimum size of a directory
entry) left in the buffer to read the next directory record.  Fix the
loop conditional so that we don't read off the end of the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/dir_iterate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 67152cc..9063c17 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -222,7 +222,7 @@ int ext2fs_process_dir_block(ext2_filsys fs,
 					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
-	while (offset < buflen) {
+	while (offset < buflen - 8) {
 		dirent = (struct ext2_dir_entry *) (ctx->buf + offset);
 		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
 			return BLOCK_ABORT;

