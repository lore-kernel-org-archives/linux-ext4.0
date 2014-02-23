From: Vitaliy Filippov <vitalif@yourcmc.ru>
Subject: [PATCH] misc: Use unsigned long long for file block count in filefrag
Date: Sun, 23 Feb 2014 13:08:47 +0400
Message-ID: <20140223091251.3545C47E837@yourcmc.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:56148 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaBWJMx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 04:12:53 -0500
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id 5FAED47E835
	for <linux-ext4@vger.kernel.org>; Sun, 23 Feb 2014 13:12:51 +0400 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes incorrect reporting of file block count on 32-bit platforms.

---
 misc/filefrag.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index a050a22..756fad8 100644
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
@@ -409,7 +409,7 @@ static void frag_report(const char *filename)
 	if (width > logical_width)
 		logical_width = width;
 	if (verbose)
-		printf("File size of %s is %llu (%lu block%s of %d bytes)\n",
+		printf("File size of %s is %llu (%llu block%s of %d bytes)\n",
 		       filename, (unsigned long long)st.st_size,
 		       numblocks * fsinfo.f_bsize >> blk_shift,
 		       numblocks == 1 ? "" : "s", 1 << blk_shift);
-- 
1.9.0.rc3

