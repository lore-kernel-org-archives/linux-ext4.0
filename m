Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B226B18872A
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2026 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786610969; cv=none; b=IvCRbY0M11Eb0RJyTX5Eoa3nObV6AQHY++eeo0DUVXQp4p8yux+wGlKDxr/haZKD6dGDtrSMGipYGoO4qeOjPN7DcsVzgBqq1sQIdKmy+L2gss15QsslUpbZOzaPskUcQAfBVsnlhMm7RjNNdk8i55tvPaERaYKAsyDRMp1GYLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786610969; c=relaxed/simple;
	bh=d19gqw26FUHCJi6tkAAXrApDZd3kNQfn7mJe1chprn8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TdwdGP3ANONzFB1m7B6yPHIeTtbq/qGrIxXc2o2zVRt5p4cgA+fo/IyPSMJS48vM/JjOX4JjI+RcCVX5WsCTjeHSrU+OXHNtQVmo/q0BlOcPS8vn0zZKoEyUXxFYBlysKc9ewLBAa6HbBeNgtU38NxhG1OrHGLnqhlJKMjj/nC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wthlus6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wthlus6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF531F000E9;
	Thu, 13 Aug 2026 08:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786610968;
	bh=biNFRZjrq8+maTUyEToP0AIzjMXJ2OsLxtgG43UvE6Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wthlus6yuoeScC7AeYwyvIaBWa6kVKLHB5GBMAKw/WIeFwVJHpEP9oOYms635BIeD
	 zTibNbOeCSYcilbK5/hA3EW4GKQVI5y6pwrNQDK8er79GbF+dngM6bGj56lvzQEk8H
	 ew4hhdkOXlmYF5NYco+pD/m/8f++zK+ptIBxKbqmsINCPwSBMvaVmc5SY6K2bTS4Vl
	 gZ8yHxVuR+/WY6eolvvtUgNyYXPdjyaNWcf0thAFZjyZ7P7npNKI8D2UH7MRhjnLjg
	 lPmMUbEyXkMOxJ1yCwO49hwVgYmjoaCRM0zF088ylGCa+T7oNxdUTkGQUW+tEH9BPr
	 I1ZLBbMW65Dsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Reply-To: sashiko-reviews@lists.linux.dev
To: pipishuo <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
References: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 08:49:27 +0000
Message-Id: <20260813084928.3BF531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Returning `-EINVAL` from `ext4_readdir` on a corrupted or inconsis=
tent directory state breaks userspace expectations and bypasses filesystem =
error handling.
--

--- Patch [1]: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir=
 ---
commit 419471105d79565b3d6563ce7e941b266526160b
Author: pipishuo <1289151713@qq.com>

Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

This commit adds a check for EXT4_STATE_MAY_INLINE_DATA in ext4_readdir to
prevent reading incorrect inline data if the inode's inline state is
inconsistent after a failure in ext4_restore_inline_data.

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 8d7b81e6948e7..857cf02742c0c 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c

[ ... ]

> @@ -160,6 +161,9 @@ static int ext4_readdir(struct file *file, struct dir=
_context *ctx)
>  	}
> =20
>  	if (ext4_has_inline_data(inode)) {
> +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +			return -EINVAL;
> +

[Severity: High]
Does returning -EINVAL here break userspace expectations and bypass the
standard filesystem corruption handling?

If an operation (like ext4_convert_inline_data_nolock) fails and leaves
EXT4_INODE_INLINE_DATA set without EXT4_STATE_MAY_INLINE_DATA, this
indicates an internally corrupted or inconsistent directory state.

By returning -EINVAL directly, this code bypasses the standard
ext4_error_file() error handler, which prevents the filesystem from taking
corrective action (such as remounting read-only).

Additionally, returning -EINVAL from a readdir (getdents64) operation is
typically interpreted by userspace as a buffer size issue, which completely
misleads tools like ls. Should this instead invoke EXT4_ERROR_FILE() and
return -EFSCORRUPTED?

>  		int has_inline_data =3D 1;
>  		err =3D ext4_read_inline_dir(file, ctx,
>  					   &has_inline_data);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_321031C6B9D=
5D092C8978B46D9F0BBA18607@qq.com?part=3D1
