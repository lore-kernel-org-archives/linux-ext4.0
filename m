Return-Path: <SRS0=Op7R=MQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56420 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbeJDTXg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Oct 2018 15:23:36 -0400
Date: Thu, 4 Oct 2018 14:30:28 +0200
From: Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: Fix use after free in jbd2_log_do_checkpoint()
Message-ID: <20181004123028.GC28384@quack2.suse.cz>
References: <20181004104640.28326-1-jack@suse.cz>
 <20181004115012.s5isxzw4zt4g26y3@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004115012.s5isxzw4zt4g26y3@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-10-18 13:50:12, Lukas Czerner wrote:
> On Thu, Oct 04, 2018 at 12:46:40PM +0200, Jan Kara wrote:
> > The code cleaning transaction's lists of checkpoint buffers has a bug
> > where it increases bh refcount only after releasing
> > journal->j_list_lock. Thus the following race is possible:
> > 
> > CPU0					CPU1
> > jbd2_log_do_checkpoint()
> > 					jbd2_journal_try_to_free_buffers()
> > 					  __journal_try_to_free_buffer(bh)
> >   ...
> >   while (transaction->t_checkpoint_io_list)
> >   ...
> >     if (buffer_locked(bh)) {
> > 
> > <-- IO completes now, buffer gets unlocked -->
> > 
> >       spin_unlock(&journal->j_list_lock);
> > 					    spin_lock(&journal->j_list_lock);
> > 					    __jbd2_journal_remove_checkpoint(jh);
> > 					    spin_unlock(&journal->j_list_lock);
> > 					  try_to_free_buffers(page);
> >       get_bh(bh) <-- accesses freed bh
> > 
> > Fix the problem by grabbing bh reference before unlocking
> > journal->j_list_lock.
> 
> Hi Jan,
> 
> nice catch. The patch looks good, you can add
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> Btw, do you by any chance have a reproducer for this ?

No, syzbot hit it but the race window is really small so I don't think you
can create reasonably reliable reproducer...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
