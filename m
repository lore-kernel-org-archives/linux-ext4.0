Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A370C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 06:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11466206A3
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 06:21:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="05KiQNhk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfDXGVk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 02:21:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38297 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfDXGVk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Apr 2019 02:21:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id f14so22779745wrj.5
        for <linux-ext4@vger.kernel.org>; Tue, 23 Apr 2019 23:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=9n2dO/SKKYGuJasuWotySUuBbez5lEo+5eIBxC2+8fk=;
        b=05KiQNhk6zf4MTpFRQ+ukjh++1Xr2XC88h84nHFG6VS217Av2YTxpjIRjHqfrdcYN+
         4rRjVuD15M1ceCoqC0WADcHqNPCqGW/nmCuD7x1s5p4Lq3mNCnCxwY6Y6zzVRnWBRWP9
         jguzUAzA0kBjUIYhxN62UoQ4ggBmDm5ix1WioPab0JkboCdZal8iNFqVfd7vU2BE7edU
         jJzuTlgXYndIU/xPhfO8fwlvxSiQLNpdzv8YlERKmSmi71UHKEDUbSenelcOoxg1cLT+
         3Scx/kM9vf4DDncNIKNQTD8BDDSIPOZW9xX+cTZzFjHyVQIB2q3Y9Y/0138H5C0COmGQ
         XxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=9n2dO/SKKYGuJasuWotySUuBbez5lEo+5eIBxC2+8fk=;
        b=ipNFrym0PAbaPmkgcaEwafbLHeoN4qfpgLF+DxBaFPBv38Za3DifpM1QNXYlF6F9cV
         cZ57GST2C47zhiYac2EwhhJE3yKEjiIJtuCjKKUimyX+KXuU6BzwULqan7ZKczLs9MUj
         32wAn1uCG1lddYdk0fT4PxAVBLqJlvskwW2IIPxQyiFYJrlksy55Wdrfd+4WpURMRPUd
         83lJrJosreEPliWEnJ5wgOQFqhYaT3eLo51nVkF0R2EvkW3EjAvfx7rcvsymRrBw3bBN
         LIKWPgXXJzxvzT7sfMlIvfsPWmsz93FbLeTuC0nDkNq2rW/msX55uoHgiZdKdVuQulcF
         6dxw==
X-Gm-Message-State: APjAAAXOqqCMDWgvKMTTcbfsRnGK/Yk8LiTMMOVfWkwubQoWSLCF4C90
        O66zMCbJM/KwMpRDAPjHDzLdaA==
X-Google-Smtp-Source: APXvYqwdEmw2wSAdMm2uNSwygYS/tReUHa298khqlcEJ6SUMpUUx2ztpYjieysLgrH1cxzIIR9U/9w==
X-Received: by 2002:a5d:6604:: with SMTP id n4mr17380528wru.42.1556086898627;
        Tue, 23 Apr 2019 23:21:38 -0700 (PDT)
Received: from [10.189.18.164] (eth-east-parth2-46-193-66-10.wb.wifirst.net. [46.193.66.10])
        by smtp.gmail.com with ESMTPSA id w9sm25604173wmi.0.2019.04.23.23.21.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 23:21:37 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <EB85EE47-BCCC-4A0C-9A33-0A5AC7239554@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D176D8A4-852F-4A5B-BEA3-8D4911BAAF0A";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext4: cond_resched in work-heavy group loops
Date:   Wed, 24 Apr 2019 08:21:36 +0200
In-Reply-To: <20190423211329.149642-1-khazhy@google.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
To:     Khazhismel Kumykov <khazhy@google.com>
References: <CACGdZYLCi+Or=afmBK8hbP3Ay8x8Oaqnp0Yr+jf1PoQiMc7_DQ@mail.gmail.com>
 <20190423211329.149642-1-khazhy@google.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_D176D8A4-852F-4A5B-BEA3-8D4911BAAF0A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 23, 2019, at 11:13 PM, Khazhismel Kumykov <khazhy@google.com> =
wrote:
>=20
> These functions may take a long time looping over many groups, which
> may cause issues for non-preempt kernels.
> ext4_mb_init_backend()
> ext4_setup_system_zone()
> ext4_mb_release()
>=20
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> v2:
> - a few other places that in testing showed to be slow
>=20
> fs/ext4/block_validity.c | 1 +
> fs/ext4/mballoc.c        | 2 ++
> 2 files changed, 3 insertions(+)
>=20
> diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
> index 913061c0de1b..16134469ea3c 100644
> --- a/fs/ext4/block_validity.c
> +++ b/fs/ext4/block_validity.c
> @@ -155,6 +155,7 @@ int ext4_setup_system_zone(struct super_block *sb)
> 		return 0;
>=20
> 	for (i=3D0; i < ngroups; i++) {
> +		cond_resched();
> 		if (ext4_bg_has_super(sb, i) &&
> 		    ((i < 5) || ((i % flex_size) =3D=3D 0)))
> 			add_system_zone(sbi, =
ext4_group_first_block_no(sb, i),
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8ef5f12bbee2..99ba720dbb7a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2490,6 +2490,7 @@ static int ext4_mb_init_backend(struct =
super_block *sb)
> 	sbi->s_buddy_cache->i_ino =3D EXT4_BAD_INO;
> 	EXT4_I(sbi->s_buddy_cache)->i_disksize =3D 0;
> 	for (i =3D 0; i < ngroups; i++) {
> +		cond_resched();
> 		desc =3D ext4_get_group_desc(sb, i, NULL);
> 		if (desc =3D=3D NULL) {
> 			ext4_msg(sb, KERN_ERR, "can't read descriptor =
%u", i);
> @@ -2705,6 +2706,7 @@ int ext4_mb_release(struct super_block *sb)
>=20
> 	if (sbi->s_group_info) {
> 		for (i =3D 0; i < ngroups; i++) {
> +			cond_resched();
> 			grinfo =3D ext4_get_group_info(sb, i);
> #ifdef DOUBLE_CHECK
> 			kfree(grinfo->bb_bitmap);
> --
> 2.21.0.593.g511ec345e18-goog
>=20


Cheers, Andreas






--Apple-Mail=_D176D8A4-852F-4A5B-BEA3-8D4911BAAF0A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlzAAHAACgkQcqXauRfM
H+AJjQ//egWnCTo2jiw4DtSAWlxwng0FavawWfmuKUmPGmxIBHmw/JM/m86f0JuB
t5SpFCEdHBB7uX3KoxPF6ZF/dbrnToHmv7FGMkb/wBoefxHtbwyBD4UWeZL7ZZ0x
mc17+lEBXsUUOMXJuxr4r+8sZkn9FA+KB51Gmd0NN9R7hinY9Eia1BkDza5MYFf4
Hf/ibSpCCPV5pvSdB0mumTSOYW0bcLXX0Jdz33/Qked7+rgaI8kRgdywFa1cQeGl
+BemfwrGuoT9sOM/pxRxIdnUWARo06Of3RShA9PVA7kurVIwe8yV5gy2dUh1WUuL
FAA2VROXnG7Q1FbAKRSLZbpKyqiGBuJn6wCa9b1/z7zGUYw+T5kIlkOEULpLEM6q
4eufuucMkBWGewNa1PsI+ZKEqfJKhGoBOQj2/114hWdv4ONBbx/VXlNdc2DqIG/Z
fHb+/EvhRIwxYQwYKLB14SdcRTXchBU6F2LTQ2VOB14jBdZQYksSE+KmfZY5Mf/c
Wlzy1OvgT3CrKL4Hk99qtSM1iLF787nQue24+Ig0xyGGLZGJKPBqoebZ4/iDUm1g
mXeHRWkSOiUk5gKZzGvVHHi5UM1RK8tTL39xwOEcjSKdtEJ32hRJSh7FwgfE7E7r
CEFGOKE57oZu0gFJnzddf2DFHds1O9hMky3n7OV1CCFYVgoCrsk=
=+WoV
-----END PGP SIGNATURE-----

--Apple-Mail=_D176D8A4-852F-4A5B-BEA3-8D4911BAAF0A--
