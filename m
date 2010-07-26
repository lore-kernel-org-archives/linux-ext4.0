From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][BUG] ext4: fix returning with 0 from write system call on
 ext4 with noextent
Date: Mon, 26 Jul 2010 11:16:36 +0900
Message-ID: <20100726111636.72264f8c.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51895 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0GZC1s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Jul 2010 22:27:48 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o6Q2RjAW002767
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Mon, 26 Jul 2010 11:27:45 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 5E4CA45DE50
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 11:27:45 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 3C4AC45DE4C
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 11:27:45 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 23F8D1DB8012
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 11:27:45 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id D1C6F1DB8015
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 11:27:41 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

By running the following reproducer, we can confirm that the write 
system call returns with 0.
-------------------------------------------------------------------------------
[reproducer] repro.sh
#!/bin/sh

/bin/dd if=/dev/zero of=./img bs=1k count=1 seek=1024k > /dev/null 2>&1
/sbin/mkfs.ext3 -Fq ./img
/bin/mount -o loop -t ext4 ./img /mnt
/bin/touch /mnt/file
strace /bin/dd if=/dev/zero of=/mnt/file conv=notrunc bs=1k count=1 seek=$((2194719883264/1024)) 2>&1 | /bin/egrep "write.* 1024\) = "
/bin/umount /mnt
exit

# sh ./repro.sh 
write(1, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 0
-------------------------------------------------------------------------------
2194719883264 bytes is the maximum file size of ext4 with noextent (nohugefile).
Therefore a "write system call" from 2194719883264th offset of a file should
be failed. 
This problem can occur because the following check is insufficient.

  58 static ssize_t
  59 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
  60                 unsigned long nr_segs, loff_t pos)
  61 {
  62         struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
  63 
  64         /*
  65          * If we have encountered a bitmap-format file, the size limit
  66          * is smaller than s_maxbytes, which is for extent-mapped files.
  67          */
  68 
  69         if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
  70                 struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
  71                 size_t length = iov_length(iov, nr_segs);
  72 
  73                 if (pos > sbi->s_bitmap_maxbytes)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  74                         return -EFBIG;
  75 
  76                 if (pos + length > sbi->s_bitmap_maxbytes) {
  77                         nr_segs = iov_shorten((struct iovec *)iov,
nr_segs,
  78                                               sbi->s_bitmap_maxbytes -
pos);
  79                 }
  80         }

So, we need consider the case: "the file position is the max file size and
we write something to the file".
If the consideration is included, this problem can fix.

[applying the fix patch]
# sh ./repro.sh 
write(1, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = -1 EFBIG (File too large)

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5313ae4..3834ead 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -70,7 +70,8 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 		size_t length = iov_length(iov, nr_segs);
 
-		if (pos > sbi->s_bitmap_maxbytes)
+		if (pos > sbi->s_bitmap_maxbytes
+		   || (pos == sbi->s_bitmap_maxbytes && length > 0))
 			return -EFBIG;
 
 		if (pos + length > sbi->s_bitmap_maxbytes) {
-- 
1.5.5.6
