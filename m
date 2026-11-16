Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794856095;
	b=wONV3BztDo+TN1QU3rrNItcqAc5u7fqP6PDOSmTq55CuG2eZbHTR+IlVCKZuMdxQlCsv
	 5LVixHmKPvhyDXehO85JInFPnymMUsXI1oTm+HOEkkFT77vdqEkAZBE2okrZ4SY5dfy9d
	 zt/8igolQoePNsh9I9ixwxloYIaPdN/NdPZ3cSi/sAnJ1TASPKVxOJy40M7AhlgyV5nu7
	 lTgFK5k0+60p+w+5kFOqh0KLtRSWtU70+Ye3dxEzQaDUG9STcdgkK/PgL5r9UDOVvgiAA
	 L6hpCQZ3L+QgAtVEHJZEFFOTW6oXA9YDjLR0TSVAfJtIZSA1pGO/4ilSKI8QKLbmgZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856095;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rCSHvQXrdzfNAYqyRuzGEadB9Z562PyE1Liu7faRu5o=;
	b=bMGsP+4gJ9UDkoFTIPG+ZKFo00Y/VGNzlsJ0DyRYvDQ6yKzOwDzQctM9K4peUxSrw+vV
	 yStCpi4R+AJcucO3QfEDxmzIg3cNeGQ9m0/okfEd00rW0ZXMrLDh2Kd0V0EEaCK2VLAKu
	 eGS7Nus8y18AFYTsZxWXhCaTSfcMRnxC44zJ0jlNoHLviI0NSuiVVyrB6m0Lss9dVTC+E
	 Y05mUkBLb7HwzQfA26+dT8FfVZQlv9MOh8yXF64YAinc6wphvWOVHulF8hVTFji/oa7gA
	 enYum6kUBe8LxZgMx6LWgvZr4vpd74mhhLwJU2uHu3f4gDv9b+P1k3ZnNoUiCUX78RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3dEw1Qg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC49606C573
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3dEw1Qg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441321F000C9;
	Mon, 16 Nov 2026 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856095;
	bh=rCSHvQXrdzfNAYqyRuzGEadB9Z562PyE1Liu7faRu5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M3dEw1Qg5cmH7UEtSQOESArJytMnBXXGAdeP5gqwwnzE5xcxu4e3WYfrCbWPO73wh
	 xYShZFijfGjmtyQiWqGJc4K0aK56BDnvNk5GhJ8upw8HiJAhZDnsO8umVD+QhlZUOD
	 VIR66qhDNh2jE2MBYhXMw5jLkRvRLr4d1XFVCa9l8XV39rsjfNqJ8YyYTCxLtjyidN
	 XwKi5Ho0zqSpinDtSRp8awzZFi+9mFKwUbWiEL+8RzQZknr6TAIM/dynNXCTpSMaKT
	 lT344BQn3kI8K+Z567Nm/6vv93Q3p9gJPZWnQBR3uF4u0EYSucaZKQ4OGftETHk4zx
	 6XVH+4n90uMjA==
Date: Mon, 16 Nov 2026 19:08:13 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH] e2fsck: set the encrypt feature if the filesystem has
 encrypted inodes
Message-ID: <20261116190813.GA229817@google.com>
References: <20261113162143.824544-1-berto@igalia.com>
 <20261113202745.GA29151@quark>
 <avsP3xlSwVjj3GJh@igalia.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avsP3xlSwVjj3GJh@igalia.com>

On Mon, Nov 16, 2026 at 03:14:55PM +0100, Alberto Garcia wrote:
> > > +	/* The inode is encrypted, so the filesystem needs the encrypt feature */
> > > +	if (!ext2fs_has_feature_encrypt(ctx->fs->super) &&
> > > +	    fix_problem(ctx, PR_1_ENCRYPT_FEATURE, pctx)) {
> > > +		ext2fs_set_feature_encrypt(ctx->fs->super);
> > > +		ext2fs_mark_super_dirty(ctx->fs);
> > > +	}
> > 
> > I'm a little surprised the fix is to set the feature flag, rather
> > than clear the inode.  It looks like e2fsck does this for other
> > feature flags though, so I guess this is consistent with that.
> 
> That's also what I understood from the previous conversation at
> https://lore.kernel.org/linux-ext4/armU51iuvA9d7zvR@igalia.com/
> 
> So this patch assumes that the inode is correctly encrypted but the
> feature flag is missing (because it was accidentally removed or
> something).
> 
> A different situation would be if the inode has the encryption flag
> when it shouldn't, but the basic case is already handled by e2fsck
> (would we need an additional test for this?):
> 
> # dd if=/dev/zero of=image bs=4096 count=128
> # mke2fs -b 4096 -N 128 image
> # debugfs -w -R "mkdir edir" image
> # debugfs -w -R "sif edir flags 0x800" image
> # e2fsck -vf image
> e2fsck 1.47.4 (6-Mar-2025)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12 has encrypt flag but no encryption extended attribute.
> Clear flag<y>?
> 
> Other possibilities:
> 
> - The flag is set, the xattr is corrupt: this is already checked
>   (immediately before the code added by this patch).
> - The flag is unset, the xattr is present: this situation is
>   not detected, but I don't think it has any consequences?
> - The flag is set, the xattr seems valid (or unknown) although the
>   file is not supposed to be encrypted. This is the only problematic
>   case, here e2fsck would suggest to set the feature flag. But this
>   looks like a very unlikely scenario, or am I missing something?

Yes, that sounds right.  If a bit flip enables EXT4_ENCRYPT_FL on an
inode, it will almost certainly trigger the NO_ENCRYPTION_POLICY case
(which clears EXT4_ENCRYPT_FL) or CORRUPT_ENCRYPTION_POLICY case (which
clears the inode).  This new check is after that, when the inode has
both EXT4_ENCRYPT_FL and a valid-looking xattr.  So setting the feature
flag there should be relatively safe.

- Eric
