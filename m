Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB8CC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 06:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B0A2146E
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 06:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="mblc99Kr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfBTGbO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:31:14 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:52259 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfBTGbO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Feb 2019 01:31:14 -0500
Received: by mail-it1-f194.google.com with SMTP id r11so12786933itc.2
        for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2019 22:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=c9kA5cEkLIpvfSBuk7L27nOpXkizH6k96zqPlukDGbM=;
        b=mblc99KrncwxonfydVutLCW6WDe/P/W3asE7UbbLqsax8DoIs+zGPE0Ctz79VswmBU
         yvZ1sWUZeg5kCRR2vSwfApBhLSWu90sVTdMpV4wscdqFG4BceyGIUVO2t4GqSUFuTf8d
         9DvqK1oK+lJn0azgfXSrMIA4DgEu9lfAQxHST14A0upEjssbo4q7CT0lJnqWLSFT7t7j
         y/TLAfeYEgfyDj0+lS8HNaRNRPKlxSPyIZJZlx0VEXSs3f7WBcae/nFuX+gfULiZowe+
         kHyPgFqvClq1dSs023hAvBhuicMUmTqjJtllWEcXz2RXZO1VtcP/l6peG6abF8r+p4Sd
         hHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=c9kA5cEkLIpvfSBuk7L27nOpXkizH6k96zqPlukDGbM=;
        b=gJDNJyq3RTsyHTjP52uXZU0JPOZpxHlSTBSMjh95BcIiIRJNMkpMNbwHcKB0xR3iOo
         aX9cQ8oFoRjeAC+xv3TWDZtzC2lNLLLWuigunLwalhCL+f32+qe9SNtiExHTfXb3nZ9M
         YcKXNKoJbtAJ3Km+lFHrdhcDL3pCvemaiRdDRDFlq2wACGmQnSvNtVhmhRSHm2LihUfr
         n2zK0jtcQcnuEEo5T+dZHKMP7d2k2FWVGdJX3rK9X01A8eYNV9yYzWzDewjhiqIQG5nL
         lDZaZ+dfz/M8v97l+yqq2IM1pjqJ6ULKd+HlF2He/GvZ4uCW1t8V9pKG6Dl9IHEKX/+Y
         pB3A==
X-Gm-Message-State: AHQUAuZXDZODMVxRKU6W3oMGMNwCvePbIrSkSaQpa9/czS+xQHRNVfyj
        2s+jreNp6vLIBfgMnXkpAqYcEIJbW1g=
X-Google-Smtp-Source: AHgI3IbPTdbq0dv9UHpEaeSkXhPXNSEzgHp8f84YlLjwq5omCtE0kxVpnUkA3qfhUU2bQ7tzFaLIjw==
X-Received: by 2002:a5d:8404:: with SMTP id i4mr20315521ion.251.1550644273301;
        Tue, 19 Feb 2019 22:31:13 -0800 (PST)
Received: from cabot.frontierlocal.net ([47.158.158.91])
        by smtp.gmail.com with ESMTPSA id 2sm2327774itw.11.2019.02.19.22.31.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 22:31:12 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <A7D7D6A2-E789-4175-9ABC-E35774D5DA2F@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E83A9448-4863-415E-AF63-7FEB0CE41695";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Create ext2 filesystem from a directory
Date:   Tue, 19 Feb 2019 22:31:24 -0800
In-Reply-To: <20190219080333.GA2912@redhat.com>
Cc:     linux-ext4@vger.kernel.org
To:     "Richard W.M. Jones" <rjones@redhat.com>
References: <20190219080333.GA2912@redhat.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_E83A9448-4863-415E-AF63-7FEB0CE41695
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 19, 2019, at 12:03 AM, Richard W.M. Jones <rjones@redhat.com> =
wrote:
>=20
>=20
> This might interest/disgust/shock/scare(?!) people on this list:
>=20
> $ time ./nbdkit --filter=3Dpartition -U - linuxdisk . partition=3D1 =
--run 'qemu-img convert $nbd /var/tmp/ext2fs.img'
>=20
> real   0m1.314s
> user   0m0.424s
> sys    0m0.889s
>=20
> $ ls -lh /var/tmp/ext2fs.img
> -rw-r--r--. 1 rjones rjones 351M Feb 19 07:44 /var/tmp/ext2fs.img
>=20
> Code here:
>=20
> =
https://github.com/rwmjones/nbdkit/commit/6e7908c828e60f082d84d866070fe840=
6e6f2b04

How does this compare to "mke2fs -d <source_dir>"?

Cheers, Andreas






--Apple-Mail=_E83A9448-4863-415E-AF63-7FEB0CE41695
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxs9D0ACgkQcqXauRfM
H+D93w/+Ljg9aB7rsgPiICq+rt+ctKk59xMgtjS1lAPZTivnANHF4POsuJtoInlZ
pViTqmG+657BcWywD4aTofJZ5XWTjucJFdvBW3UCyeR/+RU5xlH65rT2iy0/66AO
cy57/oERyqX/zIa67auExNCJ5+mBOwU0i2e4NbaKWhfb9capfV6rYPODmSsIL0Vh
pQiLNUCgHdIHpbZY63WWRdZtA8blpcf16PCoIR1g5Hu//YSkUtizjKEZiLpYSTuN
aZD1EVvkEV9pg4up7S+AssQSbSAjJMmWMKxsROETIdB4U9kSp5YBxqleaY/Yv86o
MSLz2pjnSBY9ugtcRcQe0qXSkXF/U1qcMmhOiAdqEZ7WDxSNc0VQEv2yd/xPGDUy
F3kb1zu9hlaVlYf6Cnb/sAUKXAtayTbJnFEtLdFxzpQp73dh1eFlnfMkvwPvme41
fMUOpgKM8P52h3V6b/5vAb/bGPbfiUlVdNRUPwcEyU/NKorQPJIvGAa3HRn0K7m/
r7I0L0gPxt3L59AtGw6O6ni1GFvyCA6INQNfHDqy7Hlfa6QCI1I7c6uzImz70I2r
vHrnM7e2oICqPtjcDn/KiDeKLg6tz+sTM9ZJE7XJn6MjtDkqvuOEC6y3pu3FoNRf
Ftf0s3wkLdrkUDEhhyIaEG+quvk8KIdOaTZiO0mdPl7JK/G17GY=
=S+hf
-----END PGP SIGNATURE-----

--Apple-Mail=_E83A9448-4863-415E-AF63-7FEB0CE41695--
