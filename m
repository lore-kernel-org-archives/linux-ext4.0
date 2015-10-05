From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Mon, 5 Oct 2015 09:03:00 -0700
Message-ID: <56129F34.5070203@linux.intel.com>
References: <20151005152236.GA8140@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005152236.GA8140@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/05/2015 08:22 AM, Theodore Ts'o wrote:
...
> I've bisected it down to commit 998ef75ddb: "fs: do not prefault
> sys_write() user buffer pages".  I've confirmed that 4.3-rc2 fails as
> detailed below, but with 998ef75ddb reverted, the problem goes away.
...
> Before commit 998ef75ddb, if we need to prefault in the page, we do so
> before we attempt the copy.  After this commit, we attempt the copy
> and if it fails because pagefaults have been turned off, we call
> write_end(), the unlock the page, prefault in the pages, and then
> retry the commit.

That's nasty.  Thanks for the bug report!

I'll go see if I can reproduce this.

> What I think is going on is that when we do attempt the copy, we end
> up marking the page dirty before we notice that we need to page fault
> in the page, which ends up triggering the warning that jbd2
> buffer_head that is supposed to be journaled has been marked dirty
> without calling ext4_handle_dirty_metadata() --- which is handled by
> ext4_journalled_write_end(), but which is now happening out of order
> given this commit.
> 
> Is it possible that we can change iov_iter_copy_from_user_atomic(), to
> check for the error case before it marks the page dirty?  Or can we
> create a light-weight function which checks to see if the page needs
> to be faulted in which is lighter weight than
> iov_iter_fault_in_readable?

Maybe I'm not following the macro magic, but I don't see where
iov_iter_copy_from_user_atomic() is setting 'page' dirty.  It'll set the
dirty bit in the PTEs of course, but I don't see it touching 'page'
except to kmap() it.

I do see some ->write_end() implementations doing set_page_dirty(), though.

Could we have just been confused and dirtied a page under ->write_end()
when we had copied=0 and it wasn't _really_ dirtied?
