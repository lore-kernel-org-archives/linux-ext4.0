From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks to Uninit Exts
Date: Thu, 3 Mar 2011 09:27:27 -0500
Message-ID: <CEC1AE6D-C518-471D-BC2B-C29F1269DA5A@mit.edu>
References: <4D6C6318.2010105@linux.vnet.ibm.com> <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca> <20110302202313.GA15097@dastard>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:65411 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758331Ab1CCOg2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 09:36:28 -0500
In-Reply-To: <20110302202313.GA15097@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mar 2, 2011, at 3:23 PM, Dave Chinner wrote:

> 
> XFS_IOC_ZERO_RANGE converts a range to unwritten extents, not
> uninitialised extents. An uninitialised extent is one that is
> allocated but had not data written to it (i.e. contains stale data),
> while an unwritten/preallocated extent is guaranteed to contain
> zeros.  This may be just a terminology issue, but we should try to
> use the same jargon across all filesystems...

What is the difference from the user's perspective?  If the read from
from an uninitialized extent, what do they get back?   And if the read
from an unwritten extent, what do they get back?   In ext4, in both
cases we would return all zero's.

For XFS, why is it important to maintain the distinction between these
two concept?

Just trying to understand,

-- Ted


