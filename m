From: =?utf-8?B?QW5kcsOpIEx1aXMgUGVyZWlyYSBkb3MgU2FudG9zIC0gQlNSU29mdA==?=
	<andre@bsrsoft.com.br>
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4 2.6.37-rc1
Date: Thu, 4 Nov 2010 16:34:26 -0700 (PDT)
Message-ID: <756314.4122.qm@web110514.mail.gq1.yahoo.com>
Reply-To: andre@bsrsoft.com.br
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm23.bullet.mail.ne1.yahoo.com ([98.138.90.86]:20968 "HELO
	nm23.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750779Ab0KDXe2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Nov 2010 19:34:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello.

This is true.
Despite having gone through all compilation and I have not noticed appa=
rent problems, my mistake is evident in this case.

I had not realized that the side effect would really be changing variab=
les incremented and decremented.

Thank you.

I'll think more about this type of side effect. :)


On Thu, 4 Nov 2010, Andr=C3=A9 Luis Pereira dos Santos - BSRSoft wrote:

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
> --- linux-2.6.37-rc1/fs/ext4/extents.c        2010-11-01 09:54:12.000=
000000 -0200
> +++ linux-2.6.37-rc1-patched/fs/ext4/extents.c        2010-11-04 19:5=
4:26.000000000 -0200
> @@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
>       while (l <=3D r) {
>               m =3D l + (r - l) / 2;
>               if (block < le32_to_cpu(m->ee_block))
> -                     r =3D m - 1;
> +                     r =3D m--;
>               else
> -                     l =3D m + 1;
> +                     l =3D m++;

These do not give identical results.

foo =3D bar + 1;  assigns (bar + 1) to foo.
foo =3D bar--;  assigns bar to foo then decrements bar.
foo =3D --bar;  decrements bar then assigns bar to foo.

So your change both change the value that will be assigned to 'r' and '=
l'
and also modify 'm' which was not previously modified.


>               ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee=
_block),
>                               m, le32_to_cpu(m->ee_block),
>                               r, le32_to_cpu(r->ee_block));
> @@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
>               if (ext4_ext_is_uninitialized(ex))
>                       uninitialized =3D 1;
>               ex->ee_len =3D cpu_to_le16(ext4_ext_get_actual_len(ex)
> -                             + ext4_ext_get_actual_len(ex + 1));
> +                             + ext4_ext_get_actual_len(ex++));

After your change gcc complains:

 fs/ext4/extents.c:1559:16: warning: operation on =E2=80=98ex=E2=80=99 =
may be undefined
 fs/ext4/extents.c:1559:16: warning: operation on =E2=80=98ex=E2=80=99 =
may be undefined

which it is correct in doing since you are now modifying the value of t=
he
pointer which is dereferenced in the assignment. Previously the value o=
f
(ex+1) was simply passed to ext4_ext_get_actual_len(), but now you are
passing the value of (ex) to ext4_ext_get_actual_len() and then
subsequently incrementing 'ex' itself.


>               if (uninitialized)
>                       ext4_ext_mark_uninitialized(ex);
>
>


Was this patch even compile tested?


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
