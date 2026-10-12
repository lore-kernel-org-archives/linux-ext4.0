Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB7448424B
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801179; cv=none; b=lMcVDpD3d10JkJXF2U01gRZ2NoBU5DxaSruPJ7yjJO7aGNPRHc8fwPZPbNaYAOn55RE1gMzU2vL1ujbqYuGOXGHOBAiVzCbPQox4bYWjIqNEXCaXYonGDaK49VpW8NWItImuyVLL4RY1XO3uIrOIa4JM6QE0UCMQZ7mQYmjuUWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801179; c=relaxed/simple;
	bh=OuKolj+f+8QRnIJEoNLUecvU629z2DxqH94F1L/emDw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BmyB0TO2dXo5MeyokcCWFz5U/SDCsTI1/oYcXMFv5ehczzwtFCbkBCLZhquqHFY79h2Wg1L++la++OgE9LB7np/cqAOM+SRsPNaKLDK3Bt6rx7nkLXFlvGZSqwYPFwR8HK76VSPuf/AGG/2q+kpxEq/tZuFNJ3AcJr/tOFtJQcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6PfwXwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6PfwXwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1041F0089C;
	Mon, 12 Oct 2026 10:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801167;
	bh=jl73UC2l1QQpPzrc18EhDLzb4mD7M17X7Ut2t3c/igg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z6PfwXwv+jlkNfdhXkKPhGS7rndw3G4sTWNAXPXKiCHzvdOQKmM4n2auMlFLZ48Bv
	 /9GCA3NjznTMRfyv9kMHm0Dq+WjSzIBb4SJWDw9HT9mK8N2pzIq4C9BfXM6mC6+DUg
	 xO1GRpWYNneT/v/sy9yg3Iis05X+n3Ml8MhCEVbVgM2iE9rrVlhxItVhK/cA3YcN39
	 7fXkJWF6XGzS3yRcGBm9jOwFH3QKU/jT9Y/MBBDHCayTIN+dFhMO2V7WPMlfBfuG4T
	 gyBAcm/PKnTeuOZ8iJFYB+hy7hB6Xyo0jhoXxFWP2Ke9CVjHmmgrqK9QpLgDjCho8U
	 pqXtwsyQYfkxQ==
Message-ID: <sashiko-outbox-167961@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 02/28] ecryptfs: fall back to a read-only lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, "Mark Fasheh" <mark@fasheh.com>, tytso@mit.edu, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, dsterba@suse.cz
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-2-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-2-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:32:47 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] vfs: truncate() returns -EBADF instead of -EROFS when the lower =
filesystem enforces read-only access
--

commit 3ef5a823b2848ace16dfa265a339c30dd189a39c
Author: Christian Brauner <brauner@kernel.org>

ecryptfs: fall back to a read-only lower file

This commit introduces a fallback in eCryptfs when opening a lower file.
If opening the file with write permissions returns -EROFS, it will try
again with O_RDONLY. This allows reading files even when the underlying
filesystem is read-only.

> diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
> index ae4cb4e2e1348..ba94b304edf3f 100644
> --- a/fs/ecryptfs/kthread.c
> +++ b/fs/ecryptfs/kthread.c
> @@ -30,6 +30,21 @@ static struct ecryptfs_kthread_ctl {
> =20
>  static struct task_struct *ecryptfs_kthread;
> =20
> +/*
> + * A filesystem can refuse writes while its superblock stays read-write,=
 e.g.
> + * after an error, and a read-only mount refuses them as well. Reading s=
till
> + * works so fall back to that.
> + */
> +static struct file *ecryptfs_open_lower(const struct path *path, int fla=
gs,
> +					const struct cred *cred)
> +{
> +	struct file *file =3D dentry_open(path, flags, cred);
> +
> +	if (PTR_ERR_OR_ZERO(file) =3D=3D -EROFS && (flags & O_ACCMODE) =3D=3D O=
_RDWR)
> +		file =3D dentry_open(path, (flags & ~O_ACCMODE) | O_RDONLY, cred);
        ^^^^

[Severity: Medium]
Will this fallback cause userspace to receive -EBADF instead of -EROFS
for truncate operations?

If an unprivileged user calls truncate() on an eCryptfs file backed by a
read-only lower filesystem:

sys_truncate() -> do_truncate() -> notify_change() -> ecryptfs_setattr()
    -> __ecryptfs_truncate()

__ecryptfs_truncate() calls ecryptfs_get_lower_file(), which will successfu=
lly
obtain an O_RDONLY file descriptor due to this new fallback logic.

__ecryptfs_truncate() then blindly assumes the file is writable and attempts
write operations:

fs/ecryptfs/inode.c:__ecryptfs_truncate() {
    ...
    rc =3D ecryptfs_write(inode, zero, ia->ia_size - 1, 1);
    ...
}

Because the underlying struct file lacks FMODE_WRITE, kernel_write() inside
ecryptfs_write() will fail with -EBADF. This leaks an invalid -EBADF error
code to userspace instead of the expected -EROFS or -EACCES.

> +	return file;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D2
