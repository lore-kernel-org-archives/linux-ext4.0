From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: remove deprecated oldalloc
Date: Tue, 07 Jun 2011 09:53:01 -0500
Message-ID: <4DEE3B4D.8020403@redhat.com>
References: <1307453714-2741-1-git-send-email-lczerner@redhat.com> <4DEE3AA8.4080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1FGOxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 10:53:04 -0400
In-Reply-To: <4DEE3AA8.4080504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/7/11 9:50 AM, Eric Sandeen wrote:
> On 6/7/11 8:35 AM, Lukas Czerner wrote:
>> For a long time now orlov is the default block allocator in the ext4. It
>> performs better than the old one and no one seems to claim otherwise so
>> we can safely drop it and make oldalloc and orlov mount option
>> deprecated.
>>
>> This is a part of the effort to reduce number of ext4 options hence the
>> test matrix.
>>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Seems like a good idea to me.
> 
> But I'm doing a little digging into why find_group_flex() was there;
> why all that flex_bg-related inode allocation work for a deprecated option?
> 
> commit 772cb7c83ba256a11c7bf99a11bef3858d23767c
> Author: Jose R. Santos <jrs@us.ibm.com>
> Date:   Fri Jul 11 19:27:31 2008 -0400
> 
>     ext4: New inode allocation for FLEX_BG meta-data groups.
>     
>     This patch mostly controls the way inode are allocated in order to
>     make ialloc aware of flex_bg block group grouping.  It achieves this
>     by bypassing the Orlov allocator when block group meta-data are packed
>     toghether through mke2fs. <snip>
> 
> find_group_flex() used to be called by ext4_new_inode() regardless of
> OLDALLOC, (I think) so just want to see for sure what happened to that plan...

Ah, ok:

commit a4912123b688e057084e6557cef8924f7ae5bbde
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Mar 12 12:18:34 2009 -0400

    ext4: New inode/block allocation algorithms for flex_bg filesystems
    
    The find_group_flex() inode allocator is now only used if the
    filesystem is mounted using the "oldalloc" mount option. It is
    replaced with the original Orlov allocator that has been updated for
    flex_bg filesystems <snip>

So:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> -eric
> 
>> ---
>>  Documentation/filesystems/ext4.txt |    8 --
>>  fs/ext4/ext4.h                     |    1 -
>>  fs/ext4/ialloc.c                   |  136 +-----------------------------------
>>  fs/ext4/super.c                    |    8 +-
>>  4 files changed, 7 insertions(+), 146 deletions(-)
>>
>> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
>> index 3ae9bc9..ec469fa 100644
>> --- a/Documentation/filesystems/ext4.txt
>> +++ b/Documentation/filesystems/ext4.txt
>> @@ -201,14 +201,6 @@ inode_readahead_blks=n	This tuning parameter controls the maximum
>>  			table readahead algorithm will pre-read into
>>  			the buffer cache.  The default value is 32 blocks.
>>  
>> -orlov		(*)	This enables the new Orlov block allocator. It is
>> -			enabled by default.
>> -
>> -oldalloc		This disables the Orlov block allocator and enables
>> -			the old block allocator.  Orlov should have better
>> -			performance - we'd like to get some feedback if it's
>> -			the contrary for you.
>> -
>>  user_xattr		Enables Extended User Attributes.  Additionally, you
>>  			need to have extended attribute support enabled in the
>>  			kernel configuration (CONFIG_EXT4_FS_XATTR).  See the
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1921392..7e0b8aa 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -884,7 +884,6 @@ struct ext4_inode_info {
>>  /*
>>   * Mount flags
>>   */
>> -#define EXT4_MOUNT_OLDALLOC		0x00002  /* Don't use the new Orlov allocator */
>>  #define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's group */
>>  #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
>>  #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 21bb2f6..0b5ec23 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -293,118 +293,6 @@ error_return:
>>  	ext4_std_error(sb, fatal);
>>  }
>>  
>> -/*
>> - * There are two policies for allocating an inode.  If the new inode is
>> - * a directory, then a forward search is made for a block group with both
>> - * free space and a low directory-to-inode ratio; if that fails, then of
>> - * the groups with above-average free space, that group with the fewest
>> - * directories already is chosen.
>> - *
>> - * For other inodes, search forward from the parent directory\'s block
>> - * group to find a free inode.
>> - */
>> -static int find_group_dir(struct super_block *sb, struct inode *parent,
>> -				ext4_group_t *best_group)
>> -{
>> -	ext4_group_t ngroups = ext4_get_groups_count(sb);
>> -	unsigned int freei, avefreei;
>> -	struct ext4_group_desc *desc, *best_desc = NULL;
>> -	ext4_group_t group;
>> -	int ret = -1;
>> -
>> -	freei = percpu_counter_read_positive(&EXT4_SB(sb)->s_freeinodes_counter);
>> -	avefreei = freei / ngroups;
>> -
>> -	for (group = 0; group < ngroups; group++) {
>> -		desc = ext4_get_group_desc(sb, group, NULL);
>> -		if (!desc || !ext4_free_inodes_count(sb, desc))
>> -			continue;
>> -		if (ext4_free_inodes_count(sb, desc) < avefreei)
>> -			continue;
>> -		if (!best_desc ||
>> -		    (ext4_free_blks_count(sb, desc) >
>> -		     ext4_free_blks_count(sb, best_desc))) {
>> -			*best_group = group;
>> -			best_desc = desc;
>> -			ret = 0;
>> -		}
>> -	}
>> -	return ret;
>> -}
>> -
>> -#define free_block_ratio 10
>> -
>> -static int find_group_flex(struct super_block *sb, struct inode *parent,
>> -			   ext4_group_t *best_group)
>> -{
>> -	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> -	struct ext4_group_desc *desc;
>> -	struct flex_groups *flex_group = sbi->s_flex_groups;
>> -	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
>> -	ext4_group_t parent_fbg_group = ext4_flex_group(sbi, parent_group);
>> -	ext4_group_t ngroups = ext4_get_groups_count(sb);
>> -	int flex_size = ext4_flex_bg_size(sbi);
>> -	ext4_group_t best_flex = parent_fbg_group;
>> -	int blocks_per_flex = sbi->s_blocks_per_group * flex_size;
>> -	int flexbg_free_blocks;
>> -	int flex_freeb_ratio;
>> -	ext4_group_t n_fbg_groups;
>> -	ext4_group_t i;
>> -
>> -	n_fbg_groups = (ngroups + flex_size - 1) >>
>> -		sbi->s_log_groups_per_flex;
>> -
>> -find_close_to_parent:
>> -	flexbg_free_blocks = atomic_read(&flex_group[best_flex].free_blocks);
>> -	flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
>> -	if (atomic_read(&flex_group[best_flex].free_inodes) &&
>> -	    flex_freeb_ratio > free_block_ratio)
>> -		goto found_flexbg;
>> -
>> -	if (best_flex && best_flex == parent_fbg_group) {
>> -		best_flex--;
>> -		goto find_close_to_parent;
>> -	}
>> -
>> -	for (i = 0; i < n_fbg_groups; i++) {
>> -		if (i == parent_fbg_group || i == parent_fbg_group - 1)
>> -			continue;
>> -
>> -		flexbg_free_blocks = atomic_read(&flex_group[i].free_blocks);
>> -		flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
>> -
>> -		if (flex_freeb_ratio > free_block_ratio &&
>> -		    (atomic_read(&flex_group[i].free_inodes))) {
>> -			best_flex = i;
>> -			goto found_flexbg;
>> -		}
>> -
>> -		if ((atomic_read(&flex_group[best_flex].free_inodes) == 0) ||
>> -		    ((atomic_read(&flex_group[i].free_blocks) >
>> -		      atomic_read(&flex_group[best_flex].free_blocks)) &&
>> -		     atomic_read(&flex_group[i].free_inodes)))
>> -			best_flex = i;
>> -	}
>> -
>> -	if (!atomic_read(&flex_group[best_flex].free_inodes) ||
>> -	    !atomic_read(&flex_group[best_flex].free_blocks))
>> -		return -1;
>> -
>> -found_flexbg:
>> -	for (i = best_flex * flex_size; i < ngroups &&
>> -		     i < (best_flex + 1) * flex_size; i++) {
>> -		desc = ext4_get_group_desc(sb, i, NULL);
>> -		if (ext4_free_inodes_count(sb, desc)) {
>> -			*best_group = i;
>> -			goto out;
>> -		}
>> -	}
>> -
>> -	return -1;
>> -out:
>> -	return 0;
>> -}
>> -
>>  struct orlov_stats {
>>  	__u32 free_inodes;
>>  	__u32 free_blocks;
>> @@ -817,7 +705,6 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
>>  	struct inode *ret;
>>  	ext4_group_t i;
>>  	int free = 0;
>> -	static int once = 1;
>>  	ext4_group_t flex_group;
>>  
>>  	/* Cannot create files in a deleted directory */
>> @@ -843,26 +730,9 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
>>  		goto got_group;
>>  	}
>>  
>> -	if (sbi->s_log_groups_per_flex && test_opt(sb, OLDALLOC)) {
>> -		ret2 = find_group_flex(sb, dir, &group);
>> -		if (ret2 == -1) {
>> -			ret2 = find_group_other(sb, dir, &group, mode);
>> -			if (ret2 == 0 && once) {
>> -				once = 0;
>> -				printk(KERN_NOTICE "ext4: find_group_flex "
>> -				       "failed, fallback succeeded dir %lu\n",
>> -				       dir->i_ino);
>> -			}
>> -		}
>> -		goto got_group;
>> -	}
>> -
>> -	if (S_ISDIR(mode)) {
>> -		if (test_opt(sb, OLDALLOC))
>> -			ret2 = find_group_dir(sb, dir, &group);
>> -		else
>> -			ret2 = find_group_orlov(sb, dir, &group, mode, qstr);
>> -	} else
>> +	if (S_ISDIR(mode))
>> +		ret2 = find_group_orlov(sb, dir, &group, mode, qstr);
>> +	else
>>  		ret2 = find_group_other(sb, dir, &group, mode);
>>  
>>  got_group:
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index cc5c157..e1f8f73 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1031,8 +1031,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>>  		seq_puts(seq, ",nouid32");
>>  	if (test_opt(sb, DEBUG) && !(def_mount_opts & EXT4_DEFM_DEBUG))
>>  		seq_puts(seq, ",debug");
>> -	if (test_opt(sb, OLDALLOC))
>> -		seq_puts(seq, ",oldalloc");
>>  #ifdef CONFIG_EXT4_FS_XATTR
>>  	if (test_opt(sb, XATTR_USER))
>>  		seq_puts(seq, ",user_xattr");
>> @@ -1541,10 +1539,12 @@ static int parse_options(char *options, struct super_block *sb,
>>  			set_opt(sb, DEBUG);
>>  			break;
>>  		case Opt_oldalloc:
>> -			set_opt(sb, OLDALLOC);
>> +			ext4_msg(sb, KERN_WARNING,
>> +				 "Ignoring deprecated oldalloc option");
>>  			break;
>>  		case Opt_orlov:
>> -			clear_opt(sb, OLDALLOC);
>> +			ext4_msg(sb, KERN_WARNING,
>> +				 "Ignoring deprecated orlov option");
>>  			break;
>>  #ifdef CONFIG_EXT4_FS_XATTR
>>  		case Opt_user_xattr:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

