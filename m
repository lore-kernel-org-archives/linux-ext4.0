Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653368;
	b=z7lufBULCbaMTut0QJn2iKvZt+7yBoLyrvibvA3OW7SeSfb83NVbIh1OrnzcHIz05t42
	 sAKjMZmATRcv9Dvp5ghtkGPvSjmTDNxdiynKLQsRvw7illxm1/+ydWGboO9nUzDeQW2/R
	 B+rMnH3ISYi0TUxFNLZI8AiGYFEjva1tqMxBXeM5eG2NSwCUuraZdPVwYDeGPDjlF79p7
	 siFv+73kIEAWdhEwODH6fA3ciQwefoHPBKhJD+H6jxUqTMIS5GPEKx/pEkR7W1hSiMQPu
	 TsZK/b+OWPbHCuWCz+aeDdSZwKLzlioElM7cZUaElcnmRhCHgTTlLpbEKymtfco91KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653368;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CQUyP1UiEozNR3meAeEQMCUbE9zCKmRk6JtkHKHBeQY=;
	b=lSH+vdCFqp9/SgC8J+M367nc7VpWLS/mQ2GokTCTdgLyNJOOUjeDfo1LLXql9caU7iwI
	 cvKsYp2nyk2UP97A06n1oa6Pe4iHgYSbuwfFyPkJnIRs+ww5EJnHdYNCc3P2DHMCe765h
	 xLvA0tVzs3C7JR4Hv3EXFmU9r0rEfThilzqvM92FSArt49eHKuYz98ufDqd6g+VFm98zk
	 KdwpGMIXZLUSJ/obZYc1oRxFsWG2W5eUjL6NpjS1+mfFE3yhF4my9q0mYlTPW7dbszYkt
	 hgAePVeUUFt6NbmYpMEmVGnSySLQluxcdxAFimK6KKe2EbIOb0TJrSS/QemgiS00FgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hykEY4iF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BA9606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hykEY4iF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD0B1F000C1;
	Thu, 22 Oct 2026 07:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792653368;
	bh=CQUyP1UiEozNR3meAeEQMCUbE9zCKmRk6JtkHKHBeQY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hykEY4iF4fQUesQCRIrVsnzUIXEUGp+deHK9d7qKrSPF+EjpE+4g0+RN0BdKXdOGb
	 yIrjI+ToL2Xjt5m0h62UixI2iMl8SnaLfSFzTlW6zCnxQlCi5N2URHUzs98wfNYGX1
	 7rADyuoPO0TCN4aWIT64vM8qM3MEOHAi2qpZ+Oa4RchET72CGmdrAs7CFoOK/R2Z3V
	 WnDBsk76YLEi96Ej3gaIs3rTDt1/JHYupsY3+TLDdyI/M8+eZtw+yuXgv/e2JS/RzW
	 FhChEOZR/d3pVP4m4Nl2DC26dvBe7OjtCs6oakWwiWhadln4vUEZw0MhSRBgbur/Pk
	 6iNYUxWrxRZxg==
Message-ID: <sashiko-outbox-181120@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: drop tmp inode ownership before migration
 cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261022070235.17849-1-chenyichong@uniontech.com>
References: <20261022070235.17849-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 07:16:07 +0000
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
- [High] ext4: ext4_ext_migrate() overwrites retval with ext4_journal_ensur=
e_credits()
--

commit 61a58c38b235cc8fa8d6d2591545809a44de0a40
Author: Yichong Chen <chenyichong@uniontech.com>

ext4: drop tmp inode ownership before migration cleanup

This commit moves the resets of tmp_inode's i_size, i_blocks, and
i_csum_seed in ext4_ext_migrate() ahead of ext4_journal_ensure_credits()
so that iput(tmp_inode) will not free the migrated extent tree if
obtaining journal credits fails.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 09931d3ba2c6a..cf5239c426935 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -566,10 +566,6 @@ int ext4_ext_migrate(struct inode *inode)
>  			free_ext_block(handle, tmp_inode);
>  	}
> =20
> -	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> -	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
> -	if (retval < 0)
> -		goto out_stop;
>  	/*
>  	 * Mark the tmp_inode as of size zero
>  	 */
> @@ -586,6 +582,11 @@ int ext4_ext_migrate(struct inode *inode)
>  	tmp_inode->i_blocks =3D 0;
>  	EXT4_I(tmp_inode)->i_csum_seed =3D tmp_csum_seed;
> =20
> +	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> +	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
> +	if (retval < 0)
> +		goto out_stop;

[Severity: High]
While moving this block from above, assigning the return value of
ext4_journal_ensure_credits() directly to retval in
fs/ext4/migrate.c:ext4_ext_migrate() still overwrites any prior error
stored in retval and propagates positive return values to the caller:

fs/ext4/migrate.c:ext4_ext_migrate() {
	...
err_out:
	if (retval)
		free_ext_block(handle, tmp_inode);
	else {
		retval =3D ext4_ext_swap_inode_data(handle, inode, tmp_inode);
		if (retval)
			free_ext_block(handle, tmp_inode);
	}
	...
	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
	if (retval < 0)
		goto out_stop;

	/* Reset the extent details */
	ext4_ext_tree_init(handle, tmp_inode);
out_stop:
	ext4_journal_stop(handle);
out_tmp_inode:
	unlock_new_inode(tmp_inode);
out_unlock:
	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
	iput(tmp_inode);
	return retval;
}

In fs/ext4/ext4_jbd2.h, ext4_journal_ensure_credits_fn() returns 0 when
credits are sufficient or extended, and 1 when the transaction had to be
restarted:

	err =3D ext4_journal_restart((handle), (extend_cred), (revoke_cred)); \
	if (err =3D=3D 0)							\
		err =3D 1;						\

If building the extent tree (update_extent_range(),
update_ind_extent_range(), update_dind_extent_range(),
update_tind_extent_range(), or finish_range()) or swapping the inode data
in ext4_ext_swap_inode_data() fails with a negative error in retval, and
ext4_journal_ensure_credits() then succeeds, retval is overwritten with 0
or 1, losing the migration error.

Conversely, if migration succeeds (retval =3D=3D 0) and
ext4_journal_ensure_credits() restarts the transaction, ext4_ext_migrate()
returns 1 to callers such as ext4_fileattr_set() -> ext4_ioctl_setflags()
in fs/ext4/ioctl.c:

	err =3D ext4_ioctl_setflags(inode, flags);
	if (err)
		goto out;
	err =3D ext4_ioctl_setproject(inode, fa->fsx_projid);

which treats the non-zero return value as an error and aborts before
ext4_ioctl_setproject().

Should ext4_journal_ensure_credits() use a separate error variable (or
only update retval when it returns a negative error and retval is not
already set) so that prior migration errors are preserved and a
transaction restart does not cause ext4_ext_migrate() to return 1?

> +
>  	/* Reset the extent details */
>  	ext4_ext_tree_init(handle, tmp_inode);
>  out_stop:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022070235.1784=
9-1-chenyichong@uniontech.com?part=3D1
