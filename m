From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks
 to Uninit Exts
Date: Thu, 3 Mar 2011 07:23:13 +1100
Message-ID: <20110302202313.GA15097@dastard>
References: <4D6C6318.2010105@linux.vnet.ibm.com>
 <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55344 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997Ab1CBUXQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Mar 2011 15:23:16 -0500
Content-Disposition: inline
In-Reply-To: <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 11:42:48PM -0700, Andreas Dilger wrote:
> On 2011-02-28, at 8:08 PM, Allison Henderson wrote:
> > This first patch adds a function to convert a range of blocks
> > to an uninitialized extent.  This function will
> > be used to first convert the blocks to extents before
> > punching them out.
> 
> This was proposed as a separate function for FALLOCATE by Dave
> Chinner (based on XFS_IOC_ZERO_RANGE), so this is useful as a
> standalone function.

XFS_IOC_ZERO_RANGE converts a range to unwritten extents, not
uninitialised extents. An uninitialised extent is one that is
allocated but had not data written to it (i.e. contains stale data),
while an unwritten/preallocated extent is guaranteed to contain
zeros.  This may be just a terminology issue, but we should try to
use the same jargon across all filesystems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
