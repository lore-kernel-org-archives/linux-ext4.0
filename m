Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BD127AC57
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 04:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787806217; cv=none; b=jfa6J6DaYqkbjeTnnD8dZsrW7RUpiQoX/aYIm6Y3X7YinGFjzBzxt7L3UMs/8JtuVYhp4XizXfqfpYyCogxD6vUAwkGJ8CI7ENAPjc/0yML8UPvz/JNfYAdCOoSpQMgM7l9vMGQ7C+C7Tt3drMFhg8IZq619VH3tvefojYj9eQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787806217; c=relaxed/simple;
	bh=chcHtd15jfkwP7tXCLaf++/75G+7is8rek35X3Hqa+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NYIvFY8zEDWJCE874l6ZCThjtP0XHqBWpdvE8JWwRCigyxY5Vesz/FyQJLWyIOSx1irmChigG3dKQJl8pmbqV68FET3HuX9XVDJ+lRRpM1It5TMu78AzKYTB1yyjpJFPBi/tKvfM57T14HOSMN3ssR5os2hcphnCuQWwxcXS/K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHSMxZxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHSMxZxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A0E1F000E9;
	Thu, 27 Aug 2026 04:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787806216;
	bh=yLuehY6QCUpJN0OrHrvGdwhgffq847IvH+ggsgEINBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WHSMxZxH2Wqj7NHJdUw9Xgfl47h/v75YoJHOqURIKe8dkMJlHluGFZlGKi2O8nU5/
	 gdkrjNOvIu9PDl67OZXd9JGOx6I1QbqOtof03/aQIyn0LGSVwE1nmhDZzieIn/QgV6
	 WFpGSfSl6Nz4zcs36W/qpbfoGDhPs/kpRmUMHMb2kWiTtdQnzQ3WNEpc9LTj8/CeKu
	 1ErYLCbksCMPCCx83aRWR1UtVdlxwDn5VyyjjRypVhkbrr5XHv3KfJfJhGbCYjex9z
	 9Nb/N2ku3Pc+xaPlEEXlNFiwiRLvtRq5ndBLjXzi7mPabGSuHhMlRVgL5uDVxISbpr
	 Vs9euyn4alBOA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
References: <CGME20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
 <20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 04:50:15 +0000
Message-Id: <20260827045015.E8A0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Caching a hole in the extent status tree when ext4_get_branch(=
) fails due to an I/O error.

Pre-existing issues:
- [Critical] Transient -ENOMEM or -EFSCORRUPTED errors in ext4_get_branch()=
 cause existing indirect blocks to be orphaned and overwritten.
--

commit 4a371ba0722d0395bf8f94f94d508b0175eed067
Author: Daejun Park <daejun7.park@samsung.com>

ext4: don't report delalloc data as a hole on indirect-mapped inodes

When a plain lookup finds no block, ext4_ind_map_blocks() currently
sizes the hole without considering delayed allocation, which causes
delayed data to be reported as a plain hole. This commit reconciles
the hole with the extent status tree by factoring out
ext4_determine_insert_hole() and using it for indirect-mapped inodes.
Indirect-mapped inodes now cache the holes they report.

Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce=
3aa3@ispras.ru/

[ ... ]

> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 5aec759eed705..9dc0759c88ef4 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -586,6 +586,17 @@ int ext4_ind_map_blocks(handle_t *handle, struct ino=
de *inode,
>  		for (i =3D partial - chain + 1; i < depth; i++)
>  			count =3D count * epb + (epb - offsets[i] - 1);
>  		count++;
> +
> +		/*
> +		 * The count knows nothing about delayed allocation, so let
> +		 * the common helper reconcile it with the extent status
> +		 * tree.  Clamp it first: with a large block size a subtree
> +		 * can be bigger than the logical block space.
> +		 */
> +		count =3D umin(count, EXT_MAX_BLOCKS - map->m_lblk);
> +		count =3D ext4_determine_insert_hole(inode, map->m_lblk,
> +						   map->m_lblk, count);

[Severity: Critical]
If ext4_get_branch() failed with an error like -EIO, -ENOMEM, or
-EFSCORRUPTED, does calling ext4_determine_insert_hole() here incorrectly
cache this transient error as a permanent hole in the extent status tree?

If (flags & EXT4_GET_BLOCKS_CREATE) =3D=3D 0, the code enters this branch b=
efore
checking err, so subsequent reads might find this cached hole and return
zeros instead of retrying the disk read.

> +
>  		/* Fill in size of a hole we found */
>  		map->m_pblk =3D 0;
>  		map->m_len =3D umin(map->m_len, count);

[Severity: Critical]
This is a pre-existing issue, but looking just below this hunk in
ext4_ind_map_blocks():

	/* Failed read of indirect block */
	if (err =3D=3D -EIO)
		goto cleanup;

	/*
	 * Okay, we need to do block allocation.
	*/

Does this check fail to handle errors other than -EIO from
ext4_get_branch()?

If ext4_get_branch() fails with -ENOMEM or -EFSCORRUPTED when
EXT4_GET_BLOCKS_CREATE is set, the code falls through to block allocation.
Will this cause existing indirect blocks to be orphaned and overwritten,
leading to a disk space leak and permanent replacement of valid file data
with zeros?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827043928epcms=
2p54597035aadd1eca0556ae9b0585694f9@epcms2p5?part=3D1
