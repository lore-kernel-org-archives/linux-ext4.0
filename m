From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic: add fallocate() checks to generic/300
Date: Mon, 14 Apr 2014 10:29:43 +1000
Message-ID: <20140414002942.GD27694@dastard>
References: <20140411214307.GC10174@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50025 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaDNA3q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 20:29:46 -0400
Content-Disposition: inline
In-Reply-To: <20140411214307.GC10174@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 11, 2014 at 05:43:07PM -0400, Eric Whitney wrote:
> Generic/300 fails when run on a test filesystem that does not support
> fallocate(). It uses fio's falloc ioengine to generate part of its I/O
> load and both allocates blocks and punches holes.  This causes EOPNOTSUPP
> failures when the test is run on indirect block-mapped ext4 filesystems
> or pre-3.14 ext4 filesystems created with bigalloc.
> 
> Verify that the test filesystem supports fallocate() before proceeding
> with the test, checking for both block allocation and hole punching
> capabilities.  Also, delete any pre-existing test output.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Makes sense. Same for the second patch, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
