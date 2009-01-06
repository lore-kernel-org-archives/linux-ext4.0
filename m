From: Theodore Tso <tytso@mit.edu>
Subject: Re: How to recover a damaged ext4 file system?
Date: Tue, 6 Jan 2009 14:34:04 -0500
Message-ID: <20090106193404.GA18957@mit.edu>
References: <20090105135347.GA3337@localdomain> <20090106120527.GT3932@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Ohm <chr.ohm@gmx.net>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57059 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZAFTeI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 14:34:08 -0500
Content-Disposition: inline
In-Reply-To: <20090106120527.GT3932@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 06, 2009 at 05:05:27AM -0700, Andreas Dilger wrote:
> 
> You should try to run e2fsck with the backup group descriptors, using
> the -B and/or -b options (at a guess -B 4096 and -b 32768).

That probably won't help, given that the fsck transcript already says
this:

> > fsck.ext4: Group descriptors look bad... trying backup blocks...

It looks like both the primary and the backup block group descriptors
are bad.  I'm not sure how this happened; normally nothing touches the
backup block superblocks at all.  Stupid question --- are you sure the
partition table is sane; that's always the first thing to check.

Can you upload someplace the output of

dumpe2fs /dev/XXX
dumpe2fs -o superblock=32768 /dev/XXX
dumpe2fs -o superblock=98304 /dev/XXX

That would be helpful to see what had happened.

> 2. Is this corruption a fault of ext4? I guess this is difficult to
> answer, but I had ext3 survive any lockups without much problems. So
> far ext4 seems not quite that robust, but perhaps another file
> system would have blown up as well in this situation. Is there any
> information I can give you to help make ext4 more robust?

I'm not sure what the hard system hang did, but it looks like it
splattered a lot of random crap all over the harddrive.  I doubt ext4
did this, and I doubt ext3 would have done any better.... we need to
know a lot more about exactly what sort damage was done to the
filesytem to say for certain, though.

					- Ted


