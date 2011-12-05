From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [RFC PATCH] ext4: auto batched discard support at kernel thread
Date: Mon, 5 Dec 2011 19:12:03 +0900
Message-ID: <CAH9JG2X4dTiWgvksgSvS5qAJviJ3Ndgqwp+pv6tMqc9J95_5Xw@mail.gmail.com>
References: <20111202060424.GA26155@july>
	<alpine.LFD.2.00.1112051051250.4911@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, tm@tao.ma, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45995 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1LEKME (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 05:12:04 -0500
In-Reply-To: <alpine.LFD.2.00.1112051051250.4911@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/5/11, Lukas Czerner <lczerner@redhat.com> wrote:
> On Fri, 2 Dec 2011, Kyungmin Park wrote:
>
>> Hi,
>>
>> It's proof of concept to run kernel thread for batched discard.
>>
>> Now it can run fitrim at user level. but it's not clear which deamon run
>> this activity.
>> In case of android platform, the launcher is candidate
>> but user can change the default launcher then it can't use the fitrim any
>> more.
>
> I do not thing this logic belongs to the kernel. You would be perfectly
> fine just with cron lob (or launcher) running fitrim regularly and it is
> so much easier than pushing this functionality to the kernel side. Not
> talking about the fact that cron (and others) gives you *much* more
> flexibility in running fitrim on regular basis and I do not think you
> want to reimplement cron within the kernel.
>
> Also it seems to me that the problem you're trying to solve should be
> rather solved on the Android (launcher) side.
>
> I am against this functionality, sorry.
No problem, It will be support at user space as original design. e.g.,
system settings

Thank you for all comments.

BR,
Kyungmin Park
>
> Thanks!
> -Lukas
>
>>
>> To address this issue. no dependency with platform. run the fitrim at
>> kernel.
>> Basically don't bother the user it runs at 2 clock. Please note that if
>> it's clean state, it doesn't take much time.
>>
>> Please give opinions and comments.
>>
>> Thank you,
>> Kyungmin Park
>> ---
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 5b0e26a..2cad9b3 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -942,6 +942,7 @@ struct ext4_inode_info {
>>
>>  #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
>>  						      specified delalloc */
>> +#define EXT4_MOUNT2_AUTO_DISCARD	0x00000002 /* Auto batched discard */
>>
>>  #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
>>  						~EXT4_MOUNT_##opt
>> @@ -1249,6 +1250,10 @@ struct ext4_sb_info {
>>
>>  	/* record the last minlen when FITRIM is called. */
>>  	atomic_t s_last_trim_minblks;
>> +
>> +	/* timer for periodic auto batched discard */
>> +	struct timer_list s_auto_discard;
>> +	struct task_struct *s_auto_discard_thread;
>>  };
>>
>>  static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 3858767..a2e9920 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -818,6 +818,10 @@ static void ext4_put_super(struct super_block *sb)
>>  			ext4_abort(sb, "Couldn't clean up the journal");
>>  	}
>>
>> +	if (test_opt2(sb, AUTO_DISCARD)) {
>> +		kthread_stop(sbi->s_auto_discard_thread);
>> +		del_timer(&sbi->s_auto_discard);
>> +	}
>>  	del_timer(&sbi->s_err_report);
>>  	ext4_release_system_zone(sb);
>>  	ext4_mb_release(sb);
>> @@ -1144,6 +1148,9 @@ static int ext4_show_options(struct seq_file *seq,
>> struct vfsmount *vfs)
>>  	if (test_opt(sb, DISCARD) && !(def_mount_opts & EXT4_DEFM_DISCARD))
>>  		seq_puts(seq, ",discard");
>>
>> +	if (test_opt2(sb, AUTO_DISCARD))
>> +		seq_puts(seq, ",auto_batched_discard");
>> +
>>  	if (test_opt(sb, NOLOAD))
>>  		seq_puts(seq, ",norecovery");
>>
>> @@ -1333,7 +1340,7 @@ enum {
>>  	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
>>  	Opt_inode_readahead_blks, Opt_journal_ioprio,
>>  	Opt_dioread_nolock, Opt_dioread_lock,
>> -	Opt_discard, Opt_nodiscard,
>> +	Opt_discard, Opt_nodiscard, Opt_auto_discard,
>>  	Opt_init_inode_table, Opt_noinit_inode_table,
>>  };
>>
>> @@ -1407,6 +1414,7 @@ static const match_table_t tokens = {
>>  	{Opt_dioread_lock, "dioread_lock"},
>>  	{Opt_discard, "discard"},
>>  	{Opt_nodiscard, "nodiscard"},
>> +	{Opt_auto_discard, "auto_batched_discard"},
>>  	{Opt_init_inode_table, "init_itable=%u"},
>>  	{Opt_init_inode_table, "init_itable"},
>>  	{Opt_noinit_inode_table, "noinit_itable"},
>> @@ -1886,6 +1894,9 @@ set_qf_format:
>>  		case Opt_nodiscard:
>>  			clear_opt(sb, DISCARD);
>>  			break;
>> +		case Opt_auto_discard:
>> +			set_opt2(sb, AUTO_DISCARD);
>> +			break;
>>  		case Opt_dioread_nolock:
>>  			set_opt(sb, DIOREAD_NOLOCK);
>>  			break;
>> @@ -2763,6 +2774,71 @@ static void print_daily_error_info(unsigned long
>> arg)
>>  	mod_timer(&sbi->s_err_report, jiffies + 24*60*60*HZ);  /* Once a day */
>>  }
>>
>> +/*
>> + * This function is called once a day to make a trim the device
>> + */
>> +static int ext4_auto_batched_discard_thread(void *data)
>> +{
>> +	struct super_block *sb = data;
>> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> +	struct fstrim_range range;
>> +	struct timeval now;
>> +	struct tm tm;
>> +	long next;
>> +	int ret;
>> +
>> +	set_freezable();
>> +
>> +	for (;;) {
>> +		if (kthread_should_stop())
>> +			break;
>> +
>> +		if (try_to_freeze())
>> +			continue;
>> +
>> +		range.start = 0;
>> +		range.len = ~(__u64)0;
>> +		range.minlen = SZ_1M;
>> +
>> +		ret = ext4_trim_fs(sb, &range);
>> +		if (ret < 0)
>> +			ext4_msg(sb, KERN_NOTICE, "error count: %u", ret);
>> +		else
>> +			ext4_msg(sb, KERN_NOTICE, "trimmed size %llu",
>> +					range.len);
>> +
>> +		do_gettimeofday(&now);
>> +		time_to_tm((time_t) now.tv_sec, 0, &tm);
>> +
>> +		/* Run the every day at 2 clock */
>> +		/* XXX need to consider the timezone? */
>> +		next = 2 - tm.tm_hour;
>> +		if (next <= 0)
>> +			next += 24;
>> +		next *= 60*60*HZ;
>> +
>> +		/* Re-arm the timer for next trim */
>> +		mod_timer(&sbi->s_auto_discard, jiffies + next);
>> +
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule();
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void ext4_auto_batched_discard(unsigned long arg)
>> +{
>> +	struct super_block *sb = (struct super_block *) arg;
>> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> +
>> +	/*
>> +	 * The ext4_trim_fs can't run at timer context
>> +	 * So use the created kthread.
>> +	 */
>> +	wake_up_process(sbi->s_auto_discard_thread);
>> +}
>> +
>>  /* Find next suitable group and run ext4_init_inode_table */
>>  static int ext4_run_li_request(struct ext4_li_request *elr)
>>  {
>> @@ -3576,6 +3652,21 @@ static int ext4_fill_super(struct super_block *sb,
>> void *data, int silent)
>>  	sbi->s_err_report.function = print_daily_error_info;
>>  	sbi->s_err_report.data = (unsigned long) sb;
>>
>> +	if (test_opt2(sb, AUTO_DISCARD)) {
>> +		init_timer(&sbi->s_auto_discard);
>> +		sbi->s_auto_discard.function = ext4_auto_batched_discard;
>> +		sbi->s_auto_discard.data = (unsigned long) sb;
>> +		sbi->s_auto_discard_thread =
>> +			kthread_create(ext4_auto_batched_discard_thread, sb,
>> +				"ext4-batched-discard");
>> +		if (IS_ERR(sbi->s_auto_discard_thread)) {
>> +			err = PTR_ERR(sbi->s_auto_discard_thread);
>> +			goto failed_mount2;
>> +		}
>> +		/* One hour is enough to know the time */
>> +		mod_timer(&sbi->s_auto_discard, jiffies + 1*60*60*HZ);
>> +	}
>> +
>>  	err = percpu_counter_init(&sbi->s_freeclusters_counter,
>>  			ext4_count_free_clusters(sb));
>>  	if (!err) {
>> @@ -3848,6 +3939,10 @@ failed_mount_wq:
>>  		sbi->s_journal = NULL;
>>  	}
>>  failed_mount3:
>> +	if (test_opt2(sb, AUTO_DISCARD)) {
>> +		kthread_stop(sbi->s_auto_discard_thread);
>> +		del_timer(&sbi->s_auto_discard);
>> +	}
>>  	del_timer(&sbi->s_err_report);
>>  	if (sbi->s_flex_groups)
>>  		ext4_kvfree(sbi->s_flex_groups);
>> @@ -4546,6 +4641,22 @@ static int ext4_remount(struct super_block *sb, int
>> *flags, char *data)
>>  	if (sbi->s_journal == NULL)
>>  		ext4_commit_super(sb, 1);
>>
>> +	if (test_opt2(sb, AUTO_DISCARD) && !sbi->s_auto_discard_thread) {
>> +		init_timer(&sbi->s_auto_discard);
>> +		sbi->s_auto_discard.function = ext4_auto_batched_discard;
>> +		sbi->s_auto_discard.data = (unsigned long) sb;
>> +		sbi->s_auto_discard_thread =
>> +			kthread_create(ext4_auto_batched_discard_thread, sb,
>> +				"ext4-batched-discard");
>> +		if (IS_ERR(sbi->s_auto_discard_thread)) {
>> +			err = PTR_ERR(sbi->s_auto_discard_thread);
>> +			goto restore_opts;
>> +		}
>> +
>> +		/* One hour is enough to know the time */
>> +		mod_timer(&sbi->s_auto_discard, jiffies + 1*60*60*HZ);
>> +	}
>> +
>>  #ifdef CONFIG_QUOTA
>>  	/* Release old quota file names */
>>  	for (i = 0; i < MAXQUOTAS; i++)
>>
>
> --
>
