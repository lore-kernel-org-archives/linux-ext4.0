From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Ordered mode rewrite patch
Date: Tue, 8 Apr 2008 08:19:37 -0400
Message-ID: <20080408121937.GA26650@infradead.org>
References: <20080408121149.GB6901@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Grennan <jack@cygnusx-1.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYDHMTl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2008 08:19:41 -0400
Content-Disposition: inline
In-Reply-To: <20080408121149.GB6901@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2008 at 02:11:49PM +0200, Jan Kara wrote:
> -		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
> +		} else if (!buffer_mapped(bh) && buffer_dirty(bh)
> +			   && !wbc->skip_unmapped) {

As mentioned last time unmapped buffer shouldn't happen anymore with
filesystem updated to have a ->page_mkwrite operations.  As you've
included the ext3 patch in yours the above condition shoujldn't git
anymore.

