Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795584129;
	b=0NeNLk/vrYDmOIGpmTjL9fRbzkz/voLxDPsUa8p1r0bQLRSvl8X23SHj6Olpvj6EMOn+
	 X1ra6y5/JVRnwU2Cc23Bdrlvqk9niAZ7kpsWYk6Dxduv/ctR+hYuQq22X5uzYRVuD30PC
	 8QwR65G1O5yRR3LyAeftEaC2+IUqqFNJ25SnQzWo1HYP5eBIjxbH/5s7hAVpQzMcr6QSk
	 5iG86GDm9gHT3qaBGN9g5WLhr4KL4MSGMIB3Pgxe1BK0LKB0Q328RldooMWu64BoIZHhC
	 9BDD1dMEFRylvMSNzqUxp52fqQkf1NbpbiTpZzrM9R30kJCGIRTpyS5FX4WBAd5PkhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795584129;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vl7UxncZZQc2LHZ7jQrMLvLCnoskIykkdFYjtLaXJRk=;
	b=3xngLKpqWeIsi/L9Fsgd5UVGc8YOO70MQYQcWPpqp9rlxDml65kvVm1LpS/xf62MRx49
	 3/YcOKPNW77xrC+f8ZVAO007BXXCszSKjdT3P/gymzPScgxm8mksYj4dCHgi2t73nZzCT
	 rc8Bc93X6BPG9YAMKJa4z6Kdd8FwvrltHp7rmUs3idv2lkBW1kCp2BEHtCXaYZhLMKY+n
	 oiLAyhzxGbCAuR47AfI+3/ynnK7PP1wUwqnoD1cITvfJPC/h/pp2rPES3i7LuOotj8Y7a
	 fXRBJO4KS1JsIgMY5wkyCg82SIWL51uNqPJ2awrVGVpf8L3wnlxmPjlEZhGqWZ1tbpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=onrUOYxo;
	arc=none smtp.remote-ip=209.85.222.47
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32D3606A32C
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 05:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E32D3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=onrUOYxo
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so2915435241.2
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 21:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795584128; x=1796188928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vl7UxncZZQc2LHZ7jQrMLvLCnoskIykkdFYjtLaXJRk=;
        b=onrUOYxolakFaQkzNbyxwdtaGcrL41AjK/mBAfmtGKUrKEJw11+vrJ5aYsPlXNdWx0
         LUD1S5O0cNSNcpb/LPbQWamYXyKAp7PjsNCGMkKHA5zFTNRUPays4IDjNEw79foaqnnw
         vvuFuEEfu7GhHK50kCMQN7VLywTLIm3fxMkckSTd058CBIxCVVoLdwIesymUPumvB3kj
         vWFykkKl3rhiTUxNO4jt5P4aFdzeCs70L0584fL1pf4s/x3LpsZ79H/sOz3948MdXgDt
         gQAF8gJWk+DceRe3lAHaI77J0wFqFhQWgFjgXdu0VmiqTYuHpQGRZ8MS8J3H4/uoZWrU
         tHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795584128; x=1796188928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vl7UxncZZQc2LHZ7jQrMLvLCnoskIykkdFYjtLaXJRk=;
        b=AMOuKgCcG1mvQwWDeBUbRHxQIkJPk39oqB3IUNnBxImH1Spup0fP2pjD9YQL6w3YUS
         Y4F6hcEKqnWABJFrnK5cd0V7Xk9vyU+A12bUOwmFxWWHlKMyxap4O0H3NlfI1v6lvdgD
         0l22rKT8XNSw86gXQKYx5i4HOWmRmbRqKCKqnRkhZ/fQd+zEWJJ4fC/2PjKlfOVeo/48
         DHiJJ6uPWF8FYwYfOn4IOtB5Yv83C5P/sjLEI5cF/ztEdKToronQidk52R9KQTfJ6jXV
         aDG1q4qeQEH0pDinJsCWp97a1xGgNST/el7qyTgJzK6ifT088NoRRN5I8JSTHzGHnj2w
         I2BQ==
X-Forwarded-Encrypted: i=1; AL+hErHHqo9PxcMplMHQde5qsQfB34c62swM/CCmsZhIcOG5QEj+VB1oXI+NplwuYCf6v/4YEN/nJ3iW35lH@vger.kernel.org
X-Gm-Message-State: APuU4Z9z2S6Sc/zVvxAsvmTJ2zr3uXVNLAVBe9r/JGGdKxL49U7BSNan
	MlHXHGP1izblHRKqc5jOZylIIL8cAbPt4uIo+u522KUmmS9MyUPJu7oI
X-Gm-Gg: AZFdTZccjRBpk/XlzrkwjyRf3N36RkV2ygVc01KpEX+/JQR57FaonhQ73tr71wNK0PT
	DWi79bdc7KMn1CbN3VYZ51awlWY9vruW2Dihc1ToQrHhU2t2GZXC8ZpsTMWsTGNiR0t/imkkgjV
	jDkz9myzXJkJHhBg1BORxwE0kVJxkRilz4YJ7yVUsm8AlfSkJ23RHtuSGabiI1F+HCjW/Ydmwvz
	4tidQfAWbY9aE6HkrQCBKlALtWOsKkvwP31TmNpc+heGLaUd4/ePvZRuNUokKOAl5Sj3GXNgXAK
	vHJ4REzHuXDlV61ziqHWUDw64WbgldBlpb5OToS1EQDa46yRe0XFx0qthUE/KtlSLRyze1lvDld
	ene3FbmJkWVFjS5o9bYyJEPuyHer49IQf+8RzQX7/MIp/zwtsGk+UIqwkZDbhSPRtWa6X8U06Ct
	VoHylfLrmrsBqM5OeIEUpAWjGSm0QQrWHwNWqUyEeEafF69QblEdp1msDKtKx+wvvMacki3S1LA
	DckDZ/0oT7IPnggc9vIGfkavpb+dxCPdQZ0qOL8VvhPXbJ04uHVIzsX7gt7OAuiwQl+bGzs4QVM
	zwmANp9s
X-Received: by 2002:a05:6102:441e:b0:7cb:bda3:27ab with SMTP id ada2fe7eead31-7d7393925f5mr9332299137.13.1795584127668;
        Tue, 24 Nov 2026 21:22:07 -0800 (PST)
Received: from Sys0z ([2a0d:5600:6:112::14])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6e7f92680sm17980534137.5.2026.11.24.21.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 21:22:07 -0800 (PST)
From: arzuagapozosergio@gmail.com
To: tytso@mit.edu
Cc: jack@suse.cz,
	linux-ext4@vger.kernel.org,
	syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com,
	arzuagapozosergio@gmail.com
Subject: [PATCH v5] ext4: bound xattr journal credits to transaction limit
Date: Wed, 25 Nov 2026 00:19:09 -0500
Message-ID: <20261125051909.61227-1-arzuagapozosergio@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125045143.53035-1-arzuagapozosergio@gmail.com>
References: <20261125045143.53035-1-arzuagapozosergio@gmail.com>
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

Drop the obsolete credits for releasing an old ea_inode. Since
ext4_put_ea_inode() defers the final iput to a worker, freeing the old
value's blocks does not happen in the current transaction. Continue to
count ea_inode references in the external xattr block for the case where
it must be cloned, and check the estimate against the transaction limit
after reserving the default JBD2 revoke credits. Repeat the estimate under
the xattr write lock before modifying the attribute.

When an identical xattr block is reused from the cache, drop the
provisional ea_inode reference because the reused block already contains
that reference. Add an EXT4 selftest covering the original
no-XATTR_CREATE credit path, large xattr creation and replacement,
XATTR_CREATE rejection, shared external block cloning with an ea_inode
entry, removal, and a small user xattr round trip.

Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
Link: https://syzbot.org/bug?extid=25d45c0bd716f2b794a7
Assisted-by: Codex:GPT-6
Signed-off-by: Ryuji Hiroshi <arzuagapozosergio@gmail.com>
Changes in v5:
- Avoid dropping the ea_inode reference twice when the old xattr block was
  modified in place before an identical cached block was reused.
- Document why the test uses a value close to XATTR_SIZE_MAX.

Tests:
- make -j4 bzImage
- make -C tools/testing/selftests/filesystems/ext4 clean all
- sh -n tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
- Booted the v5 kernel in QEMU/KVM with a 1 KiB-block ea_inode filesystem
  and 1 MiB journal; all 10 TAP tests passed.
- e2fsck -fn passed after the guest unmounted the filesystem.

---
 MAINTAINERS                                   |   1 +
 fs/ext4/acl.c                                 |   3 +-
 fs/ext4/crypto.c                              |   3 +-
 fs/ext4/ialloc.c                              |   9 +-
 fs/ext4/xattr.c                               | 118 ++++-----
 fs/ext4/xattr.h                               |   8 +-
 fs/jbd2/transaction.c                         |   9 +
 include/linux/jbd2.h                          |   2 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/filesystems/ext4/.gitignore     |   2 +
 .../selftests/filesystems/ext4/Makefile       |   6 +
 .../ext4/ext4_xattr_journal_credits.c         | 243 ++++++++++++++++++
 .../ext4/ext4_xattr_journal_credits.sh        |  56 ++++
 13 files changed, 389 insertions(+), 72 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/ext4/.gitignore
 create mode 100644 tools/testing/selftests/filesystems/ext4/Makefile
 create mode 100644 tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
 create mode 100755 tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh

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
index 59fac55a2..167a410ef 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -239,8 +239,7 @@ ext4_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (error)
 		return error;
 retry:
-	error = ext4_xattr_set_credits(inode, acl_size, false /* is_create */,
-				       &credits);
+	error = ext4_xattr_set_credits(inode, acl_size, &credits);
 	if (error)
 		return error;
 
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 318b2eaea..c1275009e 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -203,8 +203,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (res)
 		return res;
 retry:
-	res = ext4_xattr_set_credits(inode, len, false /* is_create */,
-				     &credits);
+	res = ext4_xattr_set_credits(inode, len, &credits);
 	if (res)
 		return res;
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 527f1f703..82623f563 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -888,8 +888,7 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 
 		nblocks += (S_ISDIR(mode) ? 2 : 1) *
 			__ext4_xattr_set_credits(sb, NULL /* inode */,
-						 NULL /* block_bh */, acl_size,
-						 true /* is_create */);
+						 NULL /* block_bh */, acl_size);
 		posix_acl_release(p);
 	}
 #endif
@@ -907,16 +906,14 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 		 */
 		nblocks += num_security_xattrs *
 			__ext4_xattr_set_credits(sb, NULL /* inode */,
-						 NULL /* block_bh */, 1024,
-						 true /* is_create */);
+						 NULL /* block_bh */, 1024);
 	}
 #endif
 	if (encrypt)
 		nblocks += __ext4_xattr_set_credits(sb,
 						    NULL /* inode */,
 						    NULL /* block_bh */,
-						    FSCRYPT_SET_CONTEXT_MAX_SIZE,
-						    true /* is_create */);
+						    FSCRYPT_SET_CONTEXT_MAX_SIZE);
 	return nblocks;
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5c310747b..0a955a6e0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -948,8 +948,7 @@ static void ext4_xattr_inode_free_quota(struct inode *parent,
 }
 
 int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
-			     struct buffer_head *block_bh, size_t value_len,
-			     bool is_create)
+			     struct buffer_head *block_bh, size_t value_len)
 {
 	int credits;
 	int blocks;
@@ -998,24 +997,6 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
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
-
 	/* We may need to clone the existing xattr block in which case we need
 	 * to increment ref counts for existing ea_inodes referenced by it.
 	 */
@@ -2109,6 +2090,18 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 								   new_bh);
 				if (error)
 					goto cleanup_dquot;
+				if (ea_inode &&
+				    !(bs->bh && s->base == bs->bh->b_data)) {
+					/* The reused block already holds this reference. */
+					error = ext4_xattr_inode_dec_ref(handle,
+									 ea_inode);
+					if (error)
+						ext4_warning_inode(ea_inode,
+								   "dec ref error=%d",
+								   error);
+					ext4_put_ea_inode(ea_inode);
+					ea_inode = NULL;
+				}
 			}
 			mb_cache_entry_touch(ea_block_cache, ce);
 			mb_cache_entry_put(ea_block_cache, ce);
@@ -2375,29 +2368,6 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 
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
@@ -2415,6 +2385,28 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		error = ext4_xattr_block_find(inode, &i, &bs);
 	if (error)
 		goto cleanup;
+
+	/* Check journal credits under write lock. */
+	if (ext4_handle_valid(handle)) {
+		int credits;
+
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
+						   value_len);
+		if (jbd2_handle_buffer_credits(handle) < credits) {
+			error = -ENOSPC;
+			goto cleanup;
+		}
+		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
+	}
 	if (is.s.not_found && bs.s.not_found) {
 		error = -ENODATA;
 		if (flags & XATTR_REPLACE)
@@ -2501,27 +2493,38 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 }
 
 int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
-			   bool is_create, int *credits)
+			   int *credits)
 {
-	struct buffer_head *bh;
-	int err;
+	struct ext4_xattr_block_find bs = {
+		.s = { .not_found = -ENODATA, },
+	};
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	int max_credits, revoke_credits, err;
 
 	*credits = 0;
-
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if (!journal)
 		return 0;
 
+	/* xattr_sem protects the block while we count its ea_inode references. */
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
+		bh = ext4_xattr_get_block(inode);
+		if (IS_ERR(bh)) {
+			err = PTR_ERR(bh);
+			goto out_unlock;
+		}
+		bs.bh = bh;
 	}
+	*credits = __ext4_xattr_set_credits(inode->i_sb, inode, bs.bh,
+					    value_len);
+	revoke_credits = ext4_trans_default_revoke_credits(inode->i_sb);
+	max_credits = jbd2_journal_get_max_transaction_buffers(journal, revoke_credits);
+	err = *credits > max_credits ? -ENOSPC : 0;
+	brelse(bs.bh);
+out_unlock:
 
 	up_read(&EXT4_I(inode)->xattr_sem);
 	return err;
@@ -2549,8 +2552,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 		return error;
 
 retry:
-	error = ext4_xattr_set_credits(inode, value_len, flags & XATTR_CREATE,
-				       &credits);
+	error = ext4_xattr_set_credits(inode, value_len, &credits);
 	if (error)
 		return error;
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 821dc6a50..eb6e85036 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -175,11 +175,11 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
-extern int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
-				  bool is_create, int *credits);
+int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
+			   int *credits);
 extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
-				struct buffer_head *block_bh, size_t value_len,
-				bool is_create);
+				    struct buffer_head *block_bh,
+				    size_t value_len);
 
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
index 000000000..85dd28d62
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
@@ -0,0 +1,243 @@
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
+#define FILLER_VALUE_SIZE 4
+#define TEST_COUNT 10
+
+/* Near XATTR_SIZE_MAX to exercise the largest ea_inode credit estimate. */
+
+static const char large_name[] = "user.ext4-credit-large";
+static const char small_name[] = "user.ext4-credit-small";
+static const char target_name[] = "user.ext4-credit-target";
+static const char filler_name[] = "user.ext4-fill";
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
+	/* Keep filler in inode body so large_name spills into the block. */
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
+		result(shared_replaced &&
+		       xattr_matches(shared_a, target_name, readback, target_new,
+				     sizeof(target_new)) &&
+		       xattr_matches(shared_b, target_name, readback,
+				     &target_old, sizeof(target_old)) &&
+		       xattr_matches(shared_b, large_name, readback, value,
+				     LARGE_VALUE_SIZE),
+		       "xattr block clone preserves both files' values");
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
index 000000000..4f875aae3
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
+if ! mkfs.ext4 -q -F -b 1024 -I 256 -O ea_inode -J size=1 "$test_dir/fs.img" \
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

