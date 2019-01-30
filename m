Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3D2C282D5
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 09:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7889520870
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 09:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4orILP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfA3JB2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:01:28 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40644 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfA3JB2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2019 04:01:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id v5so16779678lfe.7
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2019 01:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=upRNkTZZi6LaD2Dm0RaHhzXbs3nujCa7VGrk0BrxMno=;
        b=I4orILP0sywMZydMZXcOANtxPgta/+jSDY2xMDX99wAImUPi7bUdZu6pkUIWsJx5Zm
         3sDdEQmoiDE/wgMTWMX78xyI0w8fWLXTat4hWgRK4bZ9vp84RBNdhmhDs45O+Zca6IhX
         flmj7tSduibpEwYwmJVS7iV6PBM30TaWBMSGPdKznNBKoZezeRfmPCQ6xs6mPDEtcBk1
         FiQhPlThRwDkc0Mv4T4wmN0Dl4WOSHeICStkh4q7n77yWUOz92RX6hre3Nghi3QI8BKU
         Qf1EtXJnFwmPsFo7hODMJhMJde27a1FwAEjJWPC8CvwmusI9gDqM0oOwWB6/LIjXDKD+
         qEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=upRNkTZZi6LaD2Dm0RaHhzXbs3nujCa7VGrk0BrxMno=;
        b=VS64r8L1Ss47oKTWYpBmem6P5Mw27LY8qOeWz89VbPENO9oi0ZowxyhAnZe9hVhgRI
         W5I2VCkVFKdO2hTLEDQGHm/ELszNNwang03M9KTcQ/NxBfcGt+EdKOzuEClR6rJ4MLYk
         UFk+AgT6Uv5sJ4cDL4rEgawoh65UA+3fS95cHSfQQUWrAZlk8SdarlaQToPxA/B/Hozu
         CR3haL/0nxY9xZfVG+EqczbQnpLvXIoQNg8HyJWAJ+qw15OwMq7lEOLU7WVMtPeuKCqG
         UBFnoaHPxVMkZQ+agy3z/c6OzHH1YiPnpE/2RJd6uhp5rIiTKh4PuRFysgUkicHjk9Fs
         kQrw==
X-Gm-Message-State: AJcUuke3ALOAfkttP0Mu9rsgCzRoQGlLfMz5qH2nWZWrhcHwRLiOzNwH
        lUsJV3I2A0VzMwnYYIbsuFq8V2AmAIw=
X-Google-Smtp-Source: ALg8bN61eDWOI98XMq+QkkYaRSxpJaWVHmasxNmBQJghH1GrYsaC6cjUubCtAtfxdm1llYi4f+x8ZQ==
X-Received: by 2002:a19:5394:: with SMTP id h20mr12090831lfl.75.1548838886156;
        Wed, 30 Jan 2019 01:01:26 -0800 (PST)
Received: from [192.168.1.192] ([195.208.173.203])
        by smtp.gmail.com with ESMTPSA id d19-v6sm172906ljc.37.2019.01.30.01.01.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 01:01:25 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 1/2] e2fsck: allow to check >2GB sized directory
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
In-Reply-To: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
Date:   Wed, 30 Jan 2019 12:01:21 +0300
Cc:     adilger.kernel@dilger.ca
Content-Transfer-Encoding: quoted-printable
Message-Id: <4F93EC84-847D-41C2-8155-97BCED9BA4A0@gmail.com>
References: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
To:     linux-ext4 <linux-ext4@vger.kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello, Theodore.

 Do I need fix something in this patch series?

Thank you.

> On 14 Dec 2018, at 10:50, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> After large_dir feature has been added, e2fsprogs is
> ready for directories > 2GB, so we can remove e2fsck
> directory size check.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
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
> --=20
> 2.14.3
>=20

