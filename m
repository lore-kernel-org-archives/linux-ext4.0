From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][BUG] ext4: do not execute ext4_std_error with EFBIG at
 ext4_setattr
Date: Mon, 28 Jun 2010 11:42:56 +0900
Message-ID: <20100628114256.0c633779.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, toshi.okajima@jp.fujitsu.com
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37899 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0F1DP7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jun 2010 23:15:59 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o5S3Fw7a026837
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Mon, 28 Jun 2010 12:15:58 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id CF9F145DE4F
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jun 2010 12:15:57 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 9537345DE51
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jun 2010 12:15:57 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 7A844E18006
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jun 2010 12:15:57 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 32D69E0800B
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jun 2010 12:15:57 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

You know, do_truncate() can call ext4_setattr() (via notify_change()).
And, ext4_setattr() can return with -EFBIG if the argument(length) of 
do_truncate() is more than sbi->s_bitmap_maxbytes. At that time, 
it also calls ext4_std_error() with -EFBIG.

Besides, a panic happens when ext4_setattr() returns with -EFBIG
after we mount an ext4 filesystem with errors=panic.

The following steps can make this problem easily.
(1)
# /bin/dd if=/dev/zero of=/tmp/img bs=1k seek=1000k count=1
# /sbin/mkfs.ext3 -Fq /tmp/img
# /bin/mount -o loop -t ext4 /tmp/img /mnt
# /bin/dd if=/dev/zero of=/mnt/file bs=1k seek=2143281137 count=1
# /bin/dmesg
...
EXT4-fs error (device loop0) in ext4_setattr: error 27

(2)
# /bin/dd if=/dev/zero of=/tmp/img bs=1k seek=1000k count=1
# /sbin/mkfs.ext3 -Fq /tmp/img
# /bin/mount -o loop,errors=panic -t ext4 /tmp/img /mnt
# /bin/dd if=/dev/zero of=/mnt/file bs=1k seek=2143281137 count=1
(PANIC!)

This problem is in:
5482         if (attr->ia_valid & ATTR_SIZE) {
5483                 if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
5484                         struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
5485 
5486                         if (attr->ia_size > sbi->s_bitmap_maxbytes) {
5487                                 error = -EFBIG;
5488                                 goto err_out;
5489                         }
5490                 }
5491         }

5543 err_out:
5544         ext4_std_error(inode->i_sb, error);
5545         if (!error)
5546                 error = rc;
5547         return error;
(because ext4_setattr() calls ext4_std_error() when error == -EFBIG)

So, we change those into:
5482         if (attr->ia_valid & ATTR_SIZE) {
5483                 if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
5484                         struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
5485 
5486                         if (attr->ia_size > sbi->s_bitmap_maxbytes) {
5487                                 error = -EFBIG;
* 5488                                 goto err_out2;
5489                         }
5490                 }
5491         }

5543 err_out:
5544         ext4_std_error(inode->i_sb, error);
5545         if (!error)
5546                 error = rc;
* 5547 err_out2:
5548         return error;
This changes prevent this problem from happening.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..e87bb45 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5485,7 +5485,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 
 			if (attr->ia_size > sbi->s_bitmap_maxbytes) {
 				error = -EFBIG;
-				goto err_out;
+				goto err_out2;
 			}
 		}
 	}
@@ -5544,6 +5544,7 @@ err_out:
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
+err_out2:
 	return error;
 }
 
-- 
1.5.5.6
