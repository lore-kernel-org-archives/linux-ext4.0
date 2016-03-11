From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()
Date: Fri, 11 Mar 2016 23:38:53 +0800
Message-ID: <1457710733-10192-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33472 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747AbcCKPl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Mar 2016 10:41:56 -0500
Received: by mail-pa0-f66.google.com with SMTP id q6so8760579pav.0
        for <linux-ext4@vger.kernel.org>; Fri, 11 Mar 2016 07:41:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_reserve_inode_write() in ext4_mark_inode_dirty() could fail on
error (e.g. EIO) and iloc.bh can be NULL in this case. But the error is
ignored in the following "if" condition and ext4_expand_extra_isize()
might be called with NULL iloc.bh set, which triggers NULL pointer
dereference.

This is uncovered by commit 8b4953e13f4c ("ext4: reserve code points for
the project quota feature"), which enlarges the ext4_inode size, and
run the following script on new kernel but with old mke2fs:

  #/bin/bash
  mnt=/mnt/ext4
  devname=ext4-error
  dev=/dev/mapper/$devname
  fsimg=/home/fs.img

  trap cleanup 0 1 2 3 9 15

  cleanup()
  {
          umount $mnt >/dev/null 2>&1
          dmsetup remove $devname
          losetup -d $backend_dev
          rm -f $fsimg
          exit 0
  }

  rm -f $fsimg
  fallocate -l 1g $fsimg
  backend_dev=`losetup -f --show $fsimg`
  devsize=`blockdev --getsz $backend_dev`

  good_tab="0 $devsize linear $backend_dev 0"
  error_tab="0 $devsize error $backend_dev 0"

  dmsetup create $devname --table "$good_tab"

  mkfs -t ext4 $dev
  mount -t ext4 -o errors=continue,strictatime $dev $mnt

  dmsetup load $devname --table "$error_tab" && dmsetup resume $devname
  echo 3 > /proc/sys/vm/drop_caches
  ls -l $mnt
  exit 0

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aee960b..f1f26ea 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5261,7 +5261,7 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 	might_sleep();
 	trace_ext4_mark_inode_dirty(inode, _RET_IP_);
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (ext4_handle_valid(handle) &&
+	if (!err && ext4_handle_valid(handle) &&
 	    EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
 	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
 		/*
-- 
2.5.0

