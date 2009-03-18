From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 4/4] fs: Warn about writing !uptodate buffers
Date: Wed, 18 Mar 2009 23:07:54 +1100
Message-ID: <200903182307.54737.nickpiggin@yahoo.com.au>
References: <n> <1237311235-13623-4-git-send-email-jack@suse.cz> <1237311235-13623-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:26044 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757777AbZCRMIH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 08:08:07 -0400
In-Reply-To: <1237311235-13623-5-git-send-email-jack@suse.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 18 March 2009 04:33:55 Jan Kara wrote:
> Make submit_bh() warn about writing !uptodate buffers. Hopefully this
> warns us about writing garbage (although bugs in write EIO handling
> are going to trigger this as well as they already trigger the warning
> in mark_buffer_dirty()).
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 22c0144..985f617 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2997,6 +2997,8 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(!buffer_locked(bh));
>  	BUG_ON(!buffer_mapped(bh));
>  	BUG_ON(!bh->b_end_io);
> +	if (rw & WRITE)
> +		WARN_ON_ONCE(!buffer_uptodate(bh));

Yes very nice assertion to have. Arguably I think it should be a BUG_ON
because it is definitely some state corruption at least, and writing
garbage data to disk at worst. But WARN_ON for now is probably best.

I have some patches to fix up some problems with EIO handling in the
VM (and I think solves the the buffer warning too). I have to get them
out and try to get them merged again... at which point this should
probably be turned into a bug.

Acked-by: Nick Piggin <npiggin@suse.de>
