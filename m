From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race between truncate and
 __ext4_journalled_writepage()
Date: Mon, 15 Jun 2015 19:03:25 +0200
Message-ID: <20150615170325.GA2381@quack.suse.cz>
References: <20150615011433.GA15793@thunk.org>
 <1434331430-23125-1-git-send-email-tytso@mit.edu>
 <20150615123352.GD4368@quack.suse.cz>
 <20150615130611.GJ15793@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	enwlinux@gmail.com, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150615130611.GJ15793@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 15-06-15 09:06:11, Ted Tso wrote:
> On Mon, Jun 15, 2015 at 02:33:52PM +0200, Jan Kara wrote:
> >   Yeah, that's nasty. Thanks for debugging this! However I think your fix
> > reintroduces the original deadlock issues. do_journal_get_write_access()
> > can end up blocking waiting for jbd2 thread to finish a commit while jbd2
> > thread may be blocked waiting for the page to be unlocked.
> > 
> > After some thought I don't think the deadlock is real since
> > do_journal_get_write_access() will currently only block if a buffer is
> > under writeout to the journal and at that point we don't wait for page
> > locks anymore. Also ext4_write_begin() does the same in data=journal mode
> > and we haven't observed deadlocks so far. But still things look really
> > fragile here.
> 
> The reason why there are no deadlocks is the writeback in the commit
> thread happens when the inode gets written back --- but that only
> happens for data=ordered inodes, not data=journalled mode.  I was a
> little worried about what might happen when after the 'j' chattr
> attribute gets set on an inode, and the inode was still on the ordered
> flush list.
> 
> Hmm... I think we could also maybe fix this by having
> ext4_change_inode_journal_flag() force a journal commit before setting
> the JOURNAL_DATA flag.  If we did that, we could just avoid dropping
> the page_lock in __ext4_journalled_writepage() altogether.
> 
> What do you think?
  I think that fully switching lock ordering for data=journal mode back to
page lock -> transaction start (which is what you effectively do when you
never drop page lock in ->writepage) is rather error prone. We'd have to be
careful to avoid lock inversion also for places like ->write_begin,
->releasepage, ->invalidatepage etc. For example ext4_write_begin() will
currently call lock_page() with transaction started which could deadlock
against journalled writepage you suggest. So effectively we'd have to
completely separate aops for data=journal mode. Doable but I'm not sure
it's worth it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
