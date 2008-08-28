From: Theodore Tso <tytso@mit.edu>
Subject: Re: reserved field in struct io_manager
Date: Wed, 27 Aug 2008 21:25:16 -0400
Message-ID: <20080828012516.GE26987@mit.edu>
References: <20080826110924.GJ3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51262 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978AbYH1BZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 21:25:19 -0400
Content-Disposition: inline
In-Reply-To: <20080826110924.GJ3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 05:09:24AM -0600, Andreas Dilger wrote:
> I notice in the struct io_manager that there are reserved fields at the
> end, presumably for adding new methods to this array.  Unfortunately,
> the reserved field is type "int" instead of "long" and as a result there
> isn't necessarily enough space to hold a function pointer on a 64-bit
> system.
> 
> Have you looked at this at all?  Presumably as methods are added on 64-bit
> systems, the array grows slightly larger each time because the pointers
> are larger than the amount of space removed from the array.  Possibly this
> is harmless, because the consumers of this struct have allocated enough
> space to handle all of the used fields.

Yeah, it's mostly harmless.  We should probably make it be a long just
to be safe, but we have a pretty big buffer there.

The bigger problem is that when we added the 64-bit methods, we didn't
do it the best way, given that we have to deal with old applications
linking with new libaries, and vice versa, and the I/O manager can be
in *either* the application or the library.  We can mostly paper over
this by having ext2fs_open() check to make sure the write_blk64() and
read_blk64() are present.  But I should (and will) replace the header
file #define's for the read64 and write64 functions with a real C
function which can fall back to read/write functions if the
read64/write64 functions aren't present.

> I was going to submit a patch to add a "readahead" method, which we've
> been using in our "e2scan" tool to improve performance, and I thought
> it might also be useful for e2fsck speedups.  If someone is interested
> in these I can send them to the list, but the patches won't apply to
> the current Git tree because of this change.

I'd recommend adding a new C wrapper function instead of using a
#define in ext2_io.h, and for us to apply it in the "master" branch
after the 1.41.1 release.

Regards,

					- Ted
