From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: release page cache in ext4_mb_load_buddy error path
Date: Thu, 14 Apr 2011 10:01:10 +0300
Message-ID: <BANLkTinPupXGmYTq16hcgexdUP+czYRc4A@mail.gmail.com>
References: <20110414064441.GA3499@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55928 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1DNHBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 03:01:11 -0400
Received: by gxk21 with SMTP id 21so595108gxk.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 00:01:10 -0700 (PDT)
In-Reply-To: <20110414064441.GA3499@darkstar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Yang ,

The patch looks correct, but in my opinion a nicer fix would be to set
e4b->bd_bitmap_page =3D page;
or
e4b->bd_buddy_page =3D page;
right after assigning a new value to the temp variable 'page'.
and keeping the cleanup code in the error path as it is.

It's a matter of taste and code readability.

Amir.

On Thu, Apr 14, 2011 at 9:44 AM, Yang Ruirui <ruirui.r.yang@tieto.com> =
wrote:
> Add missing page_cache_release in the error path of ext4_mb_load_budd=
y
>
> Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
> ---
> =A0fs/ext4/mballoc.c | =A0 =A02 ++
> =A01 file changed, 2 insertions(+)
>
> --- linux-2.6.orig/fs/ext4/mballoc.c =A0 =A02011-04-14 14:04:48.00000=
0000 +0800
> +++ linux-2.6/fs/ext4/mballoc.c 2011-04-14 14:33:28.702958245 +0800
> @@ -1273,6 +1273,8 @@ repeat_load_buddy:
> =A0 =A0 =A0 =A0return 0;
>
> =A0err:
> + =A0 =A0 =A0 if (page)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> =A0 =A0 =A0 =A0if (e4b->bd_bitmap_page)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(e4b->bd_bitmap_page=
);
> =A0 =A0 =A0 =A0if (e4b->bd_buddy_page)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
