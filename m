From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/4] fs: Avoid data corruption with blocksize < pagesize
Date: Wed, 18 Mar 2009 13:00:23 +0100
Message-ID: <20090318120022.GB14622@wotan.suse.de>
References: <1237311235-13623-1-git-send-email-jack@suse.cz> <1237311235-13623-2-git-send-email-jack@suse.cz> <1237311235-13623-3-git-send-email-jack@suse.cz> <1237311235-13623-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:34334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZCRMDU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 08:03:20 -0400
Content-Disposition: inline
In-Reply-To: <1237311235-13623-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 17, 2009 at 06:33:54PM +0100, Jan Kara wrote:
> Assume the following situation:
> Filesystem with blocksize < pagesize - suppose blocksize = 1024,
> pagesize = 4096. File 'f' has first four blocks already allocated.
> (line with "state:" contains the state of buffers in the page - m = mapped,
> u = uptodate, d = dirty)
> 
>   process 1:                       process 2:
> 
> write to 'f' bytes 0 - 1024
>   state: |mud,-,-,-|, page dirty
>                                    write to 'f' bytes 1024 - 4096:
>                                      __block_prepare_write() maps blocks
>                                        state: |mud,m,m,m|, page dirty
>                                      we fail to copy data -> copied = 0
>                                      block_write_end() does nothing
>                                      page gets unlocked
> writepage() is called on the page
>   block_write_full_page() writes buffers with garbage
> 
> This patch fixes the problem by skipping !uptodate buffers in
> block_write_full_page().
> 
> CC: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 9f69741..22c0144 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1774,7 +1774,12 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	} while (bh != head);
>  
>  	do {
> -		if (!buffer_mapped(bh))
> +		/*
> +		 * Parallel write could have already mapped the buffers but
> +		 * it then had to restart before copying in new data. We
> +		 * must avoid writing garbage so just skip the buffer.
> +		 */
> +		if (!buffer_mapped(bh) || !buffer_uptodate(bh))
>  			continue;

I don't quite see how this can happen. Further down in this loop,
we do a test_clear_buffer_dirty(), which should exclude this I
think? And marking the buffer dirty if it is not uptodate should
be a bug.

