Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04078C282D7
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 18:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5E302083B
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 18:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMdyy5cy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfBESKq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:10:46 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39541 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfBESKq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2019 13:10:46 -0500
Received: by mail-wm1-f67.google.com with SMTP id y8so4721729wmi.4;
        Tue, 05 Feb 2019 10:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ROnhP+/pkJ6/Z48cSeE/m4LQ/2qmMpDpwJCIMwsK/J8=;
        b=ZMdyy5cyPyZwJXA0icH4r3heIsFz0pvCAIxg4OmZ5uLUI/lJDAMPyen2DAzRThoXlP
         SJbQJmN2L/jC10Vzx+kMhMaBZnSdjsYrGqIDXmE83zCO4BYLj5YWdSbBZvYJcy4aRCvV
         M1+j+I1H4rmc90PC9F3qAE4t57XT++2g2adPsPX2LRnlQWHo6pP1NgFZNx0FcW2Dei/I
         pLnIt+Wt/bESrtSHxBMm0LrycQtV06Nh7wa9FYE9gHz4HAEtsgAx2GHf8df4ZL93nzaP
         PZLOP7RGZ3mQ52ukXb1HmWsWgNqA/RDNcJ6Mcu+pBcIeAT3TY1KNQUvLLXtHI4zDHxeq
         Lszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ROnhP+/pkJ6/Z48cSeE/m4LQ/2qmMpDpwJCIMwsK/J8=;
        b=DW5kWWSE8CTauGuPIeYktYCD7kTerOnFfuJ0bXGL764koJz4NaJEyXgrwQZ/kejfye
         sD3XDvj/ax0gp1xGE32iyt6Azwv8CEZ7JKo5duepxeP4do2MLuQVC31ZskpylUk/D4Rq
         WBpcjGv+zepIeYf2K62lLAyrQJ6/1k82IKL/kl3YCDeYyKCbwRyUDe49WhexWLRpg4HL
         eFsRVxo4LHY/FeLD4LWPOBjkUV7GZjS1m/2oXFcLBUoO2BMqf31w/qm9BzP7GPUVDgfp
         N90YJz6UB6BDyGDAnYcsYxC9+rM6AKoUlKXShrcniLVIfEmN1CdvfO1J5kIezf+hGLIz
         hi2g==
X-Gm-Message-State: AHQUAuZpt6hE4WEnEhr/BYKtxD6qK98WrKTN1Z62ozQeG3ZQfhhds4il
        YD7PHK8z8hgaSq2+A3J5pWg=
X-Google-Smtp-Source: AHgI3IY2lx4HqYwaJAYb8apvosDLbP+E0SkUX9GP3ZSpwF7acWZt1HLll9HO9QejTdtyWVaavXZUMQ==
X-Received: by 2002:a1c:e488:: with SMTP id b130mr4881504wmh.124.1549390244345;
        Tue, 05 Feb 2019 10:10:44 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id m4sm14816541wmi.3.2019.02.05.10.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Feb 2019 10:10:42 -0800 (PST)
Date:   Tue, 5 Feb 2019 19:10:41 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, samba-technical@lists.samba.org,
        jlayton@kernel.org, bfields@fieldses.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
Message-ID: <20190205181041.cdyt5jt7yrqswyy2@pali>
References: <20190128213223.31512-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="w2jqy5mjgvwkwdk3"
Content-Disposition: inline
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--w2jqy5mjgvwkwdk3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Monday 28 January 2019 16:32:12 Gabriel Krisman Bertazi wrote:
> The main change presented here is a proposal to migrate the
> normalization method from NFKD to NFD.  After our discussions, and
> reviewing other operating systems and languages aspects, I am more
> convinced that canonical decomposition is more viable solution than
> compatibility decomposition, because it doesn't ignore eliminate any
> semantic meaning, like the definitive case of superscript numbers.  NFD
> is also the documented method used by HFS+ and APFS, so there is
> precedent. Notice however, that as far as my research goes, APFS doesn't
> completely follows NFD, and in some cases, like <compat> flags, it
> actually does NFKD, but not in others (<fraction>), where it applies the
> canonical form.  We take a more consistent approach and always do plain N=
FD.
>=20
> This RFC, therefore, aims to resume/start conversation with some
> stalkeholders that may have something to say regarding the normalization
> method used.  I added people from SMB, NFS and FS development who
> might be interested on this.

Hello! I think that choice of NFD normalization is not right decision.
Some reasons:

1) NFD is not widely used. Even Apple does not use it (as you wrote
   Apple has own normalization form).

2) All filesystems which I known either do not use any normalization or
   use NFC.

3) Lot of existing Linux application generate file names in NFC.

4) Linux GUI libraries like Qt and Gtk generate strings from key strokes
   in NFC. So if user type file name in Qt/Gtk box it would be in NFC.

So why to use NFD in ext4 filesystem if Linux userspace ecosystem
already uses NFC?

NFD here just makes another layer of problems, unexpected things and
make it somehow different.

Why not rather choose NFS? It would be more compatible with Linux GUI
applications and also with Microsoft Windows systems, which uses NFC
too.

Please, really consider to not use NFD. Most Linux applications really
do not do any normalization or do NFC. And usage of decomposition form
for application which do not implement full Unicode grapheme algorithms
just make for them another problems.

Yes, there are still lot of legacy application which expect that one
code point =3D one visible symbol (therefore one Unicode grapheme). And
because GUI in most cases generates NFC strings, also existing file
names are in NFC, these application works in most cases without problem.
Force usage of NFD filenames just break them.

(PS: I think that only 2 programming languages implements Unicode
grapheme algorithms correctly: Elixir and Perl 6; which is not so much)

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--w2jqy5mjgvwkwdk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCXFnRnwAKCRCL8Mk9A+RD
UvcyAKDB0sf4YrLMN9AZJ0FuR0oBhIDbLACfWvKFb9rZL6DyMKk9U38GF5XVrV0=
=6S7p
-----END PGP SIGNATURE-----

--w2jqy5mjgvwkwdk3--
