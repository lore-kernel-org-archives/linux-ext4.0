From: wfg@linux.intel.com
Subject: [ext4:master 4/4] fs/ext4/resize.c:1200:9: warning: unused variable
 'ret'
Date: Tue, 10 Jul 2012 07:44:04 +0800
Message-ID: <20120709234404.GA5584@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2GIXoJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 19:44:09 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

There are new compile warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git master
head:   952fc18ef9ec707ebdc16c0786ec360295e5ff15
commit: 952fc18ef9ec707ebdc16c0786ec360295e5ff15 [4/4] ext4: fix overhead calculation used by ext4_statfs()

All warnings:

fs/ext4/resize.c: In function 'ext4_update_super':
fs/ext4/resize.c:1200:9: warning: unused variable 'ret' [-Wunused-variable]

vim +1200 fs/ext4/resize.c
  1197		struct ext4_new_group_data *group_data = flex_gd->groups;
  1198		struct ext4_sb_info *sbi = EXT4_SB(sb);
  1199		struct ext4_super_block *es = sbi->s_es;
> 1200		int i, ret;
  1201	
  1202		BUG_ON(flex_gd->count == 0 || group_data == NULL);
  1203		/*

The unused 'ret' is introduced by:

@@ -1197,7 +1197,7 @@ static void ext4_update_super(struct super_block *sb,
        struct ext4_new_group_data *group_data = flex_gd->groups;
        struct ext4_sb_info *sbi = EXT4_SB(sb);
        struct ext4_super_block *es = sbi->s_es;
-       int i;
+       int i, ret;
 
        BUG_ON(flex_gd->count == 0 || group_data == NULL);
        /*
@@ -1272,6 +1272,11 @@ static void ext4_update_super(struct super_block *sb,
                           &sbi->s_flex_groups[flex_group].free_inodes);
        }
 
+       /*
+        * Update the fs overhead information
+        */
+       ext4_calculate_overhead(sb);
+
        if (test_opt(sb, DEBUG))
                printk(KERN_DEBUG "EXT4-fs: added group %u:"
                       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
