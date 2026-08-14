Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA6D37CD53
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 06:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786690231; cv=none; b=I/+inpnlzg5Ue++SHo7ChOsipcnvxiwp0i+zQKQqp9kU3gdaiQd5wSSLNN71W5spLjAK/XTEMOXz7ZF21HfLIO10zPjiw6d2aLqdnTtQCn5VpkRFYAsYopAmnYmzD7pMqIiwtTtgSc7p+1I/Z38i3AQ0gPKVst2P/LYf2pjhvaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786690231; c=relaxed/simple;
	bh=ZoND6SgYlFGy8Yl4TLpM9xZRMwvAvAJvxlEO5soMTGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCDL9ua/1B/9ulAZ7DWLNEex6Do+bvReK9huO2xXqiRJBuPGXk9zMobI1S0IIMaXNYkFgSvpSRQneJcKxCFh5sx6R6lREfkTrwsX71EEUdbxaRendliwz0aIDUHdAAa7oyyvPNNd/TNDjALGF/eCc4wJD9TiQaCGt1VWKyh6I2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oGK6caGG; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oGK6caGG"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3900e39d935so634542a91.0
        for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2026 23:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786690226; x=1787295026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cEBVrxsOZNPFOJ2dliwfiQO84Pc2OG+V1f05X1HYTjQ=;
        b=oGK6caGGfYMpu0hYzqq8bu5z48cWW6aet3LGlodMoj+OV+tGHg2Jc39JQHqjxzL3d4
         n3xWwqdJXn5O6SAF5qJMHYpxpTMicAX3UArTWywGW+qcijqSOcYlj1QgnDQMmq8wCrLC
         oTbQ5YxPA5W0xZb71ejH5eTqQN2io8lH6P8Ix/mOQ0mXtEt/IpVSxlSg6cjS8CkxFFVb
         jpFJzVWi/9t6PQ8MUuUK/Ku/0AGzs9alhj6fLQ6YRqhiGiQrxM/+cWTh7ZlC7GAOU4VS
         02CjtYxKAmIFOaQM8V0h/crN20ywAX99IwIVaKnW+RDmidnWHCU7wl4n/9GI1jGGn+gt
         HSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786690226; x=1787295026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cEBVrxsOZNPFOJ2dliwfiQO84Pc2OG+V1f05X1HYTjQ=;
        b=btzumJ4yUkVHAAA9E+UkjTPhdMSl6aQxOn0O9gcAYTKc7Wejl7viG7e+53MlSZcL28
         aSZ3vbsBsmsqPVepJlv4+KibYMTKz+CxWnJT6JciWr3Cm6P6ehnHfWlFgfcoDPCJxLHU
         Li8qjy5qzinaGgiwI6W1EW5kKPNnVsbqQoSoM0s7tDCDkxPwIYDNjhPuJ0QoNFoGI0MT
         nw/5rfaS3kNHmaEMLkx05aZYAsxXXUCZ/guAsJkKnAeVyy91nAStGOXTWInpyVW52yCm
         I7NHHhPTbl64YqyPKofxLkNUDGeRKHz0ax8yJJ8bGdi87wVAVVx2SKU4xcixR7mVHsHM
         qLHQ==
X-Gm-Message-State: AOJu0YzMdITs7ZldW+5r9plZEnGCsZw9+qW6q9w2HxfUYAA9yY8sae85
	lYtbAUMNiTaPhGdrzJHIYCQXqfvhiLl27VydPSc4qLukMTsNbKsnHEfC3bm6APSU
X-Gm-Gg: AR+sD119+1EfPWf4xaMJjxHyGN/74yTb9i19eRARsmgbKkNUaBQr8UIrG+wrWiGpmsC
	byrfFYwgZ3tTX6EbW3xoNUaa4+OVFJOc9GFs89P3gglQuF5dhhleLgFWJK4m8SRwLn194fShW59
	/KcQTht+wNkp9SffBiV32f9h6HcT345XHVX0EeApQVZ3KafO1gkEQiTPNOeOCZ6rKuLzjOofyDu
	8ODUF+Cmm2cAUz4Vwo65uoEuMzxQpr1lKH0PxucEtlUgU/YNUGcI0vSsdxoVUGlqFgqzk6vRdc/
	K3W18YNOxDJY0BoJ2YPjvbXElKKc/6/YyzvelKOWkOHhUN4czrLs3/4x5MwPiZQRVcdBjOf8x2c
	Rl9tabkO0v1NRNQN/HEZEPkP+KCCB6Uy5dpZVauLllis+VUYQDkU8Lsnfl/h8xLCoW9+LRszuZt
	hXjOujSMow0VnR92+3ZML4TE2DoI3mi5bvDAgBdeVn22eAXw0isAEnv3NIRqC8rixOoQlHAweYV
	NTCAytF8rw3obCF4LFd7skmi9ejlvPi2SnWZIIJAhwuGkf/qN8M4ugngXKPtAqhLGG3DdbcR350
	dbR1VfIVMWN5yAF1RWt+6sxmjJA6y/Zv9MxbeAilI7cGYem/CRRu
X-Received: by 2002:a17:90b:3908:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3933e74e1bbmr3550056a91.18.1786690226204;
        Thu, 13 Aug 2026 23:50:26 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c87bsm1271759a91.4.2026.08.13.23.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 23:50:25 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz
Subject: [PATCH v2] ext4: drop extra ea_inode ref in cached-block reuse path
Date: Fri, 14 Aug 2026 14:50:23 +0800
Message-ID: <20260814065023.3466742-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812044556.2209787-1-matthias.goergens@gmail.com>
References: <20260812044556.2209787-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_xattr_block_set() acquires a reference to the ea_inode via
ext4_xattr_inode_lookup_create() before constructing the new xattr
block.  In the new-block allocation path this extra reference is dropped
after ext4_xattr_inode_inc_ref_all() accounts for every entry in the
block.  But when mbcache supplies an identical existing block and that
block is reused, the cached block already carries the correct refcount
for its entries, and the extra reference is never dropped.

The cleanup block at the end of the function only calls
ext4_xattr_inode_dec_ref() when error is non-zero, so the success path
through cache reuse leaks one refcount.  Each reuse event adds another;
eventually the saturated refcount prevents the ea_inode from being freed
when its last real reference is dropped.

Add the matching drop when the entry was not written directly to the old
physical buffer (bs->bh && s->base == bs->bh->b_data).  In that case the
reference belongs to the old buffer, which the later release_block()
handles.  When s->base is a clone or a fresh allocation and is discarded
in favour of the cached block, the extra reference must be dropped.

v2:
- The v1 dropped the reference best-effort: a failure was logged but
  masked by the later "error = 0" on the success path, so the syscall
  could succeed with the on-disk refcount one too high.  Fail the
  operation instead, and undo the locally-owned part of the reuse
  through ext4_xattr_reuse_undo(), the same helper the success path
  uses for the old block.  Any reference that nonetheless persists
  (e.g. under errors=continue) is repaired by e2fsck.
- A failed decrement is never retried: it may already have mutated
  the refcount before failing (e.g. an EA inode inheriting S_SYNC from
  the root directory can fail ext4_mark_iloc_dirty() after the
  mutation in nojournal mode), so a retry could decrement twice.  The
  failure paths free the quota charge and drop the inode reference
  directly.
- Propagate the same masked failure at the new-block branch's
  identical drop: it has always been best-effort (warn and continue).

Found by the Sashiko AI review bot while reviewing the xattr
saturation-livelock fix.

Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 fs/ext4/xattr.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e228..0ce937d890042 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1362,6 +1362,17 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 	return;
 }
 
+/* Undo the locally-owned part of a cached-block reuse. */
+static void ext4_xattr_reuse_undo(handle_t *handle, struct inode *inode,
+				  struct buffer_head *bh)
+{
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
+
+	ext4_xattr_release_block(handle, inode, bh, &ea_inode_array,
+				 0 /* extra_credits */);
+	ext4_xattr_inode_array_free(ea_inode_array);
+}
+
 /*
  * Find the available free space for EAs. This also returns the total number of
  * bytes used by EA entries.
@@ -2107,6 +2118,39 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			mb_cache_entry_touch(ea_block_cache, ce);
 			mb_cache_entry_put(ea_block_cache, ce);
 			ce = NULL;
+			if (!(bs->bh && s->base == bs->bh->b_data) &&
+			    ea_inode) {
+				/*
+				 * The reused block already holds its own
+				 * reference; drop the extra one unless the
+				 * entry went into the old buffer directly.
+				 */
+				error = ext4_xattr_inode_dec_ref(handle,
+								 ea_inode);
+				if (error) {
+					/*
+					 * The decrement may already have run;
+					 * do not retry it: free the charge,
+					 * undo the reuse, and fail the op.
+					 */
+					ext4_error_inode(inode, __func__,
+							 __LINE__, 0,
+							"dec ref error=%d",
+							 error);
+					ext4_xattr_inode_free_quota(inode,
+								    ea_inode,
+								    i_size_read(ea_inode));
+					iput(ea_inode);
+					ea_inode = NULL;
+					if (new_bh != bs->bh)
+						ext4_xattr_reuse_undo(handle,
+								      inode,
+								      new_bh);
+					goto cleanup;
+				}
+				iput(ea_inode);
+				ea_inode = NULL;
+			}
 		} else if (bs->bh && s->base == bs->bh->b_data) {
 			/* We were modifying this block in-place. */
 			ea_bdebug(bs->bh, "keeping this block");
@@ -2143,13 +2187,21 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			if (error)
 				goto getblk_failed;
 			if (ea_inode) {
-				/* Drop the extra ref on ea_inode. */
+				/*
+				 * Drop the extra ref on ea_inode; on
+				 * failure the decrement may already have
+				 * run, so just fail and free the block.
+				 */
 				error = ext4_xattr_inode_dec_ref(handle,
 								 ea_inode);
-				if (error)
-					ext4_warning_inode(ea_inode,
-							   "dec ref error=%d",
-							   error);
+				if (error) {
+					ext4_xattr_inode_free_quota(inode,
+								    ea_inode,
+								    i_size_read(ea_inode));
+					iput(ea_inode);
+					ea_inode = NULL;
+					goto getblk_failed;
+				}
 				iput(ea_inode);
 				ea_inode = NULL;
 			}
-- 
2.55.0

