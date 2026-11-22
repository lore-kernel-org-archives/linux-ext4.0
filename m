Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795337397;
	b=yF/VgATS0vtaNVETjfRsxE/iibSkS62h+mfWbquIRUjFIVpu/RjnAEtAu/q4/cmq6Hyc
	 vNdxdufdtxM3uzPxt8SGv7idxhhKwowK+afZGNPLIhdvEJdYYm7lqF3uD0dqdsp8LA50m
	 i9mcU1ejtBjdhZDBie4G55J5WHA23c9ieaCOhCfLZoNR8awUxRSPnKVl7y2Ai6Tbd2e3c
	 x+Hf3yqy+MEyRuTsKYUD3sZXMhK+PJjzGKUauZtvw2JdV5MIUOaY1FRVH8Fklp88cpN5Z
	 zcW5yJ9Bc9V7ZDmPPIR8nBAO/ydt4/FgE57qEPdm8lIhqsbHlsvFekTZwDdmxyk3hMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795337397;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PB1m5s310eGDdTar4J4vEskvmzAWwEy2+joJx42l11s=;
	b=djrwIAYO9BSvxVl1U6k7aogOha/UjnnKA1dfKzkfYAi/V+P1pDjrszPTtMvaQoXqAdud
	 T1LRMhckklJXk8nKxfajMXp4BbU/JbThPYV28eMfNVLw+pf3RqqHj0H8hLMGduH9NQwLN
	 agfp5LFL+8PRy9ttfk2QORmgLYu4ajt5fzJ+6DjBRaj4z3NuPjAEI8KPhAqV8mmnFpzE0
	 ZVL9P1j5u+7aZXwUG2CULpb/oURz5XJLRlSfBBjHX4iZn9NzDKayt0Dq4i22rCCrliKV5
	 ZYkc0bfWr4CcAfBGvJpqxexNtggGkv9HX03+fqD/koJtP4uK8klccqSA6iZGfzS6Rfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gvHvdupy;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BF0606A332
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 08:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20BF0606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gvHvdupy
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5363316fa0cso27937371cf.3
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 00:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795337395; x=1795942195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PB1m5s310eGDdTar4J4vEskvmzAWwEy2+joJx42l11s=;
        b=gvHvdupyd6z71azQTiyhcc2TON23lTWscbvRCi5mRHIe+FsALmBh4PiifE4QUrEYl6
         f9A8C9VBfJi3LiPY5hhaolzNAnHd1DuWrj893PwjrgsAb4FuyDr2NiKeyKzMMoNCgeo8
         V3hB+umrXYYtpvtZCIlscFgxo7QqZ+4A7FDe/9ckL9zeiqH0ygNiQxoZox+/2NRdK/2t
         WacvUSoLWlD3RknybYT6xGYNbbZpm8abR0wxcGAUwu1QjBJK7mzYQAs+a3MrvKyCX3JX
         UmVoG0KnzglkPy4VcvXGJmP4884liCvoZ+4b8i/2YSkiCtzjNbl7E5B41ZHKBQPZb/Aw
         eYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795337395; x=1795942195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PB1m5s310eGDdTar4J4vEskvmzAWwEy2+joJx42l11s=;
        b=vW5gxYf3SbhgmDF3acVMFLIypCJAvuGxx69cujznxcUhRTpt2rSSnUslaWs4lcejLf
         TVmHPeKuL9a1o/4TFHCJSCz3XulDSElU9AKrmEeuDi4hqxFxVEkzbp867MQFORb8z8AM
         uf17naV+4yRDWmKqO0h66NQcEJb2yDRFb0hbGbgish9k8c4MGO2HjcYSXnjNWdSNOSN2
         om/Xo8oa417G5NRMpHwX9z4Y/vuJTz27x7H0FbOTp/NaUH0qiD4H2YPhicX9pQO48ESu
         wwPyAkhPJIadRXYCV+mOWo+JZo+s3UVMGES9deF5RchAwaI9LpyO2VIrx+3iQe62n1MX
         M68Q==
X-Forwarded-Encrypted: i=1; AL+hErG8Bks4Rl9mp3OfBWvrxjs/hA5+Pibnh1EuQQ+6MBSSeXLYXFZsatDHoihe6SZD3dV73iXA3HPtJwVT@vger.kernel.org
X-Gm-Message-State: APuU4Z9S9CD3YYeMIsXbYqFDXMXkv6+Hwoa647G8+wtwttF2b8RrdvOs
	0OrMLhVO+n9oLhNa/XHJJbq+SHfPGgjUabxDbOXDAzSZq4+wuxUG3szJ
X-Gm-Gg: AZFdTZc9dZyAJ4SnVdWJQaShaFHbDaqm5oQDSgB6rCigG4j0jj2yhdsmYx1dLxKfQYH
	J1en9sbeYQGJJ/cDxxfO35vP9K33N/oWgSQ7rVvK4OPEn36RwA8cQQlTMUg7ZqDiJSW6w9KrJfw
	zB/52fTILYmfPDNT+WTtc2FuFmS81lFjv1VkgympNrlMfUZzsr28GQsKMn8SfJ8AasLTCZHi5hQ
	cuGnEBubaFLxga7RG2a1fgmKxEvUf3SrrdKN4VyZfof9/Ee0CJ9HkvGg4772atW2G+6ofg5LYdm
	Mq2c9YBOUUAKfMkuwta8YYGrd6BRS8WqxLlKAdb91FJ8GBRP8+xEMt/pWeLhqxLraYolu1xLbbj
	Nk+JTtRE5JZHbKYtoE/7pVmrEdWUWPRc8AyXmVHLPrh480llVxq72bsbRAfmrAeOL8kLOUfbmWp
	EVSQ/LTTzv5SLmJsd13XXrsdFsofNGRrJ6gTAjHbJC18XWzy/vIVpqWHTf2OsjTwu91i3Rtz6CM
	R4XNoy+1bZ3w17bJq8mvmFtLLAATRGs0jHeKMnzRzm6PUULlmJQn+y5m2BrYU6EuaNJ3so7PGHc
	jmpZpTr3Gg==
X-Received: by 2002:ac8:5f0c:0:b0:55b:fb2e:a754 with SMTP id d75a77b69052e-55d768a2509mr157099641cf.8.1795337394821;
        Sun, 22 Nov 2026 00:49:54 -0800 (PST)
Received: from Sys0z ([2a0d:5600:6:ad1e::17])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm74590546d6.21.2026.11.22.00.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 00:49:54 -0800 (PST)
From: arzuagapozosergio@gmail.com
To: tytso@mit.edu
Cc: jack@suse.cz,
	linux-ext4@vger.kernel.org,
	syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com,
	Ryuji Hiroshi <arzuagapozosergio@gmail.com>
Subject: [PATCH v2] ext4: bound xattr journal credits to transaction limit
Date: Sun, 22 Nov 2026 03:49:39 -0500
Message-ID: <20261122084939.129223-1-arzuagapozosergio@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261122075355.81772-1-arzuagapozosergio@gmail.com>
References: <20261122075355.81772-1-arzuagapozosergio@gmail.com>
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
the xattr write lock before modifying the attribute.

Add an EXT4 selftest for large xattr creation and replacement, readback,
XATTR_CREATE, oversized replacement rejection with value preservation,
removal, and a small user xattr round trip.

Changes in v2:
- Include the default revoke descriptor blocks in the JBD2 credit limit.
- Do not charge the current transaction for deferred ea_inode truncation.
- Correct selftest registration and use kselftest result reporting.
- Use user.* attributes and skip when required mount support is
  unavailable.
- Reuse the validated xattr block buffer during the locked credit check.

Tests:
- make defconfig
- make -j2 fs/ext4/xattr.o fs/jbd2/transaction.o
- make -C tools/testing/selftests/filesystems/ext4 clean all
- sh -n tools/testing/selftests/filesystems/ext4/
  ext4_xattr_journal_credits.sh
- scripts/checkpatch.pl --strict --no-tree: 0 errors; two environment or
  tree warnings for the Fixes commit lookup and new selftest MAINTAINERS
  coverage.
- Built and booted the patched x86_64 kernel in a QEMU/KVM guest.
- The EXT4 selftest passed all 8 cases as guest root on a 1 KiB-block
  ea_inode filesystem with a 1 MiB journal. e2fsck -fn passed after
  the guest unmounted it.
- The host kselftest runner correctly reported KSFT_SKIP because it cannot
  mount the disposable filesystem without root privileges.

Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
Link: https://syzbot.org/bug?extid=25d45c0bd716f2b794a7
Signed-off-by: Ryuji Hiroshi <arzuagapozosergio@gmail.com>
---
 fs/ext4/acl.c                                 |   7 +-
 fs/ext4/crypto.c                              |   5 +-
 fs/ext4/ialloc.c                              |   6 +-
 fs/ext4/xattr.c                               | 165 ++++++++++++------
 fs/ext4/xattr.h                               |   7 +-
 fs/jbd2/transaction.c                         |   9 +
 include/linux/jbd2.h                          |   2 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/filesystems/ext4/Makefile       |   6 +
 .../ext4/ext4_xattr_journal_credits.c         | 146 ++++++++++++++++
 .../ext4/ext4_xattr_journal_credits.sh        |  56 ++++++
 11 files changed, 345 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/ext4/Makefile
 create mode 100644 tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
 create mode 100755 tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh

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
index 5c310747b..0249dc137 100644
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
@@ -2415,6 +2383,30 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
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
@@ -2500,28 +2492,91 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
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
@@ -2549,8 +2604,8 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
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
index 000000000..92a6a8f79
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "../../kselftest.h"
+
+#define LARGE_VALUE_SIZE 65296
+#define OVERSIZED_VALUE_SIZE 65537
+
+int main(int argc, char **argv)
+{
+	char path[4096];
+	char *value = NULL;
+	char *readback = NULL;
+	int fd = -1;
+	int path_len;
+	int saved_errno = 0;
+	const char *failed_test = NULL;
+	static const char large_name[] = "user.ext4-credit-test";
+	static const char small_name[] = "user.ext4-credit-small";
+	static const char small_value[] = "small-xattr";
+	char small_readback[sizeof(small_value)];
+
+	ksft_print_header();
+	ksft_set_plan(8);
+	if (argc != 2)
+		ksft_exit_fail_msg("Usage: %s MOUNTPOINT\n", argv[0]);
+
+	path_len = snprintf(path, sizeof(path), "%s/credit-test", argv[1]);
+	if (path_len < 0 || (size_t)path_len >= sizeof(path))
+		ksft_exit_fail_msg("Mount path is too long\n");
+
+	fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
+	if (fd < 0) {
+		failed_test = "create test file";
+		saved_errno = errno;
+		goto out;
+	}
+	if (close(fd) < 0) {
+		fd = -1;
+		failed_test = "close test file";
+		saved_errno = errno;
+		goto out;
+	}
+	fd = -1;
+
+	value = malloc(OVERSIZED_VALUE_SIZE);
+	readback = malloc(LARGE_VALUE_SIZE);
+	if (!value || !readback) {
+		failed_test = "allocate xattr buffers";
+		saved_errno = errno;
+		goto out;
+	}
+	memset(value, 0x5a, LARGE_VALUE_SIZE);
+	value[0] = 1;
+
+	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, 0) < 0) {
+		failed_test = "create large ea_inode xattr";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("large xattr creation\n");
+
+	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=
+	    LARGE_VALUE_SIZE || memcmp(value, readback, LARGE_VALUE_SIZE)) {
+		failed_test = "verify newly created xattr";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("large xattr readback\n");
+
+	memset(value, 0xa5, LARGE_VALUE_SIZE);
+	value[0] = 2;
+	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, XATTR_REPLACE) < 0) {
+		failed_test = "replace large ea_inode xattr";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("large xattr replacement\n");
+
+	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=
+	    LARGE_VALUE_SIZE || memcmp(value, readback, LARGE_VALUE_SIZE)) {
+		failed_test = "verify replaced xattr";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("replacement readback\n");
+
+	errno = 0;
+	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, XATTR_CREATE) !=
+	    -1 || errno != EEXIST) {
+		failed_test = "XATTR_CREATE on an existing name should return EEXIST";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("XATTR_CREATE semantics\n");
+
+	errno = 0;
+	if (setxattr(path, large_name, value, OVERSIZED_VALUE_SIZE,
+		     XATTR_REPLACE) != -1 || errno != E2BIG) {
+		failed_test = "oversized replacement should return E2BIG";
+		saved_errno = errno;
+		goto out;
+	}
+	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=
+	    LARGE_VALUE_SIZE || memcmp(value, readback, LARGE_VALUE_SIZE)) {
+		failed_test = "oversized replacement changed the old value";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("oversized replacement rejected without changing value\n");
+
+	if (removexattr(path, large_name) < 0) {
+		failed_test = "remove large xattr";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("large xattr removal\n");
+
+	if (setxattr(path, small_name, small_value, sizeof(small_value), 0) < 0 ||
+	    getxattr(path, small_name, small_readback, sizeof(small_readback)) !=
+		    sizeof(small_value) ||
+	    memcmp(small_value, small_readback, sizeof(small_value)) ||
+	    removexattr(path, small_name) < 0) {
+		failed_test = "small user xattr round trip";
+		saved_errno = errno;
+		goto out;
+	}
+	ksft_test_result_pass("small user xattr round trip\n");
+
+out:
+	if (fd >= 0)
+		close(fd);
+	free(readback);
+	free(value);
+	if (failed_test)
+		ksft_exit_fail_msg("%s: %s\n", failed_test,
+				   strerror(saved_errno));
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

