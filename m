From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Mon, 5 Oct 2015 16:58:15 +0100
Message-ID: <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005152236.GA8140@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 5, 2015 at 4:22 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> What I think is going on is that when we do attempt the copy, we end
> up marking the page dirty before we notice that we need to page fault
> in the page, which ends up triggering the warning that jbd2
> buffer_head that is supposed to be journaled has been marked dirty
> without calling ext4_handle_dirty_metadata() --- which is handled by
> ext4_journalled_write_end(), but which is now happening out of order
> given this commit.

Hmm. I suspect that we'll just need to revert that commit for now.

It does smell like jbd2 might be a bit too fragile here, and you might
be able to trigger the same issue by having some random race condition
where the user unmaps the memory in another thread in between the
iov_iter_fault_in_readable() and the actual
iov_iter_copy_from_user_atomic() call later. So I think that this
commit may not be buggy per se, as much as just exposing a problem in
jbd2, but I don't think that is something we can really fix at this
point in the release schedule.

Dave, comments?

> Is it possible that we can change iov_iter_copy_from_user_atomic(), to
> check for the error case before it marks the page dirty?

iov_iter_copy_from_user_atomic() doesn't mark anything dirty, it just
does the copy afaik. The dirtying is up to the write_begin/write_end
logic.

>  Or can we
> create a light-weight function which checks to see if the page needs
> to be faulted in which is lighter weight than
> iov_iter_fault_in_readable?

I'm not actually sure why Dave finds that function to be expensive
as-is. It should be a very cheap thing to do if it's already mapped,
and if the area isn't mapped it does need to be faulted in later
anyway, so it's not like you're really doing any extra work.

Dave, mind sharing the micro-benchmark or perhaps even just a kernel
profile of it? How is that "iov_iter_fault_in_readable()" so
noticeable? It really shouldn't be a big deal.

               Linus
