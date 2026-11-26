Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795697404;
	b=e1DVHvH/9hr5QdD8fZpvHLC8SPrwZBUeIZEzxNadL5jtAAuxNQiSQerJRbD34ugQN+i5
	 Pi9mjFSlfF5mXcJJXjP/AgOSQb9iPEQn5Lu+bwocfnRNWlu8otV8YDGbRUdN+Ze6PtwzS
	 9QXB6M6/ob5n4lHqcfq2fJ0g7YIXSgXyVQ+9dOmY9v5joS2n+BKNiHcG+paGBcVVSZP6u
	 fYqQ+6J9eyx7BOkMJgEpaWO4kUqJblMOJ/7YbtTblbt+7/HV0U/+j7eBja/Hw54iobNH4
	 QURv46yLAobvrrbQvc80jxRhkKSnb/K1bSxCOe45E6cjjEEbv77k+90OF9zjhBs5qlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795697404;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+QWmJVdSzhfUjQ5A4EOLvWNW2R26aFiEAk38Al0zI9g=;
	b=YC63z/FzZqcLaaPExKVmcL+NC0B/unHD5x+OCHlvTfPAw8HV9pKB6e1E5jFpUVjVpjok
	 o1quHdw0yJLAXV9E3hvf+YZaMvvhC8DMoXYkva2cCqvzV15lSZHhlOttsdRc1TkHpfgaT
	 a8fqEGIaeRXVjlvJMUMaoQ1qlegaude+pxlwiSQm+r79jTpnNZ2DjWpWAV2xCEsAFYdEX
	 VIYZd0F1K3aZgW8NbGUkim4PSDwk/ITPX7CLID+lX3uO+ImC1nBQNdyMqbvoilK58etfQ
	 DVNacVmEhScYzM2R2rezEC3yrWbL/6WgsA+Ldg5rXgZVDgBzaOn3Z354g9CCJmLNluw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nYm+M/ek";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04718606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYm+M/ek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130C31F000C0;
	Thu, 26 Nov 2026 12:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795697403;
	bh=+QWmJVdSzhfUjQ5A4EOLvWNW2R26aFiEAk38Al0zI9g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nYm+M/ekO67hJrvLRfi+NUWTx7y1L3gUDgmLbfE8vHvPXywalgp5dno/FXSCEoAGZ
	 a0Zatg8vaFnrrvO7PUz4ml0P7upa+hfReGFdYZmaK+modXICacSaadZiQpM5/aZVJy
	 d1d25HNSwi3XkumKRnixOWfGLvxM1piC9aUDnrj8ASsDiFm1Fe3CFug41aKXU97VR7
	 ibxf+8wrs+0zimd+8DJ7c2oz7oykMZgvBQ3bj3UOX/pd/6cMsHJcOB/8k55lGAXRp/
	 KRTvkuJn3xq3GaJScZcroreNQJaqkwwOt5p8tcaYbyyrW8lCVkHyBjvjYUpwaiuCKM
	 yk/Qb/Vyi962w==
Message-ID: <sashiko-outbox-235531@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] ext4: protect ext4_acquire_dquot against
 freezing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261126123611.2517017-3-yebin@huaweicloud.com>
References: <20261126123611.2517017-1-yebin@huaweicloud.com>
 <20261126123611.2517017-3-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 12:50:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] ext4: s_umount vs SB_FREEZE_FS deadlock in ext4_acquire_dquot()
  via vfs_ustat()
--

commit 5d68ea2752fdd861a0ff07e25a26ec6f31917f7a
Author: Ye Bin <yebin10@huawei.com>

ext4: protect ext4_acquire_dquot against freezing

This commit takes sb_start_intwrite() in ext4_acquire_dquot() when no
transaction is running so that quota acquisition during file open does not
start a transaction on a frozen filesystem.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 880f664d6c04b..af965cab32e7f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -7168,11 +7168,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
>  {
>  	int ret, err;
>  	handle_t *handle;
> +	bool freeze_protected =3D false;
> +
> +	/*
> +	 * Trying to sb_start_intwrite() in a running transaction
> +	 * can result in a deadlock. Further, running transactions
> +	 * are already protected from freezing.
> +	 */
> +	if (!ext4_journal_current_handle()) {
> +		sb_start_intwrite(dquot->dq_sb);
> +		freeze_protected =3D true;
> +	}

[Severity: High]
Can this cause an ABBA deadlock between sb->s_umount and SB_FREEZE_FS when
ustat(2) runs on a frozen filesystem?

Commit "quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem"
blocks quotactl from reaching ext4_acquire_dquot() on a frozen superblock,
but vfs_ustat() also acquires s_umount for reading via user_get_super()
without checking whether the filesystem is frozen:

fs/statfs.c:vfs_ustat() {
	struct super_block *s =3D user_get_super(dev, false);
	int err;
	if (!s)
		return -EINVAL;

	err =3D statfs_by_dentry(s->s_root, sbuf);
	drop_super(s);
	return err;
}

When project quota limits are enabled and the root directory inode has
EXT4_INODE_PROJINHERIT set, ext4_statfs() calls ext4_statfs_project() ->
dqget().  Because the root inode is a directory, its project dquot is not
kept attached in i_dquot[PRJQUOTA], so if no other inode holds an active
reference to that project dquot when the filesystem is frozen, dqget()
invokes ext4_acquire_dquot() with no running transaction:

CPU0                              CPU1
----                              ----
                                  freeze_super()
                                    /* freezes at SB_FREEZE_COMPLETE */
vfs_ustat()
  user_get_super()
    down_read(&sb->s_umount)
  ...
  ext4_acquire_dquot()
    sb_start_intwrite(sb)
                                  thaw_super()
                                    super_lock_excl(sb)
                                      down_write(&sb->s_umount)

 *** DEADLOCK ***

CPU0: vfs_ustat() -> statfs_by_dentry() -> ext4_statfs() ->
      ext4_statfs_project() -> dqget() -> ext4_acquire_dquot()
CPU1: thaw_super() -> super_lock_excl()

CPU0 blocks in sb_start_intwrite() waiting for SB_FREEZE_FS while holding
s_umount for reading, and thaw_super() cannot unlock SB_FREEZE_FS until it
acquires s_umount exclusively, leaving the filesystem permanently frozen.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126123611.2517=
017-1-yebin@huaweicloud.com?part=3D2
