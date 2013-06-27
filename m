From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2 V2] mke2fs: fix force option to create filesystem on
 mounted device
Date: Thu, 27 Jun 2013 14:52:19 +0800
Message-ID: <20130627065218.GA16789@gmail.com>
References: <51C7E72B.2070608@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60937 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3F0Gdu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Jun 2013 02:33:50 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so609518pab.38
        for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 23:33:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <51C7E72B.2070608@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 24, 2013 at 03:28:59PM +0900, Kazuya Mio wrote:
> According to mke2fs man, we can create a filesystem on the mounted device
> when -FF option is specified.
> However, currently we have to specify -F option third to force mke2fs.
> This patch fixes the problem.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

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
