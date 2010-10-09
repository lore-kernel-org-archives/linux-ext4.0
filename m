From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] vfs: Implement generic per-cpu counters for delayed
 allocation
Date: Sat, 9 Oct 2010 03:44:46 -0400
Message-ID: <20101009074446.GA15551@infradead.org>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
 <1286583147-14760-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0JIHou (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Oct 2010 03:44:50 -0400
Content-Disposition: inline
In-Reply-To: <1286583147-14760-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 09, 2010 at 02:12:26AM +0200, Jan Kara wrote:
> Implement free blocks and reserved blocks counters for delayed allocation.
> These counters are reliable in the sence that when they return success, the
> subsequent conversion from reserved to allocated blocks always succeeds (see
> comments in the code for details). This is useful for ext3 filesystem to
> implement delayed allocation in particular for allocation in page_mkwrite.

This doesn't really look like generic code that should go into the core
kernel.  I'd just add it to ext3 directly.

