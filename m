From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] extent whiteouts
Date: Tue, 19 Jun 2007 02:14:04 -0600
Message-ID: <20070619081404.GA27147@schatzie.adilger.int>
References: <20070514230808.GA5581@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50946 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbXFSIOH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 04:14:07 -0400
Content-Disposition: inline
In-Reply-To: <20070514230808.GA5581@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Did anyone ever see this?

This is a relatively simple (and actually safe) change to make now, but
would be harder to do as ext4 becomes more widely used.

I think all that would be needed is that when accessing an extent with
ext_pblock() (ee_start | ee_start_hi) == 0 we return zeroes, just as if
reading from an uninitialized extent or hole.  When allocating to this
extent we treat the ee_start == 0 extent similar to an uninitialized
extent, in that it needs to be split and can't merge with neighbour extents.

On May 14, 2007  17:08 -0600, Andreas Dilger wrote:
> For snapshot filesystems and in some cases where it is expected to do tree
> rebalancing it would be desirable to allow a "whiteout" for an extent.  That
> means the extent would be present in the tree, and would explicitly list
> the data blocks as a "hole" (i.e. ee_start == 0).  This is useful because
> it avoids the need to search all of the "backing" inodes to see if there is
> allocated data, and it also handles the case where the new file is truncated
> and extended (leaving a hole) but there is still data in the backing file.
> 
> Since block == 0 is not a valid data for ext3 it should never happen,
> and if it ever did happen it would be better to return all zeros (and
> not allow writing to the extent) instead of overwriting the superblock).
> 
> This would need some special casing in the extent code, but it probably
> would not be much different than what is currently the case for preallocated
> extents, and it would be a good time to add this in along with the
> preallocated extents.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
