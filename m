Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD9530E0D5
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789011396; cv=none; b=AJ6EHeeLnFfVkfeQr4RgRXQeS7TD4e8wu7jGy7j0R8v3QO+R+o5wmEgtZQvg71mKxjWp2ESYZu1oIFN9/hShJIwNieYUIrXwtzpznq/OlsqLD5QMkwqouJBXmag6fj4jaGMDHWBELuEEUBVn80Fq/C8nVFNJGxIpWauDQ21LcOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789011396; c=relaxed/simple;
	bh=6eI2wBShtvPrzkYk15YYNmWJoZipWwELWOh8+cjWZzU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UNxYP2wuJlzDEEYcPbGSjMKDI3Bc5R/pVJSAlOpzanr2mT/hLCnmo1Gi27xfAzo8AbbkzMinezxZwSRjoLaVmm0lksUzBnVarPjBydAMEp/7UzFW65/fR2Mpv6C8Y4zvymNhBefb9JCkGoWuBOobgs7TMnVu3AgRt+M0yvM1cBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCQ/WxiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCQ/WxiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6688B1F000FF;
	Thu, 10 Sep 2026 03:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789011394;
	bh=0MR34yxHJECqvzCoAJG17vi2ZtWsi49Rg0/cmc8awhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cCQ/WxiDnW19Au1/KBtZpNP7KoT1VeDiTVlCMdsY1NyepfKPrqbf4ca2SW6Wb5gus
	 pReYeRwwfhiS21dnUSTT9kHoBiJphyJxmNyGu1znHf9BsX9LqwaJafA8bETcaTy2+6
	 lVQpFvGVz9Fuq9Uc4kSWCNQcPmYPm0k/mQCADPnw1TmO++UimZx1NdGIvq/AbwG1E2
	 QzgbCBYkYgwyWfRzFJNASc2j3OSqefbRA1Dxr5h/9SS7smFbLLQW/3KphWIIvEpl7U
	 EAS/E5CJsAVXi5yIB8kUGt363WAW5ugpxvAgq6iJvk7lVzer6J6zMNqkmb1gCpF6CB
	 eSvTtH+qn8rGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4:Update the pre-check in
 ext4_find_inline_data_nolock
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
References: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 03:36:33 +0000
Message-Id: <20260910033634.6688B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch introduces a build failure by using an undeclared macro `=
EXT4_INODE_HAS_XATTR_SPACE`, and contradicts its own commit message.
--

commit 32deefc7c2acb463248871b4f82791288c8d233b
Author: shuo chen <1289151713@qq.com>

ext4:Update the pre-check in ext4_find_inline_data_nolock

This commit attempts to update the pre-check in ext4_find_inline_data_nolock
to be consistent with ext4_xattr_ibody_find to avoid unnecessary operations.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index caa51473207d7..19ce2a59c46a3 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -132,7 +132,7 @@ int ext4_find_inline_data_nolock(struct inode *inode)
>  	};
>  	int error;
> =20
> -	if (EXT4_I(inode)->i_extra_isize =3D=3D 0)
> +	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))

[Severity: Low]
Does this fail to compile because EXT4_INODE_HAS_XATTR_SPACE is not defined
anywhere in the kernel tree?

The commit message mentions keeping this check consistent with
ext4_xattr_ibody_find. However, looking at ext4_xattr_ibody_find, it appears
to still use the original check:

    if (EXT4_I(inode)->i_extra_isize =3D=3D 0)
            return 0;

Was a prerequisite patch defining EXT4_INODE_HAS_XATTR_SPACE missed, or
should this remain as the original check?

>  		return 0;
> =20
>  	error =3D ext4_get_inode_loc(inode, &is.iloc);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_0EDE840F0C8=
186D030DEAF5A95B8BE54350A@qq.com?part=3D1
