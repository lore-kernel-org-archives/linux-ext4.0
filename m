From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] resizing to minimum was failed since 45a78b
Date: Wed, 29 Apr 2015 10:29:12 -0400
Message-ID: <20150429142912.GA18756@thunk.org>
References: <01cb01d08257$26157350$724059f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org
To: Chanho Park <chanho61.park@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35462 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966131AbbD2O3Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2015 10:29:16 -0400
Content-Disposition: inline
In-Reply-To: <01cb01d08257$26157350$724059f0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2015 at 05:33:20PM +0900, Chanho Park wrote:
> 
> When I tried to resize a loop ext4 image to minimum, I couldn't get correct
> result.

It all depends on your definition of "correct".  I've regretted
accepting the the patch to implement -M, since in practice almost
everyone who has been using really shouldn't have been.  It's useful
for developers who want to stress test resize2fs to make sure it does
the right thing in corner cases.

However, it's a *terrible* idea for anyone to use it for __anything__
else.  The result of using resize2fs -M is a file system where the
files are highly fragmented.  The first real world use of resizde2fs
-M I was aware of, which was some clever Red Hat release engineer
which created a huge file system, installed Red Hat on it, compressed
it down to a minimum size using resize2fs -M, and then burned the
result on a CD-ROM for use as a bootable Live CD system image.  The
resulting fragmentation of files as a result of resize2fs -M meant
that reading certain files from the CD-ROM, which is not known for its
high seek speeds, was, shall we say, less than optimal.

Because I don't think there are mant (any?) real sane/valid production
uses of resize2fs -M, my definition of "correct" for resize -M is that
it doesn't (a) corrupt file systems, or (b) lead to a state when
resize2fs -M might not be able to make forward progress, leaving to a
file-system which is half-resized, corrupt, and requiring expert
surgery from a file system expert to recover.  The reason why I care
about this is because it's not just used by misguided release
engineers trying to create file system images from source builds,
where if there is a corrupted file system, it's not a disaster.

Unfortunately, it's also used by clueless users who usually have _not_
made a backup before trying to use resize2fs -M to shrink their file
system before trying to rearrange their LVM volumes.  And users get
cranky when they lose data.

So the bottom line is I care a lot more about data loss than I do
about shrinking file systems to the absolute minimum size, and I
personaly don't think it's worth a huge amount of effort to try to
make the calculation of the minimum size where resize2fs is guaranteed
to succeed any closer to being exact.

That being said, if you are creating a read-only file system for a
flash image (where seeks are largely free), and you really insist on
using resize2fs -M, it may be that your best bet is to turn off the
flex_bg option, since most of the advantages of flex_bg aren't there
on a read-only flash image (such as might be used for a
system/firmware image).

Alternatively, if you want to invest effort in trying to make
resize2fs -M mimum file system size more accurate, feel free to send
me patches --- plus your proof in terms of code analysis and an
exhaustive test regime to make sure that it works for a wide variety
of file system sizes and free space availability pre-resize2fs.
Personally, I don't think it's a particularly worthwhile use of an
engineer's time, but if you really have a strong business need for
this, feel free work on it and send me the results of your efforts.

Cheers,

					- Ted
