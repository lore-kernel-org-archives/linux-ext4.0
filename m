Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.152.32.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339455;
	b=JOBPIwWR8ftC4kv06J24wKXYIWpiz3BuqZRcRuJUFqeEhwLXwOOSfc9U4HFx1f7e1cOW
	 6R2PG/2oyjuijiA2c20KfsMH35KeoXx8iGbItsclu4Zf4aS+cZUhQUlDVDjgiPcUesjOq
	 NOqrthAGug4iRRBfavCS/9+sTPx+zNsvOauXveRLL8eN5TTwOXbsld/llU9bwOCwtwgjv
	 kimg2PAUx4XBinqfpJ/kUhVbDeJNFKqTSHqb3u7vG9o3bnmrFT/EP596obG0p4j+tp2Bf
	 SeeHmfMuHubIO+7bvu/mz5mlunzpbZjj2x4iqK1v7hotwdL8Tdfnwm1pUaGfJslkoBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339455;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Virus-Scanned:
	 X-ESPOL;
	bh=nMLSt2CPr4hWsHEgJd5HWwOeNHuxP63ShwVUaGYoVVg=;
	b=4Dq8GsHU3nNmCLXgxZFABO8ZUiMMlgKKqPg6Kqd5TZXnwOJTb/Q9t4gKq0vBf0cbIna1
	 k/fY7SocySgKRI36zhGNuZvllU29NUtIP4ITBvM0YKeFnC/vEhjlwUc84F9MDoTcG/+9H
	 JhboHWLM8YJBhgfUfGa0iOoXKihyNfauTz4koTIWKwZFcUofyj/uHT0GodaAcV7ONfKMj
	 9KZqlmRR6Kt223uDyIQE12hqtjx5CkOKYtNbg/mfy37R/2MaOl8CHaQmHiTLRVsrgo7t4
	 5cAkKtPickAy0QUzm/9QGpyQqTS20VMz5AGr91Y++nORFdrsTXgNeRhsbjVv9GDnueQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inbox.lv;
	spf=pass smtp.mailfrom=inbox.lv;
	dkim=pass header.d=inbox.lv header.i=@inbox.lv header.a=rsa-sha256 header.s=p20220324 header.b=cUmzt4tZ;
	arc=none smtp.remote-ip=194.152.32.89
Received: from new-shark9.inbox.lv (new-shark9.inbox.lv [194.152.32.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6870C606A320;
	Tue, 10 Nov 2026 19:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6870C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inbox.lv
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inbox.lv
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inbox.lv header.i=@inbox.lv header.a=rsa-sha256 header.s=p20220324 header.b=cUmzt4tZ
Received: from shark3.inbox.lv (shark3 [10.0.1.83])
	by new-shark9.inbox.lv (Postfix) with ESMTP id 4jPH3d1npXzgZSr;
	Tue, 10 Nov 2026 21:37:17 +0200 (EET)
Received: from shark3.inbox.lv (localhost [127.0.0.1])
	by shark3-out.inbox.lv (Postfix) with ESMTP id 4jPH3d122pzRhYp;
	Tue, 10 Nov 2026 21:37:17 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.lv;
	s=p20220324; t=1794339437; x=1794341237;
	bh=KM7vyKp3wkhmvgMpRn0pGPSY4NnV03NzgcSNPK0jySU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:X-ESPOL:
	 From:Date:To:Cc:Message-ID:Subject:Reply-To;
	b=cUmzt4tZRWtkx9U8CUQ5MB0LIr1r0xm3KesGtYZffhdIgSg5h3+YisiosKPT+OSR7
	 sQCW3VGCqvVmaH5UqIRmOMcq8j0+vHHGRaOgGN1WiWAAyyO/C77l5XYES26P1LL47C
	 k8YqkEob6Z0IX3JIqPT/gW2+zkCwbknk8/q99Y/0=
Received: from shark3.inbox.lv (localhost [127.0.0.1])
	by shark3-in.inbox.lv (Postfix) with ESMTP id 4jPH3d0cwLzRhYk;
	Tue, 10 Nov 2026 21:37:17 +0200 (EET)
Received: from shark3.inbox.lv ([127.0.0.1])
 by localhost (shark3.inbox.lv [127.0.0.1]) (spamfilter, port 35) with ESMTP
 id yBqgdydnhir7; Tue, 10 Nov 2026 21:37:16 +0200 (EET)
Received: from mail.inbox.lv (pop1 [127.0.0.1])
	by shark3-in.inbox.lv (Postfix) with ESMTP id 4jPH3c2RDGzRhXq;
	Tue, 10 Nov 2026 21:37:16 +0200 (EET)
From: Aleksandr Panfilenko <lexpasss@inbox.lv>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger@dilger.ca,
	willy@infradead.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aleksandr Panfilenko <lexpasss@inbox.lv>
Subject: [PATCH 1/1] ext4: fix NULL pointer dereference in ext4_mb_load_buddy_gfp()
Date: Tue, 10 Nov 2026 22:37:11 +0300
Message-Id: <20261110193711.3106773-2-lexpasss@inbox.lv>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110193711.3106773-1-lexpasss@inbox.lv>
References: <20261110193711.3106773-1-lexpasss@inbox.lv>
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
X-ESPOL: EZqEIBwB6gdL+J/+KpgOlO7j2q/TW14loyPy0L4x93Basq+jx9N0d2aRGIfrGgq/bg==

__filemap_get_folio() called without FGP_CREAT returns NULL, not an error
pointer, when the folio is not present in the page cache.  The fast path
in ext4_mb_load_buddy_gfp() only checks IS_ERR(folio) before evaluating
folio_test_uptodate(folio), so a NULL return leads to a NULL pointer
dereference in the folio flags test.

The buddy cache folios can in fact disappear from the page cache: they
are clean pages of the s_buddy_cache inode and can be reclaimed under
memory pressure, while nothing sets EXT4_MB_GRP_NEED_INIT again, so
ext4_mb_init_group() is not called to reload them.  We have hit this
twice in one day on 6.1.192 during background writeback on a server
under heavy page cache churn (fresh OS install + database restore):

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    Oops: 0000 [#1] PREEMPT SMP NOPTI
    CPU: 51 PID: 137989 Comm: kworker/u161:1 Kdump: loaded
    Workqueue: writeback wb_workfn (flush-253:1)
    RIP: 0010:ext4_mb_load_buddy_gfp+0xc0/0x3a0 [ext4]
    Code: ... 48 3d 00 f0 ff ff 0f 87 ... <48> 8b 00 a8 04 ...
    RAX: 0000000000000000
    Call Trace:
     ext4_mb_regular_allocator+0x1ba/0x600 [ext4]
     ext4_mb_new_blocks+0x3a9/0x530 [ext4]
     ext4_ext_map_blocks+0x670/0x8a0 [ext4]
     ext4_map_blocks+0x22b/0x5d0 [ext4]
     mpage_map_one_extent+0x60/0x170 [ext4]
     mpage_map_and_submit_extent+0x76/0x300 [ext4]
     ext4_writepages+0x6f8/0x860 [ext4]
     ...

The faulting instruction is the folio flags load (mov rax,[rax] with
RAX == 0) between the IS_ERR() check and the PG_uptodate test.

Before the folio conversion this was handled correctly: the old code used
find_get_page_flags() and explicitly tested "page == NULL" first, in both
the bitmap lookup (converted by 99b150d84e49) and the buddy lookup
(converted by 5eea586b47f0).  Treat a NULL folio the same way as the
"not uptodate / locked" cases and fall back to the FGP_CREAT path, which
will re-create the folio.  Also switch the two folio_put() guards to
!IS_ERR_OR_NULL() so that we do not call folio_put(NULL) after taking
the slow path with a NULL folio.

The error-path fix in c6a6c9694aad ("ext4: fix error pointer dereference
in ext4_mb_load_buddy_gfp()") does not cover this case.

The bug reproduces deterministically on 6.1.192: loop-mount a fresh
ext4 filesystem, write ~200 MB of files, sync, then run
"echo 3 > /proc/sys/vm/drop_caches" and write more files.  The drop
evicts the buddy cache folios, and the next allocation in the writeback
worker hits the NULL fast path within seconds:

    RIP: 0010:ext4_mb_load_buddy_gfp+0xc0/0x3a0 [ext4]
    Workqueue: writeback wb_workfn (flush-7:0)
    RAX: 0000000000000000
    Call Trace:
     ext4_mb_regular_allocator+0x1ba/0x600 [ext4]
     ext4_mb_new_blocks+0x3a9/0x530 [ext4]
     ...

With this patch applied (the ext4 module rebuilt against the same
kernel and config), the same sequence completes cleanly over multiple
cycles, with no oops and no ext4 warnings in dmesg.

Fixes: 99b150d84e49 ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
Fixes: 5eea586b47f0 ("ext4: convert bd_buddy_page to bd_buddy_folio")
Cc: stable@vger.kernel.org
Reported-by: Aleksandr Panfilenko <lexpasss@inbox.lv>
Signed-off-by: Aleksandr Panfilenko <lexpasss@inbox.lv>
---
 fs/ext4/mballoc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a15285224..11ca5a148 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1715,7 +1715,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+	if (IS_ERR_OR_NULL(folio) || !folio_test_uptodate(folio) ||
+	    folio_test_locked(folio)) {
 		/*
 		 * folio_test_locked is employed to detect ongoing folio
 		 * migrations, since concurrent migrations can lead to
@@ -1725,7 +1726,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		 * try to get the folio with lock in both cases to avoid
 		 * concurrency.
 		 */
-		if (!IS_ERR(folio))
+		if (!IS_ERR_OR_NULL(folio))
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
@@ -1774,8 +1775,9 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 
 	/* we need another folio for the buddy */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
-		if (!IS_ERR(folio))
+	if (IS_ERR_OR_NULL(folio) || !folio_test_uptodate(folio) ||
+	    folio_test_locked(folio)) {
+		if (!IS_ERR_OR_NULL(folio))
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-- 
2.34.1

