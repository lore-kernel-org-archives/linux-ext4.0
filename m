From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [1/4] e2p: Fix 's' handling in parse_num_blocks2()
Date: Thu, 28 Feb 2013 20:13:14 -0500
Message-ID: <20130301011314.GC18134@thunk.org>
References: <1361807708-15871-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50667 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab3CABN3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Feb 2013 20:13:29 -0500
Content-Disposition: inline
In-Reply-To: <1361807708-15871-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 05:55:05AM -0000, Jan Kara wrote:
> parse_num_blocks2() wrongly did:
> 	num << 1;
> when log_block_size < 0. That is obviously wrong as such statement has
> no effect (and the compiler properly warns about it). Callers expect
> returned value to be in bytes when log_block_size < 0 so fix the
> statement accordingly.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
