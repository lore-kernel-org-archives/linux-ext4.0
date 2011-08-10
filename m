From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: copy cluster_bits in ext2fs_copy_generic_bmap
Date: Wed, 10 Aug 2011 14:07:41 -0500
Message-ID: <4E42D6FD.2020904@redhat.com>
References: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1HJTHo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 15:07:44 -0400
In-Reply-To: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The f_lotsbad regression test was failing on some systems
with:

@@ -26,6 +61,7 @@

 Restarting e2fsck from the beginning...
 Pass 1: Checking inodes, blocks, and sizes
+Illegal block number passed to ext2fs_test_block_bitmap #0 for in-use block map
 Pass 2: Checking directory structure
 Entry 'termcap' in / (2) has deleted/unused inode 12.  Clear? yes

Running with valgrind (./test_script --valgrind f_lotsbad) we
see:

+==31409== Conditional jump or move depends on uninitialised value(s)
+==31409==    at 0x42927A: ext2fs_test_generic_bmap (gen_bitmap64.c:378)

among others.

Looking at gen_bitmap64.c:
376:        arg >>= bitmap->cluster_bits;
377:
378:        if ((arg < bitmap->start) || (arg > bitmap->end)) {

A little more debugging showed that it was actually
bitmap->cluster_bits which was uninitialized, because it never
gets copied over in ext2fs_copy_generic_bmap()

Patch below resolves the issue.

Reported-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index f75876d..80c9f7a 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -193,6 +193,7 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 	new_bmap->real_end = src->real_end;
 	new_bmap->bitmap_ops = src->bitmap_ops;
 	new_bmap->base_error_code = src->base_error_code;
+	new_bmap->cluster_bits = src->cluster_bits;
 
 	descr = src->description;
 	if (descr) {

