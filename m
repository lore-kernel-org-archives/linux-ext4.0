From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 13:33:54 -0500
Message-ID: <1290104468-sup-7908@think>
References: <20101116110058.GA4298@amd> <20101116130146.GG4757@quack.suse.cz> <4CE35A6D.2040906@redhat.com> <20101117043845.GA3586@amd> <4CE362B0.6040607@redhat.com> <20101117061057.GA3989@amd> <20101118030613.GQ3290@thunk.org> <20101117192900.da859ac7.akpm@linux-foundation.org> <20101118060000.GA3509@amd> <20101117222834.2bb36ee1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Nick Piggin <npiggin@kernel.dk>, "Ted Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20101117222834.2bb36ee1.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Andrew Morton's message of 2010-11-18 01:28:34 -0500:
> I'm not sure that s_umount versus i_mutex has come up before.
> 
> Logically I'd expect i_mutex to nest inside s_umount.  Because s_umount
> is a per-superblock thing, and i_mutex is a per-file thing, and files
> live under superblocks.  Nesting s_umount outside i_mutex creates
> complex deadlock graphs between the various i_mutexes, I think.
> 
> Someone tell me if btrfs has the same bug, via its call to
> writeback_inodes_sb_nr_if_idle()?

Btrfs is using the call differently, we kick off delalloc at transaction
start time when many fewer locks are held.

Since transaction start can happen with the inode mutex held, we'll end
up taking the s_unmount with the inode mutex held too.

But, we never take the inode lock internally in the writeback paths.

> 
> I don't see why these functions need s_umount at all, if they're called
> from within ->write_begin against an inode on that superblock.  If the
> superblock can get itself disappeared while we're running ->write_begin
> on it, we have problems, no?
> 
> In which case I'd suggest just removing the down_read(s_umount) and
> specifying that the caller must pin the superblock via some means.
> 
> Only we can't do that because we need to hold s_umount until the
> bdi_queue_work() worker has done its work.
> 
> The fact that a call to ->write_begin can randomly return with s_umount
> held, to be randomly released at some random time in the future is a
> bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
> thing.
> 
> It'd be better if we pinned these superblocks via refcounting, not via
> holding s_umount but even then, having ->write_begin randomly bump sb
> refcounts for random periods of time is still pretty ugly.
> 
> What a pickle.
> 
> Can we just delete writeback_inodes_sb_nr_if_idle() and
> writeback_inodes_sb_if_idle()?  The changelog for 17bd55d037a02 is
> pretty handwavy - do we know that deleting these things would make a
> jot of difference?
> 
> And why _do_ we need to hold s_umount during the bdi_queue_work()
> handover?  Would simply bumping s_count suffice?
> 

We don't need to keep the super in ram, we need to keep the FS mounted
so that writepage and friends continue to do useful things.  s_count
isn't enough for that...but when the bdi stuff is passed an SB from
something that has the SB explicitly pinned, we should be able to safely
skip the locking.

Since these functions are only used in that context it makes good sense
to try_lock them or drop the lock completely.

I think the only reason we need the lock:

void writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr)
{
...
        WARN_ON(!rwsem_is_locked(&sb->s_umount));

We're not going to go from rw to ro with dirty pages unless something
horrible has gone wrong (eios all around in the FS), so I'm not sure why
we need the lock at all?

-chris




