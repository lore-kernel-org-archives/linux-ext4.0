Return-Path: <SRS0=6H3F=RA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB0DC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Feb 2019 18:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD462084D
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Feb 2019 18:57:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="uac7ERBQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfBYS5o (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:57:44 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34695 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfBYS5o (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2019 13:57:44 -0500
Received: by mail-pl1-f194.google.com with SMTP id d15so4929311plr.1
        for <linux-ext4@vger.kernel.org>; Mon, 25 Feb 2019 10:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=UGUv8DKvCQwRzqeKaflTe8qE9Fbgb+0EzqQV8Fbj8TE=;
        b=uac7ERBQ3c4FG8XMowBD4cXysa71KWGSQPVSurPU5NxapapIes5kWN+BeZPIlUzx1G
         /GQzLvmx9rSG2TkXqNI+UO6QpCIKcIvZjThF/xeH2tfsFN2KlKSClOkbwOFPlyxpDUDP
         Uz/6syJ9JjgPdbH6ArYBiiD1jm/zLmO3H8RQ/20kxqIOWAqF8j3i9P9Y4EQEr9tenX4I
         LY6R9akBYTEyy2CD2XZ2etkdHIBNG+Lv23XcpV/T49VUC/sbsR0tBEzE4rP4O9z5rj84
         2gZFWjVAjLOAXsY+W3vKgnOJ2hYGakm55Gm7zwNkNB96Y6i52AoOVL/fvk1Jnb6zXz4T
         GkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=UGUv8DKvCQwRzqeKaflTe8qE9Fbgb+0EzqQV8Fbj8TE=;
        b=V9JNO9Cphsqrvvdg6y3iQVjJwxDcHgvljPhFzmp8weWXhHqFO0lsoopT7XhjXy1WxN
         YumijEe0R2jN6R0nr3MeSR5WVSZbVmZ4tfdBeBI+5/lQVGoG9v2UaBrbgp4Mm61gfLPH
         714Y3xDICD88TnmYNH74Vk0CxkZELSnL503M7HnTteDLUhR2i2X1BHwNCzJ2vlUxVVN9
         FoyWA6582kNnCJlMcCUBbN9YtOYM8dHrcuk4PsVRuF06Ga0cG79zQGFV133Fmj7UV9/+
         /tDyRpgnoH6bmHuo6dDLuvmJBJEC2T0RWbPB1VKL031PE1HuurrBsuvPl90K0q78wYwY
         KH0A==
X-Gm-Message-State: AHQUAuac/hudZ5jcNsF3m9v7PeRdyMdpIl8Es0Tp2u3u3VKTSzTHAXi+
        5UGfjEV0NLNlkYRZ0itZmsihdg==
X-Google-Smtp-Source: AHgI3IYB7+SqMtLTi2wpIC2o9K7oBxUZv2ykpbjywpsf3FqxGh+hCqHXrgzQPB2K7IKX/iruT5H+Og==
X-Received: by 2002:a17:902:2a69:: with SMTP id i96mr21709383plb.58.1551121063620;
        Mon, 25 Feb 2019 10:57:43 -0800 (PST)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id j197sm17946447pgc.76.2019.02.25.10.57.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 10:57:42 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <93AE6EDF-EF5B-4BD8-8A04-12480CF81134@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_959B59C0-D4AE-47CA-8752-F89A3A9AC0FA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3] tests: replace perl usage with shell built-in
Date:   Mon, 25 Feb 2019 11:57:51 -0700
In-Reply-To: <1544724399-84147-1-git-send-email-adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
To:     tytso@mit.edu
References: <1544724399-84147-1-git-send-email-adilger@dilger.ca>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_959B59C0-D4AE-47CA-8752-F89A3A9AC0FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 13, 2018, at 11:06 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> A couple of tests use perl only for generating a string of
> N characters long.  Instead of requiring perl just for a few
> tests, use shell built-in commands and don't spawn a separate
> subshell just to get a string of characters.
>=20
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Ping.

> ---
> tests/d_xattr_sorting/script    |  3 ++-
> tests/f_badsymlinks2/mkimage.sh |  4 +++-
> tests/f_create_symlinks/script  | 12 ++++++------
> util/gen-sample-fs              |  4 +++-
> 4 files changed, 14 insertions(+), 9 deletions(-)
>=20
> diff --git a/tests/d_xattr_sorting/script =
b/tests/d_xattr_sorting/script
> index 8666115..49bcece 100644
> --- a/tests/d_xattr_sorting/script
> +++ b/tests/d_xattr_sorting/script
> @@ -22,7 +22,8 @@ echo Exit status is $status >> $OUT.new
>=20
> B=3D$(mktemp ${TMPDIR:-/tmp}/b.XXXXXX)
>=20
> -perl -e 'print "x" x 256;' > $B
> +F=3D"xxxx"; F+=3D$F$F$F; F+=3D$F$F$F; F+=3D$F$F$F
> +printf "%s" $F > $B
>=20
> echo "ea_set -f /tmp/b / security.SMEG64" >> $OUT.new
> $DEBUGFS -w -R "ea_set -f $B / security.SMEG64" $TMPFILE >> $OUT.new =
2>&1
> diff --git a/tests/f_badsymlinks2/mkimage.sh =
b/tests/f_badsymlinks2/mkimage.sh
> index 6bbf020..fe0ebb7 100755
> --- a/tests/f_badsymlinks2/mkimage.sh
> +++ b/tests/f_badsymlinks2/mkimage.sh
> @@ -18,10 +18,12 @@ do_tune2fs() {
> 	mount image mnt
> }
>=20
> +A=3D"AAAA"; A+=3D$A$A$A; A+=3D$A$A$A; A+=3D$A$A$A; A+=3D$A$A$A; =
A+=3D$A$A$A
> symlink() {
> 	local len=3D$1
> 	local src=3D$2
> -	local target=3D$(perl -e 'print "A" x '$len)
> +	local target=3D${A:0:$len}
> +
> 	ln -s $target $src
> 	stat -c %i $src
> }
> diff --git a/tests/f_create_symlinks/script =
b/tests/f_create_symlinks/script
> index 169f58d..72741fd 100644
> --- a/tests/f_create_symlinks/script
> +++ b/tests/f_create_symlinks/script
> @@ -15,22 +15,22 @@ fi
> dd if=3D/dev/zero of=3D$TMPFILE bs=3D1k count=3D512 > /dev/null 2>&1
>=20
> echo mke2fs -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I =
256 test.img 1024 > $OUT.new
> -$MKE2FS -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 =
$TMPFILE 1024 >> $OUT 2>&1
> +$MKE2FS -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 =
$TMPFILE 1024 >> $OUT.new 2>&1
>=20
> $FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT.new 2>&1
> status=3D$?
> echo Exit status is $status >> $OUT.new
>=20
> +B=3D"xxxx"; B+=3D$B$B$B; B+=3D$B$B$B; B+=3D$B$B$B; B+=3D$B$B$B$B$B
> for i in 30 60 70 500 1023 1024 1500; do
> -	echo "debugfs -R \"symlink /l_$i $(perl -e "print 'x' x $i;")\" =
test.img" >> $OUT.new
> -	$DEBUGFS -w -R "symlink /l_$i $(perl -e "print 'x' x $i;")" =
$TMPFILE \
> -		 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT.new
> +	echo "debugfs -R \"symlink /l_$i ${B:0:i}\" test.img" >> =
$OUT.new
> +	$DEBUGFS -w -R "symlink /l_$i ${B:0:i}" $TMPFILE >> $OUT.new =
2>&1
> done
> +unset B
>=20
> for i in 30 60 70 500 1023 1024 1500; do
> 	echo "debugfs -R \"stat /l_$i\" test.img" >> $OUT.new
> -	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | \
> -		 grep -v "time: " >> $OUT.new
> +	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | grep -v "time: " >> =
$OUT.new
> done
>=20
> $FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT.new 2>&1
> diff --git a/util/gen-sample-fs b/util/gen-sample-fs
> index 8e13916..a92c822 100755
> --- a/util/gen-sample-fs
> +++ b/util/gen-sample-fs
> @@ -7,8 +7,10 @@ cp /dev/null $FS
> mke2fs -q -t ext4 -O inline_data,^has_journal -I 256 -b 4096 -N 64 $FS =
256
> mount -t ext4 $FS $MNT
> ln -s symlink_data $MNT/symlink
> +
> +L=3D"xxxx"; L+=3D$L$L$L; L+=3D$L$L$L; L+=3D$L$L$L; L+=3D$L$L$L
> for i in 30 70 500 1023 1024; do
> -	ln -s /$(perl -e "print 'x' x $i;") $MNT/l_$i
> +	ln -s /${L:0:$i} $MNT/l_$i
> done
> touch $MNT/acl
> setfacl -m u:daemon:r $MNT/acl
> --
> 1.8.0
>=20


Cheers, Andreas






--Apple-Mail=_959B59C0-D4AE-47CA-8752-F89A3A9AC0FA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlx0Oq8ACgkQcqXauRfM
H+BvxRAAgrENoE4IzixEkpFjipyQTAwA+e1OKzps2NNlpzCPwn+qVUUtERpW3TgV
TCBGQ+yNVUkp2XvXsv3UO+8B1hNTQ0UOPwGjcUthmESbcXZRuNeP1kw3tem3ofLG
CBl8+dFN7a8C4t1RzPoJ37ZChWORH4cn1IIZUrZrSdAaIzAlbh6KXHs7FxrHeNj+
OPAPdWb8qfQjANTXdk4IBnLZISmvtuI9wbmyTFuc57a+TNznQMzEGNAnTqMh2aOn
Fc8Lsnbd+us8xruypJrWtFxEPCgn2O0YxMiM3oszkqGdv7/EpAresmNxT9BE2idR
j3Pmyms1kmZonyeltHOainpwqlmrg0+jy/+9ZPbwT0uiAwPDT8Wl32qw9J8GXvsG
W9I6iNTQoFA1PA66ne542rZDmyjKUPDHtNqCcWtXX9lAtpYbI9U4IIZAr9z78e1E
lkGRNNlje2ttHWKmt6UE6hSy+7JEmwAMgoGeNuwPokq+8QMnOJwL0LxsAzt6vo45
wxxNXEF+wzU+UdnoSzHU2++rZjkhGVrGKQ3LLWN09KshGJ/mVcXDCPJUiOH5I2Vw
FplRAaGW7gIbHVZAWFSyde8+W7pcR+NDoXvzCsv59oO2Kqxd3NBsrMmZzHxlTXxm
GuzbFFZoCpukNiz/o+k3fHidu2nMVl6zCfsVDef1jBDpfccj9f4=
=Ht8W
-----END PGP SIGNATURE-----

--Apple-Mail=_959B59C0-D4AE-47CA-8752-F89A3A9AC0FA--
