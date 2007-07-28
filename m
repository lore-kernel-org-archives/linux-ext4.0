From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sat, 28 Jul 2007 20:51:14 +0100
Message-ID: <20070728195114.GA5952@infradead.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53119 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbXG1TvY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Jul 2007 15:51:24 -0400
Content-Disposition: inline
In-Reply-To: <46A87858.40005@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 26, 2007 at 06:32:56AM -0400, Jeff Garzik wrote:
> Is this based on Christoph's work?
> 
> Christoph, or some other XFS hacker, already did generic delalloc, 
> modeled on the XFS delalloc code.

This is not based on my attempt to make the xfs writeout path generic.
Alex's variant is a lot simpler and thus missed various bits required
for high sustained writeout performance or xfs functionality.

That doesn't mean I want to arge against Alex's code although I'd of
course be more happy if we could actually shared code between multiple
filesystems.

Of ourse the code in it's current form should not go into mpage.c but
rather into ext4 so that it doesn't bloat the kernel for everyone.
