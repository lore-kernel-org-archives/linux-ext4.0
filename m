From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Date: Fri, 25 Dec 2009 11:14:53 -0500
Message-ID: <20091225161453.GD32757@thunk.org>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
 <19251.26403.762180.228181@tree.ty.sabi.co.uk>
 <20091224212756.GM21594@thunk.org>
 <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, xfs@oss.sgi.com,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59134 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZLYQPG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Dec 2009 11:15:06 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 24, 2009 at 05:52:34PM -0800, Christian Kujau wrote:
> 
> Well, I do "sync" after each operation, so the data should be on disk, but 
> that doesn't mean it'll clear the filesystem buffers - but this doesn't 
> happen that often in the real world too. Also, all filesystem were tested 
> equally (I hope), yet some filesystem perform better than another - even 
> if all the content copied/tar'ed/removed would perfectly well fit into the 
> machines RAM.

Did you include the "sync" in part of what you timed?  Peter was quite
right --- the fact that the measured bandwidth in your "cp" test is
five times faster than the disk bandwidth as measured by hdparm, and
many file systems had exactly the same bandwidth, makes me very
suspicious that what was being measured was primarily memory bandwidth
--- and not very useful when trying to measure file system
performance.

    	 	     	       	       	    - Ted
