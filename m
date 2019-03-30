Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B7CC10F00
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 17:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D567218D0
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 17:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="L9as/1WE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbfC3Rso (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 Mar 2019 13:48:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38664 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730577AbfC3Rso (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Mar 2019 13:48:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id g37so2485921plb.5
        for <linux-ext4@vger.kernel.org>; Sat, 30 Mar 2019 10:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=LT+gDc/cjRltktIAZXspx4BzuMjE/oNRPe6UXXiO9Ns=;
        b=L9as/1WExx8EGsmdDkTAxlbfKQ7vvfnYY0OPtLel3OyMLw28EF6hZYirKcVQP/YST0
         bM2umzyX1OhnmlinT5iHflUoo0ivhI/Xl8d3gzvA2GX75thZou6YggSsLie70F9ucMlD
         S7WCjE2okEF4x68gxUdTQvO7n53Djyb6lvW9HU3hGwbiE/GvfvIg+qgAC7q9ep4p1CeY
         EkOHWLnVoEgvHelmX7XVqBKKBySy6PHsj6Pw0N7b8RQkdJwMIqKPnoWH20Y5VmIcfzPi
         hnan7x6yK4mIdEYn0a2P0ZvyRHZu0KC7Y2HS3r06PIRs78zqRSHBKssxsXwbhwFbVG6y
         mAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=LT+gDc/cjRltktIAZXspx4BzuMjE/oNRPe6UXXiO9Ns=;
        b=qQomeg6eDBpNnu2kp/Pmno8cIQdSe0pn8tYBD9swk8SlwdGF6qucPOJ5mbqgWtJCJv
         MwarD5kOOlxaBf542aSb2qMrz4upCSbaQB9aE6FRNOW6Xy7XBDcW5kkSqPGtdpVK+1+p
         I5d1axoocalxqFSzpi1YF6e6l0ZCEvwukivCm87FqXBai30IRYkosmLxni/TYlzr+svI
         P/oPDNSjlx4aEtZsqNka7cIc8TnCmHzyeSc/rOik2bR8+y0Nfd+3GeHWl8XMt3Fcwf4Z
         c1mWarwc1pdVkjoi3T42EvyFiDNP4cTqfk3DzCJH6udkwaf1apdQ3GKH0nOxAn1LGH7O
         VFdg==
X-Gm-Message-State: APjAAAUwvIlTXwXkoiSvsqIkeocavaRZaOYBRJ+L66ZSLfFP2KJ+viF3
        /+ojijWRgas06+Cpsw1WUiwdbQ==
X-Google-Smtp-Source: APXvYqzhe1NgPtvc3Ny2C+7K8Qenu40WRjkKPz6CkBNv1YnJygduOOc18RcZ4JjEaTrHgvxEyYK0eA==
X-Received: by 2002:a17:902:8643:: with SMTP id y3mr55147709plt.195.1553968123349;
        Sat, 30 Mar 2019 10:48:43 -0700 (PDT)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id g5sm9538039pfo.53.2019.03.30.10.48.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Mar 2019 10:48:42 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <FCE37AF6-FAD4-4968-B5DE-64399A8D5C9A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_36254D51-4FD7-4C4F-8520-DF4DFB79B543";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 1/7] block: extend stream count for in-kernel use
Date:   Sat, 30 Mar 2019 11:48:38 -0600
In-Reply-To: <1553846032-4451-2-git-send-email-joshi.k@samsung.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com
To:     Kanchan Joshi <joshi.k@samsung.com>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075743epcas1p12f1d290e65ddf84eb74ed94a5ae6eb74@epcas1p1.samsung.com>
 <1553846032-4451-2-git-send-email-joshi.k@samsung.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_36254D51-4FD7-4C4F-8520-DF4DFB79B543
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2019, at 1:53 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>=20
> This patch bumps up stream count to suppor in-kernel hints. It also
> adds 'streamid' member in 'request' and declares new API for driver
> to register stream-info with block layer.
>=20
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
> include/linux/blkdev.h | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 338604d..4088e21 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -214,6 +214,7 @@ struct request {
> #endif
>=20
> 	unsigned short write_hint;
> +	unsigned short streamid;
> 	unsigned short ioprio;
>=20
> 	void *special;		/* opaque pointer available for LLD use =
*/
> @@ -341,6 +342,8 @@ struct queue_limits {
> 	unsigned char		misaligned;
> 	unsigned char		discard_misaligned;
> 	unsigned char		raid_partial_stripes_expensive;
> +
> +	unsigned short		nr_streams;
> 	enum blk_zoned_model	zoned;
> };
>=20
> @@ -567,8 +570,9 @@ struct request_queue {
> 	size_t			cmd_size;
>=20
> 	struct work_struct	release_work;
> -
> -#define BLK_MAX_WRITE_HINTS	5
> +#define BLK_MAX_USER_HINTS	(WRITE_LIFE_KERN_MIN - 2)
> +#define BLK_MAX_KERN_HINTS	4
> +#define BLK_MAX_WRITE_HINTS	(1 + BLK_MAX_USER_HINTS + =
BLK_MAX_KERN_HINTS)
> 	u64			write_hints[BLK_MAX_WRITE_HINTS];
> };
>=20
> @@ -1071,6 +1075,7 @@ extern void =
blk_queue_update_dma_alignment(struct request_queue *, int);
> extern void blk_queue_rq_timeout(struct request_queue *, unsigned =
int);
> extern void blk_queue_flush_queueable(struct request_queue *q, bool =
queueable);
> extern void blk_queue_write_cache(struct request_queue *q, bool =
enabled, bool fua);
> +extern void blk_queue_stream_limits(struct request_queue *, unsigned =
short);

This declaration should be in the 2/7 patch where the function is added.


Cheers, Andreas






--Apple-Mail=_36254D51-4FD7-4C4F-8520-DF4DFB79B543
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyfq/YACgkQcqXauRfM
H+Bp0w//bClHuECeaul+BcHUe4kQEKqJ2tPHEeURwIJ6aQkJ08b5SJsQwv96gyzb
q5kSMY4eoaiM9mpMPIcKY16ZQy+P0sTyP+zLnE5GxhEOWAIPVxk5Pizb330hIjLS
DNqFRnurckrliUIkDmcnrgW7hqfY10UAkIuWZjQzBYa+6d1RIYNnDx4qXMTeR4JZ
ZueztUxkDSSCmMFCWfPWEGJhfduDdyBjF7M2+cVKvBiOStsIpLDXGwMkeTvfk+N2
RwaUKiVAEuG+2FBEp6CiYDc2BuubnxZE19JeYCMI0UuBFa8jC15U5WfaLW60nMHL
WZrCsB8aHkY8I2bvPI7Xyg7iXPKHXXBH+YGV5v90YShUunM1MHVY13kEyG2P00rT
Xx1ywc4mxLP/AUeVO4GuqXlRGkKAaWRi1+8dG1bKbmYhb7goGPRUpZgEWKsNR6tL
kd8jyH8JfxGbIHjwRWvhrL6hcojfdQoLncVS4OCcLDBQ3b1m4hRKDc2i2KDWV+Gk
FR0PU94LYcK9ZMyY2ITwSAMmdbQg5V7XUw9wzigZ2PGmZdxQQa7vnX2TVBdG2uDb
32HNosnKv7xT4sz5kyICoM7g2iHr1hhmznhJ5LXtdMs0FTWXkSPeycDIc2ss2Hk2
OBj1JA+U6EXYMTu5wxLJmc1eOi8eb5M8xyn0PLvuV1GWXoKkdTI=
=52IS
-----END PGP SIGNATURE-----

--Apple-Mail=_36254D51-4FD7-4C4F-8520-DF4DFB79B543--
