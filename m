From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 2/4]ext4: Remove unneeded BUG_ON() in ext4_move_extents()
Date: Wed, 2 Sep 2009 13:38:03 +0800
Message-ID: <6149e97b0909012238i6be6d8deg457a6f308608f1f8@mail.gmail.com>
References: <4A9DE3E5.8080104@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f201.google.com ([209.85.222.201]:33524 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZIBFpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 01:45:55 -0400
Received: by pzk39 with SMTP id 39so534917pzk.15
        for <linux-ext4@vger.kernel.org>; Tue, 01 Sep 2009 22:45:57 -0700 (PDT)
In-Reply-To: <4A9DE3E5.8080104@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/9/2 Akira Fujita <a-fujita@rs.jp.nec.com>:
> ext4: Remove unneeded BUG_ON() in ext4_move_extents()
>
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>
> ext4_move_extents() checks with BUG_ON() whether
> the exchanged blocks count accords with request blocks count.
> But, if the target range (orig_start + len) includes sparse block(s),
> 'moved_len' (exchanged blocks count) does not accord with
> 'len' (request blocks count),
> since sparse block is not counted in 'moved_len'.
> Therefore we hit BUG_ON(), though it succeeded.
I can confirm the bug in my test cases too.

>
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
> =C2=A0fs/ext4/move_extent.c | =C2=A0 =C2=A03 ---
> =C2=A01 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 60ed567..643156a 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -1323,8 +1323,5 @@ out2:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
>
> - =C2=A0 =C2=A0 =C2=A0 /* All of the specified blocks must be exchang=
ed in succeed */
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(*moved_len !=3D len);
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
