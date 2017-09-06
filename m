From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 Bug Report
Date: Wed, 6 Sep 2017 15:28:15 -0400
Message-ID: <20170906192815.orfe2pr6vkakix6u@thunk.org>
References: <CAFzqJcYcZHFzSJEGKrjHy3HgwDfiDHg5_wbj6GM7g+4sFPZkDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Suman Jana <sumanj@gmail.com>
To: Ruoxin Jiang <rj2394@columbia.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34834 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752255AbdIFT2S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Sep 2017 15:28:18 -0400
Content-Disposition: inline
In-Reply-To: <CAFzqJcYcZHFzSJEGKrjHy3HgwDfiDHg5_wbj6GM7g+4sFPZkDQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 06, 2017 at 11:58:19AM -0400, Ruoxin Jiang wrote:
> 
> We are researchers from Columbia University, New York. As part of our
> current research we have found some semantic discrepancies between
> ext4 and the POSIX specification/other popular filesystems.
> 
> We have attached two cases. The first one involves a direct access
> read starting from file EOF. Ext4 behavior in this case seems to
> violate the POSIX standard. In directory 2, we discovered that ext4
> and other popular filesystems (xfs/btrfs/f2fs) return different error
> codes for the same lseek syscall.

Hi,

Thanks for your report.

First, I commend your use of a relatively new kernel.  The fact that
you mentioned that some file systems were using iomap means that you
must be using a relatively new kernel, since iomap was only first
introduced in 4.8.  Many researchers tend to use far more obsolete
kernels, so it's nice to see the fact that this was done on a
relatively new kernel.  That being said, it would have been nice if
you specified exactly what Linux kernel you did your testing against.

Second, I agree that it is better that file systems on Linux should,
ideally have behaviour that is made consistent with each other
whenever possible.  And so changing ext4 to return the same error
codes or have the same behavior is in general a good thing, all other
things being equal.  We probably will convert ext4 to use iomap for at
least O_Direct operations at some point in the future, which will help
promote this.

>From a technical, spec-lawyering, niggling sort of way, I'm not sure
I'd consider the first case to be a violation of the POSIX
specification, however.  If you specify an open flag which is not
specified in POSIX, the behavior of system calls when used against
that file descriptor might not be fully compliant with the
specification.  The most obvious example of this is O_NOATIME.  If the
file descriptor is opened with that flag, then reads will not cause
atime to change.  This is obviously "in violation" of POSIX, which
mandates that atime is always modified when a file is read.  But, as
Charles Dickens once write, sometimes, "the law is an ass".

Similarly, in POSIX 2001, O_CLOEXEC was not yet part of the standard,
but I don't think anyone would have argued with a straight face that
because Linux implemented O_CLOEXEC, the fact that a file descriptor
created with this flag would get closed across an exec meant, ipso
facto, that Linux was "in violation of the Posix standard".
Fortunately, for people who might think that, by POSIX 2008, O_CLEXEC
*was* added to the spec, so that's no longer an issue.  We still
"violate the POSIX" spec with respect to O_NOATIME, however...

It's for this reason that I would argue that ext4 isn't necessarily
violating the specification when O_DIRECT is used, because O_DIRECT is
not defined by POSIX or the Single Unix Specification, and as
discussed above, non-standard flags can make system calls behave in
ways that are different from what is specified in POSIX specification.
(Another example: the O_PATH flag.)

It's still valid to say that ext4 should change to be consistent with
other file systems, and I agree with the changes you proposed in your
Readme.md files.  I'm just quibbling about whether or not this can be
technically considered a "POSIX Violation".

Best regards,

					- Ted
