From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext2: Fix oops in ext2_get_block() called from
 ext2_quota_write()
Date: Wed, 4 Dec 2013 03:01:41 -0800
Message-ID: <20131204110141.GB3263@infradead.org>
References: <1386071825-10915-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3LDLBm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 06:01:42 -0500
Content-Disposition: inline
In-Reply-To: <1386071825-10915-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 12:57:05PM +0100, Jan Kara wrote:
> ext2_quota_write() doesn't properly setup bh it passes to
> ext2_get_block() and thus we hit assertion BUG_ON(maxblocks == 0) in
> ext2_get_blocks() (or we could actually ask for mapping arbitrary number
> of blocks depending on whatever value was on stack).
> 
> Fix ext2_quota_write() to properly fill in number of blocks to map.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
