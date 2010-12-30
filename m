From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Uneven load on my raid disks.
Date: Thu, 30 Dec 2010 11:32:01 +0100
Message-ID: <20101230103200.GH2986@bitwizard.nl>
References: <20101228090749.GB1351@bitwizard.nl> <4D1B646C.8030100@uni-konstanz.de> <20101229221715.GK10149@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Diederichs <kay.diederichs@uni-konstanz.de>,
	Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:65309 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752664Ab0L3KcD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Dec 2010 05:32:03 -0500
Content-Disposition: inline
In-Reply-To: <20101229221715.GK10149@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 29, 2010 at 05:17:15PM -0500, Ted Ts'o wrote:
> On Wed, Dec 29, 2010 at 05:40:12PM +0100, Kay Diederichs wrote:
> > >says: dumpe2fs -h /dev/md0 | grep RAID
> > 
> > % tune2fs -l /dev/md0
> > 
> > ...
> > RAID stride:              128
> > RAID stripe width:        768
> > ...
> > 
> > runs much faster than dumpe2fs.
> > The command can also adjust the values.
> 
> Actually, "tune2fs -l" and "dumpe2fs -h" both run in about the same
> amount of time.  dumpe2fs without the -h option runs slower than
> tune2fs -l, true.  But that's because it reads and prints out
> information regarding the block and inode allocation bitmaps.

And the annoying thing is that it apparently uses a library function
that only returns after reading all that data. 

So while it could print the superblock info and the first few block
groups, I'm left waiting.

My remove-of-200-million-files has completed. It took a week. 
200000000/7/24/3600 = 330.7 .

So it deleted around 330 files per second. With one IO operation per
delete, the four disks operating at close to 75 IOs per second have
performed reasonable. And at an average of 1 IO per remove, also
the filesystem has performed reasonable. It seems I forgot the
-E stride= option on mkfs. 

The manual of tune2fs hints that this can be tuned after the fact with
tune2fs. I seriously doubt it. Correct?

TUNE2FS(8)                                                          
...
       -E extended-options
              Set extended options for the filesystem.  Extended  options  are
              comma separated, and may take an argument using the equals ('=')
              sign.  The following extended options are supported:

                   stride=stride-size
...
                   stripe_width=stripe-width



	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
