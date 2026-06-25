Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CA21624D5
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 06:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782367431; cv=none; b=li7ZxokVNGeHqNV00PySvpsj23LBGYVd4BdiCCzL8wbCnWFze2XRLqSV0FuQdtqqzkeCdQaEf0yf6BUybaQIc28r1QtCHYEVhiUX2+FhKEbO1wmKwj8BMmVkXSlrm6yoO1jQS8Fip/l51EjJSMSCLcw7BLMRYKewcKjZn7nEmWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782367431; c=relaxed/simple;
	bh=KCzcyH/UDRloiA+NJ/vg00W6sE/ImMrWgdGzn0L5388=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t0u2SR/YApHD45xO9py61WOYwQiPNNgzxuY4A7XprO3ke+WH3UDMLYzxkZUouxpgNvJYtYsDR/oI+RrzDyzMRsha53WkPmjkr5VPJBt8gwtiQEHmpGQsWuTsQsFTLMUFdQ7Hoblz74qYvcbaZjukkA7FkT5ufYK53UkJf+cAzbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkBWQY74; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkBWQY74"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84347ad88edso2203790b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 23:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782367428; x=1782972228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k6d4QQJGCrdmioK6u5IBx0CUX6juuCN1ItOWyh0tHRM=;
        b=bkBWQY74elVfvTK3jtNee6bPtAfoR4YX/48GrCcP3EbD3hE+uewKG07d1qBbF4O13e
         qqzZPotRto8bz+kMtUtznqjVnzhyAr+AsmLTqz0hE2WgW8xuHpNnAyiMUubO82/BKc1i
         kPZfaY0PGb/RmNKuRD1z6oLSqXYKD4uvTPYW+T+QK30zdUsJnsi3wnsv8DPcCUe/gYB/
         /Suc20d7zLKau0GYzwNHcnYuR3U8ZhXyqYR30Vy+SQBrAeB3H+YsR3BC5pFQcYD7hgp9
         f6V/BcCzs43GLaFQDXBb5ob7CmG0nFL8vc4Dn/S5dS2z6AiQsPK+oGeSbh4Tv2f6ji/V
         zM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782367428; x=1782972228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6d4QQJGCrdmioK6u5IBx0CUX6juuCN1ItOWyh0tHRM=;
        b=NMeDlpg/APNXHG6tBXRENcKY6tewLrPsG+veqN5mvOD4g9yR0uqMbkKV174m+Ns4uQ
         Jc7ynAxTit6gRyk9+ZdKRLYC03GjY0trKLQnmAx7A/FioL6gVZ3bslPdNKCzWPNuD6R5
         /40WfFrCqsq9dItWgVOjlaFhWYPGzZTT/5FoX2Tzzzpekogs7O5qN6CiIQ1bTL3EH2pl
         CO4cQayA4jQ2k8/GlO2ymALDleRlkrhfq/Ap9V6keHsiQkntfny6oQLxGL9JiXF49O6U
         uiAaqIpMWqnd+PomknR1tRYPWIbnHgaN7llJwVJOKkByVQHWsbynD8YKmbfQKWOu7pqj
         6ELQ==
X-Forwarded-Encrypted: i=1; AHgh+RoK50SRwHuMGBaUrlxC23Tb7Xl5O9+0qA2za72MU4Rmyc+GmEQvMpslJGQJdj/5j7cCjG2xPStMZKf8@vger.kernel.org
X-Gm-Message-State: AOJu0YwB9L1VyafyR8cf47xaHq0Aj4fRVcMqe3Zz7MDrARVAr4EnQTLO
	unV9Qtinp6L1Ox4HCy+CO/jfWlsqOYU9b05SqZSvr7L3Tg4hOHvkxpGc
X-Gm-Gg: AfdE7cn9EoM4ZQnZpBNhO9Hidx9omGzh58ubciUR+/YqoQUhghYwQESbNLAeyW1U7lv
	EMSSGPXj2smt9dtrq04fgoT4uB7XlNUUDBo3pK0BnmWoEj2JlxjXkw4UtylHK8s1cq5xo+xe28k
	A75zZha3w8AXqJ6sX8qY9SJkAWvnxifEMYRpDBKp8QQF8ZBVvGiN2Oj6SSTMr7xYkT/cNI3G2Hm
	+5kZdSHW3Kem8FZ1sLjBSWTLtTY6tvkwCaxzeSI032xCTcaq4aO9BEGkg9EC/vnFSfDT40T3vad
	gzNq3yL6vAylIsBx7bFcwueyGJtn6ilsiGHlA0l2uZUS579n/7+ZMt0tOGrdIDet05JLaG9UKbO
	qWh5riQQKBdbaCWtdcj4TbTGwIUrhEWTgRhZpkYIFHGnNfK3wRo0MV38yUZ+6rIg3P7R4SfZz1a
	uCEWoL/nWCSFZuD1bAGi4d3uZ9YUiVPKn+EZwdNuctG+/kfqcqAc6MRfyoNiDUMMpubhrGmKjjh
	3sTh0rymOrGeusl79PIIRrnOn1rfbqZ6oZg1K5dsa/OYggnRlsHYjAuETXNabHi0n74EhyDuoK8
	IBEPj69FuFgocaXye7LyZs+XRw==
X-Received: by 2002:a05:6a00:12e0:b0:842:55b6:f5a1 with SMTP id d2e1a72fcca58-845b3a9c2bamr1643707b3a.6.1782367428055;
        Wed, 24 Jun 2026 23:03:48 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (236.238.21.34.bc.googleusercontent.com. [34.21.238.236])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a3fcc696sm3953321b3a.4.2026.06.24.23.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 23:03:47 -0700 (PDT)
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
Subject: [PATCH v4] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Thu, 25 Jun 2026 06:03:31 +0000
Message-ID: <20260625060331.2189-1-aditya.ansh182@gmail.com>
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
I_WILL_FREE) or created (I_CREATING), simply skip it (returning -ESTALE)
rather than waiting for eviction/creation to complete, breaking the ABBA
cycle. If the returned inode is I_NEW, wait for its initialization to
clear via wait_on_new_inode().

If initialization fails and the inode is unhashed during the waking up of
wait_on_new_inode() (e.g., due to an I/O read error in another thread),
safely drop the reference and return -ESTALE to cleanly bypass the xattr
cache entry. Finally, standard validation checks (including is_bad_inode,
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
 fs/ext4/inode.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/xattr.c |  2 +-
 3 files changed, 46 insertions(+), 5 deletions(-)

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
index ce99807c5f5b..75ed467f5abf 100644
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
@@ -5298,9 +5316,31 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	inode = iget_locked(sb, ino);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (flags & EXT4_IGET_NOWAIT) {
+		bool is_freeing = false;
+
+		inode = find_inode_nowait(sb, ino, ext4_iget_match, &is_freeing);
+		if (is_freeing)
+			return ERR_PTR(-ESTALE);
+		if (!inode) {
+			inode = iget_locked(sb, ino);
+			if (!inode)
+				return ERR_PTR(-ENOMEM);
+		} else {
+			if (inode_state_read_once(inode) & I_NEW) {
+				wait_on_new_inode(inode);
+				if (unlikely(inode_unhashed(inode))) {
+					iput(inode);
+					return ERR_PTR(-ESTALE);
+				}
+			}
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

