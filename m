From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 V2] mke2fs: fix force option to create filesystem on
 mounted device
Date: Thu, 27 Jun 2013 11:05:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306271103260.1781@localhost.localdomain>
References: <51C7E72B.2070608@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab3F0JF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Jun 2013 05:05:27 -0400
In-Reply-To: <51C7E72B.2070608@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Jun 2013, Kazuya Mio wrote:

> Date: Mon, 24 Jun 2013 15:28:59 +0900
> From: Kazuya Mio <k-mio@sx.jp.nec.com>
> To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 1/2 V2] mke2fs: fix force option to create filesystem on
>     mounted device
> 
> According to mke2fs man, we can create a filesystem on the mounted device
> when -FF option is specified.
> However, currently we have to specify -F option third to force mke2fs.

Oh, you mean we have to specify -F option three times ? It took me
some time to understand. Please rephrase the description.

Otherwise the patch looks good.

Thanks!
-Lukas

> This patch fixes the problem.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>  misc/util.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/misc/util.c b/misc/util.c
> index 6c93e1c..40c8858 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -150,7 +150,7 @@ void check_mount(const char *device, int force, const char *type)
>  	}
>  	if (mount_flags & EXT2_MF_MOUNTED) {
>  		fprintf(stderr, _("%s is mounted; "), device);
> -		if (force > 2) {
> +		if (force >= 2) {
>  			fputs(_("mke2fs forced anyway.  Hope /etc/mtab is "
>  				"incorrect.\n"), stderr);
>  			return;
> @@ -162,7 +162,7 @@ void check_mount(const char *device, int force, const char *type)
>  	if (mount_flags & EXT2_MF_BUSY) {
>  		fprintf(stderr, _("%s is apparently in use by the system; "),
>  			device);
> -		if (force > 2) {
> +		if (force >= 2) {
>  			fputs(_("mke2fs forced anyway.\n"), stderr);
>  			return;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
