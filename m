From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
 for FLEX_BG
Date: Tue, 22 Apr 2008 17:27:51 -0500
Message-ID: <20080422172751.22d5aef9@gara>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
	<1208868379-17580-2-git-send-email-tytso@mit.edu>
	<1208868379-17580-3-git-send-email-tytso@mit.edu>
	<20080422091847.50708436@gara>
	<20080422145125.GB12836@mit.edu>
	<20080422103212.1c974bd9@gara>
	<20080422185728.GC20668@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45307 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759715AbYDVW17 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2008 18:27:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3MMRsrT011985
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 18:27:54 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3MMRsIa254666
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 18:27:54 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3MMRrDB001087
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 18:27:54 -0400
In-Reply-To: <20080422185728.GC20668@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Apr 2008 14:57:28 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Apr 22, 2008 at 10:32:12AM -0500, Jose R. Santos wrote:
> > I see that now, guess I should not read code with out having
> > breakfast.  I think 8 is a very safe and conservative number, maybe to
> > conservative. The 64 group packing was the number I found to be a
> > overall improvement with the limited number of drives that I had to
> > test with.  Haven't done any testing on old drives or laptop drive with
> > slow spindle speed but I would think 16 or 32 would be safe here unless
> > the drive is really old and small.
> 
> Let's stay with 16 then for now.  Spindle speed doesn't actually
> matter here; what matters is seek speed, and the density of the disk

Well higher spindle speed affect cylinder seek times which affect
overall seek time, which is why I think it should be tested as well.
 
> drive.  The other thing which worries me though is that the size of
> each flex_bg block group cluster is dependent on the size of the block
> group, which in turn is related to the square of the filesystem
> blocksize.   i.e., assuming a fs blockgroup size of 16, then:
> 
> Blocksize    Blocks/blockgroup  Blockgroup Size   Flex_BG cluster size
> 
>    1k	         8192             8 Meg	              128 Meg
>    2k           16384             32 Meg              512 Meg
>    4k           32768		  128 Meg	      2 Gig
>    8k		65536             512 Meg	      8 Gig
>   16k          131072             2 Gig		      32 Gig
>   32k	       262144		  8 Gig		      128 Gig
>   64k	       524288		  32 Gig	      512 Gig
> 
> So using a fixed default of 16, the flexible blockgroup size can range
> anything from 128 megs to half a terabyte!
> 
> How much a difference in your numbers are you seeing, anyway?  Is it
> big enough that we really need to worry about it?
> 
>     	   	   	       	  	- Ted

I do not have any data on multiple block size and I have not done
testing with the 64K equivalent of 4096 groups for a 4k filesystem. The
testing scenarios in a 4k filesystem should also be different than
those for a 64k filesystem, so the testing I did in 4k does not
necessarily apply to a bigger block size.

The default of 16 is a safe number for 4k block size.  I would think
that the larger the block size, the smaller the flex_bg packing size
should be since larger block size address some of the issues that
flex_bg tries to address.

-JRS
