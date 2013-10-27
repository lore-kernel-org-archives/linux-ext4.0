From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: online resize of ext4 hung (3.2.51 / 1.42.5)
Date: Sun, 27 Oct 2013 02:08:12 -0400
Message-ID: <20131027060812.GB12361@thunk.org>
References: <20131025220632.62b4f9b3@samsa>
 <20131025235745.GA2448@thunk.org>
 <20131026225124.5fcfd7b0@samsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jakob Haufe <sur5r@sur5r.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51234 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab3J0GIS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Oct 2013 02:08:18 -0400
Content-Disposition: inline
In-Reply-To: <20131026225124.5fcfd7b0@samsa>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 26, 2013 at 10:51:24PM +0200, Jakob Haufe wrote:
> On Fri, 25 Oct 2013 19:57:45 -0400
> Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > Can you run "echo t > /proc/sysrq-trigger" and send the output from
> > the console (or from dmesg)?  Or otherwise trigger sysrq-t?  This will
> > show the stacks of all of the processes, which would be useful to
> > figure out what might be happening.
> 
> As the log was most probably too big to pass majordomo, i've put it here:
> 
> http://permalink.sur5r.net/1/linux-3.2.51-resize2fs-1.42.5-hung-sysrq-t.log

(Sorry for the delay in responding, a number of us have been attending
a conference in Edinburgh, and I'm currently on vacation in Dublin.)

>From looking at the sysrq-t which you sent, what looks like is going
on is that resize2fs is stuck in jbd2_journal_lock_updates().  That
function has incremented j_barrier_count, so all new attempts to start
a transaction handle are blocked, which explains the rest of the
processes stuck in start_this_handle().  Meanwhile,
jbd2_journal_lock_updates is waiting for the outstanding transactions
handles that have already been started against the handle to go to
zero --- and for some reason, this never happens.

One thing which I'm trying to figure out is why the resize2fs ioctl
needs to use the whole sequence of:

		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);

anyway.  This flushes out the journal, but it's not obvious to me why
it's necessary --- and removing it would speed a file system resize
significantly.

In any case, I think it should be safe for you to reboot your file
system, and after an fsck -f, I think your file system should be OK.

			    	     	      - Ted

P.S.  To ext4 developers, please note that the kernel involved,
v3.2.52 does _not_ have Jan Kara's reserved handles changes, which
were added in commit 8f7d89f36829.  I at first thought it might have
been related to changes involving how jbd2_journal_lock_updates()
waits for j_reserved_credits to go to zero, but that was a blind
alley.
