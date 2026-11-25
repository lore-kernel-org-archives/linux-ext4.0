Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589233;
	b=pA4h+XAIYa0RySNZm4Op8Qsd/ZV7WGMHjVNjFtDj5CPIrYqG9cyVBWhui4Q7UfVe6f9v
	 kw4+mMxbLlxYN6QDabNu+gOLk4dFPkcO+zHzeAan5xaEENW6xI+ySwpb3yZt/4/hubqhA
	 vR5sddp0YlpjYCU2LguaBI6i/pGJYpu30EYNqTyHqDuj984qHFfUtJ1oemb8+H1Er7reg
	 SfNrV+5ZeC5sMmoE4040c424PVYsfwZTkTBILlWI8ywdyboHTsiulFxJ3WBpaWxAeGAr4
	 Rc6S1Oz43Q3Syx9Um8nD+W6COhAst4LmIRK4kpRU/hHHgzJU7lm3HoGkInT2GOG7tcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589233;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YbM35NhW/jsD/N/85nMN26A2nTWDpPw2c7W/6dieDkk=;
	b=a0GjAat4+bKQKC3pWOsLSHMQux6kU2sQd1/wRNlQFvkapqQBhoVisEINz3P2apPEfIfx
	 YheoXd04U39+IviiwBg2RCgQP92/qeNduDaLxM2QO4jMkKa2lBMGSF1E91/mchSRkIBND
	 i1hv6d1OJffXWCQAZaxAyIUy0OcksZ4/vziqdraYwvSHfKcgvXXQn7urUNg8TSkbKx/Om
	 KIgGN3T5aeHSmfbMZ0Y5jZjQCdsJ3zTZoaBioDmZ6ZkltOdH8T3WydvVzRhiWSRk2Lo93
	 Dj2xJ2AMPlT+NUCfJg75R24jdMh1xsZ39/dRd9QIj66sG8WHmCWl4zqu7/3rdJaqAAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hkNAdnEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C9606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 06:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hkNAdnEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939261F000C4;
	Wed, 25 Nov 2026 06:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795589232;
	bh=YbM35NhW/jsD/N/85nMN26A2nTWDpPw2c7W/6dieDkk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hkNAdnEmzigqMu6S3K5cEFC0KMXyrPb+sAqQFIsEmbjDq286o3qzc5iithcTtKC32
	 8uuGgokphT3FKNjuCozqK32lrQPucU/faThT6J5AuNsQJjpKK6Pdu1ivhnMyKjq2Kf
	 7yajd6wvdUOy9apjGcUhZHAJtqGS4YU8j/sgtqjXBLpngKZ9RaHu9JM5i+xS9k6Q6J
	 I7s6wH3GdZqyVMxb/Vz+EZgEaG1vTqjEmNtacur5CIcs8hCSJiwA3PYepBVL05Fcu+
	 FEZx4XQBLQS7wPkScSvNyn28AJ0cwcTEY3Z9SSrbO7LxzlztM12zzoq4KHGRVHpzN/
	 4wQK5DjLEB54g==
Message-ID: <sashiko-outbox-232734@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125063023.18022-1-arzuagapozosergio@gmail.com>
References: <20261125060131.10328-1-arzuagapozosergio@gmail.com>
 <20261125063023.18022-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:47:12 +0000
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
- [High] ext4: unbounded xattr journal credits in __ext4_new_inode()
--

commit 7d32898686e8e393a0ba63d6580e4c83b8362716
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit removes the old-ea_inode dereference credits from
__ext4_xattr_set_credits(), bounds ext4_xattr_set_credits() against the
maximum JBD2 transaction buffers, drops provisional ea_inode references
when reusing cached xattr blocks, and adds an ext4 kselftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 527f1f703c3e0..82623f5635c4c 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -888,8 +888,7 @@ static int ext4_xattr_credits_for_new_inode(struct in=
ode *dir, mode_t mode,
> =20
>  		nblocks +=3D (S_ISDIR(mode) ? 2 : 1) *
>  			__ext4_xattr_set_credits(sb, NULL /* inode */,
> -						 NULL /* block_bh */, acl_size,
> -						 true /* is_create */);
> +						 NULL /* block_bh */, acl_size);
>  		posix_acl_release(p);
>  	}
>  #endif

[Severity: High]
Can nblocks in __ext4_new_inode() still exceed the journal transaction
limit when creating an inode in a directory with a large default ACL?

Dropping the old-ea_inode dereference credits allows ext4_set_acl() to set
a default POSIX ACL up to ~64 KiB on a 1 KiB-block ea_inode filesystem
with a 1 MiB journal.  When a subdirectory is later created in that
directory, ext4_xattr_credits_for_new_inode() charges 2 *
__ext4_xattr_set_credits() for the inherited default and access ACLs plus
security and fscrypt xattr credits, without checking the total against
jbd2_journal_get_max_transaction_buffers():

fs/ext4/ialloc.c:__ext4_new_inode() {
	...
	if (!handle && sbi->s_journal && !(i_flags & EXT4_EA_INODE_FL)) {
		ret2 =3D ext4_xattr_credits_for_new_inode(dir, mode, encrypt);
		if (ret2 < 0) {
			err =3D ret2;
			goto out;
		}
		nblocks +=3D ret2;
	}
	...
			handle =3D __ext4_journal_start_sb(NULL, dir->i_sb,
				 line_no, handle_type, nblocks, 0,
				 ext4_trans_default_revoke_credits(sb));
			if (IS_ERR(handle)) {
				err =3D PTR_ERR(handle);
				ext4_std_error(sb, err);
				goto out;
			}
}

For a default ACL of 20 KiB or larger, nblocks exceeds the 248-buffer
limit, triggering WARN_ON(1) in start_this_handle() and passing -ENOSPC to
ext4_std_error(), which aborts the filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125063023.1802=
2-1-arzuagapozosergio@gmail.com?part=3D1
