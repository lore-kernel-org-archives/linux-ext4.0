From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
Date: Fri, 04 Apr 2014 17:18:50 +0800
Message-ID: <533E78FA.60204@gmail.com>
References: <53396AC1.10108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	gxt@mprc.pku.edu.cn
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38961 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaDDJS6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2014 05:18:58 -0400
In-Reply-To: <53396AC1.10108@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Maintains:

Please help check this patch, when you have time, thanks.


On 03/31/2014 09:16 PM, Chen Gang wrote:
> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Ne=
ed
> append 'ULL' for it.
>=20
> The related warning (with allmodconfig under unicore32):
>=20
>     CC [M]  fs/ext4/extents_status.o
>   fs/ext4/extents_status.c: In function =91__es_remove_extent=92:
>   fs/ext4/extents_status.c:813: warning: integer constant is too larg=
e for =91long=92 type
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  fs/ext4/extents_status.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 0a014a7..0ebc212 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -810,7 +810,7 @@ retry:
> =20
>  			newes.es_lblk =3D end + 1;
>  			newes.es_len =3D len2;
> -			block =3D 0x7FDEADBEEF;
> +			block =3D 0x7FDEADBEEFULL;
>  			if (ext4_es_is_written(&orig_es) ||
>  			    ext4_es_is_unwritten(&orig_es))
>  				block =3D ext4_es_pblock(&orig_es) +
>=20

--=20
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
