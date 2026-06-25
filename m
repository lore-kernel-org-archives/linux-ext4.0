Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A50A2C027C
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 04:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782360598; cv=none; b=kAA5onGylh8q1wMHK90/fJKgMbrP4KiuCvzoPZTHHKn7uvh8SILvbtGinFbgazJSiwXrQblwwcORvcdlk5cDyY/mKSVCeQy8VoVh123RFeB3GkmIv/U7w8fsXRPVlZK8LTdX4pTst0JQU8vcR0oIllUS23OdIZIuXyynEWROoTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782360598; c=relaxed/simple;
	bh=NVbWg0c0bIjnP7un6x2nk2wfEFF4yb6rURz8f50dCVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G++4labAP4nESKs6wopXK1+FQ/p9Fl6yWQueK3itYp8HL2xHQyqO5PwWIM58JWoUWa8zHzXPlfGDDdJZIosyFxL2rP0Ju+okmeBivKwfA47ytvzP/rgDPLiE0NRgpb0LAd51VCJmJ3IQYJIg3D3apLwBgO4c7BYhoM48+LKAEdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qB+rysml; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qB+rysml"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-30bc871ecdfso2098574eec.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 21:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782360597; x=1782965397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1cXsNH6ajmormroD9gHzyiRu/jCQ70ZBI9PHsJKrNFU=;
        b=qB+rysmlebQZcSzW5z5TCXrdz48VGXvnRed0duGQSM8u3a++NZBt819kB8IkIdddYx
         wBOZDoafHTQ8OIQBBl9Uy8DScYsW2SNcaXVmQgJcGMz2pUv8DM1xajmcLldLHhvrTias
         s+wZ+oJRW7o75OAeaG1YU+o/bXtiPohH7S8trfzXg/IMVaYl93xNjT2KGmsyE8YOnsl2
         zRE/Nf7fCEhl4le+knIJx0jaJgOxPjS5RFwvGrnjd1l4j4KKqxDkh3hfGINmPo0LrcCD
         4yBaBOetQTfsVy7IvGHQGD/cRhXmz36dkonbsCvL+HjqPI53CvwIX0qNd9BX4hGgCYqP
         3Y9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782360597; x=1782965397;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cXsNH6ajmormroD9gHzyiRu/jCQ70ZBI9PHsJKrNFU=;
        b=HXFrlBcd4dXHUSI4iX9xVHSO8+HxXGRQd9/RPxX4DIq3uAYLNtyiD1o30661AHyDFQ
         yfBsnHtREm9NYBkKqRkOUKd897+5hLRTy8FZ8E54SeVbL4708YUIlTK/w8yZYRXSbONI
         zv+Ie4Vdc5U2ma+sKTZ9HQ/wGd6RfhWZyIRWnefsXnHDQU7HSW6Ds7EpFQl9YHAC8RUL
         PpfIr6rZ1LUeBAksn5NQTjWn++7YG4nu+ECSlaZFb8MNAUbLpT/UpdCMFzJ8xpCt+vqS
         WEqk5IMXczEITdk3Y7bwRFxI+nB044uxz/FU1IWIA0982CIKrFsuDpkhWTCNkQdIn2xT
         PUog==
X-Forwarded-Encrypted: i=1; AHgh+Rp6vGmKQz1H+/74MQKjAaznzBFUOU0/ULfIf9PcReTOYusiFFQrvFXnPOqFoZGR/Izb6xE3fFGoWxer@vger.kernel.org
X-Gm-Message-State: AOJu0YyGQ8jvFJT1aiud3PQWFEJ/Lev/EPh6KVgwSt0aNUtB6mFmwMYw
	mk+Re4LN5P1bHrsK+CR7o+5GEz4BXon4/fDsRLNR3CFVS37oAzPxItVp
X-Gm-Gg: AfdE7ckHeaYPU2OpD8h2Nh/z1BbIMjdOvlUS1/wcqiq6SqnL+NejAavJLFjl0wi8yZM
	TLHGKKG+RXYwoNXDXjgGk8jle/yDAFia/f4o2UU+7WiPqFCPGbLj+6LMdBIx0TfRcA9+enc59Rq
	CHLhgcHrUa6DVHn3vddH8HT9os9+vC3t3UnVCbZx86LI95BPO+zmn+Ld2LEuPHRIRJ9iosQsUgA
	j8ltrtP/GmElmTqdU9JDFt29OBxNNsaJSKEHhC89+dtdDVKtWYF4PtFX85hDxEt9CQ+vilAl7zs
	//lzbwjwUxBZBGYPGjSe3W72Oc0GQ4K1rFRVQcs7mqQLFTyHr6jRQCoFkaujDurCvPNpLJ4g+/8
	dFirr5JwlylQhRXUHdCV/Pps8KBNolnCElXcqracXe0HDsbLK/5b5dy8an3VZhZmvoJziSIorI3
	gWMuPkdquSvm8VrDMtsA+yLtILAnUCZt4QzpNJvIx89McLTEVwjcWZwabJqQJJJ0ovxuuDH3Q0i
	nsUGd/Ss//mDTNcdxkaHc/gh113dwTl5UK+BAIurKRJiA+ERjNwkdODc5J6VPXEzy5mZgysRu0t
	RXvsBWTuNpKV5AN+GjjXmgg=
X-Received: by 2002:a05:7300:8c2c:b0:30c:2af0:1cc with SMTP id 5a478bee46e88-30c84fdf0c5mr1230022eec.34.1782360596583;
        Wed, 24 Jun 2026 21:09:56 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (172.19.87.34.bc.googleusercontent.com. [34.87.19.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c8b1ae5sm4307151eec.16.2026.06.24.21.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 21:09:55 -0700 (PDT)
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
Subject: [PATCH v3] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Thu, 25 Jun 2026 04:09:35 +0000
Message-ID: <20260625040935.2244-1-aditya.ansh182@gmail.com>
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
clear via wait_on_new_inode(). Finally, standard validation checks
(including is_bad_inode, EXT4_EA_INODE_FL, file_acl, and xattr flags) are
executed as normal inside check_igot_inode() to fully guarantee VFS-layer
safety.

In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.

Suggested-by: Jan Kara <jack@suse.cz>
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
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
index ce99807c5f5b..42a798f333d3 100644
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
+		if (is_freeing)
+			return ERR_PTR(-ESTALE);
+		if (!inode) {
+			inode = iget_locked(sb, ino);
+			if (!inode)
+				return ERR_PTR(-ENOMEM);
+		} else {
+			if (inode_state_read_once(inode) & I_NEW)
+				wait_on_new_inode(inode);
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

