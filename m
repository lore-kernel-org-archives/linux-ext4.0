From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Slow filesystem.
Date: Sat, 14 May 2011 07:45:53 +0200
Message-ID: <20110514054553.GB6028@bitwizard.nl>
References: <20110513125958.GA22871@bitwizard.nl> <0EBAA8CB-5EE3-477F-B4DE-51C72A0E1595@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:38714 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750828Ab1ENFpz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 May 2011 01:45:55 -0400
Content-Disposition: inline
In-Reply-To: <0EBAA8CB-5EE3-477F-B4DE-51C72A0E1595@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 11:21:52PM -0600, Andreas Dilger wrote:
> On May 13, 2011, at 06:59, Rogier Wolff wrote:
> > My work (as in what brings in money to buy things from) file-system is
> > now "slow as hell". Last time this happened you guys told me that this
> > was because I had millions of hardlinks and way too many files.
> > 
> > Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> > /dev/md0                815M    4.1M    811M    1% /recover2
> > 
> > I have only 4.1M files. Only 1% inodes "in use". 
> > 
> > 
> > The filesystem was filling up lately, but i've managed to create some
> > free space.
> > 
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/md0              6.3T  5.3T  720G  89% /recover2

> I suspect that the free inodes in your filesystem are very
> fragmented, due to the filesystem filling up and then deleting a lot
> of files that create "holes" of free inodes within the inode table
> blocks.  That means that possibly finding free inodes is a bunch of
> work, and then possibly only one or two inodes are allocated from
> each block.

How can the free inodes be fragmented?!? 99% of the available inodes
ARE free.

> > The question is: How do I get the filesystem to perform
> > normally again?
 
> It is probably worthwhile to do a blktrace to see what the IO is
> looking like, and as Eric suggested the oprofile information may be
> interesting if a lot of CPU is being used.

A lot of CPU time is being used, yes. The 62 milliseconds are almost
completely CPU time.

I was running a big "backup" (image of a 500Gb disk) onto the
partition. Now that this has finished I'll try booting into a recent
kernel. Next I'll try finding and applying the patch.... 

	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
