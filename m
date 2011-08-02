From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39 and 3.0 scalability measurement results
Date: Tue, 2 Aug 2011 10:50:12 +1000
Message-ID: <20110802005012.GD12870@dastard>
References: <4E361630.9060907@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37687 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab1HBAuR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 20:50:17 -0400
Content-Disposition: inline
In-Reply-To: <4E361630.9060907@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 31, 2011 at 10:57:52PM -0400, Eric Whitney wrote:
> I've posted the results of my 2.6.38/2.6.39 and 2.6.39/3.0 ext4
> scalability measurements and comparisons on a 48 core x86_64 server
> at:
> 
> http://free.linux.hp.com/~enw/ext4/2.6.39
> 
> http://free.linux.hp.com/~enw/ext4/3.0
> 
> The results include throughput and CPU efficiency graphs for five
> simple workloads, the raw data for same, and lockstats as well.
> 
> The data cover ext4 filesystems with and without journals.  For
> reference, ext3, xfs, and btrfs are included as well.

Can you include the output of the mkfs programs so that we can see
what the structure of the filesystems are? That makes a big
difference when interpreting the XFS results.

And FWIW, I'd be really interested to see the XFS results using the
inode64 mount option, rather then the not-really-ideal-for-multi-TB-
filesystems-but-used-historically-for-32-bit-application-
compatibility-reasons default of inode32.

inode64 drastically changes the layout of files and directories in
the filesystems, so I'd expect to see significant differences (good
and bad!) in the workloads using that option. We've been considering
changing it to be the default, so having some idea of how it
compares on your worklaods woul dbe an interesting discussion
point...

BTW, seeing as you are running against multiple diffferent
filesytems, can you cc these emails to linux-fsdevel rather than
just the ext4 list? There is wider interest in your results than
just ext4 developers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
