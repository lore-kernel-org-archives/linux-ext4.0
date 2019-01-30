Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFD9C282D7
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 17:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58F5220833
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 17:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="gs0uJGpQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfA3R7D (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 12:59:03 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45144 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfA3R7C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2019 12:59:02 -0500
Received: by mail-pg1-f196.google.com with SMTP id y4so130999pgc.12
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2019 09:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=xUYmk5M7b6Jo1JrZhhN8GtG8z+9/VSEeLJQ3Y57IAXs=;
        b=gs0uJGpQK9M8LaesWOSl/orYEGGKrua1qtSnotYGY26qTz1oVm8JbzXgeRxbOsC36x
         3lR9FXC9CVtjLQ6TU8t1Yl369My+70+mrGbs5wQCzN4XsDf3CAmg16EdzkSz+vNOSyaG
         ZVwOoDNbceOt1BeR9EBvmMCaMfeyAW63r2pWGy8tKIJqB7MK3EeOAGv0GzEviEy0eucv
         Z6TuHUFs+FPiOjf2naaM/Od7s1SNaochvzKKyusF1IIYhEhhEWoQeR/KZOsaHwLM+4pa
         Najr45+bLpwPuw0aeaHC4U0yrCYRg0gIbLUMWGEVZFCxO6yqj3QpWyoK7dt7ADHQxI8O
         ykJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=xUYmk5M7b6Jo1JrZhhN8GtG8z+9/VSEeLJQ3Y57IAXs=;
        b=QmDU5X7CXC8woorgtKzq4WXgtEe19E/Afg8p4s/q4JuElm8Mw5jJSNWx3C7UTPep4Q
         u/bmej5mM8A1Du4dhHw59z965CmiSXo83MVdueAECvs4ZRi8yN5oRGKK6jAOfTlXeqSZ
         N/SrTRa7LOvOm/OKv0SIns2dxZtq3Pd+a/pdM4B07touJgrurDvEkzY80lshIDKAtabV
         gSqpbjxUORljtS5mUG00TKk4zkPqac/RH9mH3NvRUPM0kHHmI1/weKcypX+JwJLFARlq
         fZq3gHoNPbG9q8V8QrTBzt5E7eoUopwvsdqvUTI4eFaWtrEjHVN431FV4UeRTI3IfyW/
         /r2A==
X-Gm-Message-State: AJcUukdJme6o+0n6Rws4X0eTheZPPINg2hBt9m3dOa7YwutUpFbuwnpJ
        XsBK2QqS/xaJK870P6oHYivAOA==
X-Google-Smtp-Source: ALg8bN4oATzdVR3OjcUWZLAqJIhsp2rqkLr8NqK1rc7oDxEnoVA/KkR7HVSH8NNbQpDG82aanxtH2Q==
X-Received: by 2002:a62:3888:: with SMTP id f130mr30815589pfa.132.1548871141609;
        Wed, 30 Jan 2019 09:59:01 -0800 (PST)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id e123sm2948403pgc.58.2019.01.30.09.59.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 09:59:01 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <CA49E193-ADAA-4D69-8378-D35BEF0B72C5@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BD737D8F-F6F1-459D-9C54-7743A378B729";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 1/2] e2fsck: allow to check >2GB sized directory
Date:   Wed, 30 Jan 2019 10:58:59 -0700
In-Reply-To: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_BD737D8F-F6F1-459D-9C54-7743A378B729
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 14, 2018, at 12:50 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> After large_dir feature has been added, e2fsprogs is
> ready for directories > 2GB, so we can remove e2fsck
> directory size check.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/pass1.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 5c0b92d5..5c413610 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -3647,9 +3647,12 @@ static int process_block(ext2_filsys fs,
> 		}
> 	}
>=20
> -	if (p->is_dir && blockcnt > (1 << (21 - =
fs->super->s_log_block_size)))
> +	if (p->is_dir && !ext2fs_has_feature_largedir(fs->super) &&
> +	    blockcnt > (1 << (21 - fs->super->s_log_block_size)))
> 		problem =3D PR_1_TOOBIG_DIR;
> -	if (p->is_reg && p->num_blocks+1 >=3D p->max_blocks)
> +	if (p->is_dir && p->num_blocks + 1 >=3D p->max_blocks)
> +		problem =3D PR_1_TOOBIG_DIR;
> +	if (p->is_reg && p->num_blocks + 1 >=3D p->max_blocks)
> 		problem =3D PR_1_TOOBIG_REG;
> 	if (!p->is_dir && !p->is_reg && blockcnt > 0)
> 		problem =3D PR_1_TOOBIG_SYMLINK;
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_BD737D8F-F6F1-459D-9C54-7743A378B729
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxR5eMACgkQcqXauRfM
H+D2ew/+Mg8zFSCRqlcGqGj8jrVSY09uRshRDBBAOD8ivGwQ2gqmHqna3PxQsm7/
xNq0mrBY2OXRKrSmERvNS+X7cLcTjYw1mXtArbr3oTyLe703RqthtV6X7O7mCvf+
QGVssUpCLaNcFcLsvC/3SEq2onyQhGgke9d/Zq9I+biyiz9WUsjc94ApwWEkhnpQ
4s+tXAHLdWgU/HvjiDvbVbuqBJyk5Et8mXHTqRraqKezIif44ThpYzU51elRcRx8
hWny/i3wVJyJlAFuvecCcAAECjyfI2kziY9vS9zd/lbGsUAFy4hXhUasyuEd8762
vEwy9a+U7CcTQRADLvlvozi7ZVCvAzSsFvpLhsTqfPWdrB6SBhbebJr9BOwn7wvH
TEYWkMzhZUiEIhHt1AAx6//UfBCTEg8dM8MVOlRIpD0RiqXfwXE4PXGRhqvf2eg7
DRx0OrnoNR7OaXbbrEcVbLOyhkuklppatjSBW1s2tmlb6/Vwmj6o9vMcMLY5uyiG
X8+40S8EzvZtVhAGlpAl2gHKWMJfA4fmp/EKNfreWVcXB7Mp4VcJDBTPGUJbXVd1
BQPwe4aU+NysyaeL/ZrK+rK3IOj1JY4h/uMv6rXtbRC7vyCstlkODeylQG020tvc
NyyTF+iVWjxxNIpaSoeV2hI7yVAn6r6gCoFHqXa1WjgYhafC6C0=
=CIzH
-----END PGP SIGNATURE-----

--Apple-Mail=_BD737D8F-F6F1-459D-9C54-7743A378B729--
