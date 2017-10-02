From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 build errors
Date: Mon, 2 Oct 2017 10:55:17 -0400
Message-ID: <20171002145517.652p7p7q4vv5rqcc@thunk.org>
References: <1506954181.985.9.camel@infinera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53186 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751188AbdJBOzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Oct 2017 10:55:19 -0400
Content-Disposition: inline
In-Reply-To: <1506954181.985.9.camel@infinera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 02, 2017 at 02:23:02PM +0000, Joakim Tjernlund wrote:
> Hi ext4 devs
> 
> Adding the patch last in this mail cause lots of build errors in ext4, here is a few:

Why did you need this patch to fix problems in VirtualBox?

Cleaning this up is going to be a little tricky, because one of the
implications the void * declaration in the __set_bit_le() declaration
is that there isn't any particular alignment requirement with the __le
functions.  But the long * declaration implies that the bitmaps have
to be aligned to sizeof(long).

For the ext4 bitmap, we use it on bh->b_data, for which we can safely
assume is long-aligned.  But the mballoc buddy bitmaps use
mb_set_bit() in ways that are _not_ guaranteed to be long aligned.

So fixing this is going to be a bit painful, and will likely result in
a performance regression for ext4.  We can make our own version that
open codes it as C functions --- but then we lose all of the
architecture optimized bitop functions.

I believe the reason why the standard bitop functions are made long *
aligned is that on some BE architectures --- I suspect it was PowerPC
but I'm not 100% sure about that --- the native bitop functions
required a long * alignment.  Fortunately all of the little endian
architectures didn't have these alignment restrictions, so we could
keep the __set_bit_le functions to not have any long alignment
restrictions.

The fact that bitop and the bitop_le functions are not the same
is... inelegant, but if it represents a practical optimization that is
possible on LE systems but not on BE systems (where bitop_le gets open
coded in C, in an inefficient way, but oh, well, BE systems aren't for
the cool kids anyway :-), I have to ask whether it's really worth it
to do the cleanup.

Cheers,

					- Ted
