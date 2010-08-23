From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Mon, 23 Aug 2010 09:50:56 +0900
Message-ID: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
References: <0347DFC8-03A9-45DF-9B9F-ED4005720C49@dilger.ca> <20100823091657.ACB6.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53794 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0HWAuf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Aug 2010 20:50:35 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7N0oXGH015789
	for <linux-ext4@vger.kernel.org> (envelope-from m.mizuma@jp.fujitsu.com);
	Mon, 23 Aug 2010 09:50:34 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id A819045DE51
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:50:33 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 7DD8045DE4D
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:50:33 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3AC5A1DB8038
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:50:33 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.249.87.106])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D523EE08002
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:50:29 +0900 (JST)
In-Reply-To: <20100823091657.ACB6.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

CC: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
---
 fs/ext3/inode.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5e0faf4..69c3d47 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2914,13 +2914,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		atomic_set(&ei->i_datasync_tid, tid);
 	}
 
-	if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1 &&
-	    EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
-		/*
-		 * When mke2fs creates big inodes it does not zero out
-		 * the unused bytes above EXT3_GOOD_OLD_INODE_SIZE,
-		 * so ignore those first few inodes.
-		 */
+	if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT3_INODE_SIZE(inode->i_sb)) {
-- 
1.6.2.5

Thanks,
Masayoshi

