From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4:Fix credits computing for indirect mapped files.
Date: Tue, 5 Apr 2011 13:02:24 +0800
Message-ID: <BANLkTi=Qx5cwr21YW-G9VkGCA+xDm2WbEQ@mail.gmail.com>
References: <1301058605-29978-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110404193935.GB2832@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:41116 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1DEFCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 01:02:24 -0400
Received: by pxi2 with SMTP id 2so13256pxi.10
        for <linux-ext4@vger.kernel.org>; Mon, 04 Apr 2011 22:02:24 -0700 (PDT)
In-Reply-To: <20110404193935.GB2832@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 5, 2011 at 3:39 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Mar 25, 2011 at 09:10:05PM +0800, Yongqiang Yang wrote:
>> Either the first block or the last one could be not aligned with
>> block boundary, 1 block is needed to fix it.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> Thanks for the patch submission!
>
> I further modified the patch to make the commit description a bit
> clearer, and to fix an additional bug that I noticed while reviewing
> your patch.
Thank you.

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
> From fa0dfea6882a833a70f04b3089a751f75c0d03f6 Mon Sep 17 00:00:00 200=
1
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Date: Mon, 4 Apr 2011 15:38:38 -0400
> Subject: [PATCH] ext4: fix credits computing for indirect mapped file=
s
>
> When writing a contiguous set of blocks, two indirect blocks could be
> needed depending on how the blocks are aligned, so we need to increas=
e
> the number of credits needed by one.
>
> [ Also fixed a another bug which could further underestimate the
> =A0number of journal credits needed by 1; the code was using integer
> =A0division instead of DIV_ROUND_UP() -- tytso]
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/inode.c | =A0 11 +++++------
> =A01 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1a86282..7d11e02 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5398,13 +5398,12 @@ static int ext4_indirect_trans_blocks(struct =
inode *inode, int nrblocks,
> =A0 =A0 =A0 =A0/* if nrblocks are contiguous */
> =A0 =A0 =A0 =A0if (chunk) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* With N contiguous data blocks, it =
need at most
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* N/EXT4_ADDR_PER_BLOCK(inode->i_sb)=
 indirect blocks
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 2 dindirect blocks
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1 tindirect block
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* With N contiguous data blocks, we =
need at most
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* N/EXT4_ADDR_PER_BLOCK(inode->i_sb)=
 + 1 indirect blocks,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 2 dindirect blocks, and 1 tindirec=
t block
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 indirects =3D nrblocks / EXT4_ADDR_PER_=
BLOCK(inode->i_sb);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return indirects + 3;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return DIV_ROUND_UP(nrblocks,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * if nrblocks are not contiguous, worse case, each bl=
ock touch
> --
> 1.7.3.1
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
