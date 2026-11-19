Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795076151;
	b=jTt/HMzISQK+BOiU6mqeGDhcrE1Bax0aw13MoJwHGzWS6SgUO+G1LXz5pLrGTT17TLMN
	 Qh61lvTM6vwmnTvkmn7MtZbSGwiwT6wkBKYT6/jhrfSIGdQ3tVEEafzdkTeFzN9tNvIRS
	 b3CN9fapXW2+Dtk+auSS5+x/E1KIganTwFCqyrKFH01y5m6mDw/9uexZeKxC1edDeQ4nq
	 6jjhOfM2fXnB7f6xp1QqQTsOJ8oxyJasFX0CqEE7NjQ1P3PPuBAlqax83Q+ltw9lfrGEY
	 RR2WgXsWvSore3cjZsvW6nZ+EEeHsvcJMQ/g8YUMxRpsyXCsQ3HTIbJwarg3LoUDYvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795076151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Content-Language:To:From:Subject:Content-Type:
	 Content-Transfer-Encoding;
	bh=N+YjgwIoX4f73J3ZsRVql7hx9g3wjHCbxjGp0yS/4mo=;
	b=tvwJGUE1EI0CqdnvJxy2qMknbWq5ss15RJ0fw+gvkRzDYw3XISOHRX+ksPNlNmbUsOqo
	 S7tSxtwkGyh4EKm4oAuzvQVIixpyHsYr7I0oxsPzMB0fy+cAgKJJHny5Wn4MJC/o1Zmyy
	 tWiTOUS2sdAi82GoZzqETZVTtP4/KNLV84jWSxOz/n9CjSGyghmrEkukDeRzQ62dbuhIu
	 QDAKi47Mvsr/sff5b3jgzenLJKVsiKg4a5l3MHb4jDtd+8OfAGQxhL72m7ZvNbNZdhsp8
	 wlYoH7mjjgrlX3q8rhelRQyhSJ0v3EzZq1C6UGIwtmV4+B0khv1rSWUUHtFVw13EVkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GUF1mBZi;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45625606A32C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 08:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45625606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GUF1mBZi
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b87a1a2babso1262058a12.0
        for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 00:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795076148; x=1795680948; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=N+YjgwIoX4f73J3ZsRVql7hx9g3wjHCbxjGp0yS/4mo=;
        b=GUF1mBZiNF1OqK+J55vBXprtZfIP+o8Eymoc3yEKhCFSg48FFha7YYaHnvkk50VP2z
         yYqX27avD3a4DAcNSAtlkDrCaqfasX+82rDzToft8fX292dkzrKlr/Ml03nuW0Epb+Xb
         vN72+GZu2NFsPBXkDazh2m5juWwi7HN3pW2HNUv1ZEn/AaFSRJdt+X1WwiyjkHowFycL
         1lomiwklO1Dadtnzqqrd8esB3gAksARhDgDeLG5I6zp+pcbL4JvMcdzKPzdUI5dYbaVp
         Bzp1WQgNzOJ6ewYQP0Qhlx0Wdl6twRZfG0hXvj8kr3LGAhXnJnC+KiRp/VwU2S8tHz+D
         50Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795076148; x=1795680948;
        h=content-transfer-encoding:content-type:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N+YjgwIoX4f73J3ZsRVql7hx9g3wjHCbxjGp0yS/4mo=;
        b=VZtmygvde5IZu9QrCmEQ2PNcQJAJ/m+UVr1gfcDWppp2c5jguIa5fjZxNa/+Ou4aku
         LiVgrl4OTY0LvrtGku+EqGqHJ4ztm+Go2ABu/ivUD8LAyBMIoFE1nBVPj2odxhOtceSZ
         1oPVp7SN5ZW8HbXLK6tI9wKU+rOVZENYL3kg7buOO7gGKxAqiciaHiTQ6/BQ+hal94IV
         Nbhsmm5dG4D9R+0qq3vxhdjjMRgb4bHUOZjkibYdkFgbG4B+ii9D0QgRMvWFZEKQT9+m
         GB51DIWjJ4bT3oNVfrGIOkz4rqReYX5PlC+pPe6k9m8UmzYYxmU0iFhf0CHQaQL9N2q8
         WSuA==
X-Gm-Message-State: APuU4Z8f9BzB506Aj5q/hyex6xoId4o2Yqwu2PrjPhYVnAXALoRBa9en
	aT1iu97G1IAnmW7iICnXQT2+MkrE37DyzUtNljDg5LIVDZPcqTQqBsPay+QRwg==
X-Gm-Gg: AYBFou0uBAQqNkurHKYTsqpPqjVKYF9yMDa9IxVy7PTq29GoylqNhbVCEtPavMu5Qto
	kb9NOULTeOFFgGuHJt5CgwzxzqiQtvX9EhDsJt7w87bA9jUQby1ZfggzMVgUHzwTa9PokStc4Nj
	RSffnjI3/rkgBH7cE0etnCSLimpyi2Sk9HplgHTDXAHjfNJg9YiioQCCPzK0JhQZWU7zIWaR7LI
	nJi/wV0xXrS9gzQFF4YZipo3p25AyoF9dUXgbs0vlv05r9BmiWlDqDQTx9zzqlHIz7jdQLQsQo6
	DxDNiTA/7v6uLxTn0H+UYr4VWNf9r3gjKb6ydwZ5Sb8/Rm98DwhMmwZ39BB0OWrkag3G9SpEoOm
	AS7f47TbC/Gi5p+7w0XIIuaL+5oPqotusNqmr9xtP2Zb1bSgJId/lh7wDoIq3FvYkYi7C93iNEc
	0ztsByPDZmNdkie5Kuz5eaIG2hkXGE4xq3uAjbMaSGbL5Q/ZbcZi6gQ2hLAdtAz2F5Pcb/LsSQu
	GIzM5IRODUs59sdiokt2Zqm6x3P6qej+gIvisoSc+E1w4Vx7YAm9XRT4mZ4wmwNLH0sXssxDhir
	AOpVaRMTBipI8qs1kyWT12m7Z7+7WHmWYTjIErijD6bBTh7P4DKvpG5kZZvoou0C/BNcNyqkuw=
	=
X-Received: by 2002:aa7:c68f:0:b0:6ba:1355:1b3c with SMTP id 4fb4d7f45d1cf-6ba1fac0f05mr271267a12.16.1795076148377;
        Thu, 19 Nov 2026 00:15:48 -0800 (PST)
Received: from [192.168.11.2] ([195.66.73.202])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b888ef94a5sm2066084a12.4.2026.11.19.00.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 00:15:47 -0800 (PST)
Message-ID: <81b3f525-0d62-4a46-a0f3-77d54b11d847@gmail.com>
Date: Thu, 19 Nov 2026 09:15:46 +0100
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl, en-US
To: linux-ext4@vger.kernel.org, stable@vger.kernel.org
From: "Safe-Lock.NET Dawid Partyka" <internet.jejkowice@gmail.com>
Subject: [REGRESSION] 6.1.192: NULL deref in ext4_mb_load_buddy_gfp() after,
 dropping page cache (__filemap_get_folio() returns NULL, callers check
 IS_ERR())
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

After updating from 6.1.190 to 6.1.192 I get a reproducible NULL pointer
dereference in ext4_mb_load_buddy_gfp() whenever the buddy/bitmap pages of
an ext4 group are not in the page cache.

Reproducer (100% on 6.1.192, 100% OK on 6.1.190):

     sync; echo 1 > /proc/sys/vm/drop_caches

The machine oopses immediately (panic_on_oops=1, so it reboots). It also
happened without any manual action: a nightly cron job (rsync doing
unlink()/rename() on an ext4 volume) hit the same oops at 04:45.
I have not yet tested 6.1.191.

Setup: Dell PowerEdge R820, x86_64, ext4 on megaraid_sas, CONFIG_PREEMPT.
Kernel is tainted (O) by out-of-tree modules (vboxdrv, xt_IPMARK), but
neither appears in the trace.

First oops (from the cron run, rsync doing unlink):

   BUG: kernel NULL pointer dereference, address: 0000000000000000
   Oops: 0000 [#1] PREEMPT SMP
   CPU: 15 PID: 73107 Comm: rsync Tainted: G O 6.1.192 #1
   Hardware name: Dell Inc. PowerEdge R820/066N7P, BIOS 2.7.0 01/07/2020
   RIP: 0010:ext4_mb_load_buddy_gfp+0xbc/0x390 [ext4]
   Code: 89 44 24 08 f7 3c 24 48 63 d8 89 54 24 0c ba 01 00 00 00 48 89 de
   e8 b3 f3 70 e0 49 89 c7 48 3d 00 f0 ff ff 0f 87 3a 01 00 00 <48> 8b 00
   a8 04 0f 84 24 01 00 00 49 8b 07 a8 01 0f 85 19 01 00 00
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

A second rsync hit the same function via the allocation path
(ext4_mb_regular_allocator <- ext4_mb_new_blocks <- ext4_ext_map_blocks <-
ext4_writepages <- ext4_rename), different group (0x3fa vs 0x3e4), same RIP.
The subsequent oopses were fallout (BSD accounting write from do_exit() into
the already-broken ext4).

Analysis:

The diff 6.1.190 -> 6.1.192 of fs/ext4/mballoc.c converts bd_bitmap_page /
bd_buddy_page to folios, with code like:

     folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
     if (IS_ERR(folio) || !folio_test_uptodate(folio) ||
         folio_test_locked(folio)) {

The decoded oops matches this: "cmp $0xfffff000,%rax; ja" is IS_ERR(),
followed by "mov (%rax),%rax; test $4,%al" which is folio->flags /
folio_test_uptodate() with RAX = 0.

As far as I can tell, in 6.1.y __filemap_get_folio() still returns NULL on
failure/miss; the conversion to ERR_PTR() came in a later release (I believe
6.3). If so, the backport relies on semantics that do not exist in 6.1:
   - fast path (FGP_ACCESSED, no FGP_CREAT): NULL on cache miss ->
     IS_ERR(NULL) is false -> folio_test_uptodate(NULL) -> oops;
   - slow path (FGP_CREAT) on allocation failure: NULL -> PTR_ERR(NULL) 
is 0,
     so ret = 0 and the function continues with a NULL folio;
   - ext4_mb_get_buddy_page_lock(): IS_ERR(NULL) false -> folio->mapping
     dereferenced.

I verified the 6.1.192 source of __filemap_get_folio() returns NULL:
<yes/no - please check with: grep -n -A70 '^struct folio 
\*__filemap_get_folio' mm/filemap.c>

Possible fix (UNTESTED unless noted below): either handle NULL explicitly at
all six __filemap_get_folio() call sites in mballoc.c, or add a small
wrapper that maps NULL to ERR_PTR(-ENOMEM) so the rest of the backported
code works as written:

     static struct folio *ext4_mb_get_folio(struct address_space *mapping,
                     pgoff_t index, int fgp, gfp_t gfp)
     {
             struct folio *folio = __filemap_get_folio(mapping, index, 
fgp, gfp);

             return folio ? folio : ERR_PTR(-ENOMEM);
     }

(fgp is plain int in 6.1; fgf_t does not exist there.) For the fast-path
lookup, -ENOMEM simply falls through to the FGP_CREAT slow path.
<Tested with this wrapper: yes/no, result: ...>

Please let me know what other information would help (full .config,
tests on 6.1.191, etc.).

Thanks,
Safe-Lock.NET Dawid Partyka

-- 
Safe-Lock.NET - Dawid Partyka
ul. Zebrzydowicka 137
44-217 Rybnik
NIP: PL6422786434, REGON: 276286525

tel     +48 694 590 047
serwis: +48 784 947 278

