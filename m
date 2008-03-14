From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE
	boxes
Date: Fri, 14 Mar 2008 13:14:35 -0400
Message-ID: <20080314171435.GA13733@mit.edu>
References: <47C882CD.3090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60109 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752284AbYCNROl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2008 13:14:41 -0400
Content-Disposition: inline
In-Reply-To: <47C882CD.3090204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 29, 2008 at 04:10:21PM -0600, Eric Sandeen wrote:
> +
> +	if (hostorder)
> +		attr_magic = *eaf;
>  	*eat = ext2fs_swab32(*eaf);
> +	if (!hostorder)
> +		attr_magic = *eat;
> +
> +	if (attr_magic != EXT2_EXT_ATTR_MAGIC)
> +		return; /* it seems no magic here */

The problem with this is that if the magic isn't there, we still end
up writing 4 bytes into the destination.  So I think this is a better
patch....

						- Ted

>From 91a2fbe36ff5578c46f637687a56d7a0d169a807 Mon Sep 17 00:00:00 2001
From: Eric Sandeen <sandeen@redhat.com>
Date: Fri, 29 Feb 2008 16:10:21 -0600
Subject: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE boxes

After the fix for resize2fs's inode mover losing in-inode
extended attributes, the regression test I wrote caught
that the attrs were still getting lost on powerpc.

Looks like the problem is that ext2fs_swap_inode_full()
isn't paying attention to whether or not the EA magic is
in hostorder, so it's not recognized (and not swapped)
on BE machines.  Patch below seems to fix it.

Yay for regression tests.  ;)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/swapfs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 6576c59..e07e87c 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -133,7 +133,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 			    struct ext2_inode_large *f, int hostorder,
 			    int bufsize)
 {
-	unsigned i, has_data_blocks, extra_isize;
+	unsigned i, has_data_blocks, extra_isize, attr_magic;
 	int islnk = 0;
 	__u32 *eaf, *eat;
 
@@ -232,7 +232,11 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	eaf = (__u32 *) (((char *) f) + sizeof(struct ext2_inode) +
 					extra_isize);
 
-	if (ext2fs_swab32(*eaf) != EXT2_EXT_ATTR_MAGIC)
+	attr_magic = *eaf;
+	if (!hostorder)
+		attr_magic = ext2fs_swab32(attr_magic);
+
+	if (attr_magic != EXT2_EXT_ATTR_MAGIC)
 		return; /* it seems no magic here */
 
 	eat = (__u32 *) (((char *) t) + sizeof(struct ext2_inode) +
-- 
1.5.4.1.144.gdfee-dirty

