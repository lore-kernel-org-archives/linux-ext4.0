From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH v2] ext4: avoid redundant cache finding if flags not
 cantian PUNCH_OUT
Date: Mon, 27 Jun 2011 21:45:25 +0800
Message-ID: <BANLkTikLtWsELdrn4tVsE2SB-hg32ni+Xw@mail.gmail.com>
References: <1309171513-5246-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35999 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1F0Np0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 09:45:26 -0400
Received: by bwd5 with SMTP id 5so1238130bwd.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 06:45:25 -0700 (PDT)
In-Reply-To: <1309171513-5246-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Robin Dong

     Why don't modify this line?
  =A0if ((flags & EXT4_GET_BLOCKS_CREATE) =3D=3D 0) {
    if(!(flags & EXT4_GET_BLOCKS_CREATE))


2011/6/27 Robin Dong <hao.bigrat@gmail.com>:
> In old code, ext4 will find extent in cache first even flags does
> not contian PUNCH_OUT, that may waste some time.
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
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

Best Regards
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
