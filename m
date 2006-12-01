From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 0/4] BIG_BG: support of large block groups
Date: Fri, 1 Dec 2006 04:06:55 -0800
Message-ID: <20061201120655.GN6429@schatzie.adilger.int>
References: <1164386860.17961.67.camel@ckrm> <20061129172318.GD5771@thunk.org> <456EF615.1090205@bull.net> <20061130194102.GA10999@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53435 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1030823AbWLAMG5
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Dec 2006 07:06:57 -0500
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061130194102.GA10999@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 30, 2006  14:41 -0500, Theodore Tso wrote:
> * We ignore the problem, and accept that there are some kinds of
> filesystem corruptions which e2fsck will not be able to fix --- or at
> least not without adding complexity which would allow it to relocate
> data blocks in order to make a contiguous range of blocks to be used
> for the allocation bitmaps.  
> 
> The last alternative sounds horrible, but if we assume that some other
> layer (i.e., the hard drive's bad block replacement pool) provides us
> the illusion of a flawless storage media, and CRC to protect metadata
> will prevent us from relying on an corrupted bitmap block, maybe it is
> acceptable that e2fsck may not be able to fix certain types of
> filesystem corruption.

I'd agree that even with media errors, the bad-block replacement pool
is almost certainly available to handle this case.  Even if there are
media errors on the read of the bitmap, they will generally go away
if the bitmap is rewritten (because of relocation).  At worst, we
would no longer allow new blocks/inodes to be allocated that are
tracked by that block, and if we are past 256TB then the sacrifice
of 128MB of space is not fatal.  It wouldn't even have to impact any
files that are already allocated in that space.

> without any of these protections, I'd want to keep the block group
> size under 32k so we can avoid dealing with these issues for as long
> as possible.  Even if we assume laptop drives will double in size
> every 12 months, we still have a good 10+ years before we're in danger
> of seeing a 512TB laptop drives.  :-)

Agreed, I think there isn't any reason to increase the group size
unless it is really needed, or it is specified with "mke2fs -g {blocks}"
or the number of inodes requires it.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
