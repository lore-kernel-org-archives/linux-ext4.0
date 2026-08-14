Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF33143D501
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702144; cv=none; b=GsCmmdIX8k5jgd24rLucauNGhbhbA1IM0x+JTWGepq4B2synMIoDj/IpG60aBkr9JN3w97GicBkvLzpOY0hYXwXIaK1kPSKJ0u+/q2f+lubcanW61y6w+Ce7/Irkb5PujRjKgHrqEt+OES97vvFjOKa5llYs3IFBkhx45+Yy+q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702144; c=relaxed/simple;
	bh=lkxx/mquwaGYvO/6gsS/hwRQzkZ9sOeb/Ov6PRUo7z4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XygHaZJHaQxcCyscaoYXCQySh1TPr7IsJyNwNP9V5Urr0tPZrXXUyjlArpvjaOwV3R/7KnOEW40X7tbPxlhTSoCvtm0JRV6LM3kKj8R8ZMt1yF3hp49RU5VMkdHp7aPEUZ2JumfWws2f4GsFqkRZCiD/LLmj96XlDHidN3J7apI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2DxYBJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2DxYBJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164CF1F000E9;
	Fri, 14 Aug 2026 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702132;
	bh=5vqxHI29bwJEIbLdXD/mBZYHIXlQKoZknhByw5SaX6E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U2DxYBJmzuS6N0/rxaHXkqG2uQnyK6nz6mnsKF7qYGNLN1D57eK+Eh6xusBE7QaeK
	 R8xI8dW/mE9EqFC3PDX7mS7PN54Xv0302IOk2f7fEFJUtaWB3VA8MzwGw9aYv15vP6
	 prwX9XhVepy9iFNYMFCoY22I05BCRzNX4YKXLWlrhg2+atvB8GfLQtcM/e+AZTRf6L
	 +CppCXIyog7vlqyCSZaWpQslR41iSB2FzavTnfGl9lTn5KoGiaftOu26AdDN+YpLJ2
	 su0VmQwEbjC682meccebZlaTsjeNnazokDHFkLjPHM23r/b5RHzVykdXkTRbgV3SHv
	 1N4pUpHRmNmdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 07/32] ext4: fix orig_mlen initialization in
 ext4_map_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-8-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-8-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:08:51 +0000
Message-Id: <20260814100852.164CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If ext4_issue_zeroout() fails during block allocation with EXT4_GE=
T_BLOCKS_ZERO (e.g. via DAX hole-filling), the newly allocated WRITTEN exte=
nt is not reverted, exposing uninitialized disk data.
--

--- Patch [7]: [PATCH -next v5 07/32] ext4: fix orig_mlen initialization in=
 ext4_map_blocks() ---
commit 547294dd62d03f6ea5caef0d90e340b0af933eae
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: fix orig_mlen initialization in ext4_map_blocks()

This commit fixes an overflow protection bypass by ensuring orig_mlen
is saved only after clamping map->m_len to INT_MAX.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -719,6 +719,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *i=
node,
>  	 */
>  	if (unlikely(map->m_len > INT_MAX))
>  		map->m_len =3D INT_MAX;
> +	orig_mlen =3D map->m_len;

[Severity: High]
This is a pre-existing issue, but while reviewing the block mapping code in
fs/ext4/inode.c, I noticed a potential data exposure when DAX hole-filling
writes fail to zero blocks.

If ext4_issue_zeroout() fails in ext4_map_create_blocks(), the error is
returned immediately without reverting the extent tree modification:

fs/ext4/inode.c:ext4_map_create_blocks() {
    ...
    if (flags & EXT4_GET_BLOCKS_ZERO &&
        map->m_flags & EXT4_MAP_MAPPED && map->m_flags & EXT4_MAP_NEW) {
        err =3D ext4_issue_zeroout(inode, map->m_lblk, map->m_pblk, map->m_=
len);
        if (err)
            return err;
    }
    ...
}

This error propagates back to ext4_iomap_alloc(), which aborts the operation
but proceeds to commit the transaction anyway:

fs/ext4/inode.c:ext4_iomap_alloc() {
    ...
    if (ret < 0) {
        ext4_journal_stop(handle);
        return ret;
    }
    ...
}

For a DAX write to a hole within EOF, the extend flag evaluates to false in
ext4_dax_write_iter(). This completely bypasses the cleanup path that would
otherwise drop the failed extent:

fs/ext4/file.c:ext4_dax_write_iter() {
    ...
    if (extend) {
        ret =3D ext4_handle_inode_extension(inode, offset, ret, count);
        ext4_inode_extension_cleanup(inode, ret < (ssize_t)count);
    }
    ...
}

Because the newly allocated extent was already inserted into the extent tree
as WRITTEN by ext4_ext_map_blocks() earlier in the call chain, could this
sequence leave uninitialized disk data mapped and exposed to userspace?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D7
