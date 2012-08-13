From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Sun, 12 Aug 2012 23:22:43 -0400
Message-ID: <20120813032243.GB13072@thunk.org>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
 <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Zach Brown <zab@zabbo.net>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44323 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab2HMDWw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2012 23:22:52 -0400
Content-Disposition: inline
In-Reply-To: <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 12, 2012 at 10:51:12AM -0600, Andreas Dilger wrote:
> 
> It would make sense to use the s_raid_stripe_width as the default value for
> this parameter.  The other thing we need to pay attention to is that the
> growth of the extent zeroing be done on a RAID or erase-block aligned manner.
> Otherwise, this might cause extra IO that doesn't benefit the application.

Well.... it really depends on the workload.  If you have a workload
which is doing random writes into an uninitialized region of memory,
on a RAID device you're going to be doing read/modify/write cycles
anyway.  By using a larger zero-out chunk parameter, it avoids the
excess metadata operations, and it avoids fragmenting the extent tree.

The patch that sent out, "ext4: collapse a single extent tree block
into the inode if possible" will help out in at least some cases,
hopefully the most common ones, but using a larger zero-out size can
also help address this situation.

My larger concern with this patch is that 1MB writes are not free, and
turning a 4k random write into a 1MB write is going to be noticeable.
I've changed the default from 1MB to 256k, just to be more
conservative, but need to do some benchmarking to make sure we
understand what the best number will be on a variety of common
hardware in use by our users.

I also reworded the commit description slightly, and this is what I
currently have in my tree.  What do people think?

	       	     	    	    	   - Ted

commit 5b9401f6f5afbce4cacdd01cc7c74780cc084aa3
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Sun Aug 12 23:08:58 2012 -0400

    ext4: make the zero-out chunk size tunable
    
    Currently in ext4 the length of zero-out chunk is set to 7.  But it is
    too short so that it will cause a lot of fragmentation of extent when
    we use fallocate to preallocate some uninitialized extents and the
    workload frequently does some uninitialized extent conversions.  Thus,
    we allow it to be tunable via sysfs and set an initial default value
    of 32, so instead of creating uninitalized extents smaller than
    256k (assuming a 4k block size), they will be zeroed out instead.
    
    CC: Zach Brown <zab@zabbo.net>
    CC: Andreas Dilger <adilger@dilger.ca>
    Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7c0841e..f9024a6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1271,6 +1271,9 @@ struct ext4_sb_info {
 	unsigned long s_sectors_written_start;
 	u64 s_kbytes_written;
 
+	/* the size of zero-out chunk */
+	unsigned int s_extent_zeroout_len;
+
 	unsigned int s_log_groups_per_flex;
 	struct flex_groups *s_flex_groups;
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 92fac2f..10f0afd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3084,7 +3084,6 @@ out:
 	return err ? err : map->m_len;
 }
 
-#define EXT4_EXT_ZERO_LEN 7
 /*
  * This function is called by ext4_ext_map_blocks() if someone tries to write
  * to an uninitialized extent. It may result in splitting the uninitialized
@@ -3110,6 +3109,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 					   struct ext4_map_blocks *map,
 					   struct ext4_ext_path *path)
 {
+	struct ext4_sb_info *sbi;
 	struct ext4_extent_header *eh;
 	struct ext4_map_blocks split_map;
 	struct ext4_extent zero_ex;
@@ -3124,6 +3124,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		"block %llu, max_blocks %u\n", inode->i_ino,
 		(unsigned long long)map->m_lblk, map->m_len);
 
+	sbi = EXT4_SB(inode->i_sb);
 	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
@@ -3223,8 +3224,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	 */
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
 
-	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
-	if (ee_len <= 2*EXT4_EXT_ZERO_LEN &&
+	/* If extent has less than 2*s_extent_zeroout_len zerout directly */
+	if (ee_len <= (2 * sbi->s_extent_zeroout_len) &&
 	    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 		err = ext4_ext_zeroout(inode, ex);
 		if (err)
@@ -3250,7 +3251,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	split_map.m_len = map->m_len;
 
 	if (allocated > map->m_len) {
-		if (allocated <= EXT4_EXT_ZERO_LEN &&
+		if (allocated <= sbi->s_extent_zeroout_len &&
 		    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 3 */
 			zero_ex.ee_block =
@@ -3264,7 +3265,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			split_map.m_lblk = map->m_lblk;
 			split_map.m_len = allocated;
 		} else if ((map->m_lblk - ee_block + map->m_len <
-			   EXT4_EXT_ZERO_LEN) &&
+			   sbi->s_extent_zeroout_len) &&
 			   (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 2 */
 			if (map->m_lblk != ee_block) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5896dcb..4a7092b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2541,6 +2541,7 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
+EXT4_RW_ATTR_SBI_UI(extent_zeroout_len, s_extent_zeroout_len);
 EXT4_ATTR(trigger_fs_error, 0200, NULL, trigger_test_error);
 
 static struct attribute *ext4_attrs[] = {
@@ -2556,6 +2557,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(extent_zeroout_len),
 	ATTR_LIST(trigger_fs_error),
 	NULL,
 };
@@ -3752,6 +3754,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
 	sbi->s_max_writeback_mb_bump = 128;
+	sbi->s_extent_zeroout_len = 16;
 
 	/*
 	 * set up enough so that it can read an inode
