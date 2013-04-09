From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: optimize ext4_force_commit
Date: Tue, 09 Apr 2013 18:06:58 +0400
Message-ID: <87wqsbre65.fsf@openvz.org>
References: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org> <1364807037-21664-2-git-send-email-dmonakhov@openvz.org> <20130401185838.GC22443@thunk.org> <CAF5pi0FZ4MUdBMH9A_Wav8V7TX39z1cOtGspJP9k8LN0KFja7g@mail.gmail.com> <20130409133123.GE12050@thunk.org> <CAF5pi0GhudB=BmBNGPAp4KLvfuAiw_2zo5bzYVWQ3jhthsj3Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:38898 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3DIOHE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2013 10:07:04 -0400
Received: by mail-la0-f41.google.com with SMTP id er20so1378795lab.0
        for <linux-ext4@vger.kernel.org>; Tue, 09 Apr 2013 07:07:01 -0700 (PDT)
In-Reply-To: <CAF5pi0GhudB=BmBNGPAp4KLvfuAiw_2zo5bzYVWQ3jhthsj3Xw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Apr 2013 17:42:33 +0400, Dmitry Monakhov <dmonakhovopenvz@gmail.com> wrote:
Non-text part: multipart/alternative
> ---------- Forwarded message ----------
> From: "Theodore Ts'o" <tytso@mit.edu>
> Date: Apr 9, 2013 5:31 PM
> Subject: Re: [PATCH 2/2] ext4: optimize ext4_force_commit
> To: "Dmitry Monakhov" <dmonakhovopenvz@gmail.com>
> Cc:
> 
> On Mon, Apr 01, 2013 at 11:10:59PM +0400, Dmitry Monakhov wrote:
> > Yes. I think so too.  Even more jbd2_force_commit_nested already does what
> > we want because we are not hold transaction. I'll send patch tomorrow
> 
> Hi Dmitry,
> 
> Did you send an update for this patch?  I can't seem to find it.  I'm
> wondering if we perhaps got distracted by the big endian patch, and we
> didn't get back to this commit.
Ohh It is appeared that it requires more deep analysis.
For example sync(2) is implicitly broken because ext4_sync_fs() may not
send a flush barrier. So following case is possible:

dd if=/dev/zero of=file oflag=direct bs=1M count=1
sync
POWER_FAILURE-> result in data lost. Because:

sys_write()
-> __generic_file_aio_write
   ->file_update_time
    ->update_time
      -> touch metadata -> ext4_update_inode_fsync_trans

  <# A lot of journal_start/journal_stop# >
 ->submit_bio  

 ->dio_complete

sys_sync()
 -> flush_inodes (may not start a journal)
 -> ext4_sync_fs
    if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
                if (wait)
                        jbd2_log_wait_commit(sbi->s_journal, target);

   But no one guarantee us that we start any transaction since dio was
   completed so barrier will not be send. This means we may lose
   our data on power failure.
At this moment I try to figure up sane data integrity model for
fsync/syncfs. Hope I'll send you patches at the end of the week.

