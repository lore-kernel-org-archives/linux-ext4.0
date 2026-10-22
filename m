Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639080;
	b=lac2LxEy//EgdBqNWE5O0Bk+N+gApm+1Dc9KFAnRuLnCQOV2InTNrH3VTAeTny4+d+k8
	 6JJsewbGy8hm5+2hhEGyOkMIckIUCe8AIYqbRyVaV6RnJzVfpgW+3A19kGa4BlVhhL6sU
	 IM+ztyLKaIBsR5MXU73J0MZMakrHts7lGFsPxmjMnDcQUnDmE37Fkg0/6vdpf+gXkckeZ
	 ZaNhQd4ov3Amz0C8kjb5iKQmHN1domUaJEZVuPGepp8EXm7jI6ZC9w5WMVTUNC14IxxJ4
	 DgCKuG8HY2k2wIOoCbA9GAn3e41uUmDuvJfzjo/5aJxnd3ww+Cz+M1iam8yiFzuxv2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639080;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+vEuYKhn0mWV3xbIBPl+W6FBMkA8CPtPvMkwqt9jkwI=;
	b=s49A++32F95f1N7ymnR2ooXIHKV64rUh4ztMDVNWM81e84qZqSWSZuuXBocH2jgYwQa+
	 FERR8v09r4PD9hZr5EwqOVogq21QuDH+BeMJ1OFvCJqW65Uo86RqBtwAY8Tdm/Rrn3ZRW
	 N3zfiuR4WjbEzWTB/EiVoSSYXPqJrcIHIHi8S4ODi3HHFitC6FYzqtFctqsfVuOu0AItA
	 9QWSJiKAANysOsc3Y1F2RLcvmECrHZzLzCxtURn+V7WuhK9mOYQdKk7pR4gaWSUzC2kzU
	 tR9RHrzAAnvnN/A413m/jS7KzsfJNQfdRcCpw5x6a+WymrCgvDvZ+l28sguMBfZXqKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3jXziQj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451A606A32E;
	Thu, 22 Oct 2026 03:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3jXziQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9251F000C2;
	Thu, 22 Oct 2026 03:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639080;
	bh=+vEuYKhn0mWV3xbIBPl+W6FBMkA8CPtPvMkwqt9jkwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n3jXziQjzBLn8ToZRbTyOD4WXafbLdHqKhECwuLcEijl5YQ/WrEqPZ39vc3Enf02K
	 +8no7frySOe3AVRK6h5RiZPvqUfwOo4LrXG/uD00ww5If01n76JnGHr5Ow+sgRBZe8
	 U0Rr3IrhJTeuOu9rShHOM+lUykxO+Ecob/JfqHWj9awbGywpc7hBtEtzh7GwjCzh0k
	 PQ9fBm4J692slKJU3bkq9HoBvzvna9MQRxe0OtHPM1DM+6yG+NgE2Brx6Tt1WiBDxv
	 zNLepniOkKR5stswJAsg9JadnRyRITk+n3DGGBFWjAFpzDD6Vzjl7/nwtKFX12c/fd
	 r+ecaeyb4a++g==
Message-ID: <sashiko-outbox-180933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 32/41] ext4: let uid_r be turned on while the
 filesystem is mounted
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <79f31ae647269df33f8db7fcbfd063840f37e3fa.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <79f31ae647269df33f8db7fcbfd063840f37e3fa.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: ext4_ioctl_set_tune_sb() mishandles uid_r when already set=
 on disk
--

commit 18ffac15f27841cea0033ca0f9c30bacf945f9ce
Author: Jan Koester <jan.koester@tuxist.de>

ext4: let uid_r be turned on while the filesystem is mounted

This commit allows the uid_r feature (SB_I_UID_R) to be enabled on a mounted
ext4 filesystem during remount or via the EXT4_IOC_SET_TUNE_SB_PARAM ioctl.
When enabled via the ioctl, it also raises s_want_extra_isize to reserve
space for the uid_r fields in new inodes.

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2c6e9..89bf1d36ec3db 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c

[ ... ]

> @@ -1382,6 +1383,13 @@ static void ext4_sb_setparams(struct ext4_sb_info =
*sbi,
>  		if (params->set_feature_incompat_mask &
>  		    EXT4_FEATURE_INCOMPAT_CSUM_SEED)
>  			es->s_checksum_seed =3D cpu_to_le32(sbi->s_csum_seed);
> +		/* as tune2fs does: room for the uid_r fields in new inodes */
> +		if ((params->set_feature_ro_compat_mask &
> +		     EXT4_FEATURE_RO_COMPAT_UID_R) &&
> +		    ext4_has_feature_extra_isize(sbi->s_sb) &&
> +		    le16_to_cpu(es->s_want_extra_isize) < EXT4_EXTRA_ISIZE_UID_R)
> +			es->s_want_extra_isize =3D
> +				cpu_to_le16(EXT4_EXTRA_ISIZE_UID_R);
>  	}
>  	if (params->set_flags & EXT4_TUNE_FL_FORCE_FSCK)
>  		es->s_state |=3D cpu_to_le16(EXT4_ERROR_FS);

[ ... ]

> @@ -1461,6 +1470,18 @@ static int ext4_ioctl_set_tune_sb(struct file *fil=
p,
>  		     ~EXT4_TUNE_CLEAR_RO_COMPAT_SUPP))
>  			return -EOPNOTSUPP;
> =20
> +		/*
> +		 * uid_r may already be on disk but not in use yet, when it
> +		 * was set while the filesystem was mounted: take that up too.
> +		 */
> +		if (params.set_feature_ro_compat_mask &
> +		    EXT4_FEATURE_RO_COMPAT_UID_R) {
> +			if (sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE +
> +						EXT4_EXTRA_ISIZE_UID_R)
> +				return -EINVAL;
> +			enabling_uid_r =3D true;
> +		}
> +
>  		/*
>  		 * Filter out the features that are already set from
>  		 * the set_mask.

[Severity: Medium]
In fs/ext4/ioctl.c, ext4_ioctl_set_tune_sb() intends to activate uid_r even
when EXT4_FEATURE_RO_COMPAT_UID_R is already set in es->s_feature_ro_compat
on disk.

However, when the caller passes EXT4_TUNE_FL_FEATURES rather than
EXT4_TUNE_FL_EDIT_FEATURES, ext4_ioctl_set_tune_sb() derives
params.set_feature_ro_compat_mask earlier by masking out features already
present in es->s_feature_ro_compat:

	if (params.set_flags & EXT4_TUNE_FL_FEATURES) {
		...
		params.set_feature_ro_compat_mask =3D
			params.feature_ro_compat &
			~le32_to_cpu(es->s_feature_ro_compat);

If EXT4_FEATURE_RO_COMPAT_UID_R is already set in es->s_feature_ro_compat,
that bit is cleared from params.set_feature_ro_compat_mask before reaching
the check above, so enabling_uid_r remains false, the sbi->s_inode_size
check is skipped, and ext4_enable_uid_r(sb) is never called.

Additionally, even when EXT4_TUNE_FL_EDIT_FEATURES is used directly,
ext4_ioctl_set_tune_sb() clears already-set features from
params.set_feature_ro_compat_mask immediately after setting enabling_uid_r:

		params.set_feature_ro_compat_mask &=3D
			~le32_to_cpu(es->s_feature_ro_compat);

When ext4_update_superblocks_fn() then invokes ext4_sb_setparams(),
params->set_feature_ro_compat_mask no longer has EXT4_FEATURE_RO_COMPAT_UID=
_R
set, so es->s_want_extra_isize is not raised to EXT4_EXTRA_ISIZE_UID_R on
disk in the superblocks.

Does this prevent EXT4_IOC_SET_TUNE_SB_PARAM from enabling uid_r via
EXT4_TUNE_FL_FEATURES and from updating es->s_want_extra_isize on disk when
EXT4_FEATURE_RO_COMPAT_UID_R is already set in es->s_feature_ro_compat?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D32
