From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Thu, 10 Dec 2009 11:44:49 -0600
Message-ID: <4B213391.4050603@redhat.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZLJRop (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2009 12:44:45 -0500
In-Reply-To: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Curt Wohlgemuth wrote:
> This fixes a bug in which new blocks returned from an extent created with
> ext4_ext_zeroout() can have dirty metadata still associated with them.

Do you have a testcase or at least end result details for this corruption?

> 	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
> 
> This is for the problem I reported on 23 Nov ("Bug in extent zeroout: blocks
> not marked as new").  I'm not seeing the corruption with this fix that I was
> seeing without it.
> 
> diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
> --- orig/fs/ext4/extents.c	2009-12-09 15:09:25.000000000 -0800
> +++ new/fs/ext4/extents.c	2009-12-09 15:09:37.000000000 -0800
> @@ -2474,9 +2474,21 @@ static int ext4_ext_zeroout(struct inode
>  		submit_bio(WRITE, bio);
>  		wait_for_completion(&event);
> 
> -		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> +		/* On success, we need to insure all metadata associated

nitpick, "ensure" I think, although I guess they're mostly synonymous
today so do with that what you will :)

-Eric

> +		 * with each of these blocks is unmapped. */
> +		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
> +			sector_t block = ee_pblock;
> +
>  			ret = 0;
> -		else {
> +			done = 0;
> +			while (done < len) {
> +				unmap_underlying_metadata(inode->i_sb->s_bdev,
> +							  block);
> +
> +				done++;
> +				block++;
> +			}
> +		} else {
>  			ret = -EIO;
>  			break;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

