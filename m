From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix race between truncate and
 __ext4_journalled_writepage()
Date: Mon, 15 Jun 2015 09:06:11 -0400
Message-ID: <20150615130611.GJ15793@thunk.org>
References: <20150615011433.GA15793@thunk.org>
 <1434331430-23125-1-git-send-email-tytso@mit.edu>
 <20150615123352.GD4368@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	enwlinux@gmail.com, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150615123352.GD4368@quack.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 15, 2015 at 02:33:52PM +0200, Jan Kara wrote:
>   Yeah, that's nasty. Thanks for debugging this! However I think your fix
> reintroduces the original deadlock issues. do_journal_get_write_access()
> can end up blocking waiting for jbd2 thread to finish a commit while jbd2
> thread may be blocked waiting for the page to be unlocked.
> 
> After some thought I don't think the deadlock is real since
> do_journal_get_write_access() will currently only block if a buffer is
> under writeout to the journal and at that point we don't wait for page
> locks anymore. Also ext4_write_begin() does the same in data=journal mode
> and we haven't observed deadlocks so far. But still things look really
> fragile here.

The reason why there are no deadlocks is the writeback in the commit
thread happens when the inode gets written back --- but that only
happens for data=ordered inodes, not data=journalled mode.  I was a
little worried about what might happen when after the 'j' chattr
attribute gets set on an inode, and the inode was still on the ordered
flush list.

Hmm... I think we could also maybe fix this by having
ext4_change_inode_journal_flag() force a journal commit before setting
the JOURNAL_DATA flag.  If we did that, we could just avoid dropping
the page_lock in __ext4_journalled_writepage() altogether.

What do you think?

						- Ted
