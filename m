Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51CF41D629
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544878; cv=none; b=GC7fcaA1KQz0B9ffy1nWBdBvFEdrcrfR7E1T3g8T963eFsFFi/gbms/Mc1oEQ2tOtQHNCrs/JMWItL4SfH/QqvXJ/eDRYWJcLs/oNfIzLJ9O7bNkLuVcc0fLm/U1XOek1IeL5R/O9VNSu+lxko4NmLyrnRFDkqlgQdMfArf4XHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544878; c=relaxed/simple;
	bh=r+2FIJiEEXt/MUMnCh7fF4lN0aC7i+r0ggV0OTrJrXk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VgzmaztjVxkVhBQ+J6Fv4pmVQ+c6FsuNrmyAo8LoV4RfeKdF/WTld/Qny05TF8HDtn31buPl8I483qJGgNjYrjwYmgHhhnIWeaY4G0V7PjQcxwbvbeLfdESgZLO+CKS1IoqvqjfJLqI5YIM+UrJwNdwUKX/+65yJiBuh1PTQ1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mbBVS5Bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbBVS5Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA371F000FF;
	Fri,  9 Oct 2026 11:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544869;
	bh=PQ2XbxXJPiFpHpsn+hWBaWZEJ0zxQ3bV+6Aj8G87XYM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mbBVS5Bjemiehc2Z1vfxXTpUDSTPiyIIDEe0zI5sGHrFXLwIJ6TybJsitNvqZ5Rl/
	 9CKrqPpvg25rRJmREs/AUjNq6jUxnstV49Q1JJROf4Mi8IlBRaCUdhivk8ShA4A0ex
	 S6ZWm0rnOzInVj0XNzLnE6fZ17xu8LAi0yzDJXcTRcV6bOnekJdgEt0BgdpUKcOZGO
	 7Yrwvm7FQ2B3wF6wxL7PDsqu/FpPfnaqUfzRktCb4cBIt+4sIkNginE0mtoiMSARda
	 nSKRJmclpGKRbxuBUcvb5QVcNHSHIAxOrFR9B9PK3A+0mbY3L1TAqQTIYehpaHXJYT
	 B536aWQ3UK9Ow==
Message-ID: <sashiko-outbox-165359@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 24/31] ext4: defer i_disksize update while
 DISKSIZE_GROW_PENDING is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-25-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-25-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:21:08 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: torn reads of 64-bit i_disksize cause missed updates and dat=
a loss
--

commit 9dbea84318a994dcee69fb96db7cef1b2100ff28
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set

This commit defers i_disksize updates while EXT4_STATE_DISKSIZE_GROW_PENDING
is set to prevent exposing stale data on a crash. It introduces a fast-path
check in ext4_update_inode_size() to avoid taking i_data_sem when no
size update is needed.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 089dbd39c5c24..b26ce3183bacb 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
[ ... ]
> @@ -3605,30 +3605,67 @@ do {								\
[ ... ]
>  static inline int ext4_update_inode_size(struct inode *inode, loff_t new=
size)
>  {
>  	int changed =3D 0;
> =20
> +	if (newsize <=3D inode->i_size && newsize <=3D EXT4_I(inode)->i_disksiz=
e)
> +		return 0;
> +

[Severity: High]
On 32-bit architectures, can reading the 64-bit EXT4_I(inode)->i_disksize
locklessly here result in a torn read?

Because i_disksize can be concurrently updated by ioend workers under
i_data_sem (for example, when crossing a 4GB boundary), a torn read could m=
ix
the high 32 bits of a new value with the low 32 bits of an old value,
producing a falsely large value.

If a falsely large value is read, this new fast-path check could erroneously
evaluate to true. This would cause the function to return 0 and skip acquir=
ing
i_data_sem to update i_disksize.

Could this leave i_disksize permanently short of newsize during operations
like ext4_zero_range or non-delalloc buffered writes, potentially resulting
in data loss if a system crash truncates the file to the smaller i_disksize?

> +	down_write(&EXT4_I(inode)->i_data_sem);
>  	if (newsize > inode->i_size) {
>  		i_size_write(inode, newsize);
>  		changed =3D 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D24
