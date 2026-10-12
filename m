Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE7E32B126
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802406; cv=none; b=m4RDGYtfg2hHQLVsASbalWaAoGX2xJuRNUj1zo0BAYAUEgYG0IA4E51xHTbEHrpItRKex5oa9YxurPaflOEa6nC7m8tgkKdpqVVeT7EefTGgvZUHyJQs6BoWSIlyKbTLtQzpW+Q1EoqPO0v9jcWwPYqksC3vzQ49bLyvT0LIxtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802406; c=relaxed/simple;
	bh=mbykN8k7J0sBRQIjwbtRC4pMXEUcfdj/Ra2zU/1eJoM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CJmzzVt5z4fJFDfcejXMRZZh/ETyltwtQgK138C2eVMxEpSrXUotTMtEn+MqyotKJjbanA2NoMBOeyBCTEx9ngZ8P8p5hUfR5J5VwfNR3KEH6oA//nMUw/+H97cunewsqD4jqxYsMH82OXkKjDJS3eBO0YYAaA6pFhoAE7OCirs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlthsOi9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlthsOi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA21F0089B;
	Mon, 12 Oct 2026 10:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802405;
	bh=D3Kv8rSdyz5v/JU+bhBTL/tDvjDwlJHc8OzF6lSOfh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RlthsOi9LValSnYhP0Lau3u2yFxIsCq5f0PiTS9m6yjnQOCG3y6KieqbX758w/6nL
	 CYbI3IrR33Q5cwpANKx2OzHMOIHf2ragYfdwzRaRj41h5Cn5ZTRFObjj+A7aiPi8YK
	 Me+4wUnptkfBICp5aaR4CsTCHwpgGyQ/G8snDY/hqA9vXEljj+zfniO0PZqD66xc8Y
	 0fGlRGlXXpUSyO9hRcUfxiyFF8gUMZvf28b26q1d34kVlKvSjtBCGXGz6P7Cm6H4ek
	 nt55+R8llE5ihVGqjZFeDUPqONFSNVUu3hgIoRZ4WILmNSed04q4BVObyAGMqlWBMx
	 vyW9Dg5aDJztw==
Message-ID: <sashiko-outbox-167994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 18/28] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, dsterba@suse.cz, tytso@mit.edu, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-18-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-18-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:53:24 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] btrfs: deduplication bypasses btrfs_fs_rdonly() check on errored=
 filesystem
- [Medium] btrfs: missing btrfs_fs_rdonly() check in btrfs_fallocate
--

commit 724f453e748b24ef023f98daeae702d1edad4559
Author: Christian Brauner <brauner@kernel.org>
Subject: btrfs: check BTRFS_FS_STATE_RO instead of SB_RDONLY at runtime

This commit introduces btrfs_fs_rdonly() to test BTRFS_FS_STATE_RO and
replaces sb_rdonly() with it across various runtime checks. This ensures
the filesystem catches modifications during an error state independently of
the VFS, preparing for the removal of the SB_RDONLY flag from the error
handler.

> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d2a4101912bdb..96cc207cdb4e9 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -846,7 +846,8 @@ static int btrfs_remap_file_range_prep(struct file *f=
ile_in, loff_t pos_in,
>  	if (!(remap_flags & REMAP_FILE_DEDUP)) {
>  		struct btrfs_root *root_out =3D inode_out->root;
> =20
> -		if (btrfs_root_readonly(root_out))
> +		if (btrfs_root_readonly(root_out) ||
> +		    btrfs_fs_rdonly(root_out->fs_info))
>  			return -EROFS;

[Severity: Medium]
Should the btrfs_fs_rdonly() check be placed outside the deduplication
conditional block?

By placing it inside the check for !(remap_flags & REMAP_FILE_DEDUP),
deduplication operations bypass this early read-only failure on an errored
filesystem. Because the VFS no longer rejects writes via mnt_want_write_fil=
e()
due to the SB_RDONLY removal later in the series, the FIDEDUPERANGE ioctl
will proceed to flush pages, wait for IO, and run generic_remap_file_range_=
prep().

This allows unprivileged users to force significant IO and CPU work on an
already broken filesystem, performing the expensive data comparison before
finally returning -EROFS during btrfs_start_transaction().

[ ... ]

> And check it next to every btrfs_root_readonly() check that guards a
> modification, e.g. in btrfs_permission(), btrfs_setattr(),
> btrfs_update_time(), the xattr and ACL handlers, btrfs_fileattr_set()
> and the clone checks in btrfs_remap_file_range_prep().

[Severity: Medium]
Is there a need for a similar btrfs_fs_rdonly() check in btrfs_fallocate()
in fs/btrfs/file.c?

Currently, btrfs_fallocate() on an errored filesystem will bypass VFS check=
s.
It will proceed to call btrfs_cont_expand() or btrfs_truncate_block() which
dirty pages in memory, and wait for IO, before eventually failing later when
btrfs_start_transaction() checks BTRFS_FS_ERROR.

This could leave unflushable dirty pages in memory for a read-only filesyst=
em,
potentially causing writeback warnings or unmount issues. This creates an
inconsistency with other modification paths like btrfs_setattr() which
correctly check for the read-only or error state early.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D18
