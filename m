From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Set file system to read-only by I/O error
 threshold
Date: Sat, 18 Jun 2011 10:38:37 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106181015180.4602@dhcp-27-109.brq.redhat.com>
References: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: stufever@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab1FRIi6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jun 2011 04:38:58 -0400
In-Reply-To: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Jun 2011, stufever@gmail.com wrote:

> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
> Some version of Hadoop uses access(2) to check whether the data chunk harddisk is online, if access(2) returns error, hadoop marks the disk which it called access(2) as offline. This method works for Ext3/4 with journal, because when jbd/jbd2 encounters I/O error, the file system will be set as read-only. For Ext4 no-journal mode, there is no jdb2 to set the file system as read-only when I/O error happens, the access(2) from Hadoop is not able to reliably detect hard disk offline condition.

Hi,

so you're saying that you encounter I/O error on access(2) only with
Ext3/4 with journal. So given that you're checking the error count in
ext4_handle_error() which is called when I/O error happens I fail to see
how this helps your case. Am I missing something ?

Also I do not understand how this is helpful at all ? Usually when we
hit I/O error we want to have predictable behavior set by the error=
mount option, but with this patch we have absolutely unpredictable
behaviour on errors, which is bad! Also we can end up with read-only
file system even when errors=continue has been set.

Could you please provide a real use case for having error threshold ?
Because to me it does not seem like a very good idea.

Couple of comment bellow.

> 
> This patch tries to fix the above problem from kernel side. People can set I/O error threshold, in 2 conditions Ext4 file system without journal will be set as read-only:
> 1) inside the sampling interval, I/O errors come more then pre-set threshold happens
> 2) I/O errors always happen in continous sampling intervals, the sum of errors exceeds pre-set threshold
> 
> Then the application can find the file system is set as read-only, and call its own failure tolerance procedures.
> 
> There are 2 interface exported to user space via sysfs:
> /sys/fs/ext4/sd[?]/eio_threshold --- I/O error threshold to set file system as read-only
> /sys/fs/ext4/sd[?]/eio_interval  --- sampling interval in second
> 
> If echo 0 into file eio_threshold, I/O error threshold will be infinite, no file system read-only will be triggered.
> 
> Cc: Ted Tso <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Coly Li <bosong.ly@taobao.com>
> Reviewed-by: Liu Yuan <tailai.ly@taobao.com>
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
> ---
>  fs/ext4/ext4.h  |    5 +++++
>  fs/ext4/super.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1921392..8f445a8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1108,6 +1108,11 @@ struct ext4_sb_info {
>  	int s_first_ino;
>  	unsigned int s_inode_readahead_blks;
>  	unsigned int s_inode_goal;
> +	spinlock_t s_eio_lock;

You can use atomic_t and get rid of the spinlock maybe ?

> +	unsigned int s_eio_threshold;
> +	unsigned int s_eio_interval;
> +	unsigned int s_eio_counter;
> +	unsigned long s_eio_last_jiffies;
>  	spinlock_t s_next_gen_lock;
>  	u32 s_next_generation;
>  	u32 s_hash_seed[4];
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cc5c157..f85ddcd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -384,6 +384,23 @@ static void save_error_info(struct super_block *sb, const char *func,
>  	ext4_commit_super(sb, 1);
>  }
>  
> +static inline void check_error_number(struct super_block *sb)

The name for this function should rather be inc_sb_error_count().

> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +
> +	if (time_after(sbi->s_eio_last_jiffies + sbi->s_eio_interval * HZ, jiffies)) {
> +		sbi->s_eio_counter++;
> +	} else {
> +		sbi->s_eio_counter = 1;
> +	}
> +
> +	sbi->s_eio_last_jiffies = jiffies;
> +	ext4_msg(sb, KERN_CRIT, "count total: %d", sbi->s_eio_counter);
> +	
> +	if (sbi->s_eio_counter > sbi->s_eio_threshold) { 

I am not sure, but given that it it a "threshold" should not we trigger
it when we hit the threshold and not threshold+1 ?

> +		ext4_abort(sb, "Two many io error, abort it");

Could you use better error message ? This does not say nothing about why
it happened. Something about IO errors count reached the threshold ?

> +	}
> +}
>  
>  /* Deal with the reporting of failure conditions on a filesystem such as
>   * inconsistencies detected or read IO failures.
> @@ -402,9 +419,17 @@ static void save_error_info(struct super_block *sb, const char *func,
>  
>  static void ext4_handle_error(struct super_block *sb)
>  {
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +
>  	if (sb->s_flags & MS_RDONLY)
>  		return;
>  
> +	if (sbi->s_eio_threshold && !sbi->s_journal) {
> +		spin_lock(&sbi->s_eio_lock);
> +		check_error_number(sb);
> +		spin_unlock(&sbi->s_eio_lock);

Maybe you can use atomic operations and get rid of the spin_lock.

> +	}
> +
>  	if (!test_opt(sb, ERRORS_CONT)) {
>  		journal_t *journal = EXT4_SB(sb)->s_journal;
>  
> @@ -2471,6 +2496,22 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
>  	return count;
>  }
>  
> +static ssize_t eio_interval_store(struct ext4_attr *a,
> +					  struct ext4_sb_info *sbi,
> +					  const char *buf, size_t count)
> +{
> +	unsigned long t;
> +
> +	if (parse_strtoul(buf, 0xffffffff, &t))
> +		return -EINVAL;
> +
> +	if (t <= 0)
> +		return -EINVAL;
> +
> +	sbi->s_eio_interval = t;
> +	return count;
> +}
> +
>  static ssize_t sbi_ui_show(struct ext4_attr *a,
>  			   struct ext4_sb_info *sbi, char *buf)
>  {
> @@ -2524,6 +2565,9 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
>  EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
>  EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
>  EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
> +EXT4_RW_ATTR_SBI_UI(eio_threshold, s_eio_threshold);
> +EXT4_ATTR_OFFSET(eio_interval, 0644, sbi_ui_show,
> +		 eio_interval_store, s_eio_interval);
>  
>  static struct attribute *ext4_attrs[] = {
>  	ATTR_LIST(delayed_allocation_blocks),
> @@ -2540,6 +2584,8 @@ static struct attribute *ext4_attrs[] = {
>  	ATTR_LIST(mb_stream_req),
>  	ATTR_LIST(mb_group_prealloc),
>  	ATTR_LIST(max_writeback_mb_bump),
> +	ATTR_LIST(eio_threshold),
> +	ATTR_LIST(eio_interval),
>  	NULL,
>  };
>  
> @@ -3464,6 +3510,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	sbi->s_stripe = ext4_get_stripe_size(sbi);
>  	sbi->s_max_writeback_mb_bump = 128;
>  
> +	spin_lock_init(&sbi->s_eio_lock);
> +	sbi->s_eio_threshold = 10;
> +	sbi->s_eio_interval = 5;
> +	sbi->s_eio_counter = 0;
> +
>  	/*
>  	 * set up enough so that it can read an inode
>  	 */
> 

-- 
