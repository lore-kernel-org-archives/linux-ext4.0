Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE26345CAB
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703952; cv=none; b=jOKljPnCFou+5jSixiDNQVrXSRpaRTAKnCOEEnH0dosDb3cYTDL7l8j/rPs9IYwGJecuwr+THRoNMwktm66oy2TBAuXx2rL6TJK4nckgY9PGEiF6PYbdEGdgckTNMa5VfgoS6PIQBz0XWrYTzgimEw5k99ZN6wyER48umatbZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703952; c=relaxed/simple;
	bh=3ssmfqfziKGMRC88NOgUD46vvHFWXvnCAYLSO/gZ9T0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y4lm4Vb5jpAWoeX/Ksc+0KYHpo2iUotOk1gHVMZwsyPuBZHgc4I9XoISsqVZbCt5W147UPyygsdyjw4VXqburlzTyTTiLOqg2RP+qwzSgn4oLDMCD9PjlkQFr94ZCd1a5Xi6BzyMFLQcdXVAOb7mljs9dKU380EAgyNb1ksWyN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJEv9jtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJEv9jtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437FD1F00A3A;
	Fri, 14 Aug 2026 10:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703944;
	bh=3Vg13pOiaxY2d899l8SUSABpe6cMkw83SmjnTze5Dkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QJEv9jtx5BLr/cFErZRi+LGrJdPZArx4zWyAgj/9q6psLuFGONpss7tjoGkpHMtVh
	 FWiKNtNzIDms+A6YFKkabYV010xGasZQnp3yuSpayM7tfcfv83hHlGPDczKxE7RJFY
	 jltevwfb4MZ/a1DBZ+iznO7toZwnBj1btpSFwM7MIwuXq40I6VJoE8x8aAUFGNLpLD
	 X6FnoN6OmBF3gFpOI9iO0NBSR+4MNIF5bO+l6ncmZVr9niKZzZG4KANSZkSuEKMjiU
	 zPVZKWa0yOBoAIn9+Zrsk3UNBl4P3LRUyyx5Y1kUraxLq1NqiodQtBw7x5H55Hk2PR
	 k6SyMWwWSK2hA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 31/32] ext4: partially enable iomap for the
 buffered I/O path of regular files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814094616.1710143-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814094616.1710143-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:39:03 +0000
Message-Id: <20260814103904.437FD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Encrypted and verity inodes on corrupted or downgraded filesys=
tems bypass fscrypt and fsverity, leading to plaintext data writes and unve=
rified reads.
- [Medium] Race condition in background writeback causing spurious WARN_ON_=
ONCE in ext4_iomap_writepages().
--

--- Patch [31]: [PATCH -next v5 31/32] ext4: partially enable iomap for the=
 buffered I/O path of regular files ---
commit 385d0947c4a6c1e02718f1b42a8ef1dc35bdbf03
Author: Zhang Yi <yi.zhang@huawei.com>
Subject: ext4: partially enable iomap for the buffered I/O path of regular =
files

This commit introduces ext4_enable_buffered_iomap() to determine whether a
regular file inode should use the iomap buffered I/O path. Inodes silently
fall back to the traditional buffer_head path if unsupported features like
encryption, verity, inline data, or data=3Djournal mode are met.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ee15366422a1e..c9ee78fba4d0c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -4467,6 +4479,10 @@ static int ext4_iomap_writepages(struct address_sp=
ace *mapping,
>  		.ops =3D &ext4_writeback_ops,
>  	};
> =20
> +	/* inode using the buffer_head buffered I/O path should not go here. */
> +	if (WARN_ON_ONCE(!ext4_inode_buffered_iomap(inode)))
> +		return -EINVAL;
> +

[Severity: Medium]
Can this WARN_ON_ONCE trigger spuriously due to a race with
ext4_change_inode_journal_flag()?

If background writeback via do_writepages() resolves
mapping->a_ops->writepages to ext4_iomap_writepages locklessly, the thread
might be preempted right before this check.

Meanwhile, another thread running ext4_change_inode_journal_flag() could
flush writeback, acquire s_writepages_rwsem exclusively, and clear the
EXT4_STATE_BUFFERED_IOMAP flag.

When the writeback thread resumes, it would evaluate this condition before
acquiring the s_writepages_rwsem read lock, which would trip the warning.
Should this check be moved after acquiring the read lock?

>  	ret =3D ext4_emergency_state(sb);
>  	if (unlikely(ret)) {

[ ... ]

> @@ -6037,6 +6053,81 @@ static int check_igot_inode(struct inode *inode, e=
xt4_iget_flags flags,
>  	return -EFSCORRUPTED;
>  }
> =20
> +/*
> + * Determine whether an inode should use the iomap buffered I/O path.
> + * EXT4_STATE_BUFFERED_IOMAP is generally set at inode initialization

[ ... ]

> +void ext4_enable_buffered_iomap(struct inode *inode)
> +{
> +	struct super_block *sb =3D inode->i_sb;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return;
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
> +		return;
> +
> +	/* Unsupported Features */
> +	if (ext4_has_feature_inline_data(sb))
> +		return;
> +	if (ext4_has_feature_verity(sb))
> +		return;
> +	if (ext4_has_feature_encrypt(sb))
> +		return;

[Severity: Critical]
Could checking the superblock features instead of the inode flags here lead
to a security bypass if the filesystem is manipulated offline?

If an attacker clears the encryption or verity superblock features offline,
the kernel still sets S_ENCRYPTED or S_VERITY on individual inodes that have
the flags set.

However, these superblock checks would fall through, allowing the encrypted
or verity inodes to be assigned to the iomap buffered I/O path. Since the
ext4 iomap path currently lacks fscrypt and fsverity integration, would this
cause writes to submit plaintext bios and reads to skip cryptographic
verification?

Would it be safer to check IS_ENCRYPTED(inode) and
ext4_test_inode_flag(inode, EXT4_INODE_VERITY) directly?

> +	if (test_opt(sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_JOURNAL_DATA ||
> +	    ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> +		return;
> +	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +		return;
> +
> +	ext4_set_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D31
