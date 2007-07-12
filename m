From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Random corruption test for e2fsck
Date: Wed, 11 Jul 2007 23:19:38 -0600
Message-ID: <20070712051938.GD5586@schatzie.adilger.int>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <p73myy3x8z0.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:54937 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXGLFTk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 01:19:40 -0400
Content-Disposition: inline
In-Reply-To: <p73myy3x8z0.fsf@bingen.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 11, 2007  17:20 +0200, Andi Kleen wrote:
> If you use a normal pseudo random number generator and print the seed
> (e.g. create from the time) initially the image can be easily recreated 
> later without shipping it around. /dev/urandom
> is not really needed for this since you don't need cryptographic
> strength randomness. Besides urandom data is precious and it's 
> a pity to use it up needlessly.
> 
> bash has $RANDOM built in for this purpose.

Except it is a lot more efficient and easy to do
"dd if=/dev/urandom bs=1k ..." than to spin in a loop getting 16-bit
random numbers from bash.  We would also be at the mercy of the shell
being identical on the user and debugger's systems.

I don't think that running this test once in a blue moon on some
system is going to be a source of problems.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
