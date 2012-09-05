From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/15 v2] mm: add invalidatepage_range address space
 operation
Date: Wed, 5 Sep 2012 11:56:48 -0400
Message-ID: <20120905155648.GA15985@infradead.org>
References: <1346451711-1931-1-git-send-email-lczerner@redhat.com>
 <1346451711-1931-2-git-send-email-lczerner@redhat.com>
 <20120904164316.6e058cbe.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1209051002310.509@new-host-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, hughd@google.com, linux-mm@kvack.org
To: Luk?? Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50299
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab2IEP4w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Sep 2012 11:56:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1209051002310.509@new-host-2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 05, 2012 at 10:36:00AM -0400, Luk?? Czerner wrote:
> However if we would want to keep ->invalidatepage_range() and
> ->invalidatepage() completely separate then we would have to have
> separate truncate_inode_pages_range() and truncate_pagecache_range()
> as well for the separation to actually matter. And IMO this would be
> much worse...

What's the problem with simply changing the ->invalidatepage prototype
to always pass the range and updating all instances for it?

