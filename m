From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4 2.6.37-rc1
Date: Thu, 4 Nov 2010 18:44:26 -0400
Message-ID: <AANLkTikkAL-ZzxLfa+POoyv4qCE0LUq1h+nfE2_Bn7Ji@mail.gmail.com>
References: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: andre@bsrsoft.com.br
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34796 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0KDWoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Nov 2010 18:44:46 -0400
In-Reply-To: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/11/4 Andr=E9 Luis Pereira dos Santos - BSRSoft <andre@bsrsoft.com.=
br>:
> From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
>
> Hi.
> Small refactoring of the code in order to make minor enhancements to =
critical areas.
> The notation x + 1 has been replaced by more efficient notation x + +=
=2E
>
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> ---
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> --- linux-2.6.37-rc1/fs/ext4/extents.c =A02010-11-01 09:54:12.0000000=
00 -0200
> +++ linux-2.6.37-rc1-patched/fs/ext4/extents.c =A02010-11-04 19:54:26=
=2E000000000 -0200
> @@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
> =A0 =A0 =A0 =A0while (l <=3D r) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0m =3D l + (r - l) / 2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (block < le32_to_cpu(m->ee_block))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D m - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D m--;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 l =3D m + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 l =3D m++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext_debug("%p(%u):%p(%u):%p(%u) ", l, =
le32_to_cpu(l->ee_block),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0m, le3=
2_to_cpu(m->ee_block),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0r, le3=
2_to_cpu(r->ee_block));
> @@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ext4_ext_is_uninitialized(ex))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uninitialized =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex->ee_len =3D cpu_to_le16(ext4_ext_ge=
t_actual_len(ex)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + ext4_=
ext_get_actual_len(ex + 1));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + ext4_=
ext_get_actual_len(ex++));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (uninitialized)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_mark_uninitia=
lized(ex);

But

                   r =3D m - 1;
is not equivalent to
                   r =3D m--;

At a minimum your code no longer passes the same value to of m to ext_d=
ebug.

NAK

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
