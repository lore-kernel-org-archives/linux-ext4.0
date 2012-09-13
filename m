From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] resize2fs: allow meta_bg/64-bit file systems to be online resized
Date: Thu, 13 Sep 2012 18:49:18 -0400
Message-ID: <1347576560-5820-4-git-send-email-tytso@mit.edu>
References: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50600 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab2IMX0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 19:26:00 -0400
In-Reply-To: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resize2fs can't handle resizing flex_bg file systems that do not have
the resize inode, but when the kernel adds support for resizing using
the meta_bg layout, we should allow it be able to resize the file
system.

So move the flex_bg/resize_inode check to the just before we start
doing the off-line resize, instead of doing it earlier where it would
prohibit these file systems for both on-line and off-line resizes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index f8bd983..67418ea 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -321,25 +321,6 @@ int main (int argc, char ** argv)
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
@@ -463,6 +444,28 @@ int main (int argc, char ** argv)
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
-- 
1.7.12.rc0.22.gcdd159b

