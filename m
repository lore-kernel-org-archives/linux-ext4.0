Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A87426ED3
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703743; cv=none; b=bSlHwdIgzFEjxpMvdYMM25FHDwPZkI6kQiz/LaR9dXOWZ1DRx5TIgEMCRqzgsf+UhXHhxcyBxv/Mr6RAsagnzyjG/01eke4qk4qVISlElESGAbgX60h7t78flpjovn7CvezO+5M/6UhMKxpqjhegoKA0VN0xa+MoqLzBiAAReM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703743; c=relaxed/simple;
	bh=LraQG3dtDrG9AwK62g8KzVmNu5CL7vnPCo3zPYs8sFM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Uph4WAo9Dr+uWhmeILMOr3fQB9U5i3XXVzhVCMAB76mpQJLLHBSJt7xmnfrXeqGz9mBwz0MRlPjL18jNdcYH8n6YATZTBpbzwtV+aFss/TiFfrFQk6igRem7vxAkSYKL/OJSZHNlVSTceQVIEIKRDfu2bOynFDyv7ewaJHOvonM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6SXD3Th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6SXD3Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F861F000E9;
	Fri, 14 Aug 2026 10:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703732;
	bh=uGzJNhEbKmxTUu5Ki7AUAmTKacPe6LUgH3GggoqnVuQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C6SXD3Thi9SZlLxJP3v6xR9dO2Ke9SPZWf3vr2fosaamg3rYXzdjy0ahOWDzUi/Uf
	 lbrQ1loyW1Am8To6DUTAcAPdO9UuUgzy2BjBXcZtHKXl+ino1yXQg0vqw0DoLIOUiE
	 Ish3DI2DeWZ9O/u/boTIYhP11ZP3mlkfXBkZgA1/HnrMBYhUDVltQKJZfP+lfIWxa7
	 L+7NIv7seywYKv6I9VGVFOKYU3Wf3MksXlwt4JLYwdEtyJ6UXuMwV0SIzU/scCl9Sy
	 yuwDXXNlcc841QdDrPgcxP2vjRSuWSe02hJGVuq2alqviF5nYTNy3ezB86n7hAITAA
	 +fjI6yXzrHlIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 17/32] ext4: implement mmap path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-18-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-18-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:35:31 +0000
Message-Id: <20260814103531.D9F861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] File operations that zero partial blocks will crash on iomap-ena=
bled files due to legacy buffer_head dereferencing.
- [Medium] Bypass of inline data conversion for iomap-enabled inodes causes=
 failures and kernel warnings.
--

--- Patch [17]: [PATCH -next v5 17/32] ext4: implement mmap path using ioma=
p ---
commit 355e5d2bcead3197b1566acfa637f19866c3b52c
Author: Zhang Yi <yi.zhang@huawei.com>
Subject: ext4: implement mmap path using iomap

This commit introduces ext4_iomap_page_mkwrite() to implement the mmap
iomap path for ext4. It delegates the heavy lifting to iomap_page_mkwrite(),
using ext4_iomap_buffered_write_ops and ext4_iomap_buffered_da_write_ops.
The lock ordering documentation in super.c is also updated accordingly.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0b3e54e12b78f..a054456258953 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -7318,6 +7343,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
> =20
>  	filemap_invalidate_lock_shared(mapping);
> =20
> +	if (ext4_inode_buffered_iomap(inode)) {
> +		ret =3D ext4_iomap_page_mkwrite(vmf);
> +		goto out;
> +	}
> +

[Severity: Medium]
Will this bypass inline data conversion for iomap-enabled inodes?

If ext4_inode_buffered_iomap(inode) is true, we route to
ext4_iomap_page_mkwrite() and skip ext4_convert_inline_data(inode).

However, the iomap implementation explicitly forbids inline data, triggering
a warning and returning -ERANGE:

fs/ext4/inode.c:ext4_iomap_buffered_do_write_begin() {
    ...
    /* Inline data and non-extent are not supported. */
    if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
        return -ERANGE;
    ...
}

Should the inline data conversion happen before checking for the iomap path?

[Severity: Medium]
Will file operations that zero partial blocks crash on iomap-enabled files?

When an application performs an extending write or truncate up on a file
with EXT4_STATE_BUFFERED_IOMAP enabled, ext4_write_checks() unconditionally
calls ext4_block_zero_eof() without checking if the inode uses iomap:

fs/ext4/file.c:ext4_write_checks() {
    ...
        ret =3D ext4_block_zero_eof(inode, old_size, iocb->ki_pos);
    ...
}

This proceeds to ext4_block_do_zero_range() and ext4_load_tail_bh(), which
calls folio_buffers(). For an iomap folio, folio->private points to an
iomap_folio_state, not a buffer_head:

fs/ext4/inode.c:ext4_load_tail_bh() {
    ...
    bh =3D folio_buffers(folio);
    if (!bh)
        bh =3D create_empty_buffers(folio, blocksize, 0);

    /* Find the buffer that contains "offset" */
    offset =3D offset_in_folio(folio, from);
    pos =3D blocksize;
    while (offset >=3D pos) {
        bh =3D bh->b_this_page;
    ...
}

Treating iomap_folio_state as a buffer_head leads to a crash when iterating
bh->b_this_page. Since there are no callers setting EXT4_STATE_BUFFERED_IOM=
AP
in the current codebase, this is a latent regression. How should partial bl=
ock
zeroing be handled for iomap-enabled files?

>  	err =3D ext4_convert_inline_data(inode);
>  	if (err)
>  		goto out_ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D17
