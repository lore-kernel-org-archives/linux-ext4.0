From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 22:28:34 -0800
Message-ID: <20101117222834.2bb36ee1.akpm@linux-foundation.org>
References: <20101116110058.GA4298@amd>
	<20101116130146.GG4757@quack.suse.cz>
	<4CE35A6D.2040906@redhat.com>
	<20101117043845.GA3586@amd>
	<4CE362B0.6040607@redhat.com>
	<20101117061057.GA3989@amd>
	<20101118030613.GQ3290@thunk.org>
	<20101117192900.da859ac7.akpm@linux-foundation.org>
	<20101118060000.GA3509@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101118060000.GA3509@amd>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 18 Nov 2010 17:00:00 +1100 Nick Piggin <npiggin@kernel.dk> wrote:

> On Wed, Nov 17, 2010 at 07:29:00PM -0800, Andrew Morton wrote:
> > On Wed, 17 Nov 2010 22:06:13 -0500 "Ted Ts'o" <tytso@mit.edu> wrote:
> > 
> > > On Wed, Nov 17, 2010 at 05:10:57PM +1100, Nick Piggin wrote:
> > > > On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
> > > > > On 11/16/10 10:38 PM, Nick Piggin wrote:
> > > > > >> as for the locking problems ... sorry about that!
> > > > > > 
> > > > > > That's no problem. So is that an ack? :)
> > > > > > 
> > > > > 
> > > > > I'd like to test it with the original case it was supposed to solve; will
> > > > > do that tomorrow.
> > > > 
> > > > OK, but it shouldn't make much difference, unless there is a lot of
> > > > strange activity happening on the sb (like mount / umount / remount /
> > > > freeze / etc).
> > > 
> > > This makes sense to me as well.
> > > 
> > > Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> > > 
> > > So how do we want to send this patch to Linus?  It's a writeback
> > > change, so through some mm tree?
> > 
> > It's in my todo pile.  Even though the patch sucks, but not as much as
> > its changelog does.  Am not particularly happy merging an alleged
> > bugfix where the bug is, and I quote, "I saw a lock order warning on
> > ext4 trigger".  I mean, wtf?  How is anyone supposed to review the code
> > based on that??  Or to understand it a year from now?
> 
> Sorry bout the confusion, it was supposed to be "i_mutex", and then it
> would have been a bit more obvious.
> 
> 
> > When I get to it I'll troll this email thread and might be able to
> > kludge together a description which might be able to fool people into
> > thinking it makes sense.
> 
> "Lock order reversal between s_umount and i_mutex".
> 
> i_mutex nests inside s_umount in some writeback paths (it was the end
> io handler to convert unwritten extents IIRC). But hmm, wouldn't that
> be a bug? We aren't allowed to take i_mutex inside writeback, are we?

I'm not sure that s_umount versus i_mutex has come up before.

Logically I'd expect i_mutex to nest inside s_umount.  Because s_umount
is a per-superblock thing, and i_mutex is a per-file thing, and files
live under superblocks.  Nesting s_umount outside i_mutex creates
complex deadlock graphs between the various i_mutexes, I think.

Someone tell me if btrfs has the same bug, via its call to
writeback_inodes_sb_nr_if_idle()?

I don't see why these functions need s_umount at all, if they're called
from within ->write_begin against an inode on that superblock.  If the
superblock can get itself disappeared while we're running ->write_begin
on it, we have problems, no?

In which case I'd suggest just removing the down_read(s_umount) and
specifying that the caller must pin the superblock via some means.

Only we can't do that because we need to hold s_umount until the
bdi_queue_work() worker has done its work.

The fact that a call to ->write_begin can randomly return with s_umount
held, to be randomly released at some random time in the future is a
bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
thing.

It'd be better if we pinned these superblocks via refcounting, not via
holding s_umount but even then, having ->write_begin randomly bump sb
refcounts for random periods of time is still pretty ugly.

What a pickle.

Can we just delete writeback_inodes_sb_nr_if_idle() and
writeback_inodes_sb_if_idle()?  The changelog for 17bd55d037a02 is
pretty handwavy - do we know that deleting these things would make a
jot of difference?

And why _do_ we need to hold s_umount during the bdi_queue_work()
handover?  Would simply bumping s_count suffice?

