From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 12:20:40 -0400
Message-ID: <20080910162040.GA17482@infradead.org>
References: <20080825202250.GY3392@webber.adilger.int> <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de> <20080910134727.GA17498@infradead.org> <20080910161037.GH4563@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYIJQUr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 12:20:47 -0400
Content-Disposition: inline
In-Reply-To: <20080910161037.GH4563@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 09:10:37AM -0700, Mark Fasheh wrote:
> Ok, aside from NO_BYPASS all your proposed changes have been made. Not sure
> about NO_BYPASS. Maybe we just update the description? In the meantime, can
> we please just put this in -mm? I'll happily do a patch on top of it all to
> rename EXTENT_NO_BYPASS once we agree on a name.

AFAICS it's meant to say "not a filesystem block but something else",
so we should say that in the flag.  Otherwise this one looks good to me.

