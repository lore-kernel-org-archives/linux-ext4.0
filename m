From: shenghui <crosslonelyover@gmail.com>
Subject: Re: [PATCH 1/2 RESEND] fix return value for mb_cache_shrink_fn when
	nr_to_scan > 0
Date: Sun, 18 Jul 2010 21:58:59 +0800
Message-ID: <AANLkTilV_RalPPhHCk9D7p7AvV5WWOgCIPfc4Orn37Xo@mail.gmail.com>
References: <4C430830.9020903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-mm@kvack.org, linux-ext4 <linux-ext4@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Christoph Hellw
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33407 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0GRN67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Jul 2010 09:58:59 -0400
In-Reply-To: <4C430830.9020903@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E5=9C=A8 2010=E5=B9=B47=E6=9C=8818=E6=97=A5 =E4=B8=8B=E5=8D=889:57=EF=BC=
=8CWang Sheng-Hui <crosslonelyover@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> Sorry to resend this patch. For the 2nd patch should
> be applied after this patch, I just send them together.
>
> Following is the explanation of the patch:
> The comment for struct shrinker in include/linux/mm.h says
> "shrink...It should return the number of objects which remain in the
> cache."
> Please notice the word "remain".
>
> In fs/mbcache.h, mb_cache_shrink_fn is used as the shrink function:
> =C2=A0 =C2=A0 =C2=A0 static struct shrinker mb_cache_shrinker =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .shrink =3D mb_cache=
_shrink_fn,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .seeks =3D DEFAULT_S=
EEKS,
> =C2=A0 =C2=A0 =C2=A0 };
> In mb_cache_shrink_fn, the return value for nr_to_scan > 0 is the
> number of mb_cache_entry before shrink operation. It may because the
> memory usage for mbcache is low, so the effect is not so obvious.
>
> Per Eric Sandeen, we should do the counting only once.
> Per Christoph Hellwig, we should use list_for_each_entry instead of
> list_for_each here.
>
> Following patch is against 2.6.35-rc4. Please check it.
>
>

Sorry, made a typo. It's against 2.6.35-rc5.

--=20


Thanks and Best Regards,
shenghui
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
