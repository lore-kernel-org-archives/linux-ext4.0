From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded variable.
Date: Thu, 17 Nov 2011 15:15:25 +0530
Message-ID: <CADDb1s21Px4vP5S48O770vCT6FNAw4CDR9uDRcBn=rPqfKnzQA@mail.gmail.com>
References: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1KQJp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 04:45:26 -0500
In-Reply-To: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Any feedback for this patch? We surely don't need 'ret2' variable in th=
is code.

Thanks & Regards,
Amit Sahrawat

On Fri, Nov 11, 2011 at 8:32 PM, Namjae Jeon <linkinjeon@gmail.com> wro=
te:
> ret2 is not needed in ext4_flush_completed_IO().
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
> =A0fs/ext4/fsync.c | =A0 =A05 +----
> =A01 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 00a2cb7..40397ac 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -81,7 +81,6 @@ int ext4_flush_completed_IO(struct inode *inode)
> =A0 =A0 =A0 =A0struct ext4_inode_info *ei =3D EXT4_I(inode);
> =A0 =A0 =A0 =A0unsigned long flags;
> =A0 =A0 =A0 =A0int ret =3D 0;
> - =A0 =A0 =A0 int ret2 =3D 0;
>
> =A0 =A0 =A0 =A0dump_completed_IO(inode);
> =A0 =A0 =A0 =A0spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> @@ -105,12 +104,10 @@ int ext4_flush_completed_IO(struct inode *inode=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_complete=
d_io_lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_end_io_nolock(io);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret2 =3D ret;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&ei->i_completed_io_=
lock, flags);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_completed_io_lock, flags=
);
> - =A0 =A0 =A0 return (ret2 < 0) ? ret2 : 0;
> + =A0 =A0 =A0 return (ret < 0) ? ret : 0;
> =A0}
>
> =A0/*
> --
> 1.7.4.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
