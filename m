Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBDC3ABDA5
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801718; cv=none; b=HIOAZO6FEHJri+keV5gn25wBIJmo15jS90ayuUidL1xjGu2qwmVlEGpmrmZB2XuLim3DRvXQqKDxy816dMVqokWuBW95ucCgGlkPQdcIs9JT2WbuOXDXW2RRrx5YtPUah79yFcQo26oCHnod4KNhQXy/pP35jc5qvMfhUueWy28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801718; c=relaxed/simple;
	bh=93U0ZGQFyRpl5IWAPwvPCgj153yHej8LOFni0VlPPKs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VTLE49tcuyKINB9+2nlrH4CoVWHU5kbSxKv2BnfR8bcTmskIfb0WnBURzEkgkkIN90yEqZMHPq3iuXLlEb0wQWJt62yhm1Wzb5RjSxNNKFusz8MKcvuCznIs5F1+qPiPn+0jqotFajRZyVXOzj5XgqKrM21x7zGfRvu4ZdgncKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTZwwMo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTZwwMo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2D61F0089B;
	Mon, 12 Oct 2026 10:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801717;
	bh=gVbaP+vx4awXxrsYxNLKij8RZLGRpUEH+MVSB+kfmQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CTZwwMo8G6fsEjaORdz+Lk2Mr3MQqQMh5D9cacKtOmICLjzT5klLT5wPCxvxmSi/B
	 r0ZqaJr2Guu0qp9/a9Nif+6ky4C3pY9XsnExKF/KEs294hyECdNKHtlQ2e+4iQrcZu
	 A/7LrOmREdoP5bt/y49X1I8e7yR5z0iH/lalxfWMM3W2ufqg6NtktrS7avnk6lau1V
	 h+RBYtpbhW2UPcC+GxE1mC6KQ9eqNS/XDnbsRvWhO89H4FxVRoGIf//q23KrfiodtA
	 wi0v6MwNGKBy6YSvrOUAVY+WVM85MvxG9meOwpX2zI2XxjY/r0jBqMCy215Bce0QcX
	 2TtaSU/dBu8zA==
Message-ID: <sashiko-outbox-167976@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/28] affs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-11-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-11-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:41:56 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] affs: affs_error() logic short-circuit prevents setting emergency =
RO if already SB_RDONLY
- [High] affs: mmap writes and writeback bypass AFFS_STATE_EMERGENCY_RO and=
 corrupt filesystem
--

commit 1ab95d009ae4a762fda73d7b1a5276c439494d6a
Author: Christian Brauner <brauner@kernel.org>
Subject: affs: don't set SB_RDONLY after filesystem errors

This commit stops setting SB_RDONLY directly in affs_error() without
holding sb->s_umount, which previously caused deadlocks during freezing.
Instead, it introduces an AFFS_STATE_EMERGENCY_RO bit to gracefully
refuse modifications with -EROFS.

> diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
> --- a/fs/affs/amigaffs.c
> +++ b/fs/affs/amigaffs.c
> @@ -479,9 +479,15 @@ affs_error(struct super_block *sb, const char *funct=
ion, const char *fmt, ...)
>  	vaf.fmt =3D fmt;
>  	vaf.va =3D &args;
>  	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
> -	if (!sb_rdonly(sb))
> +	/*
> +	 * Don't set SB_RDONLY: that requires sb->s_umount and a proper
> +	 * remount. Set while the superblock is frozen it makes thaw_super()
> +	 * skip releasing s_writers and every later writer hangs. Refuse
> +	 * modifications until umount instead.
> +	 */
> +	if (!sb_rdonly(sb) &&
> +	    !test_and_set_bit(AFFS_STATE_EMERGENCY_RO, &AFFS_SB(sb)->s_state))

[Severity: High]
Does this short-circuit logic prevent the emergency RO bit from being set
if the filesystem is already read-only?

If a user mounts the filesystem RO, hits a read or checksum error (triggeri=
ng
affs_error()), the AFFS_STATE_EMERGENCY_RO bit is completely skipped because
sb_rdonly(sb) is true.

When the user later remounts RW, affs_reconfigure() finds
affs_emergency_ro(sb) to be false and permits the RW remount. Could this
allow a corrupted filesystem to become writable, violating the intent to
refuse modifications after an error?

>  		pr_warn("Remounting filesystem read-only\n");
> -	sb->s_flags |=3D SB_RDONLY;
>  	va_end(args);
>  }

> diff --git a/fs/affs/file.c b/fs/affs/file.c
> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
[ ... ]
> @@ -1000,10 +1006,18 @@ int affs_file_fsync(struct file *filp, loff_t sta=
rt, loff_t end, int datasync)
>  	inode_unlock(inode);
>  	return ret;
>  }
> +
> +static ssize_t affs_file_write_iter(struct kiocb *iocb, struct iov_iter =
*from)
> +{
> +	if (affs_emergency_ro(file_inode(iocb->ki_filp)->i_sb))
> +		return -EROFS;
> +	return generic_file_write_iter(iocb, from);
> +}

[Severity: High]
Since this patch removes SB_RDONLY from the error path, do we now need
checks in the mmap and writeback paths to prevent arbitrary data and
metadata modifications?

By no longer setting SB_RDONLY, the VFS filemap_page_mkwrite (used by
generic_file_mmap_prepare) permits dirtying pages without resistance.
During writeback, affs_writepages() calls affs_get_block():

fs/affs/file.c:affs_writepages() {
    return mpage_writepages(mapping, wbc, affs_get_block);
}

fs/affs/file.c:affs_get_block() {
    ...
    if (create) {
        u32 blocknr =3D affs_alloc_block(inode, ext_bh->b_blocknr);
    ...
}

If the write targets a hole, affs_alloc_block() allocates blocks on the
physical disk and dirties metadata buffers. Because neither affs_writepages=
()
nor affs_get_block() check affs_emergency_ro(), could a user memory map an
opened file, write to it after an error, and have background writeback flush
the pages to disk, thereby corrupting the filesystem?

> +
>  const struct file_operations affs_file_operations =3D {
>  	.llseek		=3D generic_file_llseek,
>  	.read_iter	=3D generic_file_read_iter,
> -	.write_iter	=3D generic_file_write_iter,
> +	.write_iter	=3D affs_file_write_iter,
>  	.mmap_prepare	=3D generic_file_mmap_prepare,
>  	.open		=3D affs_file_open,
>  	.release	=3D affs_file_release,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D11
