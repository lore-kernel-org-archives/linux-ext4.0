From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Take advantage of kmem_cache_zalloc() in
 ext4_init_io_end()
Date: Sun, 19 Dec 2010 21:44:55 -0500
Message-ID: <20101220024455.GB24990@thunk.org>
References: <alpine.LNX.2.00.1012092257290.25880@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47090 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab0LTCo7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Dec 2010 21:44:59 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012092257290.25880@swampdragon.chaosbits.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 09, 2010 at 12:17:34PM -0000, Jesper Juhl wrote:
> Take advantage of kmem_cache_zalloc(). Save a memset() call in 
> ext4_init_io_end() and save a few bytes.
> 
> Before:
>  [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
>     text    data     bss     dec     hex filename
>     3016       0     624    3640     e38 fs/ext4/page-io.o
> After:
>  [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
>     text    data     bss     dec     hex filename
>     3000       0     624    3624     e28 fs/ext4/page-io.o
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, added to the ext4 patch queue.

						- Ted
