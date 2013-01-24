From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: remove unused variable flags
Date: Fri, 25 Jan 2013 00:46:29 +0800
Message-ID: <E39D24D3-2C5C-4851-A640-1B42264DC126@gmail.com>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com> <1359045044-31435-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56396 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3AXQqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 11:46:40 -0500
Received: by mail-pb0-f47.google.com with SMTP id wz17so5522082pbc.6
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2013 08:46:40 -0800 (PST)
In-Reply-To: <1359045044-31435-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D4=DA 2013-1-25=A3=AC=C9=CF=CE=E712:30=A3=ACLukas Czerner <lczerner@re=
dhat.com> =D0=B4=B5=C0=A3=BA

> Remove unused variable flags from dump_completed_IO(). The code is on=
ly
> exercised when EXT4FS_DEBUG is defined.
>=20
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng
> ---
> fs/ext4/page-io.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 0016fbc..3331a76 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -119,7 +119,6 @@ static void dump_completed_IO(struct inode *inode=
)
> #ifdef    EXT4FS_DEBUG
>    struct list_head *cur, *before, *after;
>    ext4_io_end_t *io, *io0, *io1;
> -    unsigned long flags;
>=20
>    if (list_empty(&EXT4_I(inode)->i_completed_io_list)) {
>        ext4_debug("inode %lu completed_io list is empty\n",
> --=20
> 1.7.7.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
