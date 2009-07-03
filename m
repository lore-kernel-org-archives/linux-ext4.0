From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH]ext4: Fix compile warnings with MB_DEBUG
Date: Fri, 03 Jul 2009 09:34:37 +0900
Message-ID: <4A4D521D.9040406@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35025 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZGCAew (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jul 2009 20:34:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When MB_DEBUG is enabled, we get some compile warnings
because ext4_group_t is unsigned int.
This patch fixes them.

  CC      fs/ext4/mballoc.o
fs/ext4/mballoc.c: In function ‘ext4_mb_init_group’:
fs/ext4/mballoc.c:1847: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has type ‘ext4_group_t’
fs/ext4/mballoc.c: In function ‘ext4_mb_show_ac’:
fs/ext4/mballoc.c:4131: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has type ‘ext4_group_t’
fs/ext4/mballoc.c:4138: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has type ‘ext4_group_t’

Signed-off-by Akira Fujita <a-fujita@rs.jp.nec.com>
---
 mballoc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
diff -Nrup -X linux-2.6.31-rc1-a/Documentation/dontdiff linux-2.6.31-rc1-a/fs/ext4/mballoc.c linux-2.6.31-rc1-b/fs/ext4/mballoc.c
--- linux-2.6.31-rc1-a/fs/ext4/mballoc.c        2009-06-25 08:25:37.000000000 +0900
+++ linux-2.6.31-rc1-b/fs/ext4/mballoc.c        2009-07-03 08:51:30.000000000 +0900
@@ -1844,7 +1844,7 @@ static int ext4_mb_init_group(struct sup
        struct inode *inode = sbi->s_buddy_cache;
        struct page *page = NULL, *bitmap_page = NULL;

-       mb_debug("init group %lu\n", group);
+       mb_debug("init group %u\n", group);
        blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
        this_grp = ext4_get_group_info(sb, group);
        /*
@@ -4127,14 +4127,14 @@ static void ext4_mb_show_ac(struct ext4_
                        ext4_get_group_no_and_offset(sb, pa->pa_pstart,
                                                     NULL, &start);
                        spin_unlock(&pa->pa_lock);
-                       printk(KERN_ERR "PA:%lu:%d:%u \n", i,
+                       printk(KERN_ERR "PA:%u:%d:%u \n", i,
                                                        start, pa->pa_len);
                }
                ext4_unlock_group(sb, i);

                if (grp->bb_free == 0)
                        continue;
-               printk(KERN_ERR "%lu: %d/%d \n",
+               printk(KERN_ERR "%u: %d/%d \n",
                       i, grp->bb_free, grp->bb_fragments);
        }
        printk(KERN_ERR "\n");
