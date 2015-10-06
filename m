From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Tue, 6 Oct 2015 10:01:04 +0100
Message-ID: <CA+55aFyA7YH_cTTBv2vX78Pnv446DxOWxPaO9ud4G3TCrsS8eQ@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
	<CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
	<5612A3F3.2040609@linux.intel.com>
	<CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
	<5612E23B.7070606@linux.intel.com>
	<CA+55aFwkA1EODc0bsrdmob945DYfDW_jE+nmrFKpq2YmBn+W4Q@mail.gmail.com>
	<CA+55aFz9hH26=iQa832J5789Kf1ufYEJPt5L_D1wcDhCycUCFQ@mail.gmail.com>
	<561308BD.5090304@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Peter Anvin <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <561308BD.5090304@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 6, 2015 at 12:33 AM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
>
> Did you mean that as a cleanup, or to fix the regression?

Purely as a cleanup to try to avoid the (already existing) special
case in at least ext4 - and possibly others.

So that patch was meant just for discussion - it's not really fixing
any existing bugs, and I didn't actually keep it live in my tree.

I'm planning on just doing the revert for now, but I'll wait a bit to
see how this thread pans out first.

> Since the page isn't faulted in yet, iov_iter_copy_from_user_atomic()
> had already set copied=0

Not necessarily. For your case that only does one-byte writes, yes.
But in the generic case you may well have a page-crossing source area
in user space, and get a partial success from the user copy. It's that
partial success case (when the rest of the missing data isn't
necessarily already up-to-date) that I'd like to have low-level
filesystems not have to worry about.

           Linus
