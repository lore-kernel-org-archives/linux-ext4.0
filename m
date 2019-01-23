Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1898FC282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 18:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32B221872
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 18:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="1WcYOx40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfAWSft (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 13:35:49 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33284 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfAWSfp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2019 13:35:45 -0500
Received: by mail-ed1-f66.google.com with SMTP id p6so2544416eds.0
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 10:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=teV05G8bPtIQJMZiCG/EVzI0eOkvLzZEGlVk8GwtzsY=;
        b=1WcYOx40H0VuCp9yT4MVQVz2/3wHm6clMWhJPuKdZLSnHEz+CXpBOI9P9cyWUigkzy
         CcQQyHtzuSchg7ZfVfyR9AkrtXHleCAJ5QTDUVNHllCZvD6x+uOqEGpxWug/EwdYdb4R
         IKWfDPfzAy/d3RHQJ5g+lipVprL9CfQ+0o1kgZjgV0I46KHTy8SiCyI5fHV/XbeehZl4
         MEZGDOjj7H1wiHrogSU7Y+bjofotdiUCFml/rDmMk7bpU1rNs7hdeUWQv1sz76FdAo+i
         ocaRICIesTAWBU7HrRRQexzRqLyR/26wG+wGERet2ifeG+ecxsqqwl3yh+VnGqW/3/YU
         X9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=teV05G8bPtIQJMZiCG/EVzI0eOkvLzZEGlVk8GwtzsY=;
        b=FtVKda9bHiMtV/jnGkd3LXKDcKet1ssCmci01ImBwyQcChOU8MegutZ+uyHLe51oi1
         wL4Ix16i5+oIhtEKGsq7NdytjrPrNcoaw1Gix+uR97QqKQlAbVEUKvslIuRoe65+pL68
         8n+RQDfr8twAVJ5GgIvU2/K3pDrJTPnJFXsLJd9nVgoDOr5zQq3A8GHeZ82jJ9pkv0gf
         kMuah2CjTveOXZDXNYX9XQZ8peDLQ4GDXLnkFHuK5IEtaPiDdSz4q2bSmm/Uvxd2BJIW
         SgevKRHexcwY40Bx3f9TbXMUBf2TwMCm0ku9MvgyLMaVM0e1noGouV5f758BCFbCnzNV
         m1fw==
X-Gm-Message-State: AJcUukebUINm3iT+hXb7xT2C8GHq/njupuS6OhnP1EhgsXcI5iB7pmwG
        6/fZfqPtsi3zFQnBa77YetLxGRcygS6uTA==
X-Google-Smtp-Source: ALg8bN675PxHWVqY5l6ltnJXNDsf+2m5w7OqUbkk/45O152/5msrZpvBATMCltNX967FltLQZVQX5w==
X-Received: by 2002:a17:906:6a9b:: with SMTP id p27-v6mr3419247ejr.235.1548268543655;
        Wed, 23 Jan 2019 10:35:43 -0800 (PST)
Received: from [192.168.1.85] (ip-5-186-122-168.cgn.fibianet.dk. [5.186.122.168])
        by smtp.gmail.com with ESMTPSA id p1-v6sm5440202ejo.49.2019.01.23.10.35.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 10:35:43 -0800 (PST)
From:   =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Message-Id: <B766FDC6-0B26-4D25-95B6-26807D3E2C79@javigon.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_128C7BFC-A885-48CF-8BEF-6C418FD2A992";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 12.1 \(3445.101.1\))
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Date:   Wed, 23 Jan 2019 19:35:39 +0100
In-Reply-To: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        jack@suse.com, david@fromorbit.com, tytso@mit.edu,
        prakash.v@samsung.com
To:     Kanchan Joshi <joshi.k@samsung.com>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
X-Mailer: Apple Mail (2.3445.101.1)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_128C7BFC-A885-48CF-8BEF-6C418FD2A992
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On 9 Jan 2019, at 16.30, Kanchan Joshi <joshi.k@samsung.com> wrote:
>=20
> Towards supporing write-hints/streams for filesystem journal.
>=20
> Here is the v1 patch for background -
> https://marc.info/?l=3Dlinux-fsdevel&m=3D154444637519020&w=3D2
>=20
> Changes since v1:
> - introduce four more hints for in-kernel use, as recommended by Dave =
chinner
>  & Jens axboe. This isolates kernel-mode hints from user-mode ones.
> - remove mount-option to specify write-hint, as recommended by Jan =
kara &
>  Dave chinner. Rather, FS always sets write-hint for journal. This =
gets ignored
>  if device does not support stream.
> - Removed code-redundancy for write_dirty_buffer (Jan kara's review =
comment)
>=20
>=20
> Kanchan Joshi (4):
>  block: Increase count of supported write-hints
>  fs: introduce four macros for in-kernel hints
>  fs: introduce APIs to enable sending write-hint with buffer-head
>  fs/ext4,jbd2: add support for passing write-hint with journal.
>=20
> fs/buffer.c                 | 18 ++++++++++++++++--
> fs/ext4/super.c             |  2 ++
> fs/jbd2/commit.c            | 11 +++++++----
> fs/jbd2/journal.c           |  3 ++-
> fs/jbd2/revoke.c            |  3 ++-
> include/linux/blkdev.h      |  5 ++++-
> include/linux/buffer_head.h |  3 +++
> include/linux/fs.h          |  5 +++++
> include/linux/jbd2.h        |  8 ++++++++
> 9 files changed, 49 insertions(+), 9 deletions(-)
>=20
> --
> 2.7.4

Worth sharing the paper where you describe the design and the numbers
you collected [1]. Also, addressing Dave's comment on stream support, it
points to a Samsung drive supporting streams (PM963). In this context,
you should verify in V3 that we are at least passing xfstests and
blktests with these changes.

[1] https://www.usenix.org/system/files/conference/fast18/fast18-rho.pdf

Javier

--Apple-Mail=_128C7BFC-A885-48CF-8BEF-6C418FD2A992
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEU1dMZpvMIkj0jATvPEYBfS0leOAFAlxIs/sACgkQPEYBfS0l
eODJtBAAgwyYs2lwzgDn4YOdpjFloR4PeYu18mA2ZNNeGdeTvzSRNqOwtiP2ATGb
8+IiMecChBGZt6Z1zQ3YtZEwCpWJsgAkdhWt5lGNLVnLMuu/NBPEvDKTh40AnDpj
DumwBWwWxFp4QEUE2eYmyVOJE3uW5HQ3u7DYcX6l8kddK6HMdXNQZuRH+xjihxPF
VzeGb+GB3+4deEqWpE+buBBEQbpL7Gpkjx7YMf/+05EDk9JMA7YnWnWQK/g38/i5
j0fJWZYASSMgw3veu5PIH5HjUp9UidxC4qP+CgvJx6wOWie9BH3rDAEjUUm5IQPO
9w4yA05GGdN38uRQHMo7xLqkETPFG4YGP8mtkHlH2UvR9I2rskqWB3rvXxwbBkIB
XquWwT02+yrACy9jC6dek4ld4Y/Tgo1wDgAEt41V52f3w4nFhjECYlNjdnDA+5CA
1QkRYqZDG+We4Qdv0OVKUrgMXJlYy9j+1QKRa2wTXX82nF237PVLB/6FbNH5tb68
OFrvHr6wqttfZ4utHGxnbGviVS5WDIFyq6Ozm8CFoAxO/xwfUaBOrij7XOLTSa7m
v5cWdikrKEhvcdoRHC3+rdckjQbF+CoCP+t1xT53tyS2YiqlxwLpK30N3x1Amx+E
p+HLI/xmlIkCs5H1C+fqC2xxOVAoWw+vmGskyaDCJQHQ3g4HgGI=
=v9JG
-----END PGP SIGNATURE-----

--Apple-Mail=_128C7BFC-A885-48CF-8BEF-6C418FD2A992--
