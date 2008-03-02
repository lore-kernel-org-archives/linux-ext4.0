From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Sun, 02 Mar 2008 10:51:56 -0800
Message-ID: <20080302185156.GB2908@webber.adilger.int>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204240440.3609.26.camel@localhost.localdomain>
 <20080229110924.GA16757@skywalker> <20080229192142.GJ2997@webber.adilger.int>
 <20080301173059.GA6833@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44748 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYCBSv7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2008 13:51:59 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m22Ipxka020903
	for <linux-ext4@vger.kernel.org>; Sun, 2 Mar 2008 10:51:59 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX4007019IEY600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 02 Mar 2008 10:51:59 -0800 (PST)
In-reply-to: <20080301173059.GA6833@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 01, 2008  23:00 +0530, Aneesh Kumar K.V wrote:
> +/* FIXME!! we need to try to merge to left or right after zerout  */
> +static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
> +{
> +		done = 0;
> +		while(done < len) {
> +			ret = bio_add_page(bio, ZERO_PAGE(0), blocksize, 0);

Don't we need to set the page offset here?  

> Converting it to an API like above doesn't help much. How about 
> 
> int bio_zero_blocks(struct block_device *bdev, sector_t start, unsigned
> long bytes);
> 
> Here it implies that we would like to wait for zero out to finish.
> 
> Since we don't have another user now i didn't add the helper. But that
> should be easy.

Yes, this is probably fine too, though at that point you don't need to
have "bio" in the name since it is an internal implementation detail.

> > A related optimization is to determine the size of the remaining split
> > extents.  I propose that if either of the remaining extents are < 7
> > blocks long (or whatever, possibly 15 blocks to get a nice 64kB write) we
> > should just zero out those blocks and create a single initialized extent.
> > This would avoid the "write every alternate block" problem that could
> > grow the number of extents dramatically.
> 
> Why 64KB ?. Also while inserting the extent we try to merge with left or
> right so the problem may not be that bad. But I agree with you it
> would be nice to zero out if the split extent have very small size.

I pick 64kB since this is a good size for underlying IDE disks for track
merging and such.  Smaller IO sizes probably cause internal read-modify-
write, and if we make it too large it may cause extra overhead.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

