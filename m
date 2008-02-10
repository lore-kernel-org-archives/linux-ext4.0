From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ext4: move headers out of include/linux
Date: Sun, 10 Feb 2008 07:52:22 +0100
Message-ID: <20080210065222.GA22951@lst.de>
References: <20080209093933.GA5882@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org
To: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34126 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYBJGyQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 01:54:16 -0500
Content-Disposition: inline
In-Reply-To: <20080209093933.GA5882@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 09, 2008 at 10:39:33AM +0100, Christoph Hellwig wrote:
> Move ext4 headers out of include/linux.  This is just the trivial move,
> there's some more thing that could be done later.
> 
> Ted, is anything of these shared with e2fsprogs or can we rip out all
> that #ifdef __KERNEL__ junk?
> 
> Note that I plan to submit similar patches for ext2 and ext3 aswell,
> so the diverging from them argument doesn't count.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like the patch is to big for vger.  Here's a link instead:

http://verein.lst.de/~hch/ext4-move-headers
