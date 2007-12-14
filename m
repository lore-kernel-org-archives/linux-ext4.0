From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Thu, 13 Dec 2007 20:36:11 -0600
Message-ID: <20071213203611.69525e6c@gara>
References: <20071206161045.1054bbe7@gara>
	<20071207101428.GE3214@webber.adilger.int>
	<20071207095212.037ca68a@gara>
	<20071211110033.GQ3214@webber.adilger.int>
	<20071211100812.557b923b@gara>
	<20071211231528.GS3214@webber.adilger.int>
	<20071213095112.100b3d9e@gara>
	<20071213225857.GK3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:59584 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbXLNCgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2007 21:36:20 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBE2aKId023859
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 21:36:20 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBE2aEqQ122918
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 19:36:19 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBE2aCf5013581
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 19:36:13 -0700
In-Reply-To: <20071213225857.GK3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Dec 2007 15:58:57 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Dec 13, 2007  09:51 -0600, Jose R. Santos wrote:
> > Now, storing the bits only guaranties that the flexbg size is always a
> > power-of-two and does not guarantee that the super block flexbg size
> > represents the actual meta-data grouping on disk.  For this we need to
> > verify that the bitmap offsets match what the super block reports.  It
> > may be an unlikely scenario, but it may be worth it to check this as
> > well at mount time.
> 
> I'm not sure what you mean...  Isn't the flexbg size just a count of
> the number of block groups?  If it is always a power of two, and the
> groups per metabg is always a power of two (it is) then they will
> always be even multiples.

What I mean is that if the value in the super block is corrupted and
does not represent the actual flexbg size, the inode allocation will
behave in weird unexpected ways.  Just as we check that the bitmaps are
within the block group range (when not using flexbg), we should
probably sanity check the size of the flexbg as reported in the super
block.

Or do you believe the check is unnecessary?

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 



-JRS
