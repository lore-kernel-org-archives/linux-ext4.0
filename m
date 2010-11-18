From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Fri, 19 Nov 2010 00:58:37 +0100
Message-ID: <20101118235837.GE5004@quack.suse.cz>
References: <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
 <1290104468-sup-7908@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@kernel.dk>, Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290104468-sup-7908@think>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 18-11-10 13:33:54, Chris Mason wrote:
> > Can we just delete writeback_inodes_sb_nr_if_idle() and
> > writeback_inodes_sb_if_idle()?  The changelog for 17bd55d037a02 is
> > pretty handwavy - do we know that deleting these things would make a
> > jot of difference?
> > 
> > And why _do_ we need to hold s_umount during the bdi_queue_work()
> > handover?  Would simply bumping s_count suffice?
> > 
> 
> We don't need to keep the super in ram, we need to keep the FS mounted
> so that writepage and friends continue to do useful things.  s_count
> isn't enough for that...but when the bdi stuff is passed an SB from
> something that has the SB explicitly pinned, we should be able to safely
> skip the locking.
> 
> Since these functions are only used in that context it makes good sense
> to try_lock them or drop the lock completely.
> 
> I think the only reason we need the lock:
> 
> void writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr)
> {
> ...
>         WARN_ON(!rwsem_is_locked(&sb->s_umount));
  The above is the only reason why we need the lock in the call from
->write_begin(). Yes. But:

> We're not going to go from rw to ro with dirty pages unless something
> horrible has gone wrong (eios all around in the FS), so I'm not sure why
> we need the lock at all?
  One of the nasty cases is for example: Writeback thread decides inode
needs writeout, so the thread gets inode reference. Then someone calls
umount and gets EBUSY because writeback thread is working. Kind of
unexpected... So generally we *do* need a serialization of writeback thread
and umount / remount. Just in that particular case where we call the
function from ->write_begin(), s_umount is overkill...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
