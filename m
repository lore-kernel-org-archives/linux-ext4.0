From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Wed, 7 Oct 2015 11:43:03 -0400
Message-ID: <20151007154303.GC24678@thunk.org>
References: <20151005152236.GA8140@thunk.org>
 <5612BBB3.7010201@intel.com>
 <20151007033448.GB24678@thunk.org>
 <CA+55aFycvHK2z_0QZ34wEJf5fBMxWDaeOs85cFSmpKnNONDxLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Hansen <dave.hansen@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFycvHK2z_0QZ34wEJf5fBMxWDaeOs85cFSmpKnNONDxLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 07, 2015 at 08:32:16AM +0100, Linus Torvalds wrote:
> And none of *those* requirements change just because "copied" would be
> zero. If you avoid zeroing the buffers and marking them dirty, nothing
> will ever initialize them on disk, andn if the prefault then later
> fails during retry, no later write will happen either. So now
> eventually later, a read() can see stale data from disk.

Shoot.  You're right, we could end up allowing a stale data to be
exposed.  If we knew the caller of write_end() was guaranteed to
retry, we could skip the jbd2_journal_stop() call and keep the handle
open, which would prevent the transaction from closing.  But if the
write gets abandoned, then the transaction would never close, and
things would grind to a halt.

> I do think this is an ext4 bug, and you'll need to do something *like*
> that patch. Maybe Dave's patch is good as-is. It's the "I think you
> need to do more" that I worry about. Not at -rc4 time. Not with a core
> filesystem like ext4. Let's not hurry this too much.

Agreed, I know what to do, and and the change is not something I'd
want to get in -rc4.  I'll target a fix for the next merge window.

    	    	   	       	      	- Ted
