From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/3] e2fsck: Fix loop counter properly
Date: Mon, 6 Jul 2009 23:24:51 -0400
Message-ID: <20090707032451.GI31532@mit.edu>
References: <4A51B29C.6020703@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57255 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbZGGDYu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jul 2009 23:24:50 -0400
Content-Disposition: inline
In-Reply-To: <4A51B29C.6020703@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 06, 2009 at 05:15:24PM +0900, Kazuya Mio wrote:
> If unused range of the bitmap has an unmarked bit,
> check_[inode/block]_end() marks all bits in the range. However, we
> know that the checked bits are marked.  So this patch fixes loop
> counter to mark from the unmarked bit.

Thanks, applied.

						- Ted
