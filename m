From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: Random corruption test for e2fsck
Date: Fri, 13 Jul 2007 12:42:37 +0530
Message-ID: <1184310757.4372.14.camel@garfield>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com>
	 <p73myy3x8z0.fsf@bingen.suse.de>
	 <20070712051938.GD5586@schatzie.adilger.int>
	 <20070712110923.GA500@one.firstfloor.org>
	 <20070712221624.GA5880@schatzie.adilger.int>
	 <20070712222426.GB1011@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:56077 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXGMHLl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 03:11:41 -0400
In-Reply-To: <20070712222426.GB1011@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-13 at 00:24 +0200, Andi Kleen wrote:
> On Thu, Jul 12, 2007 at 04:16:24PM -0600, Andreas Dilger wrote:
> > On Jul 12, 2007  13:09 +0200, Andi Kleen wrote:
> > > > "dd if=/dev/urandom bs=1k ..." than to spin in a loop getting 16-bit
> > > > random numbers from bash.  We would also be at the mercy of the shell
> > > > being identical on the user and debugger's systems.
> > > 
> > > With /dev/urandom you have the guarantee you'll never ever reproduce
> > > it again. 
> > 
> > That is kind of the point of this testing - getting new test images for
> > each user that runs "make check" or "make rpm".  I'm We also save the
> > generated image before e2fsck touches it so that it can be used for
> > debugging if needed.
> 
> If you seed a good pseudo RNG with the time (or even a few bytes from 
> /dev/urandom; although the time tends to work as well) you'll also effectively 
> get a new image every time.
> 
> But the advantage is if you print out the seed the image
> can be easily recreated just by re-running the fuzzer
> with the same seed. No need to ship potentially huge images
> around.
> 
> You can essentially compress your whole image into a single
> number this way.

Firstly the filesystem is populated with files from the e2fsprogs source
directory. The filesystem is also corrupted by copying blocks in the
filesystem to some arbitary locations within it.

	from=`get_random_location $NUM_BLKS`
	to=`get_random_location $NUM_BLKS`
	dd if=$IMAGE of=$IMAGE bs=1k count=$CORRUPTION_SIZE conv=notrunc skip=
$from seek=$to >> $OUT 2>&1

Then the filesystem also undergoes corruption with /dev/urandom. To be
able to recreate the exact same filesystem with the seed, the filesystem
would need to allocate the _same_ blocks and metadata on both the
clients and the testers machine, which is obviously not possible.

Thanks,
Kalpak.

> 
> -Andi
