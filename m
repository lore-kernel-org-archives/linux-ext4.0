From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Slow filesystem.
Date: Fri, 13 May 2011 23:21:52 -0600
Message-ID: <0EBAA8CB-5EE3-477F-B4DE-51C72A0E1595@dilger.ca>
References: <20110513125958.GA22871@bitwizard.nl>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25256 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1ENFV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 May 2011 01:21:59 -0400
In-Reply-To: <20110513125958.GA22871@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 13, 2011, at 06:59, Rogier Wolff wrote:
> My work (as in what brings in money to buy things from) file-system is
> now "slow as hell". Last time this happened you guys told me that this
> was because I had millions of hardlinks and way too many files.
> 
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/md0                815M    4.1M    811M    1% /recover2
> 
> I have only 4.1M files. Only 1% inodes "in use". 
> 
> 
> The filesystem was filling up lately, but i've managed to create some
> free space.
> 
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0              6.3T  5.3T  720G  89% /recover2

I suspect that the free inodes in your filesystem are very fragmented, due to the filesystem filling up and then deleting a lot of files that create "holes" of free inodes within the inode table blocks.  That means that possibly finding free inodes is a bunch of work, and then possibly only one or two inodes are allocated from each block.

> The question is: How do I get the filesystem to perform
> normally again?

It is probably worthwhile to do a blktrace to see what the IO is looking like, and as Eric suggested the oprofile information may be interesting if a lot of CPU is being used.

> All mkdir calls are taking around 62 milliseconds: 
> 
> 14:57:02 mkdir("...ME_25c8e/", 0777) = 0 <0.062312>
> 14:57:02 mkdir("...ME_112ff/", 0777) = 0 <0.062658>
> 14:57:02 mkdir("...ME_183cf/", 0777) = 0 <0.062344>
> 
> while on my workstation where i'm not supposed to be working
> with client-data I get: 
> 
> 14:58:18 mkdir("...ME_2a6c6/", 0777) = 0 <0.000033>
> 14:58:18 mkdir("...ME_2b3d9/", 0777) = 0 <0.000031>
> 14:58:18 mkdir("...ME_2c63f/", 0777) = 0 <0.000034>
> 
> So, things on my big datastorage drive are about 2000 times slower
> than on my workstation.
> 
> 	Roger. 
> 
> -- 
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
> Does it sit on the couch all day? Is it unemployed? Please be specific! 
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





