Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.152.32.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339447;
	b=v88wzNGUZBCAkaAwLY2+m5+55SSJarLqsWTWTwXb4xmU+8zE2bCSnJps6fELc//2DowH
	 Zdu55gGnQu3pdC6I3FwcV7QYdtdM+D7HKnfzM2zmLBBvRM0HyMQrH3RRyV9wjWw/WA5f8
	 rUCmWhjgK3mHOcXYICryjNd2v+R+ivtj3PLjllW6Q2YEhiviiwcmNBOp76ZMK7EgzMfwr
	 A8AQoHtNm1ByZ2F6nIjxHZSK4nu6w+JKNmEVr2frcjcI/YTeUrHPYiCBh24OfnkXHRhgv
	 ZJNHaigXmfVK2h5qkTavlk/xNgpCRAGa/bWcTUgHAwzpHzBGw3XVAx0kRP0/dTavdAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339447;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Virus-Scanned:X-ESPOL;
	bh=fm98nlfTK99UdBrWE84b0/lqZBli+x2Fs7jL+lQqY3g=;
	b=RCL16Jv5ESAaCtE1rBY4d1tdfUVW1LUKkhG2ieoQhCkH4N2/6iEYdY8iFSf1TuXectMU
	 s0hxjvdlnbfwnZ5ytA/KUqHi7UsTl7mvwSkbOz+7gkZL69oSTsp29W2QUYyGacEBoBRhC
	 2+ERSZym9jEdCp1KWOiqfemnP8PVbcUe9wzLFCZdlBBUm8AkBV/nIziCoovuB/78n+rhf
	 /3ouc6o1f6Y0dW3oehuqDD1456SWBLJnxqWTJK2ViNGYHNvGJPkMmdnugBZWYFF3BOz7F
	 0CFvpXCrsxA3FkclGoYjW6ydAPV3p/Q4QinYvUagtwIlsHmOlK46o0Dl/xLIjsqMI6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inbox.lv;
	spf=pass smtp.mailfrom=inbox.lv;
	dkim=pass header.d=inbox.lv header.i=@inbox.lv header.a=rsa-sha256 header.s=p20220324 header.b=uowgGVAM;
	arc=none smtp.remote-ip=194.152.32.89
Received: from new-shark9.inbox.lv (new-shark9.inbox.lv [194.152.32.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED529606A31C;
	Tue, 10 Nov 2026 19:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED529606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inbox.lv
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inbox.lv
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=inbox.lv header.i=@inbox.lv header.a=rsa-sha256 header.s=p20220324 header.b=uowgGVAM
Received: from shark3.inbox.lv (shark3 [10.0.1.83])
	by new-shark9.inbox.lv (Postfix) with ESMTP id 4jPH3c5gbczgZSq;
	Tue, 10 Nov 2026 21:37:16 +0200 (EET)
Received: from shark3.inbox.lv (localhost [127.0.0.1])
	by shark3-out.inbox.lv (Postfix) with ESMTP id 4jPH3c4wYczRhZK;
	Tue, 10 Nov 2026 21:37:16 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.lv;
	s=p20220324; t=1794339436; x=1794341236;
	bh=wpuN4fb/9EEUxvIFIv0QedKmCRrTfq3DOCrDQrBa258=;
	h=From:To:Cc:Subject:Date:Message-Id:X-ESPOL:From:Date:To:Cc:
	 Message-ID:Subject:Reply-To;
	b=uowgGVAMycfPJ36id7T7v23LIBoUKUxfoOVUbveoftVpOXQ5RRLeadPLxUcZTM+yq
	 QfJL9i7HrAc+XOy2GswX2rKw0AfNgcE3uD4djiGomkun9oaCIGqx268CVQzt30DUBz
	 zlJSy7iD3PWZI5LdVUDmmpLsJ/w9sKqSCejfm/Sg=
Received: from shark3.inbox.lv (localhost [127.0.0.1])
	by shark3-in.inbox.lv (Postfix) with ESMTP id 4jPH3c4WGBzRhYp;
	Tue, 10 Nov 2026 21:37:16 +0200 (EET)
Received: from shark3.inbox.lv ([127.0.0.1])
 by localhost (shark3.inbox.lv [127.0.0.1]) (spamfilter, port 35) with ESMTP
 id PKrFcJBKKA0Q; Tue, 10 Nov 2026 21:37:15 +0200 (EET)
Received: from mail.inbox.lv (pop1 [127.0.0.1])
	by shark3-in.inbox.lv (Postfix) with ESMTP id 4jPH3b59PlzRhYk;
	Tue, 10 Nov 2026 21:37:15 +0200 (EET)
From: Aleksandr Panfilenko <lexpasss@inbox.lv>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger@dilger.ca,
	willy@infradead.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aleksandr Panfilenko <lexpasss@inbox.lv>
Subject: [PATCH 0/1] ext4: fix NULL pointer dereference in ext4_mb_load_buddy_gfp()
Date: Tue, 10 Nov 2026 22:37:10 +0300
Message-Id: <20261110193711.3106773-1-lexpasss@inbox.lv>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: OK
X-ESPOL: AJqERWVk+XRCvt66I5pv5v3mxdKvJSQu/Xi6z6FSnX9YsbrFsN1xc2eTB/ecFGDcbg==

Hello,

We have hit a kernel NULL pointer dereference in ext4_mb_load_buddy_gfp()
twice in one day on a freshly installed server. Both crashes are identical
(same RIP and offset) and were captured by kdump. Patch 1 fixes it; this
cover letter contains the full crash data and the analysis.

Environment
-----------

Kernel:      6.1.192-1.el9.elrepo.x86_64 (vanilla linux-6.1.y built by ELRepo;
             the affected code is identical in current mainline)
Hardware:    ASUSTeK RS500-E9-PS4 (2 sockets, 64 GiB RAM)
Filesystem:  ext4 on LVM on md-raid1, 120 GiB, block size 4096,
             features: has_journal ext_attr resize_inode dir_index filetype
             extent 64bit flex_bg sparse_super large_file huge_file
             dir_nlink extra_isize metadata_csum
Mount:       rw,relatime
Workload:    fresh OS install followed by heavy package installation and
             database restore (lots of writes and page cache churn); both
             crashes happened in background writeback (kworker), not tied
             to any specific userspace task.

Crash 1 (kdump at 19:26:27, 4683s after boot)
---------------------------------------------

[ 4683.607255] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 4683.619530] #PF: supervisor read access in kernel mode
[ 4683.624757] #PF: error_code(0x0000) - not-present page
[ 4683.627387] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 4683.631834] CPU: 51 PID: 137989 Comm: kworker/u161:1 Kdump: loaded Tainted: G            E      6.1.192-1.el9.elrepo.x86_64 #1
[ 4683.652787] Workqueue: writeback wb_workfn (flush-253:1)
[ 4683.658194] RIP: 0010:ext4_mb_load_buddy_gfp+0xc0/0x3a0 [ext4]
[ 4683.664141] Code: 48 63 f0 89 54 24 14 ba 01 00 00 00 48 89 74 24 08 e8 44 49 ec f5 48 8b 74 24 08 48 3d 00 f0 ff ff 49 89 c7 0f 87 32 01 00 00 <48> 8b 00 a8 04 0f 84 1c 01 00 00 49 8b 07 a8 01 0f 85 11 01 00 00
[ 4683.688284] RAX: 0000000000000000 RBX: 00000000000000a2 RCX: 0000000000000022

[ 4683.765356] Call Trace:
[ 4683.767559]  <TASK>
[ 4683.773060]  ext4_mb_regular_allocator+0x1ba/0x600 [ext4]
[ 4683.777952]  ? ext4_find_extent+0x378/0x440 [ext4]
[ 4683.782848]  ext4_mb_new_blocks+0x3a9/0x530 [ext4]
[ 4683.787823]  ext4_ext_map_blocks+0x670/0x8a0 [ext4]
[ 4683.792460]  ext4_map_blocks+0x22b/0x5d0 [ext4]
[ 4683.797441]  mpage_map_one_extent+0x60/0x170 [ext4]
[ 4683.797441]  mpage_map_and_submit_extent+0x76/0x300 [ext4]
[ 4683.803020]  ext4_writepages+0x6f8/0x860 [ext4]
[ 4683.818105]  do_writepages+0xcc/0x1d0
[ 4683.821867]  __writeback_single_inode+0x41/0x270
[ 4683.826575]  writeback_sb_inodes+0x209/0x4c0
[ 4683.830937]  __writeback_inodes_wb+0x4c/0xe0
[ 4683.835300]  wb_writeback+0x1d7/0x2d0
[ 4683.839058]  wb_do_writeback+0x22a/0x2b0
[ 4683.843080]  wb_workfn+0x5d/0x250

Crash 2 (kdump at 20:19:39, 3005s after the following boot) is identical:
same RIP (ext4_mb_load_buddy_gfp+0xc0/0x3a0), same workqueue, same
instruction sequence, RAX=0, different block group (RBX=0xbe vs 0xa2)
and CPU.  (The only difference in the Code dump is the relative call
displacement - see the note under the disassembly below.)

Analysis
--------

The faulting instruction sequence decodes to (bytes from the Crash 1
dump above; in the Crash 2 dump the call displacement differs - the
call to __filemap_get_folio is stored as an R_X86_64_PLT32 relocation
against the vmlinux symbol in the module and is resolved at module
load time, so its encoded value depends on the kernel and module load
addresses of a given boot, while the instruction sequence is identical):

    e8 44 49 ec f5        call  __filemap_get_folio      ; fast path
    48 8b 74 24 08        mov   rsi, [rsp+0x8]
    48 3d 00 f0 ff ff     cmp   rax, 0xfffff000
    49 89 c7              mov   r15, rax
    0f 87 32 01 00 00     ja    err                      ; IS_ERR() only
    <48 8b 00>            mov   rax, [rax]               ; RAX == NULL -> #PF
    a8 04                 test  al, 0x4                  ; PG_uptodate
    0f 84 ...             jz    slow_path
    49 8b 07              mov   rax, [r15]
    a8 01                 test  al, 0x1                  ; PG_locked
    0f 85 ...             jnz   slow_path

This is the fast path in ext4_mb_load_buddy_gfp():

    folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
    if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
            ...
    }

__filemap_get_folio() without FGP_CREAT legitimately returns NULL when
the folio is not in the page cache ("if (!folio) goto no_page;" in
mm/filemap.c).  The fast-path condition only checks IS_ERR(folio) before
dereferencing the folio, so a NULL return results in a NULL deref.

The ext4_mb_init_group() call at the top of the function is skipped for
groups that are already initialized (EXT4_MB_GRP_NEED_INIT not set), so
nothing guarantees the buddy cache folio is still in the page cache at
this point: the folios of the s_buddy_cache inode are clean and can be
reclaimed under memory pressure.  The folio conversion series dropped
the explicit NULL check that the old find_get_page_flags()-based code
had ("page == NULL ||" was the first condition) in both lookups: the
bitmap lookup was converted by commit 99b150d84e49 ("ext4: convert
bd_bitmap_page to bd_bitmap_folio") and the buddy lookup by commit
5eea586b47f0 ("ext4: convert bd_buddy_page to bd_buddy_folio"), which
is where the regression comes from.

The error-path fix from commit c6a6c9694aad ("ext4: fix error pointer
dereference in ext4_mb_load_buddy_gfp()") does not cover this case.

The patch switches the fast-path conditions (and the two folio_put()
guards) to IS_ERR_OR_NULL(), so a NULL folio falls back to the FGP_CREAT
path which re-creates it.

Deterministic reproducer
------------------------

Once the eviction mechanism was understood, the crash turned out to be
trivially reproducible on a test VM (same 6.1.192 kernel, stock ext4
module):

    # fallocate -l 1G /root/t.img
    # mkfs.ext4 -F /root/t.img
    # mount -o loop /root/t.img /mnt/t
    # dd if=/dev/urandom of=/mnt/t/f1 bs=1M count=200
    # sync
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/urandom of=/mnt/t/f2 bs=1M count=200

The drop_caches evicts the clean s_buddy_cache folios, and the next
block allocation in the writeback worker hits the NULL fast path within
seconds:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    CPU: 0 PID: 446 Comm: kworker/u4:4 Kdump: loaded
    Workqueue: writeback wb_workfn (flush-7:0)
    RIP: 0010:ext4_mb_load_buddy_gfp+0xc0/0x3a0 [ext4]
    Code: ... 48 3d 00 f0 ff ff 0f 87 ... <48> 8b 00 a8 04 ...
    RAX: 0000000000000000

Same RIP and the same instruction sequence as in both production crashes.

Verification
------------

I rebuilt the ext4 module against the same kernel and config with only
this fix applied (verified via srcversion that the patched module was
the one loaded) and re-ran the reproducer above for three full
write/drop_caches/write cycles: no oops, no ext4 warnings in dmesg.
The unpatched module panics on the first cycle.

Additional data
---------------

vmcores of both production crashes (captured by kdump) and of the
reproduced crash on the test VM are available on request.  No ext4
errors or warnings preceded the production oopses; the log simply ends
a few minutes before the kdump timestamp.

Aleksandr Panfilenko (1):
  ext4: fix NULL pointer dereference in ext4_mb_load_buddy_gfp()

 fs/ext4/mballoc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.34.1

