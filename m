From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Using libext2fs in libe2p?
Date: Tue, 3 Feb 2009 14:56:45 -0500
Message-ID: <20090203195645.GG20654@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Nick Dokos <nicholas.dokos@hp.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZBCT4t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 14:56:49 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos noticed that libe2p now depends on libext2fs in the 64-bit
tree, since we use ext2fs_blocks_count() and friends (see diff below).

Possible solutions:

Link libext2fs with libe2p
Open code 64-bit block counts
Require users of libe2p to link with libext2fs
Move ext2fs_blocks_count() and friends into a header file and inline them

I am agnostic.

-VAL

diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 6d2ce70..1923793 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -20,6 +20,7 @@
 #include <time.h>
 
 #include "e2p.h"
+#include "ext2fs/ext2fs.h"
 
 static void print_user (unsigned short uid, FILE *f)
 {
@@ -219,9 +220,9 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
        fprintf(f, "Filesystem OS type:       %s\n", str);
        free(str);
        fprintf(f, "Inode count:              %u\n", sb->s_inodes_count);
-       fprintf(f, "Block count:              %u\n", sb->s_blocks_count);
-       fprintf(f, "Reserved block count:     %u\n", sb->s_r_blocks_count);
-       fprintf(f, "Free blocks:              %u\n", sb->s_free_blocks_count);
+       fprintf(f, "Block count:              %llu\n", ext2fs_blocks_count(sb));
+       fprintf(f, "Reserved block count:     %llu\n", ext2fs_r_blocks_count(sb));
+       fprintf(f, "Free blocks:              %llu\n", ext2fs_free_blocks_count(sb));
        fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
        fprintf(f, "First block:              %u\n", sb->s_first_data_block);
        fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));

