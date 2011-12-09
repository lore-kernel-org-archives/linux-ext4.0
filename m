From: Eric Gouriou <egouriou@google.com>
Subject: Re: [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
Date: Fri, 9 Dec 2011 14:41:44 -0800
Message-ID: <CAMUAhYSCFivbHbmeRRGxSC1qiFq1OQbhajNLCXn28rvvGTGPkg@mail.gmail.com>
References: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	hughd@google.com, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37430 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1LIWlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2011 17:41:45 -0500
Received: by qcqz2 with SMTP id z2so2551813qcq.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Dec 2011 14:41:44 -0800 (PST)
In-Reply-To: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 6, 2011 at 21:21, Yongqiang Yang <xiaoqiangnk@gmail.com> wr=
ote:
> If a file is fallocated on a hole, map->m_lblk + map->m_len may be gr=
eater
> than ee_block + ee_len.

Could you please detail a scenario that leads to this check being inval=
id?
As I'm to blame for the faulty BUG_ON I'd like to use this as an opport=
unity
to get properly edified.

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =C2=A0fs/ext4/extents.c | =C2=A0 =C2=A01 -
> =C2=A01 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6f0300e..29bb629 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2943,7 +2943,6 @@ static int ext4_ext_convert_to_initialized(hand=
le_t *handle,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Pre-conditions */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!ext4_ext_is_uninitialized(ex));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!in_range(map->m_lblk, ee_block, ee=
_len));
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(map->m_lblk + map->m_len > ee_block + e=
e_len);

=46or a bit I thought this would break the fast path logic, however it =
gets
protected by the checks marked /*L1*/ and /*L2*/ since m_lblk =3D=3D ee=
_block
(L1) and m_len < ee_len (L2).

 Regards - Eric

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Attempt to transfer newly initialized b=
locks from the currently
> --
> 1.7.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
