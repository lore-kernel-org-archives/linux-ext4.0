Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34D3CB2C7;
	Fri,  9 Oct 2026 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583370; cv=none; b=TmTRkkIQJ+1W9Rv74ALyBQp8atwt7+fI2hYiD+/Ft4quFmAmdyr1VH/QX3pbOzrxEfEtFM+kvavveiARhpS9Jl4ir8HzlEEGGYCNIlPl+SqHpvYmVin19YpLTOTLHm+MdF1fy9AYnEyzZckrnVxB+q/1ykcBU79JlDel8h/+D0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583370; c=relaxed/simple;
	bh=d47lU36pHZgPDso9gLpb9eROjF2LLClmOF8i81OsnTY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=P39yujG1XLpj1zo8ZaJUzLfD2H1BQ1Y15+niRK5GT8obVsXd7O84UmiVKyb2AIGkKG6zj/6a754hyzBDe7fBpAexDi/Dkd4scwpQ8QL5W4z7aSms13uzaJlSMsQn9+aL4VuuCogWoTZ+g0au5V7GISVcgqBMoJq7GI+dz+1+dYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JkQuf+z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JkQuf+z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6FB1F000FF;
	Fri,  9 Oct 2026 22:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583368;
	bh=Gwh1z4Eiy+AKfKac2UCoTGO0QrGKLd3grLlmnSx8RHA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JkQuf+z/0UL4BHqDm2ytBK8s6dbG+KZl9YcXKjgSTe2EmW9aKcKGH4SmOXUomIL1O
	 7nsh2cgXLhOkuVjLckrlgz5gpWebPR0p0aQO+aUQx9gf8bJQ0VrUUawCJhpu14jeWf
	 BZJ3IVpIe2za2TZ58YuEpwcIFgLnNfnf7uDaOO5CihzTsX6JdWMpiWs3nLvcUuM9To
	 aKmO/ShBgAGpaHftj0khylmDzTwgZS6iUMhb0vVC1Ru9BEr9dzoGwCPDD0S01BOCvC
	 HLAO0BEFss+k0wtdp1RO9xysqoZzQERMwgWDL/C27fsQxYAwmjz/1xJTt6zKE1sXos
	 6v29iNnhZEInw==
Message-ID: <sashiko-outbox-166120@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] ntfs3: free replaced mount options after a grace
 period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-trace-kernel@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009-work-fixes-rcu-v1-8-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-8-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:02:47 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ntfs3: use-after-free of sbi->options during concurrent remount
- [Medium] vfs: ntfs3 silent mount option loss on remount
--

commit c093269bafa15fa705cf9dfc3164cc884b583d68
Author: Christian Brauner <brauner@kernel.org>
ntfs3: free replaced mount options after a grace period

This commit introduces an RCU grace period before freeing replaced mount
options in ntfs_fs_reconfigure() to resolve a use-after-free issue in
ntfs_nls_to_utf16() during pathwalks. It also introduces struct rcu_head
into struct ntfs_mount_options and updates readers like
ntfs_nls_to_utf16() to use RCU synchronization.

> diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
> index 841f9068d82f9..58ef6be3286b1 100644
> --- a/fs/ntfs3/super.c
> +++ b/fs/ntfs3/super.c
> @@ -473,7 +479,15 @@ static int ntfs_fs_reconfigure(struct fs_context *fc)
>  	}
> =20
>  	sync_filesystem(sb);
> -	swap(sbi->options, fc->fs_private);
> +	old_opts =3D sbi->options;
> +	/* pairs with the READ_ONCE() in ntfs_nls_to_utf16() */
> +	smp_store_release(&sbi->options, new_opts);
> +	fc->fs_private =3D NULL;
> +	/*
> +	 * ntfs_d_hash() and ntfs_d_compare() of a pathwalk in rcu mode may
> +	 * still read the old options through the sbi.
> +	 */
> +	call_rcu(&old_opts->rcu, put_mount_options_rcu);

[Severity: High]
Does this change leave other readers of sbi->options vulnerable to a
use-after-free?

While this patch protects ntfs_nls_to_utf16(), other VFS operations appear
to access sbi->options without holding rcu_read_lock() or s_umount. If a
thread is preempted immediately after loading the sbi->options pointer, and
a concurrent mount -o remount calls ntfs_fs_reconfigure() which replaces
sbi->options and schedules its destruction via call_rcu(), the grace period
can complete before the first thread resumes.

For example, during inode initialization:

fs/ntfs3/inode.c:ntfs_read_mft() {
    ...
    inode->i_uid =3D sbi->options->fs_uid;
    inode->i_gid =3D sbi->options->fs_gid;
    ...
}

Or during getattr operations:

fs/ntfs3/file.c:ntfs_fileattr_get() {
    ...
    if (sbi->options->nocase)
        flags |=3D FS_CASEFOLD_FL;
    ...
}

Or during directory traversal:

fs/ntfs3/dir.c:ntfs_dir_emit() {
    ...
    if (!sbi->options->showmeta && ntfs_is_meta_file(sbi, ino))
    ...
}

Will these unprotected accesses cause memory corruption when the options
are freed by the concurrent remount?

[Severity: Medium]
This problem wasn't introduced by this patch, but doesn't replacing
sbi->options with new_opts cause a silent loss of mount options during
remount?

When a user executes a remount without providing the full set of original
mount options, fc->fs_private is populated with a fresh, default-initialized
options struct in ntfs_init_fs_context():

fs/ntfs3/super.c:ntfs_init_fs_context() {
    ...
    if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE)
        goto ok;
    ...
}

Then in ntfs_fs_reconfigure(), the old options are entirely overwritten by
the new defaults, discarding any unspecified previous settings like uid, gi=
d,
or umask:

    smp_store_release(&sbi->options, new_opts);

Can this lead to unintended permission changes or feature toggles by
resetting unspecified options to their default values?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D8
