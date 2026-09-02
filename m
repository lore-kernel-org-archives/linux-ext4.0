Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D70C44065C
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 10:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344661; cv=none; b=XTfCLZRjlQ2s3QM4zaCziMN84yyRUNOKuqcP++NJXFfngc7oB7EHi/3GjWKDw3CK0hcX0be7VlrG9SMG1pZ/JDm0HnGsfMpj4tcbD/aa7HWJA3tKFO28bFMqAxicXwqpzzjNx38UxeyV7Df0Yw2r/tgE2CW6U+dEywcKSZVXyDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344661; c=relaxed/simple;
	bh=cxK7edG6EvmgSvR9H2Vt0yRkQOigJhh/9Z6Qyqap4SE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mwKeAPzeqfibz61mJdzm+03BRJYS20uNwejeTo3Lp4CL3PKG7//hR/JBqKe8iZt9fq3/s6sqPI+P4Fofaf3XI5DHA4MQMd5PeftbwWXxD2ZJUAXYE7aZXTWeidhpgfT7wvzQIAFAhkV6EyXYpQeNTboy2RZmIzkYH99UTZd3ohc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4tEwPCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4tEwPCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE61F00A3D;
	Wed,  2 Sep 2026 10:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788344656;
	bh=Nm7KbTOQxUDW0Nye9/IQLQvONWk6DiZ4Ty4QZO07PTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k4tEwPClKJb7oEbJTf0M7oRAt6nsbtpAMmRHC7TuyVURToNVrp+W9ONPkOJnj5GgA
	 kWQ/Q1jOr1L3ixH/I6s/jqsU9nTMUWOFAeFwoBA44URDttwUfKS386pTqaOtQycaWu
	 DCK92OKTJBwW/KZWTFS1ml76UyxI6ZU+nBRqURpsiPUfbOxcPKyrgvvG8ZtvbOifZN
	 wdC6qhTW+sdxahBeES2Z7Gro9drA7n6AokVqkGq/mg4QIIAfODR/RFSPnDZKG0SDAF
	 VI89QW1oUNubxlW9DtRNFrztQQnv+yandrZiNkORKWoskZXdQ/eg3A7zdMLVnHBrcv
	 +ZKtd7rsXIHGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] ext4: rewrite ext4_convert_inline_data_nolock to
 make it safer
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_FBF9C69AF090A1BF9003C68555A8928D1707@qq.com>
References: <tencent_8756434A305EF41A89C387860E424A199709@qq.com>
 <tencent_FBF9C69AF090A1BF9003C68555A8928D1707@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 10:24:16 +0000
Message-Id: <20260902102416.6FDE61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Silent data loss when ext4_ext_insert_extent() fails with erro=
rs like -ENOMEM or -EIO.
- [High] Zero-initialization of not_found causes out-of-bounds memory opera=
tions on uninitialized xattr space.
--

commit 5924a3556bc680106bf975144b0fa43d647b3a95
Author: shuo chen <1289151713@qq.com>

    ext4: rewrite ext4_convert_inline_data_nolock to make it safer
   =20
    Fix issues raised by sashiko-bot.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..8c589edaeff78 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1079,21 +1080,120 @@ static int ext4_update_inline_dir(handle_t *hand=
le, struct inode *dir,
>  	return 0;
>  }
> =20
> -static void ext4_restore_inline_data(handle_t *handle, struct inode *ino=
de,
> -				     struct ext4_iloc *iloc,
> -				     void *buf, int inline_size)
> +static int ext4_set_inline_data_block(handle_t *handle, struct inode *in=
ode, ext4_fsblk_t block,
> +					unsigned int len, struct buffer_head *bh)
>  {
> -	int ret;
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	struct ext4_xattr_ibody_find is =3D {
> +		.s =3D { .not_found =3D 0, },
> +	};

[Severity: High]
Does initializing .not_found to 0 set up a false positive match instead of
the expected -ENODATA?

If a filesystem image is mounted where a file has EXT4_INODE_INLINE_DATA
set but lacks the EXT4_STATE_XATTR flag, ext4_xattr_ibody_find() will exit
early without modifying is.s.not_found.

Because it was initialized to 0 (meaning 'found'), later in this function:

    error =3D ext4_xattr_ibody_find(inode, &i, &is);
    if (error)
        goto recovery;
    if (!is.s.not_found)
        error =3D ext4_xattr_ibody_set(handle, inode, &i, &is);

The code believes a valid xattr entry exists at is.s.here (which points to
uninitialized space). This causes ext4_xattr_ibody_set() to attempt to
delete a bogus entry, potentially leading to out-of-bounds memory
operations and a kernel panic.

[ ... ]
> +		struct ext4_extent newex;
> +
> +		newex.ee_block =3D cpu_to_le32(0);
> +		newex.ee_len =3D cpu_to_le16(1);
> +		ext4_ext_store_pblock(&newex, block);
> +		path =3D ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> +		if (IS_ERR(path)) {
> +			error =3D PTR_ERR(path);
> +			if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC)
> +				goto recovery;
> +		} else {
> +			ext4_free_ext_path(path);
> +		}

[Severity: Critical]
Does this restricted error check silently swallow fatal failure codes
(like -ENOMEM or -EIO) from ext4_ext_insert_extent()?

If ext4_ext_insert_extent() fails due to memory pressure or I/O error, the
restricted check allows the failure to fall through.

The unhandled error code is then overwritten shortly after:

    error =3D ext4_xattr_ibody_find(inode, &i, &is);

This completely masks the prior failure, causing the function to complete
successfully. The inline data flag is cleared, but the newly allocated
block is never added to the file's extent tree, permanently losing the
file's data and leaking the block.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_FBF9C69AF09=
0A1BF9003C68555A8928D1707@qq.com?part=3D1
