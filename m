Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792961390;
	b=2usjkZuGAlImkbP/MmbxGdGT07V5u6HrpQElRZnl3u1oPB9V/jJDyzgd91Okvf+PRyAO
	 xIXEz+sUPDBGZbKtjXjqvgm0LOtH/aFAT1kQMZ001whqNP1MX+6KECdER1NB+w+tsEf3D
	 e+45fAF7M5Zmc792fpoy1aPCSMFCBaIw1NQfR/Y+/GstVEq0Lv1fFB+GqYUS1v9rIvlwz
	 Hrdnsa2FxjJEAJSPuQPogjM5N9j6hG2Zz4S1CjKRu3gVjao9ndkp/Kgc3frbc8OIdurMW
	 gTBXiTeo4k6zgxbpxR7Fjtrv7Pm33X5ZfIzYlITZq7qznUw1Er7ee4zZSue8j056fEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792961390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YriLpqrjrZmfB+xvcDA9gJWwkDiRX4+T7vg5RgUigrE=;
	b=eTbwg9+fIB8axmmyMEbT0a7EvRoE2qOcCzKr5MkviRyCaB3EKxlyKbRUbUAq1ptYTP0W
	 QRsL/7NLD4Pk1Fns5mnEFkFhkrW+SzqG7vWBbpH+OoLT2oaEoTJypNd/lh9ck9xuC2rco
	 b9PacvTy9HoeEVT1+qQQlyCCqrSgOCIRfdVSHUj2aroFY0yLWuUPYfXVC1/P8Hug8pB8n
	 rQkkp+it+Y5HQQB2MBIK15urYlfw6PY4xIXCIy7IarZTZC+F1Bq1rsjYoNJJd2Tyx+o3w
	 Z+3OhHHd0U3XgsSnRruHs0+mD+9qHmEwLdOIUAOwU6+0rBZlk8ssxquJxvU8Ph7sDcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ratw+LN6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9629C606A31A;
	Sun, 25 Oct 2026 20:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ratw+LN6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4F51F01825;
	Sun, 25 Oct 2026 20:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792961390;
	bh=YriLpqrjrZmfB+xvcDA9gJWwkDiRX4+T7vg5RgUigrE=;
	h=From:To:Cc:Subject:Date;
	b=Ratw+LN6WSQrMxSFfkmRUZbqKXQMhepXEi5IicxhSDL3VDyji7s6MAHtNUBRMm374
	 fc1D3X+ers1xVUlohRJrRphPWhPbqLgB+kUUeLZ47Smnmrt/XqPQlYguie0RP1JLm4
	 MGgb1Bnx88kM+vD3DX2oRZc5WYIsoDswy4Z6MKIwfEJhUQH5pNeWkqyZoY4CT4QNYI
	 R8BVU84wAfphhTvX2pj2N6Ne04khNObfAbJCGHjU6Tac587Mmk5b0KGMJfkO9jZ9nc
	 hXiVPe9BgL3YAkkMBPMDO0h1Uhay3C+3eNIz1UirTJlXasj4sNY7tFHDjm1z2RP6kJ
	 OYBRuaom7Jmgg==
From: Eric Biggers <ebiggers@kernel.org>
To: fsverity@lists.linux.dev
Cc: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] fsverity: Set S_VERITY only after rollback is no longer possible
Date: Sun, 25 Oct 2026 13:48:07 -0700
Message-ID: <20261025204807.122875-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

Commit f77f281b6118 ("fsverity: use a hashtable to find the
fsverity_info") changed the implementation of FS_IOC_ENABLE_VERITY to
make concurrent reads start going through fsverity verification slightly
earlier than they did before.

Instead of it happening when enable_verity() calls fsverity_set_info(),
it now happens when ->end_enable_verity() sets S_VERITY.

However, ext4 and btrfs can roll back verity after they set S_VERITY,
causing a use-after-free.

Fix that by making ext4 and btrfs set S_VERITY only after rollback is no
longer possible.  On failure, don't roll back S_VERITY, but do roll back
the filesystem-specific verity flag.

Also update enable_verity() to handle any future instances of this bug
more safely by warning and *not* freeing the fsverity_info.

Finally, tweak some comments.  Clarify one, and move information from
another to its proper place in the comment for ->end_enable_verity().

Fixes: f77f281b6118 ("fsverity: use a hashtable to find the fsverity_info")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/btrfs/verity.c        |  7 ++++---
 fs/ext4/verity.c         |  4 +++-
 fs/verity/enable.c       | 12 +++++-------
 include/linux/fsverity.h | 12 +++++++-----
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index ccfa2ef97e504..b34d2247cf84e 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -483,8 +483,6 @@ static int rollback_verity(struct btrfs_inode *inode)
 			inode->vfs_inode.i_ino);
 		goto out;
 	}
-	inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
-	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
@@ -549,16 +547,19 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 	inode->ro_flags |= BTRFS_INODE_RO_VERITY;
-	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
 	if (ret)
 		goto end_trans;
 	ret = del_orphan(trans, inode);
 	if (ret)
 		goto end_trans;
+	/* Now that rollback is no longer possible, set S_VERITY. */
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_set_fs_compat_ro(root->fs_info, VERITY);
 end_trans:
+	if (ret)
+		inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
 	btrfs_end_transaction(trans);
 	return ret;
 
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index ac5c133f55292..56fe3e5b33e06 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -216,17 +216,19 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 		goto stop_and_cleanup;
 
 	ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
-	ext4_set_inode_flags(inode, false);
 	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (err)
 		goto stop_and_cleanup;
 
 	ext4_journal_stop(handle);
 
+	/* Now that rollback is no longer possible, set S_VERITY. */
+	ext4_set_inode_flags(inode, false);
 	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
 	return 0;
 
 stop_and_cleanup:
+	ext4_clear_inode_flag(inode, EXT4_INODE_VERITY);
 	ext4_journal_stop(handle);
 cleanup:
 	/*
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index ad4ff71d7dd95..271e8275fd0d9 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -276,8 +276,8 @@ static int enable_verity(struct file *filp,
 	 * initialization so that we don't have to undo the enabling when memory
 	 * allocation for the hash table fails.  This is safe because looking up
 	 * the fsverity_info always first checks the S_VERITY flag on the inode,
-	 * which will only be set at the very end of the ->end_enable_verity
-	 * method.
+	 * which will only be set at the very end of a successful call to
+	 * ->end_enable_verity().
 	 */
 	err = fsverity_set_info(vi);
 	if (err) {
@@ -287,10 +287,7 @@ static int enable_verity(struct file *filp,
 
 	/*
 	 * Tell the filesystem to finish enabling verity on the file.
-	 * Serialized with ->begin_enable_verity() by the inode lock.  The file
-	 * system needs to set the S_VERITY flag on the inode at the very end of
-	 * the method, at which point the fsverity information can be accessed
-	 * by other threads.
+	 * Serialized with ->begin_enable_verity() by the inode lock.
 	 */
 	inode_lock(inode);
 	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
@@ -298,7 +295,8 @@ static int enable_verity(struct file *filp,
 	if (err) {
 		fsverity_err(inode, "%ps() failed with err %d",
 			     vops->end_enable_verity, err);
-		fsverity_remove_info(vi);
+		if (!WARN_ON_ONCE(IS_VERITY(inode)))
+			fsverity_remove_info(vi);
 	} else if (WARN_ON_ONCE(!IS_VERITY(inode))) {
 		fsverity_remove_info(vi);
 		err = -EINVAL;
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index f9433332c274b..61fe96ccdff6a 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -54,11 +54,13 @@ struct fsverity_operations {
 	 * @merkle_tree_size: total bytes the Merkle tree took up
 	 *
 	 * If desc == NULL, then enabling verity failed and the filesystem only
-	 * must do any necessary cleanups.  Else, it must also store the given
-	 * verity descriptor to a fs-specific location associated with the inode
-	 * and do any fs-specific actions needed to mark the inode as a verity
-	 * inode, e.g. setting a bit in the on-disk inode.  The filesystem is
-	 * also responsible for setting the S_VERITY flag in the VFS inode.
+	 * must do any necessary cleanups.
+	 *
+	 * Else, the filesystem must store the given verity descriptor to a
+	 * fs-specific location associated with the inode and do any fs-specific
+	 * actions needed to mark the inode as a verity inode, e.g. set a bit in
+	 * the on-disk inode.  Finally, on success (only when rollback is no
+	 * longer possible!) it must set S_VERITY in the VFS inode.
 	 *
 	 * i_rwsem is held for write, but it may have been dropped between
 	 * ->begin_enable_verity() and ->end_enable_verity().

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.56.0

