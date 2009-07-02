From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH-e2fsprogs-resend] filefrag: fix fm_start in
	filefrag_fiemap loop
Date: Thu, 2 Jul 2009 00:24:59 -0400
Message-ID: <20090702042459.GB22615@mit.edu>
References: <1244078320-13888-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35341 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZGBEZB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jul 2009 00:25:01 -0400
Content-Disposition: inline
In-Reply-To: <1244078320-13888-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2009 at 09:18:40AM +0800, Peng Tao wrote:
> When used with -v and the targeted file has more than 144 extents(double of
> the length of fm_extents array provided by buf), filefrag_fiemap loops and
> calls fiemap ioctl() multiple times to calculate the actual number of extents
> in a file. Each call to fiemap ioctl() uses  fm_start as the starting logical
> offset. The patch fixes fm_start in each loop( except for the first one) and
> makes the extent calculation correct for files with more that 144 extents.  
> 
> To produce the problem, first run filefrag -v on a highly fragmented file.
> Then change the buf size in filefrag_fiemap to make it large enough to have
> all the extent mapped in a single loop and run filefrag -v after recompiling.
> The former will produce a much smaller extent count because of the false
> fm_start used in the loop. And the two will produce different extent output
> since the 145th extent.

Thanks, applied.

						- Ted
