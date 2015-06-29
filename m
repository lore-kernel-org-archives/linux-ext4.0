From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Mon, 29 Jun 2015 11:04:37 +0200
Message-ID: <20150629090437.GD11013@quack.suse.cz>
References: <20150625034626.GA21682@thunk.org>
 <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
 <20150627040237.GC474@thunk.org>
 <20150627140743.GF474@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150627140743.GF474@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 27-06-15 10:07:43, Ted Tso wrote:
> On Sat, Jun 27, 2015 at 12:02:37AM -0400, Theodore Ts'o wrote:
> > 
> > I would tend to agree.  The weird thing though is that I haven't seen
> > this problem myself, despite running multiple regression tests before
> > I sent the pull request, as well as running it on my laptop and doing
> > kernel compiles with make -j16 and reading e-mail (I'm typing this
> > e-mail on a 4.1 kernel merged with the ext4 patches for this merge
> > window, so I have this commit running in my development laptop, and it
> > hasn't triggered for me).
> 
> Update: I've been able to reproduce the crash using a post merge
> kernel (of course, I had to use CONFIG_SLUB since CONFIG_SLAB is
> busted) a single time.  Unfortunately, I've not been able to reproduce
> it reliably so I can't speak to whether reverting 2143c1965a76 will
> fix things.  But it does seem very likely.

BTW, what did you use to trigger the error for you? The ext4 path where the
assertion triggered for Linus is definitely correct so the assertion
failure was a false positive. Since we don't hold proper locks when doing
the assertion, we likely saw an intermediate state where we raced with
__jbd2_journal_refile_buffer() called from jbd2 thread which was doing

        jh->b_transaction = jh->b_next_transaction;
        jh->b_next_transaction = NULL;

and we saw NULL in b_next_transaction but old content in b_transaction.
Originally I didn't think that's really possible but on a second thought
don't know how I came to that conclusion :-|. Looking at the disassemly of
__jbd2_journal_refile_buffer() I see my compiler compiled the above as:

mov    0x30(%rbx),%rax  b_next_transaction -> rax
movq   $0x0,0x30(%rbx)  NULL -> b_next_transaction
mov    %rax,0x28(%rbx)  rax -> b_transaction

So even the compiler decided to reorder the stores to memory and I'm not
even speaking of what the CPU could have done with the stores or loads
from the assertion.

I will fix the assertion in the same way the second assertion in
jbd2_journal_dirty_metadata() was fixed - take the necessary locks if it
seems the assertion is violated to make sure we don't see false positives.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
