Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C453F2ECEB9
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 01:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789694372; cv=none; b=bD54XfjYBNevRYWFCYE5GHs8ZkZGZqY/SFqxoHQ5VKL4rSkE/LHIXQ5JlLTo+q1ocso5gFUP/O7qkz4UaoBJkbVLqoQbulperOAhUDkxILZUmhlaSy/7UAwy22mik/upXH1UtTqVD/SRYRA5jkWrtKHqQ29Sd58Wt5LiJaxAMWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789694372; c=relaxed/simple;
	bh=gMZcKkV/HZeL+T+4kLhWx4njbJFJ+hF2H12bnO77NMU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fq5S7TRY52w5x2/n4r0nm86xUe9n72oh2xEx+17KqiLGF2NGxzhwyBxiO3mkF2oylSZmoNvWauIMbGrmSgiEFq1+Q02CnM/flJlpdegN9OnBlsUCm1cqO9brf/Lh3KrzfZDdHgkb07NTN9z9oI2f11f28rnw59dmZ+UV1t1Qy54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCXErnh1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCXErnh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A121F000FF;
	Fri, 18 Sep 2026 01:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789694370;
	bh=9UQsQs6FP/+W6c52/yy0gLWjKNflrFWjapcxTHo3ZBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZCXErnh14X2WkHap6K+twhymbvgDdHqDxCVCHJ2+GjSLEm+OEMAEZk3LYQV1G2Y4S
	 bpUqXJXvy65j331xy3JcUjMkkAietf5w/dNRzT5AqK+8JzYIxWa9XsjoL692+d4l1k
	 AzhpBSPTJvNDp009AoRh7jTh9koPVDldaBWXcCXU5w8YqoQ3Let7i+PcHdZi5/BlQq
	 QAZmvRF0J+mMhHxBVY51yiOKe1ZLlNuLeIw2TCwsWX8Jen0T4sQCBSpJn6lfizixHQ
	 I2QvNeIu6sVnjz9OoQygbQsmoUsfkx1AHtjKDWPafN82fvOOd3aHxE5qOcSedGJ1IS
	 OmWXytgjrfVig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: add bounds check for e_value_offs in
 ext4_read_inline_data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deepanshu Kartikey" <kartikey406@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260918010558.8210-1-kartikey406@gmail.com>
References: <20260918010558.8210-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 01:19:29 +0000
Message-Id: <20260918011930.22A121F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ext4: information leak due to unhandled error in ext4_read_inline_=
page()
- [Low] ext4: undefined macro ITAIL causes compilation failure
--

commit 61b118bf302b061ec089fd01a981cb9991fa3a62
Author: Deepanshu Kartikey <kartikey406@gmail.com>
ext4: add bounds check for e_value_offs in ext4_read_inline_data

This patch adds a bounds check to ext4_read_inline_data() to validate the
location of inline data xattr values against the actual bounds of the inode=
's
xattr area. If the value is out of bounds, it returns -EFSCORRUPTED to
prevent reading out-of-bounds memory.

Closes: https://syzkaller.appspot.com/bug?extid=3D085a394c92518a04fd09

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index caa51473207d7..7d5592030ec32 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c

[ ... ]

> @@ -188,13 +190,21 @@ static int ext4_read_inline_data(struct inode *inod=
e, void *buffer,
>  		goto out;
> =20
>  	header =3D IHDR(inode, raw_inode);
> +	end =3D ITAIL(inode, raw_inode);

[Severity: Low]
Does this code compile? ITAIL() appears to be undefined in this context,
which would break the build.

>  	entry =3D (struct ext4_xattr_entry *)((void *)raw_inode +
>  					    EXT4_I(inode)->i_inline_off);
>  	len =3D min_t(unsigned int, len,
>  		    (unsigned int)le32_to_cpu(entry->e_value_size));
> =20
> -	memcpy(buffer,
> -	       (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs), len);
> +	offset =3D le16_to_cpu(entry->e_value_offs);
> +	p =3D (void *)IFIRST(header) + offset;
> +
> +	if (unlikely(p + len > end)) {
> +		EXT4_ERROR_INODE(inode, "corrupt inline xattr entry");
> +		return -EFSCORRUPTED;

[Severity: High]
Does returning an error code here cause an information leak?

Looking at ext4_read_inline_page(), it calls this function but does not
check if the return value is negative before unconditionally zeroing the ta=
il
and marking the page as up-to-date:

fs/ext4/inline.c:ext4_read_inline_page() {
    ...
    ret =3D ext4_read_inline_data(inode, kaddr, len, &iloc);
    flush_dcache_page(page);
    kunmap_atomic(kaddr);
    zero_user_segment(page, len, PAGE_SIZE);
    SetPageUptodate(page);
    ...
}

If this returns -EFSCORRUPTED, will the page be left with uninitialized
kernel memory that gets exposed to userspace?

> +	}
> +
> +	memcpy(buffer, p, len);
>  	cp_len +=3D len;
> =20
>  out:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918010558.8210=
-1-kartikey406@gmail.com?part=3D1
