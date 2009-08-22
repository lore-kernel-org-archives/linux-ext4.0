From: Theodore Tso <tytso@mit.edu>
Subject: Re: RFC: Clarifying Direct I/O Semantics
Date: Fri, 21 Aug 2009 20:07:45 -0400
Message-ID: <20090822000745.GP9529@mit.edu>
References: <E1Mec4O-0005ka-NN@closure.thunk.org> <4A8F1FA5.5080501@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58228 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587AbZHVAHr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2009 20:07:47 -0400
Content-Disposition: inline
In-Reply-To: <4A8F1FA5.5080501@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 21, 2009 at 06:28:53PM -0400, jim owens wrote:
>> The Linux man page does not state what happens if the alignment
>> restrictions are not met; does the kernel start running rogue or
>> nethack; does it send a signal such as SIGSEGV or SIGABORT, and kill the
>> running process; or does it fall back to buffered I/O? Today, the answer
>> is the latter; but it's not specified anywhere.
>
> retval = -EINVAL; is what __blockdev_direct_IO does in that case
> and what I was making btrfs directIO do.  but fall back is OK too
> if we really want. what existing code fixes up the EINVAL?

You're right; I thought it did the fallback in all cases, but it only
does it when writing into holes.  Oops.  I should have tested this
before saying it.

I'll fix up the wiki page.

>> This is relatively well understood by most implementors and users of
>> O_DIRECT as part of the "oral lore", so simply updating the Linux man
>> page should not be controversial.
>>
>
> The following section includes "sparse" AKA "allocating" writes but
> just says "extending".  Either sparse-filling write needs covered
> separately or we should say "allocating" instead of "extending.

Yup, good point.

> Possibly it should just be stated that directIO write data integrity
> is based on the setting of posix O_SYNC and O_DSYNC.  Then it is their
> choice to run slow-and-safe or fast.  O_SYNC requires metadata on disk.

The question in my mind is whether we should guarantee that the data
block is written synchronously for allocating writes when the file
metadata is not written synchronously; what's the point?  After all,
the application can't distinguish between the data block not making it
out to disk, versus the metadata that will allow the data block to be
accessed after a crash, why should one by synchronous but not the
other?

						- Ted
