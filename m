From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix memleak in ext4_readdir()
Date: Tue, 16 Feb 2016 00:25:05 -0500
Message-ID: <20160216052505.GB3426@thunk.org>
References: <569E4B40.3060506@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dmonakhov@virtuozzo.com
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39628 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbcBPFZJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2016 00:25:09 -0500
Content-Disposition: inline
In-Reply-To: <569E4B40.3060506@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 19, 2016 at 05:42:08PM +0300, Kirill Tkhai wrote:
> When ext4_bread() fails, fname_crypto_str remains
> allocated after return. Fix that.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> CC: Theodore Ts'o <tytso@mit.edu>
> CC: Dmitry Monakhov <dmonakhov@virtuozzo.com>

Applied, thanks.

					- Ted
