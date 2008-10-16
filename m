From: Nick Piggin <npiggin@suse.de>
Subject: Re: minix/ext2 + rd problem
Date: Thu, 16 Oct 2008 05:48:12 +0200
Message-ID: <20081016034812.GA10371@wotan.suse.de>
References: <alpine.DEB.1.10.0810141631130.30331@krichy.tvnetwork.hu> <20081015041644.GA24613@wotan.suse.de> <alpine.DEB.1.10.0810150943350.3259@krichy.tvnetwork.hu> <20081015140523.GA30641@wotan.suse.de> <alpine.DEB.1.10.0810151609230.21953@krichy.tvnetwork.hu> <20081015143425.GA2316@wotan.suse.de> <20081015192254.GL15064@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Kojedzinszky <krichy@tvnetwork.hu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:42893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbYJPDs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 23:48:27 -0400
Content-Disposition: inline
In-Reply-To: <20081015192254.GL15064@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 15, 2008 at 01:22:54PM -0600, Matthew Wilcox wrote:
> On Wed, Oct 15, 2008 at 04:34:25PM +0200, Nick Piggin wrote:
> > You can flush and invalidate the blockdev with the --flushbufs argument
> > to blockdev command. However you can't use this with ramdisk devices:
> > someone thought it would be a good idea to save on precious ioctl space
> > and implemented totally different semantics on that device with the
> > same ioctl (it throws away the underlying data as well as the cache).
> 
> What happens if we declare that a bug and fix it (and add a new ioctl to
> actually throw away the data ... oh, wait, we have one, it's BLKDISCARD)?

Well... that's a good point. We probably could, because the worst someone
will see is their backing store memory does not get freed. It won't munch
someone's data.

I'd love to do this, OTOH we've had the old behaviour, apparently documented
and used by someone at some point, for a long time :(
