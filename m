From: Andreas Dilger <adilger@sun.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation	for
 FLEX_BG
Date: Wed, 23 Apr 2008 14:57:35 -0600
Message-ID: <20080423205735.GA3095@webber.adilger.int>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
 <1208868379-17580-2-git-send-email-tytso@mit.edu>
 <1208868379-17580-3-git-send-email-tytso@mit.edu>
 <20080422091847.50708436@gara> <20080422145125.GB12836@mit.edu>
 <20080422103212.1c974bd9@gara> <20080422185728.GC20668@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55553 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYDWU5u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 16:57:50 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3NKvnMn012979
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 13:57:49 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZS00A01Q4AKL00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Apr 2008 13:57:49 -0700 (PDT)
In-reply-to: <20080422185728.GC20668@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 22, 2008  14:57 -0400, Theodore Ts'o wrote:
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

It probably makes sense to change the mke2fs/tune2fs parameter to be in
MB or GB instead of a count of groups, and/or change the internal default
to be a function of the groups size instead of just a constant.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

