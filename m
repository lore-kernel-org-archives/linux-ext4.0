Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CB64B0CB8
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443192; cv=none; b=FJpqLHXZuuSAjrLVZ5QhaNrQ9uSqI1ZaLU82olCbdKIs8E7oeUNa7LX3Leq4fhSUmuIP1z5FH56vy8Y/KKS60wSqMvmG+kYcLSRCe6CcgLfOKQZUU5jOIvgTD/aC3oJCruDRMlr54hcV6YTt+5SYjRVMMSFw6VInntsRuzQZFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443192; c=relaxed/simple;
	bh=6SU4hiUTR/8O7BFR0kqJcAfm2gZ1ozPRlbEhM2Ja4u8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i8KpSOdxe8EaltTkaq3XLxX8JFk0mQkSOH/THOwkVO8MHLqAOT46FP8x8tSekx/TIWjDCO7rGJ51Qg1mlgPEs0ui6ROYrbSGf/tB4Ei5F5QncFonZdh6vfNnIE4XvvpO7SXNICy5Ffk1ueCjfJ5fmcQ0zplmadchTZ+sOFNw4vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAhgFYRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAhgFYRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1771E1F00AC4;
	Thu,  3 Sep 2026 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443186;
	bh=UBmWp+okqy4QgmkZcIVSxMrqGfKAuamHQtKrz+VAukk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DAhgFYRNnDVp7BMJVph4c7YMD7PfhWsXeEKjQ5O1KdM1gtXsOxjn1/W+b94QYZgr3
	 jHBucMWJ2omJ9OXQY2aDKcDPpI2nV+7eyyYwHW6AXtE/d1TdRLZVsUybL5lRYcS4GN
	 00MbPAHDPPSjUs8fmR59ObqzezbwQAl5OWQzYazOKubfrrY0hJLAnYLn54QjFB5Akw
	 QMaYF2ydHnb6fSkTUWjs8Acz+Id0r8OFuSdjQC9FPBVBRhSCy/JZ61L69ogsJ4+ZO+
	 /3Z0xnONx32KsvjXEEgF1dfMi8GVsqI3YxI72lBp4EKEAkfMbC5WODml9HGLjirsyV
	 5i07o9q4BSOlQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/31] ext4: skip block allocation for holes in the
 data submission path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:46:25 +0000
Message-Id: <20260903134626.1771E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mpage_map_one_extent() fails to check for err =3D=3D 0 from ex=
t4_map_blocks(), leading to dirty buffers being mapped to block 0 and silen=
tly overwriting the filesystem superblock on inconsistencies.
--

commit 0c0032b57a5cee4a0ac28f30d5e6fc9a53e4e923
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: skip block allocation for holes in the data submission path

This commit modifies ext4_map_blocks() to return 0 without allocating blocks
when encountering a hole during the data submission path. It aims to discard
dirty bits for holes without submitting I/O.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1473263dd82f1..81c4625de752a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -825,6 +825,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *=
inode,
>  			map->m_flags |=3D EXT4_MAP_MAPPED;
>  			goto out_handle;
>  		}
> +	} else if (retval =3D=3D 0) {
> +		/*
> +		 * Do not allocate blocks for holes in the context of
> +		 * data submission path.
> +		 */
> +		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
> +			goto out_handle;

[Severity: Critical]
Does this new return path create an unhandled condition in
mpage_map_one_extent() for the buffer_head writeback path?

When ext4_map_blocks() is called by mpage_map_one_extent() and returns 0 due
to this new logic, the caller only checks for err < 0:

fs/ext4/inode.c:mpage_map_one_extent() {
	...
	err =3D ext4_map_blocks(handle, inode, map, get_blocks_flags);
	if (err < 0)
		return err;
	...
}

Because err =3D=3D 0 is ignored, mpage_map_one_extent() proceeds as if bloc=
ks
were successfully allocated. The zero m_pblk is then used by
mpage_map_and_submit_buffers(), which sets bh->b_blocknr =3D 0 and clears t=
he
delay flag.

Could this result in ext4_bio_write_folio() submitting I/O to the mapped
physical block 0 and silently overwriting the filesystem superblock on
inconsistencies?

>  	}
> =20
>  	if (!handle) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D9
