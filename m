Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E543AB47E
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786960467; cv=none; b=u8E/ix5SBD4n4pNoo7ZlEkhQjyFNJUoOu6v1sc2DwEx3CoFCOUPRxaaoMQ4JkB+SrGXpD1UxL6BlN2mFDhvgyorFzVTvNd4KSSvJ8iiiWEhdGChaVEjp8QdOy84GudS4qEeFhoo92gg004WZOJcScYRmIL1y0mYJpXp2pmLNHd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786960467; c=relaxed/simple;
	bh=BhXJb/A27yVhcIzZQ0mXA9ogD0TnnK2tGqo3JJr7d1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+PormAmW5tRKD51XM5TA+JpNR/0/zCb+BfVsS6iUxJyeou3IEuAr0BR5SHVLjWGasBEPc+By/uhj0fXa3cCws6WkQ/d08ouI7ujVn7Nm0qHh5zLWjTutE4WMdsgi+Cu5KspzQERih99hB0RGfxlfF2CT+KGaLOQBiGG1XFPXz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYpX7ZnQ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYpX7ZnQ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d53197d8b5so24671265ad.3
        for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 02:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786960465; x=1787565265; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=63J9OPVd71uDptawci2ix7+JFslOh0UL9CAgs7qL3cI=;
        b=RYpX7ZnQtqQCtm58pjIr7L5BUVQ/o+oe9m/uWA6UxiyaJBRzapU9by4LGdgUKDdxo7
         +ZUeU3rTH/AaoFOHMJ0PqP1RWYv+4VxPuN0NT7V4oKy8NmdLfAFZCrtdFgKdWShI1MXB
         GfFr8us0Ebj/cruc3E7ifh81r64ZpHY2pc9tk19X4FJzSmeCAfOtWcB/uh83uEZyk6hT
         n9D98gXKYPOYwTN0jmiv9nJAs/cCSWtOueE9zVKoYnp2akh8ROHzXkoS7hnD5wRgWfsO
         EuLorCkqvVtAArdSiEAiWWGyflRMOICio/xs/fBXbpc4iZBeWlfbjT+RQwR+CxicPZss
         tiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786960465; x=1787565265;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63J9OPVd71uDptawci2ix7+JFslOh0UL9CAgs7qL3cI=;
        b=miEVXN0u4jba/LLbX/bMcj9NRDLorEjuoAhgJ4aHt2rwF8KqPgldUB15QvU5cGscFC
         iFcry4QyhI2MIFSek5NySRTQ3c274wOki3YKh/YIQfWsaLXQ5gyuAJL8okVF4vHVwwZd
         F+yjK54gf07DpaB9DXfE6bx877GmicDgRhBP6LHKNhitO30fNzpy7U1LpRNe2ODnm6ft
         0irznbtA0PWS6ifhTIEmAcdDJNdd00/ZwN2wuXAnO94n4j12NsEDHYiXzYYWlPslFuQH
         3V/xhp5SIsa6Gjh5EkCqDUxzLvt7DMUwGXDov55SqRHGaf7SDIcozZbf7VDR6qsx8Wy8
         CpWA==
X-Gm-Message-State: AOJu0YxvVBYftCwWbKsiyr9+C9k4RZN9RN1VzmWSUBmWQwoUirBcRZUZ
	SzhKpoOXl6WdU+IC9HXL3S8Y2lqhvae3Bj82JhrPgmUcAs1zA7EjWDDMEaRdZWjV
X-Gm-Gg: AR+sD13YDevgNY05tCout/dQBdK/11E8yewZtAiDdRqNyovv2MksyaLILEcuuKgWbYo
	cnApuOfVVdnUAuMUP1cqOFe44C/a3l65rc/2bYIbeHXW757VFWMKHbUK2L/6Qk2Vc3xLZQBp48L
	WvztRcnLfC2puFGm90zfduOEvekAKtrXmn+N1+tf++mTFj4hEMXrzT7Ck/uo9Vs6Pcx0dkuqDGv
	U4BCTY9oYIvMXKk1wcq38YWaLx9ld5pHbspW/mLydOy5ObvK4WyhuFGUc5h1XSxERZEMhEfNBuO
	SHnoJBYr/QG/GO+WPvI1Xo84Fpy7fuUO5+tB5Z6JpGd2qiaVouFxU2rMtUUdVMgBqzlK0IVXXL/
	+h9qXAQL0A+adu++8PHSj4Hdenz3LhBOfP+bbqSq6YA4H9jbaWUVuuf6mwILfgdYsinEMBTGgp/
	AtjRa2wGcGsY0KF/9c3GaXdVzXNl6kJDOJcVq/TZ0Spyta/gErnYcUPDORy++qMtzpr8hi8NoMt
	CnEWGjKJ6OqyzsIzoxnBPUBYr9XdGpQMVL2kpnTsrYf3PH78Q2/sFlIPEyK+bULQEhfEDGiUFPL
	bRWPWHg/PpLF5nW9ApXSvw22WBCw+1A0NDFupJTihsYGKYmfbdyB
X-Received: by 2002:a05:6a20:2589:b0:3c3:7f50:fc3a with SMTP id adf61e73a8af0-3cc71e7d6fbmr23434426637.33.1786960465232;
        Mon, 17 Aug 2026 02:54:25 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13bf26504sm455270a12.10.2026.08.17.02.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 02:54:24 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz
Subject: [PATCH] ext4: compensate ea_inode refs and free block on new xattr block write error
Date: Mon, 17 Aug 2026 17:54:21 +0800
Message-ID: <20260817095421.1171145-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814070432.595B91F00A3A@smtp.kernel.org>
References: <20260814070432.595B91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_xattr_block_set() increments the on-disk reference counts of the
ea_inodes a new xattr block refers to before dirtying the block.  If
ext4_handle_dirty_metadata() then fails, the error path neither undoes
the increments nor frees the block.

With a journal the failure aborts the journal and the transaction is
discarded, so nothing leaks.  Without one, ext4_handle_dirty_metadata()
can return -EIO when sync_dirty_buffer() fails for an inode that needs
sync, the increments are already in the dirty ea_inode inode blocks and
reach disk: the reference counts stay one too high forever, the inodes
are never reclaimed, the new block stays allocated but unreferenced,
and the quota charged for the new value is never released.

Compensate on the failure: remove the block from the mbcache, drop the
references, free the block, and release the quota this operation
charged.  A concurrent setxattr may have taken the cached block
meanwhile, so re-check its reference count under the buffer lock and
skip the free if an owner appeared — degrading to the pre-existing
leak rather than corrupting a live owner.

Verified on a nojournal filesystem with ext4_handle_dirty_metadata()
instrumented to return -EIO for the new xattr block (the sync_dirty_
buffer() failure case): unpatched, e2fsck -fn reports the stale
ea_inode reference count, the lost block and the parent's i_blocks
residue; patched, the same injection leaves a clean filesystem and the
no-injection control behaves as before.

Reported-by: Sashiko AI review bot <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-ext4/20260814070432.595B91F00A3A@smtp.kernel.org/
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 fs/ext4/xattr.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e228..e086c8395042a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1362,6 +1362,63 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 	return;
 }
 
+/*
+ * Undo the setup of a new xattr block that failed to be written out: drop
+ * the ext4_xattr_inode_inc_ref_all() references, free the block, and
+ * release the quota this operation charged for the new value (quota_len,
+ * zero when the value is not in an EA inode).
+ */
+static void ext4_xattr_new_block_fail(handle_t *handle, struct inode *inode,
+				      struct buffer_head *new_bh,
+				      size_t quota_len, int error)
+{
+	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
+	struct mb_cache_entry *oe;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
+
+	ext4_error_inode(inode, __func__, __LINE__, 0,
+			 "xattr block dirty failed: %d", error);
+	lock_buffer(new_bh);
+retry_owner:
+	if (le32_to_cpu(BHDR(new_bh)->h_refcount) != 1) {
+		unlock_buffer(new_bh);
+		return;
+	}
+	if (ea_block_cache) {
+		oe = mb_cache_entry_delete_or_get(ea_block_cache,
+						  le32_to_cpu(BHDR(new_bh)->h_hash),
+						  new_bh->b_blocknr);
+		if (oe) {
+			unlock_buffer(new_bh);
+			mb_cache_entry_wait_unused(oe);
+			mb_cache_entry_put(ea_block_cache, oe);
+			lock_buffer(new_bh);
+			goto retry_owner;
+		}
+	}
+	get_bh(new_bh);
+	unlock_buffer(new_bh);
+
+	ext4_xattr_inode_dec_ref_all(handle, inode, new_bh,
+				     ENTRY(BHDR(new_bh) + 1),
+				     true /* block_csum */,
+				     &ea_inode_array,
+				     0 /* extra_credits */,
+				     true /* skip_quota */);
+	ext4_xattr_inode_array_free(ea_inode_array);
+	if (quota_len) {
+		/*
+		 * Reverses this operation's own ext4_xattr_inode_alloc_quota()
+		 * charge, so no EA inode pointer is needed here.
+		 */
+		ext4_xattr_inode_free_quota(inode, NULL, quota_len);
+		ext4_mark_inode_dirty(handle, inode);
+	}
+	ext4_free_blocks(handle, inode, new_bh, 0, 1,
+			 EXT4_FREE_BLOCKS_METADATA |
+			 EXT4_FREE_BLOCKS_FORGET);
+}
+
 /*
  * Find the available free space for EAs. This also returns the total number of
  * bytes used by EA entries.
@@ -2169,8 +2226,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_block_cache_insert(ea_block_cache, new_bh);
 			error = ext4_handle_dirty_metadata(handle, inode,
 							   new_bh);
-			if (error)
+			if (error) {
+				ext4_xattr_new_block_fail(handle, inode, new_bh,
+							  i->in_inode ?
+							  i->value_len : 0,
+							  error);
 				goto cleanup;
+			}
 		}
 	}
 
-- 
2.55.0

