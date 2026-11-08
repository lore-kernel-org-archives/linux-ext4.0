Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170763;
	b=247LRt/PufIaVTWRjHk/HpOOu+Zz+mBMqDFssPvu/eGRcGbXdLrIAinZu3azavKrwHck
	 0KCjiyToxJ25rtF/AJLmGrrEKcg6w55tH1dVqPfBG8Ngg20HI5KxVTuiq8kU43YmddVxp
	 2mCfb7dPriVY1l13DZlIF6iFLZxScxgBFt/TaKqW2TJmuBP1LHjujd4vN7R/C+itMrpFx
	 JZmCfz6jlxT9V6JCXzhZyrnFegE4ZuQ3DICBeWk2PPim1LrZ9xRe98r/0nxBwha28Ip5w
	 Zv9ENQcqEwwG7HmZeNIxgL33OaIL0oqVi4mJfKgqzqgHsFV+q9Uh8/ySPPaK8CnJTuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170763;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d6ToXOl63T66MxwBHbjlISDGYiAbi6B4E8AOTmu5uyc=;
	b=excQawRNxQMs/4kn2MfLKf+1u8b9mJSlXdpOaB3jvSnd6fEpWQ3RG1cvAb7DBbuVkfRl
	 /jnLO8p8s52XOJ+CMeWjcfmbK3G5F23m8GybvOMS06a5dq8z5bC6EtexjvQbMOzNBYVxe
	 UHRLm3T5p/kNl/nutrAB5NwJyKDz8xb1tc+lQgd7i5Tc6yY96znVm0g9jkC8DgCyHhZNN
	 91aAI2M7vZmI6M1oZiu/DZIBYk6Nox3Lhmfw5SO694yDB4BguQ3WByMuXL4W3Wijv3lC/
	 A3xBe9NmSTLOf9JyCg7W+NYXER7+HG6P31BKKUCEmbI812RCgWAZ7p3sm8foVLsco6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nfgd8L2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAD7606A320
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 20:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nfgd8L2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315C41F0089F;
	Sun,  8 Nov 2026 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794170762;
	bh=d6ToXOl63T66MxwBHbjlISDGYiAbi6B4E8AOTmu5uyc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nfgd8L2+QavfUStiPXkOETTKuc0VnNP4QJI4+kEZN/zdGhwmD66G44BR7d0sSQMgY
	 kFeytdJELYTkJ3G4ojMTSh/h0t9qArr6rEtiut+V2BOoZKBA55owYMt/RA1Uq8Gwvz
	 M29OatGLE0x7Kow1Zo8yCy/MlV/VZZTvJwnkVtqCXcEF4z/DVCByY9UtG0cE0N5uj6
	 HZj5naBST4fR06cDzhiEGFyH/Ii/AmGHhld+MpnC1Gaav8xibRoYJf+DcSZpP46MvL
	 3H0al8YWr+yXK6fvf4kDeUOS5TQBNCRT47LtMv8CBIM3gUPzm28xrmxjWpetexpf4p
	 iu01gOrjmkmkw==
Message-ID: <sashiko-outbox-204022@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: validate extent root during fast commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261108201906.1417129-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108201906.1417129-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 20:46:01 +0000
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
- [High] ext4: false corruption errors in ext4_find_extent() on
  non-extent replay
- [Medium] ext4: inodes cached during fast commit replay bypass
  ext4_find_extent() check
--

commit adf8509abc940e5e79c96840165b645b5c4cea05
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

ext4: validate extent root during fast commit replay

This commit validates the inode extent header via ext4_ext_check() in
ext4_find_extent() when EXT4_FC_REPLAY is set in s_mount_state.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7193429a05e1f..c275bb23658e3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -905,6 +905,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t bl=
ock,
>  		ret =3D -EFSCORRUPTED;
>  		goto err;
>  	}
> +	/* ext4_iget() skips extent validation during fast commit replay. */
> +	if (unlikely(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)) {
> +		ret =3D ext4_ext_check(inode, eh, depth, 0);
> +		if (ret)
> +			goto err;
> +	}

[Severity: High]
Does running ext4_ext_check() here when EXT4_INODE_EXTENTS is clear trigger
false-positive filesystem corruption errors when replaying valid non-extent
inodes?

Special files created via ext4_mknod() (FIFOs, sockets, device nodes) and
fast symlinks do not set EXT4_INODE_EXTENTS or EXT4_INODE_INLINE_DATA, and
their i_data holds zeroed bytes, rdev, or the symlink target rather than an
ext4_extent_header.  They are still tracked by fast commit via
ext4_fc_track_create() and ext4_fc_track_inode().

During recovery, ext4_fc_replay_inode() calls ext4_ext_clear_bb() and
ext4_ext_replay_set_iblocks() whenever EXT4_INODE_INLINE_DATA is clear, and
both call ext4_find_extent():

fs/ext4/fast_commit.c:ext4_fc_replay_inode() {
	...
	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
		ext4_ext_replay_set_iblocks(inode);
	...
}

Previously, ext4_find_extent() saw depth =3D=3D 0 and eh_entries =3D=3D 0 f=
or a
special inode and returned an empty path, which those callers treated as a
no-op.  With this regression, ext4_ext_check() sees eh_magic !=3D
EXT4_EXT_MAGIC and calls ext4_error_inode_err() -> ext4_handle_error(),
aborting replay, marking the filesystem corrupted, and remounting read-only
or panicking the kernel.

[Severity: Medium]
Can an inode loaded by ext4_iget() during fast commit replay stay cached in
memory and bypass extent root validation after EXT4_FC_REPLAY is cleared?

During replay, __ext4_iget() skips ext4_ext_check_inode() and inserts the
inode into the VFS cache.  Replay paths such as ext4_fc_replay_link() and
ext4_fc_replay_create() call ext4_iget() and iput() without calling
ext4_find_extent(), and ext4_fc_replay_inode() ignores the return values of
ext4_ext_clear_bb() and ext4_ext_replay_set_iblocks() without evicting the
inode.

Once ext4_fc_replay_cleanup() clears EXT4_FC_REPLAY, subsequent ext4_iget()
calls hit the cached inode (I_NEW is clear) and return it without running
ext4_ext_check_inode(), while later ext4_find_extent() calls skip this new
check because EXT4_FC_REPLAY is no longer set.  A corrupt root header on
that cached inode can then still overflow i_data in
ext4_ext_insert_extent() after mount completes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108201906.1417=
129-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1
