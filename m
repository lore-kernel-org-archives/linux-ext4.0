From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/21] libext2fs/e2fsck: don't run off the end of the EA
 block
Date: Mon, 04 Aug 2014 18:05:23 -0700
Message-ID: <20140805010523.2611.3554.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40152 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBF2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:28 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're (a) reading EAs into a buffer; (b) byte-swapping EA
entries; or (c) checking EA data, be careful not to run off the end of
the memory buffer, because this causes invalid memory accesses and
e2fsck crashes.  This can happen if we encounter a specially crafted
FS image.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c        |    3 ++-
 lib/ext2fs/ext_attr.c |    3 ++-
 lib/ext2fs/swapfs.c   |    4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5c72f48..6c79eed 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -302,7 +302,8 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 	/* take finish entry 0UL into account */
 	remain = storage_size - sizeof(__u32);
 
-	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
+	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
 		/* header eats this space */
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 96530f8..5732ca6 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -633,7 +633,8 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 
 	entry = entries;
 	remain = storage_size;
-	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
+	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
 		/* header eats this space */
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index f08859b..e2aa41d 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -196,7 +196,9 @@ void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, int has_header)
 		to_entry   = (struct ext2_ext_attr_entry *)to_header;
 	}
 
-	while ((char *)from_entry < from_end && *(__u32 *)from_entry) {
+	while ((char *)from_entry < from_end &&
+	       (char *)EXT2_EXT_ATTR_NEXT(from_entry) <= from_end &&
+	       *(__u32 *)from_entry) {
 		ext2fs_swap_ext_attr_entry(to_entry, from_entry);
 		from_entry = EXT2_EXT_ATTR_NEXT(from_entry);
 		to_entry   = EXT2_EXT_ATTR_NEXT(to_entry);

