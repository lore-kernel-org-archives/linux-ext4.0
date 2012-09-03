From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] resize2fs: allow meta_bg/64-bit file systems to be online resized
Date: Mon,  3 Sep 2012 12:45:57 -0400
Message-ID: <1346690758-21072-1-git-send-email-tytso@mit.edu>
References: <20120903164525.GD5066@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48626 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab2ICQqA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 12:46:00 -0400
In-Reply-To: <20120903164525.GD5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resize2fs can't handle resizing flex_bg file systems that do not have
the resize inode, but when the kernel adds support for resizing using
the meta_bg layout, we should allow it be able to resize the file
system.

So move the flex_bg/resize_inode check to the just before we start
doing the off-line resize, instead of doing it earlier where it would
prohibit these file systems for both on-line and off-line resizes.
Also disable the > 32-bit block number check for meta_bg file systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c   | 59 ++++++++++++++++++++++++++++++++-------------------------
 resize/online.c | 14 +++++++++-----
 2 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index e6604f2..b2e66f6 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -316,25 +316,6 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 
-	/*
-	 * XXXX   The combination of flex_bg and !resize_inode causes
-	 * major problems for resize2fs, since when the group descriptors
-	 * grow in size this can potentially require multiple inode
-	 * tables to be moved aside to make room, and resize2fs chokes
-	 * rather badly in this scenario.  It's a rare combination,
-	 * except when a filesystem is expanded more than a certain
-	 * size, so for now, we'll just prohibit that combination.
-	 * This is something we should fix eventually, though.
-	 */
-	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
-	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
-		com_err(program_name, 0, _("%s: The combination of flex_bg "
-					   "and\n\t!resize_inode features "
-					   "is not supported by resize2fs.\n"),
-			device_name);
-		exit(1);
-	}
-
 	min_size = calculate_minimum_resize_size(fs);
 
 	if (print_min_size) {
@@ -385,13 +366,17 @@ int main (int argc, char ** argv)
 			exit(1);
 		}
 	} else {
-		/* Take down devices exactly 16T to 2^32-1 blocks */
-		if (max_size == (1ULL << 32))
-			max_size--;
-		else if (max_size > (1ULL << 32)) {
-			com_err(program_name, 0, _("New size too large to be "
-				"expressed in 32 bits\n"));
-			exit(1);
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_INCOMPAT_64BIT)) {
+			/* Take down devices exactly 16T to 2^32-1 blocks */
+			if (max_size == (1ULL << 32))
+				max_size--;
+			else if (max_size > (1ULL << 32)) {
+				com_err(program_name, 0,
+					_("New size too large to be "
+					  "expressed in 32 bits\n"));
+				exit(1);
+			}
 		}
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
@@ -453,6 +438,28 @@ int main (int argc, char ** argv)
 				device_name);
 			exit(1);
 		}
+		/*
+		 * XXXX The combination of flex_bg and !resize_inode
+		 * causes major problems for resize2fs, since when the
+		 * group descriptors grow in size this can potentially
+		 * require multiple inode tables to be moved aside to
+		 * make room, and resize2fs chokes rather badly in
+		 * this scenario.  It's a rare combination, except
+		 * when a filesystem is expanded more than a certain
+		 * size, so for now, we'll just prohibit that
+		 * combination.  This is something we should fix
+		 * eventually, though.
+		 */
+		if ((fs->super->s_feature_incompat &
+		     EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+		    !(fs->super->s_feature_compat &
+		      EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
+			com_err(program_name, 0, _("%s: The combination of "
+				"flex_bg and\n\t!resize_inode features "
+				"is not supported by resize2fs.\n"),
+				device_name);
+			exit(1);
+		}
 		printf(_("Resizing the filesystem on "
 			 "%s to %llu (%dk) blocks.\n"),
 		       device_name, new_size, fs->blocksize / 1024);
diff --git a/resize/online.c b/resize/online.c
index 966ea1e..194a993 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -56,9 +56,11 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		EXT2_DESC_PER_BLOCK(fs->super));
 	printf("old_desc_blocks = %lu, new_desc_blocks = %lu\n",
 	       fs->desc_blocks, new_desc_blocks);
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
-	    new_desc_blocks != fs->desc_blocks) {
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT2_FEATURE_INCOMPAT_META_BG) &&
+	    (new_desc_blocks != fs->desc_blocks)) {
 		com_err(program_name, 0,
 			_("Filesystem does not support online resizing"));
 		exit(1);
@@ -101,8 +103,10 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		return 0;
 	}
 
-	if ((ext2fs_blocks_count(sb) > MAX_32_NUM) ||
-	    (*new_size > MAX_32_NUM)) {
+	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT2_FEATURE_INCOMPAT_META_BG) &&
+	    ((ext2fs_blocks_count(sb) > MAX_32_NUM) ||
+	     (*new_size > MAX_32_NUM))) {
 		com_err(program_name, 0,
 			_("Kernel does not support resizing a file system "
 			  "this large"));
-- 
1.7.12.rc0.22.gcdd159b

