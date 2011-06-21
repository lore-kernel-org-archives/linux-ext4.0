From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Set file system to read-only by I/O error
 threshold
Date: Tue, 21 Jun 2011 11:41:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106211138520.6947@dhcp-27-109.brq.redhat.com>
References: <1308572768-11606-1-git-send-email-wangshaoyan.pt@taobao.com> <4DFF5C93.4000704@redhat.com> <alpine.LFD.2.00.1106211111170.3618@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, stufever@gmail.com,
	linux-ext4@vger.kernel.org,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1FUJmB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 05:42:01 -0400
In-Reply-To: <alpine.LFD.2.00.1106211111170.3618@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 21 Jun 2011, Lukas Czerner wrote:

> On Mon, 20 Jun 2011, Eric Sandeen wrote:
> 
> > On 6/20/11 7:26 AM, stufever@gmail.com wrote:
> > > From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> > > 
> > > changes from v1 -> v2 :
> > > When counter is greater than threshold, don't call ext4_abort(), but check the mount errors_* option.
> > > 
> > > Some version of Hadoop uses access(2) to check whether the data chunk
> > > harddisk is online, if access(2) returns "Read-only file system"
> > > error, hadoop marks the disk which it called access(2) to as offline.
> > 
> > Ugh, that already sounds ext3-specific.  "Some versions of Hadoop" - which
> > versions?  All?  Custom?  Old?  Upstream?
> > 
> > > This method works for Ext3/4 with journal, because when jbd/jbd2
> > > encounters I/O error, the file system will be set as read-only. For
> > > Ext4 no-journal mode, there is no jdb2 to set the file system as
> > > read-only when I/O error happens, the access(2) from Hadoop is not
> > 
> > But there are other paths to ext4_handle_error ... your changes don't
> > seem specific to whether or not journaling is active?
> > 
> > > able to reliably detect hard disk offline condition.
> > 
> > > This patch tries to fix the above problem from kernel side. 
> > 
> > I don't really don't like this very much.
> 
> Hi Wang,
> 
> as I already said to you, I do not like this either and I agree with
> Eric. You still did not explained how this change helps your case
> without journal, since ext4_handle_error() is callen when IO error is
> encountered and it is not journal specific at all.
> 
> But, I am trying to understand the case you are trying to solve. Is it
> that you have bunch of data sources and access(2) helps you to determine
> whether specific data source is accessible, e.g. writable ? Well if this
> is the case then maybe you would have to change the method to not only
> check if the device is writable, but also if the disk is still alive.
> But generally you'll hit the IO error once you try to sync write to the
> disk, is then already too late ?

Also it appears to me, that you counting on the fact that the drive
might disappear and then reappear in short time (it that why you have
the threashold?). If this it the case, then I think that detecting this
in the moment when it happens is much better approach. I agree that lots
of the application would not handle it correctly, but you can always try
to detect IO error with systemtap on the fly.

> 
> Why not just detect whether the filesystem is mounted as read write with
> access(2) and ignore the case when disk is not alive and then detect this
> and mark the data source as offline once you really hit the IO error ? Or
> it is not sufficient ?
> 
> Also I do not think that this kind of heuristic you are adding into ext4
> belongs to kernel, you should rather solve this in user-space.
> 
> Thanks!
> -Lukas
> 
> > 
> > We already have:
> > 
> > errors=remount-ro
> > errors=continue
> > errors=panic
> > data_err=ignore
> > data_err=abort
> > 
> > Now you propose yet another error handling behavior for the nonstandard
> > no-journal operation mode, with still more tunables and complexity...
> > 
> > Well, or maybe it's only a change to existing behavior...
> > 
> > From a quick read, I think that all your patch really does is change existing
> > ext4_handle_error() behavior so that it only triggers after a certain error rate
> > threshold, right?  And we don't necessarily get there only for I/O errors, in
> > fact I think many (most?) callchains which end here come from metadata corruption
> > detection.
> > 
> > So for that case (metadata corruption) a threshold makes no sense to me;
> > either the fs is corrupt, or it's not.  In the case of a corrupted directory,
> > whether your code fires basically depends on how often (or how rapidly) an
> > application tries to look up a file in a corrupted dir, for example.
> > That doesn't make sense to me.  Your patch simply makes the filesystem
> > more tolerant of corruption, as far as I can tell, and I don't see the point
> > in that.  Am I missing something?
> > 
> > Thanks,
> > -Eric
> > 
> > 
> > > 1.Mount file system with errors=remount-ro
> > > 	mount -t -o errors=remount-ro /dev/sd[?] some_dir 
> > > 2.The counter reach the threshold:
> > > 	1) inside the sampling interval, I/O errors come more than pre-set threshold happens
> > > 	2) I/O errors always happen in continous sampling intervals, the sum of errors exceeds pre-set threshold
> > > 
> > > Then the application can find the file system is set as read-only, and call its own failure tolerance procedures.
> > > 
> > > There are 2 interface exported to user space via sysfs:
> > > /sys/fs/ext4/sd[?]/eio_threshold --- I/O error threshold to check mount errors options
> > > /sys/fs/ext4/sd[?]/eio_interval  --- sampling interval in second
> > > 
> > > If default value of eio_threshold is 0, everything happens as before.
> > > 
> > > Cc: Ted Tso <tytso@mit.edu>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Lukas Czerner <lczerner@redhat.com>
> > > Reviewed-by: Coly Li <bosong.ly@taobao.com>
> > > Reviewed-by: Liu Yuan <tailai.ly@taobao.com>
> > > Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> > > ---
> > >  fs/ext4/ext4.h  |    7 +++++++
> > >  fs/ext4/super.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 58 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 1921392..b08348e 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -1214,6 +1214,13 @@ struct ext4_sb_info {
> > >  
> > >  	/* Kernel thread for multiple mount protection */
> > >  	struct task_struct *s_mmp_tsk;
> > > +
> > > +	/* IO error count */
> > > +	spinlock_t s_eio_lock;
> > > +	unsigned int s_eio_threshold;
> > > +	unsigned int s_eio_interval;
> > > +	unsigned int s_eio_counter;
> > > +	unsigned long s_eio_last_jiffies;
> > >  };
> > >  
> > >  static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index cc5c157..1b3fc81 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -384,6 +384,19 @@ static void save_error_info(struct super_block *sb, const char *func,
> > >  	ext4_commit_super(sb, 1);
> > >  }
> > >  
> > > +static inline void inc_sb_error_count(struct super_block *sb)
> > > +{
> > > +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > > +
> > > +	if (time_after(sbi->s_eio_last_jiffies + sbi->s_eio_interval * HZ, jiffies)) {
> > > +		sbi->s_eio_counter++;
> > > +	} else {
> > > +		sbi->s_eio_counter = 1;
> > > +	}
> > > +
> > > +	sbi->s_eio_last_jiffies = jiffies;
> > > +	ext4_msg(sb, KERN_CRIT, "IO error count total: %d", sbi->s_eio_counter);
> > > +}
> > >  
> > >  /* Deal with the reporting of failure conditions on a filesystem such as
> > >   * inconsistencies detected or read IO failures.
> > > @@ -402,9 +415,21 @@ static void save_error_info(struct super_block *sb, const char *func,
> > >  
> > >  static void ext4_handle_error(struct super_block *sb)
> > >  {
> > > +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > > +
> > >  	if (sb->s_flags & MS_RDONLY)
> > >  		return;
> > >  
> > > +	spin_lock(&sbi->s_eio_lock);
> > > +	inc_sb_error_count(sb);
> > > +	spin_unlock(&sbi->s_eio_lock);
> > > +
> > > +	/* When the counter is greater than threshold(default 0), 
> > > +	 * like usual, we check the ERRORS_*. Otherwise, we just return.
> > > +	 */
> > > +	if (sbi->s_eio_counter <= sbi->s_eio_threshold)
> > > +		return;
> > > +
> > >  	if (!test_opt(sb, ERRORS_CONT)) {
> > >  		journal_t *journal = EXT4_SB(sb)->s_journal;
> > >  
> > > @@ -2471,6 +2496,22 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
> > >  	return count;
> > >  }
> > >  
> > > +static ssize_t eio_interval_store(struct ext4_attr *a,
> > > +					  struct ext4_sb_info *sbi,
> > > +					  const char *buf, size_t count)
> > > +{
> > > +	unsigned long t;
> > > +
> > > +	if (parse_strtoul(buf, 0xffffffff, &t))
> > > +		return -EINVAL;
> > > +
> > > +	if (t <= 0)
> > > +		return -EINVAL;
> > > +
> > > +	sbi->s_eio_interval = t;
> > > +	return count;
> > > +}
> > > +
> > >  static ssize_t sbi_ui_show(struct ext4_attr *a,
> > >  			   struct ext4_sb_info *sbi, char *buf)
> > >  {
> > > @@ -2524,6 +2565,9 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
> > >  EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
> > >  EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
> > >  EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
> > > +EXT4_RW_ATTR_SBI_UI(eio_threshold, s_eio_threshold);
> > > +EXT4_ATTR_OFFSET(eio_interval, 0644, sbi_ui_show,
> > > +		 eio_interval_store, s_eio_interval);
> > >  
> > >  static struct attribute *ext4_attrs[] = {
> > >  	ATTR_LIST(delayed_allocation_blocks),
> > > @@ -2540,6 +2584,8 @@ static struct attribute *ext4_attrs[] = {
> > >  	ATTR_LIST(mb_stream_req),
> > >  	ATTR_LIST(mb_group_prealloc),
> > >  	ATTR_LIST(max_writeback_mb_bump),
> > > +	ATTR_LIST(eio_threshold),
> > > +	ATTR_LIST(eio_interval),
> > >  	NULL,
> > >  };
> > >  
> > > @@ -3464,6 +3510,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> > >  	sbi->s_stripe = ext4_get_stripe_size(sbi);
> > >  	sbi->s_max_writeback_mb_bump = 128;
> > >  
> > > +	spin_lock_init(&sbi->s_eio_lock);
> > > +	sbi->s_eio_threshold = 0;
> > > +	sbi->s_eio_interval = 5;
> > > +	sbi->s_eio_counter = 0;
> > > +
> > >  	/*
> > >  	 * set up enough so that it can read an inode
> > >  	 */
> > 
> > 
> 
> 

-- 
