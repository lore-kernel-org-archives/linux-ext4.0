From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4:Fix a bug in 6d9c85eb.
Date: Tue, 10 May 2011 14:34:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105101432180.4184@dhcp-27-109.brq.redhat.com>
References: <1305027117-936-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab1EJMeR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 08:34:17 -0400
In-Reply-To: <1305027117-936-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 10 May 2011, Yongqiang Yang wrote:

The commit subject is really useless, could you be more specific ? and
possibly more descriptive in commit description ?

Thanks!
-Lukas

> In case blocksize < pagesize, ext4_ext_fiemap_cb need to ignore
> blocks which are not in request range.
> 
> BUG description:
> xfstests 225 ended in a endless loop without this patch
> when blocksize < pagesize.
> 
> Reported-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e363f21..ec37109 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3718,9 +3718,14 @@ out:
>  
>  			bh = head;
>  			do {
> +				if (end < newex->ec_block)
> +					/* The buffer is not in
> +					 * the request range.
> +					 */
> +					continue;
>  				if (buffer_mapped(bh)) {
>  					/* get the 1st mapped buffer. */
> -					if (end > newex->ec_block +
> +					if (end >= newex->ec_block +
>  						newex->ec_len)
>  						/* The buffer is out of
>  						 * the request range.
> 

-- 
