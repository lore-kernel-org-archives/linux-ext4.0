From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] e2image: fix logic bug which could cause a raw image
 not to be extended
Date: Fri, 17 Feb 2012 21:18:26 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202172118090.10691@dhcp-27-109.brq.redhat.com>
References: <20120217143026.GA19606@thunk.org> <1329489163-21918-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab2BQUSb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 15:18:31 -0500
In-Reply-To: <1329489163-21918-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Feb 2012, Theodore Ts'o wrote:

> If the size of the last "hole" in the raw file was an exact multiple
> of a megabyte, then we wouldn't write a null at the end of the file in
> order to extend the size of the raw image to correspond with the file
> system size.  Thanks to Lukas Czerner for suggesting the fix, and
> Phillip Susi for pointing out the problem.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/e2image.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index d888e5a..3cb92fe 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -504,10 +504,9 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
>  				continue;
>  			}
>  			sparse += fs->blocksize;
> -			if (sparse >= 1024*1024) {
> -
> -				write_block(fd, 0, sparse, 0, 0);
> -				sparse = 0;
> +			if (sparse > 1024*1024) {
> +				write_block(fd, 0, 1024*1024, 0, 0);
> +				sparse -= 1024*1024;
>  			}
>  		}
>  	}
> 

Looks good, thanks!

-Lukas
