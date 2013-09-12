From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fwd: strange e2fsck magic number behaviour
Date: Thu, 12 Sep 2013 13:35:34 -0400
Message-ID: <20130912173534.GB5985@thunk.org>
References: <CA+qGm=-0w+gTh6=ZJhns_=4LKksJueiaYF0gxogmj=TmFN7yQg@mail.gmail.com>
 <CA+qGm=_BBsNM6ZYYWhHucMiP7QWCfD0ApVQNa3ijN22AMN8mGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Alexander Harrowell <a.harrowell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59095 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3ILRfg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 13:35:36 -0400
Content-Disposition: inline
In-Reply-To: <CA+qGm=_BBsNM6ZYYWhHucMiP7QWCfD0ApVQNa3ijN22AMN8mGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 12, 2013 at 04:39:33PM +0000, Alexander Harrowell wrote:
> I'm currently trying to recover an ext4 filesystem. Last night, during
> a resize operation, the system (Ubuntu 12.04 LTS on my fix-stuff usb
> stick) locked up hard and eventually crashed. Restarting,
> unsurprisingly, gparted offered to check the volume. e2fsck, called
> from within gparted, replayed the journal overnight and completed the
> resize.

How big was this file system?  And it sounds like you were doing an
on-line resize (that is, the file system was mounted at the time when
you did the resize)?  There were some bugs there with file file
systems with block numbers > 32-bits (i.e., greater than 16TB).  But
for smaller file systems, online resize should have been fairly safe.
Certainly I'm not aware of any bugs that resulted in the system
locking up hard.

> and now comes the interesting bit - at some point, block 16777215
> starts to appear more and more often in the inodes, often duplicated,
> until it starts to print out the number 16777215 in a fast loop. in
> fact, it looks like it hits some inode and keeps printing block
> 16777215 to the same very long line (it's generated 500MB of log)

0xFFFFFF or 0x1000000 isn't a magic boundary as far as ext4 is
concerned.  It appears that this is showing up as part of the multiply
claimed blocks error message?  That usually happens because there was
garbage in an indirect block or in the extent tree.

What you might have remembered is that the maximum number of physical
blocks with ext4 is 48 bits, but what you are reporting is 24 bits,
which is something else quite different.

It would help to see a short except of exactly what e2fsck reported,
so we could see whether it is being reported as a logical block number
or a physical block number.  However, I suspect this is really much
more of a symptom rather than the cause.

Regards,

						- Ted
