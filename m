From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Uneven load on my raid disks.
Date: Wed, 29 Dec 2010 17:17:15 -0500
Message-ID: <20101229221715.GK10149@thunk.org>
References: <20101228090749.GB1351@bitwizard.nl>
 <4D1B646C.8030100@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-ext4@vger.kernel.org
To: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52474 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab0L2WR2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Dec 2010 17:17:28 -0500
Content-Disposition: inline
In-Reply-To: <4D1B646C.8030100@uni-konstanz.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 29, 2010 at 05:40:12PM +0100, Kay Diederichs wrote:
> >says: dumpe2fs -h /dev/md0 | grep RAID
> 
> % tune2fs -l /dev/md0
> 
> ...
> RAID stride:              128
> RAID stripe width:        768
> ...
> 
> runs much faster than dumpe2fs.
> The command can also adjust the values.

Actually, "tune2fs -l" and "dumpe2fs -h" both run in about the same
amount of time.  dumpe2fs without the -h option runs slower than
tune2fs -l, true.  But that's because it reads and prints out
information regarding the block and inode allocation bitmaps.

	    	      	  	    	  	     - Ted
