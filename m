From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2: Fix oops in ext2_get_block() called from
 ext2_quota_write()
Date: Tue, 3 Dec 2013 16:13:28 -0500
Message-ID: <20131203211328.GB24466@thunk.org>
References: <1386071825-10915-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36180 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab3LCVNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 16:13:36 -0500
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
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

					- Ted
