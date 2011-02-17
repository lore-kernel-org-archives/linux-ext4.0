From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Thu, 17 Feb 2011 11:41:26 +0100
Message-ID: <20110217104126.GC4947@quack.suse.cz>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20110215160630.GH17313@quack.suse.cz>
 <20110215170352.GE4255@thunk.org>
 <20110215172954.GK17313@quack.suse.cz>
 <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
 <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <169849F1-1830-4771-9D38-6A39C8B46C90@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: toshi.okajima@jp.fujitsu.com, Jan Kara <jack@suse.cz>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <169849F1-1830-4771-9D38-6A39C8B46C90@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 16-02-11 22:13:53, Andreas Dilger wrote:
> On 2011-02-16, at 20:50, Toshiyuki Okajima wrote:
> > (2011/02/16 23:56), Jan Kara wrote:
> >> 
> >>> I got a reproducer from Mizuma-san yesterday, and then I executed it on the kernel without a fixed patch. After an hour, I confirmed that this deadlock happened.
> >>> 
> >>> However, on the kernel with a fixed patch, this deadlock doesn't still happen
> >>> after 12 hours passed.
> >>> 
> >>> The patch for linux-2.6.38-rc4 is as follows:
> >>> ---
> >>>  fs/fs-writeback.c |    2 +-
> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>> 
> >>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >>> index 59c6e49..1c9a05e 100644
> >>> --- a/fs/fs-writeback.c
> >>> +++ b/fs/fs-writeback.c
> >>> @@ -456,7 +456,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
> >>>         spin_unlock(&sb_lock);
> >>> 
> >>>         if (down_read_trylock(&sb->s_umount)) {
> >>> -               if (sb->s_root)
> >>> +               if (sb->s_frozen == SB_UNFROZEN && sb->s_root)
> >>>                         return true;
> >>>                 up_read(&sb->s_umount);
> 
> This seems like a very low-risk fix.
> 
> >>   So this is something along the lines I thought but it actually won't work
> >> for example if sync(1) is run while the filesystem is frozen (that takes
> >> s_umount semaphore in a different place). And generally, I'm not convinced
> >> there are not other places that try to do IO while holding s_umount
> >> semaphore...
> > 
> > OK. I understand.
> > 
> > This code only fixes the case for the following path:
> > writeback_inodes_wb
> > -> ext4_da_writepages
> >   -> ext4_journal_start_sb
> >      -> vfs_check_frozen
> > But, the code doesn't fix the other cases.
> > 
> > We must modify the local filesystem part in order to fix all cases...?
> 
> It seems worthwhile to implement the low-risk fix that covers the common
> case, and if/when someone hits the rare 3-process case and/or submits a
> patch for it then that one will be fixed also.
  Yes, the fix is simple enough that I won't oppose it getting in as a
band aid and if we add this band aid to fs/sync.c:sync_one_sb(), it would
even be a reasonably reliable band aid. But that doesn't change the fact
that the locking is simply broken ;).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
