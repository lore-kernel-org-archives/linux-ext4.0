From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs : Fix memory leak in ext2fs_initialize.
Date: Fri, 11 Jul 2008 14:46:25 -0400
Message-ID: <20080711184625.GC26656@mit.edu>
References: <ea11fea30807110332n459593eay3ce43cca67d5c676@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34581 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753505AbYGKSq1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 14:46:27 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30807110332n459593eay3ce43cca67d5c676@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's how the patch was applied; please note the style fixes I made
in the code and in the patch comments.

       	       	     	 	  	      - Ted

>From adc4e77d89d9a423c3fbe6457676b020c9ad3a64 Mon Sep 17 00:00:00 2001
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Fri, 11 Jul 2008 14:42:57 -0400
Subject: [PATCH] libext2fs: fix potential memory leak in ext2fs_initialize()

If we fail doing ext2fs_allocate_block_bitmap() or
ext2fs_allocate_inode_bitmap() we directly goto cleanup and don't free
the memory allocated to buf.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/initialize.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 011656f..e9bfe49 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -105,7 +105,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	int		rsv_gdt;
 	int		csum_flag;
 	int		io_flags;
-	char		*buf;
+	char		*buf = 0;
 	char		c;
 
 	if (!param || !param->s_blocks_count)
@@ -429,6 +429,8 @@ ipg_retry:
 	*ret_fs = fs;
 	return 0;
 cleanup:
+	if (buf)
+		free(buf);
 	ext2fs_free(fs);
 	return retval;
 }
-- 
1.5.6.1.205.ge2c7.dirty

