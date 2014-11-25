From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unneeded code in ext4_unlink
Date: Tue, 25 Nov 2014 16:47:53 -0500
Message-ID: <20141125214753.GG28449@thunk.org>
References: <003601d007b1$ffde29e0$ff9a7da0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51690 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaKYVry (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 16:47:54 -0500
Content-Disposition: inline
In-Reply-To: <003601d007b1$ffde29e0$ff9a7da0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2014 at 03:43:47PM +0900, Namjae Jeon wrote:
> Setting retval to zero is not needed in ext4_unlink.
> Remove unneeded code.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Thanks, applied.

				- Ted
