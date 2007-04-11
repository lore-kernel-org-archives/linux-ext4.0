From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs - pass1c terminates early if hard links
Date: Wed, 11 Apr 2007 08:57:07 -0400
Message-ID: <20070411125707.GE19237@thunk.org>
References: <Pine.LNX.4.61.0704101344050.29750@webb> <20070411034019.GA25231@thunk.org> <20070411042220.GP5967@schatzie.adilger.int> <20070411104230.GA19237@thunk.org> <20070411115147.GS5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Garlick <garlick@llnl.gov>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55958 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXDKM5I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2007 08:57:08 -0400
Content-Disposition: inline
In-Reply-To: <20070411115147.GS5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 11, 2007 at 05:51:47AM -0600, Andreas Dilger wrote:
> > Of course the temptation then would be to start adding conditions,
> > functions, maybe an entire tcl interpreter....   :-)
> 
> Yes, I thought of this too, and also the "let's build a full interpreted
> language into debugfs" conclusion.  It wouldn't be fatal though - in
> some cases it would be nice to have debugfs loop over inodes to fix some
> unusual corruption.

I have actually thought about the possibility of extending libss so
that it would optionally load the tcl shared library, just as today we
optionally load the readline library.  The interfaces used by libss to
call individual command handlers and those used by tcl aren't actually
all that different.

If someone wanted to look into it, patches would certainly be
gratefully accepted.  Having the ability to loop over inodes would
come in handy, and while you can do it to day by writing the script in
perl or bash and then using debugfs -R, (1) it's clumsy, and (2) it's
slow for big filesystems if you have to read the bitmaps each time.

Speaking of which, wasn't someone going to write patches that did lazy
bitmap loading for debugfs?  I can't remember who said they would do
that.  To whoever was going to do that --- one thought which I had ---
it would probably be a good idea to keep the current catastrophic
mode, and change it so that in catatrophic mode, bitmaps are not
loaded automatically, and an error message is returned right away.
There may be situations where you don't want debugfs to ever even try
loading the bitmaps (because they will fail after waiting a long
time), and so an immediate refusal to execute a particular command
requires the bitmaps to be loaded may be preferable.

						- Ted
