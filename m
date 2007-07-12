From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Random corruption test for e2fsck
Date: Thu, 12 Jul 2007 13:09:23 +0200
Message-ID: <20070712110923.GA500@one.firstfloor.org>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <p73myy3x8z0.fsf@bingen.suse.de> <20070712051938.GD5586@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47757 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762047AbXGLLJY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 07:09:24 -0400
Content-Disposition: inline
In-Reply-To: <20070712051938.GD5586@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 11:19:38PM -0600, Andreas Dilger wrote:
> On Jul 11, 2007  17:20 +0200, Andi Kleen wrote:
> > If you use a normal pseudo random number generator and print the seed
> > (e.g. create from the time) initially the image can be easily recreated 
> > later without shipping it around. /dev/urandom
> > is not really needed for this since you don't need cryptographic
> > strength randomness. Besides urandom data is precious and it's 
> > a pity to use it up needlessly.
> > 
> > bash has $RANDOM built in for this purpose.
> 
> Except it is a lot more efficient and easy to do

Ah you chose to only address one sentence in my reply.
I thought only Linus liked to to do that.

If you're worried about efficiency it's trivial to
write a C program that generates bulk pseudo random numbers using
random(3) 

> "dd if=/dev/urandom bs=1k ..." than to spin in a loop getting 16-bit
> random numbers from bash.  We would also be at the mercy of the shell
> being identical on the user and debugger's systems.

With /dev/urandom you have the guarantee you'll never ever reproduce
it again. 

Andrea A. used to rant about people who use srand(time(NULL)) 
in benchmarks and it's sad these mistakes get repeated again and again.

-Andi
