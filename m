From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race between truncate and
 __ext4_journalled_writepage()
Date: Tue, 16 Jun 2015 14:57:17 +0200
Message-ID: <20150616125717.GB7038@quack.suse.cz>
References: <20150615011433.GA15793@thunk.org>
 <1434331430-23125-1-git-send-email-tytso@mit.edu>
 <20150615123352.GD4368@quack.suse.cz>
 <20150615130611.GJ15793@thunk.org>
 <AA05E959-86D4-42F4-8589-0C244FFB7BBB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	enwlinux@gmail.com, stable@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AA05E959-86D4-42F4-8589-0C244FFB7BBB@dilger.ca>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 15-06-15 11:59:59, Andreas Dilger wrote:
> On Jun 15, 2015, at 7:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> > On Mon, Jun 15, 2015 at 02:33:52PM +0200, Jan Kara wrote:
> >>  Yeah, that's nasty. Thanks for debugging this! However I think your fix
> >> reintroduces the original deadlock issues. do_journal_get_write_access()
> >> can end up blocking waiting for jbd2 thread to finish a commit while jbd2
> >> thread may be blocked waiting for the page to be unlocked.
> >> 
> >> After some thought I don't think the deadlock is real since
> >> do_journal_get_write_access() will currently only block if a buffer is
> >> under writeout to the journal and at that point we don't wait for page
> >> locks anymore. Also ext4_write_begin() does the same in data=journal mode
> >> and we haven't observed deadlocks so far. But still things look really
> >> fragile here.
> > 
> > The reason why there are no deadlocks is the writeback in the commit
> > thread happens when the inode gets written back --- but that only
> > happens for data=ordered inodes, not data=journalled mode.  I was a
> > little worried about what might happen when after the 'j' chattr
> > attribute gets set on an inode, and the inode was still on the ordered
> > flush list.
> > 
> > Hmm... I think we could also maybe fix this by having
> > ext4_change_inode_journal_flag() force a journal commit before setting
> > the JOURNAL_DATA flag.  If we did that, we could just avoid dropping
> > the page_lock in __ext4_journalled_writepage() altogether.
> 
> That is already being done:
> 
> int ext4_change_inode_journal_flag(struct inode *inode, int val)
> {
>         :
>         :
> 
>         jbd2_journal_lock_updates(journal);
> 
>         :
>         :
> 
> 
> /**
>  * void jbd2_journal_lock_updates () - establish a transaction barrier.
>  * @journal:  Journal to establish a barrier on.
>  *
>  * This locks out any further updates from being started, and blocks
>  * until all existing updates have completed, returning only once the
>  * journal is in a quiescent state with no updates running.
>  *
>  * The journal lock should not be held on entry.
>  */
  Well, jbd2_journal_lock_updates() makes sure there are no handles for the
running transaction but it doesn't ensure current transaction is committed
(which is what Ted wanted because he wanted to avoid inode being both
ordered and journaled in the same transaction).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
