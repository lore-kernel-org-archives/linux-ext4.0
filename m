From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: make ext4_has_inline_data() as a inline function
Date: Wed, 4 Jun 2014 15:11:11 +0800
Message-ID: <20140604071111.GA19191@gmail.com>
References: <1401709168-27403-1-git-send-email-wenqing.lz@taobao.com>
 <20140602145631.GD30598@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ian Nartowicz <claws@nartowicz.co.uk>,
	Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:40560 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaFDHDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 03:03:54 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so6597098pbb.13
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jun 2014 00:03:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140602145631.GD30598@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2014 at 10:56:31AM -0400, Theodore Ts'o wrote:
> I am wondering though, as we add ext4_has_inline_data() to more and
> more codepaths, whether we might be better off making this an inline
> function in ext4.h.  We should see how much such a change bloats the
> text sizes, and whether there is any measurable CPU difference.

Subject: [PATCH] ext4: make ext4_has_inline_data() as a inline function

From: Zheng Liu <wenqing.lz@taobao.com>

Now ext4_has_inline_data() is used in wide spread codepaths.  So we need
to make it as a inline function to avoid burning some CPU cycles.

text size (bytes):
vanilla: 10350562
patched: 10384933 (+0.33%)

I use the following script to measure the CPU usage.

  #!/bin/bash

  shm_base='/dev/shm'
  img=${shm_base}/ext4-img
  mnt=/mnt/loop

  e2fsprgs_base=$HOME/e2fsprogs
  mkfs=${e2fsprgs_base}/misc/mke2fs
  fsck=${e2fsprgs_base}/e2fsck/e2fsck

  sudo umount $mnt
  dd if=/dev/zero of=$img bs=4k count=3145728
  ${mkfs} -t ext4 -O inline_data -F $img
  sudo mount -t ext4 -o loop $img $mnt

  # start testing...
  testdir="${mnt}/testdir"
  mkdir $testdir
  cd $testdir

  echo "start testing..."
  for ((cnt=0;cnt<100;cnt++)); do

  for ((i=0;i<5;i++)); do
  	for ((j=0;j<5;j++)); do
  		for ((k=0;k<5;k++)); do
  			for ((l=0;l<5;l++)); do
  				mkdir -p $i/$j/$k/$l
  				echo "$i-$j-$k-$l" > $i/$j/$k/$l/testfile
  			done
  		done
  	done
  done

  ls -R $testdir > /dev/null
  rm -rf $testdir/*

  done

The result of `perf top -G -U` is as below.

vanilla:
 13.92%  [ext4]  [k] ext4_do_update_inode
  9.36%  [ext4]  [k] __ext4_get_inode_loc
  4.07%  [ext4]  [k] ftrace_define_fields_ext4_writepages
  3.83%  [ext4]  [k] __ext4_handle_dirty_metadata
  3.42%  [ext4]  [k] ext4_get_inode_flags
  2.71%  [ext4]  [k] ext4_mark_iloc_dirty
  2.46%  [ext4]  [k] ftrace_define_fields_ext4_direct_IO_enter
  2.26%  [ext4]  [k] ext4_get_inode_loc
  2.22%  [ext4]  [k] ext4_has_inline_data
  [...]

After applied the patch, we don't see ext4_has_inline_data() because it
has been inlined and perf couldn't sample it.  Although it doesn't mean
that the CPU cycles can be saved but at least the overhead of function
calls can be eliminated.  So IMHO we'd better inline this function.

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h   |    7 ++++++-
 fs/ext4/inline.c |    6 ------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0519715..0531df5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2564,7 +2564,6 @@ extern const struct file_operations ext4_file_operations;
 extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 
 /* inline.c */
-extern int ext4_has_inline_data(struct inode *inode);
 extern int ext4_get_max_inline_size(struct inode *inode);
 extern int ext4_find_inline_data_nolock(struct inode *inode);
 extern int ext4_init_inline_data(handle_t *handle, struct inode *inode,
@@ -2630,6 +2629,12 @@ extern void ext4_inline_data_truncate(struct inode *inode, int *has_inline);
 
 extern int ext4_convert_inline_data(struct inode *inode);
 
+static inline int ext4_has_inline_data(struct inode *inode)
+{
+	return ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA) &&
+	       EXT4_I(inode)->i_inline_off;
+}
+
 /* namei.c */
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 645205d..141b6ac 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -120,12 +120,6 @@ int ext4_get_max_inline_size(struct inode *inode)
 	return max_inline_size + EXT4_MIN_INLINE_DATA_SIZE;
 }
 
-int ext4_has_inline_data(struct inode *inode)
-{
-	return ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA) &&
-	       EXT4_I(inode)->i_inline_off;
-}
