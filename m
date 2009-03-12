From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix bogus BUG_ONs in in mballoc code
Date: Thu, 12 Mar 2009 13:46:57 -0500
Message-ID: <49B958A1.6060805@redhat.com>
References: <49B93E44.8070109@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44967 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZCLSrL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 14:47:11 -0400
In-Reply-To: <49B93E44.8070109@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thiemo Nagel reported that:

# dd if=/dev/zero of=image.ext4 bs=1M count=2
# mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 \
  -O large_file,dir_index,flex_bg,extent,sparse_super image.ext4
# mount -o loop image.ext4 mnt/
# dd if=/dev/zero of=mnt/file

oopsed, with a BUG_ON in ext4_mb_normalize_request because
size == EXT4_BLOCKS_PER_GROUP

It appears to me (esp. after talking to Andreas) that the BUG_ON
is bogus; a request of exactly EXT4_BLOCKS_PER_GROUP should
be allowed, though larger sizes do indicate a problem.

Fix that an another (apparently rare) codepath with a similar check.

Reported-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c
+++ linux-2.6/fs/ext4/mballoc.c
@@ -1447,7 +1447,7 @@ static void ext4_mb_measure_extent(struc
 	struct ext4_free_extent *gex = &ac->ac_g_ex;
 
 	BUG_ON(ex->fe_len <= 0);
-	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
 
@@ -3292,7 +3292,7 @@ ext4_mb_normalize_request(struct ext4_al
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 

