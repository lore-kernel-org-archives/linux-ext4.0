From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 14 Feb 2011 14:58:45 -0500
Message-ID: <20110214195845.GD4255@thunk.org>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
 <20110204131739.GC4104@quack.suse.cz>
 <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
 <20110214172504.GC3018@quack.suse.cz>
 <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58233 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1BNT7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Feb 2011 14:59:00 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-lsf-pc, -linux-fsdevel

On Mon, Feb 14, 2011 at 09:00:58PM +0200, Amir Goldstein wrote:
> Yes, of course. Upgraders won't be the ones using snapshots.
> My intension was to state that those people installing new systems to test
> snapshots would be functioning as testers for "ext3 mode", because:
> 1. when no snapshots exists it boils down to testing "ext3 mode".
> 2. it is unlikely that snapshots will mask "ext3 mode" bugs.
> 
> So my claim is that "ext3 mode" would benefit from a transition
> period in which snapshots and (extens,delalloc) are mutually
> exclusive in ext4.

Here are the requirements that I think are critical before we do this:

1) We need to solve the testing matrix problem.  Right now "ext3 mode"
in ext4 doesn't get enough testing as it is.  Part of the solution is
(a) deciding on the modes that need testing, and (b) writing some
shell scripts so that xfstests can be automatically run in all of the
right modes.  And then it will be having some number of people
(hopefully not just me) running said tests and reporting failures.

2) The code has to integrate in a fairly seemless and easy way.
mballoc.c is an example of code that still needs a lot of cleanup.
Coly Li has submitted some cleanups, which is great.  But I suspect a
lot more is needed.

One thing that comes to mind about your question with the
e4b->alloc_semp causing problems.  If the only reason why we need it
is to protect against multiple attempts to initialize different block
groups that share the same buddy bitmap, can we solve the problem by
ditching e4b->alloc_semp entirely, and simply using lock_page() on the
buddy bitmap page to protect it?

That's an example of the radical code cleanup and simplification that
parts of the ext4 codebase could really use.  That isn't the
snapshot's code fault, and if we didn't really need to touch parts the
code in question, it's probably stable enough as it is.
Unfortunately, if you need to make changes, there's enough code debt
in some of the files that you need to change that any changes _has_ to
make things better, and not worse.  So for example, checking to see if
the blocksize==page_size, and then skipping the down_read(alloc_smp)
call is an example of layering _more_ complexity and code hackery, and
not less.

Note what I did with patches in the ext4_da_writepages() codepath ---
about 100 lines of code removed in just 7 patches, and I expect
performance will get better as a result of the cleanup.  And then
compare that to how that code looked in say, 2.6.27.  We need to do
similar amounts of cleanup in other parts of ext4 --- and mballoc.c is
by no means the worse.  But building on top of code which has a fair
amount of code debt, is not a receipe for long-term success; it's like
building a castle on quicksand, or in a swamp (insert obligatory Monty
Python reference here).

						- Ted
