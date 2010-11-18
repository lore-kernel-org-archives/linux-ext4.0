From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 15:36:58 -0500
Message-ID: <1290112001-sup-2818@think>
References: <20101116110058.GA4298@amd> <20101116130146.GG4757@quack.suse.cz> <4CE35A6D.2040906@redhat.com> <20101117043845.GA3586@amd> <4CE362B0.6040607@redhat.com> <20101117061057.GA3989@amd> <20101118030613.GQ3290@thunk.org> <20101117192900.da859ac7.akpm@linux-foundation.org> <20101118060000.GA3509@amd> <20101117222834.2bb36ee1.akpm@linux-foundation.org> <4CE53E56.4090501@redhat.com> <20101118091053.c275e1f2.akpm@linux-foundation.org> <4CE56AA5.4030705@redhat.com> <20101118103638.99c1e8bc.akpm@linux-foundation.org> <1290105840-sup-3874@think> <20101118122238.b2fc379a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Eric Sandeen <sandeen@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
	"Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20101118122238.b2fc379a.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Andrew Morton's message of 2010-11-18 15:22:38 -0500:
> On Thu, 18 Nov 2010 13:51:15 -0500
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > > If those functions "fix" a testcase then it was by sheer luck, and the
> > > fs's ENOSPC handling is still busted.
> > > 
> > > For a start writeback_inodes_sb_if_idle() is a no-op if the device
> > > isn't idle!  Secondly, if the device _was_ idle,
> > > writeback_inodes_sb_if_idle() uses a work handoff to another thread,
> > > which means that the work might not get executed for another six weeks.
> > > 
> > > So no, your ENOSPC handling is still busted and I'll be doing you a
> > > favour when I send that parport patch.
> > 
> > Btrfs uses it with this cool looping construct. It's an innovative
> > combination of while, 1, schedule_timeout(),  and if all goes well, break.
> 
> If the calling code can do that then it doesn't need to pass the work
> off to another thread at all.  Just sychronously call
> writeback_inodes_sb(), then bye-bye goes writeback_inodes_sb_if_idle(),
> to great sighs of relief.

I think if_idle() is a different discussion than the lock.

writeback_inodes_sb will not actually writeback inodes.  It calls
bdi_queue_task, which puts a work request into the list of things the
bdi flusher thread is already doing, and then it waits for that work to
finish.

So, if the bdi flusher thread is already doing work on this bdi, it will
finish that work (at which point our ENOSPC problems may be solved) and
then it will do the work we've added.

The btrfs enospc code is calling this while we start transactions, so it
might happen once per process calling write().  So if you have 50 procs,
we don't want 50 work requests pigging our bdi work queue.  We just want
to let the flusher do its thing and wait for it to make progress.

schedule_timeout isn't a very pretty way to wait for that progress, but
we haven't had a pretty way to wait for IO...ever (don't say
congestion_wait, it really just broke down to schedule_timeout()).

Without the if_idle variant, we'll end up doing 50 calls to
writeback_inodes_sb, one after the other, even if the 1st call was
enough.

> 
> And again: as btrfs is effectively making a synchronous call to
> writeback_inodes_sb() via schedule(), then surely it does not need to
> take s_umount to protect its own darn superblock!!
> 

Definitely agree here.  I'd love to get rid of the s_umount lock.
Outside of the WARN_ON in __writeback_inodes_sb, I don't think we need
it.

Christoph added the s_umount to protect against mount -o remount,ro, but
I think we can deal with that via an extra check while actually walking
the inodes/pages?

-chris
