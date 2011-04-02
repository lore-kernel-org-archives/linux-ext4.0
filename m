From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Is this a bug?
Date: Sat, 2 Apr 2011 09:32:49 -0700
Message-ID: <BANLkTimc3LC19vzjuvL4QyXcjrGAQgnqJA@mail.gmail.com>
References: <BANLkTinPYj7_qpKcZgp3Oya1LXzcbfBczQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35908 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1DBQcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 12:32:50 -0400
Received: by qwk3 with SMTP id 3so2646519qwk.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Apr 2011 09:32:49 -0700 (PDT)
In-Reply-To: <BANLkTinPYj7_qpKcZgp3Oya1LXzcbfBczQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 2, 2011 at 1:05 AM, Ding Dinghua <dingdinghua85@gmail.com> =
wrote:
> When truncate files and free blocks, the following codes make me puzz=
led:
>
> void ext4_free_blocks(handle_t *handle, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh, ex=
t4_fsblk_t block,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long count, int f=
lags)
> {
> =A0 =A0 =A0 =A0if (flags & EXT4_FREE_BLOCKS_FORGET) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *tbh =3D bh;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int i;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(bh && (count > 1));
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < count; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!bh)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tbh =3D=
 sb_find_get_block(inode->i_sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block + i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(!tbh))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_forget(handle, fl=
ags & EXT4_FREE_BLOCKS_METADATA,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
inode, tbh, block + i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> }
>
> I notice that ext4_forget mainly do two things:
> =A0 =A0a) =A0call jbd2_journa_forget to forget the modification of so=
me buffer head
> =A0 =A0b) =A0or deal with the revoke issue
> however, if we are freeing data blocks && ext4_forget get into branch=
 a),

Simple. we don't pass the FORGET flag when freeing data blocks,
only when freeing metadata blocks, which may have been journalled
already.
I am not sure about the journal=3Ddata case through.

> tbh is not the buffer_head which journal took care of in ext4_write_b=
egin,
> so i'm puzzled with this.
>
> Could anyone explain it to me? Thanks.
>
> --
> Ding Dinghua
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
