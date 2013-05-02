From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [ext4] extent tree es_len can be zero?
Date: Thu, 2 May 2013 10:55:22 +0800
Message-ID: <20130502025522.GA6385@gmail.com>
References: <20130430045920.296280@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jon ERNST <jonernst@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43290 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3EBChv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 May 2013 22:37:51 -0400
Received: by mail-pb0-f54.google.com with SMTP id rr4so83918pbb.27
        for <linux-ext4@vger.kernel.org>; Wed, 01 May 2013 19:37:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130430045920.296280@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 30, 2013 at 12:59:19AM -0400, Jon ERNST wrote:
> Hi ,list,
>=20
> extent tree es_len can be zero?
> if we call ext4_es_end when es_len is zero, it will have problem.
>=20
>=20
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 95796a1..49a8da2 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -108,7 +108,7 @@
>  =C2=A0* =C2=A0 =C2=A0 tree are ordered by logical block no.
>  =C2=A0*
>  =C2=A0* =C2=A0 -- =C2=A0 =C2=A0 =C2=A0 =C2=A0operations on a extent =
status tree
> - * =C2=A0 =C2=A0 There are three important operations on a delayed e=
xtent tree: find
> + * =C2=A0 =C2=A0 There are three important operations on a delayed e=
xtent tree: finding
>  =C2=A0* =C2=A0 =C2=A0 next extent, adding a extent(a range of blocks=
) and removing a extent.
>  =C2=A0*
>  =C2=A0* =C2=A0 -- =C2=A0 =C2=A0 =C2=A0 =C2=A0race on a extent status=
 tree
> @@ -195,7 +195,7 @@ static void ext4_es_print_tree(struct inode *inod=
e)
> =20
>  static inline ext4_lblk_t ext4_es_end(struct extent_status *es)
>  {
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(es->es_lblk + es->es_len < es->es_lblk)=
;
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(es->es_lblk + es->es_len <=3D es->es_lb=
lk);

Hi Jon,

Thanks for looking at the code.  When ext4_es_end is called, es_len
shouldn't be zero because we always get 'es' from extent status tree,
and we never save an 'es' whose length is zero.  So we don't need to
worry about this.

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
