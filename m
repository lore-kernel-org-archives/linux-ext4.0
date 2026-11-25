Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617529;
	b=5It6Y7jHTftGORRYnhJnYz4fr1fYf96T6OrcWCcUoD7jaqeX5XUKMR0v5pr0SHouwFOK
	 UT5oCN2AIsnP+vG/ULyZhZmhCiWtes2CZqCojkH2bcwG7CD2epR1fWGWyfUsf6CvYghs6
	 6IoiyVhJR06rPHOha4Zbq+RxBs0CFR7W88sX7wMqOn5y1+lpj/fXMgH7GsTxlQY+nLiJ3
	 m6ZPGGFS3keBq1lL2UkkKTN6JJdHW2LMG5lRwUgdHt/nuPnKX3xNHL8knt2ysd9/FxRHw
	 t8HgLYGuIA4TJ1IVulpYv4zVDf/1fFwdWrUJPd3ivIQKmYoQEOdUD9R2mb+8znoGihw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617529;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=KCNbPva4mF5XpGmktWSlUa7O0FkwlEdc1yHh6KRJCrU=;
	b=Ntf1gHnB6c2LjJPU37hpYlr/48iBc+x9jCHmbXdjUJlIWSpb+/wBrRMsruiladh2Kbmo
	 40CN4H/xN5fhXHlv8qZ8Hir4VwU91fG118eBg2B8RrfEN3mqrF9QOKP4643k6kwB+ALKl
	 h7dmkQB5wpd0KptVmgtlmwjlAKZ+nBu6KKQCmjl4o9lntsqkNRNz1t9XioU4uaKH4VwC2
	 p6E3eNKiZHLbKiVoamwwMMB5sOwgMe1PN6wcuxfoZQvdVNLakO4WMw7FMiSyByqH3NQtZ
	 sZ348s4mgtaTerLdQ+m/i6iFEj50aktQ3TurhqXCGBW70XjoYvHOOxAa0kBq6QcvwCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=e2b.dev;
	spf=pass smtp.mailfrom=e2b.dev;
	dkim=pass header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=X9nev+gb;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77296606A331
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 14:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77296606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=e2b.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e2b.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=X9nev+gb
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso58071145e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 06:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=e2b.dev; s=google; t=1795617528; x=1796222328; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KCNbPva4mF5XpGmktWSlUa7O0FkwlEdc1yHh6KRJCrU=;
        b=X9nev+gb29dK/PZhEUG0om2mx2tvAWC8Drd9Ue/pqjwJmae7sCJYZfqPIJx54is2kD
         m60KFv5wCeweYOM+cOUhZN8DC7OWm6yqx/sF1/Yq+KcUGNmVwC76TAxeeyzYFZG2tUm/
         BhoBl6rop+Rcsv8ogi0XJ569w8OFy77gCm/PFyzCcc9UbnkwrZ5whLvgAQRIIDr16Hz+
         KR+3bo6ZnG0fJUB8xCIa/7xox/jN3dyrL6q3exf8Uy5140xe277hUxIpdh+jc2k349IQ
         EzWfbVK/yfWYvDBqVAPbWJjpNZAZrA3W0L9oasgX1+FVuD8pZYE6wRndFE1BSbDqT4P7
         94UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617528; x=1796222328;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KCNbPva4mF5XpGmktWSlUa7O0FkwlEdc1yHh6KRJCrU=;
        b=QbNQUQvNboil7pO4uLMU9qaAeQBcVVx3/9WZ64Sq3tIQ3go/Lsp2KFImCwsCkddJSv
         HmSsTeYhoploru/P1DkvAsQY4yguAg1yzjjPFOSjQiPzkiNMaTeS2k6eG0gs5eufAXae
         UglNLuAKk9RQ8u6Pap5OdHX/fY8Bcq/CIv+wYs54NQOs3dGXOy6KAlMNTMMVm+Lt025f
         alGqTBU1R8/El20lNaoNSf1vJ7WlnAqTpxtsdDPhZqcsoU/d1I7MMCAYus8pqJiLXYmY
         1u1SME+NW918TZFD6LvbgCIQ4lDGyEVsSmmRU//t2mchF/8SljqwhG+gKRFJ5XlPkyFQ
         oy8w==
X-Forwarded-Encrypted: i=1; AL+hErGN9+Ew6VIZE/3WappWiB3O/nW4bjXQE7Mvk8TC3QiKIMt7V/5uyS+zlPqtMRu90F4shQgMe4QMFOzZ@vger.kernel.org
X-Gm-Message-State: APuU4Z9zaWUu/GPtj7+kxRbb/tz2X4NHFNlQaa1Tp8SIAY01dzkAzZk6
	IXLbJA6vKjo81ilXBZchOMsSjD4l+xx483YzACD+zLdmAWMk8yDyAd8QsYKBT24gfR8=
X-Gm-Gg: AZFdTZefnckxiW5Axoe2ZCFVhguDBA/S8kTt19N6ajrM+O5WeCOoVI9DRd4Fs+5CRKx
	w5DPUcyPdCa6Gr/awYQIDeoBpxyhQ3OJ5Wx++Z2sGvh2hz5TMkgbGKstpAAiu+VghB6fl3dD50Y
	F90SkD6gfAzWL2tnzEntilhB7+Cwb6d8cRt7iFoLuqJx/9oZHcKYDo9If9FCwCl3qTC3zS6vjIT
	CDETEyTGMEYUO/i5X2cTnXeiCMmvUPhH30r1KoGacr3JjJqzt5QSHLriFRQxrnceDeYXEWGBNFb
	gM2uLGmVx0jeC6gfM9ALZjyHLlWmoU4SuV6GUt0saqxc5uHUKgw74e+65kMYd1xVYfH1R2ZLZJI
	/1HkRE6K5deFcv/DMpvJJRmmwkx7K2tminOP0QA2kbAH9aGAK+d+nywIt92lEaHUqqxyE8ZBNqb
	U7Pb2I+oKVIR/Hmgbne/MeFOM4kGoWE+/GGf/nObNO2cPbIixYRH5mHSMfwuqz3CxgEG2WiDd7N
	zNqQpt1ayuxHmPGknA3oLW1iH1k2KhnVybIaaweTGSmrAKdgn2inBHBSigCVLSRb5zyA1wc/Uvt
	2eJWA5vWNSt2UKePk5+i2Akyb2UXuCvacl6/SDcZKTF++KroQmM=
X-Received: by 2002:a05:600c:820d:b0:4bb:5de1:e923 with SMTP id 5b1f17b1804b1-4bb887c33f7mr352292285e9.4.1795617527720;
        Wed, 25 Nov 2026 06:38:47 -0800 (PST)
Received: from fedora.sphynx-tuna.ts.net ([2001:1ae9:6617:a200:4752:c78a:bea5:1bc3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8849e598sm491648735e9.8.2026.11.25.06.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:38:47 -0800 (PST)
From: =?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: =?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>,
	stable@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: recompute the inode checksum after restoring inline data
Date: Wed, 25 Nov 2026 15:38:39 +0100
Message-ID: <20261125143841.928615-1-petr.vanek@e2b.dev>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_restore_inline_data() recreates the system.data xattr with
ext4_create_inline_data(), which marks the inode dirty and so sets its
checksum, and only then copies the saved bytes into the raw inode with
ext4_write_inline_data().  Unless something dirties the inode again
before it is written out, the inode reaches the disk with a checksum
that does not match its contents.

Failed inline data conversions take this path, for example an mmap write
to a small inline file on a full filesystem:

  mkfs.ext4 -O inline_data /dev/vdb 64M
  mount /dev/vdb /mnt
  xfs_io -f -c "pwrite -S 0x61 0 42" /mnt/small
  xfs_io -f -c "falloc 0 64m" /mnt/fill                # ENOSPC, fs is full
  xfs_io -c "mmap -rw 0 42" -c "mwrite 0 1" /mnt/small # SIGBUS
  umount /mnt; mount /dev/vdb /mnt
  cat /mnt/small                                       # EBADMSG

The read after the remount fails with:

  [    1.203967] EXT4-fs error (device vdb): ext4_lookup:1635: inode #4097: comm cat: iget: checksum invalid

Mark the inode dirty again after ext4_write_inline_data(), so the
checksum written to disk covers the restored data.

The Fixes tag is based on code analysis: ext4_restore_inline_data() has
called ext4_create_inline_data() before ext4_write_inline_data() since
that commit.  The failure reproduces on v5.19 and later; older kernels
were not tested.

Fixes: 3c47d54170b6 ("ext4: let add_dir_entry handle inline data properly")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Vaněk <petr.vanek@e2b.dev>
---
This patch was developed with the help of an AI coding assistant
(Claude Opus via OpenCode).  It analysed the bug, wrote the fix and the
changelog, and built the QEMU test setup; I reviewed the change and the
test results.

Tested with the reproducer above in QEMU (x86_64, KASAN and lockdep
enabled) on 7.4-rc5 with and without the patch; e2fsck is clean after
the patched run.  Not tested: xfstests, other architectures.

 fs/ext4/inline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index acdc65ce47960..360c06441c8f1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1111,6 +1111,8 @@ static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
 	}
 	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
 	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	/* Update the inode checksum to cover the restored data. */
+	ext4_mark_inode_dirty(handle, inode);
 }
 
 struct buffer_head *ext4_inline_getblk(struct super_block *sb,
-- 
2.56.1

