Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821480;
	b=BUXKV1tVMU9KOJshpidAB3Vd3TKyosArUrtIW4jEXF6NMW+ctBHruvPFZcNMcZq9OkzD
	 BUbmWG2Hu7TXKb0Jb6HOY2LzPup6MznYDO9dL4iX0WGBfR3JsqA2/qSLBT2CoyZ88qbxr
	 Dyu2ze0rXv1dQQ+MUiB+glIsVDydjM4ZgbEQsLKQhMkaU9PutK458KqhlqF7JVjuE3LJu
	 YE7a4YXeKx41VwqjyjIeZmtmIirF1tcpUUtwNM5uTJWAlBLQiHdCaNdLRMuk1shSlXiyW
	 MvpH+RapyF4bIb/oImekfZ4U/zeIrvUXHLkRBLRYsT5bhWBoEjGJXd4Gy5zBdK18zIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821480;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:Subject:Content-Type:
	 Content-Transfer-Encoding;
	bh=SZMO+K4nb7HFDWV9r/yGO5C8vBQcAVEMtJaC8F6M0Z8=;
	b=Dgo8R2+WyomNcquXiD8grVMo0iKaSfU/cr5OgyxvLmE0SQ4wshfGExvQ4YWnlxhMocSS
	 sfONL1zDLY9epm/1MVQnDTPnxFn954jrt32gH6YZ86lk9hVFmijb7rqAj+HY79G5zbv9N
	 VDIyMA3v+jnmhCOVEvrgNwbEN/ZChmSC2mx89CmTChhddM2QmJPyvmTPvpxR58KdJVtoP
	 9LW1M8s32l9QBC9nzXcL+RH4h61FrM5o+y681JpqeMu535EjnMY2Y0MMY9ZPe5r5VVU5U
	 amc5fV5fJLKH3Oja82V8zKO8jQcUMZiKdfSj+N/wPhnhQCq0k7cpaHaOrB3q5a2Jx1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tiukov.com;
	spf=pass smtp.mailfrom=tiukov.com;
	dkim=pass header.d=tiukov.com header.i=@tiukov.com header.a=rsa-sha256 header.s=fm2 header.b=IAh+IvHV;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=SFpLVnxq;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C77606A323
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 09:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63C77606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tiukov.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tiukov.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tiukov.com header.i=@tiukov.com header.a=rsa-sha256 header.s=fm2 header.b=IAh+IvHV;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=SFpLVnxq
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 84BA47A0013
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 04:31:18 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-09.internal (MEProxy); Mon, 16 Nov 2026 04:31:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tiukov.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1794821477; x=1794907877; bh=SZ
	MO+K4nb7HFDWV9r/yGO5C8vBQcAVEMtJaC8F6M0Z8=; b=IAh+IvHVTB/A/Uk3tE
	dwNLlvOReoARKW8EcCMKYyncDKvP3uK8YnvIhjo5/tAoCjjpt/OGNr4UMH30MwhT
	zg15b5nASHZLV1YgQDpPw7m9PeMxOzvuYz7Cte1kZjTgGqkpIwNf7arJ7H5/FKHG
	OBkJ1hxkYfFdhlxiMwX7UwQ9xQgHF1r1iHtl21aARSyXeLKnh8Jf7e9yzUQ36T/1
	V/Cn6+IgQOHwOgNVjzhRygbONgWnk+WaeAqllgQArCiKcktdR91siasb+p3HrIZh
	z5IEEgw/ykTZ5zGXQDB0R5Jk3oUEs2F6bGwYDG5e6YCO2CU0+AoCGdFeUk35rDVQ
	z8GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1794821477; x=1794907877; bh=SZMO+K4nb7HFDWV9r/yGO5C8vBQc
	AVEMtJaC8F6M0Z8=; b=SFpLVnxqH0HCU9iAKymzPZCudr8Bu58pHWPEZEbE033j
	OZo4/YDbcAMsrEnPCtg5mkQUMq+6n0veh6NYr6QRS5BwyO0GhHkc7d8f/kfWaGwl
	TOYG6iyBigRM8jX1zKNR1sQ9Cjx9W2f6LjT6wrNpxi6uIgk8BJtK+x6qKOCQ3w0j
	ByWCLt0Tdk4L507hc3TMgHXvUYCltdDPJdl8sguNyBZ4uMbMyIhUXKaCZjp3sn98
	VgV3wzETpUhc0W9589HHZO9bSPNSLT2wN0AClAcikJsI6OMUGbsLj4Uw8U8rkJtc
	nXxDpnOBYskqdsSoffRms0tlWyF4LnkwCh2Zep3iZg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=tiukov.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794821477; d=tiukov.com;
	mf=PGl2YW5AdGl1a292LmNvbT4=;
	rt=PGxpbnV4LWV4dDRAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:N4R8ZXWKG7HpkdyQCC3bjWRsNO6Gu4aCWhRfCLVx03ngyUO
	ayQkd5N3m0pxQ5eKivGiycyZHyywkNHnYtBec/VMudvA6n5qSpo7Wec9PjNeXTI8
	Cluo6UoWl4nJZFm/0VWI56IwfnE0Rn7wXRhAvKZxs9PjLk3diSqM36BiRQfW/LwF
	8uvh1CBLiHT9znBqcskWBou+rzo6+MSa88Ty9sOdziZn3zxCP+HRAUjSgUqBPkQH
	a9bqUqnNDbpTTCMuetbFYx7jJJh29ukzRxVnARM1ii5vi7x3CF4ggAboe95CNt8O
	a5YyXTa3t7fMNCEf5Czitq4f6t4qZcKYYEv5MLQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:dis56LSwZsW2NsxyFUFazZOEJv0s0eYQxJkyqS795iQ=:QonS9ZldPhS2lrtUv56ngGFzPIABKkrWUmEKRgsosB4=;
X-ME-Sender: <xms:Zc36alSRqFcUFJugf9Ls2Bz4AfxvZUGI4BgYJDnK-a6W-Ei0I0kJPg>
    <xme:Zc36apksVnLsRXAFRnejd8moOCBsHvSL2hmd-SuFtc2KrdJwUvyo9OnMSSfIjAlC_
    Bm7AqxmqEiGYD_4GCSvDJQa3rHiB_3-trM8zJ0W1oOBg0lcqDwcssU>
X-ME-Proxy-Cause: dmFkZTGXSJGBWNgfZ8JnSomSi6fs+ioeyaky7BrB3lzR9xt6PsgiobQOpIkWrT6qZWwFF2
    K97YwyZ/PrPG9GLZkrcf9QAIkkYtISYacS3dbR2TDaxp3bRemGHfWBnnKp1bC37AuuIMNO
    jKZbOuZ/vTlNI0IPMkknQD09PUEdtfIlTYWGybt8IMLTMfnupzvQmwcMHlwALAC/Qb1roT
    tvOEu4TooxsHNTEJih4trN2q1bgq1wkbv8HHO/AgrQJRQ9YsYCjAGIemjKJW9P2/ClDYvQ
    TIhTme5awrGLEV3X4XrDoNaKFHkQwxTQvxJzo6MQha5E8cI0S7q5l8awtOcmpztacFQNok
    wVXFoc6RKQH0HGgkSHd93LIlBL9tq8o0LHyRC4nw5v0JiiYICLvetAOwpJUu8eM5pxpZoK
    XRKwiCnvCdElTKd/zvPpC4ACJj5mAgrzfG5bSFbev+5do9XZYNgvl/nvB7wCy+5ZCm+gSt
    SbVS2IMsUZp9YT5BG0SicGTBLsPPu+YdgG7QV84N7GYpHtGpShSOAbOIAxlON+OJKXal9A
    1Y713lfBpo0mDJ2Aztz7BAsjn+8y7dc4+YQFh0fXZJcp4cbwa8kiqEClecXb7vs99h1W1v
    DuIEHPqsEWgatkl8XW+OkZilFmdC2bTzguMcvQwHbWhikItD9xwYMepZCyUg
X-ME-Proxy: <xmx:Zc36aq4KLR0omtS1bLfrfyvhahvp6qeOkZKO3f3HKyCpvjoJ1ggRYQ>
    <xmx:Zc36at8_e_LtMj6wWTbnQBjkRGplCQ3DpGdRuqBWDt5A_VGQdHWSFA>
    <xmx:Zc36apXnSrFXvhunow3mjUFH_w0F_CxqUAh6F5PuC2dsifRYuPSPEA>
    <xmx:Zc36aopzuQreBGgZaNHuen9AW9TivEMOWBp_pgM0nCbPKtF6nN4Jkw>
    <xmx:Zc36avCxHEGoVJ6KS8t1RMnEvn69lXEftbl9WNh08KXGZPVqGl27hXZ1>
Feedback-ID: i1ce0434e:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 204CA780070; Mon, 16 Nov 2026 04:31:17 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 16 Nov 2026 11:30:56 +0200
From: "Ivan Tiukov" <ivan@tiukov.com>
To: linux-ext4@vger.kernel.org
Cc: stable@vger.kernel.org, tytso@mit.edu, jack@suse.cz, adilger@dilger.ca,
 dan.carpenter@linaro.org, willy@infradead.org
Message-Id: <ef745013-2ea2-4e2d-86be-ac3e4a9d0cba@app.fastmail.com>
Subject: [BUG] ext4: NULL deref in ext4_mb_load_buddy_gfp() on 6.1.y
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

Linux 6.1.y panics in ext4 under heavy unlink/truncate load. I believe this
is a stable-only regression from the mballoc folio conversion in 6.1.191:
the converted code assumes __filemap_get_folio() returns an ERR_PTR when it
cannot hand out a folio, but 6.1.y still returns a plain NULL, so the NULL
check that IS_ERR() is supposed to provide is not there.

The crash reproduced three times on one host within eight hours; the trace
below is from the third one, captured over netconsole because the machine
went down before journald could persist anything.


= Crash
--------

Kernel: 6.1.192-1 (Debian 6.1.0-55-amd64), x86_64, 4 vCPU KVM guest, 8 GB.
Process: rpmsign, doing unlink() of large RPM files on ext4 root.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 3 PID: 12736 Comm: rpmsign Not tainted 6.1.0-55-amd64 #1 Debian 6.1.192-1
  Hardware name: Red Hat KVM, BIOS 1.16.0-4.module_el8.9.0+3659+9c8643f3 04/01/2014
  RIP: 0010:ext4_mb_load_buddy_gfp+0xbc/0x380 [ext4]
  Code: 89 44 24 08 f7 3c 24 48 63 d8 89 54 24 0c ba 01 00 00 00 48 89 de
        e8 d3 6e ff f2 49 89 c7 48 3d 00 f0 ff ff 0f 87 28 01 00 00 <48>
        8b 00 a8 04 0f 84 12 01 00 00 49 8b 07 a8 01 0f 85 07 01 00 00
  RSP: 0018:ffffd065089bfae8 EFLAGS: 00010207
  RAX: 0000000000000000 RBX: 000000000000004c RCX: 0000000000000003
  RDX: 000000000000000c RSI: ffff8ecec175f908 RDI: ffff8ecdd505e000
  RBP: ffff8ecee0983000 R08: ffff8ecec1582f70 R09: 0000000000000000
  R10: 0000000000000000 R11: ffff8ece2a13eff0 R12: ffffd065089bfb80
  R13: 0000000000008c40 R14: ffff8ecec0420a78 R15: 0000000000000000
  CR2: 0000000000000000 CR3: 00000000150b2000 CR4: 0000000000750ee0
  Call Trace:
   <TASK>
   ext4_free_blocks+0x410/0xbb0 [ext4]
   ext4_ext_remove_space+0x7ff/0x15d0 [ext4]
   ext4_ext_truncate+0xb4/0xd0 [ext4]
   ext4_truncate+0x314/0x490 [ext4]
   ? __ext4_journal_start_sb+0x105/0x120 [ext4]
   ext4_evict_inode+0x2f8/0x710 [ext4]
   evict+0x112/0x2c0
   do_unlinkat+0x173/0x320
   __x64_sys_unlink+0x3e/0x70
   do_syscall_64+0x5d/0xb0
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8
   </TASK>
  Kernel panic - not syncing: Fatal exception


= Analysis
----------

The faulting instruction is in the fast path of ext4_mb_load_buddy_gfp():

  folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
  if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {

No FGP_CREAT is passed, so when the folio is not in the page cache
__filemap_get_folio() reaches no_page: and, on 6.1.y, simply does
"return folio;" with folio == NULL.

  IS_ERR(NULL) is false, so the guard falls through to
  folio_test_locked(folio), which dereferences NULL.

RAX == 0 at the fault and CR2 == 0 confirm the returned value was NULL. I
also disassembled the shipped ext4.ko to make sure this is the code being
executed:

  315c8: call  __filemap_get_folio
  315cd: mov   %rax,%r15
  315d0: cmp   $0xfffffffffffff000,%rax    # IS_ERR() only
  315d6: ja    <slow path>
  315dc: mov   (%rax),%rax                 # +0xbc, faults with RAX == NULL

There is no NULL test anywhere between the call and the dereference.

Commit a8d83471c560 ("ext4: fix error pointer dereference in
ext4_mb_load_buddy_gfp()") added the IS_ERR() checks. That is correct for
mainline, where __filemap_get_folio() returns ERR_PTR(-ENOENT), but it does
not cover 6.1.y, where the function returns NULL for the same situation.


= Why this is 6.1.y only
-------------------------

__filemap_get_folio() changed its no-folio convention in v6.4:

  66dabbb65d67  mm: return an ERR_PTR from __filemap_get_folio
  38a55db9877c  filemap: Handle error return from __filemap_get_folio()

That change is a semantics change for every caller, so it was never a
stable candidate and 6.1.y does not have it. What 6.1.y did get, in
6.1.191, is the ext4 side of the folio conversion (862483175d3d, d34e4fd4e73f
and the a8d83471c560 follow-up), which was written against the post-6.4
semantics.

I checked the tree heads:

  branch         ext4 guard               __filemap_get_folio   result
  linux-6.6.y    IS_ERR(folio) || ...     ERR_PTR(-ENOENT)      ok
  linux-6.12.y   IS_ERR(folio) || ...     ERR_PTR(-ENOENT)      ok
  linux-6.1.y    IS_ERR(folio) || ...     NULL                  NULL deref

So 6.1.y is the only affected stable branch, and it stays broken in 6.1.192
and in linux-6.1.y HEAD. 5.15.y still uses find_get_page_flags() here and is
not affected.


= Minor: a second latent site in the same file
-----------------------------------------------

ext4_mb_get_buddy_page_lock() has the same assumption:

  folio = __filemap_get_folio(inode->i_mapping, pnum,
                  FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
  if (IS_ERR(folio))
          return PTR_ERR(folio);
  BUG_ON(folio->mapping != inode->i_mapping);

Here NULL does come back from FGP_CREAT when the allocation fails, and
PTR_ERR(NULL) is 0, so the function reports success and then dereferences
NULL in BUG_ON(). Same root cause, different symptom. I folded it into the
patch below.

No other file under fs/ext4/ calls __filemap_get_folio() in 6.1.192, so
mballoc.c is the whole surface.


= Proposed fix (against 6.1.192)
---------------------------------

Use IS_ERR_OR_NULL() and translate NULL into -ENOMEM. This keeps working
unchanged if 6.1.y ever picks up the ERR_PTR() semantics, and it is a no-op
for mainline.

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1375,8 +1375,8 @@ static int ext4_mb_get_buddy_page_lock(s
 	poff = block % blocks_per_page;
 	folio = __filemap_get_folio(inode->i_mapping, pnum,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (IS_ERR_OR_NULL(folio))
+		return folio ? PTR_ERR(folio) : -ENOMEM;
 	BUG_ON(folio->mapping != inode->i_mapping);
 	e4b->bd_bitmap_folio = folio;
 	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
@@ -1389,8 +1389,8 @@ static int ext4_mb_get_buddy_page_lock(s
 	/* blocks_per_page == 1, hence we need another page for the buddy */
 	folio = __filemap_get_folio(inode->i_mapping, block + 1,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (IS_ERR_OR_NULL(folio))
+		return folio ? PTR_ERR(folio) : -ENOMEM;
 	BUG_ON(folio->mapping != inode->i_mapping);
 	e4b->bd_buddy_folio = folio;
 	return 0;
@@ -1533,7 +1533,8 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+	if (IS_ERR_OR_NULL(folio) || !folio_test_uptodate(folio) ||
+	    folio_test_locked(folio)) {
 		/*
 		 * folio_test_locked is employed to detect ongoing folio
 		 * migrations, since concurrent migrations can lead to
@@ -1543,11 +1544,11 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 		 * try to get the folio with lock in both cases to avoid
 		 * concurrency.
 		 */
-		if (!IS_ERR(folio))
+		if (!IS_ERR_OR_NULL(folio))
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-		if (!IS_ERR(folio)) {
+		if (!IS_ERR_OR_NULL(folio)) {
 			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
 	"ext4: bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
@@ -1567,8 +1568,8 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 			folio_unlock(folio);
 		}
 	}
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	if (IS_ERR_OR_NULL(folio)) {
+		ret = folio ? PTR_ERR(folio) : -ENOMEM;
 		goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
@@ -1585,12 +1586,13 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 	poff = block % blocks_per_page;
 
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
-		if (!IS_ERR(folio))
+	if (IS_ERR_OR_NULL(folio) || !folio_test_uptodate(folio) ||
+	    folio_test_locked(folio)) {
+		if (!IS_ERR_OR_NULL(folio))
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-		if (!IS_ERR(folio)) {
+		if (!IS_ERR_OR_NULL(folio)) {
 			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
 	"ext4: buddy bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
@@ -1609,8 +1611,8 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 			folio_unlock(folio);
 		}
 	}
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	if (IS_ERR_OR_NULL(folio)) {
+		ret = folio ? PTR_ERR(folio) : -ENOMEM;
 		goto err;
 	}
 	if (!folio_test_uptodate(folio)) {


= Trigger and testing
----------------------

The window is narrow but not exotic: the block group must be initialised
while its buddy folio has been evicted from the page cache, and then any
free/alloc in that group takes the fast path with a cold folio. On this host
it happened under rm -rf of a large tree and under rpm --addsign of several
hundred MB of RPMs, both with the page cache under pressure.

I have not boot-tested a 6.1.y build with the patch applied. The diagnosis
itself is confirmed on the affected kernel: the oops, the NULL in RAX/CR2,
and the disassembly of the shipped module. I am happy to build and run a
patched 6.1.y if that helps; the host is available for retesting.

Workaround for anyone hitting this: stay on 6.1.190 or earlier until 6.1.y
carries a fix, or run 6.6.y/6.12.y.

-- 
Ivan Tiukov (www.tiukov.com)
