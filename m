Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA054AF14B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441930; cv=none; b=Z4qRhuetWX2FaPo+YXf39bPb6UVouM12Pcx0bq5L3WNlIGoN1rh7Z00Q1w1E0TYLILtTdggKn8uwWe3rWb7KSqQ0taLVhnvUgrcmELW/QlSEoO4UWRXwfNRn2yQJ/1l7owExEksvWyj7vx8pnIuIQz96GwUcGOC2+lzv+S6Xbrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441930; c=relaxed/simple;
	bh=VBNWYx8d2hg7KENJ/QgsesKMbsMWwvlmjsaPzWgHq/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Lff8Dpu825IzrPZR6P9LgJGp6Sp58t5oN7/vVlAolPooQURljbq4NKIyhRiqP/GiMxH89oc2GRXS/e/AB8MzrXljHgCA+dCP7E+V88TeFeCL+TD1DBn8US71siojvftVV4WfOIhZGwgl0bfpHe7tdgDVRxdyMnsJTZSt0ehDy5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0IdmB6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0IdmB6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D14E1F000E9;
	Thu,  3 Sep 2026 13:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441911;
	bh=EPUDbqwIRMgc8rH8dVYFkkdSmk6EOR4kId6+PPK/3co=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M0IdmB6S1xL/vQZ5SSJYAuwDSL+8gTluADXH8rW46helljiv95HvR+Tn2JJmyX6id
	 vP40LADXxaxz6h7D67kkFPvmAY5NWszKYR2vwhnUIF/6t8BA4kLV7ZeNefTddop56S
	 C4V+wi8WJ4kwiXgP8N9Z8V2sBRBGAPG1rkBABKm8NpQtiRY2d+E5ajId9ZoG1QSYab
	 7vfkWroWiF61biM0OZFNgFLM0GYi40yRqTrIzmzNpAcuAI8HbWrKE3ybcWyanPmgGr
	 48eJtiRn7ro9gRcof+6O4N0nN02OW+FsZhhkHXGTRWpCxFOvOBlbVHE7VpV0qgTGqe
	 EGvTv4kFzaQDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 20/31] ext4: disable online defrag when inode using
 iomap buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-21-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-21-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:25:11 +0000
Message-Id: <20260903132511.8D14E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing IS_DAX() check for donor_inode allows DAX semantics violat=
ion during online defrag
--

commit 72261d911fe966cebd22871f337efe46600e2fd2
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: disable online defrag when inode using iomap buffered I/O path

Online defragmentation does not currently support inodes using the
iomap buffered I/O path. The existing implementation relies on
buffer_head for sub-folio block management and data=3Dordered mode for
data consistency, both of which are incompatible with the iomap path.

> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 3329b7ad5dbd8..948ef3f44df5e 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -476,6 +476,17 @@ static int mext_check_validity(struct inode *orig_in=
ode,
>  		return -EOPNOTSUPP;
>  	}
> =20
> +	/*
> +	 * TODO: support online defrag for inodes that use the buffered
> +	 * I/O iomap path.
> +	 */
> +	if (ext4_inode_buffered_iomap(orig_inode) ||
> +	    ext4_inode_buffered_iomap(donor_inode)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Online defrag not supported for inode with iomap buffered IO path");
> +		return -EOPNOTSUPP;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but since you are correctly
validating both orig_inode and donor_inode here in mext_check_validity(),
I noticed a potential issue with the earlier DAX validation.

Currently, mext_check_validity() in fs/ext4/move_extent.c only checks if
the origin file is DAX:

	if (IS_DAX(orig_inode)) {
		ext4_msg(sb, KERN_ERR,
			 "Online defrag not supported with DAX");
		return -EOPNOTSUPP;
	}

If a local user calls the EXT4_IOC_MOVE_EXT ioctl with a non-DAX origin
file and a DAX donor file, the operation won't be rejected.

Could this allow ext4_move_extents() to proceed and call
mext_folio_double_lock(), incorrectly allocating page cache folios and
buffer heads for the DAX donor inode instead of following DAX block
semantics?

>  	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
>  		ext4_debug("ext4 move extent: suid or sgid is set to donor file [ino:o=
rig %llu, donor %llu]\n",
>  			   orig_inode->i_ino, donor_inode->i_ino);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D20
