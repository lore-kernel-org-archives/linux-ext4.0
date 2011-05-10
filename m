From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4:Let ext4_ext_fiemap_cb() handle blocks before
 request range correctly.
Date: Tue, 10 May 2011 16:35:37 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105101620590.18016@dhcp-27-109.brq.redhat.com>
References: <1305036366-1228-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab1EJOfp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 10:35:45 -0400
In-Reply-To: <1305036366-1228-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 10 May 2011, Yongqiang Yang wrote:

> v1->v2:
>   Add more specific description.
> 
> To get delayed-extent information, ext4_ext_fiemap_cb() lookups pagecache,
> it thus collects information starting from a page's head block.
> If blockszie < pagesize, the beginning blocks of a page may lie before the
> range.  ext4_ext_fiemap_cb() should proceed ignoring them, because they
> has been handled before.

Thanks for the description, but I have one question below.

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
So if the condition is true, then we might leave the loop, because (bh ==
head) in the first iteration, is that desired behavior? Also if we hit
this condition in other than first iteration we will spin forever. I do
not think this is right. How did you tested this case ?

Thanks!
-Lukas

>  				if (buffer_mapped(bh)) {
>  					/* get the 1st mapped buffer. */
> -					if (end > newex->ec_block +
> +					if (end >= newex->ec_block +
>  						newex->ec_len)
>  						/* The buffer is out of
>  						 * the request range.
> 
