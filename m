From: Christoph Hellwig <hch@infradead.org>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Thu, 26 May 2016 00:02:17 -0700
Message-ID: <20160526070217.GA12151@infradead.org>
References: <57448A5D.4050805@siemens.com>
 <20160526022020.GG26977@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gernot Hillier <gernot.hillier@siemens.com>,
	linux-ext4@vger.kernel.org, guillem@debian.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbcEZHCU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 May 2016 03:02:20 -0400
Content-Disposition: inline
In-Reply-To: <20160526022020.GG26977@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2016 at 12:20:20PM +1000, Dave Chinner wrote:
> Stupid question: why is dpkg using fallocate() for such small ranges
> like that? I can't think of a more inefficient way to do small IO -
> using delayed allocation is far more optimal from a layout,
> overhead, latency and IO perspective than the above forced
> allocation pseudo-synchronous write behaviour.

Below is the commit adding it.  Guillem, can you explain what fallocate
in the dpkg is supposed to help with?  The way it's it does fallocate
before writes that aren't spare it looks actively harmful for any 
Linux file system.

commit 87b0b20b86407baf1deb4e91b3fd839e01228ac8
Author: Guillem Jover <guillem@debian.org>
Date:   Tue Jul 15 21:00:52 2014 +0200

    dpkg: Try to preallocate the disk size for extracted files
        
    This might help in avoiding filesystem fragmentation, and possibly
    improve performance on some filesystems.
		    
    We use the system specific methods if available, and possibly
    improve performance on some filesystems.

    We use the system specific methods if available, and only use
    posix_fallocate() if nothing else is available, because on some systems
    its semantics are counter to what we want to obtain here, as the libc
    library will fallback to manually writing '\0' to each block to force
    the preallocation, instead of just failing and leaving the application
    to do so if desired.
