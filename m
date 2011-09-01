From: Dave Chinner <david@fromorbit.com>
Subject: Re: lock i_mutex for fallocate?
Date: Thu, 1 Sep 2011 17:08:48 +1000
Message-ID: <20110901070848.GQ32358@dastard>
References: <4E5ED2D5.8040302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:46639 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636Ab1IAHIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2011 03:08:51 -0400
Content-Disposition: inline
In-Reply-To: <4E5ED2D5.8040302@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:33:25PM -0700, Allison Henderson wrote:
> Hi All,
> 
> In ext4 punch hole, we realized that the punch hole operation needs
> to be done under i_mutex just like truncate.  i_mutex for truncate
> is held in the vfs layer, so we dont need to lock it at the file
> system layer, but vfs does not lock i_mutex for fallocate.  We can
> lock i_mutex for fallocate at the fs layer, but question was raised
> then: should i_mutex for fallocate be held in the vfs layer instead?

No.

> I do not know if other file systems need i_mutex to be locked for
> fallocate,

For one, XFS does not require i_mutex to be held for any extent
manipulation of any kind (allocation, truncation, hole punch,
unwritten extent conversion, etc).

Hence the current structure of having the filesystem take i_mutex if
it needs it to protect allocations against races is appropriate.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
