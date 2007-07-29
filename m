From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 20:24:37 +0100
Message-ID: <20070729192437.GB14530@infradead.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org> <20070729173035.GU5992@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762019AbXG2TYk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2007 15:24:40 -0400
Content-Disposition: inline
In-Reply-To: <20070729173035.GU5992@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 29, 2007 at 11:30:36AM -0600, Andreas Dilger wrote:
> Sigh, we HAVE a patch that was only adding delalloc to ext4, but it
> was rejected because "that functionality should go into the VFS".
> Since the performance improvement of delalloc is quite large, we'd
> like to get this into the kernel one way or another.  Can we make a
> decision if the ext4-specific delalloc is acceptable?

I'm a big proponent of having proper common delalloc code, but the
one proposed here is not generic for the existing filesystem using
delalloc.  It's still on my todo list to revamp the xfs code to get
rid of some of the existing mess and make it useable genericly.  If
the ext4 users are fine with the end result we could move to generic
code.

Note that moving to VFS is bullshit either way, writeback code is
nowhere near the VFS nor should it.
