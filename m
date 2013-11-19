From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 03:01:47 -0800
Message-ID: <20131119110147.GA3323@infradead.org>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
 <20131119104508.GA4630@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3KSLBr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 06:01:47 -0500
Content-Disposition: inline
In-Reply-To: <20131119104508.GA4630@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 19, 2013 at 06:45:08PM +0800, Zheng Liu wrote:
> BTW, that would be great if you could give me some comments about this
> problem itself.  Is it a generic problem in vfs?  Or just a feature by
> design?

It seems like a fundamental issue with ext4 (and most older Linux
filesystems) trying to do dio reads without locking out writers.

If you have a shared/exclusive lock to protect dio reads against
buffered or appending writers like XFS does this issue is properly
prevented.
