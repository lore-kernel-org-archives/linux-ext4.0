Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C392C10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 19:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03437214DA
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 19:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="W93efR1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfDRTAv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 15:00:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33018 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfDRTAv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 15:00:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id t16so1590266plo.0
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2019 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=yvLv+a4So/bNgLWhnFJWjs33SpdJg6fjzJeDLHpmXW8=;
        b=W93efR1l/I0GFqD3ZSIsALuAPWM4I5KmSBmT3iyJpsV0EGPySL1UkbliAn5zOv7w/H
         ZgwVcNvz+xZ3f0B/cpFq+pyQ1E8CTgnaEAmyFO69XM7XFPMojqGmZp4tXXmUzRr4rTWh
         kPWb25eeqo/vhX6DZpK9cQE5AQ+b+UNTa6CwmNwwyve7T5epOVeVt6ODKDAM7tn3UuMu
         vxOocCyV7j+t6Clk2eVctZ/ZA6cg/qnKV4fg2tJTyIqvS1RIQvew4XOle3E8IaBD8mRn
         oc/1VhHDDyP6nZC3bjb5n00BBV7pQ0Px74hyAwOKsKd1HgkCY5e/+3jh7Z99mkcisG6+
         28aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=yvLv+a4So/bNgLWhnFJWjs33SpdJg6fjzJeDLHpmXW8=;
        b=NdgvXlqPpuB3oLpAH/Buw+m75L8Wmp3PG9WsI6o2Gq65aeFVbEJxPR7mfXp82h++OJ
         UoiCKNTaxylh6j4LNumL7dE61NOoy5b07Gu4TYo9iFlTQkJSWP1gQn3FlYpjDpt3gPXR
         XHww2DXhxNyFST/ELg+6sKT8zSzQBQ+d8og5JmdWzIU1z7o8kxkpzZw2kg8HlKSm5ys8
         ju2GNCAxJFVet4YY1VX/Iy9+lS8aVQWb3nm01X/19YzJDXewahdIXZ/Yd0GwIy32jzlV
         cbCftXOiExgg6n3O2aAZxma5KB0k/IU/rXQzZ1GHoLIM4vBBkrzXn3C5y30l/edVMshR
         jkwA==
X-Gm-Message-State: APjAAAWixX9V9/WaCivrAkknemTUEBQwruabpFY2zwALDYhmIrAM399z
        tX06eBB50F6xxEiIhkLvYe5PUQ==
X-Google-Smtp-Source: APXvYqz595pU89D9WpgBROwbrfTextSuNnkD7a5TOMl6WLh4nyY1Fh3tEWqla2QhrDLpT/tGvRPK6g==
X-Received: by 2002:a17:902:8d89:: with SMTP id v9mr97228069plo.230.1555614050806;
        Thu, 18 Apr 2019 12:00:50 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id p7sm4070297pfp.70.2019.04.18.12.00.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 12:00:50 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <06E7E8DE-FA81-4764-B069-885C7963084E@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_24C28EF9-7EEE-44A7-A639-108A9D3FC168";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext4: fix use-after-free race with
 debug_want_extra_isize
Date:   Thu, 18 Apr 2019 13:00:48 -0600
In-Reply-To: <20190418155937.164947-1-brho@google.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To:     Barret Rhoden <brho@google.com>
References: <20190415211945.27343-1-brho@google.com>
 <20190418155937.164947-1-brho@google.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_24C28EF9-7EEE-44A7-A639-108A9D3FC168
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 18, 2019, at 9:59 AM, Barret Rhoden <brho@google.com> wrote:
>=20
> When remounting with debug_want_extra_isize, we were not performing =
the
> same checks that we do during a normal mount.  That allowed us to set =
a
> value for s_want_extra_isize that reached outside the s_inode_size.
>=20
> Reported-by: syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Barret Rhoden <brho@google.com>
> Cc: stable@vger.kernel.org # 4.14.111

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> - Updated tags
>=20
> Thanks for the review!
>=20
> fs/ext4/super.c | 58 +++++++++++++++++++++++++++++--------------------
> 1 file changed, 34 insertions(+), 24 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6ed4eb81e674..184944d4d8d1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3513,6 +3513,37 @@ int ext4_calculate_overhead(struct super_block =
*sb)
> 	return 0;
> }
>=20
> +static void ext4_clamp_want_extra_isize(struct super_block *sb)
> +{
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_super_block *es =3D sbi->s_es;
> +
> +	/* determine the minimum size of new large inodes, if present */
> +	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    sbi->s_want_extra_isize =3D=3D 0) {
> +		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
> +						     =
EXT4_GOOD_OLD_INODE_SIZE;
> +		if (ext4_has_feature_extra_isize(sb)) {
> +			if (sbi->s_want_extra_isize <
> +			    le16_to_cpu(es->s_want_extra_isize))
> +				sbi->s_want_extra_isize =3D
> +					=
le16_to_cpu(es->s_want_extra_isize);
> +			if (sbi->s_want_extra_isize <
> +			    le16_to_cpu(es->s_min_extra_isize))
> +				sbi->s_want_extra_isize =3D
> +					=
le16_to_cpu(es->s_min_extra_isize);
> +		}
> +	}
> +	/* Check if enough inode space is available */
> +	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
> +							=
sbi->s_inode_size) {
> +		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
> +						       =
EXT4_GOOD_OLD_INODE_SIZE;
> +		ext4_msg(sb, KERN_INFO,
> +			 "required extra inode space not available");
> +	}
> +}
> +
> static void ext4_set_resv_clusters(struct super_block *sb)
> {
> 	ext4_fsblk_t resv_clusters;
> @@ -4387,30 +4418,7 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	} else if (ret)
> 		goto failed_mount4a;
>=20
> -	/* determine the minimum size of new large inodes, if present */
> -	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
> -	    sbi->s_want_extra_isize =3D=3D 0) {
> -		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
> -						     =
EXT4_GOOD_OLD_INODE_SIZE;
> -		if (ext4_has_feature_extra_isize(sb)) {
> -			if (sbi->s_want_extra_isize <
> -			    le16_to_cpu(es->s_want_extra_isize))
> -				sbi->s_want_extra_isize =3D
> -					=
le16_to_cpu(es->s_want_extra_isize);
> -			if (sbi->s_want_extra_isize <
> -			    le16_to_cpu(es->s_min_extra_isize))
> -				sbi->s_want_extra_isize =3D
> -					=
le16_to_cpu(es->s_min_extra_isize);
> -		}
> -	}
> -	/* Check if enough inode space is available */
> -	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
> -							=
sbi->s_inode_size) {
> -		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
> -						       =
EXT4_GOOD_OLD_INODE_SIZE;
> -		ext4_msg(sb, KERN_INFO, "required extra inode space not"
> -			 "available");
> -	}
> +	ext4_clamp_want_extra_isize(sb);
>=20
> 	ext4_set_resv_clusters(sb);
>=20
> @@ -5194,6 +5202,8 @@ static int ext4_remount(struct super_block *sb, =
int *flags, char *data)
> 		goto restore_opts;
> 	}
>=20
> +	ext4_clamp_want_extra_isize(sb);
> +
> 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
> 	    test_opt(sb, JOURNAL_CHECKSUM)) {
> 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
> --
> 2.21.0.392.gf8f6787159e-goog
>=20


Cheers, Andreas






--Apple-Mail=_24C28EF9-7EEE-44A7-A639-108A9D3FC168
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAly4yWAACgkQcqXauRfM
H+C/KQ/9HxxkbdQe8x03WKCj4+v4soN0xwekUzoW46BzMvyxGxVP5zPv9lFM1J8r
uolBDrdCYW1gF6k0Y846L/Q95oOz/I9BPDg8o3C+5fpeYKuqQfEPDKAwdp9VR931
vrWIF2dQzpIOhJ8XU27BSj/PUAXW5D51aENnxPix7VI023Ojvx9S66cXrVQ6LoRJ
Av4mXwae/a9lIU2iKIlYYOfv605v6y4Br4mz+Vh70wbvU2Sr1qm1DDJ69/dSUvb8
uoU15gnBcFeDssJs42EG/UvDA2Ql3fHZAyNG41qezfU1oGGMcIN4yVE4o3SG8/l2
ZPAgtwFFoHFFVQHZJLjfADeeKnph2CXbwSfLfjfWY+jLxJc/Bmu5AwsMoFTwgaab
kCYbXdm2nRSa+HmI+nD+kxXNrJMnK49s63/HuHQtsKe57kcehs8YnyPPGeKvnv5H
9fC+tlJ/xI0yP9FEM+kNZeXiytCthkkoIdVu9y+Qsun8XsqxrOM/+8Dd4PUOw4rH
nhb7JsmV693ZFb41f6vBqaRtUEGMgF2ZgJQLx1zPXkc3SmLVVl397fkh6zInXRnO
/z8mXVoSigJPw5hy1Ls4iru6A/OFO6LbG0ROuQd5h37U2TtlLoH2YCtLw+ZefgKg
ljzd8UH+jsc83/tanWC6XTRQnS9Hyl9Cm3U+gAn2TbqVL2XSpt4=
=VKSu
-----END PGP SIGNATURE-----

--Apple-Mail=_24C28EF9-7EEE-44A7-A639-108A9D3FC168--
