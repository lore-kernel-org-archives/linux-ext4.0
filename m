From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH 2/2] blkmap64_ba: Only define ba_print_stats() when needed.
Date: Wed, 27 Jun 2012 20:59:19 +1000
Message-ID: <1340794759-15286-2-git-send-email-tony@bakeyournoodle.com>
References: <1340794759-15286-1-git-send-email-tony@bakeyournoodle.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:40760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab2F0K7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 06:59:47 -0400
In-Reply-To: <1340794759-15286-1-git-send-email-tony@bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ENABLE_BMAP_STATS isn't defined make a_print_stats() do nothing.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
I copied the coding style from blkmap64_rb.c 

 lib/ext2fs/blkmap64_ba.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 8eddde9..73180b0 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -310,12 +310,16 @@ static void ba_clear_bmap(ext2fs_generic_bitmap bitmap)
 	       (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1));
 }
 
+#ifdef ENABLE_BMAP_STATS
 static void ba_print_stats(ext2fs_generic_bitmap bitmap)
 {
 	fprintf(stderr, "%16llu Bytes used by bitarray\n",
 		((bitmap->real_end - bitmap->start) >> 3) + 1 +
 		sizeof(struct ext2fs_ba_private_struct));
 }
+#else
+static void ba_print_stats(ext2fs_generic_bitmap bitmap) {}
+#endif
 
 /* Find the first zero bit between start and end, inclusive. */
 static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
-- 
1.7.7.6

