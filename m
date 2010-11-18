From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Thu, 18 Nov 2010 09:29:18 -0500
Message-ID: <20101118142918.GA18510@infradead.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0KRO3V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 09:29:21 -0500
Content-Disposition: inline
In-Reply-To: <20101118141957.GK6178@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 07:19:58AM -0700, Matthew Wilcox wrote:
> I guess I was assuming that, on receiving a FALLOC_FL_PUNCH_HOLE, a
> filesystem that was TRIM-aware would pass that information down to the
> block device that it's mounted on.  I strongly feel that we shouldn't
> have two interfaces to do essentially the same thing.
> 
> I guess I'm saying that you're going to have to learn about TRIM :-)

Did you actually look Lukas FITRIM code (not the slight reordering here,
but the original one).  It's the ext4 version of the batched discard
model, that is a userspace ioctl to discard free space in the
filesystem.

hole punching will free the blocks into the free space pool.  If you do
online discard it will also get discarded, but a filesystem that has
online discard enabled doesn't need FITRIM.

