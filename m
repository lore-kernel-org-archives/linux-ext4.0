Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795334050;
	b=Dcy9yKcZZTYmmv9exeXoLkFQsIF2ttbjZYQNxwSMcYnXoI5q34sWcO4to1CbFtJTBmI+
	 B1pE0gXO2IoWS+xzOjishntdctHijl4jGK/IxqFfVbw0+5b4RND1/MOOuKUAi8pUg4ybC
	 +t46/HR4vAqPYfQzpQv3GYAx0jpb9eQ0LY40j/UQ0GKyzBluE2lQUwkgCJqXw0H0JunIi
	 ayGDUOgznsyY5+y60RN0wHMVIQXPu/D6UWhTdMOemEw28eFP2QFjJ4tYzxqQjQiR63trE
	 rz96P0n0JMJu05XZdujuKlg1y18CTKxoJhMKWXPTYW4VKaocr3VqrSoHlkccRfzmv0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795334050;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KHzOd9SnyBjhqFtj6stKfCn8x5op7GQwI4i/mmCd04M=;
	b=pl5VCpREYsC2u8nwlii9XqW2U9/PnNslq877g80KeJiwttAyiyaH0AVDkEPohaJZa1A0
	 8pG9mo/e/0fqkVlAV4NdZwCMcDFp7t47munyw1Gt2QIgoioZPkKwgDlgiUUhxIbkvVBkl
	 TeYvnTabVNN8pB3UjhY7EssvPQGews7lb0vI80/RO8IR1RNKvq9TaKc/dP9sV5lB6AGwF
	 umbvugmpckVO786q96Nd+BYHMTIjsF1e93ACPFUtEq1+IY5Y+7wQZeyg5+VkDc6PEnLm7
	 u8noZISpws7/PWHnEecoxdd+ihzC+BycFczeA4rrzAFvlAsl8On4Xemxc3Jpp6Xjz1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="NkHkLS/l";
	arc=none smtp.remote-ip=209.85.221.172
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2045606A320
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 07:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2045606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NkHkLS/l
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5ecde8e8e5bso670376e0c.2
        for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 23:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795334048; x=1795938848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KHzOd9SnyBjhqFtj6stKfCn8x5op7GQwI4i/mmCd04M=;
        b=NkHkLS/ls1IPkq4kOqkVwNAAQgSmLtr8TzqJC7pyDeLrL5V0uFF/34Au8qb5TDAvZx
         dNW3jksqpWgsF0ybbjB3mwD7p14llXzc/dwBsT79KM4wWd65F5mYu1+Y53pcYQ0Jh1ZB
         wgJStwnkOowNvTOMwntGGp+WAWFNoDi20WPN6et5u83Xc8S3abSrf1532OE//N4jU9Ey
         wUnEdEJifJixBaAONvCfNrawv2QJ1hM77kMpugkuOa1seyZYgY6cItXGvfQWfAP/tf4x
         RedGZ905omkkeNJlnpmP+JJeaOIx9/KXexg0l87tSUb6vu+hQPsZz/TMka92U0qQVXxl
         956w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795334048; x=1795938848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KHzOd9SnyBjhqFtj6stKfCn8x5op7GQwI4i/mmCd04M=;
        b=G1CNHmOGp7f+p/iSBaUy6mE4ZlQurSc15fFQUmPwQRmDxH53JXvpDrLvbpWHaAoJzn
         u1XGX4NLsDPlMKS/HpXCFFGr8mtYnnPJW5uNYroypmsf694ozQ4y9FtHGfBIppnILuha
         AoYxlpt2CdTUHCF4re6Toc3t0PE6JJE6NCbsWd2zV5gJaGQHImQS3lX/md4226nI9+TW
         D34HmKoQQV7xzZQLkFA0Q5pG7gHqfAJmS4zDuqdUv8voJZXcND+i7yknLAJA1GRu+/Br
         kSOUXE4XR+U+j92XWIL9yB9IgaXCIcNbHCJeGc9aGV5yYTmBA9FxWTp7Wi+4rI+8IF3l
         gI3w==
X-Forwarded-Encrypted: i=1; AL+hErFoqa6KGg4R9IAvBc1ZtMoNCTmmNZcw6rGnwMHQdJHl1ip+6cxoSeHrtw4e1oPibbEGpCfKLciConGe@vger.kernel.org
X-Gm-Message-State: APuU4Z/r1K6kgfZ8moEm8DpILRV4b9mVTzp7y/45Atk+JGEiQL94wbia
	AmiffCCiS6j9Fp4ForY/d57LqDXURZB+HOJSG0EuVWPo69MdHkUZTtuN
X-Gm-Gg: AZFdTZenF1mHADJcp0CKJkP+GpjRf8UyF0VMPPDPObL9mUwHQ/6RAq4Ze6Est0w6AhO
	57AgGtWB3pNPuotqOEBEPX3Q3Sd9h7dOEGD9vrOgXcDKi3BaGOqjIXs9EqQ6fQSl6GZouNa9lAd
	Qym48rMyTIHyPUeMHiSheKlk3gQBQjW2HtSQSSz0i+YoOvYZH76vDoY5enZ3xyeczo42o+c71PZ
	EcEsEbSqlQ7Ssjyvm38DN6opbuabAkjl2AM7HJI4plSKQJct8DEhlW7TNctYJrEvxFOOBBXSxFh
	7VptrAOFyQ8VnJgRo77V22oicnvT4IDP5qh+ksce1vR69ts6iX7dfv4TCFICUHlS8KqvB/Un+NP
	u6md0CqWUPBcTYS+5eDrIwRucdr5AM81d8y2pz8JLNFvh1rHPA1EMwxAAeMU1cISQiJpBJGCpw5
	zy27arS7db0zal16Fe6Of/kA4zpdBHe8kekWNWSA6FKWQmK1S0P/bLeCgv5BVYsSxLMZ6nB7zkO
	0a4BqLMToW8MFvqQ1PpgCy1wE5F37eoXgknnLj95RTj3vNShPBLHQ+pgBWgp7G1aLwQBywID2xs
	+uWez8hx2Q==
X-Received: by 2002:a05:6102:5120:b0:7b1:6028:5475 with SMTP id ada2fe7eead31-7d7393580d0mr3071387137.12.1795334048377;
        Sat, 21 Nov 2026 23:54:08 -0800 (PST)
Received: from Sys0z ([2a0d:5600:6:ad1e::17])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6e7b12eb7sm8354113137.0.2026.11.21.23.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 23:54:07 -0800 (PST)
From: arzuagapozosergio@gmail.com
To: tytso@mit.edu
Cc: jack@suse.cz,
	linux-ext4@vger.kernel.org,
	Ryuji Hiroshi <182191995+root465-lipcripto@users.noreply.github.com>,
	syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
Subject: [PATCH] ext4: bound xattr journal credits to transaction limit
Date: Sun, 22 Nov 2026 02:53:55 -0500
Message-ID: <20261122075355.81772-1-arzuagapozosergio@gmail.com>
X-Mailer: git-send-email 2.56.1
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

From: Ryuji Hiroshi <182191995+root465-lipcripto@users.noreply.github.com>

When setting an xattr without XATTR_CREATE, ext4 reserves credits for
freeing an old ea_inode sized up to XATTR_SIZE_MAX, even when the
attribute does not exist. On a 1 KiB-block filesystem with a minimum
journal, this can request 341 credits while JBD2 permits 334, triggering
a warning before the setxattr operation fails.

Look up the existing attribute under xattr_sem and account for its actual
ea_inode value size. Recheck the estimate under the write lock before
modifying the xattr, since the attribute may change between estimating
credits and starting the transaction. Reject estimates above JBD2's
maximum transaction credits before starting a journal handle.

Add an EXT4 selftest covering large xattr creation and readback,
oversized replacement rejection with value preservation, XATTR_CREATE,
removal, and a small user xattr round trip.

Tested with a QEMU/KVM guest using the syzbot reproducer and the new
selftest. The original xattr operation succeeds, an oversized replacement
returns -ENOSPC without changing the old value, and e2fsck -fn exits 0
after unmount.

Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
Link: https://syzbot.org/bug?extid=25d45c0bd716f2b794a7
Signed-off-by: Ryuji Hiroshi <182191995+root465-lipcripto@users.noreply.github.com>
---
 fs/ext4/acl.c                                 |   7 +-
 fs/ext4/crypto.c                              |   5 +-
 fs/ext4/ialloc.c                              |   6 +-
 fs/ext4/xattr.c                               | 132 +++++++++++++-----
 fs/ext4/xattr.h                               |   7 +-
 fs/jbd2/transaction.c                         |   6 +
 include/linux/jbd2.h                          |   1 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/filesystems/ext4/Makefile       |   6 +
 .../ext4/ext4_xattr_journal_credits.c         |  89 ++++++++++++
 .../ext4/ext4_xattr_journal_credits.sh        |  41 ++++++
 11 files changed, 254 insertions(+), 47 deletions(-)
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
index 5c310747b..a904ea1dc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -949,7 +949,7 @@ static void ext4_xattr_inode_free_quota(struct inode *parent,
 
 int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 			     struct buffer_head *block_bh, size_t value_len,
-			     bool is_create)
+			     bool is_create, size_t old_ea_value_len)
 {
 	int credits;
 	int blocks;
@@ -998,14 +998,15 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 	/* Blocks themselves. */
 	credits += blocks;
 
-	if (!is_create) {
+	if (!is_create && old_ea_value_len) {
 		/* Dereference ea_inode holding old xattr value.
 		 * Old ea_inode, inode map, block bitmap, group descriptor.
 		 */
 		credits += 4;
 
 		/* Data blocks for old ea_inode. */
-		blocks = XATTR_SIZE_MAX >> sb->s_blocksize_bits;
+		blocks = (old_ea_value_len + sb->s_blocksize - 1) >>
+			 sb->s_blocksize_bits;
 
 		/* Indirection block or one level of extent tree for old
 		 * ea_inode.
@@ -2375,29 +2376,6 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 
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
@@ -2415,6 +2393,38 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		error = ext4_xattr_block_find(inode, &i, &bs);
 	if (error)
 		goto cleanup;
+
+	/* Check journal credits under write lock using the old value size. */
+	if (ext4_handle_valid(handle)) {
+		struct ext4_xattr_entry *entry = NULL;
+		size_t old_ea_value_len = 0;
+		int credits;
+
+		if (!is.s.not_found)
+			entry = is.s.here;
+		else if (!bs.s.not_found)
+			entry = bs.s.here;
+		if (entry && entry->e_value_inum &&
+		    !(flags & XATTR_CREATE))
+			old_ea_value_len = le32_to_cpu(entry->e_value_size);
+
+		struct buffer_head *bh = ext4_xattr_get_block(inode);
+
+		if (IS_ERR(bh)) {
+			error = PTR_ERR(bh);
+			goto cleanup;
+		}
+		credits = __ext4_xattr_set_credits(inode->i_sb, inode, bh,
+						   value_len,
+						   flags & XATTR_CREATE,
+						   old_ea_value_len);
+		brelse(bh);
+		if (jbd2_handle_buffer_credits(handle) < credits) {
+			error = -ENOSPC;
+			goto cleanup;
+		}
+		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
+	}
 	if (is.s.not_found && bs.s.not_found) {
 		error = -ENODATA;
 		if (flags & XATTR_REPLACE)
@@ -2500,28 +2510,76 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
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
+	size_t old_ea_value_len = 0;
+	int max_credits, err;
 
 	*credits = 0;
+	if (!name)
+		return -EINVAL;
+	if (strlen(name) > 255)
+		return -ERANGE;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if (!journal)
 		return 0;
 
+	/*
+	 * The old ea_inode is only charged when the target attribute currently
+	 * references one.  xattr_sem is dropped before the transaction starts,
+	 * so ext4_xattr_set_handle() repeats this check under the write lock.
+	 */
 	down_read(&EXT4_I(inode)->xattr_sem);
 
-	bh = ext4_xattr_get_block(inode);
-	if (IS_ERR(bh)) {
-		err = PTR_ERR(bh);
+	err = ext4_get_inode_loc(inode, &is.iloc);
+	if (err)
+		goto out_unlock;
+	err = ext4_xattr_ibody_find(inode, &i, &is);
+	if (err)
+		goto out;
+	if (!is.s.not_found) {
+		entry = is.s.here;
 	} else {
+		err = ext4_xattr_block_find(inode, &i, &bs);
+		if (err)
+			goto out;
+		if (!bs.s.not_found)
+			entry = bs.s.here;
+	}
+	if (!is_create && entry && entry->e_value_inum)
+		old_ea_value_len = le32_to_cpu(entry->e_value_size);
+	{
+		struct buffer_head *bh = ext4_xattr_get_block(inode);
+
+		if (IS_ERR(bh)) {
+			err = PTR_ERR(bh);
+			goto out;
+		}
 		*credits = __ext4_xattr_set_credits(inode->i_sb, inode, bh,
-						    value_len, is_create);
+						    value_len, is_create,
+						    old_ea_value_len);
 		brelse(bh);
-		err = 0;
 	}
+	max_credits = jbd2_journal_get_max_transaction_buffers(journal);
+	err = *credits > max_credits ? -ENOSPC : 0;
+out:
+	brelse(is.iloc.bh);
+	brelse(bs.bh);
+out_unlock:
 
 	up_read(&EXT4_I(inode)->xattr_sem);
 	return err;
@@ -2549,8 +2607,8 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 		return error;
 
 retry:
-	error = ext4_xattr_set_credits(inode, value_len, flags & XATTR_CREATE,
-				       &credits);
+	error = ext4_xattr_set_credits(inode, name_index, name, value_len,
+				       flags & XATTR_CREATE, &credits);
 	if (error)
 		return error;
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 821dc6a50..e98379eed 100644
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
+				bool is_create, size_t old_ea_value_len);
 
 extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   int extra_credits);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 85d84d909..cbc5c8775 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -194,6 +194,12 @@ static int jbd2_max_user_trans_buffers(journal_t *journal)
 				journal->j_transaction_overhead_buffers;
 }
 
+int jbd2_journal_get_max_transaction_buffers(journal_t *journal)
+{
+	return jbd2_max_user_trans_buffers(journal);
+}
+EXPORT_SYMBOL(jbd2_journal_get_max_transaction_buffers);
+
 /*
  * Wait until we can add credits for handle to the running transaction.  Called
  * with j_state_lock held for reading. Returns 0 if handle joined the running
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e3886963b..ed09abac1 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1523,6 +1523,7 @@ static inline handle_t *journal_current_handle(void)
  */
 
 extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
+int jbd2_journal_get_max_transaction_buffers(journal_t *journal);
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
index 000000000..b271567c0
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_GEN_PROGS := ext4_xattr_journal_credits
+TEST_PROGS := ext4_xattr_journal_credits.sh
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
new file mode 100644
index 000000000..13f4f6673
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.c
@@ -0,0 +1,89 @@
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
+#define LARGE_VALUE_SIZE 65296
+
+static int fail(const char *what)
+{
+	fprintf(stderr, "FAIL: %s: %s\n", what, strerror(errno));
+	return 1;
+}
+
+int main(int argc, char **argv)
+{
+	char path[4096];
+	char *value, *readback;
+	int path_len;
+	static const char large_name[] = "security.ima";
+	static const char small_name[] = "user.ext4-credit-test";
+	static const char small_value[] = "small-xattr";
+	char small_readback[sizeof(small_value)];
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s MOUNTPOINT\n", argv[0]);
+		return 2;
+	}
+	path_len = snprintf(path, sizeof(path), "%s/credit-test", argv[1]);
+	if (path_len < 0 || (size_t)path_len >= sizeof(path)) {
+		fprintf(stderr, "Mount path is too long\n");
+		return 2;
+	}
+
+	if (creat(path, 0600) < 0)
+		return fail("create test file");
+
+	value = malloc(LARGE_VALUE_SIZE);
+	readback = malloc(LARGE_VALUE_SIZE);
+	if (!value || !readback)
+		return fail("allocate xattr buffers");
+	memset(value, 0x5a, LARGE_VALUE_SIZE);
+	value[0] = 1;
+
+	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, 0) < 0)
+		return fail("create large ea_inode xattr");
+	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=
+	    LARGE_VALUE_SIZE || memcmp(value, readback, LARGE_VALUE_SIZE))
+		return fail("verify newly created xattr");
+	puts("PASS: large xattr creation and readback");
+
+	value[0] = 2;
+	errno = 0;
+	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, XATTR_REPLACE) !=
+	    -1 || errno != ENOSPC)
+		return fail("oversized replacement should return ENOSPC");
+	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=
+	    LARGE_VALUE_SIZE || readback[0] != 1)
+		return fail("failed replacement changed the old value");
+	puts("PASS: oversized replacement rejected without changing old value");
+
+	errno = 0;
+	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, XATTR_CREATE) !=
+	    -1 || errno != EEXIST)
+		return fail("XATTR_CREATE on existing name should return EEXIST");
+	puts("PASS: XATTR_CREATE semantics");
+
+	if (removexattr(path, large_name) < 0)
+		return fail("remove large xattr");
+	puts("PASS: large xattr removal");
+
+	if (setxattr(path, small_name, small_value, sizeof(small_value), 0) < 0)
+		return fail("create small user xattr");
+	if (getxattr(path, small_name, small_readback, sizeof(small_readback)) !=
+	    sizeof(small_value) ||
+	    memcmp(small_value, small_readback, sizeof(small_value)))
+		return fail("verify small user xattr");
+	if (removexattr(path, small_name) < 0)
+		return fail("remove small user xattr");
+	puts("PASS: small user xattr create, readback, and removal");
+
+	free(readback);
+	free(value);
+	return 0;
+}
diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
new file mode 100755
index 000000000..837329fbd
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits.sh
@@ -0,0 +1,41 @@
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
+for command in mkfs.ext4 mount umount truncate e2fsck; do
+	command -v "$command" >/dev/null 2>&1 || skip "missing $command"
+done
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
+mkfs.ext4 -q -F -b 1024 -O ea_inode -J size=1 "$test_dir/fs.img" || exit 1
+mkdir "$test_dir/mnt" || exit 1
+mount -t ext4 -o loop "$test_dir/fs.img" "$test_dir/mnt" || exit 1
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

