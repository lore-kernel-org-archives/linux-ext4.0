Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AD21632DD
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 11:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776771176; cv=pass; b=K7eFRsqN7G4zWlsoNJAq0nW0NpoxuqQ0w12KQKLQAdVKOGr5oFH+QoY0uZyKEU9NvS308lCOAW5zIgPTqS+fcPW/hH9ZoRBAXnxrk75UFK+mNnoVZmKv1CSJ2n0NtxnmIFJDBieCdCl2WtDD38jIDV6AXwOnpjjIzlrMsaNENx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776771176; c=relaxed/simple;
	bh=O5uaamRUmyuJEEJp1DE1/sjlVRrEIWTRjNg2WBDfiWI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YZjC0zbvBcdTyIceB7mWB3+F3bdQvYTHhavLFG/4RfDbD6P8NZXt+25Tp8opaBqva0bE5hSG/If5RvXEDc4uE9NMnxPFjYzcDHVVyfvcjVjK0fuPBtj3QyKDQBPIWqfgYOpaB2DC1VNIZ8Oo0hbvo6oql7o9T/z3QDDeav4EovI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esdWbHVG; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esdWbHVG"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36146ae9dd4so3106657a91.3
        for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 04:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776771175; cv=none;
        d=google.com; s=arc-20240605;
        b=fTsjTwNBIt/IH+YbjDsGJfY1jx1rV9/orNj7Mfws7uCUJukAKbKQadVy0GoM2DSE8E
         c2Tz/17Zq/fgYxOJAjZ3HtX+RmPyURaNTCXTw4VArKPa1jO1CyFjdRcLvb06DpLFhsrJ
         eFAB57g970fNOQ4QmNHS0okx3s6HR3WqJGUmOzyeLi9j/R/KeOIjjGosGF924RuQvWWa
         Z8o4uq45NY1/dY9JQv7MO0PSUpTPCwBJQbJgZglfl5hmRtihgvo2GHcOMoONb9BrZvHU
         3hg3hR3QLFH5OvVbZwQz9fjkwCv6eobfGDkYJ5DlRJXSRSBWNJn+F3wV766pyJH37qC2
         bZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=O5uaamRUmyuJEEJp1DE1/sjlVRrEIWTRjNg2WBDfiWI=;
        fh=Wu8bOl8ubfAB5NPFlO9J0KH5WRefa6dbropD9TRpJO8=;
        b=BsGLmO+tDa/06eMHasDC2EbkarBerlk49RyKiMdzXDEuzXnxM1+a1ZVRxSnUrmKSvi
         Ex1fXgoxb+L+Y9W8LpT+zx9BkpXzGNLmWCpOnmJv6GL/f98jUsW4N1w0xJAkCFXOE0JA
         ZXkjAKz2hem4fl4fKhzUOB4moTvS0/CDaGyL5B93kj1pW5BXycORXDy7PGi7EcYmlZnS
         /Xm7+PMRPoVd+0qU+uK+KhRhr0GMyKWmYD0725ErYZMrIUVoknjpfUgPnRc4wjOMvHLi
         R6D0uuqEla10YI4gIzFuwQ614pfsyP7MIu/iprouKtVCw5t2GvXJW9IdixZvLtVILoHr
         IhFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776771175; x=1777375975; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O5uaamRUmyuJEEJp1DE1/sjlVRrEIWTRjNg2WBDfiWI=;
        b=esdWbHVGl9bayQx0OxLRAiknYDYZ8qCN2Nk0yrpAISyeMbSTPPfsMFCLnN7yT7naoF
         xqn0qHjAGDcnKhdt0yRlcwDLdJVVsNvFt9ldfxmRTBQTCB7b8l4WCRT3gXTzs7/KoG7K
         k2DVPA5qjaR/K905sQN2HL870u2OHaEvUjo9+Cf5GkR2KZjUP23Q/meQNslK6Yondbkd
         EAig3ehGuSlKZHJPc14dmfOHxc2+j0FVjw51udhixFTeIR0Hv9M+cGRLhp1PH0ox3rjF
         mBeoqy9F8J7BXXJdUasmYIL6dQ70Qb+72QOLFj550i+xYRwMSyvSx5/WcJTFVaLbl3Pi
         v/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776771175; x=1777375975;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5uaamRUmyuJEEJp1DE1/sjlVRrEIWTRjNg2WBDfiWI=;
        b=bzQYCpq4xdFu4xWyuikHknhVBsrmFwNBoroAh2+jqjiyZawtSx7B/mSCafwhTZ5vp1
         juy7APZtrBaoxc47ylqB2NXddjDoky0E0s5kYE1GR7aYyV1Spjo/thgaAtScl0JY97Yx
         t2OyWJ2gZSxl4ZUNCVZO0Azex1hWwm/vzSlGwqF1FWNwU/DVrwrcXHj2BRvYXdTiX+HQ
         eNJHL845YwitTIwp3fHrhjLazttc7l1TkqX6bySMK7u/AY0TXtkGB+rM/3PG0sL3p2xU
         2AZGAHPzBwcfCeoEWiDYuiwFv4pL2pawkTSzx2UTWgTaBAak0/7L5e5LoYX8vXwFKLlD
         8RPA==
X-Forwarded-Encrypted: i=1; AFNElJ9aiHxi7jUlhXQ/cPoY7IqIP1DidPzcKzeq3rEdGMY3wviHm0pNo0pfX52n+eGx5l5d1EYUIzZVXxAH@vger.kernel.org
X-Gm-Message-State: AOJu0YzjSOAb2qyz4jiFb+/TA6ZxX/gRYZlv4eBevZF8iahADGhO2Ncv
	7LNILWzcp55vcKXDDHWieMci+UskJ8ndl+r8axiWU99fRZrE5SmsKACS9dYy2FzYlw+nB9ySaNE
	B+RJSR1/xK8pj4t9mjRkALoYOcECPue0=
X-Gm-Gg: AeBDiet0H42ifjO1l971FwrUzG+iiUSblp6dSrzZcbY2MXDIMUg5smJE8Fcy+qCamZ/
	5P8ULrZMp6ooHAKD/OfZ13Vuem+2VP4F+i3W4dENZ0GLxPsW+odMDRijxWlVC17qXioWtWMRoNO
	Kih0ky7nArcnvTv8HzoDwkzGmUs3uVCPfT74xbnwPWCGFEs1A8rzDuR4qZPzNV2khIC+uA7l9zZ
	9XKzbm7chduslTxP1U4XbltYLvoo1BRbxmcilVBQQnWZHd94CYLizSERD7dN1meC70RWzqH8G3F
	C6Xnd3ytLCIH4WKveA==
X-Received: by 2002:a17:90b:5107:b0:35f:b870:9c9f with SMTP id
 98e67ed59e1d1-361403f09e9mr17524141a91.12.1776771174624; Tue, 21 Apr 2026
 04:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zw Tang <shicenci@gmail.com>
Date: Tue, 21 Apr 2026 19:32:43 +0800
X-Gm-Features: AQROBzDWJ5grn8TBnVAm-zcDcOu60SSAuTAR9bmtBP5FVlU4texznDx_ooYATZ0
Message-ID: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
Subject: [BUG] ext4: BUG_ON in ext4_write_inline_data (fs/ext4/inline.c:240)
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, libaokun@linux.alibaba.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a kernel BUG in ext4 triggered by a syzkaller reproducer on
Linux 7.0.0-08391-g1d51b370a0f8.

The first fatal issue happens in the ext4 inline data write path:
sendfile64 -> ext4_file_write_iter -> ext4_da_write_end ->
ext4_write_inline_data_end -> ext4_write_inline_data.

The crash is reported as:

kernel BUG at fs/ext4/inline.c:240

and RIP points to:

ext4_write_inline_data+0x3d0/0x490

This looks like an ext4 inline-data boundary/state inconsistency triggered
while writing to an ext4 image crafted by syzkaller. The later
KASAN: slab-use-after-free in rwsem_down_write_slowpath() appears to be a
secondary effect after the primary ext4 BUG, likely during teardown/unlink
after the filesystem failure.

Reproducer:
C reproducer: pastebin.com/raw/3LmK5Kxg
console output: pastebin.com/raw/C0XjNMXp
kernel config: pastebin.com/raw/aq1V3cLk

Kernel:
HEAD commit:
git tree: <e.g. torvalds/linux>
kernel version: 7.0.0-08391-g1d51b370a0f8 #1 PREEMPT(lazy) (QEMU)

Relevant log:

[ 1329.147750] kernel BUG at fs/ext4/inline.c:240!
[ 1329.148692] Oops: invalid opcode: 0000 [#1] SMP KASAN
[ 1329.149543] CPU: 0 UID: 0 PID: 334 Comm: repro1 Tainted: G W
7.0.0-08391-g1d51b370a0f8 #1 PREEMPT(lazy)
[ 1329.153249] RIP: 0010+0x3d0/0x490
[ 1329.167978] ext4_write_inline_data_end+0x293/0xc90
[ 1329.170566] ext4_da_write_end+0x521/0xec0
[ 1329.176842] ext4_buffered_write_iter+0x11a/0x430
[ 1329.177610] ext4_file_write_iter+0x561/0x1840
[ 1329.185052] iter_file_splice_write+0xa33/0x11c0
[ 1329.190820] direct_splice_actor+0x18f/0x7a0
[ 1329.198893] do_splice_direct+0x41/0x50
[ 1329.200276] do_sendfile+0xa86/0xda0
[ 1329.203110] __x64_sys_sendfile64+0x1cf/0x210

There is also an ext4 metadata inconsistency message right after the BUG:

[ 1329.221770] EXT4-fs error (device loop1):
ext4_mb_generate_buddy:1314: group 0, block bitmap and bg descriptor
inconsistent: 25 vs 150994969 free clusters

and later a secondary report:

[ 1329.274881] BUG: KASAN: slab-use-after-free in
rwsem_down_write_slowpath+0x15e9/0x1640

Based on the log, I believe the primary issue to investigate is the BUG in
fs/ext4/inline.c, while the later rwsem report is probably fallout after
the ext4 failure.

Please let me know if more information is needed.

Thanks.
