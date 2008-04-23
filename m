From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
 for FLEX_BG
Date: Wed, 23 Apr 2008 16:20:15 -0500
Message-ID: <20080423162015.702346a6@gara>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
	<1208868379-17580-2-git-send-email-tytso@mit.edu>
	<1208868379-17580-3-git-send-email-tytso@mit.edu>
	<20080422091847.50708436@gara>
	<20080422145125.GB12836@mit.edu>
	<20080422103212.1c974bd9@gara>
	<20080422185728.GC20668@mit.edu>
	<20080423205735.GA3095@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49428 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYDWVUm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 17:20:42 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3NLKcN8026081
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:20:38 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NLKc80248798
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:20:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NLKRvc007799
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:20:28 -0400
In-Reply-To: <20080423205735.GA3095@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 23 Apr 2008 14:57:35 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Apr 22, 2008  14:57 -0400, Theodore Ts'o wrote:
> > On Tue, Apr 22, 2008 at 10:32:12AM -0500, Jose R. Santos wrote:
> > > I see that now, guess I should not read code with out having
> > > breakfast.  I think 8 is a very safe and conservative number, maybe to
> > > conservative. The 64 group packing was the number I found to be a
> > > overall improvement with the limited number of drives that I had to
> > > test with.  Haven't done any testing on old drives or laptop drive with
> > > slow spindle speed but I would think 16 or 32 would be safe here unless
> > > the drive is really old and small.
> > 
> > Let's stay with 16 then for now.  Spindle speed doesn't actually
> > matter here; what matters is seek speed, and the density of the disk
> > drive.  The other thing which worries me though is that the size of
> > each flex_bg block group cluster is dependent on the size of the block
> > group, which in turn is related to the square of the filesystem
> > blocksize.   i.e., assuming a fs blockgroup size of 16, then:
> > 
> > Blocksize    Blocks/blockgroup  Blockgroup Size   Flex_BG cluster size
> > 
> >    1k	         8192             8 Meg	              128 Meg
> >    2k           16384             32 Meg              512 Meg
> >    4k           32768		  128 Meg	      2 Gig
> >    8k		65536             512 Meg	      8 Gig
> >   16k          131072             2 Gig		      32 Gig
> >   32k	       262144		  8 Gig		      128 Gig
> >   64k	       524288		  32 Gig	      512 Gig
> > 
> > So using a fixed default of 16, the flexible blockgroup size can range
> > anything from 128 megs to half a terabyte!
> > 
> > How much a difference in your numbers are you seeing, anyway?  Is it
> > big enough that we really need to worry about it?
> 
> It probably makes sense to change the mke2fs/tune2fs parameter to be in
> MB or GB instead of a count of groups, and/or change the internal default
> to be a function of the groups size instead of just a constant.

Did you mean making it a function of the block size?  I agree that this
would make more sense than just the constant.

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 



-JRS
