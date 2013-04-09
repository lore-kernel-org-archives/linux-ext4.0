From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: optimize ext4_force_commit
Date: Tue, 9 Apr 2013 16:36:53 +0200
Message-ID: <20130409143653.GG13672@quack.suse.cz>
References: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
 <1364807037-21664-2-git-send-email-dmonakhov@openvz.org>
 <20130401185838.GC22443@thunk.org>
 <CAF5pi0FZ4MUdBMH9A_Wav8V7TX39z1cOtGspJP9k8LN0KFja7g@mail.gmail.com>
 <20130409133123.GE12050@thunk.org>
 <CAF5pi0GhudB=BmBNGPAp4KLvfuAiw_2zo5bzYVWQ3jhthsj3Xw@mail.gmail.com>
 <87wqsbre65.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089Ab3DIOhA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 10:37:00 -0400
Content-Disposition: inline
In-Reply-To: <87wqsbre65.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-04-13 18:06:58, Dmitry Monakhov wrote:
> On Tue, 9 Apr 2013 17:42:33 +0400, Dmitry Monakhov <dmonakhovopenvz@gmail.com> wrote:
> Non-text part: multipart/alternative
> > ---------- Forwarded message ----------
> > From: "Theodore Ts'o" <tytso@mit.edu>
> > Date: Apr 9, 2013 5:31 PM
> > Subject: Re: [PATCH 2/2] ext4: optimize ext4_force_commit
> > To: "Dmitry Monakhov" <dmonakhovopenvz@gmail.com>
> > Cc:
> > 
> > On Mon, Apr 01, 2013 at 11:10:59PM +0400, Dmitry Monakhov wrote:
> > > Yes. I think so too.  Even more jbd2_force_commit_nested already does what
> > > we want because we are not hold transaction. I'll send patch tomorrow
> > 
> > Hi Dmitry,
> > 
> > Did you send an update for this patch?  I can't seem to find it.  I'm
> > wondering if we perhaps got distracted by the big endian patch, and we
> > didn't get back to this commit.
> Ohh It is appeared that it requires more deep analysis.
> For example sync(2) is implicitly broken because ext4_sync_fs() may not
> send a flush barrier. So following case is possible:
> 
> dd if=/dev/zero of=file oflag=direct bs=1M count=1
> sync
> POWER_FAILURE-> result in data lost. Because:
> 
> sys_write()
> -> __generic_file_aio_write
>    ->file_update_time
>     ->update_time
>       -> touch metadata -> ext4_update_inode_fsync_trans
> 
>   <# A lot of journal_start/journal_stop# >
  If we are allocating blocks (as you would in the above example), then
we call ext4_update_inode_fsync_trans() for each allocation. But that's not
really important for your sync(2) example.

>  ->submit_bio  
> 
>  ->dio_complete
> 
> sys_sync()
>  -> flush_inodes (may not start a journal)
>  -> ext4_sync_fs
>     if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
>                 if (wait)
>                         jbd2_log_wait_commit(sbi->s_journal, target);
> 
>    But no one guarantee us that we start any transaction since dio was
>    completed so barrier will not be send. This means we may lose
>    our data on power failure.
  So ext4_sync_file() actually handles this fine - if transaction commit
doesn't send the flush we need, it will send it manually. But you are right
that ext4_sync_fs() needs a similar thing.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
