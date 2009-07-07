From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsck: Remove unused variable
Date: Mon, 6 Jul 2009 23:25:08 -0400
Message-ID: <20090707032508.GJ31532@mit.edu>
References: <4A51B2E0.9080002@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57261 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZGGDZH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jul 2009 23:25:07 -0400
Content-Disposition: inline
In-Reply-To: <4A51B2E0.9080002@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 06, 2009 at 05:16:32PM +0900, Kazuya Mio wrote:
> check_block_bitmap() calculates the block number of superblock in the 
> current block group but it's not used.

Thanks, applied.

						- Ted
