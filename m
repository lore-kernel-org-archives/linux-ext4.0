From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH 5/5] libext2fs: Optimize ext2fs_convert_subcluster_bitmap()
Date: Tue, 19 Mar 2013 20:06:04 +0400
Message-ID: <1363709164-3210-6-git-send-email-qrxd43@motorola.com>
References: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:46479 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3CSQGb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 12:06:31 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.22.94.167])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id r2JFt3xs021515
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 11:55:03 -0400 (EDT)
Received: from mail-ee0-f48.google.com (mail-ee0-f48.google.com [74.125.83.48])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id r2JFt2Mc021503
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 11:55:03 -0400 (EDT)
Received: by mail-ee0-f48.google.com with SMTP id t10so339307eei.21
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:06:27 -0700 (PDT)
In-Reply-To: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Scan original bitmap with successive ffs/ffz and
insert complete extents into target bitmap.

Signed-off-by Andrey Sidorov <qrxd43@motorola.com>
---
 lib/ext2fs/gen_bitmap64.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 80502b5..3639f60 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -758,8 +758,7 @@ errcode_t ext2fs_convert_subcluster_bitmap(ext2_filsys fs,
 {
 	ext2fs_block_bitmap	cmap, bmap;
 	errcode_t		retval;
-	blk64_t			i, b_end, c_end;
-	int			n, ratio;
+	blk64_t			b_end, c_end, f_zero, f_set;
 
 	bmap = *bitmap;
 
@@ -771,23 +770,25 @@ errcode_t ext2fs_convert_subcluster_bitmap(ext2_filsys fs,
 	if (retval)
 		return retval;
 
-	i = bmap->start;
+	f_zero = bmap->start;
 	b_end = bmap->end;
 	bmap->end = bmap->real_end;
 	c_end = cmap->end;
 	cmap->end = cmap->real_end;
-	n = 0;
-	ratio = 1 << fs->cluster_ratio_bits;
-	while (i < bmap->real_end) {
-		if (ext2fs_test_block_bitmap2(bmap, i)) {
-			ext2fs_mark_block_bitmap2(cmap, i);
-			i += ratio - n;
-			n = 0;
-			continue;
+
+	while (f_zero < bmap->real_end) {
+		retval = ext2fs_find_first_set_block_bitmap2(bmap, f_zero,
+							     bmap->real_end,
+							     &f_set);
+		if (retval)
+			break;
+		retval = ext2fs_find_first_zero_block_bitmap2(bmap, f_set,
+							      bmap->real_end,
+							      &f_zero);
+		if (retval) {
+			f_zero = bmap->real_end + 1;
 		}
-		i++; n++;
-		if (n >= ratio)
-			n = 0;
+		ext2fs_mark_block_bitmap_range2(cmap, f_set, f_zero - f_set);
 	}
 	bmap->end = b_end;
 	cmap->end = c_end;
-- 
1.7.10.4

