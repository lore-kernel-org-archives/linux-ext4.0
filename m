Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794899747;
	b=0ZSFo5d+3/deokMolsQ3lGJxJ+zLiFxUWG+iv+Rg9gcqi0Wr5UWwTPnqdMFSPWVuN+c+
	 EXIIpMogudOSZiVgB0uU2qbl+e7RnqYYYnbAJmRFeE7oy4BtsTp4FG5DuybLYT2RZZvHN
	 b4qw02kg7tcf7cFMmgLEJ5Cp/0Nw8LHzF+uc2w7+xQstjxBEV3heFuEtS/9aUyrOl909E
	 gJ+YGY9X34MBPlUaWXbKrhQtTqzc7FvCwP6T6ELM4ZL2ygfGFlYvTI4FYgv1r6MdscGBi
	 TF8hLMkDAg9bMo7cKZYmGuMSsikrZiph/vngfKrPj6+sgTQLJFts5B4uQUxaOVwZBNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794899747;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p/WrGjueSJQqMVA4FslRTNx0ggX6D4SXT88SEFVh0MI=;
	b=IxGZxxzBNB6TS7qZh+G4kpBW6MhVe6HvsbbOhcrZAgiOGEm52TlBMIrpEeyNPseEBL4J
	 bBV2Fne5lCBqUojo2lYS31XJjZdNZfYC7dTsAqTmHjWYuNJkNSgZbZIY0yDvx0ERJ0ZcI
	 4FjOrIP8TZ6uA8HFwfnA4weAEgs6lXosmrNCRw+nfCmBs+A/+hmf0ssF5zVD0H6pTTRJQ
	 uWhs9Y1PWHOhU73aU45ax5Ot6Wy9kw1skQslVmmo6968QpDXljnZ3+0nHuv/YJcVpagSE
	 GngC2S9uoO9fol+LLqnR1kjBBpl4T5Nxw45XzC8xfcXBl3+HTbW0vkh6K2iH4VwEbKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fddc2xlE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D82606A323
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 07:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fddc2xlE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174721F000C4;
	Tue, 17 Nov 2026 07:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794899747;
	bh=p/WrGjueSJQqMVA4FslRTNx0ggX6D4SXT88SEFVh0MI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fddc2xlEBJNWEKDz5S4Hri2eHSdnZpOQAUeGw2QPblnOIJSV96G/ITW0Mm3ByQ8m3
	 hdKAyakTwDLVet1AbavN7eDgOHX9pFgQ/4I9rIrOOffr7GeDTgIjkXYwxpSNJRvgHP
	 F7mneFh/MjBQa/hv3ddXTe1CavvfX+4PbWJxnm2RuAsZHkuUoldaYCXD/ExWdWJ/ak
	 e87Qg44UL73oa/cSB2UCN/8ueKRfUpCudE8qHCZZXwqilOujnUHtYDgRD+vXFWGx2+
	 4bNk8fP9sl5+w8ORIgudWfnf0a1MhCrS+R31dBVOGEbIQnOzIfRJtxDP3PBDKJWv9V
	 4aBNtaUbsrqXw==
Message-ID: <sashiko-outbox-218310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: reject a non-regular boot loader inode in
 EXT4_IOC_SWAP_BOOT
Reply-To: sashiko-reviews@lists.linux.dev
To: "William Chuang" <founder@logarcheon.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117065645.4409-1-founder@logarcheon.com>
References: <20261117061822.3826-1-founder@logarcheon.com>
 <20261117065645.4409-1-founder@logarcheon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 07:15:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] ext4: unlocked make_bad_inode() in swap_inode_boot_loader()
  races with iget
- [Low] ext4: redundant !S_ISREG() check left in
  swap_inode_boot_loader()
--

commit 92e1647560c592675448976b5391a26f9a8b9d29
Author: William Chuang <founder@logarcheon.com>

ext4: reject a non-regular boot loader inode in EXT4_IOC_SWAP_BOOT

This commit rejects EXT4_IOC_SWAP_BOOT when the boot loader inode is not a
regular file, marking the inode bad before dropping the reference.

Link: https://lore.kernel.org/all/tencent_DABB2333139E8D1BCF4B5D1B2725FABA9=
108@qq.com/T/
Link: https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e8e579498c990..8990122f585df 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -390,6 +390,26 @@ static long swap_inode_boot_loader(struct super_bloc=
k *sb,
>  		return PTR_ERR(inode_bl);
>  	ei_bl =3D EXT4_I(inode_bl);
> =20
> +	/*
> +	 * An unused boot loader inode comes back from ext4_iget() as a bad
> +	 * inode, which make_bad_inode() leaves as S_IFREG.  Any other type
> +	 * means the on-disk inode is corrupted; its type cannot be changed
> +	 * in place below.
> +	 */
> +	if (!S_ISREG(inode_bl->i_mode)) {
> +		EXT4_ERROR_INODE(inode_bl,
> +				 "boot loader inode is not a regular file (mode 0%o)",
> +				 inode_bl->i_mode);
> +		/*
> +		 * Drop it as a bad inode, as ext4_get_journal_inode() does:
> +		 * with i_nlink =3D=3D 0, a plain iput() would try to delete the
> +		 * reserved inode, and otherwise it would stay cached.
> +		 */
> +		make_bad_inode(inode_bl);
> +		iput(inode_bl);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/* Protect orig inodes against a truncate and make sure,
>  	 * that only 1 swap_inode_boot_loader is running. */
>  	lock_two_nondirectories(inode, inode_bl);

[Severity: Medium]
Can calling make_bad_inode(inode_bl) on a live, unlocked inode race with a
concurrent swap_inode_boot_loader() caller and trick it into treating the
corrupted inode as an unused boot loader inode?

When the on-disk boot loader inode has a valid non-regular mode,
__ext4_iget() unlocks and returns it while it is hashed in the inode cache.
make_bad_inode() overwrites inode_bl->i_mode with S_IFREG and sets
inode_bl->i_op to &bad_inode_ops, which is the same state
swap_inode_boot_loader() uses to identify an unused boot loader inode:

CPU0                                  CPU1
swap_inode_boot_loader()              swap_inode_boot_loader()
  inode_bl =3D ext4_iget(...)
  !S_ISREG(inode_bl->i_mode)
  EXT4_ERROR_INODE(...)
                                        inode_bl =3D ext4_iget(...)
                                          /* gets same cached inode_bl */
  make_bad_inode(inode_bl)
    inode_bl->i_mode =3D S_IFREG
    inode_bl->i_op =3D &bad_inode_ops
  iput(inode_bl)
                                        !S_ISREG(inode_bl->i_mode) /* false=
 */
                                        ...
                                        if (is_bad_inode(inode_bl) || ...)
                                          /* reinitializes & swaps inode_bl=
 */

CPU1 then bypasses the !S_ISREG(inode_bl->i_mode) check, enters the
is_bad_inode(inode_bl) branch, and swaps the corrupted inode (preserving
its stale i_blocks, i_bytes, and union fields) with the caller's file.

[Severity: Low]
This isn't a bug, but now that non-regular boot loader inodes are rejected
upfront here, is the !S_ISREG(inode_bl->i_mode) check added by
991ed014de08 ("ext4: fix bug_on in __es_tree_search caused by bad boot
loader inode") further down in swap_inode_boot_loader() now redundant?

fs/ext4/ioctl.c:swap_inode_boot_loader() {
    ...
	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
		/* this inode has never been used as a BOOT_LOADER */
    ...
}

Dropping !S_ISREG(inode_bl->i_mode) from that condition would keep the two
checks consistent.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117065645.4409=
-1-founder@logarcheon.com?part=3D1
