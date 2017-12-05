From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e2freefrag: print 64bit free blocks count
Date: Tue, 5 Dec 2017 00:15:38 +0000
Message-ID: <C26C67884C4B7A48980D574635594864033FC0E1@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tyo162.gate.nec.co.jp ([114.179.232.162]:44319 "EHLO
        tyo162.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLEAcu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2017 19:32:50 -0500
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2freefrag prints incorrect free blocks count when the number of free blocks
is larger than 2^32. 
To fix this problem, e2freefrag uses ext2fs_free_blocks_count(),
not fs->super->s_free_blocks_count.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e2freefrag.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index b315263..c5aeab9 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -255,9 +255,10 @@ static errcode_t dump_chunk_info(ext2_filsys fs, struct chunk_info *info,
 	unsigned long start = 0, end;
 	int i, retval = 0;
 
-	fprintf(f, "Total blocks: %llu\nFree blocks: %u (%0.1f%%)\n",
-		ext2fs_blocks_count(fs->super), fs->super->s_free_blocks_count,
-		(double)fs->super->s_free_blocks_count * 100 /
+	fprintf(f, "Total blocks: %llu\nFree blocks: %llu (%0.1f%%)\n",
+		ext2fs_blocks_count(fs->super),
+		ext2fs_free_blocks_count(fs->super),
+		(double)ext2fs_free_blocks_count(fs->super) * 100 /
 		ext2fs_blocks_count(fs->super));
 
 	if (info->chunkbytes) {
@@ -301,7 +302,7 @@ static errcode_t dump_chunk_info(ext2_filsys fs, struct chunk_info *info,
 				info->histogram.fc_chunks[i],
 				info->histogram.fc_blocks[i],
 				(double)info->histogram.fc_blocks[i] * 100 /
-				fs->super->s_free_blocks_count);
+				ext2fs_free_blocks_count(fs->super));
 		}
 		start = end;
 		if (start == 1<<10) {
