From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: Use unsigned long long for file block count in
 filefrag
Date: Sun, 23 Feb 2014 08:58:34 -0500
Message-ID: <20140223135834.GC2280@thunk.org>
References: <20140223091251.3545C47E837@yourcmc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vitaliy Filippov <vitalif@yourcmc.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33065 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaBWN6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 08:58:39 -0500
Content-Disposition: inline
In-Reply-To: <20140223091251.3545C47E837@yourcmc.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 23, 2014 at 01:08:47PM +0400, Vitaliy Filippov wrote:
> This patch fixes incorrect reporting of file block count on 32-bit platforms.

Hi Vitaliy,

Thanks for the patch!  Your patch is missing a Signed-Off-By footer.
Also, you note that numblocks gets passed to filefrag_fibmap(), so if
you're going to do this, and we fall back to using fibmap, you should
probably check to see if numblocks would overflow an unsigned long,
and if so, to give an error because fibmap ioctl only supports the use
of a ulong.

Cheers,

					- Ted
