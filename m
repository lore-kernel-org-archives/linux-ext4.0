From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext* free space fragmentation reporting
Date: Tue, 22 Jul 2008 01:05:21 -0600
Message-ID: <20080722070521.GA16621@webber.adilger.int>
References: <20080721211334.GP3370@webber.adilger.int>
 <20080722025935.GL28839@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62165 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYGVHF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 03:05:29 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6M75RQA021933
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 00:05:28 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4E00L01BN93E00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 22 Jul 2008 00:05:27 -0700 (PDT)
In-reply-to: <20080722025935.GL28839@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2008  22:59 -0400, Theodore Ts'o wrote:
> On Mon, Jul 21, 2008 at 03:13:34PM -0600, Andreas Dilger wrote:
> > We wrote a tool for Lustre which reports the free space fragmentation in
> > ext* filesystems.  There was a request on linuxfs to get a copy of this
> > patch, and I thought it would be potentially useful for others as well.
> > The patch is against 1.40.11, but I don't think it would need to change
> > much (if any) for 1.40.1 because it only uses public libext2fs interfaces.
> 
> Thanks, I'll look at this.  Speaking of which, a week or two ago I was
> going through the clusterfs patches to see if there was anything I had
> missed for 1.41.0 that should either go into 1.42 or 1.41.1, and I
> noticed there were a number of extra tools, of which freefrag was but
> one.
> 
> Can I assume a signed-off by "Andreas Dilger <adilger@sun.com>" for
> any of the Clusterfs/Sun e2fsprogs patches in the public patches
> directory?

Yes.

> Are there any other user programs in particular that should be included?

The other one that we've worked on is e2scan - it implements a fast
scan of the inode table to find modified files for backup/rsync/etc.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

