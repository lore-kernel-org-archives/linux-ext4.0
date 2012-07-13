From: Dave Chinner <david@fromorbit.com>
Subject: Re: e2fsprogs alignment issues
Date: Sat, 14 Jul 2012 08:25:31 +1000
Message-ID: <20120713222531.GB2920@dastard>
References: <4FFD7D9B.2080503@bobich.net>
 <4FFD9613.3050305@redhat.com>
 <20120711200557.GB5838@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Gordan Bobic <gordan@bobich.net>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:49086 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab2GMWZf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jul 2012 18:25:35 -0400
Content-Disposition: inline
In-Reply-To: <20120711200557.GB5838@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 11, 2012 at 04:05:57PM -0400, Theodore Ts'o wrote:
> I will *not* accept a patch which uses memcpy to copy each field in
> the on-disk superblock, or directory entry, into an int, just in case
> there is some insane architecture which requires that 4 byte integers
> be 32-byte aligned, or something else insane like that.

This is a problem we've had to deal with in the XFS userspace for
years because of the way extent records are packed into inodes.
Hence we have "get/set_unaligned_be32" and "get/set_unaligned_be64"
functions to read and write unaligned variables directly out of
buffers without having platform specific alignment issues. It's
exactly the same generic code as the kernel uses for this purpose.
See libxfs/xfs.h....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
