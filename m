From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Unwritten extent zeroing beyond i_size
Date: Thu, 14 Mar 2013 12:11:28 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303141205330.18319@dhcp-1-104.brq.redhat.com>
References: <20130313095640.GC29730@quack.suse.cz> <alpine.LFD.2.00.1303140850460.18319@dhcp-1-104.brq.redhat.com> <20130314105629.GA12789@quack.suse.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-478148050-1363259491=:18319"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab3CNLMQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 07:12:16 -0400
In-Reply-To: <20130314105629.GA12789@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-478148050-1363259491=:18319
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 Mar 2013, Jan Kara wrote:

> Date: Thu, 14 Mar 2013 11:56:29 +0100
> From: Jan Kara <jack@suse.cz>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
>     linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> Subject: Re: Unwritten extent zeroing beyond i_size
> 
> On Thu 14-03-13 08:56:55, Lukáš Czerner wrote:
> > On Wed, 13 Mar 2013, Jan Kara wrote:
> > 
> > > Date: Wed, 13 Mar 2013 10:56:40 +0100
> > > From: Jan Kara <jack@suse.cz>
> > > To: Dmitry Monakhov <dmonakhov@openvz.org>
> > > Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> > > Subject: Unwritten extent zeroing beyond i_size
> > > 
> > >   Hello Dmitry,
> > > 
> > >   I'm tracking down failure in xfstests test 274 (fallocate + ENOSPC
> > > testing). The problem I found (and that's really unrelated to the question
> > > I want to ask) is that if write beyond i_size fails, we truncate the file
> > > to i_size to remove any blocks that may have been allocated under the page
> > > by the write before it failed (think of blocksize < pagesize config).
> > > 
> > > Now in this test the write fails because it needs to split unwritten extent
> > > and there's no space for that and zeroing out is impossible because we are
> > > beyond i_size. And here comes my question: You disallowed zeroing of
> > > extents beyond i_size because fsck complains about those. Won't it be
> > > better to just add inode flag saying "this inode has blocks preallocated
> > > beyond i_size" and make fsck not complain about such blocks? IMHO that
> > > would catch 99% of corruptions as well and would let us solve the problem
> > > with ENOSPC on writes to preallocated space (plus it would simplify the
> > > kernel code).
> > > 
> > > 								Honza
> > 
> > Unfortunately this will not solve the real issue that writing into
> > preallocated space should _not_ fail at all, because it is
> > preallocated.
> > 
> > The problem right now is that we simply do not have block to
> > allocate metadata, and there is no way for us to reserve metadata
> > blocks in advance as we might try to do in delalloc.
>   But if you don't need to split the extent (you will change the whole
> extent from unwritten to written state) you don't need any aditional
> metadata blocks. So write cannot fail...

Right, but that's not always the case, also this is not the
problematic case, or am I missing something ?

> 
> > I've proposed the solution for this in the recent email with subject
> > "Metadata reservation for unwritten extent conversion". Basically
> > the idea is to have reserved pool of blocks which could be used for
> > exactly this (and other) cases. Note that xfs actually have the same
> > thing for exactly the same reasons.
>   Yeah, I've read your proposal. I don't really object to this solution as
> it has advantages over "don't split extent if we are out of space" - namely
> it's going to be faster than writing extent full of zeros. But OTOH writing
> zeros is so much simpler than implementing some reservation of blocks for
> emergency cases that it looks as a compelling solution to me.

The reservation is not really all that complicated. Here is what I
have so far. Note that the code is not ready yet, nor is it properly
tested.

But you're right that zeroing the extent should be simpler. We might
want to have both solutions as in extreme cases we might run out of
the reserved space as well - it really depends on the default
setting. In that case a warning would be appropriate.

Thanks!
-Lukas

 fs/ext4/balloc.c  |   24 ++++++++++++---
 fs/ext4/ext4.h    |   14 ++++++---
 fs/ext4/extents.c |   21 ++++++++------
 fs/ext4/inode.c   |   12 +++++++-
 fs/ext4/super.c   |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 131 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 2f2e0da..bcd7acd 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -478,7 +478,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 				  s64 nclusters, unsigned int flags)
 {
-	s64 free_clusters, dirty_clusters, root_clusters;
+	s64 free_clusters, dirty_clusters, rsv;
 	struct percpu_counter *fcc = &sbi->s_freeclusters_counter;
 	struct percpu_counter *dcc = &sbi->s_dirtyclusters_counter;
 
@@ -489,9 +489,10 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	 * r_blocks_count should always be multiple of the cluster ratio so
 	 * we are safe to do a plane bit shift only.
 	 */
-	root_clusters = ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
+	rsv = (ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits) +
+	      sbi->s_resv_clusters;
 
-	if (free_clusters - (nclusters + root_clusters + dirty_clusters) <
+	if (free_clusters - (nclusters + rsv + dirty_clusters) <
 					EXT4_FREECLUSTERS_WATERMARK) {
 		free_clusters  = percpu_counter_sum_positive(fcc);
 		dirty_clusters = percpu_counter_sum_positive(dcc);
@@ -499,7 +500,7 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	/* Check whether we have space after accounting for current
 	 * dirty clusters & root reserved clusters.
 	 */
-	if (free_clusters >= ((root_clusters + nclusters) + dirty_clusters))
+	if (free_clusters >= (rsv + nclusters + dirty_clusters))
 		return 1;
 
 	/* Hm, nope.  Are (enough) root reserved clusters available? */
@@ -508,9 +509,22 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	    capable(CAP_SYS_RESOURCE) ||
 		(flags & EXT4_MB_USE_ROOT_BLOCKS)) {
 
-		if (free_clusters >= (nclusters + dirty_clusters))
+		if (free_clusters >= (nclusters + dirty_clusters +
+				      sbi->s_resv_clusters))
 			return 1;
 	}
+	/* No free blocks. Let's see if we can dip into reserved pool */
+	if (flags & EXT4_MB_USE_RESERVED) {
+		if (free_clusters >= (nclusters + dirty_clusters)) {
+			/*
+			sbi->s_resv_clusters_avail--;
+			if (sbi->s_resv_clusters_avail > sbi->s_resv_clusters)
+				printk(KERN_CRIT "resv_clusters_avail underflowed %llu\n",
+						sbi->s_resv_clusters_avail);
+			*/
+			return 1;
+		}
+	}
 
 	return 0;
 }
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6e16c18..949df97 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -121,6 +121,8 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_STREAM_ALLOC		0x0800
 /* Use reserved root blocks if needed */
 #define EXT4_MB_USE_ROOT_BLOCKS		0x1000
+/* Use blocks from reserved pool */
+#define EXT4_MB_USE_RESERVED		0x2000
 
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
@@ -557,9 +559,8 @@ enum {
 #define EXT4_GET_BLOCKS_UNINIT_EXT		0x0002
 #define EXT4_GET_BLOCKS_CREATE_UNINIT_EXT	(EXT4_GET_BLOCKS_UNINIT_EXT|\
 						 EXT4_GET_BLOCKS_CREATE)
-	/* Caller is from the delayed allocation writeout path,
-	   so set the magic i_delalloc_reserve_flag after taking the
-	   inode allocation semaphore for */
+	/* Caller is from the delayed allocation writeout path
+	 * finally doing the actual allocation of delayed blocks */
 #define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0004
 	/* caller is from the direct IO path, request to creation of an
 	unitialized extents if not allocated, split the uninitialized
@@ -571,8 +572,9 @@ enum {
 	/* Convert extent to initialized after IO complete */
 #define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
 					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
-	/* Punch out blocks of an extent */
-#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT		0x0020
+	/* Eventual metadata allocation (due to growing extent tree)
+	 * should not fail, so try to use reserved blocks for that.*/
+#define EXT4_GET_BLOCKS_METADATA_NOFAIL		0x0020
 	/* Don't normalize allocation size (used for fallocate) */
 #define EXT4_GET_BLOCKS_NO_NORMALIZE		0x0040
 	/* Request will not result in inode size update (user for fallocate) */
@@ -1179,6 +1181,8 @@ struct ext4_sb_info {
 	unsigned int s_mount_flags;
 	unsigned int s_def_mount_opt;
 	ext4_fsblk_t s_sb_block;
+	ext4_fsblk_t s_resv_clusters;
+	ext4_fsblk_t s_resv_clusters_avail;
 	kuid_t s_resuid;
 	kgid_t s_resgid;
 	unsigned short s_mount_state;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 28dd8ee..92f7881 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1878,8 +1878,8 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	if (flag & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
-		flags = EXT4_MB_USE_ROOT_BLOCKS;
+	if (flag & EXT4_GET_BLOCKS_METADATA_NOFAIL)
+		flags = EXT4_MB_USE_RESERVED;
 	err = ext4_ext_create_new_leaf(handle, inode, flags, path, newext);
 	if (err)
 		goto cleanup;
@@ -2665,12 +2665,14 @@ again:
 
 			/*
 			 * Split the extent in two so that 'end' is the last
-			 * block in the first new extent
+			 * block in the first new extent. Also we should not
+			 * fail removing space due to ENOSPC so try to use
+			 * reserved block if that happens.
 			 */
 			err = ext4_split_extent_at(handle, inode, path,
-						end + 1, split_flag,
-						EXT4_GET_BLOCKS_PRE_IO |
-						EXT4_GET_BLOCKS_PUNCH_OUT_EXT);
+					end + 1, split_flag,
+					EXT4_GET_BLOCKS_PRE_IO |
+					EXT4_GET_BLOCKS_METADATA_NOFAIL);
 
 			if (err < 0)
 				goto out;
@@ -3108,7 +3110,8 @@ out:
 static int ext4_ext_convert_to_initialized(handle_t *handle,
 					   struct inode *inode,
 					   struct ext4_map_blocks *map,
-					   struct ext4_ext_path *path)
+					   struct ext4_ext_path *path,
+					   int flags)
 {
 	struct ext4_sb_info *sbi;
 	struct ext4_extent_header *eh;
@@ -3287,7 +3290,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	}
 
 	allocated = ext4_split_extent(handle, inode, path,
-				      &split_map, split_flag, 0);
+				      &split_map, split_flag, flags);
 	if (allocated < 0)
 		err = allocated;
 
@@ -3652,7 +3655,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	}
 
 	/* buffered write, writepage time, convert*/
-	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
+	ret = ext4_ext_convert_to_initialized(handle, inode, map, path, flags);
 	if (ret >= 0)
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 out:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ea0cde..95081a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1601,12 +1601,21 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	 */
 	map.m_lblk = next;
 	map.m_len = max_blocks;
-	get_blocks_flags = EXT4_GET_BLOCKS_CREATE;
+	/*
+	 * We're in delalloc path and it is possible that we're going to
+	 * have to convert uninitialized extent to written which means
+	 * that we might need metadata allocation which was not accounted
+	 * for, but we can not fail due to ENOSPC so try to use reserved
+	 * blocks if possible.
+	 */
+	get_blocks_flags = EXT4_GET_BLOCKS_CREATE |
+			   EXT4_GET_BLOCKS_METADATA_NOFAIL;
 	if (ext4_should_dioread_nolock(mpd->inode))
 		get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
 	if (mpd->b_state & (1 << BH_Delay))
 		get_blocks_flags |= EXT4_GET_BLOCKS_DELALLOC_RESERVE;
 
+
 	blks = ext4_map_blocks(handle, mpd->inode, &map, get_blocks_flags);
 	if (blks < 0) {
 		struct super_block *sb = mpd->inode->i_sb;
@@ -1622,6 +1631,7 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 
 		if (err == -ENOSPC && ext4_count_free_clusters(sb)) {
 			mpd->retval = err;
+			printk(KERN_CRIT "%s ENOSPC - %llu\n", __func__, ext4_count_free_clusters(sb));
 			goto submit_io;
 		}
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 620cf56..dfe8797 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -81,6 +81,7 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
+static int ext4_reserve_clusters(struct ext4_sb_info *, ext4_fsblk_t);
 
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext2_fs_type = {
@@ -2356,6 +2357,17 @@ struct ext4_attr {
 	int offset;
 };
 
+static int parse_strtoull(const char *buf,
+		unsigned long long max, unsigned long long *value)
+{
+	int ret;
+
+	ret = kstrtoull(skip_spaces(buf), 0, value);
+	if (!ret && *value > max)
+		ret = -EINVAL;
+	return ret;
+}
+
 static int parse_strtoul(const char *buf,
 		unsigned long max, unsigned long *value)
 {
@@ -2440,6 +2452,26 @@ static ssize_t sbi_ui_store(struct ext4_attr *a,
 	return count;
 }
 
+static ssize_t resv_clusters_show(struct ext4_attr *a,
+				  struct ext4_sb_info *sbi, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%llu\n", sbi->s_resv_clusters);
+}
+
+static ssize_t resv_clusters_store(struct ext4_attr *a,
+				   struct ext4_sb_info *sbi,
+				   const char *buf, size_t count)
+{
+	unsigned long long val;
+	int ret;
+
+	if (parse_strtoull(buf, -1ULL, &val))
+		return -EINVAL;
+	ret = ext4_reserve_clusters(sbi, val);
+
+	return ret ? ret : count;
+}
+
 static ssize_t trigger_test_error(struct ext4_attr *a,
 				  struct ext4_sb_info *sbi,
 				  const char *buf, size_t count)
@@ -2477,6 +2509,7 @@ static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
 EXT4_RO_ATTR(delayed_allocation_blocks);
 EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
+EXT4_RW_ATTR(resv_clusters);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
@@ -2494,6 +2527,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(delayed_allocation_blocks),
 	ATTR_LIST(session_write_kbytes),
 	ATTR_LIST(lifetime_write_kbytes),
+	ATTR_LIST(resv_clusters),
 	ATTR_LIST(inode_readahead_blks),
 	ATTR_LIST(inode_goal),
 	ATTR_LIST(mb_stats),
@@ -3169,6 +3203,41 @@ int ext4_calculate_overhead(struct super_block *sb)
 	return 0;
 }
 
+
+static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
+{
+	ext4_fsblk_t resv_clusters;
+
+	/*
+	 * By default we reserve 2% or 4096 clusters, whichever is smaller.
+	 * This should cover the situations where we can not afford to run
+	 * out of space like for example punch hole, or converting
+	 * uninitialized extents in delalloc path. In most cases such
+	 * allocation would require 1, or 2 blocks, higher numbers are
+	 * very rare.
+	 */
+	resv_clusters = ext4_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
+
+	do_div(resv_clusters, 50);
+	resv_clusters = min_t(ext4_fsblk_t, resv_clusters, 4096);
+
+	return resv_clusters;
+}
+
+
+static int ext4_reserve_clusters(struct ext4_sb_info *sbi, ext4_fsblk_t count)
+{
+	ext4_fsblk_t fs_clusters;
+
+	fs_clusters = ext4_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
+	if (count >= fs_clusters)
+		return -EINVAL;
+
+	sbi->s_resv_clusters = count;
+	sbi->s_resv_clusters_avail = count;
+	return 0;
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
 	char *orig_data = kstrdup(data, GFP_KERNEL);
@@ -3887,6 +3956,13 @@ no_journal:
 			 "available");
 	}
 
+	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sbi));
+	if (err) {
+		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
+			 "reserved pool", ext4_calculate_resv_clusters(sbi));
+		goto failed_mount4a;
+	}
+
 	err = ext4_setup_system_zone(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize system "
@@ -4717,6 +4793,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	ext4_fsblk_t overhead = 0;
+	ext4_fsblk_t resv_blocks = EXT4_C2B(sbi, sbi->s_resv_clusters);
 	u64 fsid;
 	s64 bfree;
 
@@ -4730,8 +4807,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
 	/* prevent underflow in case that few free space is available */
 	buf->f_bfree = EXT4_C2B(sbi, max_t(s64, bfree, 0));
-	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
-	if (buf->f_bfree < ext4_r_blocks_count(es))
+	buf->f_bavail = buf->f_bfree -
+			(ext4_r_blocks_count(es) + resv_blocks);
+	if (buf->f_bfree < (ext4_r_blocks_count(es) + resv_blocks))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
-- 
1.7.7.6


--8323328-478148050-1363259491=:18319--
