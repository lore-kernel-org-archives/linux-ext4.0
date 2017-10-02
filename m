From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 build errors
Date: Mon, 2 Oct 2017 12:54:08 -0400
Message-ID: <20171002165408.fhgsykuwautesn4v@thunk.org>
References: <1506954181.985.9.camel@infinera.com>
 <20171002145517.652p7p7q4vv5rqcc@thunk.org>
 <1506957332.985.22.camel@infinera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53588 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbdJBQyK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Oct 2017 12:54:10 -0400
Content-Disposition: inline
In-Reply-To: <1506957332.985.22.camel@infinera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 02, 2017 at 03:15:33PM +0000, Joakim Tjernlund wrote:
> > I believe the reason why the standard bitop functions are made long *
> > aligned is that on some BE architectures --- I suspect it was PowerPC
> > but I'm not 100% sure about that --- the native bitop functions
> > required a long * alignment.  Fortunately all of the little endian
> > architectures didn't have these alignment restrictions, so we could
> > keep the __set_bit_le functions to not have any long alignment
> > restrictions.
> 
> If this is a special case for ext4, can you not just do an explicit
> type cast in ext4 code?

Sure, it would be safe *today*, but then in the future someone might
change an implementation of the bitop_le* functions for some
architecture which would not tolerate unaligned pointers (since using
a long * would imply this is allowed), and then things would break.

> > The fact that bitop and the bitop_le functions are not the same
> > is... inelegant, but if it represents a practical optimization that is
> > possible on LE systems but not on BE systems (where bitop_le gets open
> > coded in C, in an inefficient way, but oh, well, BE systems aren't for
> > the cool kids anyway :-), I have to ask whether it's really worth it
> > to do the cleanup.
> 
> I see, but by using void * you also loose type checking w.r.t size so
> if you by mistake use an u32, you will not notice.

Um, we're never using a u32.  We're using a pointer into a bit array
which is often far larger than 32 or 64 bits.  For example, when we
use a 4k block size, then bh->b_data is a bit array which is 4096*8 ==
32,768 bits.

This is why void * is the right thing --- it's not a u32 or a long.
It's a bit array.  And in the case of the mb buddy bitmap, it's not
necessarily going to start on a a byte boundary which is a multiple of
4 or 8.

					- Ted
