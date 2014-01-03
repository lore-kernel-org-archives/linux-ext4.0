From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/5] libblkid: fix sizeof(foo) vs sizeof(*foo) malloc()
 bug
Date: Fri, 03 Jan 2014 10:44:07 -0600
Message-ID: <52C6E8D7.3050106@redhat.com>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu> <1388726998-14349-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaACQoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 11:44:10 -0500
In-Reply-To: <1388726998-14349-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/2/14, 11:29 PM, Theodore Ts'o wrote:
> Addresses-Coverity-Bug: #709510
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Heh, that's been around a while!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  lib/blkid/probe.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
> index bd31fe0..6f74bd4 100644
> --- a/lib/blkid/probe.c
> +++ b/lib/blkid/probe.c
> @@ -1003,7 +1003,7 @@ static int probe_udf(struct blkid_probe *probe,
>  	   (block sizes larger than 2K will be null padded) */
>  	for (bs = 1; bs < 16; bs++) {
>  		isosb = (struct iso_volume_descriptor *)
> -			get_buffer(probe, bs*2048+32768, sizeof(isosb));
> +			get_buffer(probe, bs*2048+32768, sizeof(*isosb));
>  		if (!isosb)
>  			return 1;
>  		if (isosb->vd_id[0])
> @@ -1015,7 +1015,7 @@ static int probe_udf(struct blkid_probe *probe,
>  		if (j > 1) {
>  			isosb = (struct iso_volume_descriptor *)
>  				get_buffer(probe, j*bs*2048+32768,
> -					   sizeof(isosb));
> +					   sizeof(*isosb));
>  			if (!isosb)
>  				return 1;
>  		}
> @@ -1223,7 +1223,7 @@ static int probe_hfsplus(struct blkid_probe *probe,
>  		off = (alloc_first_block * 512) +
>  			(embed_first_block * alloc_block_size);
>  		buf = get_buffer(probe, off + (id->bim_kboff * 1024),
> -				 sizeof(sbd));
> +				 sizeof(*sbd));
>  		if (!buf)
>  			return 1;
>  
> 

