Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657811;
	b=uWrUhfLFg3gtqt0mf3hB6GDmvsZrnRCOyLzPRJAkB5HbtlOG8ncrrPDVSVswXWnztwW6
	 eSPxurUeM8rPWe7K6E0SqV8WJDEa4A8vMY21zl4pLY+ZCq229/aWF8zSD8XurGKSTFU9K
	 67veezwGhFgu8X0Id1iFBSjtPOZNgWDM8OLMWeSlho+6AmCSnIH7uU3T9mEyIBcz8mfqV
	 zRHONS2DnMeq9mXKQFaFGerVMaBGrinDjfxNB8t7pdSd+1//ks0QxkaB9z5nDOm5Um1eS
	 i8+gZvJu2s55vhW6NiOZADTBgr3PYEbpAm8Jbf192n/eUmz2STh2EWuXwOTEKTz4YEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657811;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=m8bjqjOZXXJPj1tfqG9iwnas9qJ8BH37nqepWAHXyz4=;
	b=NG5XpCrN7n9srSXSjxEcwHYg6fN2tTLt/NWfMFeXN2YkGx1nZuhBWSMipy2Bm12xsM1x
	 joy0yxtMpEW4K8nl2dIIO6RHYxmm2EG+/+fQZzks/ey40RPYhxCIOOioUQletiiuH2qsu
	 bfkuAaJ8e5/XVCj9cafoE6WKtu1ZyuDsO0Xkz3U+pOjcSR2elXlUiygbX0N2bpPvfisec
	 umNjpy8NKDQXjGY0ngPq23vaduMPfnYLhOmx7X/EzP4U4nxK7F3XpsA6WjjMCI2i67l/6
	 Z+1AuaHCguCtOb51mGajzaW6fCH9TRLKsF1qqgBTWTMzjhKIJ9nWEgaaukuRqzi0nEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTkZ9H3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BBE606A32D;
	Sat, 14 Nov 2026 12:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTkZ9H3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2641F000C4;
	Sat, 14 Nov 2026 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657811;
	bh=m8bjqjOZXXJPj1tfqG9iwnas9qJ8BH37nqepWAHXyz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VTkZ9H3kLYaSH+ftQJare6BeAJ35leW2srLLeVqVNkIYufakLwc9qsPh7q6PyK+GQ
	 2ESGn5N0LRUxkvTDHqu/Iodt7hjLHU2IBpfcd6KHkZ4X5RchqdoqPfjR2gvnP7Jzzi
	 v3r7/NXEE33bdYANLq7Kc1uharlCSFFOH1YrAdyf8EjtHgqtSd5DAIGxLsopxrYOA7
	 c5UFB4cjnyUOFj3v6kLAgLIBJGi137K/4UixHmfbUnRHqyoCrZVv17A0U1XRCHd3IW
	 xnyP/lx78ekHV4o2o9rHn12pw/WS+rCrGk1Nvtjm8XCbZZO/7VDsyEf+np+R0r3kEP
	 shGz027E42Ciw==
Message-ID: <sashiko-outbox-214462@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/33] exfat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-11-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-11-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] exfat: exfat_page_mkwrite() checks emergency state and
  dirties before sb_start_pagefault()
--

commit e1275d4c04928c834a6a34f6b3133c89c272c085
Author: Christian Brauner <brauner@kernel.org>

exfat: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY on runtime filesystem errors with an
EXFAT_FLAGS_EMERGENCY_RO flag and checks exfat_emergency_state() across wri=
te
and modification paths so frozen filesystems can thaw cleanly.

> diff --git a/fs/exfat/file.c b/fs/exfat/file.c
> index 1386149916bbe..dddedf6e75da6 100644
> --- a/fs/exfat/file.c
> +++ b/fs/exfat/file.c
[ ... ]
> @@ -974,6 +987,11 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault=
 *vmf)
>  	struct exfat_inode_info *ei =3D EXFAT_I(inode);
>  	vm_fault_t ret;
>  	loff_t new_valid_size, mmap_valid_size, fault_page_start;
> +	int err;
> +
> +	err =3D exfat_emergency_state(inode->i_sb);
> +	if (unlikely(err))
> +		return vmf_fs_error(err);
> =20
>  	if (!inode_trylock(inode))
>  		return VM_FAULT_RETRY;

[Severity: Medium]
Can a write fault that blocks in sb_start_pagefault() bypass
exfat_emergency_state() if a filesystem error or shutdown happens while the
filesystem is frozen?

CPU0                                    CPU1
exfat_page_mkwrite()
  exfat_emergency_state(sb) -> 0
  inode_trylock(inode)
                                        bdev_freeze()
                                        ...
                                        __exfat_fs_error()
                                          set_bit(EXFAT_FLAGS_EMERGENCY_RO,=
 ...)
  sb_start_pagefault(sb)
    /* waits for thaw */
                                        bdev_thaw()
  file_update_time(...)
  iomap_page_mkwrite(...)               <-- installs writable PTE after err=
or

Because sb_start_pagefault() is called near the bottom of
exfat_page_mkwrite(), after exfat_prepare_valid_range() and
mark_inode_dirty(), a fault arriving on an already-frozen filesystem can
also dirty gap folios and the inode while frozen and then sleep in
sb_start_pagefault() while holding inode->i_rwsem:

fs/exfat/file.c:exfat_page_mkwrite() {
    ...
		exfat_advance_zeroed_size(ei,
				round_up(new_valid_size, i_blocksize(inode)));
		exfat_set_valid_size(ei, new_valid_size);
		mark_inode_dirty(inode);
	}

	sb_start_pagefault(inode->i_sb);
	file_update_time(vmf->vma->vm_file);

	filemap_invalidate_lock_shared(inode->i_mapping);
	ret =3D iomap_page_mkwrite(vmf, &exfat_iomap_ops, NULL);
    ...
}

Calling sb_start_pagefault() before inode_trylock() and checking
exfat_emergency_state() after acquiring freeze protection would avoid both
dirtying state while frozen and missing an error that occurred during the
freeze.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D11
