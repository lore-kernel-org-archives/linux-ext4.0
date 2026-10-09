Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6264D488E
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791545613; cv=none; b=H9XMPmoYQelRJb59JQQavPlERIxGSsiXVcBQtji8sMWHYPPcbUTJuGJ3FtJ3uIOBB7w1g/1DhzlBPNzbsbV/uUk/6JAJiLVO8YBaqL1y0RMBdg5IycK7EryWuYM+BX8bE8FZoTP7mHNRcOERbbK1tRxVR1U/tcfSSnVOpg8ZDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791545613; c=relaxed/simple;
	bh=VlPoN+24FRXK2vrtOvCGtkktJRVkVgcIQmq4BWgXwz0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=a9SpPMwafiDr0YO7ZkvuuGa/3xzec+Ay8EjxcLNA1b5qYXVVagKFn8p8X+o1cHwvotGQ8g4G7Hv4cfKEiM71iyklQU2LgfCI8elW4J8YApG4eRPHacSzFLs+qyzH+prlB48v4pYvq1rKsbujq9kmJtoIEUSM70jm9cBgpe2UE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kADR23Pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kADR23Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CCF1F000FF;
	Fri,  9 Oct 2026 11:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791545599;
	bh=1KDCv+gQ4EreyclkCyCMCCLuf36+SwRW1R4f5/L0kxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kADR23PvoWZPHa7QlSt6z9RKY1QWUhyxDEInganMciq+uG5RSGKb9fOUwQ0IGtj6P
	 RThWd9WCcMXrJ0VEnz/3DvOIEtvddw+qUy5Squ2BpH9Y/M5wwdytsgInwdoaK0gFWM
	 bz+IMR/4hHmvVqBZfMed8mlEwD+Dp9GBbTq3ZJyqa1hTU1avzy2c0YU6zZwbPCHxet
	 DuAAbU9zgfs/p3BsTg+1oNN8g4px/4E+GuDx+DsKZKrQwAKVKC5y8Evjx8rZ8uXz5n
	 KuapVjeKQ8RphVDoWTgFGFT+NX/ZqNVeK8SOXKFXY2+kEW7NO7M7TB6vKvg1iwJYai
	 XWYeZUdZS/k2g==
Message-ID: <sashiko-outbox-165384@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 30/31] ext4: partially enable iomap for the buffered
 I/O path of regular files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103831.2978767-2-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103831.2978767-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:33:19 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] ext4: NULL pointer dereference in pagecache_write() during dyn=
amic fsverity enablement
--

commit 3391a6fc6c975d43c433b32dd18bae4da4784860
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: partially enable iomap for the buffered I/O path of regular files
   =20
Introduce ext4_enable_buffered_iomap() to determine whether a regular file
inode should use the iomap buffered I/O path. If unsupported features like
fsverity are enabled at the superblock level, the inode silently falls back
to the buffer_head path.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c3a6f3dce3d86..a07ce368e6e82 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -6076,6 +6098,81 @@ static int check_igot_inode(struct inode *inode, e=
xt4_iget_flags flags,
[ ... ]
> +void ext4_enable_buffered_iomap(struct inode *inode)
> +{
> +	struct super_block *sb =3D inode->i_sb;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return;
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
> +		return;
> +
> +	/* Unsupported Features */
> +	if (ext4_has_feature_inline_data(sb))
> +		return;
> +	if (ext4_has_feature_verity(sb))
> +		return;

[Severity: Critical]
Does this logic handle dynamic fsverity enablement correctly?

If FS_IOC_ENABLE_VERITY is executed on a file where the verity feature was =
not
initially set on the superblock, ext4_has_feature_verity(sb) will be false =
at
inode initialization. This causes the inode to be assigned to the iomap
buffered I/O path, setting mapping->a_ops =3D &ext4_iomap_aops.

When the user executes the ioctl, ext4_begin_enable_verity() does not check=
 if
the inode is using the iomap path. It proceeds to write the verity descript=
or
via ext4_write_verity_descriptor(), which calls pagecache_write().

fs/ext4/verity.c:pagecache_write() {
    ...
    res =3D aops->write_begin(NULL, mapping, pos, n, &folio, &fsdata);
    ...
}

Because pagecache_write() unconditionally dereferences aops->write_begin, a=
nd
ext4_iomap_aops does not implement write_begin (it is NULL), can this lead =
to
an immediate NULL pointer dereference?

Since this can be triggered by unprivileged users with write access via an
ioctl, could this be exploited as a local Denial of Service?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D30
