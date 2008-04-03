From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: #blocks per group too big: 37265
Date: Thu, 3 Apr 2008 14:39:29 -0400
Message-ID: <20080403183929.GE13486@mit.edu>
References: <20080403161904.GA31670@msgid.wurtel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35605 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbYDCSjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 14:39:40 -0400
Content-Disposition: inline
In-Reply-To: <20080403161904.GA31670@msgid.wurtel.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 03, 2008 at 06:19:04PM +0200, Paul Slootman wrote:
> Hi,
> I wanted to try out ext4 on my shiny new 9+TB RAID5 device
> (11 x 1TB disks in md raid5).
> 
> I obtained the 1.39-tyt3 version of e2fsprogs, and did:
> 
> ./mkfs.ext3 -j -m 0 -N 1000000000 -O dir_index,filetype,resize_inode -E stride=65536,resize=5120000000 -J device=/dev/mapper/vg11-md15--journal -L data2 /dev/md15
> 
> (If using a separate device for the journal is inadvisable, please let
> me know; this is on a different set of spindles that md15 is running on.)
> 
> The stride was calculated from the 64k chunk of the raid5 device.
> Mainly a guess, as I couldn't find any clear reference on how to plug in
> the values to fill this in.

The stride parameter is the problem.  Newer versions of e2fsprogs
don't allow a stride parameter which is too big.  If you want to do
the perfect calculation, you take the 64k chunk size, and divide it by
the 4k blocksize to yield a stride parameter of 16.  Actually, though,
simply using a non-zero stride size is actually good enough --- and if
you have a even number of RAID-5 disks, you might not need this
parameter at all.  (It's only purpose is to perturb the location of
the block bitmaps so that all of the bitmaps don't end up on a single
hard drive.)

BTW, we will be making a new snapshot for people who want to test ext4
soon....

					- Ted
