From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: [PATCH] ext3: set i_extra_isize of 11th inode
Date: Fri, 20 Aug 2010 11:20:11 +0900
Message-ID: <20100820112011.E6FA.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42325 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0HTCUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Aug 2010 22:20:19 -0400
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7K2KH3C019547
	for <linux-ext4@vger.kernel.org> (envelope-from m.mizuma@jp.fujitsu.com);
	Fri, 20 Aug 2010 11:20:17 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 7C63C45DE52
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 11:20:17 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id E593C45DE50
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 11:20:15 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id C51041DB8048
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 11:20:15 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D04D01DB804F
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 11:20:14 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In ext3 filesystem, if following conditions 1., 2., 3. and 4. is satisfied,
getfattr can't search the extended attribute (EA) after remount.

Condition:
    1. the inode size is over 128 byte
    2. "lost+found" whose inode number is 11 was removed 
    3. the 11th inode is used for a file.
    4. the EA locates in-inode

This happens because of following logic:
    i_extra_isize is set to over 0 by ext3_new_inode() when we create
    a file whose inode number is 11 after removing "lost+found". 
    Therefore setfattr creates the EA in-inode.
    After remount, i_extra_isize of 11th inode is set to 0 by ext3_iget()
    when we lookup the file, so getfattr tries to search the EA out-inode.
    However, the EA locates in-inode, so getfattr can't search the EA.

How to reproduce:
    1. mkfs.ext3 -I 256 /dev/sdXX
    2. mount -o acl,user_xattr  /dev/sdXX /TEST
    3. rm -rf /TEST/*
    4. touch /TEST/file (whose inode number is 11)
    5. cd /TEST; setfattr -n user.foo0 -v bar0 file
    6. cd /TEST; getfattr -d file
       -> can see foo0/bar0
    7. umount  /dev/sdXX
    8. mount -o acl,user_xattr /dev/sdXX /TEST
    9. cd /TEST; getfattr -d file
       -> can't see foo0/bar0

Though the 11th inode is used for "lost+found" normally, the other
file can also use it. Therefore, i_extra_isize of 11th inode should be set
to the suitable value by ext3_iget().

Signed-off-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
---
 fs/ext3/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 735f019..85e8574 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2881,8 +2881,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		atomic_set(&ei->i_datasync_tid, tid);
 	}
 
-	if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1 &&
-	    EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
+	if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
 		/*
 		 * When mke2fs creates big inodes it does not zero out
 		 * the unused bytes above EXT3_GOOD_OLD_INODE_SIZE,
-- 
1.6.2.5

Thanks,
Masayoshi

