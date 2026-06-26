Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE19E3CB2C5
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 05:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452922; cv=none; b=NTZ88jF/uHwTdHH3vTZFmqJzFpyW4RLBFJ8y5XVEXv+SAv6Ib6q4HswLDxs1P3cBcIgEZAy4ABlC8fjioFhIII20CrQGqt+bvUbAnPxsisjrIq6diNMfzQJE+HZR7Q955ypBedqNB2akBYJUv6OsQ6duk41EqDbVSVIDZI0EYQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452922; c=relaxed/simple;
	bh=xe75FNILl7Rx2wvuARs3wkjGb0UF2irJHf9qRP6in8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e7AtKUONVogQpYwo1OZrkSRemyGXb8DBps1/sd61mjjueu5o20++Sgt1DH0yeeq/C9pKnI7rQ6vZLaQnYu83nY2BpLgkfGLoSruo4jkA+9hcjIRgmJefvAPBas5uMM8uhcQ0amIWHOyrUfZyW/YcauylNjCWozZCa5U9G+Ucn+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjUKf9UW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjUKf9UW"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-845b8193c52so382858b3a.2
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 22:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782452920; x=1783057720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jAqiwasc7AbsCyt3HMhEJjgMaRjlcGDlYPEAXt/ReXA=;
        b=LjUKf9UWuwCbxqRwIBAYIzLVLD/5OuBRT/2xVBr07dITuiqxjfEWcyyW2YFe0dQ8Jf
         4/uWhcLRIQ48sRoCTt7ZL7V9KX7Px9RX19BWEGuodd+V0YZp6qw1OmvIyWnC0xCCdxpn
         1nE/hzwNLSgO/uFvXwGeZsSkbmAvHHMjI4n80If03rDegEODG+fBg0ESYn9ZR9a+mcom
         daSKN3s3BuciG3gi9fzWw4pw/Eb4YmqjDufVsXy2DkBIQIjp4RtIktguWFgYZfkmUU4e
         dwgBLUnFI77vfvMojX6Jr5mwzeVPIdI3w8tYWjEoeZrDg4MYdij0ED5oCsvhtffn3NFE
         jANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782452920; x=1783057720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jAqiwasc7AbsCyt3HMhEJjgMaRjlcGDlYPEAXt/ReXA=;
        b=r/h18udyCcRw1lFxTCZUipf0/wxKnmgWmrF9Rwd49QDoV0OwMYfLUsbzNldGEidu4e
         zOYh632b6XoY8VrGygh+uSisyve7WS3vjZA6UKacm4Rqi2Fa9jW+cA7Rbz06RyI1u+rj
         EogH+RTCLEukbX92wTzAS8TiR6Mm4dhs/fxIGFWQR0p5tqYGAHno8VHNI+5TpoqqdqRJ
         DsELS8RCnOpxUEQtMMusTPkhqrU5xHXLP7Ml/z8/Fr54WVefrSwce9DdAkaoeesJwiKI
         goSsNtnUuoIEdJgaiuBPl7gE2cg7Xd/eohKU9z6fdO4P4Gj44oPbFoyCn2a0It+/7LIo
         tMHA==
X-Forwarded-Encrypted: i=1; AHgh+RpZCbkfIUThNq7ct3pd/YyFhs89+yFhs6tzB04H647Kx9dSolitUtllVH23IbwZTAB/9tir2r9+Qaai@vger.kernel.org
X-Gm-Message-State: AOJu0YxsPWPj3x7kuW7mGiR7Pjbk0/296iAHcm/DljV/5BLTx9SoFXZ2
	G9yhEJ9BvR8GZBAVQ8560BOabV9YbYKOc9gjzXRb9ED4f4e/7JApscLx
X-Gm-Gg: AfdE7ckhFrdTmY9kHpZmexzfFQbg0RzSagNLYo8Z5ZDhGu1QLsp+PsYgW5rLcU8hYY4
	FECg8RrniTFGjFqOZdNH4z31EkEpll/hp+6tbURwehcoWZ1vWqRUbkyHbf4j1EQvXu6bzzt5oSK
	pSpcElg6Eucpb7ZdTpdRdBmlBg+Vg9n231sEZYYUdqAvRzl/7Y5PYD2FzsGMuzqG5PXYI9YP5Mm
	ag+M46KzIBCNMGV+Sl8rS6jHUZJTALvt7+xsv0Q/BuzLcV/PkJqdouU0zts+pxDMbGw/Pm5i3MD
	/V6/SBRi4Z+OnU70nb0Lef+laDZhMehEpmR63rinGEwZbzjLXStiQmh0ubZeN9TEUiKVtwkBHkJ
	fnQ0HsuJRvHJ8uuxvSxyf9E4ZgVpbOH/HxVGGKFAiuAzIo+cg88J1uxtzXToz5U4zO1a6D8BGw+
	rdaxBHkqr0u/wUEzp6XY5qRzmSm68gkcJfAU+Xa7tbdnwy7RxMgXV+CxvfD0lp9+RFzbIaNacQN
	s/Ts+5H+uFfeszlzAmbRvaFRr1cIS1xxKSJn+SBM+/FPa3H1vw2BlABIsDYJXGABcwd43VUc/7y
	nnfjQHujp7yoJbDn5BQDxh4y+3bT
X-Received: by 2002:a05:6a00:94d1:b0:845:4928:8645 with SMTP id d2e1a72fcca58-845b3a9c2a3mr6836324b3a.7.1782452919792;
        Thu, 25 Jun 2026 22:48:39 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (247.226.198.35.bc.googleusercontent.com. [35.198.226.247])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845c81922fasm591634b3a.1.2026.06.25.22.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 22:48:39 -0700 (PDT)
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
Subject: [PATCH v6] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Fri, 26 Jun 2026 05:48:21 +0000
Message-ID: <20260626054821.1729-1-aditya.ansh182@gmail.com>
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
inode cache (cache miss), simply skip it (returning -ENOENT) rather than
waiting for eviction/creation to complete, breaking the ABBA cycle.

Since we return -ENOENT immediately on a cache miss, we never attempt to
allocate a new inode or call iget_locked(), completely eliminating any
TOCTOU race window.

If the returned inode is I_NEW, wait for its initialization to clear via
wait_on_new_inode(). If initialization fails and the inode is unhashed
during wait_on_new_inode() waking up (e.g., due to an I/O read error in
another thread), safely drop the reference and return -ENOENT. This
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
Changes in v6:
  - Drop the redundant is_freeing tracking variable completely, as pointed
    out by Jan Kara.
  - Return -ENOENT instead of -ESTALE on cache misses and unhashed inode
    checks, as requested by Jan Kara.

Changes in v5:
  - Address two critical concurrency issues flagged by the Sashiko AI bot in v4:
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
 fs/ext4/inode.c | 35 ++++++++++++++++++++++++++++++++---
 fs/ext4/xattr.c |  2 +-
 3 files changed, 35 insertions(+), 5 deletions(-)

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
index ce99807c5f5b..a091a43959a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5270,6 +5270,20 @@ void ext4_set_inode_mapping_order(struct inode *inode)
 	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
 }
 
+static int ext4_iget_match(struct inode *inode, u64 ino, void *data)
+{
+	if (inode->i_ino != ino)
+		return 0;
+	spin_lock(&inode->i_lock);
+	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE | I_CREATING)) {
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
@@ -5298,9 +5312,24 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	inode = iget_locked(sb, ino);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (flags & EXT4_IGET_NOWAIT) {
+		inode = find_inode_nowait(sb, ino, ext4_iget_match, NULL);
+		if (!inode)
+			return ERR_PTR(-ENOENT);
+
+		if (inode_state_read_once(inode) & I_NEW)
+			wait_on_new_inode(inode);
+
+		if (unlikely(inode_unhashed(inode))) {
+			iput(inode);
+			return ERR_PTR(-ENOENT);
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

