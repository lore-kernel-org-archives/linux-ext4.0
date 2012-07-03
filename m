From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Wed, 4 Jul 2012 01:41:47 +0800
Message-ID: <20120703174147.GA14986@gmail.com>
References: <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
 <4FF1DEDF.90105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45200 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2GCRdd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 13:33:33 -0400
Received: by ghrr11 with SMTP id r11so5561741ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jul 2012 10:33:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FF1DEDF.90105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 02, 2012 at 01:48:15PM -0400, Ric Wheeler wrote:
> Definitely more interesting I think to try and do the MB size extent
> conversion, that should be generally a good technique to minimize
> the overhead.

Hi Ric and other developers,

I generate a patch to adjust the length of zero-out chunk (I attach it
at the bottom of this email), and do the following test.  The result
shows that the number of fragmentations of extent can be reduced with
the length of chunk increasingly.  Meanwhile the iops in non-journal
mode can be slightly increased.  But in journal mode (data=ordered) the
iops almost doesn't change.  So now I describe my test in detailed, and
sorry for leaving too much boring numbers in here.

[environment]
I run the test in my own desktop, which has a Intel(R) Core(TM)2 Duo CPU
E8400, 4GB memory, a SATA disk (SAMSUNG HD161GJ).  I only use a
paraition of this disk to do the test.

[workload]
I use fio to do the test, which is provided by Ted, and I paste it in
here again.

  [global]
  rw=randwrite
  size=128m
  filesize=1g
  bs=4k
  ioengine=sync
  fallocate=1
  fsync=1

  [thread1]
  filename=testfile

[ext4 parameters]
I run the same test in journal (data=ordered)/non-journal mode.  The
length of zero-out chunk includes: 7 (old deafult value), 16, 32, 64,
128, and 256.  In addition, I use dd to create a preallocated file to
simulate fallocate with NO_HIDE_STAE_DATA flag.  After every test, I
use the following command to accout the number of fragmenetations of
extent.

$ debugfs -R 'ex ${TESTFILE}' /dev/${DEVICE} | wc -l

[results]
Non-journal modes
len|extents|fio-result
7  |22656  |write: io=131072KB, bw=852170 B/s, iops=208 , runt=157501msec
16 |4273   |write: io=131072KB, bw=820552 B/s, iops=200 , runt=163570msec
32 |228    |write: io=131072KB, bw=828059 B/s, iops=202 , runt=162087msec
64 |31     |write: io=131072KB, bw=869201 B/s, iops=212 , runt=154415msec
128|23     |write: io=131072KB, bw=893706 B/s, iops=218 , runt=150181msec
256|17     |write: io=131072KB, bw=907281 B/s, iops=221 , runt=147934msec
flg|10     |write: io=131072KB, bw=1033.9KB/s, iops=258 , runt=126874msec

*flg: fallocate with NO_HIDE_STALE_DATA flag*

Journal mode
len|extents|fio-result
7  |22653  |write: io=131072KB, bw=124818 B/s, iops=30 , runt=1075302msec
16 |4260   |write: io=131072KB, bw=122595 B/s, iops=29 , runt=1094801msec
32 |228    |write: io=131072KB, bw=123968 B/s, iops=30 , runt=1082677msec
64 |32     |write: io=131072KB, bw=122272 B/s, iops=29 , runt=1097691msec
128|22     |write: io=131072KB, bw=123328 B/s, iops=30 , runt=1088291msec
256|19     |write: io=131072KB, bw=122040 B/s, iops=29 , runt=1099781msec
flg|10     |write: io=131072KB, bw=122266 B/s, iops=29 , runt=1097743msec

Obviously, after increasing the length of zero-out chunk, the number of
fragmentations is reduced, and in non-journal mode the iops is slightly
increased.  In journal mode, the performance doesn't be impacted.  So
this patch can reduce the number of fragmentations of extent when we do
a lot of uninitialized extent conversions, but it doesn't solve the key
issue.

The result of fallocate with NO_STALE_DATA flag makes me puzzled.  It
cannot improve the performance.  But I don't dig this problem yet.  So
I turn back to re-run my old test as I said in the previous email.  The
result is 88s vs. 17s in journal mode.  The command is as follow:

time for((i=0;i<2000;i++)); do \
dd if=/dev/zero of=/mnt/sda1/testfile conv=notrunc bs=4k \
      count=1 seek=`expr $i \* 16` oflag=sync,direct 2>/dev/null; \
done

So IMHO that the length of chunk is increased quite can help us to avoid
the number of fragmentations as much as possible.  But it doesn't solve
the *root cause*.

In addition, I run the fio test between xfs and ext4 (with
journal_async_commit option, and the length of zero-out chunk is 7).  The
result of iops is 39 (xfs) vs. 44 (ext4).  I do this test because I
remember that xfs's delay logging is an async journal (I am not sure
becuase I don't familiar with xfs's code).  Thus, it points out that
async journal is useful for us.

Regards,
Zheng

Subject: [PATCH] ext4: dynamical adjust the length of zero-out chunk

From: Zheng Liu <wenqing.lz@taobao.com>

Currently in ext4 the length of zero-out chunk is set to 7.  But it is
too short so that it will cause a lot of fragmentation of extent when
we use fallocate to preallocate some uninitialized extents and the
workload frequently does a uninitialized extent conversion.  Thus, now
we set it to 256 (1MB chunk), and put it into super block in order to
adjust it dynamically in sysfs.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h    |    3 +++
 fs/ext4/extents.c |   11 ++++++-----
 fs/ext4/super.c   |    3 +++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cfc4e01..0f44577 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1265,6 +1265,9 @@ struct ext4_sb_info {
 	/* locality groups */
 	struct ext4_locality_group __percpu *s_locality_groups;
 
+	/* the length of zero-out chunk */
+	unsigned int s_extent_zeroout_len;
+
 	/* for write statistics */
 	unsigned long s_sectors_written_start;
 	u64 s_kbytes_written;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..e921c02 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3029,7 +3029,6 @@ out:
 	return err ? err : map->m_len;
 }
 
-#define EXT4_EXT_ZERO_LEN 7
 /*
  * This function is called by ext4_ext_map_blocks() if someone tries to write
  * to an uninitialized extent. It may result in splitting the uninitialized
@@ -3055,6 +3054,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 					   struct ext4_map_blocks *map,
 					   struct ext4_ext_path *path)
 {
+	struct ext4_sb_info *sbi;
 	struct ext4_extent_header *eh;
 	struct ext4_map_blocks split_map;
 	struct ext4_extent zero_ex;
@@ -3069,6 +3069,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		"block %llu, max_blocks %u\n", inode->i_ino,
 		(unsigned long long)map->m_lblk, map->m_len);
 
+	sbi = EXT4_SB(inode->i_sb);
 	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
@@ -3168,8 +3169,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	 */
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
 
-	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
-	if (ee_len <= 2*EXT4_EXT_ZERO_LEN &&
+	/* If extent has less than 2*s_extent_zeroout_len zerout directly */
+	if (ee_len <= 2*sbi->s_extent_zeroout_len &&
 	    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 		err = ext4_ext_zeroout(inode, ex);
 		if (err)
@@ -3195,7 +3196,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	split_map.m_len = map->m_len;
 
 	if (allocated > map->m_len) {
-		if (allocated <= EXT4_EXT_ZERO_LEN &&
+		if (allocated <= sbi->s_extent_zeroout_len &&
 		    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 3 */
 			zero_ex.ee_block =
@@ -3209,7 +3210,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			split_map.m_lblk = map->m_lblk;
 			split_map.m_len = allocated;
 		} else if ((map->m_lblk - ee_block + map->m_len <
-			   EXT4_EXT_ZERO_LEN) &&
+			   sbi->s_extent_zeroout_len) &&
 			   (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 2 */
 			if (map->m_lblk != ee_block) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb7aa3e..ad6cf73 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2535,6 +2535,7 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
+EXT4_RW_ATTR_SBI_UI(extent_zeroout_len, s_extent_zeroout_len);
 EXT4_ATTR(trigger_fs_error, 0200, NULL, trigger_test_error);
 
 static struct attribute *ext4_attrs[] = {
@@ -2550,6 +2551,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(extent_zeroout_len),
 	ATTR_LIST(trigger_fs_error),
 	NULL,
 };
@@ -3626,6 +3628,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
 	sbi->s_max_writeback_mb_bump = 128;
+	sbi->s_extent_zeroout_len = 256;
 
 	/*
 	 * set up enough so that it can read an inode
-- 
1.7.4.1

