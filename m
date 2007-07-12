From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Random corruption test for e2fsck
Date: Fri, 13 Jul 2007 00:24:26 +0200
Message-ID: <20070712222426.GB1011@one.firstfloor.org>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <p73myy3x8z0.fsf@bingen.suse.de> <20070712051938.GD5586@schatzie.adilger.int> <20070712110923.GA500@one.firstfloor.org> <20070712221624.GA5880@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:33171 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbXGLWY1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 18:24:27 -0400
Content-Disposition: inline
In-Reply-To: <20070712221624.GA5880@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 12, 2007 at 04:16:24PM -0600, Andreas Dilger wrote:
> On Jul 12, 2007  13:09 +0200, Andi Kleen wrote:
> > > "dd if=/dev/urandom bs=1k ..." than to spin in a loop getting 16-bit
> > > random numbers from bash.  We would also be at the mercy of the shell
> > > being identical on the user and debugger's systems.
> > 
> > With /dev/urandom you have the guarantee you'll never ever reproduce
> > it again. 
> 
> That is kind of the point of this testing - getting new test images for
> each user that runs "make check" or "make rpm".  I'm We also save the
> generated image before e2fsck touches it so that it can be used for
> debugging if needed.

If you seed a good pseudo RNG with the time (or even a few bytes from 
/dev/urandom; although the time tends to work as well) you'll also effectively 
get a new image every time.

But the advantage is if you print out the seed the image
can be easily recreated just by re-running the fuzzer
with the same seed. No need to ship potentially huge images
around.

You can essentially compress your whole image into a single
number this way.

-Andi
