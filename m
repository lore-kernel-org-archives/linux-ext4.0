From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Wed, 7 Mar 2012 11:51:30 +1100
Message-ID: <20120307005130.GH3592@dastard>
References: <20120305125029.GA5121@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34145 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932701Ab2CGAve (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:51:34 -0500
Content-Disposition: inline
In-Reply-To: <20120305125029.GA5121@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 08:50:29PM +0800, Zheng Liu wrote:
> Hi list,
> 
> Block allocation is a key component of file system.  Every file systems try to
> improve the performance with optimizing the block allocation of a file.  But no
> matter what file system does, it just guesses what the user expects.  Thus, it
> is not very accurate.  fadvise(2) provides a method to let the user to give a
> hint to file system.  However, until now, only few flags are provided.  So we
> can provide more flags to tell file system how to allocate the blocks for a
> file.
> 
> For example:
> we can add these flags into fadvise(2):
> FADV_ALLOC_READ_SEQ

fallocate()

> FADV_ALLOC_READ_RANDOM

Allocation can't be optimised as the read pattern cannot be defined.

> FADV_ALLOC_WRITE_ONCE

fallocate()

> FADV_ALLOC_WRITE_APPEND

chattr +a

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
