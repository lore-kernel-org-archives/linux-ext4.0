Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCB143B3E3
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702369; cv=none; b=AlcHAnZnFTLQ4a+h2OKsDTxlLB8+L6JbwEas501D5TvWJNFzaic1282gePOxEgt0jy6dbJBwNB/EWZFcQGdaV+Pxcp97yHtwa72XH511FJITZTeBMhJH25CfzQkK95EpeYqN0RS7sGArYAY42TzRl4rnhbtxO9FNwNqiMaxGCf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702369; c=relaxed/simple;
	bh=A6VAbOgbLR0eJgYCe/q+OnUoa/6sdba8vYd7fd2cAMc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B9pA2hCJ6tRBKiAlGN7JUlG8kd00Gnf0Ex1X1fWo6PkTRruLx9FyTueod99SOF78fgzSuO1ynPsP9NkBt3fQysHJRyn+i/+88gDqOC1+UXbv9s4Dvpa+kopLptSgDyDF3D688H2UnXLMlu5cMoKfwhwREwdnWNSTNwX+Gl55wJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6OKIg0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6OKIg0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5201F000E9;
	Fri, 14 Aug 2026 10:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702349;
	bh=arkPVmFt3tdFADv/hfbDbmI84AGdRL0sWsw6+RmBwZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G6OKIg0crjb3I5r2wpmDA/YKJMet5UYiQfkDX8XFTQN84BBgBDk9l3kpW+uJIxym2
	 e3QLcteWfQAQwh3/gIduuJuKT8jvX7GnxQWo2oMDOpBfXwhveFzXKWOdWqdVisShYm
	 IuU/Qbi4z+jXuj9ElJs5aUkzqoFHBJ8ye5eur14YSUZ3FS0UgQ6t1gmi+ijLGNQAYB
	 9f4BpdXemnzmHYvJsZ7GgBYaJaNrWXwe68+3o3QTnB/vF8d9k2V7U9FyNwNZOoNVjy
	 Vso7Otwg7zMdZDWMWuiqG+Psf8LVL/3Aeh9K1064M2wXgDsxxNCfffKs97+g/qA/S1
	 PtuxmFyRnwwJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 03/32] ext4: simplify error handling in
 ext4_setattr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-4-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:12:29 +0000
Message-Id: <20260814101229.9F5201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] The patch incorrectly routes non-fatal errors from `posix_acl_=
chmod()` (and `ext4_truncate()`) to `ext4_std_error()`, triggering a spurio=
us filesystem corruption response (DoS).
--

--- Patch [3]: [PATCH -next v5 03/32] ext4: simplify error handling in ext4=
_setattr() ---
commit f94f03ca7ff7f314c8faf61276a2cc51f78e4ce7
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: simplify error handling in ext4_setattr()

Refactor the error handling in ext4_setattr() to propagate errors using
the existing error variable and jump to the common 'err_out' label. This
removes the need for the redundant rc variable and unreachable checks.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8654006a57eff..76bf0e944ebee 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -6244,15 +6244,19 @@ int ext4_setattr(struct mnt_idmap *idmap, struct =
dentry *dentry,
>  		}
> =20
>  		filemap_invalidate_unlock(inode->i_mapping);
> +		if (error)
> +			goto err_out;
>  	}
> =20
> -	if (!error) {
> -		if (inc_ivers)
> -			inode_inc_iversion(inode);
> -		setattr_copy(idmap, inode, attr);
> -		mark_inode_dirty(inode);
> -	}
> +	if (inc_ivers)
> +		inode_inc_iversion(inode);
> +	setattr_copy(idmap, inode, attr);
> +	mark_inode_dirty(inode);
> =20
> +	if (ia_valid & ATTR_MODE)
> +		error =3D posix_acl_chmod(idmap, dentry, inode->i_mode);
> +
> +err_out:
>  	/*
>  	 * If the call to ext4_truncate failed to get a transaction handle at
>  	 * all, we need to clean up the in-core orphan list manually.
> @@ -6260,14 +6264,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct d=
entry *dentry,
>  	if (orphan && inode->i_nlink)
>  		ext4_orphan_del(NULL, inode);
> =20
> -	if (!error && (ia_valid & ATTR_MODE))
> -		rc =3D posix_acl_chmod(idmap, dentry, inode->i_mode);
> -
> -err_out:
> -	if  (error)
> +	if (error)
>  		ext4_std_error(inode->i_sb, error);

[Severity: Critical]
Does this code now incorrectly route non-fatal errors from posix_acl_chmod()
(and ext4_truncate()) to ext4_std_error()?

Passing a non-fatal error code like -ENOSPC or -EDQUOT to ext4_std_error()
can cause it to treat the condition as a critical filesystem metadata
corruption, aborting the journal and remounting read-only (or panicking).

For example, if an unprivileged user exhausts their quota or filesystem
space, and then executes chmod on a file with a POSIX ACL,
posix_acl_chmod() attempts to update the ACL, calling ext4_set_acl(), which
may return -EDQUOT or -ENOSPC. This error is now assigned to the error
variable and falls through to the err_out label, triggering
ext4_std_error() and causing a potential local Denial of Service (DoS).

> -	if (!error)
> -		error =3D rc;
>  	return error;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D3
