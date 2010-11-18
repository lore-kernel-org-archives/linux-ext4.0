From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 12:22:38 -0800
Message-ID: <20101118122238.b2fc379a.akpm@linux-foundation.org>
References: <20101116110058.GA4298@amd>
	<20101116130146.GG4757@quack.suse.cz>
	<4CE35A6D.2040906@redhat.com>
	<20101117043845.GA3586@amd>
	<4CE362B0.6040607@redhat.com>
	<20101117061057.GA3989@amd>
	<20101118030613.GQ3290@thunk.org>
	<20101117192900.da859ac7.akpm@linux-foundation.org>
	<20101118060000.GA3509@amd>
	<20101117222834.2bb36ee1.akpm@linux-foundation.org>
	<4CE53E56.4090501@redhat.com>
	<20101118091053.c275e1f2.akpm@linux-foundation.org>
	<4CE56AA5.4030705@redhat.com>
	<20101118103638.99c1e8bc.akpm@linux-foundation.org>
	<1290105840-sup-3874@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
	"Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1290105840-sup-3874@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 18 Nov 2010 13:51:15 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> > If those functions "fix" a testcase then it was by sheer luck, and the
> > fs's ENOSPC handling is still busted.
> > 
> > For a start writeback_inodes_sb_if_idle() is a no-op if the device
> > isn't idle!  Secondly, if the device _was_ idle,
> > writeback_inodes_sb_if_idle() uses a work handoff to another thread,
> > which means that the work might not get executed for another six weeks.
> > 
> > So no, your ENOSPC handling is still busted and I'll be doing you a
> > favour when I send that parport patch.
> 
> Btrfs uses it with this cool looping construct. It's an innovative
> combination of while, 1, schedule_timeout(),  and if all goes well, break.

If the calling code can do that then it doesn't need to pass the work
off to another thread at all.  Just sychronously call
writeback_inodes_sb(), then bye-bye goes writeback_inodes_sb_if_idle(),
to great sighs of relief.

And again: as btrfs is effectively making a synchronous call to
writeback_inodes_sb() via schedule(), then surely it does not need to
take s_umount to protect its own darn superblock!!

