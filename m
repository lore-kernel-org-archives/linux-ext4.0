From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/1] ext4: Fix Opts: (null)
Date: Tue, 23 Jul 2013 21:18:56 -0500
Message-ID: <51EF3990.4010901@redhat.com>
References: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?B?IkrDsw==?= =?UTF-8?B?aGFubiBCLiBHdcOwbXVuZHNzb24i?=
	<johannbg@fedoraproject.org>
To: =?UTF-8?B?IkrDs2hhbm4gQi4gR3XDsG11bmRzc29uIg==?=
	<johannbg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3GXCTC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jul 2013 22:19:02 -0400
In-Reply-To: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/22/13 5:24 PM, J=C3=B3hann B. Gu=C3=B0mundsson wrote:
> null null null no more Opts: (null) but something that actually makes=
 sense to
> human beings...

It's not clear to me how this changes the (null) output...
Have you tested it?  What's the difference in output?

-Eric

> Signed-off-by: J=C3=B3hann B. Gu=C3=B0mundsson <johannbg@fedoraprojec=
t.org>
> ---
>  fs/ext4/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 85b3dd6..ef141b7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4088,8 +4088,8 @@ no_journal:
>  				 "the device does not support discard");
>  	}
> =20
> -	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> -		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> +	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s "
> +		 "%s%s%s mount option(s)", descr, sbi->s_es->s_mount_opts,
>  		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
> =20
>  	if (es->s_error_count)
> @@ -4866,7 +4866,7 @@ static int ext4_remount(struct super_block *sb,=
 int *flags, char *data)
>  	}
>  #endif
> =20
> -	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
> +	ext4_msg(sb, KERN_INFO, "re-mounted %s mount option(s)", orig_data)=
;

>  	kfree(orig_data);
>  	return 0;
> =20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
