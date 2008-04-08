From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/5] print a bit more info for the tst_extents info command
Date: Mon,  7 Apr 2008 22:00:57 -0500
Message-ID: <1207623660-1088-3-git-send-email-sandeen@redhat.com>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbYDKSQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:16:23 -0400
In-Reply-To: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index e7733c5..76f6f65 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1087,6 +1087,7 @@ void do_print_all(int argc, char **argv)
 
 void do_info(int argc, char **argv)
 {
+	struct ext2fs_extent	extent;
 	struct ext2_extent_info	info;
 	errcode_t		retval;
 
@@ -1104,6 +1105,15 @@ void do_info(int argc, char **argv)
 		return;
 	}
 
+	retval = ext2fs_extent_get(current_handle,
+				   EXT2_EXTENT_CURRENT, &extent);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+
+	dbg_print_extent(0, &extent);
+
 	printf("Current handle location: %d/%d (max: %d, bytes %d), level %d/%d\n",
 	       info.curr_entry, info.num_entries, info.max_entries,
 	       info.bytes_avail, info.curr_level, info.max_depth);
-- 
1.5.4.1

