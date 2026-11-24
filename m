Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493046;
	b=aqw3Xj11KCklQolDBfMOZlJlKE1ZwUwRlZKth4XT9/WZzMsB2Y699RO4+FfI4NvVyzTE
	 RMekJPytl0Txh3DZYcAkcrDdmO7t0cafAmApy7gr6nurzZ9I92LVE+LxQ/qkhHZ2np+mU
	 yhBfxC5Pd2Oithc8h3UZua2ndvtDM+id5geNc3Nl3ySGQfq7kDQnN0ACm3gGydz57ymHL
	 tMoSNFdzuNIihGNOsbdL7cef3SNsg3/kx9BxVV238UJzH2CERTnKBBjcZW4x+Zs62P+Kx
	 eJRvwTQ1FpwrDbj5UynmwE8Ot0ZL7WsEG6cq6VO7JmTJfr6qf67czHPr0K4H4rQ2bMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493046;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0EPyiwRrR1BaQ2JCwSypnBdaaL9evNTYzKSa5vSadtI=;
	b=XfTEYw3Ket3V27K3zz6U0hoR4Kom6FNUg0DbgHS59+/M5/G4DXbCROwZsLNzqzHD6JqP
	 5Mtefy/ved85hqQw72QlQnhD2cl8+59gzzgBDf4WH+O+ZvsGIF38X5pJFyWmdanGDDs6f
	 LtXwDv8JWUZO9CfSzyieKNQeVXs7TlTPVgBaYd6y7h1tcPWp29mRT6HOr18Tprt/v3wrt
	 aIerLdWfFs85f1pHpJ4YxK7LPEVCc4A5RpQ5xY9apos1bD9V/tc9GFrbvULFw9QcBbb8Y
	 TkxxMiHLvTfPIAVSft84Axkdh6YzedbHT5XjBMyCHCcw/cm0idh7vJ422Ut/GyBTFxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aSCR2AjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C344606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aSCR2AjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC891F000C0;
	Tue, 24 Nov 2026 04:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795493046;
	bh=0EPyiwRrR1BaQ2JCwSypnBdaaL9evNTYzKSa5vSadtI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aSCR2AjNo61HCsQTz/4JOhF468lhjd+E2fRmYJeOnGj1irQSQj1z0imqhcI0fCr5i
	 a8fP2WxJXy9t8jHwLaeQeMfdOKXybOMNh3bdk0pQkQq0oszP+x8ee7W1UUxYANz0LB
	 qzDEvq06lzEyv608q0klBqWdqd1JUrH9J3fA+t365sdV4QnsT8+OV3qbsUft52Lt5h
	 KKoo07n5dj3c/IKiIU9Uy802Wl5SDiAVXMS4pYtaHP1CyehTdqN0v8T7yyeTHYVvUZ
	 blMmIvl5N5XVBCF+UTQjWvNYTi123QuRMb6c2vjtlSo1EK0Aoq5DWPANUiri/QqRte
	 8S9ekdy6TZcQQ==
Message-ID: <sashiko-outbox-230493@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] ext4: reject impossible group free cluster
 counts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261124033900.76700-3-zhaogongyi@bytedance.com>
References: <20261124033900.76700-3-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 04:04:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] ext4: sbi->s_want_extra_isize not updated in
  ext4_validate_replayed_metadata()
- [Medium] ext4: missing quota, hash, MMP, and ext3 checks in
  ext4_validate_replayed_metadata()
--

commit 7e275abcaa17312423929e9a2ecee6c5701d57a7
Author: Zhao Gongyi <zhaogongyi@bytedance.com>

ext4: reject impossible group free cluster counts

This commit rejects block group descriptors whose free cluster count exceeds
the group's capacity, and adds a JBD2 recovery callback to revalidate
superblock fields and group descriptors after journal and fast commit repla=
y.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 359f9d4ed4479..68bd932608bc9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c

[ ... ]

> @@ -4939,88 +4990,254 @@ static int ext4_check_geometry(struct super_bloc=
k *sb,

[ ... ]

> +	/*
> +	 * These settings have already affected mount setup. Online tuning
> +	 * can enable some features, but cannot remove them.
> +	 */
> +	if (es->s_creator_os !=3D old->s_creator_os ||
> +	    (incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) ||
> +	    (ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
> +	    (ro_compat & le32_to_cpu(old->s_feature_ro_compat) &
> +	     EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE) ||
> +	    (incompat & old_incompat & (EXT4_FEATURE_INCOMPAT_EA_INODE |
> +				       EXT4_FEATURE_INCOMPAT_CSUM_SEED |
> +				       EXT4_FEATURE_INCOMPAT_ENCRYPT |
> +				       EXT4_FEATURE_INCOMPAT_CASEFOLD)) ||
> +	    (test_opt2(sb, HURD_COMPAT) && ext4_has_feature_ea_inode(sb))) {
> +		ext4_msg(sb, KERN_ERR, "incompatible mount settings after journal repl=
ay");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	err =3D ext4_check_extra_isize(sb, es);
> +	if (err)
> +		return err;
> +	if (es->s_min_extra_isize !=3D old->s_min_extra_isize ||
> +	    es->s_want_extra_isize !=3D old->s_want_extra_isize) {
> +		ext4_msg(sb, KERN_ERR, "extra inode size settings changed during journ=
al replay");
> +		return -EFSCORRUPTED;
> +	}

[Severity: Medium]
Should ext4_validate_replayed_metadata() also update sbi->s_want_extra_isize
when journal replay enables EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE?

Before replay, ext4_inode_info_init() only applies es->s_want_extra_isize a=
nd
es->s_min_extra_isize to sbi->s_want_extra_isize if
ext4_has_feature_extra_isize(sb) is already set.  If the unreplayed
superblock had s_want_extra_isize or s_min_extra_isize greater than
sizeof(struct ext4_inode) - EXT4_GOOD_OLD_INODE_SIZE (32 bytes) with
EXTRA_ISIZE cleared, and replay sets EXTRA_ISIZE, ext4_check_extra_isize()
succeeds while sbi->s_want_extra_isize stays at 32 bytes, below
s_min_extra_isize.

[ ... ]

> +	if (!ext4_feature_set_ok(sb, replay->readonly))
> +		return -EINVAL;

[Severity: Medium]
Does ext4_validate_replayed_metadata() also need to revalidate quota,
directory hash, MMP, and ext2/ext3 feature settings that were consumed befo=
re
journal replay?

Before ext4_load_and_init_journal(), __ext4_fill_super() configures
sb->s_qcop and sbi->s_qf_names[] from EXT4_FEATURE_RO_COMPAT_QUOTA and
validates EXT4_MOUNT_PRJQUOTA against EXT4_FEATURE_RO_COMPAT_PROJECT; if
replay toggles QUOTA or clears PROJECT, sb->s_qcop and the mount quota flags
are left inconsistent with ext4_enable_quotas() and ext4_orphan_cleanup().

Similarly, ext4_hash_info_init() initializes sbi->s_def_hash_version,
sbi->s_hash_seed, and sbi->s_hash_unsigned from es before replay (which
online tuning of DIR_INDEX or s_def_hash_version can change),
ext4_multi_mount_protect() checks EXT4_FEATURE_INCOMPAT_MMP and
es->s_mmp_block before replay, and ext4_check_feature_compatibility()
enforces ext2_feature_set_ok() / ext3_feature_set_ok() when IS_EXT2_SB(sb)
or IS_EXT3_SB(sb) is true.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124033900.7670=
0-1-zhaogongyi@bytedance.com?part=3D2
