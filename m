From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e2fsck: Fix the wrong error detection for non-extent file
Date: Fri, 25 Nov 2011 16:26:52 +0900
Message-ID: <4ECF433C.4030604@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57237 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1KYH3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Nov 2011 02:29:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When I create a non-extent file with the maximum size in ext4,
e2fsck detects the following error:

Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_size is 4402345721856, should be 4402345721856. Fix?

As we know, e2fsck checks the size field of the inode in pass 1.
However, in case of the ext4 with the feature of ^extent and huge_file,
the maximum file size calculated in e2fsck is less than the real one.
The patch fixes this problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 e2fsck/pass1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index dbf3c94..61e3e7f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -583,7 +583,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		max_sizes = EXT2_NDIR_BLOCKS + EXT2_BPP(i);
 		max_sizes = max_sizes + EXT2_BPP(i) * EXT2_BPP(i);
 		max_sizes = max_sizes + EXT2_BPP(i) * EXT2_BPP(i) * EXT2_BPP(i);
-		max_sizes = (max_sizes * (1UL << i)) - 1;
+		max_sizes = (max_sizes * (1UL << i));
 		ext2_max_sizes[i - EXT2_MIN_BLOCK_LOG_SIZE] = max_sizes;
 	}
 #undef EXT2_BPP
