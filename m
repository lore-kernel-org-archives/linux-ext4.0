From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: Remove misplaced BUFFER_TRACE() in ext3_truncate()
Date: Mon, 18 Oct 2010 09:22:29 -0500
Message-ID: <4CBC5825.8050502@redhat.com>
References: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab0JROWq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 10:22:46 -0400
In-Reply-To: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/inode.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 5e0faf4..90a9c3d 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2530,7 +2530,6 @@ void ext3_truncate(struct inode *inode)
>  			 */
>  		} else {
>  			/* Shared branch grows from an indirect block */
> -			BUFFER_TRACE(partial->bh, "get_write_access");
>  			ext3_free_branches(handle, inode, partial->bh,
>  					partial->p,
>  					partial->p+1, (chain+n-1) - partial);

As long as you're doing these cleanups, you may as well eyeball ext4
to see whether the same issues exist; in the case above, it does, and the
exact same patch (modulo ext3/ext4 changes) applies.

No real point in getting ext3 fixed up and leaving ext4 behind...

Thanks,
-Eric
