From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v1] ext3:Fix credits computing for ordered mode.
Date: Thu, 24 Mar 2011 06:49:50 +0200
Message-ID: <AANLkTi=Y4_h80bJZ8vW-dr58UujWMjY=VNWRTPt=fGLp@mail.gmail.com>
References: <1300927719-27383-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39250 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab1CXEtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2011 00:49:51 -0400
Received: by qwk3 with SMTP id 3so6415708qwk.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 21:49:50 -0700 (PDT)
In-Reply-To: <1300927719-27383-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 24, 2011 at 2:48 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Orginal computing ignores indirects themselves in ordered mode.

On the worst case, data,ind,dind,tind all allocated from different bg
and different gdb
credits should be 2*4+4+2 for journaled and 2*4+3+2 for ordered (with
4K block: bpp =3D 1, indirects =3D 3)

Acked-by: Amir Goldstein <amir73il@users.sf.net>

>
> Signed-off-by:Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext3/inode.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ae94f6d..7f5db46 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3294,7 +3294,7 @@ static int ext3_writepage_trans_blocks(struct i=
node *inode)
> =A0 =A0 =A0 =A0if (ext3_should_journal_data(inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 3 * (bpp + indirects) + 2;
> =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 2 * (bpp + indirects) + 2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 2 * (bpp + indirects) + indirec=
ts + 2;
>
> =A0#ifdef CONFIG_QUOTA
> =A0 =A0 =A0 =A0/* We know that structure was already allocated during=
 dquot_initialize so
> --
> 1.7.4
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
