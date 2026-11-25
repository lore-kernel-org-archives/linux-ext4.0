Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588238;
	b=DoAPF+IX+mamKHhhVvEUwn+XBU0kEhMv7cQF5hBBXCyLSsMfYshiYC0oPuhMq78//FEY
	 N3n8kfVdU5e48j+Y6daPXdEmR5bkzxv8wWy7syDJC4Y6Lte2XrPw3XtNOF6i+qhD2Bgbp
	 bk/k92fnslA2b3hDLQw/RWamSaJp9/u119qriETlF5LMYqCqoDkaRMFBAN/kS0TXXcLo4
	 UIhiuqsWXZNjkNNQa4g3RoIHIWVjeDwNM1oOdWVNdw3haZSCs33k+QhWYL7/CzZZStRh3
	 U4pm6dk24/SeItF8cl00/hmjCxMZRWThxxjpXyVpIkooUlRGWMlRC9pXRqlXY5NBKrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pCECKG7vk4hGnYdapmutw9n8ApbZR8PvBHiZ+FG0w8Q=;
	b=YHK/TD30CSnKuzv0jPEXS1H2YCErw/EUMLfuKJiq0a2aDMSk3RenQeIyJ03Rw3CCgDvY
	 HibzbpoShFQYS/sa4KYOQbeB+BL/Cn5FP/2DMEFcEwIXqDgxP88e73fcOow07mlqJsy+R
	 A8GzIWjXdkskSPiqXbhxzWg/TFMMavA9RIlYYtkpnyEUXIpiPnu+aWs+h4z+hXdiNB7xG
	 /J7JMgy7KYPYVA6xu+CT0wxqqE+BKaYLErTlEDtJNirnhmVoGQR5aS8AMTTRFSUuHA1/Q
	 1PLTwi5A13UrQXl8qwLqCWWYyi3fjltVrzbvJQsMso3cBuKZkxAZbtXlDnRB9lOfOBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S9DMMVVa;
	arc=none smtp.remote-ip=209.85.221.176
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E17606A326
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 06:30:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06E17606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S9DMMVVa
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5ec20398b05so4597031e0c.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 22:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795588237; x=1796193037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pCECKG7vk4hGnYdapmutw9n8ApbZR8PvBHiZ+FG0w8Q=;
        b=S9DMMVVaxeXJ5L/gEFc/K8XT263hQtzl+8HczZGkyZGMT+9+OsKx+PJP+KC/uDM52v
         i2td+wZN0cGVLvQMQOivL9uO7L6F2a3m/RobZDp881qINRZTki8BcYli7/wolBkjzIYB
         1457GnhoKsWcjiNRHVAmUkQ1ZfRAmO86ickGGvC1RYos6V4RyLg6mQf9JcZhvum/VIKR
         2lasoxSfVlJZHN92FP2r7pCB/jp7ugGegrV9XNaPO9tHEm3qgjQNOy3PYiWW8us49i6s
         UtLLdIRs45pY1l4h0Uqy6asuncQqdgY0fT2I56BrW5NXWqG07EfPFKSCU/CL8gIST5Yj
         S0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795588237; x=1796193037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pCECKG7vk4hGnYdapmutw9n8ApbZR8PvBHiZ+FG0w8Q=;
        b=ob1mMrNrVeODARKXNgU3Eve1+4oDw2m4IxFwmBiGICi6bx+ByPXnYLm4MyEi3/2+o8
         QuddFDik95VugZgSE6qJwkvgdy44UH82i/3FU5/ZEBTDvgGQ6TOZ8PjQpzNawkrJrCwn
         nK4brYGYbJb/ag3a1fz72QtYXn2FWmqvOJU2J+yk2HOEIwS8bwTYpXRUs4dSoVeGTDi7
         wiw1QdrxtrgSvRNDAM7n4n1ncpFXdr2SxC0MUor/4hv2vdhKE7jnDT0qS9OaLF+uAiyE
         jGiApM7QH4VlKE/+oV9WVh5lsTUSBq5B2QwAYcS+EwfHbGbmq5mfl1dK2z2toBnPESX0
         ssjg==
X-Forwarded-Encrypted: i=1; AL+hErGm2Pn3cYcavFfFnw+JuTdOcaxEFX0Gxnz2HpEKR/c7+vVUfNrq8xwah2nWoGwx+fBcF3AghISLhUBK@vger.kernel.org
X-Gm-Message-State: APuU4Z9fiMvNxpJCVgzWQWiro/Dw2HktiueL27+E7EsHnmkvzUO71Lsf
	xNOagSnUGjbgVhUbxnOasYct8+xNuyDwHunIkCnfhhP6VXQGwiDuMUYi
X-Gm-Gg: AZFdTZdXncNjT8wYbwd685aGAyp+HjUK8a1KLGubxIrDw81+rPJ6v5NLNk2WKPCr4Wd
	m/qRpfHmCzW3oosgf+FNlC5vosSTzzIYLvJLcX7vXRXYwoagyEeMOzD12po/xxNU9181WlujN1A
	KrgRzxQ+D9rXMVqnC2/n69iO8jyWu1E+IOeP9053iGxZsd7VBCzN16xJmY57ZA41QvPJvxI0/LQ
	n26NUQg9m9pZfZJ/7IGPTC9VY8ZR1y7kdnnrMbA7hgeCSJ2rWKkvs9+cCvVffeRudaczrh2SWPe
	hBEfMb69crEAJeJ7CqOjIDgEDA68vpbARzsdXl9Psmo2gLwKhzYiZEMULJiPmKfSNdfuMG9XtHf
	A8A9m/pEDDKfVYeUxYYN/JTbzbMNMPCdS4EPTHauSbq4XeJEndUE97/zbN5J3W0udNakjAfU3+n
	Nn4UIJHTmHysgTbQX6Z22fIaOPQhVcQSWM1EcnEE9sLxY1QLQkHuu9cT4k2SRasIgLDNZfimUfd
	IjloOOkRaoiHVlT3oUdeYN+qKqvGq9ZmXtOzo7Tk9t5YhTAZK8JZ7Qs8VAwUW2IrWClxWGIB5Ig
	jkkR69f6U5uVhJOLc4gaHgBmAQ9P
X-Received: by 2002:a05:6102:374d:b0:7cc:971a:61ee with SMTP id ada2fe7eead31-7d7393ff678mr9734940137.10.1795588236632;
        Tue, 24 Nov 2026 22:30:36 -0800 (PST)
Received: from Sys0z ([134.82.68.97])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99e6df8a28dsm17628039241.4.2026.11.24.22.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:30:36 -0800 (PST)
From: arzuagapozosergio@gmail.com
To: tytso@mit.edu
Cc: jack@suse.cz,
	linux-ext4@vger.kernel.org,
	syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com,
	arzuagapozosergio@gmail.com
Subject: [PATCH v7] ext4: bound xattr journal credits to transaction limit
Date: Wed, 25 Nov 2026 01:30:23 -0500
Message-ID: <20261125063023.18022-1-arzuagapozosergio@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125060131.10328-1-arzuagapozosergio@gmail.com>
References: <20261125060131.10328-1-arzuagapozosergio@gmail.com>
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
provisional ea_inode reference unless the block was modified in place.
Handle both a different cached block and the original block being found
after cloning. Add an EXT4 selftest for the credit path, large xattrs,
shared-block same-value replacement, and a small user xattr round trip.

Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
Link: https://syzbot.org/bug?extid=25d45c0bd716f2b794a7
Assisted-by: Codex:GPT-6
Signed-off-by: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

Changes in v7:
- Format the selftest image with 128-byte inodes so xattrs cannot fit in
  the in-inode area and the shared ea_inode test exercises external blocks.

Tests:
- make -C tools/testing/selftests/filesystems/ext4 clean all
- sh -n tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
- Booted the v6 kernel in QEMU/KVM with a 1 KiB-block, 128-byte-inode
  ea_inode filesystem and 1 MiB journal; all 3 harness tests passed.
- e2fsck -fn passed after the guest unmounted the filesystem.
---
 MAINTAINERS                                   |   1 +
 fs/ext4/acl.c                                 |   3 +-
 fs/ext4/crypto.c                              |   3 +-
 fs/ext4/ialloc.c                              |   9 +-
 fs/ext4/xattr.c                               | 116 ++++++------
 fs/ext4/xattr.h                               |   8 +-
 fs/jbd2/transaction.c                         |   9 +
 include/linux/jbd2.h                          |   2 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/filesystems/ext4/.gitignore     |   2 +
 .../selftests/filesystems/ext4/Makefile       |   6 +
 .../ext4/ext4_xattr_journal_credits.c         | 166 ++++++++++++++++++
 .../ext4/ext4_xattr_journal_credits.sh        |  57 ++++++
 13 files changed, 311 insertions(+), 72 deletions(-)
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
index 5c310747b..753265c08 100644
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
@@ -2110,6 +2091,16 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				if (error)
 					goto cleanup_dquot;
 			}
+			if (ea_inode &&
+			    !(bs->bh && s->base == bs->bh->b_data)) {
+				/* The reused block already holds this reference. */
+				error = ext4_xattr_inode_dec_ref(handle, ea_inode);
+				if (error)
+					ext4_warning_inode(ea_inode,
+							   "dec ref error=%d", error);
+				ext4_put_ea_inode(ea_inode);
+				ea_inode = NULL;
+			}
 			mb_cache_entry_touch(ea_block_cache, ce);
 			mb_cache_entry_put(ea_block_cache, ce);
 			ce = NULL;
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
@@ -2415,6 +2383,28 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
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
@@ -2501,27 +2491,38 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
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
@@ -2549,8 +2550,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
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
index 000000000..93e8c074d
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+/* Near XATTR_SIZE_MAX to exercise the largest ea_inode credit estimate. */
+#define LARGE_VALUE_SIZE 65296
+
+static const char large_name[] = "user.ext4-credit-large";
+static const char small_name[] = "user.ext4-credit-small";
+
+FIXTURE(ext4_xattr_journal_credits)
+{
+	char path[PATH_MAX];
+	char shared_a[PATH_MAX];
+	char shared_b[PATH_MAX];
+	char *value;
+	char *readback;
+};
+
+FIXTURE_SETUP(ext4_xattr_journal_credits)
+{
+	int len;
+
+	len = snprintf(self->path, sizeof(self->path), "credit-test-%d",
+		       getpid());
+	ASSERT_GE(len, 0);
+	ASSERT_LT(len, (int)sizeof(self->path));
+	len = snprintf(self->shared_a, sizeof(self->shared_a), "shared-a-%d",
+		       getpid());
+	ASSERT_GE(len, 0);
+	ASSERT_LT(len, (int)sizeof(self->shared_a));
+	len = snprintf(self->shared_b, sizeof(self->shared_b), "shared-b-%d",
+		       getpid());
+	ASSERT_GE(len, 0);
+	ASSERT_LT(len, (int)sizeof(self->shared_b));
+
+	self->value = malloc(LARGE_VALUE_SIZE);
+	ASSERT_NE(NULL, self->value);
+	self->readback = malloc(LARGE_VALUE_SIZE);
+	ASSERT_NE(NULL, self->readback);
+}
+
+FIXTURE_TEARDOWN(ext4_xattr_journal_credits)
+{
+	unlink(self->path);
+	unlink(self->shared_a);
+	unlink(self->shared_b);
+	free(self->readback);
+	free(self->value);
+}
+
+static void create_test_file(struct __test_metadata *_metadata,
+			     const char *path)
+{
+	int fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
+
+	ASSERT_GE(fd, 0) {
+		TH_LOG("open(%s): %s", path, strerror(errno));
+	}
+	ASSERT_EQ(0, close(fd));
+}
+
+static void check_xattr_value(struct __test_metadata *_metadata,
+			      const char *path,
+			      const char *name, const void *expected,
+			      size_t size, char *buffer)
+{
+	ssize_t len = getxattr(path, name, buffer, size);
+
+	ASSERT_EQ((ssize_t)size, len) {
+		TH_LOG("getxattr(%s): %s", name,
+		       len < 0 ? strerror(errno) : "unexpected value size");
+	}
+	ASSERT_EQ(0, memcmp(buffer, expected, size));
+}
+
+TEST_F(ext4_xattr_journal_credits, large_xattr_lifecycle)
+{
+	char *expected = malloc(LARGE_VALUE_SIZE);
+	int ret;
+
+	ASSERT_NE(NULL, expected);
+	create_test_file(_metadata, self->path);
+	memset(self->value, 0x5a, LARGE_VALUE_SIZE);
+	self->value[0] = 1;
+
+	ASSERT_EQ(0, setxattr(self->path, large_name, self->value,
+			      LARGE_VALUE_SIZE, 0));
+	check_xattr_value(_metadata, self->path, large_name, self->value,
+			  LARGE_VALUE_SIZE, self->readback);
+
+	memset(self->value, 0xa5, LARGE_VALUE_SIZE);
+	self->value[0] = 2;
+	ASSERT_EQ(0, setxattr(self->path, large_name, self->value,
+			      LARGE_VALUE_SIZE, XATTR_REPLACE));
+	check_xattr_value(_metadata, self->path, large_name, self->value,
+			  LARGE_VALUE_SIZE, self->readback);
+
+	memcpy(expected, self->value, LARGE_VALUE_SIZE);
+	memset(self->value, 0x3c, LARGE_VALUE_SIZE);
+	self->value[0] = 3;
+	errno = 0;
+	ret = setxattr(self->path, large_name, self->value,
+		       LARGE_VALUE_SIZE, XATTR_CREATE);
+	ASSERT_EQ(-1, ret);
+	ASSERT_EQ(EEXIST, errno);
+	check_xattr_value(_metadata, self->path, large_name, expected,
+			  LARGE_VALUE_SIZE, self->readback);
+
+	ASSERT_EQ(0, removexattr(self->path, large_name));
+	free(expected);
+}
+
+TEST_F(ext4_xattr_journal_credits, shared_block_reuses_same_ea_inode)
+{
+	/* The test image has 128-byte inodes, so both xattrs use external blocks. */
+	create_test_file(_metadata, self->shared_a);
+	create_test_file(_metadata, self->shared_b);
+	memset(self->value, 0x7e, LARGE_VALUE_SIZE);
+	self->value[0] = 0x42;
+
+	ASSERT_EQ(0, setxattr(self->shared_a, large_name, self->value,
+			      LARGE_VALUE_SIZE, XATTR_CREATE));
+	ASSERT_EQ(0, setxattr(self->shared_b, large_name, self->value,
+			      LARGE_VALUE_SIZE, XATTR_CREATE));
+	check_xattr_value(_metadata, self->shared_a, large_name, self->value,
+			  LARGE_VALUE_SIZE, self->readback);
+	check_xattr_value(_metadata, self->shared_b, large_name, self->value,
+			  LARGE_VALUE_SIZE, self->readback);
+
+	/* Clone the shared block, then deduplicate back to the original block. */
+	ASSERT_EQ(0, setxattr(self->shared_a, large_name, self->value,
+			      LARGE_VALUE_SIZE, XATTR_REPLACE));
+	check_xattr_value(_metadata, self->shared_a, large_name, self->value,
+			  LARGE_VALUE_SIZE, self->readback);
+	check_xattr_value(_metadata, self->shared_b, large_name, self->value,
+			  LARGE_VALUE_SIZE, self->readback);
+
+	ASSERT_EQ(0, removexattr(self->shared_a, large_name));
+	ASSERT_EQ(0, removexattr(self->shared_b, large_name));
+}
+
+TEST_F(ext4_xattr_journal_credits, small_xattr_round_trip)
+{
+	static const char value[] = "small-xattr";
+	char readback[sizeof(value)];
+
+	create_test_file(_metadata, self->path);
+	ASSERT_EQ(0, setxattr(self->path, small_name, value, sizeof(value), 0));
+	ASSERT_EQ((ssize_t)sizeof(value),
+		  getxattr(self->path, small_name, readback, sizeof(readback)));
+	ASSERT_EQ(0, memcmp(value, readback, sizeof(value)));
+	ASSERT_EQ(0, removexattr(self->path, small_name));
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
new file mode 100755
index 000000000..977cdcf47
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
@@ -0,0 +1,57 @@
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
+# 128-byte inodes have no ibody xattr space, forcing the external-block path.
+if ! mkfs.ext4 -q -F -b 1024 -I 128 -O ea_inode -J size=1 "$test_dir/fs.img" \
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
+test_bin="$(cd "$(dirname "$0")" && pwd)/ext4_xattr_journal_credits"
+(cd "$test_dir/mnt" && "$test_bin") || exit $?
+
+umount "$test_dir/mnt" || exit 1
+mounted=0
+e2fsck -fn "$test_dir/fs.img"

base-commit: c44104f3642da720164042623e4832836aefdd8e
-- 
2.56.1

