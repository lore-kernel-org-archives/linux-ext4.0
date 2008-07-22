From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext* free space fragmentation reporting
Date: Mon, 21 Jul 2008 22:59:35 -0400
Message-ID: <20080722025935.GL28839@mit.edu>
References: <20080721211334.GP3370@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33602 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbYGVC75 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2008 22:59:57 -0400
Content-Disposition: inline
In-Reply-To: <20080721211334.GP3370@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2008 at 03:13:34PM -0600, Andreas Dilger wrote:
> We wrote a tool for Lustre which reports the free space fragmentation in
> ext* filesystems.  There was a request on linuxfs to get a copy of this
> patch, and I thought it would be potentially useful for others as well.
> The patch is against 1.40.11, but I don't think it would need to change
> much (if any) for 1.40.1 because it only uses public libext2fs interfaces.

Thanks, I'll look at this.  Speaking of which, a week or two ago I was
going through the clusterfs patches to see if there was anything I had
missed for 1.41.0 that should either go into 1.42 or 1.41.1, and I
noticed there were a number of extra tools, of which freefrag was but
one.

Can I assume a signed-off by "Andreas Dilger <adilger@sun.com>" for
any of the Clusterfs/Sun e2fsprogs patches in the public patches
directory?  Are there any other user programs in particular that
should be included?

						- Ted
