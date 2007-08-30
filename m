From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH V2] fix mballoc oopses on mkdir
Date: Thu, 30 Aug 2007 08:31:47 -0600
Message-ID: <20070830143147.GX5377@schatzie.adilger.int>
References: <46D39776.2090103@redhat.com> <46D3A390.5000202@redhat.com> <46D3B1AE.40408@redhat.com> <20070828194628.GV5377@schatzie.adilger.int> <46D48592.4030704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:47886 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbXH3ObY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 10:31:24 -0400
Content-Disposition: inline
In-Reply-To: <46D48592.4030704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 28, 2007  15:29 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> >> (there are 54 BUGs and BUG_ONs in this file...!)
> > 
> > Yes, we like lots of assertions in our code, because it is exceedingly
> > complex to debug otherwise.
> 
> But wouldn't error recovery be a better choice?  You could macro-ize it
> to BUG for development purposes if you wanted, I suppose...

No, the goal is if something "impossible" happens you want to stop dead
at that point instead of continuing to work in an unknown environment.
I believe that all of the extents/mballoc code will NOT BUG on bad data
from disk.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
