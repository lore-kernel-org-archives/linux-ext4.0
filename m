Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812F257845
	for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 22:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781389242; cv=none; b=dCMJMUgLMiR3EatFv7jLTunM245P56QkQyJ4/RQnnZtKd2M6CEiYNLIgo61ODn0zfv50qLOC45L6hpIUO5zkQ3Ee6LyM30BlOFbbXoD/4E+n96nT6vqSlOdZ+SlXF/3kJsxF3g6pF3b/6bKRjDyL6c67BlyePvbG1z4XZLLO7Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781389242; c=relaxed/simple;
	bh=airLqzG/L7e/wziP//7I+GC4eYKfQmDRXFoekkvGuI4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KlSzmsfn6zBAD5LG+K47IVfAlRt2tBmCFyHEM7ww2l0Nimto5/5MmkNsSMcxT7fJRsPLGgswukUzLNY/ZvRNR9/M3uv1HbC6gWjMgx2Yr7RIMlSG4PL3HxL6nlH4RHXLB52+r2QgA/u75G5z7Pyb4COKm6DZFu5WXtKNNOu2hN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=DKyxDFOt; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="DKyxDFOt"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36bcbd7821fso1045580a91.2
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 15:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781389240; x=1781994040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n66YruYocOh5knrDPtGgjglYitjlbKeUlxMM8lYrh5U=;
        b=DKyxDFOtbgDPE5lW+tRgcx8TZ/+kSSg6wUtKOCnbIFCgYHij+UyBQ2LZo94H/K4eB0
         SHk+U0RqOAMk7jmNivOE1uUqPk0DI3QtGkQry3YEnel9qOTP1ek2krzXwF+10pqYnHcc
         8ISnCWMC5Yiyb8rISDUBVGqNnbfWPczhx3riOAHbSiTbA10uY+VhUeeCheoj1jfQdOzo
         +dVAF4SzcbyLA4jVN0Ope6QC8dGk/SO8b7pppiOeMJSTECx9MiJlFAgfcPpyDzDvmQ+h
         XwyDQRg+6f7yldA93cZAd1ZSsu3BD0AraGnkX7sVsai8XpTJeoTw53stzdz9zlXq6sEV
         Y9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781389240; x=1781994040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n66YruYocOh5knrDPtGgjglYitjlbKeUlxMM8lYrh5U=;
        b=ELWx/0Hs8ULG+Rj2kY2MPOlKIUBsjesDPSk+Ou/st39DXEO3oeLy6XjUFOQIcjy2wm
         UqHrPgySosNmTnncnKwULWQV11cFgR1eB+gA7VLPJkJXjwo9GCuOvMHTzxMk6wG6wMID
         r43evltb8TbuJ664p/3W7ma5za6P2Eydnnk+9gFVlQ4zwRtBdOL2z7iLRUxtH0bG3ZeQ
         2k6Evjtt34Tp026gO3A25EoIZt5dvcJX9yVMTN7yww//ZXm48GhJDi+0bOfnoHgCNcFY
         EyfSOlEIlXseSMibpwAsUPGPRvu3Z3DH3GYxWCP3JnL/98FhfGknzNHcx8ZHlDYNioee
         H4Ig==
X-Gm-Message-State: AOJu0Yzc9OKJ+Mx5ty0uf3AVIYeCOdJsiJFPMJ8WQ4qM9Z/OE8L6EJp5
	xHRAUMCDmkEX8uASgOHrbzSUy6VdXruz3kNXwpQ2xIzakdkSLc91qmW8EPMf4r1kuyHCmiD3z1L
	Y7zb87S8h
X-Gm-Gg: Acq92OGmmNiKGVSuO3GVGMdxSKe2Q7LaoQTlJpDloB0Pz/fB/kzVgi7syxsyyqOJmZr
	VFSg6b+OFYzhPpdbRsiEiu6UEE2AHu8Evd4L3C+a4cM9UEuhBRFruGBhz5sBwDCU/X5FqnaC5uU
	cqCIQxev6rZIxjw8E6HMkF3f3v43/GpjvJZaBh0xrTvFb2scB7B9dK4EKHX1r6MM5P+aU9bD01z
	iFJnSZn5pZ8bH/T/9ADiaT/BBcH0pWg+3KweZjvO3MxaxHNTJCyAMHpjWycih046/S42/ozUC4x
	BWicJSC2FJgvEpOcBMxpLNzgDqykIcuDEFnTqSMUXKR0oikZ1o9N7McDlyxr+ZZXAQttUm9QhWw
	AxmorLvsmqxHh3LTDSs+e/x1pL1L407zeRG4rfme04/HBdN3LksrnaGSYuWTypr7F9Z23jmzmVe
	wtVBITa5bAXA==
X-Received: by 2002:a17:90b:2d48:b0:368:78da:803 with SMTP id 98e67ed59e1d1-37a038e556fmr8308182a91.12.1781389240277;
        Sat, 13 Jun 2026 15:20:40 -0700 (PDT)
Received: from p1.. ([172.56.108.175])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-379c3240b5esm3948090a91.0.2026.06.13.15.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:20:39 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH ext4 v3] ext4: fix out-of-bounds read in ext4_read_inline_dir()
Date: Sat, 13 Jun 2026 15:18:36 -0700
Message-ID: <20260613221836.556019-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_read_inline_dir() can read a dirent header past the end of its inline
buffer, triggering a slab-out-of-bounds read during getdents64():

  BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
  Read of size 2 at addr ffff88800f3dd23c by task exploit/148
   ...
   __ext4_check_dir_entry
   ext4_read_inline_dir
   iterate_dir

The dirent payload lives in a buffer of exactly inline_size bytes:

	dir_buf = kmalloc(inline_size, GFP_NOFS);

but iteration runs in a position space extra_offset bytes larger
(extra_size = extra_offset + inline_size) so the synthetic "." and ".."
land at their block-dir offsets. A dirent is formed at "dir_buf + pos -
extra_offset", yet the loop bound (ctx->pos < extra_size) and the
ext4_check_dir_entry() length argument both use the larger extra_size. A
ctx->pos that is valid in extra_size space but whose de lies past 
inline_size is therefore accepted, and the rescan loop's rec_len probe 
and ext4_check_dir_entry() dereference de->rec_len before the entry is
rejected.

Bound the dirent header by inline_size in both loops: break out of the
rescan loop once a minimum-size header no longer fits, reject such a
position in the main loop before forming de, and pass inline_size rather
than extra_size to ext4_check_dir_entry().

Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 fs/ext4/inline.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..1266c8827cca 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1454,6 +1454,9 @@ int ext4_read_inline_dir(struct file *file,
 			/* for other entry, the real offset in
 			 * the buf has to be tuned accordingly.
 			 */
+			if (i - extra_offset + ext4_dir_rec_len(1, NULL) >
+			    inline_size)
+				break;
 			de = (struct ext4_dir_entry_2 *)
 				(dir_buf + i - extra_offset);
 			/* It's too expensive to do a full
@@ -1488,10 +1491,18 @@ int ext4_read_inline_dir(struct file *file,
 			continue;
 		}
 
+		/*
+		 * de lives at dir_buf + ctx->pos - extra_offset, within the
+		 * kmalloc(inline_size) buffer.  Make sure its header fits before
+		 * ext4_check_dir_entry() dereferences de->rec_len.
+		 */
+		if (ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
+		    inline_size)
+			goto out;
 		de = (struct ext4_dir_entry_2 *)
 			(dir_buf + ctx->pos - extra_offset);
 		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
-					 extra_size, ctx->pos))
+					 inline_size, ctx->pos))
 			goto out;
 		if (le32_to_cpu(de->inode)) {
 			if (!dir_emit(ctx, de->name, de->name_len,
-- 
2.43.0

