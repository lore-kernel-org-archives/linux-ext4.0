Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795340268;
	b=e4GotJQZPQ1Z21JUy0JqQkgzl6q+7Xbz2kV/DD666uoJYEEKnVtTICJRgmxrQDbWDQpj
	 pMfTRgVHiTgJgsbRKvSB6ilTJ/69UiwsdrP7z9RVaNA7va9lwNr1qTl3rOMmWkC0y150k
	 OiMvDC3Mq4PZ4uZLbM9oGEGlDVvIgcivFveUPr3F6T4VFhZW5M9MbNcSVGURyPSiGNhGi
	 MaroKc+QerjZ+JfmqjC2sYBG8uCwgEgE2vJMhite2GzZPoLsonuSJ865Ja9SGwcoN7pgU
	 z7ketLvrhhRo/taWugA4oRLQLw+30ktuGaUoPXXNTuNHfj2R9jXTDnp9qy0oXR5mIiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795340268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GWPFweQIXGWaluYtwoxtpGPAQ4sykKEaK8fKbVOZ4CQ=;
	b=hIi5NxaiY8QzIMF1F/pqtc1atW+1RlPZ6kTGAkhC2RZot/GiB3NrszN1OTfPB2zEJBGc
	 3NCvv/WWqhM9e1T7JeV7HDdm8CcYnqUWPVzRd3bkuF34DeXiVNuF554szcS/ygJEcH80+
	 B0F78AKJjx/SdsImheIMb3AcKSZVRiaYbjq5ony6/tdlKLxt6jLUW0ykywBbko+Kpn61E
	 0msMiLvYitTn5SUYf6T9tGmenKtyDDFAMb0yK18XqbAxk8NLiZFBupXeqiFsES4dyopnL
	 tfwgN+DoYEs8e3BoWR79Ol1pZ1AaIjPn7j4Zj4+JZ3az5O03rVVyrXeB3M2DfTKjKEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="L/UzKfrU";
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78332606A331
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 09:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78332606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L/UzKfrU
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55c35262674so18667031cf.0
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 01:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795340266; x=1795945066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GWPFweQIXGWaluYtwoxtpGPAQ4sykKEaK8fKbVOZ4CQ=;
        b=L/UzKfrUHI+oGj+7eeS7EzJhLBsvxC7xLyKZ5DwAT8wZf3Zdv/GJO/w2xinUAe8hlv
         VcCuXc34OLlpyG8pMAm2HMmrbcavPemsdFveH2d+y0fK5aLUwuD2kODJerSiQL5yIpzT
         pFKfU/pKKhwl5xGJd0Y9OvTxkGjZ+QlWV7a6GaIvU7fcUhokBUNV/Q1UBep30Jv6mrLr
         5qohNP/dZpd95D3za7g1DQKsku68dDtSstYBAVTg8dMGcKfjQpcxEdWB7aHU9pdbiKML
         EyJ7sd71cQm3gIza0+amf2tdd8BAw3EUPjChymjuFaKLEVLsaq/BZjLN/MRJzOoAcYrI
         PcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795340266; x=1795945066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GWPFweQIXGWaluYtwoxtpGPAQ4sykKEaK8fKbVOZ4CQ=;
        b=BXqMuhETQesEV2z4C1PXiiWrdMZtCkqce1ah3OE/Ys0Ut3Th2gIjkrQObom49F07W9
         0Ni0wRSd4ldNd4tPm6Ci8EKkH2RIsJ+yNAka92hUvM0+ZaSihLYxRqbs8/TXLjzWI9EW
         KTmQ8x7YLBqF4ec2R4Ubqm3Ae1+cjMOtVLe1eSCgTD+zz55+qU9SHPJRUUHG437yXOxT
         J7BreNtqJLxWMRCNCUR0E4f+ErTc60dKwg4jUnBtLOypFrUaqA6Mb9iR9BVHy36TTf/o
         ih39RMusQEAWAGhnwcju1ZMxaS7GHHXtqHn7xGX+gGURJeh9REnRWZlN+LXOSXX8YOV1
         A/iA==
X-Forwarded-Encrypted: i=1; AL+hErHlzt/RTXlVMbTkjSm1UdusSdNFDEQj8cfHC/QorYYJVEQ4gINJtWzfTP3srXmR2VFkE64kbSHWKm2Y@vger.kernel.org
X-Gm-Message-State: APuU4Z/yPv4U2gHBxGqcnLPm3AbemAJQeyeybHbDB3cUhR8jB23zERKS
	VhpIP7kVox1dUR9RSlRuRne7053raGMCKMPlA1w7o+/SCzxawAQAhhBQVuvZ8wrudiEFxQ==
X-Gm-Gg: AZFdTZcRf+jMzyvceGOli/IXx7KOdBVsMdbGMQ37YEqwU2qUtKiGV+VUyIpdLb2Kd3F
	Yq/IWnsJMFO0bC1YtJivQc4UBIuQ6GlQWgWMROvpSKug4Z48tXr4yPGzP3OwSfu9tdcpfWNi1wF
	+DQrj1AWbZTeXgONj/ZVdJSVSo1udh987INVde1S7p9Hll+lmOsJmoHL24OjVxp2Qb+cwJUFDjP
	9ntZs6oKpVsZxj34Esx8dnDXqrpGV0XetbnzyGg0wHGJ9EK0R4dG1PywrEBH1G9qWxTug0LaPaz
	YwDnLtkCP4B5UzI0ZpznrE8ZTe0l1LxkpEfhjIC4q72+yrM0rYK5rUYPRLpYLvIX9hClK1PuscZ
	pT8gjNRyhFQ2KqyL6auMxD5ADgeWoTiBJa4QFGmdvkKlu/AQiwPU6x/gi8eZ6g0sWXFIZZ7llFl
	9KOeFSgi9UoJlKqH9nsKv1EelCx+Awi3wblRbtcSz1fuvZCgKteprffbOnGHrlWuTzMVcXDDRA9
	hVXxyrJOKDgXUrkrcmt0Vdn/IUFhLRjFUbA/MoMvU1klwza13/J46dU/78WzEEvmYkVjQ104XGf
	s1cG1MiBjg==
X-Received: by 2002:ac8:5d89:0:b0:536:5696:e8c8 with SMTP id d75a77b69052e-55d769e4561mr150346201cf.28.1795340266100;
        Sun, 22 Nov 2026 01:37:46 -0800 (PST)
Received: from Sys0z ([2a0d:5600:6:ad1e::17])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882bf70sm70140051cf.11.2026.11.22.01.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 01:37:45 -0800 (PST)
From: arzuagapozosergio@gmail.com
To: tytso@mit.edu
Cc: jack@suse.cz,
	linux-ext4@vger.kernel.org,
	syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com,
	Ryuji Hiroshi <arzuagapozosergio@gmail.com>
Subject: [PATCH v3] ext4: bound xattr journal credits to transaction limit
Date: Sun, 22 Nov 2026 04:37:32 -0500
Message-ID: <20261122093732.136895-1-arzuagapozosergio@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261122084939.129223-1-arzuagapozosergio@gmail.com>
References: <20261122084939.129223-1-arzuagapozosergio@gmail.com>
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

From: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

When setting an xattr without XATTR_CREATE, ext4 reserves credits for
releasing an old ea_inode even when the attribute does not exist. On a
1 KiB-block filesystem with a minimum journal, this can request more
credits than JBD2 permits, triggering a warning before the operation
fails.

Look up the existing attribute and account for the work done when its
ea_inode reference is dropped. The final iput() and block truncation are
deferred to a separate transaction. Check the credit limit after reserving
space for the default JBD2 revoke records, and repeat the estimate under
the xattr write lock before modifying the attribute. When the target is
found in the inode body, also read the external xattr block so shared
block EA inode references are included in the locked estimate.

Add EXT4 selftests for the original no-XATTR_CREATE credit-estimation
path, large xattr creation and replacement, preservation after a rejected
XATTR_CREATE operation, shared external xattr block cloning, removal, and
a small user xattr round trip.

Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
Link: https://syzbot.org/bug?extid=25d45c0bd716f2b794a7
Assisted-by: Codex:GPT-6
Signed-off-by: Ryuji Hiroshi <arzuagapozosergio@gmail.com>
---
 MAINTAINERS                                   |   1 +
 fs/ext4/acl.c                                 |   7 +-
 fs/ext4/crypto.c                              |   5 +-
 fs/ext4/ialloc.c                              |   6 +-
 fs/ext4/xattr.c                               | 174 +++++++++----
 fs/ext4/xattr.h                               |   7 +-
 fs/jbd2/transaction.c                         |   9 +
 include/linux/jbd2.h                          |   2 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/filesystems/ext4/.gitignore     |   2 +
 .../selftests/filesystems/ext4/Makefile       |   6 +
 .../ext4/ext4_xattr_journal_credits.c         | 244 ++++++++++++++++++
 .../ext4/ext4_xattr_journal_credits.sh        |  56 ++++
 13 files changed, 455 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/ext4/.gitignore
 create mode 100644 tools/testing/selftests/filesystems/ext4/Makefile
 create mode 100644 tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
 create mode 100755 tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh

Changes in v3:
- Re-read the external xattr block for the locked estimate when the target
  attribute is in the inode body.
- Replace the pre-VFS E2BIG check with the original no-XATTR_CREATE case,
  preservation after XATTR_CREATE rejection, and shared-block clone coverage.
- Report setup errors separately, ignore the generated test binary, and add
  the EXT4 selftest path to MAINTAINERS.

Tests:
- make -j4 bzImage
- make -C tools/testing/selftests/filesystems/ext4 clean all
- sh -n tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
- Booted the patched kernel in QEMU/KVM; all 10 selftest cases passed on a
  1 KiB-block ea_inode filesystem with a 1 MiB journal; QEMU shut down cleanly.
- Confirmed the shared-block fixture used the same external xattr block with
  refcount 2 before cloning.
- e2fsck -fn passed after the guest unmounted the image.
- The host kselftest runner returned KSFT_SKIP because the unprivileged host
  cannot mount the disposable filesystem; the binary passed in the VM as root.

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ac5128b7..1debcbeb0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10131,6 +10131,7 @@ F:	Documentation/filesystems/ext4/
 F:	fs/ext4/
 F:	include/trace/events/ext4.h
 F:	include/uapi/linux/ext4.h
+F:	tools/testing/selftests/filesystems/ext4/
 
 Extended Verification Module (EVM)
 M:	Mimi Zohar <zohar@linux.ibm.com>
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 59fac55a2..07b351694 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -239,8 +239,11 @@ ext4_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (error)
 		return error;
 retry:
-	error = ext4_xattr_set_credits(inode, acl_size, false /* is_create */,
-				       &credits);
+	error = ext4_xattr_set_credits(inode,
+				       type == ACL_TYPE_ACCESS ?
+				       EXT4_XATTR_INDEX_POSIX_ACL_ACCESS :
+				       EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT,
+				       "", acl_size, false /* is_create */, &credits);
 	if (error)
 		return error;
 
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 318b2eaea..98afd33b0 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -203,8 +203,9 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (res)
 		return res;
 retry:
-	res = ext4_xattr_set_credits(inode, len, false /* is_create */,
-				     &credits);
+	res = ext4_xattr_set_credits(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+				     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+				     len, false /* is_create */, &credits);
 	if (res)
 		return res;
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 527f1f703..927b2e8f0 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -889,7 +889,7 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 		nblocks += (S_ISDIR(mode) ? 2 : 1) *
 			__ext4_xattr_set_credits(sb, NULL /* inode */,
 						 NULL /* block_bh */, acl_size,
-						 true /* is_create */);
+							 true /* is_create */, 0);
 		posix_acl_release(p);
 	}
 #endif
@@ -908,7 +908,7 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 		nblocks += num_security_xattrs *
 			__ext4_xattr_set_credits(sb, NULL /* inode */,
 						 NULL /* block_bh */, 1024,
-						 true /* is_create */);
+							 true /* is_create */, 0);
 	}
 #endif
 	if (encrypt)
@@ -916,7 +916,7 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 						    NULL /* inode */,
 						    NULL /* block_bh */,
 						    FSCRYPT_SET_CONTEXT_MAX_SIZE,
-						    true /* is_create */);
+						    true /* is_create */, 0);
 	return nblocks;
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5c310747b..21061850d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -949,7 +949,7 @@ static void ext4_xattr_inode_free_quota(struct inode *parent,
 
 int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 			     struct buffer_head *block_bh, size_t value_len,
-			     bool is_create)
+			     bool is_create, bool old_ea_inode)
 {
 	int credits;
 	int blocks;
@@ -998,23 +998,14 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 	/* Blocks themselves. */
 	credits += blocks;
 
-	if (!is_create) {
-		/* Dereference ea_inode holding old xattr value.
-		 * Old ea_inode, inode map, block bitmap, group descriptor.
-		 */
-		credits += 4;
-
-		/* Data blocks for old ea_inode. */
-		blocks = XATTR_SIZE_MAX >> sb->s_blocksize_bits;
-
-		/* Indirection block or one level of extent tree for old
-		 * ea_inode.
-		 */
-		blocks += 1;
-
-		/* Block bitmap and group descriptor updates for each block. */
-		credits += blocks * 2;
-	}
+	/*
+	 * Replacing an ea_inode xattr only drops its reference here.  The
+	 * final iput() and block truncation happen asynchronously in a separate
+	 * transaction, so charge only for updating the ea_inode and, when its
+	 * reference count reaches zero, adding it to the orphan list.
+	 */
+	if (!is_create && old_ea_inode)
+		credits += 2;
 
 	/* We may need to clone the existing xattr block in which case we need
 	 * to increment ref counts for existing ea_inodes referenced by it.
@@ -2375,29 +2366,6 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 
 	ext4_write_lock_xattr(inode, &no_expand);
 
-	/* Check journal credits under write lock. */
-	if (ext4_handle_valid(handle)) {
-		struct buffer_head *bh;
-		int credits;
-
-		bh = ext4_xattr_get_block(inode);
-		if (IS_ERR(bh)) {
-			error = PTR_ERR(bh);
-			goto cleanup;
-		}
-
-		credits = __ext4_xattr_set_credits(inode->i_sb, inode, bh,
-						   value_len,
-						   flags & XATTR_CREATE);
-		brelse(bh);
-
-		if (jbd2_handle_buffer_credits(handle) < credits) {
-			error = -ENOSPC;
-			goto cleanup;
-		}
-		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
-	}
-
 	error = ext4_reserve_inode_write(handle, inode, &is.iloc);
 	if (error)
 		goto cleanup;
@@ -2415,6 +2383,39 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		error = ext4_xattr_block_find(inode, &i, &bs);
 	if (error)
 		goto cleanup;
+
+	/* Check journal credits under write lock using the old ea_inode state. */
+	if (ext4_handle_valid(handle)) {
+		struct ext4_xattr_entry *entry = NULL;
+		bool old_ea_inode = false;
+		int credits;
+
+		if (!is.s.not_found)
+			entry = is.s.here;
+		else if (!bs.s.not_found)
+			entry = bs.s.here;
+		if (entry && entry->e_value_inum &&
+		    !(flags & XATTR_CREATE))
+			old_ea_inode = true;
+		if (!bs.bh) {
+			struct buffer_head *bh = ext4_xattr_get_block(inode);
+
+			if (IS_ERR(bh)) {
+				error = PTR_ERR(bh);
+				goto cleanup;
+			}
+			bs.bh = bh;
+		}
+		credits = __ext4_xattr_set_credits(inode->i_sb, inode, bs.bh,
+						   value_len,
+						   flags & XATTR_CREATE,
+						   old_ea_inode);
+		if (jbd2_handle_buffer_credits(handle) < credits) {
+			error = -ENOSPC;
+			goto cleanup;
+		}
+		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
+	}
 	if (is.s.not_found && bs.s.not_found) {
 		error = -ENODATA;
 		if (flags & XATTR_REPLACE)
@@ -2500,28 +2501,91 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	return error;
 }
 
-int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
+int ext4_xattr_set_credits(struct inode *inode, int name_index,
+			   const char *name, size_t value_len,
 			   bool is_create, int *credits)
 {
-	struct buffer_head *bh;
-	int err;
+	struct ext4_xattr_info i = {
+		.name_index = name_index,
+		.name = name,
+	};
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_block_find bs = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_entry *entry = NULL;
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	bool old_ea_inode = false;
+	int max_credits, revoke_credits, err;
 
 	*credits = 0;
+	if (!name)
+		return -EINVAL;
+	if (strlen(name) > 255)
+		return -ERANGE;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if (!journal)
 		return 0;
 
+	/*
+	 * The old ea_inode reference is charged only when the target attribute
+	 * currently points to one.  xattr_sem is dropped before the transaction
+	 * starts, so ext4_xattr_set_handle() repeats this check under the write
+	 * lock.
+	 */
 	down_read(&EXT4_I(inode)->xattr_sem);
 
-	bh = ext4_xattr_get_block(inode);
-	if (IS_ERR(bh)) {
-		err = PTR_ERR(bh);
-	} else {
-		*credits = __ext4_xattr_set_credits(inode->i_sb, inode, bh,
-						    value_len, is_create);
-		brelse(bh);
-		err = 0;
+	if (ext4_has_feature_ea_inode(inode->i_sb)) {
+		struct buffer_head *bh;
+
+		if (is_create) {
+			/* The target lookup is unnecessary, but block refs matter. */
+			bh = ext4_xattr_get_block(inode);
+			if (IS_ERR(bh)) {
+				err = PTR_ERR(bh);
+				goto out_unlock;
+			}
+			bs.bh = bh;
+		} else {
+			err = ext4_get_inode_loc(inode, &is.iloc);
+			if (err)
+				goto out_unlock;
+			err = ext4_xattr_ibody_find(inode, &i, &is);
+			if (err)
+				goto out;
+			if (!is.s.not_found) {
+				entry = is.s.here;
+			} else {
+				err = ext4_xattr_block_find(inode, &i, &bs);
+				if (err)
+					goto out;
+				if (!bs.s.not_found)
+					entry = bs.s.here;
+			}
+			if (!bs.bh) {
+				bh = ext4_xattr_get_block(inode);
+				if (IS_ERR(bh)) {
+					err = PTR_ERR(bh);
+					goto out;
+				}
+				bs.bh = bh;
+			}
+		}
 	}
+	if (!is_create && entry && entry->e_value_inum)
+		old_ea_inode = true;
+	*credits = __ext4_xattr_set_credits(inode->i_sb, inode, bs.bh,
+					    value_len, is_create,
+					    old_ea_inode);
+	revoke_credits = ext4_trans_default_revoke_credits(inode->i_sb);
+	max_credits = jbd2_journal_get_max_transaction_buffers(journal, revoke_credits);
+	err = *credits > max_credits ? -ENOSPC : 0;
+out:
+	brelse(is.iloc.bh);
+	brelse(bs.bh);
+out_unlock:
 
 	up_read(&EXT4_I(inode)->xattr_sem);
 	return err;
@@ -2549,8 +2613,8 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 		return error;
 
 retry:
-	error = ext4_xattr_set_credits(inode, value_len, flags & XATTR_CREATE,
-				       &credits);
+	error = ext4_xattr_set_credits(inode, name_index, name, value_len,
+				       flags & XATTR_CREATE, &credits);
 	if (error)
 		return error;
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 821dc6a50..47fd2a7c5 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -175,11 +175,12 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
-extern int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
-				  bool is_create, int *credits);
+int ext4_xattr_set_credits(struct inode *inode, int name_index,
+			   const char *name, size_t value_len,
+			   bool is_create, int *credits);
 extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 				struct buffer_head *block_bh, size_t value_len,
-				bool is_create);
+				bool is_create, bool old_ea_inode);
 
 extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   int extra_credits);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 85d84d909..5fe49f118 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -194,6 +194,15 @@ static int jbd2_max_user_trans_buffers(journal_t *journal)
 				journal->j_transaction_overhead_buffers;
 }
 
+/* Maximum buffer credits available after reserving @revoke_records. */
+int jbd2_journal_get_max_transaction_buffers(journal_t *journal,
+					     int revoke_records)
+{
+	return jbd2_max_user_trans_buffers(journal) -
+		DIV_ROUND_UP(revoke_records, journal->j_revoke_records_per_block);
+}
+EXPORT_SYMBOL(jbd2_journal_get_max_transaction_buffers);
+
 /*
  * Wait until we can add credits for handle to the running transaction.  Called
  * with j_state_lock held for reading. Returns 0 if handle joined the running
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e3886963b..a72f14440 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1523,6 +1523,8 @@ static inline handle_t *journal_current_handle(void)
  */
 
 extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
+int jbd2_journal_get_max_transaction_buffers(journal_t *journal,
+					     int revoke_records);
 extern handle_t *jbd2__journal_start(journal_t *, int blocks, int rsv_blocks,
 				     int revoke_records, gfp_t gfp_mask,
 				     unsigned int type, unsigned int line_no);
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 07c3719f8..c16b1132e 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -37,6 +37,7 @@ TARGETS += filesystems/binderfs
 TARGETS += filesystems/configfs
 TARGETS += filesystems/epoll
 TARGETS += filesystems/eventfd
+TARGETS += filesystems/ext4
 TARGETS += filesystems/failfs
 TARGETS += filesystems/fat
 TARGETS += filesystems/file_stressor
diff --git a/tools/testing/selftests/filesystems/ext4/.gitignore b/tools/testing/selftests/filesystems/ext4/.gitignore
new file mode 100644
index 000000000..d3678b52d
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+/ext4_xattr_journal_credits
diff --git a/tools/testing/selftests/filesystems/ext4/Makefile b/tools/testing/selftests/filesystems/ext4/Makefile
new file mode 100644
index 000000000..90569a1cc
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_GEN_PROGS_EXTENDED := ext4_xattr_journal_credits
+TEST_PROGS := ext4_xattr_journal_credits.sh
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
new file mode 100644
index 000000000..313e81767
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "../../kselftest.h"
+
+#define LARGE_VALUE_SIZE 65296
+#define FILLER_VALUE_SIZE 32
+#define TEST_COUNT 10
+
+static const char large_name[] = "user.ext4-credit-large";
+static const char small_name[] = "user.ext4-credit-small";
+static const char target_name[] = "user.ext4-credit-target";
+static const char filler_name[] = "user.ext4-credit-filler";
+
+static void result(bool passed, const char *name)
+{
+	ksft_test_result(passed, "%s\n", name);
+}
+
+static bool xattr_matches(const char *path, const char *name,
+			  char *buffer, const void *expected, size_t size)
+{
+	ssize_t len;
+
+	errno = 0;
+	len = getxattr(path, name, buffer, size);
+	if (len < 0) {
+		ksft_print_msg("getxattr(%s): %s\n", name, strerror(errno));
+		return false;
+	}
+	return len == size && !memcmp(buffer, expected, size);
+}
+
+static int create_file(const char *path)
+{
+	int fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
+	int error;
+
+	if (fd < 0)
+		return -1;
+	if (!close(fd))
+		return 0;
+	error = errno;
+	errno = error;
+	return -1;
+}
+
+static bool set_xattr(const char *path, const char *name,
+		      const void *value, size_t size, int flags)
+{
+	errno = 0;
+	if (!setxattr(path, name, value, size, flags))
+		return true;
+	ksft_print_msg("setxattr(%s): %s\n", name, strerror(errno));
+	return false;
+}
+
+static void report_setup_error(const char *what, unsigned int skip_count)
+{
+	int saved_errno = errno;
+	unsigned int i;
+
+	ksft_test_result_error("setup %s: %s\n", what,
+			       strerror(saved_errno));
+	for (i = 0; i < skip_count; i++)
+		ksft_test_result_skip("setup failed\n");
+}
+
+static bool prepare_shared_file(const char *path, const char *large_value,
+				const char *filler, char target_value)
+{
+	return create_file(path) == 0 &&
+	       set_xattr(path, target_name, &target_value, sizeof(target_value),
+			 XATTR_CREATE) &&
+	       set_xattr(path, filler_name, filler, FILLER_VALUE_SIZE,
+			 XATTR_CREATE) &&
+	       set_xattr(path, large_name, large_value, LARGE_VALUE_SIZE,
+			 XATTR_CREATE);
+}
+
+static bool prepare_shared_block(const char *path_a, const char *path_b,
+				 char *large_value, char *readback)
+{
+	char target_value = 0x11;
+	char filler[FILLER_VALUE_SIZE];
+	char target_readback;
+
+	memset(filler, 0x6c, sizeof(filler));
+	memset(large_value, 0x7e, LARGE_VALUE_SIZE);
+	large_value[0] = 0x42;
+
+	if (!prepare_shared_file(path_a, large_value, filler, target_value) ||
+	    !prepare_shared_file(path_b, large_value, filler, target_value))
+		return false;
+
+	return xattr_matches(path_a, large_name, readback, large_value,
+			     LARGE_VALUE_SIZE) &&
+	       xattr_matches(path_b, large_name, readback, large_value,
+			     LARGE_VALUE_SIZE) &&
+	       xattr_matches(path_a, target_name, &target_readback,
+			     &target_value, sizeof(target_value)) &&
+	       xattr_matches(path_b, target_name, &target_readback,
+			     &target_value, sizeof(target_value));
+}
+
+int main(int argc, char **argv)
+{
+	char path[4096], shared_a[4096], shared_b[4096];
+	char *value = NULL, *expected = NULL, *readback = NULL;
+	char target_new[64];
+	static const char small_value[] = "small-xattr";
+	char small_value_readback[sizeof(small_value)];
+	char target_old = 0x11;
+	int fd, path_len, shared_len;
+	bool created = false, replaced = false, shared_ready = false;
+	bool shared_replaced = false;
+	int ret;
+
+	ksft_print_header();
+	ksft_set_plan(TEST_COUNT);
+	if (argc != 2)
+		ksft_exit_fail_msg("Usage: %s MOUNTPOINT\n", argv[0]);
+
+	path_len = snprintf(path, sizeof(path), "%s/credit-test", argv[1]);
+	shared_len = snprintf(shared_a, sizeof(shared_a), "%s/shared-a", argv[1]);
+	if (path_len < 0 || (size_t)path_len >= sizeof(path) ||
+	    shared_len < 0 || (size_t)shared_len >= sizeof(shared_a))
+		ksft_exit_fail_msg("Mount path is too long\n");
+	shared_len = snprintf(shared_b, sizeof(shared_b), "%s/shared-b", argv[1]);
+	if (shared_len < 0 || (size_t)shared_len >= sizeof(shared_b))
+		ksft_exit_fail_msg("Mount path is too long\n");
+
+	fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
+	if (fd < 0) {
+		report_setup_error("create test file", TEST_COUNT - 1);
+		ksft_finished();
+	}
+	if (close(fd) < 0) {
+		report_setup_error("close test file", TEST_COUNT - 1);
+		ksft_finished();
+	}
+
+	value = malloc(LARGE_VALUE_SIZE);
+	expected = malloc(LARGE_VALUE_SIZE);
+	readback = malloc(LARGE_VALUE_SIZE);
+	if (!value || !expected || !readback) {
+		report_setup_error("allocate xattr buffers", TEST_COUNT - 1);
+		ksft_finished();
+	}
+
+	memset(value, 0x5a, LARGE_VALUE_SIZE);
+	value[0] = 1;
+	/* Exercise the original no-XATTR_CREATE credit-estimation path. */
+	created = set_xattr(path, large_name, value, LARGE_VALUE_SIZE, 0);
+	result(created, "large xattr creation");
+	if (created) {
+		result(xattr_matches(path, large_name, readback, value,
+				     LARGE_VALUE_SIZE), "large xattr readback");
+
+		memset(value, 0xa5, LARGE_VALUE_SIZE);
+		value[0] = 2;
+		replaced = set_xattr(path, large_name, value,
+				     LARGE_VALUE_SIZE, XATTR_REPLACE);
+		result(replaced, "large xattr replacement");
+	} else {
+		ksft_test_result_skip("readback needs the created xattr\n");
+		ksft_test_result_skip("replacement needs the created xattr\n");
+	}
+
+	if (replaced) {
+		result(xattr_matches(path, large_name, readback, value,
+				     LARGE_VALUE_SIZE), "replacement readback");
+
+		memcpy(expected, value, LARGE_VALUE_SIZE);
+		memset(value, 0x3c, LARGE_VALUE_SIZE);
+		value[0] = 3;
+		errno = 0;
+		ret = setxattr(path, large_name, value, LARGE_VALUE_SIZE,
+			       XATTR_CREATE);
+		result(ret < 0 && errno == EEXIST &&
+		       xattr_matches(path, large_name, readback, expected,
+				     LARGE_VALUE_SIZE),
+		       "XATTR_CREATE rejection preserves the old value");
+	} else {
+		ksft_test_result_skip("replacement readback needs a successful replacement\n");
+		ksft_test_result_skip("XATTR_CREATE check needs a successful replacement\n");
+	}
+
+	if (prepare_shared_block(shared_a, shared_b, value, readback)) {
+		shared_ready = true;
+		ksft_test_result_pass("shared external xattr block fixture\n");
+	} else {
+		report_setup_error("prepare shared xattr block", 2);
+	}
+
+	if (shared_ready) {
+		memset(target_new, 0x22, sizeof(target_new));
+		shared_replaced = set_xattr(shared_a, target_name, target_new,
+					    sizeof(target_new), XATTR_REPLACE);
+		result(shared_replaced,
+		       "replace inode-body xattr with shared external block present");
+
+		result(xattr_matches(shared_a, target_name, readback,
+				     shared_replaced ? target_new : &target_old,
+				     shared_replaced ? sizeof(target_new) :
+				     sizeof(target_old)) &&
+		       xattr_matches(shared_b, target_name, readback,
+				     &target_old, sizeof(target_old)) &&
+		       xattr_matches(shared_b, large_name, readback, value,
+				     LARGE_VALUE_SIZE),
+		       "xattr block clone preserves both files' values");
+	} else {
+		ksft_test_result_skip("shared-block replacement needs its fixture\n");
+		ksft_test_result_skip("shared-block readback needs its fixture\n");
+	}
+
+	if (created) {
+		ret = removexattr(path, large_name);
+		result(ret == 0, "large xattr removal");
+	} else {
+		ksft_test_result_skip("removal needs the created xattr\n");
+	}
+
+	ret = setxattr(path, small_name, small_value, sizeof(small_value), 0);
+	result(ret == 0 &&
+	       getxattr(path, small_name, small_value_readback,
+			sizeof(small_value_readback)) == sizeof(small_value) &&
+	       !memcmp(small_value, small_value_readback, sizeof(small_value)) &&
+	       removexattr(path, small_name) == 0,
+	       "small user xattr round trip");
+
+	free(readback);
+	free(expected);
+	free(value);
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
new file mode 100755
index 000000000..365bef975
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
@@ -0,0 +1,56 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+KSFT_SKIP=4
+
+skip()
+{
+	printf 'SKIP: %s\n' "$1"
+	exit "$KSFT_SKIP"
+}
+
+[ "$(id -u)" -eq 0 ] || skip "requires root to mount a disposable EXT4 image"
+
+for command in mkfs.ext4 mount umount truncate e2fsck losetup grep; do
+	command -v "$command" >/dev/null 2>&1 || skip "missing $command"
+done
+
+grep -qw ext4 /proc/filesystems || skip "EXT4 is not available in this kernel"
+losetup -f >/dev/null 2>&1 || skip "no loop device is available"
+
+test_dir=$(mktemp -d) || exit 1
+mounted=0
+
+cleanup()
+{
+	if [ "$mounted" -eq 1 ]; then
+		umount "$test_dir/mnt" || true
+	fi
+	rm -rf "$test_dir"
+}
+trap cleanup EXIT INT TERM
+
+truncate -s 32M "$test_dir/fs.img" || exit 1
+if ! mkfs.ext4 -q -F -b 1024 -O ea_inode -J size=1 "$test_dir/fs.img" \
+		2>"$test_dir/mkfs.err"; then
+	cat "$test_dir/mkfs.err" >&2
+	skip "mkfs.ext4 does not support the ea_inode test image"
+fi
+mkdir "$test_dir/mnt" || exit 1
+if ! mount -t ext4 -o loop "$test_dir/fs.img" "$test_dir/mnt" \
+		2>"$test_dir/mount.err"; then
+	cat "$test_dir/mount.err" >&2
+	if grep -Eqi 'permission denied|operation not permitted|not permitted' \
+			"$test_dir/mount.err"; then
+		skip "mounting a loop image is not permitted"
+	fi
+	exit 1
+fi
+mounted=1
+
+test_bin="$(dirname "$0")/ext4_xattr_journal_credits"
+"$test_bin" "$test_dir/mnt" || exit $?
+
+umount "$test_dir/mnt" || exit 1
+mounted=0
+e2fsck -fn "$test_dir/fs.img"

base-commit: c44104f3642da720164042623e4832836aefdd8e
-- 
2.56.1

