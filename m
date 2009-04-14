From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
Date: Tue, 14 Apr 2009 13:13:49 +0530
Message-ID: <ea11fea30904140043y1f2e4200oe225a6e2b2a88712@mail.gmail.com>
References: <20090414073631.GA4145@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:56905 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZDNHoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2009 03:44:05 -0400
In-Reply-To: <20090414073631.GA4145@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 14, 2009 at 1:06 PM, Akinobu Mita <akinobu.mita@gmail.com> =
wrote:
> Add missing mutex_unlock in error path in ext2_quota_write()

This has already been taken I think.

http://patchwork.ozlabs.org/patch/25661/

Thanks -
Manish


>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index f983225..5c4afe6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1395,8 +1395,10 @@ static ssize_t ext2_quota_write(struct super_b=
lock *sb, int type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk++;
> =A0 =A0 =A0 =A0}
> =A0out:
> - =A0 =A0 =A0 if (len =3D=3D towrite)
> + =A0 =A0 =A0 if (len =3D=3D towrite) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0if (inode->i_size < off+len-towrite)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode, off+len-towrite);
> =A0 =A0 =A0 =A0inode->i_version++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
