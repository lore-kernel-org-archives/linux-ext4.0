From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] ext4: fix some s64 printing warnings
Date: Wed, 12 Nov 2008 11:10:49 +1100
Message-ID: <20081112111049.68c604ff.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	ppc-dev <linuxppc-dev@ozlabs.org>
To: "Theodore Ts'o" <tytso@mit.edu>, <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:43048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYKLAK7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 19:10:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A powerpc ppc64_defconfig build of Linus' current tree produces these
warnings:

fs/ext4/balloc.c: In function 'ext4_has_free_blocks':
fs/ext4/balloc.c:617: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c: In function 'ext4_print_free_blocks':
fs/ext4/inode.c:1833: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1835: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'

Fix them up with the usual casts.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d2003cd..9ce2fcd 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -614,7 +614,7 @@ int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
-					dirty_blocks);
+					(long long)dirty_blocks);
 		}
 	}
 	/* Check whether we have space after
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index be21a5a..2a3804e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1830,9 +1830,9 @@ static void ext4_print_free_blocks(struct inode *inode)
 			ext4_count_free_blocks(inode->i_sb));
 	printk(KERN_EMERG "Free/Dirty block details\n");
 	printk(KERN_EMERG "free_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_freeblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_freeblocks_counter));
 	printk(KERN_EMERG "dirty_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_dirtyblocks_counter));
 	printk(KERN_EMERG "Block reservation details\n");
 	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
 			EXT4_I(inode)->i_reserved_data_blocks);
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
