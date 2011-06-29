From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH v3] ext4: avoid wasted extent cache lookup if !PUNCH_OUT_EXT
Date: Wed, 29 Jun 2011 09:30:57 +0800
Message-ID: <BANLkTinTk-2005wzEnLtk=guuOCnFdLBDA@mail.gmail.com>
References: <1309309071-2244-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56827 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1F2Ba7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 21:30:59 -0400
Received: by bwd5 with SMTP id 5so637093bwd.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2011 18:30:58 -0700 (PDT)
In-Reply-To: <1309309071-2244-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/29 Robin Dong <hao.bigrat@gmail.com>:
> This patch avoids an extraneous lookup of the extent cache
> in ext4_ext_map_blocks() when the flag
> EXT4_GET_BLOCKS_PUNCH_OUT_EXT is absent.
>
> The existing logic was performing the lookup but not making
> use of the result. The patch simply reverses the order of evaluation
> in the condition.
>
> Since ext4_ext_in_cache() does not initialize newex on misses, bypass=
ing
> its invocation does not introduce any new issue in this regard.
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Eric Gouriou <egouriou@google.com>
> ---
> =A0fs/ext4/extents.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index eb63c7b..fed2633 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3358,8 +3358,8 @@ int ext4_ext_map_blocks(handle_t *handle, struc=
t inode *inode,
> =A0 =A0 =A0 =A0trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, ma=
p->m_len, flags);
>
> =A0 =A0 =A0 =A0/* check in cache */
> - =A0 =A0 =A0 if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT=
) =3D=3D 0)) {
> + =A0 =A0 =A0 if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_in_cache(inode, map->m_lblk, &=
newex)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!newex.ee_start_lo && !newex.ee_st=
art_hi) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((flags & EXT4_GET_=
BLOCKS_CREATE) =3D=3D 0) {

Ronbin Dong,
  why donnot do this line?
=A0if ((flags & EXT4_GET_BLOCKS_CREATE) =3D=3D 0) {
TO
=A0if (!(flags & EXT4_GET_BLOCKS_CREATE) ) {
?
Acked-by:   LiuQi <lingjiujianke@gmail.com>

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> --
> 1.7.1
>
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
