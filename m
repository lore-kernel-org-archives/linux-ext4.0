From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 2/5][64-BIT] Enable 64-bitness in e2image.c
Date: Wed, 15 Apr 2009 15:54:49 -0400
Message-ID: <20090415195449.GD1668@shell>
References: <11643.1239227186@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbZDOTyv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 15:54:51 -0400
Content-Disposition: inline
In-Reply-To: <11643.1239227186@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 05:46:26PM -0400, Nick Dokos wrote:
> 
> Add EXT2_FLAG_NEW_BITMAPS to the open_flags for the device.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

> ---
>  misc/e2image.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index fb92881..5c4dde7 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -625,7 +625,7 @@ int main (int argc, char ** argv)
>  	errcode_t retval;
>  	ext2_filsys fs;
>  	char *image_fn;
> -	int open_flag = 0;
> +	int open_flag = EXT2_FLAG_NEW_BITMAPS;
>  	int raw_flag = 0;
>  	int install_flag = 0;
>  	int scramble_flag = 0;
> -- 
> 1.6.0.6
> 
