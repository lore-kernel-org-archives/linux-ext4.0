Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA85FC10F13
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 18:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FBDD20868
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 18:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="YHhwP9Id"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfDPSR2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 14:17:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35577 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfDPSR1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2019 14:17:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id t21so10814336pfh.2
        for <linux-ext4@vger.kernel.org>; Tue, 16 Apr 2019 11:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=WDPU9YFo5i9pUQ9wsW1uBz1pJ2WT8n6i8sPURzY0XD8=;
        b=YHhwP9Id/qKJ+CLidA/8qSRzI7xSDF2begSPs90pFRyRqtTYf5TlED+mWdhk4r9vtG
         9dIUjAhSyotUhi+QMaQBhz20vaXIUmEurwJ+DWCi3jW+d1/9dCtBu7vodJ0utdlk4iPa
         Ot9cx/f4H7FcSKL9KVnch1L6smaLi7qtA6Q+5SKJD51dmtq2r3dbuRdRECijibP+1CkK
         9UHf+PldnpcW2aUC9wgefkGj83DwvqSy9Q2BfGGStrPk+ffzKlDziVAOJ/xyqDSnZQYX
         uzYwnmgJHaVVdQmlno32qYT8vvmeoGpsuu1zGKf92YOVaPz61vUvUonq3s/UIGhoLX5j
         ImTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=WDPU9YFo5i9pUQ9wsW1uBz1pJ2WT8n6i8sPURzY0XD8=;
        b=a1KnKnr6Nlvz/BwF7oXuALHemWSJzydq7tUkcdg2cxI0XSKXDOIqQCkkzQ4LVaA45r
         Ls5vGBSAcarrACq7dPuxNQKTqRbirO78MNXMlxzrtaI4R/XQYTKaXB0RfQ7DvWdDibDq
         woaIhhdPuQorD2F9iXPiVTXjOSYSMtIypIHp7Ao8aaKDOt6CLaCi1PwI8AqWM9igZSzt
         0W9BfnOfe1Bc/dUcWdDXClmBTQViD4I+snZnrvlFBcL0c4s+5FI8Muz/I8gsDQ/rf6Ry
         xhyHgcKGHVQk4z5nKkko4L2hyYUecKIl6jh3EZOrjHZMlLVoXoxTlYQzj0hOS7SFpuGr
         Pl/Q==
X-Gm-Message-State: APjAAAWrl4EyZRluKEz/tnXVkShr17WO3+LfW94Z6yYWMEUZprzF7uSf
        DCDEd9LhD1XqMd1vg4OuUad4Fw==
X-Google-Smtp-Source: APXvYqx8WF0XuDgUIbBPLFLxIRcKlm4dRvMNJeWt991ZiExHDm10cEh7Wki6VIu8gmj7OXwyX2O5nA==
X-Received: by 2002:a65:4bce:: with SMTP id p14mr80159653pgr.376.1555438646703;
        Tue, 16 Apr 2019 11:17:26 -0700 (PDT)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id j6sm69628778pfe.107.2019.04.16.11.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 11:17:26 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <802B4CD4-953D-4E0F-9B22-1350BF91EDD3@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DC3DBD84-4038-49D4-856D-43ED28BB6A9E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 2/4] ext4: Initialize timestamps limits
Date:   Tue, 16 Apr 2019 12:17:23 -0600
In-Reply-To: <20190416143416.3856-2-deepa.kernel@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
References: <20190416143416.3856-1-deepa.kernel@gmail.com>
 <20190416143416.3856-2-deepa.kernel@gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_DC3DBD84-4038-49D4-856D-43ED28BB6A9E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 16, 2019, at 8:34 AM, Deepa Dinamani <deepa.kernel@gmail.com> =
wrote:
>=20
> ext4 has different overflow limits for max filesystem
> timestamps based on the extra bytes available.
>=20
> The timestamp limits are calculated according to the
> encoding table in
> a4dad1ae24f85i(ext4: Fix handling of extended tv_sec):
>=20
> * extra  msb of                         adjust for signed
> * epoch  32-bit                         32-bit tv_sec to
> * bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid time =
range
> * 0 0    1    -0x80000000..-0x00000001  0x000000000   =
1901-12-13..1969-12-31
> * 0 0    0    0x000000000..0x07fffffff  0x000000000   =
1970-01-01..2038-01-19
> * 0 1    1    0x080000000..0x0ffffffff  0x100000000   =
2038-01-19..2106-02-07
> * 0 1    0    0x100000000..0x17fffffff  0x100000000   =
2106-02-07..2174-02-25
> * 1 0    1    0x180000000..0x1ffffffff  0x200000000   =
2174-02-25..2242-03-16
> * 1 0    0    0x200000000..0x27fffffff  0x200000000   =
2242-03-16..2310-04-04
> * 1 1    1    0x280000000..0x2ffffffff  0x300000000   =
2310-04-04..2378-04-22
> * 1 1    0    0x300000000..0x37fffffff  0x300000000   =
2378-04-22..2446-05-10
>=20
> Note that the time limits are not correct for deletion times.
>=20
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> #define EXT4_GOOD_OLD_INODE_SIZE 128
>=20
> +#define EXT4_EXTRA_TIMESTAMP_MAX	(((s64)1 << 34) - 1  + S32_MIN)
> +#define EXT4_NON_EXTRA_TIMESTAMP_MAX	S32_MAX
> +#define EXT4_TIMESTAMP_MIN		S32_MIN
> +
> /*
>  * Feature set definitions
>  */
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f5b828bf1299..3a63a23219a8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3930,8 +3930,20 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 			       sbi->s_inode_size);
> 			goto failed_mount;
> 		}
> -		if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE)
> -			sb->s_time_gran =3D 1 << (EXT4_EPOCH_BITS - 2);
> +		/* i_atime_extra is the last extra field available for =
[acm]times in
> +		 * struct ext4_inode. Checking for that field should =
suffice to ensure
> +		 * we have extra spaces for all three.

There was never a time when only i_ctime_extra or i_mtime_extra was =
present in the
inode, so this should be totally safe.  The code may check for them =
independently
for correctness reasons (e.g. in case of some corruption of the on-disk =
inode or
whatever), but for a global state like this it is totally safe to check =
all three
of the fields based on the presence of i_atime_extra.

> +		 */
> +		if (sbi->s_inode_size >=3D offsetof(struct ext4_inode, =
i_atime_extra) +
> +			sizeof(((struct ext4_inode *)0)->i_atime_extra)) =
{
> +			sb->s_time_gran =3D 1;
> +			sb->s_time_max =3D EXT4_EXTRA_TIMESTAMP_MAX;
> +		} else {
> +			sb->s_time_gran =3D 0;
> +			sb->s_time_max =3D EXT4_NON_EXTRA_TIMESTAMP_MAX;
> +		}
> +
> +		sb->s_time_min =3D EXT4_TIMESTAMP_MIN;
> 	}
>=20
> 	sbi->s_desc_size =3D le16_to_cpu(es->s_desc_size);
> --
> 2.17.1
>=20


Cheers, Andreas






--Apple-Mail=_DC3DBD84-4038-49D4-856D-43ED28BB6A9E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAly2HDQACgkQcqXauRfM
H+B6sg/9HuVITpmi90z6SHvYE889jdKzWuEr1FfgNB1ANwCSlj1sxduMvef382Gj
NE0pNvqguNl9rFuL1Xyo8gT3WX+kpWLCTQXObyml6sRowhser/xU6e91jHlLxOkt
7vlPIHxM3vtEoX9WNmNjP7URBiaz4gbwkxqDmI/1R0Qsltp9TKKaBCIbeFmwPpt9
SBkgyIcnsCH3TGQEn5qIhdTun7P7WZKQHbWoMezUZRSHZ25RIWirmDW2d5f3rf/D
8NXBsLl5Ql1QxJ+NXVBGgnpACLh5QhSuDcDrUVLdpku+bI+JuKIXc5zw566PSkMZ
0ShHFpwP7UzG4c3pQ/u/tqAruCTKyjOeO7k22YwrKDFmmmjZ8LkdhLS4uVrXE7oG
yuecqd0M7lIsXHEixx55u4sGnX01ZMKVhD4QX2xoWTiAg4k+ejS3Ac/9GgSxHp6F
2Z/ljVJbqpOt5c7f5iI4l9O3ebCimcY005AEET09U6EDZFoTMzqUBdK7vy5uoD2w
31T+Hq4pBdFbSU8acrVOHX9c0h8OXnBgSxAuSa5iiJEjvRncgnLfdz1cYfNLtCbt
OHffNk4xZKXpdE1mRirs5fIgbCY56obeUtuibQSb+LyNEH2M0eLorLm5qpyieVeK
eoeY2Z6IPv0/4a2HRHa3oqjgwoR47uTkWc/74wE3rjzwYdK/U9A=
=cy6k
-----END PGP SIGNATURE-----

--Apple-Mail=_DC3DBD84-4038-49D4-856D-43ED28BB6A9E--
