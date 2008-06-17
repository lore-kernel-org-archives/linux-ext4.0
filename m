From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] resize2fs: Prohibit the combination of flex_bg and !resize_inode
Date: Tue, 17 Jun 2008 02:06:32 -0400
Message-ID: <1213682792-4878-4-git-send-email-tytso@mit.edu>
References: <1213682792-4878-1-git-send-email-tytso@mit.edu>
 <1213682792-4878-2-git-send-email-tytso@mit.edu>
 <1213682792-4878-3-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33399 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbYFQGGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 02:06:34 -0400
In-Reply-To: <1213682792-4878-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a potentially a difficult case for resize2fs to handle, so
prohibit it for now.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index d7097ad..1cb0b20 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -316,9 +316,28 @@ int main (int argc, char ** argv)
 			"(%s)", device_name);
 		exit(1);
 	}
+
+	/*
+	 * XXXX   The combination of flex_bg and !resize_inode causes
+	 * major problems for resize2fs, since when the group descriptors
+	 * grow in size this can potentially require multiple inode
+	 * tables to be moved aside to make room, and resize2fs chokes
+	 * rather badly in this scenario.  It's a rare combination,
+	 * except when a filesystem is expanded more than a certain
+	 * size, so for now, we'll just prohibit that combination.
+	 * This is something we should fix eventually, though.
+	 */
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
+		com_err(program_name, 0, _("%s: The combination of flex_bg "
+					   "and\n\t!resize_inode features "
+					   "is not supported by resize2fs.\n"),
+			device_name);
+		exit(1);
+	}
 	
 	if (print_min_size) {
-		printf("Estimated minimum size of the filesystem: %u\n",
+		printf(_("Estimated minimum size of the filesystem: %u\n"),
 		       calculate_minimum_resize_size(fs));
 		exit(0);
 	}
-- 
1.5.6.rc3.1.g36b7.dirty

