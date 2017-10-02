From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [EXTERNAL]Re: ext4 build errors
Date: Mon, 2 Oct 2017 14:40:35 -0400
Message-ID: <20171002184035.hwbkntpuup7ikqyv@thunk.org>
References: <1506954181.985.9.camel@infinera.com>
 <20171002145517.652p7p7q4vv5rqcc@thunk.org>
 <1506957332.985.22.camel@infinera.com>
 <20171002165408.fhgsykuwautesn4v@thunk.org>
 <1506965229.24473.9.camel@infinera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53900 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdJBSkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Oct 2017 14:40:39 -0400
Content-Disposition: inline
In-Reply-To: <1506965229.24473.9.camel@infinera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 02, 2017 at 05:27:12PM +0000, Joakim Tjernlund wrote:
> > This is why void * is the right thing --- it's not a u32 or a long.
> > It's a bit array.  And in the case of the mb buddy bitmap, it's not
> > necessarily going to start on a a byte boundary which is a multiple of
> > 4 or 8.
> 
> For ext4 it might be right but I was using "you" in a wider scope,
> the rest of kernel src.

So let's take this up to a high level of the problem.  For the bitops
functions, there are two sorts of users.  Those that want to operate
on an integer type (either a u32 or a long), and those that operate on
bitarrays.  Most of the integer users are using the bitops for
in-memory state flags.  Most of the bitarray use cases are for things
like ext4's allocation bitmaps, where the on-disk format needs to be
portable across architectures --- and that's where bitops_le tends to
be used.

Taking a quick look at the output of "git grep set_bit_le", most of
the users are just like ext4, where it's being used for a bitarray.
So my argument I think *does* apply much more widely.

      	       	       	      	    	 - Ted
