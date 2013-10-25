From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH][RESEND] mke2fs: fix force option to create filesystem on
 mounted device
Date: Fri, 25 Oct 2013 13:30:31 -0200
Message-ID: <20131025152957.GA14944@orion.maiolino.org>
References: <526A2E83.5050102@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab3JYPan (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Oct 2013 11:30:43 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9PFUZdX022118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Oct 2013 11:30:36 -0400
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9PFUWqO005101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Oct 2013 11:30:34 -0400
Content-Disposition: inline
In-Reply-To: <526A2E83.5050102@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Fri, Oct 25, 2013 at 05:40:35PM +0900, Kazuya Mio wrote:
> According to mke2fs man, we can create a filesystem on the mounted device
> when -FF option is specified.
> However, currently we have to specify -F option third to force mke2fs.
> This patch fixes the problem.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
