From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4] ext4: reduce lock contention in __ext4_new_inode
Date: Wed, 16 Aug 2017 18:42:11 +0200
Message-ID: <20170816164211.GA31117@quack2.suse.cz>
References: <20170808050517.7160-1-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, wshilong@ddn.com,
        adilger@dilger.ca, sihara@ddn.com, lixi@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46495 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752318AbdHPQmO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Aug 2017 12:42:14 -0400
Content-Disposition: inline
In-Reply-To: <20170808050517.7160-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-08-17 13:05:17, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> While running number of creating file threads concurrently,
> we found heavy lock contention on group spinlock:
> 
> FUNC                           TOTAL_TIME(us)       COUNT        AVG(us)
> ext4_create                    1707443399           1440000      1185.72
> _raw_spin_lock                 1317641501           180899929    7.28
> jbd2__journal_start            287821030            1453950      197.96
> jbd2_journal_get_write_access  33441470             73077185     0.46
> ext4_add_nondir                29435963             1440000      20.44
> ext4_add_entry                 26015166             1440049      18.07
> ext4_dx_add_entry              25729337             1432814      17.96
> ext4_mark_inode_dirty          12302433             5774407      2.13
> 
> most of cpu time blames to _raw_spin_lock, here is some testing
> numbers with/without patch.
> 
> Test environment:
> Server : SuperMicro Sever (2 x E5-2690 v3@2.60GHz, 128GB 2133MHz
>          DDR4 Memory, 8GbFC)
> Storage : 2 x RAID1 (DDN SFA7700X, 4 x Toshiba PX02SMU020 200GB
>           Read Intensive SSD)
> 
> format command:
>         mkfs.ext4 -J size=4096
> 
> test command:
>         mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \
>                 -r -i 1 -v -p 10 -u #first run to load inode
> 
>         mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \
>                 -r -i 5 -v -p 10 -u
> 
> Kernel version: 4.13.0-rc3
> 
> Test  1,440,000 files with 48 directories by 48 processes:
> 
> Without patch:
> 
> File Creation   File removal
> 79,033          289,569 ops/per second
> 81,463          285,359
> 79,875          288,475
> 79,917          284,624
> 79,420          290,91
> 
> with patch:
> File Creation   File removal
> 691,528		296,574 ops/per second
> 691,946		297,106
> 692,030		296,238
> 691,005		299,249
> 692,871		300,664
> 
> Creation performance is improved more than 8X with large
> journal size. The main problem here is we test bitmap
> and do some check and journal operations which could be
> slept, then we test and set with lock hold, this could
> be racy, and make 'inode' steal by other process.
> 
> However, after first try, we could confirm handle has
> been started and inode bitmap journaled too, then
> we could find and set bit with lock hold directly, this
> will mostly gurateee success with second try.
> 
> This patch dosen't change logic if it comes to
> no journal mode, luckily this is not normal
> use cases i believe.
> 
> Tested-by: Shuichi Ihara <sihara@ddn.com>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

The results look great and the code looks correct however I dislike the
somewhat complex codeflow with your hold_lock variable. So how about
cleaning up the code as follows:

Create function like

unsigned long find_inode_bit(struct super_block *sb, ext4_group_t group,
		struct buffer_head *bitmap, unsigned long start_ino)
{
	unsigned long ino;

next:
	ino = ext4_find_next_zero_bit(...);
	if (ino >= EXT4_INODES_PER_GROUP(sb))
		return 0;
	if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
		...
		return 0;
	}
	if ((EXT4_SB(sb)->s_journal == NULL) &&
                    recently_deleted(sb, group, ino)) {
		start_ino = ino + 1;
		if (start_ino < EXT4_INODES_PER_GROUP(sb))
			goto next;
	}
	return ino;
}

Then you can use this function from __ext4_new_inode() when looking for
free ino and also in case test_and_set_bit() fails you could just do:

ext4_lock_group(sb, group);
ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
if (ret2) {
	/* Someone already took the bit. Repeat the search with lock held.*/
	ino = find_inode_bit(sb, group, inode_bitmap_bh, ino);
	if (ino) {
		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
		WARN_ON_ONCE(!ret2);
	}
}
ext4_unlock_group(sb, group);

And that's it, no strange bool variables and conditional locking. And as a
bonus it also works for nojournal mode in the same way.

								Honza

> ---
> v3->v4: codes cleanup and avoid sleep.
> ---
>  fs/ext4/ialloc.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 507bfb3..23380f39 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -761,6 +761,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  	ext4_group_t flex_group;
>  	struct ext4_group_info *grp;
>  	int encrypt = 0;
> +	bool hold_lock;
>  
>  	/* Cannot create files in a deleted directory */
>  	if (!dir || !dir->i_nlink)
> @@ -917,17 +918,40 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  			continue;
>  		}
>  
> +		hold_lock = false;
>  repeat_in_this_group:
> +		/* if @hold_lock is ture, that means, journal
> +		 * is properly setup and inode bitmap buffer has
> +		 * been journaled already, we can directly hold
> +		 * lock and set bit if found, this will mostly
> +		 * gurantee forward progress for each thread.
> +		 */
> +		if (hold_lock)
> +			ext4_lock_group(sb, group);
> +
>  		ino = ext4_find_next_zero_bit((unsigned long *)
>  					      inode_bitmap_bh->b_data,
>  					      EXT4_INODES_PER_GROUP(sb), ino);
> -		if (ino >= EXT4_INODES_PER_GROUP(sb))
> +		if (ino >= EXT4_INODES_PER_GROUP(sb)) {
> +			if (hold_lock)
> +				ext4_unlock_group(sb, group);
>  			goto next_group;
> +		}
>  		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
> +			if (hold_lock)
> +				ext4_unlock_group(sb, group);
>  			ext4_error(sb, "reserved inode found cleared - "
>  				   "inode=%lu", ino + 1);
>  			continue;
>  		}
> +
> +		if (hold_lock) {
> +			ext4_set_bit(ino, inode_bitmap_bh->b_data);
> +			ext4_unlock_group(sb, group);
> +			ino++;
> +			goto got;
> +		}
> +
>  		if ((EXT4_SB(sb)->s_journal == NULL) &&
>  		    recently_deleted(sb, group, ino)) {
>  			ino++;
> @@ -950,6 +974,10 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  			ext4_std_error(sb, err);
>  			goto out;
>  		}
> +
> +		if (EXT4_SB(sb)->s_journal)
> +			hold_lock = true;
> +
>  		ext4_lock_group(sb, group);
>  		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
>  		ext4_unlock_group(sb, group);
> -- 
> 2.9.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
