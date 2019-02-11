Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDF3C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 20:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 975C12084D
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 20:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="qt+mG3bP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfBKUjE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 15:39:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35442 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfBKUjE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2019 15:39:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id z9so124202pfi.2
        for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2019 12:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=vCmSf4wiX7uyCAXj4jA6mUXOQGiPXIr2xxg/eIy0T1Y=;
        b=qt+mG3bPuNRgPl1EOPbMrbpqc6iHycRZaAmlh2BdB+ybjGGvJD0AnIlv56dHXnx0qZ
         EP17BpEpg2Rjis4zTCXDi3Et7VH8/8EWAgXON9CnICq1M2QPD/DoxhmEqDscG2ud9Uai
         gNNM6NVEHKg7IPSAltd5k24a6QXPf9JNzmRzNMpOFwYC8fDgS8a+lSL3Kjzs5oy/8oLx
         3zK03qWoTcLC+9omG8uS8ZfDcqayW2jHVQ2kCWNRK0XoKctHptO5e8KRcHMGtgEs5AUv
         skC4+M7CDXLkh2i+xLSSj+s8Iiqx+H6k7zoX9p/66cuoiF8ZqeF6JsRE0IYyUHP4+qpL
         zlsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=vCmSf4wiX7uyCAXj4jA6mUXOQGiPXIr2xxg/eIy0T1Y=;
        b=huYSrBaV6z7DJY9mb49KiQexLVZbV+qu69T2fzegvuUFbftk6CriDB4YEhbd4p7N2D
         CB3v9vCiZxZJ9QgmGQR9hdnCt2qZ4qtswsdhvkoQon5Z4NTGH49YKtJu56/Z4MQMYR4f
         W6qr/scnK6DMRg6Ro/SeOav0Jbcl3b1B5VondFy81PWhyEB9EeK4hwbObqFTifj57uws
         VGdqbx6YUWatYbRaGKiL0Bn8fI9iilB4UySvoTEp/0rsVu61ZA46VSi2Qb+feBkQvDm1
         5l/QH4RWb/H7vmk2RcGWOKupbgEMqz+oFKeaUurWFsGnx3DIt7GC0Hk3bqOLYPxr3r67
         ukiA==
X-Gm-Message-State: AHQUAuZYIGUD7KtDv8Ow3eyAPe+rLMdLuPR/7j7OxovISr4pliyEKXUY
        nkYz7oXBTsaFcFvAVyauGNtXVA==
X-Google-Smtp-Source: AHgI3IaCF0p78MRjlu2HaIdXjHpzouAa4Fp8iEYBu+qFpL7apPgpDth66PYeey9VrXgnafxgwtoWNw==
X-Received: by 2002:a63:2905:: with SMTP id p5mr116415pgp.178.1549917543801;
        Mon, 11 Feb 2019 12:39:03 -0800 (PST)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id z62sm19268832pfi.4.2019.02.11.12.39.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 12:39:03 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <A695FC57-D150-42A9-9E55-32DC8D1AED76@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3D210E50-F019-4E8A-B7FE-48774CBE3F77";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: prevent very high s_inode_readahead_blks
Date:   Mon, 11 Feb 2019 13:38:59 -0700
In-Reply-To: <20190211184459.GB22106@kadam>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To:     Dan Carpenter <dan.carpenter@oracle.com>
References: <20190211184459.GB22106@kadam>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_3D210E50-F019-4E8A-B7FE-48774CBE3F77
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Feb 11, 2019, at 11:44 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> My static checker complains that "arg" can be negative.  That does seem
> possible.  I don't know if it causes an issue at run time but it seems
> safest to allow negatives.

The option declaration requires that "arg" be greater than zero:

        {Opt_inode_readahead_blks, 2, MOPT_GTE0},

and this is checked earlier in handle_mount_opt():

        if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
                return -1;

but I agree that having false static checking warnings is annoying
and potentially also hides other issues.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> fs/ext4/super.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 60da0a6e4d86..4e0845708c52 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1838,7 +1838,7 @@ static int handle_mount_opt(struct super_block *sb,
> 	} else if (token == Opt_min_batch_time) {
> 		sbi->s_min_batch_time = arg;
> 	} else if (token == Opt_inode_readahead_blks) {
> -		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
> +		if (arg && (arg > (1U << 30) || !is_power_of_2(arg))) {

This may "fix" the problem by virtue of implicitly forcing an unsigned
comparison, but doesn't necessarily make the issue more obvious to the
reader.

That said, it doesn't look like _any_ use of "arg" allows a negative
value, regardless of whether MOPT_GTE0 is set or not, so we should
just declare arg as an unsigned int or explicitly refuse all negatives:

	if (args->from && !(m->flags & MOPT_STRING)) {
		if (match_int(args, &arg))
			return -1;
		if (arg < 0)
			return -1;
	}

This should keep the static checker happy, since the only place that
"arg" is set away from zero it is also verified not to be negative.
At that point it would also be possible to remove MOPT_GTE0 completely.

Cheers, Andreas






--Apple-Mail=_3D210E50-F019-4E8A-B7FE-48774CBE3F77
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxh3WQACgkQcqXauRfM
H+D2xxAAoumeTLnQUIy54hROhS0j1AEOlzF9hIOkSxvzkT1BtMvN6SYACoYUWGKl
R0rKBu2TIEvmWl8zcgPpaDcI9fCh5ZnLU87FhdHUVgUft21/AQRvI1E6pe/GrIj0
Eq398vFvaUsCRbKjmKlBiIdl9IeQeQ1IuwO0vIYErPBb0QXPLa494PbpxXIWLqOU
n6a/TZcdeddS4oYvHTNtzNc+GD3mM5I9hBsiWU0ySYmB1ISLxvwuzQVZ2bm0MWUB
KqUzVn9QQgNdQBEpc7vNDp8fY3iOS60LKPYJrrLzSNT4b/BbXDy8dvhs+zDZ7Ipd
OC9JsHSl4NTm12Ix0bVGtrLzmuWddHE3VlCWTQoZgHcXl8PehNHqPhQVHt9i9/wm
Gi8/rkKHX62zQk6NXNGWyfByWqyI2ucjL1+Qho1O+y8tjtyKYx1DMmh0IA0F0UZP
TPq+uXlpIzIJcVaNEG44BXWQ/eixxnTrJDowSbBeZlUXUdrtcvkGRSCcsZDhS/q8
QlAfL3wgOTEEg5ebpUlxZbnTRPpCXQJGMWNJ4MaRjRNOkzKWqWSgfurscihsomdA
hTo1crIunS2IFsP3FpJOCA4fyUawb8epjgaMKenQqI+uJkEr/6qsfrMdIKvmt/lX
4zVpalGNEk4GJZiaoRdg45KLvkwKh9r90IZ5LG3Jhxuay9GgcoM=
=Vw24
-----END PGP SIGNATURE-----

--Apple-Mail=_3D210E50-F019-4E8A-B7FE-48774CBE3F77--
