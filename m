From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Thu, 24 Jan 2013 16:12:24 +0100
Message-ID: <20130124151224.GC21818@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <87vcamdi6e.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3AXPMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 10:12:36 -0500
Content-Disposition: inline
In-Reply-To: <87vcamdi6e.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 24-01-13 13:49:45, Dmitry Monakhov wrote:
> On Fri, 18 Jan 2013 13:00:38 +0100, Jan Kara <jack@suse.cz> wrote:
> > Merging of uninitialized extents creates all sorts of interesting race
> > possibilities when writeback / DIO races with fallocate. Thus
> > ext4_convert_unwritten_extents_endio() has to deal with a case where
> > extent to be converted needs to be split out first. That isn't nice
> > for two reasons:
> > 
> > 1) It may need allocation of extent tree block so ENOSPC is possible.
> > 2) It complicates end_io handling code
> As we already discussed your idea is 100% correct, but even with
> what patch I still able to trigger situation where split it required.
> I've got following error with this patch applied on top of 7f5118629f7
> EXT4-fs error (device dm-3): ext4_convert_unwritten_extents_endio:3411:
> inode #12: comm kworker/u:4: Written extent modified before IO finished:
> extent logical block 1379787, len 64; IO logical block 1379787, len 21
  Drat, thanks for heads up. I did run xfstests on the patch set but
apparently you are doing something more evil :) If I get your test & error
right, you do AIO DIO to a file while doing truncate 0, fallocate SIZE, in
a loop. And extent is found longer when we finish the IO. Am I right?

								Honza
> ------------[ cut here ]------------
> WARNING: at fs/ext4/extents.c:4518
> ext4_convert_unwritten_extents+0x149/0x210 [ext4]()
> Hardware name:         
> Modules linked in: ext4 jbd2 cpufreq_ondemand acpi_cpufreq freq_table
> mperf coretemp kvm_intel kvm crc32c_intel microcode sg button ext3 jbd
> mbcache sd_mod crc_t10dif ahci libahci pata_acpi ata_generic dm_mirror
> dm_region_hash dm_log dm_mod
> Pid: 249, comm: kworker/u:4 Not tainted 3.8.0-rc3+ #16
> Call Trace:
>  [<ffffffff8106fc23>] warn_slowpath_common+0xc3/0xf0
>  [<ffffffff8106fc6a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa03fb909>] ext4_convert_unwritten_extents+0x149/0x210 [ext4]
>  [<ffffffff811064fa>] ? __lock_release+0x1da/0x1f0
>  [<ffffffffa03c368e>] ext4_end_io+0x3e/0x160 [ext4]
>  [<ffffffff813aab40>] ? __list_del_entry+0x210/0x250
>  [<ffffffffa03c3a21>] ext4_do_flush_completed_IO+0x101/0x280 [ext4]
>  [<ffffffffa03c3bb6>] ext4_end_io_work+0x16/0x20 [ext4]
>  [<ffffffff8109f7dd>] process_one_work+0x4ad/0x780
>  [<ffffffff8109f6d2>] ? process_one_work+0x3a2/0x780
>  [<ffffffffa03c3ba0>] ? ext4_do_flush_completed_IO+0x280/0x280 [ext4]
>  [<ffffffff810a3ed1>] worker_thread+0x3f1/0x590
>  [<ffffffff810a3ae0>] ? manage_workers+0x210/0x210
>  [<ffffffff810ac870>] kthread+0x100/0x110
>  [<ffffffff810ac770>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff81812e2c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810ac770>] ? __init_kthread_worker+0x70/0x70
> ---[ end trace add5cefed72186f8 ]---
> EXT4-fs (dm-3): ext4_convert_unwritten_extents:4522: inode #12: block
> 1379787: len 21: ext4_ext_map_blocks returned -5
> EXT4-fs (dm-3): failed to convert unwritten extents to written
> extents -- potential data loss!  (inode 12, offset 5651562496, size
> 131072, error -5)
> 
> I've run 286'th xfstest (this is my own copy of xfstest so 286'th test
> is differ from mainstream one) you can find it here
> https://raw.github.com/dmonakhov/xfstests/devel/286
> In two words it is stress test which run DIO/AIO,truncate,fallocate in parallel.
> Also you need recent FIO(http://git.kernel.dk/?p=fio.git;a=summary)
> 
> Currently I try to understand what caused this issue.
> > 
> > So we disable merging of uninitialized extents which allows us to simplify
> > the code. Extents will get merged after they are converted to initialized
> > ones.
> > 
> > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/extents.c |   61 +++++++++++++++-------------------------------------
> >  1 files changed, 18 insertions(+), 43 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 26af228..f1ce33a 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -54,9 +54,6 @@
> >  #define EXT4_EXT_MARK_UNINIT1	0x2  /* mark first half uninitialized */
> >  #define EXT4_EXT_MARK_UNINIT2	0x4  /* mark second half uninitialized */
> >  
> > -#define EXT4_EXT_DATA_VALID1	0x8  /* first half contains valid data */
> > -#define EXT4_EXT_DATA_VALID2	0x10 /* second half contains valid data */
> > -
> >  static __le32 ext4_extent_block_csum(struct inode *inode,
> >  				     struct ext4_extent_header *eh)
> >  {
> > @@ -1579,20 +1576,17 @@ int
> >  ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
> >  				struct ext4_extent *ex2)
> >  {
> > -	unsigned short ext1_ee_len, ext2_ee_len, max_len;
> > +	unsigned ext1_ee_len, ext2_ee_len;
> >  
> >  	/*
> > -	 * Make sure that either both extents are uninitialized, or
> > -	 * both are _not_.
> > +	 * Make sure that both extents are initialized. We don't merge
> > +	 * uninitialized extents so that we can be sure that end_io code has
> > +	 * the extent that was written properly split out and conversion to
> > +	 * initialized is trivial.
> >  	 */
> > -	if (ext4_ext_is_uninitialized(ex1) ^ ext4_ext_is_uninitialized(ex2))
> > +	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
> >  		return 0;
> >  
> > -	if (ext4_ext_is_uninitialized(ex1))
> > -		max_len = EXT_UNINIT_MAX_LEN;
> > -	else
> > -		max_len = EXT_INIT_MAX_LEN;
> > -
> >  	ext1_ee_len = ext4_ext_get_actual_len(ex1);
> >  	ext2_ee_len = ext4_ext_get_actual_len(ex2);
> >  
> > @@ -1605,7 +1599,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
> >  	 * as an RO_COMPAT feature, refuse to merge to extents if
> >  	 * this can result in the top bit of ee_len being set.
> >  	 */
> > -	if (ext1_ee_len + ext2_ee_len > max_len)
> > +	if (ext1_ee_len + ext2_ee_len > EXT_INIT_MAX_LEN)
> >  		return 0;
> >  #ifdef AGGRESSIVE_TEST
> >  	if (ext1_ee_len >= 4)
> > @@ -2959,9 +2953,6 @@ static int ext4_split_extent_at(handle_t *handle,
> >  	unsigned int ee_len, depth;
> >  	int err = 0;
> >  
> > -	BUG_ON((split_flag & (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2)) ==
> > -	       (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2));
> > -
> >  	ext_debug("ext4_split_extents_at: inode %lu, logical"
> >  		"block %llu\n", inode->i_ino, (unsigned long long)split);
> >  
> > @@ -3020,14 +3011,7 @@ static int ext4_split_extent_at(handle_t *handle,
> >  
> >  	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> >  	if (err == -ENOSPC && (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
> > -		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
> > -			if (split_flag & EXT4_EXT_DATA_VALID1)
> > -				err = ext4_ext_zeroout(inode, ex2);
> > -			else
> > -				err = ext4_ext_zeroout(inode, ex);
> > -		} else
> > -			err = ext4_ext_zeroout(inode, &orig_ex);
> > -
> > +		err = ext4_ext_zeroout(inode, &orig_ex);
> >  		if (err)
> >  			goto fix_extent_len;
> >  		/* update the extent length and mark as initialized */
> > @@ -3085,8 +3069,6 @@ static int ext4_split_extent(handle_t *handle,
> >  		if (uninitialized)
> >  			split_flag1 |= EXT4_EXT_MARK_UNINIT1 |
> >  				       EXT4_EXT_MARK_UNINIT2;
> > -		if (split_flag & EXT4_EXT_DATA_VALID2)
> > -			split_flag1 |= EXT4_EXT_DATA_VALID1;
> >  		err = ext4_split_extent_at(handle, inode, path,
> >  				map->m_lblk + map->m_len, split_flag1, flags1);
> >  		if (err)
> > @@ -3099,8 +3081,7 @@ static int ext4_split_extent(handle_t *handle,
> >  		return PTR_ERR(path);
> >  
> >  	if (map->m_lblk >= ee_block) {
> > -		split_flag1 = split_flag & (EXT4_EXT_MAY_ZEROOUT |
> > -					    EXT4_EXT_DATA_VALID2);
> > +		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
> >  		if (uninitialized)
> >  			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
> >  		if (split_flag & EXT4_EXT_MARK_UNINIT2)
> > @@ -3379,8 +3360,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
> >  
> >  	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
> >  	split_flag |= EXT4_EXT_MARK_UNINIT2;
> > -	if (flags & EXT4_GET_BLOCKS_CONVERT)
> > -		split_flag |= EXT4_EXT_DATA_VALID2;
> > +
> >  	flags |= EXT4_GET_BLOCKS_PRE_IO;
> >  	return ext4_split_extent(handle, inode, path, map, split_flag, flags);
> >  }
> > @@ -3405,20 +3385,15 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
> >  		"block %llu, max_blocks %u\n", inode->i_ino,
> >  		  (unsigned long long)ee_block, ee_len);
> >  
> > -	/* If extent is larger than requested then split is required */
> > +	/* Extent is larger than requested? */
> >  	if (ee_block != map->m_lblk || ee_len > map->m_len) {
> > -		err = ext4_split_unwritten_extents(handle, inode, map, path,
> > -						   EXT4_GET_BLOCKS_CONVERT);
> > -		if (err < 0)
> > -			goto out;
> > -		ext4_ext_drop_refs(path);
> > -		path = ext4_ext_find_extent(inode, map->m_lblk, path);
> > -		if (IS_ERR(path)) {
> > -			err = PTR_ERR(path);
> > -			goto out;
> > -		}
> > -		depth = ext_depth(inode);
> > -		ex = path[depth].p_ext;
> > +		EXT4_ERROR_INODE(inode, "Written extent modified before IO"
> > +			" finished: extent logical block %llu, len %u; IO"
> > +			" logical block %llu, len %u\n",
> > +			(unsigned long long)ee_block, ee_len,
> > +			(unsigned long long)map->m_lblk, map->m_len);
> > +		err = -EIO;
> > +		goto out;
> >  	}
> >  
> >  	err = ext4_ext_get_access(handle, inode, path + depth);
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
