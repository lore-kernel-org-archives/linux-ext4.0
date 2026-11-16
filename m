Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821788;
	b=1qgCwvLlsG7V7BsY2/KcD1jkNIH9QTJt42s1maYKF30lTzDyRdHT8JTuTJuP2iekgICX
	 63FUlKDUzn19oE2n3CO20F6IoE2hQqp/IHd1s6CGYnRm8hsu4nE+T/ILTnbwgnBN9sD3v
	 GL0YI72kOeu9b8HWJTmKum7B0IUl6rlvDM++OA5AeTMtIrnNbTocCUONcLUeV8yZrlCji
	 7TihMN18VCMGKb1kSlPk1tCh7Qt2LN5u8WHCxXo52UVOTTibNW4062MtJnFbDZ887pOBp
	 Qy7muu3bCt+IgLh7AIjty2TY3e/avMNNzlc3UUVbZL8xfZh6xLhg2EyDwD8oAYY9XUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821788;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7zjM6IZ/i/6KVojs+fWNQl/0lmngzDzbEnk7d6Yn1Ck=;
	b=rPiGG6EGDCAlfPPi6ntr16KOH+nsD7UBNR9j3Yd6vKcUwyjmf6fqcy7VIkqrT2K2N6M4
	 87U9126eq3uHsO4Cpa43Ysj9avJRZWgjySJzFyBDsNfUnTR3y7KGMQj8y9TobxuH7N1mf
	 7IEWACaKFqAyHPUSoR9ZmaDiKx3RAHLO7Eo1BYEUaY14UUifo+cNN9m9K1HB4yhkOHmY/
	 1keXtxuX75xLsR4fKUk/iFuhctotaztz4nDY1cBHGaMWrIXlFLxcXaLuWu4ciuUkLkN19
	 b/pwBnatSgVxYG2NS7nceSRjJRKhjCNnASB322Smi6FaJsxIk3cS/Faa8Mw6Uy2LIKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j1SV5otQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9632606A323
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 09:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j1SV5otQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2E01F000C9;
	Mon, 16 Nov 2026 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794821788;
	bh=7zjM6IZ/i/6KVojs+fWNQl/0lmngzDzbEnk7d6Yn1Ck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j1SV5otQuuTPCDsXpp8uybjupSl4FMzPBizUus9mb1UGHhJhSp/TuHajbGnVlfnhC
	 OEYxSFfejt6BpvtN+WcbYKjRDr5unGEPbwySZLSVrFQlmln4HO+heHyAxNhqfJvBFx
	 J3PzMJyP+EEe6qm/Ln0L+nNqTK9nDcWC2r5NhWFuuStooRx+pt3Ii66aboavfqYQ/h
	 tD4/TZ/d6A3dxF/MG+prLEVa0x2uTHeii/D2zV9e+BhA+SAOUpYK6IcnTx/AqmCoXT
	 bATUB89U9KKBhwCaLOTtEuZfd9Ejn/tb1hsvolodYC+P9XwafcltmwiBJa7rvDab7O
	 qquJoaJTIRUcw==
Message-ID: <sashiko-outbox-216623@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [BUG] ext4: NULL deref in ext4_mb_load_buddy_gfp() on 6.1.y
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivan Tiukov" <ivan@tiukov.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <ef745013-2ea2-4e2d-86be-ac3e4a9d0cba@app.fastmail.com>
References: <ef745013-2ea2-4e2d-86be-ac3e4a9d0cba@app.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 09:36:28 +0000
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
- [High] ext4: missing Signed-off-by trailer in commit message
- [Low] ext4: missing Fixes trailers in commit message
--

commit e1b11c11cdaa0a618daf0cfc52aa27557238d3df
Author: Ivan Tiukov <ivan@tiukov.com>

> ext4: NULL deref in ext4_mb_load_buddy_gfp() on 6.1.y
>
> Hello,
>
> Linux 6.1.y panics in ext4 under heavy unlink/truncate load. I believe th=
is
> is a stable-only regression from the mballoc folio conversion in 6.1.191:
> the converted code assumes __filemap_get_folio() returns an ERR_PTR when =
it
> cannot hand out a folio, but 6.1.y still returns a plain NULL, so the NULL
> check that IS_ERR() is supposed to provide is not there.
>
> The crash reproduced three times on one host within eight hours; the trace
> below is from the third one, captured over netconsole because the machine
> went down before journald could persist anything.
>
> =3D Crash
> --------
>
> Kernel: 6.1.192-1 (Debian 6.1.0-55-amd64), x86_64, 4 vCPU KVM guest, 8 GB.
> Process: rpmsign, doing unlink() of large RPM files on ext4 root.
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP NOPTI
>   CPU: 3 PID: 12736 Comm: rpmsign Not tainted 6.1.0-55-amd64 #1 Debian 6.=
1.192-1
>   Hardware name: Red Hat KVM, BIOS 1.16.0-4.module_el8.9.0+3659+9c8643f3 =
04/01/2014
>   RIP: 0010:ext4_mb_load_buddy_gfp+0xbc/0x380 [ext4]
>   Code: 89 44 24 08 f7 3c 24 48 63 d8 89 54 24 0c ba 01 00 00 00 48 89 de
>         e8 d3 6e ff f2 49 89 c7 48 3d 00 f0 ff ff 0f 87 28 01 00 00 <48>
>         8b 00 a8 04 0f 84 12 01 00 00 49 8b 07 a8 01 0f 85 07 01 00 00
>   RSP: 0018:ffffd065089bfae8 EFLAGS: 00010207
>   RAX: 0000000000000000 RBX: 000000000000004c RCX: 0000000000000003
>   RDX: 000000000000000c RSI: ffff8ecec175f908 RDI: ffff8ecdd505e000
>   RBP: ffff8ecee0983000 R08: ffff8ecec1582f70 R09: 0000000000000000
>   R10: 0000000000000000 R11: ffff8ece2a13eff0 R12: ffffd065089bfb80
>   R13: 0000000000008c40 R14: ffff8ecec0420a78 R15: 0000000000000000
>   CR2: 0000000000000000 CR3: 00000000150b2000 CR4: 0000000000750ee0
>   Call Trace:
>    <TASK>
>    ext4_free_blocks+0x410/0xbb0 [ext4]
>    ext4_ext_remove_space+0x7ff/0x15d0 [ext4]
>    ext4_ext_truncate+0xb4/0xd0 [ext4]
>    ext4_truncate+0x314/0x490 [ext4]
>    ? __ext4_journal_start_sb+0x105/0x120 [ext4]
>    ext4_evict_inode+0x2f8/0x710 [ext4]
>    evict+0x112/0x2c0
>    do_unlinkat+0x173/0x320
>    __x64_sys_unlink+0x3e/0x70
>    do_syscall_64+0x5d/0xb0
>    entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>    </TASK>
>   Kernel panic - not syncing: Fatal exception
>
> =3D Analysis
> ----------
>
> The faulting instruction is in the fast path of ext4_mb_load_buddy_gfp():
>
>   folio =3D __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
>   if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(f=
olio)) {
>
> No FGP_CREAT is passed, so when the folio is not in the page cache
> __filemap_get_folio() reaches no_page: and, on 6.1.y, simply does
> "return folio;" with folio =3D=3D NULL.
>
>   IS_ERR(NULL) is false, so the guard falls through to
>   folio_test_locked(folio), which dereferences NULL.
>
> RAX =3D=3D 0 at the fault and CR2 =3D=3D 0 confirm the returned value was=
 NULL. I
> also disassembled the shipped ext4.ko to make sure this is the code being
> executed:
>
>   315c8: call  __filemap_get_folio
>   315cd: mov   %rax,%r15
>   315d0: cmp   $0xfffffffffffff000,%rax    # IS_ERR() only
>   315d6: ja    <slow path>
>   315dc: mov   (%rax),%rax                 # +0xbc, faults with RAX =3D=
=3D NULL
>
> There is no NULL test anywhere between the call and the dereference.
>
> Commit a8d83471c560 ("ext4: fix error pointer dereference in
> ext4_mb_load_buddy_gfp()") added the IS_ERR() checks. That is correct for
> mainline, where __filemap_get_folio() returns ERR_PTR(-ENOENT), but it do=
es
> not cover 6.1.y, where the function returns NULL for the same situation.
>
> =3D Why this is 6.1.y only
> -------------------------
>
> __filemap_get_folio() changed its no-folio convention in v6.4:
>
>   66dabbb65d67  mm: return an ERR_PTR from __filemap_get_folio
>   38a55db9877c  filemap: Handle error return from __filemap_get_folio()
>
> That change is a semantics change for every caller, so it was never a
> stable candidate and 6.1.y does not have it. What 6.1.y did get, in
> 6.1.191, is the ext4 side of the folio conversion (862483175d3d, d34e4fd4=
e73f
> and the a8d83471c560 follow-up), which was written against the post-6.4
> semantics.
>
> I checked the tree heads:
>
>   branch         ext4 guard               __filemap_get_folio   result
>   linux-6.6.y    IS_ERR(folio) || ...     ERR_PTR(-ENOENT)      ok
>   linux-6.12.y   IS_ERR(folio) || ...     ERR_PTR(-ENOENT)      ok
>   linux-6.1.y    IS_ERR(folio) || ...     NULL                  NULL deref
>
> So 6.1.y is the only affected stable branch, and it stays broken in 6.1.1=
92
> and in linux-6.1.y HEAD. 5.15.y still uses find_get_page_flags() here and=
 is
> not affected.
>
> =3D Minor: a second latent site in the same file
> -----------------------------------------------
>
> ext4_mb_get_buddy_page_lock() has the same assumption:
>
>   folio =3D __filemap_get_folio(inode->i_mapping, pnum,
>                   FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
>   if (IS_ERR(folio))
>           return PTR_ERR(folio);
>   BUG_ON(folio->mapping !=3D inode->i_mapping);
>
> Here NULL does come back from FGP_CREAT when the allocation fails, and
> PTR_ERR(NULL) is 0, so the function reports success and then dereferences
> NULL in BUG_ON(). Same root cause, different symptom. I folded it into the
> patch below.
>
> No other file under fs/ext4/ calls __filemap_get_folio() in 6.1.192, so
> mballoc.c is the whole surface.
>
> =3D Proposed fix (against 6.1.192)
> ---------------------------------
>
> Use IS_ERR_OR_NULL() and translate NULL into -ENOMEM. This keeps working
> unchanged if 6.1.y ever picks up the ERR_PTR() semantics, and it is a no-=
op
> for mainline.

[Severity: High]
The commit message is missing a Signed-off-by trailer, which is required
under the Developer's Certificate of Origin before the patch can be
applied.

[Severity: Low]
Since this fixes regressions introduced by the folio conversion commits on
6.1.y, should the commit message also include Fixes tags?

  Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
  Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/ef745013-2ea2-4e2d-=
86be-ac3e4a9d0cba@app.fastmail.com?part=3D1
