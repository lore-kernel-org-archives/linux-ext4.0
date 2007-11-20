From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] ext4: dir inode reservation V3
Date: Tue, 20 Nov 2007 12:14:03 +0800
Message-ID: <47425F0B.3030604@suse.de>
References: <4739B0C0.3060907@suse.de> <1195524061.4177.17.camel@localhost.localdomain>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44413 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXKTEF7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2007 23:05:59 -0500
In-Reply-To: <1195524061.4177.17.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks for the feedback :-)

Mingming Cao wrote:
> On Tue, 2007-11-13 at 22:12 +0800, Coly Li wrote:
>> Basic idea of my dir inode reservation patch can be found here,
>> http://lists.openwall.net/linux-ext4/2007/11/05/3
>>
>> 1, What does dir inode reservation do
>> Dir inode reservation tries to reserve several inodes in inodes table for a directory when this
>> directory is created. When create new file under this directory, try to allocate inode from the
>> reserved inodes area. This is called as dir_ireserve inode allocator.
>>
> Thanks for the update.
> 
> Let me try to understand your method:
> 
> So the basic idea is not do linear inode allocation for directory? Inode
> structure block for directory file is only coming from block 0, N, N
> +N,... where the number of skipped blocks N is stored in the in-core
> superblock structure. 

N is not stored in in-core superblock. N = s_dir_ireserve_nr / inodes_per_block. What is stored in
in-core superblock is number of inodes to be reserved for each directory.

> 
> When ever need to allocate an inode for directory, skip N reserved bits
> (space for N*16 inodes) if the previous block is already allocated. That
> way place two directories with the hole of N*16 inodes structures, then
> allow files under the first directory stay closer with their parent
> directory. Is this correct?

The hole is (s_dir_ireserve_nr - 1), not N * s_dir_ireserve_nr. Because directory inode will also
use a inode slot from reserved area, reset slots number for files is (s_dir_ireserve_nr - 1).
Except for the reserved inodes number, your understanding exactly matches my idea.

>  
> 
>> 4, Dir inode reservation is optional
>> Dir inode reservation is optional, you can use -o followed by one of these options to enable dir
>> inode reservation during mount ext4 file system:
>>          dir_ireserve=low
>>          dir_ireserve=normal
>>          dir_ireserve=high
> 
> Would be nice to pass the tuning info low/normal/high(16/64/128 blocks
> correspondingly) via something else rather than mount options. 

Sure, I agree with you. Also I am thinking should this patch permit user to input reserved inodes
number directly other than a low/normal/high. Also I am looking for methods to display the tuning
info more convenient to users.

>  
>> Currently, 'low' reserves 15 file inodes for each directory, 'normal' reserves 31 inodes and 'high'
>> reserves 127 inodes. Reserving more than 127 inodes does not help to performance obviously.
>>
>>
>> 5, Performance number
>> On a Core-Duo, 2MB DDM memory, 7200 RPM SATA PC, I built a 50GB ext4 partition, and tried to create
>> 50000 directories, and create 15 (1KB) files in each directory alternatively. After a remount, I
>> tried to remove all the directories and files recursively by a 'rm -rf'. Bellow is the benchmark result,
>> 			normal ext4			ext4 with dir inode reservation
>> 	mount options:	-o data=writeback		-o data=writeback,dir_ireserve=low
>> 	Create dirs:	real    0m49.101s		real    2m59.703s
>> 	Create files:	real    24m17.962s		real    21m8.161s
>> 	Unlink all:	real    24m43.788s		real    17m29.862s
>> Creating dirs with dir inode reservation is slower than normal ext4 as predicted, because allocating
>> directory inodes in non-linear order will cause extra hard disk seeking and block I/O.
> 
> Hmm...I suspect there is bug in your patch, the extra seek should not
> contribute to 4 times slower

I agree with you :-)

> 
>>  #include <linux/time.h>
>> @@ -478,6 +480,75 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
>>  	return -1;
>>  }
>>
>> +static int ext4_ino_from_ireserve(handle_t *handle, struct inode *dir,
>> +			  int mode, ext4_group_t *group, unsigned long *ino)
>> +{
>> +	struct super_block *sb;
>> +	struct ext4_sb_info *sbi;
>> +	struct ext4_group_desc *gdp = NULL;
>> +	struct buffer_head *gdp_bh = NULL, *bitmap_bh = NULL;
>> +	ext4_group_t ires_group = *group;
>> +	unsigned long ires_ino;
>> +	int i, bit;
>> +
>> +	sb = dir->i_sb;
>> +	sbi = EXT4_SB(sb);
>> +
>> +	/* if the inode number is not for directory,
>> +	 * only try to allocate after directory's inode
>> +	 */
>> +	if (!S_ISDIR(mode)) {
>> +		*ino = dir->i_ino % EXT4_INODES_PER_GROUP(sb);
>> +		return 0;
>> +	}
>> +
>> +	/* reserve inodes for new directory */
>> +	for (i = 0; i < sbi->s_groups_count; i++) {
>> +		gdp = ext4_get_group_desc(sb, ires_group, &gdp_bh);
>> +		if (!gdp)
>> +			goto fail;
>> +		bit = 0;
>> +try_same_group:
>> +		if (bit < EXT4_INODES_PER_GROUP(sb)) {
>> +			brelse(bitmap_bh);
>> +			bitmap_bh = read_inode_bitmap(sb, ires_group);
>> +			if (!bitmap_bh)
>> +				goto fail;
>> +
>> +			BUFFER_TRACE(bitmap_bh, "get_write_access");
>> +			if (ext4_journal_get_write_access(
>> +				handle, bitmap_bh) != 0)
>> +				goto fail;
>> +			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, ires_group),
>> +					bit, bitmap_bh->b_data)) {
>> +				/* we won it */
>> +				BUFFER_TRACE(bitmap_bh,
>> +					"call ext4_journal_dirty_metadata");
>> +				if (ext4_journal_dirty_metadata(handle,
>> +							bitmap_bh) != 0)
>> +					goto fail;
>> +				ires_ino = bit;
>> +				goto find;
>> +			}
>> +			/* we lost it */
>> +			jbd2_journal_release_buffer(handle, bitmap_bh);
>> +			bit += sbi->s_dir_ireserve_nr;
>> +			goto try_same_group;
>> +		}
>> +		if (++ires_group == sbi->s_groups_count)
>> +			ires_group = 0;
>> +	}
>> +	goto fail;
>> +find:
>> +	brelse(bitmap_bh);
>> +	*group = ires_group;
>> +	*ino = ires_ino;
>> +	return 0;
>> +fail:
>> +	brelse(bitmap_bh);
>> +	return -ENOSPC;
>> +}
>> +
>>  /*
>>   * There are two policies for allocating an inode.  If the new inode is
>>   * a directory, then a forward search is made for a block group with both
>> @@ -543,6 +614,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
>>
>>  		ino = 0;
>>
>> +		if (test_opt(sb, DIR_IRESERVE)) {
>> +			err = ext4_ino_from_ireserve(handle, dir,
>> +						     mode, &group, &ino);
>> +			if ((!err) && S_ISDIR(mode))
>> +				goto got;
>> +		}
> 
> 
> So you are calling ext4_ino_from_ireserve() inside a loop iterate all
> block groups? I think this is bug, it should move outside of the loop.
> 

Hmm, sure, putting ext4_ino_from_ireserve() in this loop is redundant, it should be out of this
loop. Neat eyes:-) So this is second bug in my patch.

I will submit V4 patch and basic benchmark number before next internal conf-call. Thanks for your
review, great help to me :-)


>>  repeat_in_this_group:
>>  		ino = ext4_find_next_zero_bit((unsigned long *)
>>  				bitmap_bh->b_data, EXT4_INODES_PER_GROUP(sb), ino);
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index b626339..9b873b7 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -884,6 +884,7 @@ enum {
>>  	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
>>  	Opt_journal_checksum, Opt_journal_async_commit,
>>  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>> +	Opt_dir_ireserve_low, Opt_dir_ireserve_normal, Opt_dir_ireserve_high,
>>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
>>  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
>> @@ -929,6 +930,9 @@ static match_table_t tokens = {
>>  	{Opt_data_journal, "data=journal"},
>>  	{Opt_data_ordered, "data=ordered"},
>>  	{Opt_data_writeback, "data=writeback"},
>> +	{Opt_dir_ireserve_low, "dir_ireserve=low"},
>> +	{Opt_dir_ireserve_normal, "dir_ireserve=normal"},
>> +	{Opt_dir_ireserve_high, "dir_ireserve=high"},
>>  	{Opt_offusrjquota, "usrjquota="},
>>  	{Opt_usrjquota, "usrjquota=%s"},
>>  	{Opt_offgrpjquota, "grpjquota="},
>> @@ -1311,6 +1315,18 @@ clear_qf_name:
>>  				return 0;
>>  			sbi->s_stripe = option;
>>  			break;
>> +		case Opt_dir_ireserve_low:
>> +			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
>> +			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_LOW;
>> +			break;
>> +		case Opt_dir_ireserve_normal:
>> +			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
>> +			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_NORMAL;
>> +			break;
>> +		case Opt_dir_ireserve_high:
>> +			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
>> +			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_HIGH;
>> +			break;
>>  		default:
>>  			printk (KERN_ERR
>>  				"EXT4-fs: Unrecognized mount option \"%s\" "
>> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
>> index bcdb59d..88f5173 100644
>> --- a/include/linux/ext4_fs.h
>> +++ b/include/linux/ext4_fs.h
>> @@ -92,6 +92,13 @@ struct ext4_allocation_request {
>>  #define EXT4_GOOD_OLD_FIRST_INO	11
>>
>>  /*
>> + * Macro-instructions used to reserve inodes for directories
>> + */
>> +#define EXT4_DIR_IRESERVE_LOW		16
>> +#define EXT4_DIR_IRESERVE_NORMAL	64
>> +#define EXT4_DIR_IRESERVE_HIGH		128
>> +
>> +/*
>>   * Maximal count of links to a file
>>   */
>>  #define EXT4_LINK_MAX		65000
>> @@ -502,6 +509,7 @@ do {									       \
>>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
>>  #define EXT4_MOUNT_DELALLOC		0x2000000 /* Delalloc support */
>>  #define EXT4_MOUNT_MBALLOC		0x4000000 /* Buddy allocation support */
>> +#define EXT4_MOUNT_DIR_IRESERVE		0x10000000/* dir inode reservation */
>>  /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
>>  #ifndef _LINUX_EXT2_FS_H
>>  #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
>> diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
>> index 744e746..790b0cf 100644
>> --- a/include/linux/ext4_fs_sb.h
>> +++ b/include/linux/ext4_fs_sb.h
>> @@ -147,6 +147,8 @@ struct ext4_sb_info {
>>
>>  	/* locality groups */
>>  	struct ext4_locality_group *s_locality_groups;
>> +	/* number of inodes we reserve in a directory */
>> +	int s_dir_ireserve_nr;
>>  };
>>  #define EXT4_GROUP_INFO(sb, group)					   \
>>  	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \
>>
>>
> 

-- 
Coly Li
SuSE PRC Labs
