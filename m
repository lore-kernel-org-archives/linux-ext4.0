From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs.8.in: correct the sign of a block-size constraint.
Date: Sat, 24 Jul 2010 23:55:55 -0500
Message-ID: <4C4BC3DB.5000008@redhat.com>
References: <20100724220124.GO4032@pooh.frostnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Frost <chris@frostnet.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0GYE4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Jul 2010 00:56:16 -0400
In-Reply-To: <20100724220124.GO4032@pooh.frostnet.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Frost wrote:
> Small but technical typo correction.
> 
> There may be more preferred mark ups (e.g., no space between the negative
> sign and "block-sized") or expressions (e.g., absolute value instead of
> negation).

wow I didn't even know that behavior existed.

How about "If block-size is preceded by a negative sign ("-"), then mke2fs 
will use heuristics to determine the appropriate block size, with the 
constraint that the block size will be at least block-size bytes."

-Eric

> 
> Signed-off-by: Chris Frost <chris@frostnet.net>
> ---
>  misc/mke2fs.8.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 45a99f8..05cfe17 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -177,7 +177,7 @@ is negative, then
>  .B mke2fs
>  will use heuristics to determine the
>  appropriate block size, with the constraint that the block size will be
> -at least
> +at least \-
>  .I block-size
>  bytes.  This is useful for certain hardware devices which require that
>  the blocksize be a multiple of 2k.

