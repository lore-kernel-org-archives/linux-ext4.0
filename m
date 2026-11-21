Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795267232;
	b=NAUrezInTdlF8hnz0Q3P+xz10cxAm3768CfnwDJtgB1LpKNDZvRE8r5q77WBhkx3U3aA
	 OnDKuNovFDaK244EgpoY7t/ikN8NGE/RzKOvTazVu4l1AcouH012/tCP0Ugx/lkbpTXBy
	 4OdTgWZ69iDLdXsLDI7Uz77DDXhDCuJlGmtst/SSQLtZ3TjgXrMz09dxHg/OwjSmW5eqb
	 P4d558xnOmptaz4gYOGzwFQHU3DKCO9lgBjTuy3pBso9rKJS1FvFMImzXNKoIJdgAAfqS
	 F8lYZL54OXqG5rA12xSbfW6Q/a31vDZNTyBlyqBeCCwd7eNlqmGpFKX3CN/euWsA6TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267232;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QOgyUVDlSxaBIL7v8j8bXe+QBfBO6iqqbZdCZyiBmS0=;
	b=TejKtj9l6cTMFuqHpM9g0/0aNgf1b21Av4a2b50uNZpHmxnA+gkTrxkAZUtDSQJA2JZd
	 qrHaUVouOSP+m7ZBfIzC57hhSjKNDoUp7rT6oRscCAifGLHoYx5Ue7wlZgp+Mpbi7uS6W
	 U1J4Mj6X+C8MVqyoVtc6N1ADdNUbJxBXGjqPn0Y+B/lJKP0dgldz1HGtMAXBOiiJFHlXQ
	 mng+f9BvjSo90+WVnEgtWtuzflc4zTaF6ZC1Iw9yqF0T/f2ip6dckzgKrW4HPwoZP7AV/
	 oI0VcpyCag8NyinktDrKRUxViVvlLT60/1ukrzvDFkDk9olIAvvtv2XNyUKFe4vvrxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G0npnPaD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831D1606A331
	for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G0npnPaD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24B11F000C0;
	Sat, 21 Nov 2026 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795267232;
	bh=QOgyUVDlSxaBIL7v8j8bXe+QBfBO6iqqbZdCZyiBmS0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G0npnPaDKZJPz2ZU0Bq8hwpdzTR8PzxGwCoyTZ8ROjxyY/m4M89kQLNmpUelERk+3
	 xy5eiQ007A52S20XG1hmjQd9+r0td4II4NB8vSQ82pRuMCiM7FrtDjScckQotzK05P
	 e/D17++tn2mOFU9TI56Pcwnutv2ENcB0mX+FIIUNTChHQ/P+wTSj7i/n41ZKjWCvJ/
	 pTVP7L5k865aKkESEkOhkeazMGk7B7CwHk60luPaEVxu53CPn9P2TqD8MUQ49J+XdV
	 195ofjoqhAURnEvZuiUHwxgaDrUY0rAwCmezgH1rjMoPIz8iUi29pp7OWZkmuprXgn
	 R4YPVCTUrLNVQ==
Message-ID: <sashiko-outbox-227059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: discard inode preallocations when indirect block
 allocation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QXlrdXQgQ8SxbmPEsWs=?= <aykutcincik@ogr.eskisehir.edu.tr>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261121-ext4-ind-discard-pa-v1-1-ee92928f7797@ogr.eskisehir.edu.tr>
References: <20261121-ext4-ind-discard-pa-v1-1-ee92928f7797@ogr.eskisehir.edu.tr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 13:20:31 +0000
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
- [Low] ext4: inaccurate Fixes trailer in commit message
--

commit 1bfc794f1c8f78c227e6f7f7e5eea7e4e3428226
Author: Aykut C=C4=B1nc=C4=B1k <aykutcincik@ogr.eskisehir.edu.tr>

> ext4: discard inode preallocations when indirect block allocation fails
>
> When ext4_alloc_branch() or ext4_splice_branch() fails after the data
> blocks have been allocated, the blocks are released with
> ext4_free_blocks().  For an indirect-mapped inode these blocks usually
> come from the inode preallocation (PA), and ext4_mb_use_inode_pa() has
> already subtracted them from pa_free.  Freeing them does not return
> them to the PA, so the PA still covers the logical range while pa_free
> no longer accounts for it.
>
> Writeback retries the same logical range after such a failure, for
> example after sb_getblk() returns NULL with -ENOMEM for an indirect
> block that lies beyond the end of a shrunk loop device, and
> ext4_mb_use_preallocated() picks the same PA again.  This time pa_free
> is smaller than the requested length and the BUG_ON() in
> ext4_mb_use_inode_pa() fires:
>
>   kernel BUG at fs/ext4/mballoc.c:4779!
>   RIP: 0010:ext4_mb_use_inode_pa+0x557/0x890
>   Call Trace:
>    ext4_mb_use_preallocated+0xd96/0x1440
>    ext4_mb_new_blocks+0x72d/0x4900
>    ext4_ind_map_blocks+0x142c/0x2210
>    ext4_map_create_blocks+0x2be/0x5c0
>    ext4_map_blocks+0xbb2/0x1480
>    ext4_do_writepages+0x1dba/0x3a60
>    ext4_writepages+0x370/0x770
>    do_writepages+0x288/0x600
>    filemap_writeback+0x203/0x290
>    file_write_and_wait_range+0xf7/0x170
>    ext4_sync_file+0x418/0xdb0
>    do_fsync+0xda/0x240
>
> If the BUG_ON() is not reached, the mismatch shows up later as
> "freeing already freed block" and "ext4_mb_release_inode_pa: free N,
> pa_free M" errors when the PA is released.
>
> The extent-mapped path has handled this since mballoc was added by
> discarding the inode PAs before freeing the blocks in
> ext4_ext_map_blocks().  Do the same in both indirect error paths.
>
> An AI coding assistant (Claude Code with Claude Opus) was used to
> analyse the syzbot report, write a reproducer, trace the root cause with
> temporary printk instrumentation, and draft both the fix and this
> changelog.  I have reviewed the change and verified it as follows:
> without the fix the reproducer hits the BUG_ON() deterministically in
> QEMU (virtme-ng, KASAN and lockdep enabled); with the fix it ran 3/3
> times without BUG, KASAN or pa_free reports.  The ext4 KUnit tests pass,
> and a copy/write/delete workload on a no-extents filesystem leaves
> e2fsck clean.
>
> Reported-by: syzbot+d79019213609e7056a19@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd79019213609e7056a19
> Fixes: c9de560ded61 ("ext4: Add multi block allocator for ext4")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aykut C=C4=B1nc=C4=B1k <aykutcincik@ogr.eskisehir.edu.tr>

[Severity: Low]
In commit c9de560ded61 ("ext4: Add multi block allocator for ext4"),
indirect block allocation called ext4_new_blocks() without setting
EXT4_MB_HINT_DATA in ar.flags, so inode preallocations were never created
or used for indirect-mapped files.  Should the Fixes: tag point to commit
7061eba75ceb ("ext4: Use inode preallocation with -o noextents") instead,
which enabled EXT4_MB_HINT_DATA on the indirect allocation path?

  Fixes: 7061eba75ceb ("ext4: Use inode preallocation with -o noextents")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121-ext4-ind-d=
iscard-pa-v1-1-ee92928f7797@ogr.eskisehir.edu.tr?part=3D1
