Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795081862;
	b=UwYxEgF+Bsed7xa+sL2jpHLbuXj1Kz4qXeXaLsr9O7XT5HmXAJxzM0rWSZu8nMKnGMLx
	 ZKiv7uuQ5TxxLu8wCOO6N4Wl3imkfK1L0XRo88sz11gVbf5zLeWvF/uGae0j3oASq7WtT
	 IehHJb+F39sqp9UTHv1KWHKYWH8dynzvW/6PYlCCjUXRGcKRX6ePDEFFFKZLQ+I4b4cSe
	 h759CACMAw4mWoZ78kIeqL7K6WsE/9+hZfJDN+cODTKiPI0kOoQLCKvxNSpm29ktUObBM
	 gZ5xGLyRgo38JklrYULqA1Pw9+xwmatvL5kLQeJiNfaZBoF5hCzIQaSs9x+2rr2vLrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795081862;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:Content-Type:Content-Transfer-Encoding:X-Bugzilla-URL:
	 Auto-Submitted:MIME-Version;
	bh=1LgSgCoKTCRsZfwChF9VbUgdgThkLemnLSdSaRUrr3Q=;
	b=2sXLoJgmevM5F9gCDfdCI13j6xHWTkWLZSldXmsOlvRenmFUx+UzjrQq2M6W6Cc/ye0v
	 bRyPCDWj73MifS1oYdCv9/YQLMwATM/86gSz35blG6vyxq8lANAnld4KS3yz3rseldMGU
	 WJXGi2PlMJvstWwIUe4AylbtexQxiF1gcLA8Az9qlUibw6U8Ahk0eeW5AztFyNPxDd4K1
	 v2pzOc4oJzqCD7UGHwwzFx1/cGUw1MPRW/dCzWENRNNyFq2s19Z4wzzwhi97UKV3q9wc9
	 Y9qK35iRj8DRZe9HMmkK2k8lAyDwidJfWe6b5DoXbZhbJIkiEYRfsZSFIDxC1nGRAXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jEOcTFPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F240606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 09:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jEOcTFPU
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E84C1F000C5
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795081862;
	bh=1LgSgCoKTCRsZfwChF9VbUgdgThkLemnLSdSaRUrr3Q=;
	h=From:To:Subject:Date;
	b=jEOcTFPUhrqdmkBq5V3/C/mPf0HE7mv6GuFxrUHuvl2x2CFSC7IAZUDBZNsUH30m6
	 12YLQk69wGTgMVUksiRXSOAUJDdG3jDRNHk47pcr4ikUQsaPFaTPWYRl3SF1HjxDd2
	 6wixrIit5I9BpKZHDzPd2lGQeKeLL0a8ccrvkdte1U5CXpWY1mhjDju8+fhMqYg7tk
	 ZpzLETDTK2rRenekKPjeo2wn3FPXF1c6qXxScIGCVwhBr3W6ZUIGPOttnZi1kdT5c6
	 GCylvLjjllNRJleEU9mOnHi6V9567jEfXkvqzKnYMej/56X5eOxPrniU99+LLtH+fP
	 cJgjA864xxkCA==
Received: by aws-us-west-2-korg-bugzilla-alma10-1.codeaurora.org (Postfix, from userid 48)
	id 222D4240040D; Thu, 19 Nov 2026 09:51:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 222294] New: [REGRESSION] 6.1.191+: NULL deref in
 ext4_mb_load_buddy_gfp() after a3a7d360252c ("ext4: fix e4b bitmap
 inconsistency reports")
Date: Thu, 19 Nov 2026 09:51:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: internet.jejkowice@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-222294-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D222294

            Bug ID: 222294
           Summary: [REGRESSION] 6.1.191+: NULL deref in
                    ext4_mb_load_buddy_gfp() after a3a7d360252c ("ext4:
                    fix e4b bitmap inconsistency reports")
           Product: File System
           Version: 2.5
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: internet.jejkowice@gmail.com
        Regression: No

Created attachment 311518
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D311518&action=3Dedit
patch

Regression in the 6.1.y stable series, introduced in 6.1.191 and still
present in 6.1.192. 6.1.190 is fine.

REPRODUCER (100% on 6.1.191/6.1.192, 0% on 6.1.190):

    sync; echo 1 > /proc/sys/vm/drop_caches

The machine oopses immediately (kernel.panic_on_oops=3D1, so it reboots).
Without manual action it also hit during a nightly cron job (rsync doing
unlink()/rename() on an ext4 volume) at 04:45, after the page cache had
been churned by earlier I/O.

SYSTEM
Dell PowerEdge R820, BIOS 2.7.0, x86_64, 40 CPUs, CONFIG_PREEMPT,
ext4 on megaraid_sas. Self-built kernel from kernel.org tarballs.
Tainted (O): out-of-tree vboxdrv/vboxnetflt/vboxnetadp and xt_IPMARK,
none of which appear in the traces.
<.config attached / available on request>

FIRST OOPS (rsync, unlink path)

  Oops: 0000 [#1] PREEMPT SMP
  CPU: 15 PID: 73107 Comm: rsync Tainted: G O 6.1.192 #1
  RIP: 0010:ext4_mb_load_buddy_gfp+0xbc/0x390 [ext4]
  Code: ... 49 89 c7 48 3d 00 f0 ff ff 0f 87 3a 01 00 00 <48> 8b 00 a8 04
        0f 84 24 01 00 00 ...
  RAX: 0000000000000000 RBX: 00000000000003e4 ...
  CR2: 0000000000000000
  Call Trace:
   ext4_free_blocks+0x3a7/0xb30 [ext4]
   ext4_ext_remove_space+0x80f/0x1570 [ext4]
   ext4_ext_truncate+0xb4/0xc0 [ext4]
   ext4_truncate+0x310/0x480 [ext4]
   ext4_evict_inode+0x308/0x720 [ext4]
   evict+0x103/0x2b0
   do_unlinkat+0x143/0x2f0
   __x64_sys_unlink+0x3e/0x60
   do_syscall_64+0x35/0x90

A second rsync hit the same RIP via the allocation path
(ext4_mb_regular_allocator <- ext4_mb_new_blocks <- ext4_ext_map_blocks <-
ext4_writepages <- ext4_rename), for a different group (0x3fa vs 0x3e4).
Everything after that was fallout: BSD process accounting writes from
do_exit() into the already-broken ext4 led to further oopses, a dead
mutex waiter on a freed stack, and finally soft lockups on the
acct mutex's wait_lock until the box was reset.

CAUSE
Diffing 6.1.190 -> 6.1.191, the regression comes from
  a3a7d360252c ("ext4: fix e4b bitmap inconsistency reports")
  [upstream bdc56a9c46b2]
preceded in the same release by the preparatory commits
  e394adafb089, e6b6cbe9f2fb, 1c0f0e2b9b69
which are not themselves the cause.

The patch converts ext4_mb_load_buddy_gfp() and
ext4_mb_get_buddy_page_lock() to __filemap_get_folio() and checks the
result with IS_ERR() only. In 6.1.y, __filemap_get_folio() never returns
ERR_PTR() (mm/filemap.c, no ERR_PTR anywhere in the function). It returns
NULL when:
 - the lookup misses and FGP_CREAT is not set (falls through no_page to
   the final "return folio;" with folio =3D=3D NULL),
 - FGP_NOWAIT and folio_trylock() fails,
 - filemap_alloc_folio() fails,
 - filemap_add_folio() fails (folio =3D NULL).

So in the fast path
    folio =3D __filemap_get_folio(mapping, pnum, FGP_ACCESSED, 0);
    if (IS_ERR(folio) || !folio_test_uptodate(folio) || ...)
a cache miss reaches folio_test_uptodate(NULL) and dereferences address 0.
This matches the oops: "cmp $0xfffff000,%rax; ja" is IS_ERR(), followed
by "mov (%rax),%rax; test $4,%al" (folio->flags, PG_uptodate) with
RAX =3D 0, CR2 =3D 0. The FGP_CREAT slow path has the same flaw
(PTR_ERR(NULL) =3D=3D 0, so ret =3D 0 and the NULL folio is used), as does
ext4_mb_get_buddy_page_lock() (folio->mapping on NULL).

Upstream (>=3D v6.3) returns ERR_PTR from __filemap_get_folio(), so only
stable branches that received this backport without adapting it are
affected. 5.15.y and 5.10.y may be affected too if they got the same
backport; I have not checked.

WORKAROUND / FIX
Wrapper that maps NULL to ERR_PTR(-ENOMEM), used for all six
__filemap_get_folio() calls in fs/ext4/mballoc.c:

    static struct folio *ext4_mb_get_folio(struct address_space *mapping,
                    pgoff_t index, int fgp, gfp_t gfp)
    {
            struct folio *folio =3D __filemap_get_folio(mapping, index, fgp,
gfp);

            return folio ? folio : ERR_PTR(-ENOMEM);
    }

With this applied on 6.1.192, 4x "echo 1" and 7x "echo 3" to drop_caches
no longer crash (previously a single "echo 1" did).
<Result of cron.daily rsync after drop_caches with the patch: ...>
Patch attached; also sent to stable@vger.kernel.org and
linux-ext4@vger.kernel.org: <lore.kernel.org link>

Reverting a3a7d360252c is the other option.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.=
