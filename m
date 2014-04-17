From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH] e2fsprogs/filefrag: print shared extent flag
Date: Thu, 17 Apr 2014 14:41:46 -0700
Message-ID: <20140417214146.GD27178@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaDQVls (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 17:41:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Filefrag doesn't catch and print the shared extent flag. Add this for
users of filefrag on file systems with shared extents (such as btrfs).

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 lib/ext2fs/fiemap.h | 2 ++
 misc/filefrag.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index 30bf555..895cd0b 100644
--- a/lib/ext2fs/fiemap.h
+++ b/lib/ext2fs/fiemap.h
@@ -64,5 +64,7 @@ struct fiemap {
 #define FIEMAP_EXTENT_MERGED		0x00001000 /* File does not natively
 						    * support extents. Result
 						    * merged for efficiency. */
+#define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with other
+						    * files. */
 
 #endif /* _LINUX_FIEMAP_H */
diff --git a/misc/filefrag.c b/misc/filefrag.c
index a050a22..929a33b 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -165,6 +165,8 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		strcat(flags, "unwritten,");
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
 		strcat(flags, "merged,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_SHARED)
+		strcat(flags, "shared,");
 
 	if (fm_extent->fe_logical + fm_extent->fe_length >= (__u64) st->st_size)
 		strcat(flags, "eof,");
-- 
1.8.4

