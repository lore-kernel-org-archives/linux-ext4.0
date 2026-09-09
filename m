Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B276826AA91
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 01:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788917084; cv=none; b=kUE+V/YYLsDz/kYVbs0Vo2MpHSZ0AwlDwRbz/2KgKxZzpVQiQAj8MbWwYZjD4Gn53jaQR3gaShuxhcuCceKtMfOJpRp0igc/uMV6x+Ri1mkMFSucA+FmoNOx5rQUvAF51vyzY8gl0ev0FzSkG+EG0KbmA61rJb24b/hiqwxdh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788917084; c=relaxed/simple;
	bh=2kB21y0Z4FrD5zjFFa7Ce+HIv1OSQq4RpUNTNCtyp6E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Asp4t8GDE2khABBImNqDGYUrgK/CVwdWsL6/xfWluPxj56GhRyE1K7ApVdFP0DFwW7nJXzcHfGIiLVqt/gE+Z9yUs4fyt0kVYB2NNsbEMdGXDmsG8JVFsyAMLlASalkfVXiXBaw5759+WA0Jo3mO6xbLlm2y9kSnedQ+fiGzAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGVvFjrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGVvFjrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A01F00A3A;
	Wed,  9 Sep 2026 01:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788917083;
	bh=Wzv+PusuIDdJjXJE7/LII418FBt9E4C85nQsmM+XbH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oGVvFjrDXLHjhdVBdEvMR2lVXubsQs17BUndw6x7d7cCmx4Brn/m5/A66xBKMKwk1
	 GDsyzu8tV0GmP0M9EApAK35EPMgiUlGG4wyqoxlgC5z1u+0R3w5ch+V11NQlotSNOI
	 o3mCF3OL5GIAQMeiCMhH1FdADAI/1TvxVX2RTPaBZTjH/JWs5vCPysU9p0KhHbFjDs
	 LoakR9/szbRAGbKp64JSK1jqHpkapPvg5fzLh7jktyOEmrcjHhmjr0Wxj1YbS/km/6
	 GKMdwql80xZgKE2uR+L0PheHrBcyEXNJEYV1ps9cz808edHQJWs8AWUKAE/brgR1Cq
	 obl8BrIW7aEnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4:Fix the initial value of not_found in
 ext4_destroy_inline_data_nolock
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
References: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 01:24:42 +0000
Message-Id: <20260909012443.0E7A01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch initializes `is.s.not_found` to `-ENODATA` but fails=
 to check this value before unconditionally deleting the inline data xattr,=
 leading to a catastrophic size_t underflow and KASAN out-of-bounds write (=
kernel panic).
--

commit af434a75deba4ee29e45b41767340323974fc530
Author: shuo chen <1289151713@qq.com>

ext4:Fix the initial value of not_found in ext4_destroy_inline_data_nolock

If a file has EXT4_INODE_INLINE_DATA set but lacks the EXT4_STATE_XATTR
flag, ext4_xattr_ibody_find() will exit early without modifying
is.s.not_found. This may cause ext4_xattr_ibody_set() to behave
incorrectly.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index caa51473207d7..4f02e7e9f5a30 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -405,7 +405,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *=
handle,
>  {
>  	struct ext4_inode_info *ei =3D EXT4_I(inode);
>  	struct ext4_xattr_ibody_find is =3D {
> -		.s =3D { .not_found =3D 0, },
> +		.s =3D { .not_found =3D -ENODATA, },

[Severity: Critical]
This is a pre-existing issue, but does this patch fully resolve the problem?

While is.s.not_found is now correctly initialized to -ENODATA,
ext4_destroy_inline_data_nolock() still unconditionally calls
ext4_xattr_ibody_inline_set() without checking if is.s.not_found indicates
the attribute is missing.

When ext4_xattr_ibody_find() returns 0 and leaves not_found as -ENODATA,
this leads to a deletion operation (i.value =3D=3D NULL) in
ext4_xattr_set_entry() on a non-existent entry.

Because the deletion path in ext4_xattr_set_entry() ignores s->not_found:

fs/ext4/xattr.c:ext4_xattr_set_entry() {
	...
	if (!i->value) {
		/* Remove old name. */
		size_t size =3D EXT4_XATTR_LEN(name_len);

		last =3D ENTRY((void *)last - size);
		memmove(here, (void *)here + size,
			(void *)last - (void *)here + sizeof(__u32));
		memset(last, 0, size);
	}
	...
}

Executing this when the entry doesn't exist causes an integer underflow in =
the
memmove() length parameter, which leads to an out-of-bounds write and kernel
panic.

Should ext4_destroy_inline_data_nolock() explicitly check is.s.not_found
and skip ext4_xattr_ibody_inline_set() when it is -ENODATA?

>  	};
>  	struct ext4_xattr_info i =3D {
>  		.name_index =3D EXT4_XATTR_INDEX_SYSTEM,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_CD1AF9C3A78=
75C42F2187B57D74A1C5EE609@qq.com?part=3D1
