From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
	for FLEX_BG
Date: Tue, 22 Apr 2008 14:57:28 -0400
Message-ID: <20080422185728.GC20668@mit.edu>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu> <1208868379-17580-2-git-send-email-tytso@mit.edu> <1208868379-17580-3-git-send-email-tytso@mit.edu> <20080422091847.50708436@gara> <20080422145125.GB12836@mit.edu> <20080422103212.1c974bd9@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42407 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764535AbYDVS6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 14:58:07 -0400
Content-Disposition: inline
In-Reply-To: <20080422103212.1c974bd9@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 22, 2008 at 10:32:12AM -0500, Jose R. Santos wrote:
> I see that now, guess I should not read code with out having
> breakfast.  I think 8 is a very safe and conservative number, maybe to
> conservative. The 64 group packing was the number I found to be a
> overall improvement with the limited number of drives that I had to
> test with.  Haven't done any testing on old drives or laptop drive with
> slow spindle speed but I would think 16 or 32 would be safe here unless
> the drive is really old and small.

Let's stay with 16 then for now.  Spindle speed doesn't actually
matter here; what matters is seek speed, and the density of the disk
drive.  The other thing which worries me though is that the size of
each flex_bg block group cluster is dependent on the size of the block
group, which in turn is related to the square of the filesystem
blocksize.   i.e., assuming a fs blockgroup size of 16, then:

Blocksize    Blocks/blockgroup  Blockgroup Size   Flex_BG cluster size

   1k	         8192             8 Meg	              128 Meg
   2k           16384             32 Meg              512 Meg
   4k           32768		  128 Meg	      2 Gig
   8k		65536             512 Meg	      8 Gig
  16k          131072             2 Gig		      32 Gig
  32k	       262144		  8 Gig		      128 Gig
  64k	       524288		  32 Gig	      512 Gig

So using a fixed default of 16, the flexible blockgroup size can range
anything from 128 megs to half a terabyte!

How much a difference in your numbers are you seeing, anyway?  Is it
big enough that we really need to worry about it?

    	   	   	       	  	- Ted
