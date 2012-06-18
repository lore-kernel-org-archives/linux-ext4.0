From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Mon, 18 Jun 2012 13:12:57 -0400
Message-ID: <20120618171257.GA16017@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Tony Breeds <tony@bakeyournoodle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51118 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2FRRNC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 13:13:02 -0400
Content-Disposition: inline
In-Reply-To: <20120618055836.GA30557@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 18, 2012 at 03:58:42PM +1000, Tony Breeds wrote:
> 
> I'm not certain we're on the same page.  We're linking statically so
> that fact we don't call the progress functions doesn't matter.  The
> code is in libext2fs.a and there must be a call path from (eg)
> ext2fs_open() to fwrite(stderr, ...).  The fact we don't add the 
> EXT2_FLAG_PRINT_PROGRESS doesn't come into it does it?

Oh, I see, the problem is that ext2fs_closefs() is calling the
progress functions; I had forgotten about it.  Yeah, that's something
I can fix so that the progress functions are only dragged in if mke2fs
explicitly requests it, via adding function which enables the progress
functions, instead of just setting the EXT2_FLAG_PRINT_PROGRESS.

> No we really don't need mmp :)  I can see creating --enable-mmp and
> --disbale-mmp options for configure would be reasonable and not too
> intrusive, and it gets rid of nearly 30% of the libc functions.

Yes, absolutely.  I'll look at your patch but adding --disable-mmp is
something I'm very comfortable adding to e2fsprogs.

> Feedback very welcome but if it looks okay I'll add my signed off and
> resubmit with a reasonable commit message.

So a couple of things; it's a really bad to define static functions in
a header file such as ext2fs.h.  Yes, gcc will normally optimize out
functions which aren't used, but it will also complain with warnings
if you enable them.

Instead, what I would do is to simply take out the calls to the
ext2fs_mmp library functions in e2fsck and tune2fs, and remove the MMP
feature flag from the list of supported features.  That way, if
someone tries to use the e2fsck binary compiled with --disable-mmp on
a file system with MMP enabled, e2fsck will refuse to touch the file
system saying that it doesn't support the feature.  If you just make
the mmp functions silently succeed (by returning 0), that's really bad
since file system damage could result.

> Well currently we open it read-write but I cannot see a problem with
> switching to read-only.  Based on my very limited understanding of
> e2fsprogs it seems that disabling the bitmap functions is good for yaboot
> it would result in a library that has pretty limited value to anyone
> else.

I already have things set up so that if you don't actually call the
functions to read in the bitmaps, the functions to read and write the
bitmaps don't get dragged into a static library link.  That's what I'm
referring to.

The functions to actually create in-memory bitmaps for various
housekeeping things, do need to get dragged in, but we don't
necessarily need to drag in all of the different bitmap back-ends.  If
we assume that yaboot doesn't need to optimize for low-memory usage
for really, really big file systems (i.e., you're not going to try to
allocate files or blocks while opening a multi-terrabyte file system
using libext2fs on a system with only 512mb), then you wouldn't need
blkmap64_rb.c.

And the bitmap statistics functions are sometihng we can use a
configure option to disable, which should remove the last bits of
stdio usage I believe.

> For the record we currently only call:
> 	ext2fs_open()
> 	ext2fs_namei_follow()
> 	ext2fs_follow_link()
> 	ext2fs_read_inode()
> 	ext2fs_close()
> 	ext2fs_block_iterate()
> 	ext2fs_bmap() # Actually we may not use this anymore 
> 
> I'm also happy to rewrite the yaboot code for ext* if someone with
> more knowledge can make a provide pointers.

OK, that's useful.  I'm a little busy at the moment, but in the next
couple of weeks as I have time I'll trace down what is getting dragged
in and see if I can minimize the number of library functions that are
pulled in via static library link, and where necessary add configure
options to disable stuff that you wouldn't need.

If you'd like to try to clean up the --disable-mmp patch, and perhaps
try your hand at a --disable-libext2fs-stats patch which disable the
statistics options, that would be great.  Otherwise, I'll try to get
to it in the next few weeks.

Regards,

						- Ted
