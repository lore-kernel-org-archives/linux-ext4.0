From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/19] ext4: Convert to new freezing mechanism
Date: Thu, 8 Mar 2012 10:05:21 +0100
Message-ID: <20120308090521.GA6681@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
 <1330963277-26336-11-git-send-email-jack@suse.cz>
 <1331159533.12984.73.camel@fourier>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2CHJFY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Mar 2012 04:05:24 -0500
Content-Disposition: inline
In-Reply-To: <1331159533.12984.73.camel@fourier>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 07-03-12 14:32:13, Kamal Mostafa wrote:
> Re: the patch set:
>     [PATCH 00/19] Fix filesystem freezing deadlocks
> 
> In my initial smoke testing of this, I find that if I freeze a newly
> created ext4 filesystem immediately after mounting it for the very first
> time, then I get the new SB_FREEZE_COMPLETE warning from
> ext4_journal_start_sb() every 0.4 seconds from ext4lazyinit...
> 
>         # mkfs -t ext4 /dev/sdaX
>         # mount /dev/sdaX /mnt
>         # fsfreeze -f /mnt
> 
>          WARNING:
>         at /home/kamal/src/linux/ubuntu-precise/fs/ext4/super.c:301
>         ext4_journal_start_sb+0x159/0x160()
>         
>          Pid: 3252, comm: ext4lazyinit Tainted: G        W
>         3.2.0-18-generic #28+kamal1+jankara1
>         
>          Call Trace:
>           [<ffffffff8106724f>] warn_slowpath_common+0x7f/0xc0
>           [<ffffffff810672aa>] warn_slowpath_null+0x1a/0x20
>           [<ffffffff812352c9>] ext4_journal_start_sb+0x159/0x160
>           [<ffffffff8121326b>] ? ext4_init_inode_table+0xab/0x370
>           [<ffffffff8121326b>] ext4_init_inode_table+0xab/0x370
>           [<ffffffff81659cb5>] ? schedule_timeout+0x175/0x320
>           [<ffffffff81226905>] ext4_run_li_request+0x85/0xe0
>           [<ffffffff812269fc>] ext4_lazyinit_thread+0x9c/0x1c0
>           [<ffffffff81226960>] ? ext4_run_li_request+0xe0/0xe0
>           [<ffffffff8108a39c>] kthread+0x8c/0xa0
>           [<ffffffff81665e34>] kernel_thread_helper+0x4/0x10
>           [<ffffffff8108a310>] ? flush_kthread_worker+0xa0/0xa0
>           [<ffffffff81665e30>] ? gs_change+0x13/0x13
  Ah, good point. Thanks for spotting this. I forgot about the lazyinit
thread. Attached patch fixes the problem (I've folded it into ext4
conversion patch in my series).

								Honza
> 
>  -Kamal
> 
> 
> On Mon, 2012-03-05 at 17:01 +0100, Jan Kara wrote:
> > We remove most of frozen checks since upper layer takes care
> > of blocking all writes. We only have to handle protection in
> > ext4_page_mkwrite() in a special way because we cannot use
> > generic block_page_mkwrite().
> > 
> > CC: linux-ext4@vger.kernel.org
> > CC: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/inode.c |    7 ++-----
> >  fs/ext4/super.c |   29 +++++------------------------
> >  2 files changed, 7 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index feaa82f..c65baf9 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4593,11 +4593,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	get_block_t *get_block;
> >  	int retries = 0;
> >  
> > -	/*
> > -	 * This check is racy but catches the common case. We rely on
> > -	 * __block_page_mkwrite() to do a reliable check.
> > -	 */
> > -	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> > +	sb_start_pagefault(inode->i_sb);
> >  	/* Delalloc case is easy... */
> >  	if (test_opt(inode->i_sb, DELALLOC) &&
> >  	    !ext4_should_journal_data(inode) &&
> > @@ -4665,5 +4661,6 @@ retry_alloc:
> >  out_ret:
> >  	ret = block_page_mkwrite_return(ret);
> >  out:
> > +	sb_end_pagefault(inode->i_sb);
> >  	return ret;
> >  }
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 502c61f..0f1024a 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -289,33 +289,17 @@ static void ext4_put_nojournal(handle_t *handle)
> >   * journal_end calls result in the superblock being marked dirty, so
> >   * that sync() will call the filesystem's write_super callback if
> >   * appropriate.
> > - *
> > - * To avoid j_barrier hold in userspace when a user calls freeze(),
> > - * ext4 prevents a new handle from being started by s_frozen, which
> > - * is in an upper layer.
> >   */
> >  handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> >  {
> >  	journal_t *journal;
> > -	handle_t  *handle;
> >  
> >  	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
> >  	if (sb->s_flags & MS_RDONLY)
> >  		return ERR_PTR(-EROFS);
> >  
> > +	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
> >  	journal = EXT4_SB(sb)->s_journal;
> > -	handle = ext4_journal_current_handle();
> > -
> > -	/*
> > -	 * If a handle has been started, it should be allowed to
> > -	 * finish, otherwise deadlock could happen between freeze
> > -	 * and others(e.g. truncate) due to the restart of the
> > -	 * journal handle if the filesystem is forzen and active
> > -	 * handles are not stopped.
> > -	 */
> > -	if (!handle)
> > -		vfs_check_frozen(sb, SB_FREEZE_TRANS);
> > -
> >  	if (!journal)
> >  		return ext4_get_nojournal();
> >  	/*
> > @@ -4280,10 +4264,8 @@ int ext4_force_commit(struct super_block *sb)
> >  		return 0;
> >  
> >  	journal = EXT4_SB(sb)->s_journal;
> > -	if (journal) {
> > -		vfs_check_frozen(sb, SB_FREEZE_TRANS);
> > +	if (journal)
> >  		ret = ext4_journal_force_commit(journal);
> > -	}
> >  
> >  	return ret;
> >  }
> > @@ -4315,9 +4297,8 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
> >   * gives us a chance to flush the journal completely and mark the fs clean.
> >   *
> >   * Note that only this function cannot bring a filesystem to be in a clean
> > - * state independently, because ext4 prevents a new handle from being started
> > - * by @sb->s_frozen, which stays in an upper layer.  It thus needs help from
> > - * the upper layer.
> > + * state independently. It relies on upper layer to stop all data & metadata
> > + * modifications.
> >   */
> >  static int ext4_freeze(struct super_block *sb)
> >  {
> > @@ -4344,7 +4325,7 @@ static int ext4_freeze(struct super_block *sb)
> >  	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> >  	error = ext4_commit_super(sb, 1);
> >  out:
> > -	/* we rely on s_frozen to stop further updates */
> > +	/* we rely on upper layer to stop further updates */
> >  	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> >  	return error;
> >  }
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--fUYQa+Pmc3FrFX/N
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4_lazyinit_freeze_fix.diff"

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0f1024a..039b1e0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2756,6 +2756,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
 
+	sb_start_write(sb);
 	for (group = elr->lr_next_group; group < ngroups; group++) {
 		gdp = ext4_get_group_desc(sb, group, NULL);
 		if (!gdp) {
@@ -2782,6 +2783,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;
 	}
+	sb_end_write(sb);
 
 	return ret;
 }

--fUYQa+Pmc3FrFX/N--
