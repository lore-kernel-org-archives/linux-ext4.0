From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH] ext4: remove loop around bio_alloc()
Date: Thu, 30 Jun 2011 10:12:25 +0800
Message-ID: <BANLkTikSROvSS9UdQbyyPkHQO1YDoP7yoQ@mail.gmail.com>
References: <1309398299-9988-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58032 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1F3CM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 22:12:26 -0400
Received: by bwd5 with SMTP id 5so1463084bwd.19
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jun 2011 19:12:25 -0700 (PDT)
In-Reply-To: <1309398299-9988-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

2011/6/30 Theodore Ts'o <tytso@mit.edu>:
> These days, bio_alloc() is guaranteed to never fail (as long as nvecs
> is less than BIO_MAX_PAGES), so we don't need the loop around the
> struct bio allocation.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/page-io.c | =A0 =A06 +-----
> =A01 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 7bb8f76..430c401 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -285,11 +285,7 @@ static int io_submit_init(struct ext4_io_submit =
*io,
> =A0 =A0 =A0 =A0io_end =3D ext4_init_io_end(inode, GFP_NOFS);
> =A0 =A0 =A0 =A0if (!io_end)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> - =A0 =A0 =A0 do {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio =3D bio_alloc(GFP_NOIO, nvecs);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nvecs >>=3D 1;
> - =A0 =A0 =A0 } while (bio =3D=3D NULL);
> -
> + =A0 =A0 =A0 bio =3D bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
Is this needn't to check if bio_alloc success?

> =A0 =A0 =A0 =A0bio->bi_sector =3D bh->b_blocknr * (bh->b_size >> 9);
> =A0 =A0 =A0 =A0bio->bi_bdev =3D bh->b_bdev;
> =A0 =A0 =A0 =A0bio->bi_private =3D io->io_end =3D io_end;
> --
> 1.7.4.1.22.gec8e1.dirty
>
> --
Asked-by: LiuQi <lingjiujianke@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
