Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794BB45519A
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 12:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787835133; cv=none; b=Qfxwp4wP319mnt/anX6rHpTx/6tAyLlVcY5aGuDQ/2lfaOk3d2+2uLpsvq/lYUU8h6OUjHdnT+1lBYb6Quoo2QbPVmJW/Z8SVm6Ldojh664tM/s4YACTz+sGy404IB4B8DLNFcJWCxeWZKEtIqRGfO7oCopJLTbvEijt4T5VSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787835133; c=relaxed/simple;
	bh=K9axMah5qz+QEVhEz4bEKeBDM+BV3dE8rnC3WGnMggw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0V/iGpT7+g2b+OmJWI4K/MGiUTRGWH4jvnuWsVy9vq73/KWqVukOISMWLaTdldrBKlocJnSSOYtlvTQdP2cx1nGNya3ov5o6OU26jtBiBJ3CnsUZCBtfUfEr7CrU+ntP7hidxIZouAfiSfUN1KWzXLL16esBCN7SHmdLR8EEJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ZS2CEG7+; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZS2CEG7+"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so1826822a12.0
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 05:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1787835126; x=1788439926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=78hHrlgtsKFYxigQeu7K4G0bR4FTknBfS+NNz2iRaEw=;
        b=ZS2CEG7+6FnT9MHh1t/rl43R87L+VNge9wqQsrIrWM/0hFZSyA3efgywPBlgCvNHbr
         FkSzAmkJcTrIcl+6SgOqeE2Ds6IatWVsA7ivi2FkbmdFhB/xgBeET6wcoYcmFr2DSFsA
         FOZ/BWx+9nvV72liq7NtbZJpvHT/xcxIk7Px8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787835126; x=1788439926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=78hHrlgtsKFYxigQeu7K4G0bR4FTknBfS+NNz2iRaEw=;
        b=XyLjIbYOTRZH7sTfbagexsvl9BhewPdln261LtdNIDB+jtAnyXWS7iYDbJ1I6wl8Bl
         ga2DBEhIrUqaEZSEQSt+PLwc1tzvAFyPxe3AIjmPeJntfk3J3XircCPRPmayi6H1ZKZL
         aQ+a0qnn2876fuGybAazEgOT0aQX2yMd0TD7lT6+whD9hMxbVnqjmhqLV+3EOIWxEm1I
         6dR/lUmRxQZXuWcC4ikInyY4ejg7qc8Oc9UfueLi0iwvAJvkGAqTDSO+dsbDbTMqxBH0
         iCnAabTs7vBCsx2yA6mGWpyratW8jYk3mwN9q83PIuJUIaeaVZ6fPGgnrzqchnN3YDc9
         /CDA==
X-Forwarded-Encrypted: i=1; AHgh+RpjbCiBuC8aat2k2nP+Qz1MAcgcgKq6IwvAA52yu+IO9nbLfIGnUA5PuXwzGFyivHPDgBfcsZrIq3I8@vger.kernel.org
X-Gm-Message-State: AFuF++mx3saxL1JR+XpDm7yBPEvrTbqedS0f1sRN2qZTONLnwPi4TruW
	WijDjlVHxiRU29TcOPONk1kXJEC+9dXWglfdIQfc+bQZ7c/GrM19xkRofuhD/wYm7w==
X-Gm-Gg: AR+sD10sRyK4ZPMx0ekeGAGeqco/JB95KlPnOvPqdLGwLQfgeUq5P1uloY8pYNLEhWM
	URD3H96lC3gz2LOXgJUKIk5+CHeLyJ9kRtlMnekWYyyksHI/fa3SDfhxMmy+051GdHAlrOTFGWz
	BW9ZsGgqLRCF7mdg4paYXHP3AO1lHqKYgiyA5L7iY2kp4WOBUh6MCn9Y0DiVgRNKlCzuTwdEJlX
	tEXJu7YxR7LY2/5tByU4z30v3gZuyHBYXbaLq4NtkRKrGT55D8HdGif5kZSNYY4b1I5d8ncLJt8
	F0ItFv7OR4Myrjg+4IyFN88mkKwlM6QnnaO8rz3yTkmW/zQ5x2fM7VMk5G94aRXhG1D0r6LehDI
	GNs3Y8BD5rFNEKJql9Wi7r4cSWa5G+m5z2GkeW606z/fjRkV50djIOwk1irgBqroabNFXkVqDLA
	bT0RBQ7HyQb461vpM7m3xa4p7lnB7HYsBOt1VKX+iXOJjZVQ/gRjSwbux3hER/Ac6a2WTbMREic
	+nC63TuwvhK3H1CyhfZm6yo/QD1J+oqZvJ2pNUgo/Tw3McDvN8=
X-Received: by 2002:a17:90a:dfd0:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-3966d3a8f3amr32347128a91.8.1787835126108;
        Thu, 27 Aug 2026 05:52:06 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ff0:ad84:24b0:9e52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd5edbsm2726158a91.11.2026.08.27.05.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 05:52:05 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sarthak Kukreti <sarthakkukreti@google.com>
Subject: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
Date: Thu, 27 Aug 2026 21:50:20 +0900
Message-ID: <20260827125158.4030598-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We observe the following ABBA deadlock (casefolding enabled):

 INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
 task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
 Call Trace:
  <TASK>
  __schedule+0xc2c/0xe60
  schedule+0x40/0xe0
  jbd2_journal_wait_updates+0x8f/0xf0
  jbd2_journal_commit_transaction+0x321/0x1850
  kjournald2+0xa9/0x230
  kthread+0x226/0x2a0
  ret_from_fork+0x101/0x1e0
  ret_from_fork_asm+0x1a/0x30

 INFO: task Thread-10:4161 blocked for more than 720 seconds.
 task:Thread-10       state:D stack:0     pid:4161  tgid:3848  ppid:540
 Call Trace:
  <TASK>
  __schedule+0xc2c/0xe60
  schedule+0x40/0xe0
  wait_transaction_locked+0x8c/0xd0
  start_this_handle+0x252/0x870
  jbd2__journal_start+0x120/0x280
  __ext4_journal_start_sb+0x11a/0x250
  ext4_evict_inode+0x208/0x760
  iput+0x222/0x5c0
  dput+0x293/0x690
  ____fput+0x145/0x2b0
  task_work_run+0x7a/0xb0
  exit_to_user_mode_loop+0xc0/0xd0
  do_syscall_64+0x14b/0xf10
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 NMI backtrace for cpu 0
 CPU: 0 UID: 1010216 PID: 4160 Comm: Thread-7
 RIP: 0010:d_walk+0x0/0x290
[..]
 Call Trace:
 <TASK>
  shrink_dcache_parent+0xb2/0x100
  d_invalidate+0x50/0x110
  ext4_rmdir+0x3a2/0x3d0
  vfs_rmdir+0x9d/0x1d0
  do_rmdir+0xf0/0x330
  __x64_sys_unlinkat+0x34/0x50
  do_syscall_64+0x61/0xf10

The problem is that ext4_rmdir() calls d_invalidate() before stopping
the jbd2 transaction handle.  Because d_invalidate() traverses child
dentries it can encounter dying or in-use dentries.  If a concurrent
thread executing __dentry_kill() on a child dentry invokes ext4_evict_inode(),
it requests a new transaction handle via ext4_journal_start(), which
waits for all running handles to close.  However, the thread executing
ext4_rmdir() still holds its active transaction handle while looping
in shrink_dcache_parent() waiting for the dying child dentry to complete
eviction.

Stop transaction handle in ext4_rmdir() before calling d_invalidate().

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Co-developed-by: Sarthak Kukreti <sarthakkukreti@google.com>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 fs/ext4/namei.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a6386c1d237f..231a274b814e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3209,19 +3209,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	ext4_fc_track_unlink(handle, dentry);
 	retval = ext4_mark_inode_dirty(handle, dir);
 
+end_rmdir:
+	brelse(bh);
+	if (handle)
+		ext4_journal_stop(handle);
+
 	/* VFS negative dentries are incompatible with Encoding and
 	 * Case-insensitiveness. Eventually we'll want avoid
 	 * invalidating the dentries here, alongside with returning the
 	 * negative dentries at ext4_lookup(), when it is better
 	 * supported by the VFS for the CI case.
 	 */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
+	if (!retval && IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
 		d_invalidate(dentry);
 
-end_rmdir:
-	brelse(bh);
-	if (handle)
-		ext4_journal_stop(handle);
 	return retval;
 }
 
-- 
2.55.0.897.gb25b4bd76c-goog

