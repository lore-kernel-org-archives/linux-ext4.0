From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4_zero_range: fix incorect journal credits
 reservation
Date: Sat, 23 Aug 2014 15:08:35 -0400
Message-ID: <20140823190835.GB6236@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46117 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaHWTJF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Aug 2014 15:09:05 -0400
Content-Disposition: inline
In-Reply-To: <1408707147-22482-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 22, 2014 at 03:32:25PM +0400, Dmitry Monakhov wrote:
> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 4);
> +	/* In worst case we have to writeout two nonadjacent unwritten blocks */
> +	credits = ext4_chunk_trans_blocks(inode, 1) * 2 -
> +		EXT4_META_TRANS_BLOCKS(inode->i_sb);

This looks like it would be a massive over-estimate, since it includes
the block group allocation bitmaps, which we wouldn't need to update,
no?

Wouldn't

	credts = ext4_index_trans_blocks(inode, 1, 1) * 2;

be sufficient?

					- Ted
