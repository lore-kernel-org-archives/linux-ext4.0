From: Vitaliy Filippov <vitalif@yourcmc.ru>
Subject: [PATCH v2] misc: Use unsigned long long for file block count in
 filefrag
Date: Sun, 23 Feb 2014 13:08:47 +0400
Message-ID: <20140223162614.4FEF347E837@yourcmc.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:39465 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaBWQ0W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 11:26:22 -0500
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id 847C747E835
	for <linux-ext4@vger.kernel.org>; Sun, 23 Feb 2014 20:26:14 +0400 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes incorrect reporting of file block count on 32-bit platforms.

Signed-off-by: Vitaliy Filippov <vitalif@yourcmc.ru>
---
 misc/filefrag.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index a050a22..74e9306 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -337,7 +337,7 @@ static void frag_report(const char *filename)
 	ext2fs_struct_stat st;
 	int		blk_shift;
 	long		fd;
-	unsigned long	numblocks;
+	unsigned long long	numblocks;
 	int		data_blocks_per_cyl = 1;
 	int		num_extents = 1, expected = ~0;
 	int		is_ext2 = 0;
@@ -409,13 +409,17 @@ static void frag_report(const char *filename)
 	if (width > logical_width)
 		logical_width = width;
 	if (verbose)
-		printf("File size of %s is %llu (%lu block%s of %d bytes)\n",
+		printf("File size of %s is %llu (%llu block%s of %d bytes)\n",
 		       filename, (unsigned long long)st.st_size,
 		       numblocks * fsinfo.f_bsize >> blk_shift,
 		       numblocks == 1 ? "" : "s", 1 << blk_shift);
 
 	if (force_bmap ||
 	    filefrag_fiemap(fd, blk_shift, &num_extents, &st) != 0) {
+		if (numblocks > (unsigned long)-1L) {
+			fprintf(stderr, "%s: File too big to use FIBMAP\n", filename);
+			goto out_close;
+		}
 		expected = filefrag_fibmap(fd, blk_shift, &num_extents,
 					   &st, numblocks, is_ext2);
 		if (expected < 0) {
-- 
1.9.0.rc3

