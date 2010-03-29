From: tytso@mit.edu
Subject: Re: 2.6.33.1: ext4 disk free weirdness
Date: Mon, 29 Mar 2010 10:53:11 -0400
Message-ID: <20100329145311.GA4671@thunk.org>
References: <20100329045748.GR2657@zip.com.au>
 <4BB0BDD2.3080100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CaT <cat@zip.com.au>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36497 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0C2P4h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 11:56:37 -0400
Content-Disposition: inline
In-Reply-To: <4BB0BDD2.3080100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 29, 2010 at 09:48:50AM -0500, Eric Sandeen wrote:
> CaT wrote:
> > Using kernel 2.6.33.1. Am rsyncing from /data/mirror (a raid0 mount) to
> > /dev/sda1 (a usb HD). Both filesystems formatted as ext3 but mounted as
> > ext4. /mnt filesystem is only being added to and currently large files
> > (iso files 700MB-4.4GB) are being copied. When I remounted /mnt as ext3
> > I could not duplicate the issue and the amount of disk used stabilised
> > at 182G. The df results, whilst /mnt is mounted as ext4, are below:
> 
> I would say this is likely speculative allocation due to delalloc
> (ext4 has to reserve worst-case metadata amounts to prepare for
> delalloc writeback).  When the file data actually gets written out,
> the worst-case reservation is freed up again.  We also flush and
> switch to nodelalloc when the filesystem is pretty close to full.
> see ext4_nonda_switch() for example.
> 
> This looks pretty severe though, more than I would expect
> from that behavior.

This is fixed in commit d330a5bef, which which got merged post
2.6.34-rc2, and which we need to get into 2.6.33 stable.  If you
cherry-pick that commit, I think you'll see that it fixes this
problem.

						- Ted
