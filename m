Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBCC3C10A7
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782370235; cv=none; b=ZE9MGpD50oFfE50d0Qtb1MZ4ferRxw2+SFdabwt//RHLIH8hgGgkdShVHGcBZ1QJdJdFL4N8wbQIiAimkOqrfDNoenEjMmiRxCny0u3EbBy8QUE4QLMOeEnpZYJva/iDaGPN9dGq5lcbjGXkpU0exWW+NobzvY5DBkkyRhMxAOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782370235; c=relaxed/simple;
	bh=sFkznzlfLSl26r6KpCBH/9fUE33xJbX06NLDKxDmSrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fXt6iuq+sX9k2tC1JElrLS97HlJhUwbsaIwfhnb3JaZfbff5YiHgdQVUNwKJXPjElt8iuRtBYm0vB6uawX2g/dVkh4j5H3OQfcd6gkBJ0actTHh93wJlDO6y1hV7vWXcelEiSergfT+OXbvt1QMmCaJaFLUIPpwRyuMTobdK9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SVz6wQN1; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SVz6wQN1"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84538597e1fso1336738b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 23:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782370233; x=1782975033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4kckIrH/H8sJhsSNM2xh5aVq4vn80Y2Ti9UWMx61qs4=;
        b=SVz6wQN1o5c0eUOJTwfQb3RIuXTV1KF3JkY8a5C7iSLEkWtoc5KxQyMd11LxNjL5vZ
         ICnkdAQPlNoXhOAe9c2f+xibevnDbflu5o/I3SvaRM+Eboc1zZl7/fpKNo8GH+U+FSME
         FfVQ8IW5YBQJ3dlxZKbzyREgQjLiBEJ1zzrgh4smI4q0HzKE3HhyBbD3wazU2wZrFzAo
         F1WBbjJByxZ2W8qPnhimSZ22nXS9ph2rJIL4nwmpZCfCXKKMOyo1l939gsO2s/JEZr1K
         QNcnIQsxqYeMNIo7DmzlLw1t/7MldtrMnm1yhDNCzNVaZRbZKToSysVPpIbztJcyzYpF
         Vp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782370233; x=1782975033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kckIrH/H8sJhsSNM2xh5aVq4vn80Y2Ti9UWMx61qs4=;
        b=mj/VGsFbXXW6GiPa2eEO4Jzgtpxz5aHyWw0PNkHw5Z87BFZxpgqBZe5a1FbbbOuzfZ
         PZigApgbFSPF/QHVH6f9bf+gqcLlhd1btQaBeJEF5xfP3DI0ro3S94XtG1gjeu4sy7b2
         DsOu4nWH+UQfpor6c3Pb03KSk48pe89PJgp/E0wHTXTUR1Ipk0/pyYqEgtD2TTD12aF+
         PTROzHtdtCT5/0GBcBRmAXOSZ5juAzN8ZGb7nRRGkP4safSpRfR4UysZKNgLFz/9rk+u
         jElAzlQGHXG6OwHsIvXZUg+TnP4lR01foaUvy1Qyg71mBHNmb7d4wP+e6dhBYnkfNXYd
         qY+Q==
X-Forwarded-Encrypted: i=1; AHgh+RrpmB8dvxF+PT6IW2VWW43fRoWSi+rAbSRC+ZoyJBcd5Am+iD/GyZ/UDeg4u34RHCBM+G26J9fgJ+vi@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm79EovvLSukDb9uqnPelT5RSTInOplpUOKWJG10Qj9mBjMOBO
	tO+WDi0iddKuOTS8cHVqw0g0fKpUfC8SR5Yh7zeHWvjqUMfLzidDB4R0
X-Gm-Gg: AfdE7cnq8HQ6mlbNOl4XZToYOHL9ccDDEkBzmSEzLCW5bdjDcNZN5/mTK67mQHkO5bx
	JrrK5ozAMUgIlzz5n+nFNqbd4SmRJ+gXUtGlgxV3JALqiCd6C58PD2IpODjfhJBx+C9XY+09l0T
	rWf3XpEqFPx4jGsrpMD3yTuHpUcU02BarxWmKihhwz1i1OoRufkB8kQarrwOZ5aa5smjl+DrwUh
	6t3fcoBSHs4CkWEzEdy8DRwVLmQgJTYrttTQ1d81B6oWDmmFSoGftEk47thkorMjTFgBfdb9Q+n
	TAkUqygO183ATOVrxMh0hUVcaWerGr5aUW+WNb4cZUcut3fKjrKPlxtTUv0FeWGG/FB9qzg41j+
	bIpTrkIYV9veEs8XcZPW3SVbbJvNMHdf/bbqOkyUORAeKbuas5/wNTBwYIADW89n/m0Aa5C/UZe
	jobcJJUPIAu+VmpNXa9K0jX5T1tiYQERZikhwDwFApR1HySaQkQ5pnEietZYsVdY+0JinvXY3Db
	GvAUPCti7A6azoWiAG2916TrfGwgCJ0muuIRnggQhG8/S+XoqklzkGq7zfabyw2TgMkkxDXbw1A
	l8Iwjrgtap9aCsZnoMtmijJbhQ==
X-Received: by 2002:a05:6a00:6c85:b0:845:3260:50d1 with SMTP id d2e1a72fcca58-845b3ab5a72mr1672848b3a.27.1782370233322;
        Wed, 24 Jun 2026 23:50:33 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (236.238.21.34.bc.googleusercontent.com. [34.21.238.236])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a3fcd1fbsm3774978b3a.3.2026.06.24.23.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 23:50:32 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: tytso@mit.edu,
	jack@suse.cz
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH v5] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Thu, 25 Jun 2026 06:50:09 +0000
Message-ID: <20260625065010.2332-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
concurrent xattr workloads (using the ea_inode mount/format option).

The deadlock occurs between the running transaction and the eviction
thread:
- Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
  and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
  the corresponding EA inode. Since the EA inode is currently being
  evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
  eviction to complete.
- Task 2 (eviction thread): Currently evicting the same EA inode in
  ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
  blocks waiting for Task 1 to release the reference to the mbcache_entry.

To break this deadlock, implement a new ext4_iget() configuration flag
named EXT4_IGET_NOWAIT. When set, perform a non-blocking lookup of the
inode via VFS's find_inode_nowait() API.

If the inode is currently being evicted (marked with I_FREEING or
I_WILL_FREE) or created (I_CREATING), or if it is not present in the VFS
inode cache (cache miss), simply skip it (returning -ESTALE) rather than
waiting for eviction/creation to complete, breaking the ABBA cycle.

Since we return -ESTALE immediately on a cache miss, we never attempt to
allocate a new inode or call iget_locked(), completely eliminating any
TOCTOU race window.

If the returned inode is I_NEW, wait for its initialization to clear via
wait_on_new_inode(). If initialization fails and the inode is unhashed
during wait_on_new_inode() waking up (e.g., due to an I/O read error in
another thread), safely drop the reference and return -ESTALE. This
unhashed check is executed unconditionally on all cache-hit pathways to
properly handle concurrent initialization failures.

Finally, standard validation checks (including is_bad_inode,
EXT4_EA_INODE_FL, file_acl, and xattr flags) are executed as normal inside
check_igot_inode() to fully guarantee VFS-layer safety.

In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.

Suggested-by: Jan Kara <jack@suse.cz>
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
Changes in v5:
  - Address two critical issues flagged by the Sashiko AI bot in v4:
    1. Resolve the Time-Of-Check to Time-Of-Use (TOCTOU) race window between
       find_inode_nowait() and iget_locked() by returning -ESTALE immediately
       on a VFS cache miss. This completely bypasses fallback to iget_locked()
       and prevents potential ABBA deadlocks.
    2. Fix the improperly nested inode_unhashed() safety check by moving it
       outside the I_NEW condition block, ensuring it runs unconditionally
       on all cache-hit pathways to prevent false-positive filesystem
       corruption errors during concurrent initialization failures.

Changes in v4:
  - Check if the inode was unhashed during wait_on_new_inode() waking up
    to handle transient initialization failures (like I/O read errors)
    gracefully. Dropping the reference and returning -ESTALE prevents
    false filesystem corruption errors (__ext4_error), as found by the
    Sashiko AI bot.

Changes in v3:
  - Implement a new ext4_iget() configuration flag named EXT4_IGET_NOWAIT to
    fully contain the non-blocking lookup and VFS-level validations within
    inode.c, as requested by Jan Kara.
  - Skip inodes currently being created (I_CREATING), following Jan Kara's
    direct feedback.
  - Remove all open-coded match helpers and VFS state-checks from xattr.c.

Changes in v2:
  - Read inode state locklessly using inode_state_read_once() to resolve
    a lockdep assertion on cache hit.
  - Manually restore essential inode/ea_inode validations on the retrieved
    inode (is_bad_inode, EXT4_EA_INODE_FL, file_acl, and xattr checks) to
    match VFS safety guarantees and prevent using corrupted/failed inodes.

 fs/ext4/ext4.h  |  3 ++-
 fs/ext4/inode.c | 41 ++++++++++++++++++++++++++++++++++++++---
 fs/ext4/xattr.c |  2 +-
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..c76dd0bdd3d8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3144,7 +3144,8 @@ typedef enum {
 	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
 	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
 	EXT4_IGET_BAD =		0x0004, /* Allow to iget a bad inode */
-	EXT4_IGET_EA_INODE =	0x0008	/* Inode should contain an EA value */
+	EXT4_IGET_EA_INODE =	0x0008,	/* Inode should contain an EA value */
+	EXT4_IGET_NOWAIT =	0x0010	/* Non-blocking lookup (skip if freeing) */
 } ext4_iget_flags;
 
 extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..f6b681320358 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5270,6 +5270,24 @@ void ext4_set_inode_mapping_order(struct inode *inode)
 	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
 }
 
+static int ext4_iget_match(struct inode *inode, u64 ino, void *data)
+{
+	bool *is_freeing = data;
+
+	if (inode->i_ino != ino)
+		return 0;
+	spin_lock(&inode->i_lock);
+	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE | I_CREATING)) {
+		if (is_freeing)
+			*is_freeing = true;
+		spin_unlock(&inode->i_lock);
+		return -1;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	return 1;
+}
+
 struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 			  ext4_iget_flags flags, const char *function,
 			  unsigned int line)
@@ -5298,9 +5316,26 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	inode = iget_locked(sb, ino);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (flags & EXT4_IGET_NOWAIT) {
+		bool is_freeing = false;
+
+		inode = find_inode_nowait(sb, ino, ext4_iget_match, &is_freeing);
+		if (is_freeing || !inode)
+			return ERR_PTR(-ESTALE);
+
+		if (inode_state_read_once(inode) & I_NEW)
+			wait_on_new_inode(inode);
+
+		if (unlikely(inode_unhashed(inode))) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
+	} else {
+		inode = iget_locked(sb, ino);
+		if (!inode)
+			return ERR_PTR(-ENOMEM);
+	}
+
 	if (!(inode_state_read_once(inode) & I_NEW)) {
 		ret = check_igot_inode(inode, flags, function, line);
 		if (ret) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..21b5670d8503 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1550,7 +1550,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 
 	while (ce) {
 		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
-				     EXT4_IGET_EA_INODE);
+				     EXT4_IGET_EA_INODE | EXT4_IGET_NOWAIT);
 		if (IS_ERR(ea_inode))
 			goto next_entry;
 		ext4_xattr_inode_set_class(ea_inode);
-- 
2.47.3

