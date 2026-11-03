Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716839;
	b=tn+Nz7+nHCv1fuS7Ccj2OPxPD/CufWFef2OzfdB6t2H2OTgCwaeZh4NRCXXUHps41IBe
	 nUq5NS8MojZy8CvfzpZLSZAlRT51E8K5WOKiG+VAFFg9fSfTKmPhMRB5PBPcY0hRbxX47
	 D7kAsNDSGo8UCs0ddsGCR5+el52m6TUcoh1ON7+G/FlB7jamjLHhhuu8WgDBMigy5xC/m
	 jZGiYTlludaGEICfWkQSQa7B8p7RcD58INObHLmNVVmUAeKmdWrS9kOopiPQZrkezNUwu
	 lK6uXFqK5rlxJwEyDZWsosAJK6+GyIURR/LCR8QRju/nrWSPp684ApFJX/UJcPhJ8xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716839;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:Date:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=ItYNDLcZ9yyLcy/hXS85fqljtT4mPR58lFpMoT2D7l8=;
	b=oYJpwtUAdZtxba1S0avn1EgqMSGaJkYHILuCje7sHkJCDPuLqrbqJ4MHlcxEykPGuIfL
	 Ki1WjQAkDYhObgGGpl1KflVqyTg02/GXa1DwHAUhKx2vd/zcNr30AVYBcu6x71ZeYAbfE
	 iOiBm1RR0oMf/krK52IC0hi3DpEXUB0awHvAPw9ebvEQ5Gi6ys6QgyHvOvXTxXWCEhKZt
	 Sap9ZQkcVtt8PdJLNk6nYxiWFP/+QbFz7evfUivbnzFC6CDjylO/i1ou6OxeSvKYRT/2s
	 LjRltWtqMGSmUJjgGxIC9LNTSdbrjDILftAi4wRFQaAJyLEKKZ+1h/svRtEr5jkzaIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=IHBf7pTZ;
	arc=none smtp.remote-ip=162.62.57.87
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25306606A332;
	Tue,  3 Nov 2026 14:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25306606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=IHBf7pTZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793716827; bh=ItYNDLcZ9yyLcy/hXS85fqljtT4mPR58lFpMoT2D7l8=;
	h=From:To:Cc:Subject:Date;
	b=IHBf7pTZIAdMWDMlBrvMopiBrNyjOBuyoj0a2n5YSk3yTXDBKYXC3B6HaPLOgwg4I
	 WQIBzXjB2EJV1gN9fcx0mICaV6SVEzRJAvGXD6YMBWJ2hrggniRbTggu4Z8980TiWh
	 Ufy9Jqg6pXGIRigASs114zQSxdwjmhb57wsvLU+U=
Received: from [172.18.4.77] ([61.136.26.103])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id A192EC89; Tue, 03 Nov 2026 22:40:25 +0800
X-QQ-mid: xmsmtpt1793716825t72dwuopa
Message-ID: <tencent_A7CF569440AAFAB7D1C884939CE941149706@qq.com>
X-QQ-XMAILINFO: OPDQNGCUQ3qLv0zQ8kmj3wG0NgkoW2KbsLHfbkV9zN8dgc6GPDDpA6L0dljvUS
	 yU2Q7UeCOm3dAonrc+QhAtVnMrGyn61ka/LeoDpxIUyh+cQ68dxPGcpRqHoMMAkG2/L5171zJcoX
	 1Szeug50bt/9pd0YbdW0AbtEabPOY8Q+QNkpHEVfwBW7RenOjQXYU10DQleTcvd5f8zPDoWeVAUy
	 I2eKH1GyyS1ou8RQiQMQ7v/9AyYs2qoQHGVPvfTgtUPAopLhfwfrZcNVNeQOUQSJ9sQVRNlC+BJY
	 4996C2sHeIQnopKuFVE30P56HME6OAOkHHFg1RAk0uoIsLzjCqfPAUF5qIIPW6j5oA75PNQHSLXe
	 g5/chWaoTA06H/4Mh6fapfhdLNbca28iQpctFZiaH/6K+PXfBIF41zk4sdY2Xi4r4YUc7cQ8Q/lk
	 +K1mJYi+OLFAsuCutQt4cHS/JkwuTKneiBr0mc8QIgAORcpXUxng9om1aodFDJXwxfx7Ri200sJq
	 xvxVTmR0/xX7bibOarCU4UEW6d96IQaDl8mmJH27FLXj+BbKuG6bGC6DFBrzQYi+Q+uN51AU/lsi
	 isE6HK8I4Y3PUE5OdOb/+u+AtWfWUtfKr6IHdte4M75J8ixjSDj8sFdz8u3LM+ktI2rj3jKTP816
	 TtTB+xZDHrQ4OJ2OzdBqVDPEZrQrJpyA9PSs1e1fUyuZeTBam5iUjFKVWLf8H9GOVVElbL6Pdfah
	 LwrEYxNav7/sbmY+d1WM+LptLU7wp2nWIICDAGNdDY7fOmWAcrUgfW/pmaIRpsnjQgqQL/urP8wW
	 kiNVsGcy7u8H8VlF4niEBeZAk9ogBv3cx66k91i/BS3LtbEwmcHr2lRydIfHZQNWGUotYJ6idLvJ
	 DXdx4xhQj8kRdEECnE/28bJAOroMjpIOfjw24X7Xv3aFrrF6bRU+YmCmhTu0eTf6+wY62dOzrLCF
	 C0GZdC77Fbo0jbX5/+9wT7JptpYT015LrI0ST6tPQkUj90OiX9DE41ZWzH3txZkiu4GWq3UnVXuU
	 WONEBTpx9nvODDQtw/bKFIgt4ggnIZcNjuVBWhMqXJjoLxFipp0lJ6pEWTEi47vZIeA0dYXg==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Guikun Yang <yangguikun19@qq.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
 Zhang Yi <yi.zhang@huawei.com>
Subject: [Bug report] ext4: journal replay overwrites the validated
 superblock, casefold feature bit set after s_encoding decision ->
 null-ptr-deref in utf8_casefold
X-OQ-MSGID: <c15-ext4-replay-casefold-null-20261103@qq.com>
Date: Tue, 03 Nov 2026 12:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

Mounting a crafted ext4 image with metadata_csum and a journal checksum
enabled ends in a general protection fault during a later lookup. The
chain is that journal replay overwrites the superblock after
ext4_fill_super() has already made a decision based on the previous
contents, so the two ends of the mount path disagree about the casefold
feature.

  general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  RIP: 0010:utf8nlookup+0x38/0x890
  Call Trace:
   utf8byte+0x1c0/0x1320
   utf8_casefold+0x161/0x230
   ext4_fname_setup_ci_filename+0x17f/0x4d0
   ext4_lookup+0x161/0x710
   __lookup_slow+0x156/0x320

RBX is 0 (the unicode_map) and RDI is 0x18 (&um->tables), so
utf8_casefold() was called with a NULL sb->s_encoding.

## The chain

1. ext4_encoding_init() (super.c:5468) runs before
   ext4_load_and_init_journal() (super.c:5576). With no casefold
   feature in the on-disk superblock it returns early and
   sb->s_encoding stays NULL.

2. ext4_check_blockref() has an exemption for the journal inode
   (block_validity.c:356):

       if (journal && inode == journal->j_inode)
               return 0;

   so the journal inode's extent can point at any free blocks without
   failing the block reference walk.

3. A dirty journal is constructed in those free blocks whose single
   data block is a copy of block 0 with the CASEFOLD incompatible
   feature bit set. Every checksum is recomputed: the superblock
   checksum, the journal superblock checksum, the block tag checksum
   and the commit block checksum, plus the inode checksums of the
   journal inode and the target directory. Nothing on disk is invalid.

4. On mount, jbd2 replay writes that block back to block 0 via
   __getblk(journal->j_fs_dev, ...) + memcpy (recovery.c:551). The
   in-memory ext4_super_block now advertises casefold, but
   ext4_encoding_init() has already run and sb->s_encoding is still
   NULL.

5. ext4_iget() rejects a casefold flag without the casefold feature
   (inode.c:6568). The root inode is read before replay and would
   fail, so the flag is placed on a subdirectory instead; its inode is
   only read on first lookup, after replay has set the feature bit in
   memory, and the check passes.

6. Any lookup inside that directory takes ext4_fname_setup_ci_filename
   (namei.c:1370), which checks IS_CASEFOLD(dir) - an inode flag,
   independent of the feature bit - and calls
   utf8_casefold(dir->i_sb->s_encoding, ...) with NULL.

## Observed

Deterministic, 3/3 on a QEMU x86_64 kernel with KASAN. The trigger is
two syscalls after the image is built:

  mount("/dev/vda", "/mnt", "ext4", 0, NULL);
  stat("/mnt/d1/nonexistent", &st);      /* GPF here */

Reproducer notes that matter for reproduction:

  - The superblock must have NEEDS_RECOVERY set, otherwise
    ext4_load_journal() calls jbd2_journal_wipe() before
    jbd2_journal_load() and the crafted journal is discarded.
  - The casefold flag cannot go on the root inode; ext4_iget() rejects
    it during mount because the feature bit is not visible yet.

## The larger issue

The crash is one consequence of a more general property: replay writes
into the page cache of blocks that ext4_fill_super() has already
read, checksummed and acted on. s_checksum verifies the on-disk
contents before replay, not after, and ext4_encoding_init() is one of
several decisions made from the pre-replay superblock. Anything read
from the superblock before ext4_load_and_init_journal() and still used
after it is a candidate for the same disagreement.

The reproducer (image builder with checksum recomputation, forged
journal builder, ready-made image and crash log) is available on
request.

Tested on 7.3.0 with CONFIG_UNICODE; the ordering of
ext4_encoding_init() and ext4_load_and_init_journal() and the NULL
use in namei.c are unchanged in current mainline.

Thanks,
Guikun Yang

