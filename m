Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DE2C187
	for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 08:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780214509; cv=none; b=d+1V/GDeggq+CDK3RtVJtISkuk4hD9UIdmjXfXoCcxguRBF3c2FQvOQ7TBdKplg3yJqH6BsDqNWb4UbibpNmcs9lsyWoZ4Mwv3aCeXtlo02vb4BZM2FXtkwPY0wqmYGn0Q5SH+/R4Lxx2K29Dl+bPfcbI1/rMhqclDaSv87hxyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780214509; c=relaxed/simple;
	bh=WnlAE8Ukw15zMl5Mq87OS/KwhzZ7EVfeODCY+QpNEwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d+jChbqTgefwV4s9H+7GXb/tFjKv6pCtqSu1MkhanGSeyNQXQqbZKpKBKLexOyKcNAoM0x3UITIX6QO+QZgSBSIae0CH0XruWt1D5lzdcTWbCyNko+csEPpTaHzaIVHLkYFJdyujaXM40Ono+aKe2U95TcJc58o8GLaGUqyu/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=dKLtZLhT; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="dKLtZLhT"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf237e1433so21392235ad.1
        for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 01:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780214505; x=1780819305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nUef9sNwRoN0uICwU5o8yqLsbz/MtxfeVdh9b3GdS38=;
        b=dKLtZLhTnhz/uX39CkF1V8BTSer6URF/ezQPAhaA8V5kR7HsyqxTlj9ROqAdt8oACk
         8ALfhnHNpgzXDLftiadQT2v9e5fm37FIAkxrEYuYCiK3jE34ju5rccXTG/zBtqMJ/yhE
         7ZBU6Xh227DTKr1HoFr9hqBuFiBeCt95gM5i24KjDkabXJ1E2evO8qiIT10bIwDyKMzQ
         t9Tvkzjwr9SmTUo9M5WSmgbF5oUJKXTIxfAv2PUNV7vG2RcRXefxz8ankarqwKRUfk/T
         AbjXac8rbEzgR57L2daE7GjSODtUjY9CVKBrBPSlMv/xpSrw3MgtynWDSWBAdzAAN6kk
         bLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780214505; x=1780819305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nUef9sNwRoN0uICwU5o8yqLsbz/MtxfeVdh9b3GdS38=;
        b=In7OIHCBzDZLlgRUoKCfViEEN6f02UKNNcaNQHJPftcwpsGirw70Kn5dBhL+IeGokk
         kjV6lZNwBwl6fLFxsQRj+oy6hAqqclhs/nyshbN3NxPnIpZX0uJuhJavh9TGpBk1Y5Sg
         7d+KWez7f9+mIVY8aGzYlrcMjq467ywZ0SMEGBJFPOMVOVL3aXBETpWTDupcJjJxM37W
         /LXHnTFM6HhwFBYeLjrPx+cCvS4tRaunVUdv420wWric1syUvowUm86e+KQiPsUwZD5t
         U3pNGXmhmENElr5CGNP+QPB9uy/sCw6GqAijTzcfiE/YV5ah3w07plmhppGl3v2jJ9+9
         AiIg==
X-Gm-Message-State: AOJu0YztzLPTO4u9lIAgestcZ7zUpcRtciQfr7YoQmyWjgGY9EahsoD4
	wyX/HrD5oiUuP9Ry6xWjOORTCnbgF8AUzie6K3C9YRfK4yWrmfjX0jghj7mIS7I8Zw7dLTefVvG
	aaDT9
X-Gm-Gg: Acq92OHvM7V05eKxVU01pUW45qLAsBIN6bL7UJpNahIOT6bK6VVoC+f43+4a5f3I7Ef
	coHQE5iQRvqS0g2sH7Q9qiciv7/zf6dG2XGBYbDh5ytyIt3slA+q4CITmZKZEU82IRWdgI1QF3B
	Mzyfe5wxkzJMsttsQrTVUdlDGBTJGDugUdb1c4OJgQ+yHE9Ihfz5T2L5rknI3dSVrC6NODJC3dn
	wRJo7ioQY/O0clxt7lwE8SMcbitAvrwR7DwXGv37+j8MZijlhH2KfprguzmXinVjVFQfXzEfE02
	uwQLhDza/LsjzJPgJ6qK56jLbZiR8LflgeU+lU7nQtBil+ZTXhmeoONEnALigcqQ7uiSpg/+lpH
	bXq+6qhHGiBFwXMfLfzU/DsVXnEokDuM2of2UuUZZHINK/nGjJ48+23vzXKdTtyQb0gUBWRU6NO
	Yf3FpvfL1iIAeFuZzeV558AGMkV1GBHj3ejSvZpqSpNigsaZ3WHboPy8QB
X-Received: by 2002:a17:903:17c8:b0:2bd:8dbb:293e with SMTP id d9443c01a7336-2bf367c80b3mr77372935ad.14.1780214505264;
        Sun, 31 May 2026 01:01:45 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:429:4bda:e5dc:8a16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c3f496sm70588225ad.76.2026.05.31.01.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 01:01:44 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	edward062254@gmail.com,
	visitorckw@gmail.com,
	david.laight.linux@gmail.com,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: [PATCH v6 1/2] ext4: add Kunit coverage for directory hash computation
Date: Sun, 31 May 2026 16:00:18 +0800
Message-Id: <20260531080019.3794809-2-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
References: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce Kunit tests for fs/ext4/hash.c to verify ext4fs_dirhash()
across the legacy, half-MD4, and TEA hash variants.

The tests cover empty, seeded hashing, and non-ASCII name handling.
They also verify error paths, including invalid hash versions and
SipHash without a configured key, and check that the signed and
unsigned hash variants differ on non-ASCII input as expected.

When CONFIG_UNICODE is enabled, the tests further verify casefolded-name
hashing and the fallback behavior for invalid input.

Co-developed-by: Chen Hao Yu <edward062254@gmail.com>
Signed-off-by: Chen Hao Yu <edward062254@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 fs/ext4/Makefile    |   2 +-
 fs/ext4/hash-test.c | 567 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/hash.c      |   4 +
 3 files changed, 572 insertions(+), 1 deletion(-)
 create mode 100644 fs/ext4/hash-test.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 3baee4e7c..3f9fc0eb8 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -15,7 +15,7 @@ ext4-y	:= balloc.o bitmap.o block_validity.o dir.o ext4_jbd2.o extents.o \
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-test-objs				+= inode-test.o mballoc-test.o \
-					   extents-test.o
+					   extents-test.o hash-test.o
 obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
 ext4-$(CONFIG_FS_ENCRYPTION)		+= crypto.o
diff --git a/fs/ext4/hash-test.c b/fs/ext4/hash-test.c
new file mode 100644
index 000000000..49b0d874c
--- /dev/null
+++ b/fs/ext4/hash-test.c
@@ -0,0 +1,567 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for ext4 directory hash computation.
+ */
+
+#include <kunit/test.h>
+#include <kunit/resource.h>
+#include <linux/fs.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/unicode.h>
+#include "ext4.h"
+
+static void ext4_hash_init_fake_dir(struct inode *dir, struct super_block *sb)
+{
+	memset(sb, 0, sizeof(*sb));
+	memset(dir, 0, sizeof(*dir));
+	dir->i_sb = sb;
+	strscpy(sb->s_id, "kunit-ext4", sizeof(sb->s_id));
+}
+
+static void ext4_hash_init_fake_dir_with_sbi(struct inode *dir,
+					     struct super_block *sb,
+					     struct ext4_sb_info *sbi)
+{
+	ext4_hash_init_fake_dir(dir, sb);
+	memset(sbi, 0, sizeof(*sbi));
+	sb->s_fs_info = sbi;
+	sbi->s_sb = sb;
+}
+
+#ifdef CONFIG_FS_ENCRYPTION
+static const struct fscrypt_operations ext4_hash_test_cryptops = {
+	.inode_info_offs =
+		(int)offsetof(struct ext4_inode_info, i_crypt_info) -
+		(int)offsetof(struct ext4_inode_info, vfs_inode),
+};
+#endif
+
+static void ext4_hash_init_fake_ext4_dir(struct ext4_inode_info *ei,
+					 struct super_block *sb,
+					 struct ext4_sb_info *sbi)
+{
+	struct inode *dir = &ei->vfs_inode;
+
+	memset(sb, 0, sizeof(*sb));
+	memset(ei, 0, sizeof(*ei));
+	memset(sbi, 0, sizeof(*sbi));
+
+	strscpy(sb->s_id, "kunit-ext4", sizeof(sb->s_id));
+	sb->s_fs_info = sbi;
+	sbi->s_sb = sb;
+
+	dir->i_sb = sb;
+	dir->i_mode = S_IFDIR;
+
+#ifdef CONFIG_FS_ENCRYPTION
+	fscrypt_set_ops(sb, &ext4_hash_test_cryptops);
+#endif
+}
+
+struct ext4_dirhash_test_case {
+	const char *name;
+	u32 hash_version;
+	const char *input;
+	int len;
+	u32 seed[4];
+	bool use_seed;
+	u32 expected_hash;
+	u32 expected_minor_hash;
+};
+
+static const struct ext4_dirhash_test_case ext4_dirhash_test_cases[] = {
+	{
+		.name = "legacy_abc",
+		.hash_version = DX_HASH_LEGACY,
+		.input = "abc",
+		.len = 3,
+		.use_seed = false,
+		.expected_hash = 0x75afd992,
+		.expected_minor_hash = 0x00000000,
+	},
+	{
+		.name = "legacy_unsigned_abc",
+		.hash_version = DX_HASH_LEGACY_UNSIGNED,
+		.input = "abc",
+		.len = 3,
+		.use_seed = false,
+		.expected_hash = 0x75afd992,
+		.expected_minor_hash = 0x00000000,
+	},
+	{
+		.name = "half_md4_abc",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "abc",
+		.len = 3,
+		.use_seed = false,
+		.expected_hash = 0xd196a868,
+		.expected_minor_hash = 0xc420eb28,
+	},
+	{
+		.name = "half_md4_unsigned_abc",
+		.hash_version = DX_HASH_HALF_MD4_UNSIGNED,
+		.input = "abc",
+		.len = 3,
+		.use_seed = false,
+		.expected_hash = 0xd196a868,
+		.expected_minor_hash = 0xc420eb28,
+	},
+	{
+		.name = "tea_abc",
+		.hash_version = DX_HASH_TEA,
+		.input = "abc",
+		.len = 3,
+		.use_seed = false,
+		.expected_hash = 0xb1435ec4,
+		.expected_minor_hash = 0x3f7eaa0e,
+	},
+	{
+		.name = "tea_unsigned_abc",
+		.hash_version = DX_HASH_TEA_UNSIGNED,
+		.input = "abc",
+		.len = 3,
+		.use_seed = false,
+		.expected_hash = 0xb1435ec4,
+		.expected_minor_hash = 0x3f7eaa0e,
+	},
+	{
+		.name = "empty_half_md4",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "",
+		.len = 0,
+		.use_seed = false,
+		.expected_hash = 0xefcdab88,
+		.expected_minor_hash = 0x98badcfe,
+	},
+	{
+		.name = "half_md4_31bytes",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "1234567890123456789012345678901",
+		.len = 31,
+		.use_seed = false,
+		.expected_hash = 0xc4db1f78,
+		.expected_minor_hash = 0xea23921b,
+	},
+	{
+		.name = "half_md4_32bytes",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "12345678901234567890123456789012",
+		.len = 32,
+		.use_seed = false,
+		.expected_hash = 0xfa6cc63e,
+		.expected_minor_hash = 0x2f77bd1c,
+	},
+	{
+		.name = "half_md4_33bytes",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "123456789012345678901234567890123",
+		.len = 33,
+		.use_seed = false,
+		.expected_hash = 0xdc0c2dec,
+		.expected_minor_hash = 0x5ca23365,
+	},
+	{
+		.name = "half_md4_unsigned_31bytes",
+		.hash_version = DX_HASH_HALF_MD4_UNSIGNED,
+		.input = "1234567890123456789012345678901",
+		.len = 31,
+		.use_seed = false,
+		.expected_hash = 0xc4db1f78,
+		.expected_minor_hash = 0xea23921b,
+	},
+	{
+		.name = "half_md4_unsigned_32bytes",
+		.hash_version = DX_HASH_HALF_MD4_UNSIGNED,
+		.input = "12345678901234567890123456789012",
+		.len = 32,
+		.use_seed = false,
+		.expected_hash = 0xfa6cc63e,
+		.expected_minor_hash = 0x2f77bd1c,
+	},
+	{
+		.name = "half_md4_unsigned_33bytes",
+		.hash_version = DX_HASH_HALF_MD4_UNSIGNED,
+		.input = "123456789012345678901234567890123",
+		.len = 33,
+		.use_seed = false,
+		.expected_hash = 0xdc0c2dec,
+		.expected_minor_hash = 0x5ca23365,
+	},
+	{
+		.name = "tea_15bytes",
+		.hash_version = DX_HASH_TEA,
+		.input = "123456789abcdef",
+		.len = 15,
+		.use_seed = false,
+		.expected_hash = 0xa562903a,
+		.expected_minor_hash = 0x6174a00f,
+	},
+	{
+		.name = "tea_16bytes",
+		.hash_version = DX_HASH_TEA,
+		.input = "1234567890abcdef",
+		.len = 16,
+		.use_seed = false,
+		.expected_hash = 0x8449f258,
+		.expected_minor_hash = 0x49a16d46,
+	},
+	{
+		.name = "tea_17bytes",
+		.hash_version = DX_HASH_TEA,
+		.input = "123456789abcdefgh",
+		.len = 17,
+		.use_seed = false,
+		.expected_hash = 0xf32ec10c,
+		.expected_minor_hash = 0x58ceae61,
+	},
+	{
+		.name = "half_md4_seeded",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "same-name",
+		.len = 9,
+		.seed = { 0x11111111, 0x22222222, 0x33333333, 0x44444444 },
+		.use_seed = true,
+		.expected_hash = 0x8aebf604,
+		.expected_minor_hash = 0x66ce48fe,
+	},
+	{
+		.name = "half_md4_non_ascii_signed",
+		.hash_version = DX_HASH_HALF_MD4,
+		.input = "\x80\x81\x82\x83\x84",
+		.len = 5,
+		.use_seed = false,
+		.expected_hash = 0x8bab0498,
+		.expected_minor_hash = 0xc326632d,
+	},
+	{
+		.name = "half_md4_non_ascii_unsigned",
+		.hash_version = DX_HASH_HALF_MD4_UNSIGNED,
+		.input = "\x80\x81\x82\x83\x84",
+		.len = 5,
+		.use_seed = false,
+		.expected_hash = 0xbc48596e,
+		.expected_minor_hash = 0xde0fad41,
+	},
+	{
+		.name = "tea_non_ascii_signed",
+		.hash_version = DX_HASH_TEA,
+		.input = "\x80\x81\x82\x83\x84",
+		.len = 5,
+		.use_seed = false,
+		.expected_hash = 0x21e3a154,
+		.expected_minor_hash = 0x90112c3d,
+	},
+	{
+		.name = "tea_non_ascii_unsigned",
+		.hash_version = DX_HASH_TEA_UNSIGNED,
+		.input = "\x80\x81\x82\x83\x84",
+		.len = 5,
+		.use_seed = false,
+		.expected_hash = 0x9b648616,
+		.expected_minor_hash = 0x011dd507,
+	},
+};
+
+static void test_ext4fs_dirhash_vectors(struct kunit *test)
+{
+	struct super_block *sb;
+	struct inode *dir;
+	int i;
+
+	sb = kunit_kzalloc(test, sizeof(*sb), GFP_KERNEL);
+	dir = kunit_kzalloc(test, sizeof(*dir), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb);
+	KUNIT_ASSERT_NOT_NULL(test, dir);
+
+	ext4_hash_init_fake_dir(dir, sb);
+
+	for (i = 0; i < ARRAY_SIZE(ext4_dirhash_test_cases); i++) {
+		const struct ext4_dirhash_test_case *tc =
+			&ext4_dirhash_test_cases[i];
+		struct dx_hash_info hinfo;
+		int ret;
+
+		memset(&hinfo, 0, sizeof(hinfo));
+		hinfo.hash_version = tc->hash_version;
+		hinfo.seed = tc->use_seed ? (u32 *)tc->seed : NULL;
+
+		ret = ext4fs_dirhash(dir, tc->input, tc->len, &hinfo);
+
+		KUNIT_ASSERT_EQ_MSG(test, ret, 0, "case=%s", tc->name);
+		KUNIT_EXPECT_EQ_MSG(test, hinfo.hash, tc->expected_hash,
+				    "case=%s", tc->name);
+		KUNIT_EXPECT_EQ_MSG(test, hinfo.minor_hash,
+				    tc->expected_minor_hash,
+				    "case=%s", tc->name);
+	}
+}
+
+static void test_ext4fs_dirhash_seed_changes_result(struct kunit *test)
+{
+	struct super_block *sb;
+	struct inode *dir;
+	u32 seed[4] = { 0x11111111, 0x22222222, 0x33333333, 0x44444444 };
+	struct dx_hash_info plain = {
+		.hash_version = DX_HASH_HALF_MD4,
+	};
+	struct dx_hash_info seeded = {
+		.hash_version = DX_HASH_HALF_MD4,
+		.seed = seed,
+	};
+	int ret_plain, ret_seeded;
+
+	sb = kunit_kzalloc(test, sizeof(*sb), GFP_KERNEL);
+	dir = kunit_kzalloc(test, sizeof(*dir), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb);
+	KUNIT_ASSERT_NOT_NULL(test, dir);
+
+	ext4_hash_init_fake_dir(dir, sb);
+
+	ret_plain = ext4fs_dirhash(dir, "same-name", 9, &plain);
+	ret_seeded = ext4fs_dirhash(dir, "same-name", 9, &seeded);
+
+	KUNIT_ASSERT_EQ(test, ret_plain, 0);
+	KUNIT_ASSERT_EQ(test, ret_seeded, 0);
+
+	KUNIT_EXPECT_TRUE(test,
+			  plain.hash != seeded.hash ||
+			  plain.minor_hash != seeded.minor_hash);
+}
+
+static void test_ext4fs_dirhash_invalid_version_returns_einval(struct kunit *test)
+{
+	struct super_block *sb;
+	struct inode *dir;
+	struct ext4_sb_info *sbi;
+	struct dx_hash_info hinfo = {
+		.hash = 0xdeadbeef,
+		.minor_hash = 0xcafebabe,
+		.hash_version = DX_HASH_LAST + 1,
+	};
+	int ret;
+
+	sb = kunit_kzalloc(test, sizeof(*sb), GFP_KERNEL);
+	dir = kunit_kzalloc(test, sizeof(*dir), GFP_KERNEL);
+	sbi = kunit_kzalloc(test, sizeof(*sbi), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb);
+	KUNIT_ASSERT_NOT_NULL(test, dir);
+	KUNIT_ASSERT_NOT_NULL(test, sbi);
+
+	ext4_hash_init_fake_dir_with_sbi(dir, sb, sbi);
+
+	ret = ext4fs_dirhash(dir, "abc", 3, &hinfo);
+
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+	KUNIT_EXPECT_EQ(test, hinfo.hash, 0);
+	KUNIT_EXPECT_EQ(test, hinfo.minor_hash, 0);
+}
+
+static void test_ext4fs_dirhash_siphash_without_key_returns_einval(struct kunit *test)
+{
+	struct super_block *sb;
+	struct ext4_inode_info *ei;
+	struct inode *dir;
+	struct ext4_sb_info *sbi;
+	struct dx_hash_info hinfo = {
+		.hash_version = DX_HASH_SIPHASH,
+	};
+	int ret;
+
+	sb = kunit_kzalloc(test, sizeof(*sb), GFP_KERNEL);
+	ei = kunit_kzalloc(test, sizeof(*ei), GFP_KERNEL);
+	sbi = kunit_kzalloc(test, sizeof(*sbi), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb);
+	KUNIT_ASSERT_NOT_NULL(test, ei);
+	KUNIT_ASSERT_NOT_NULL(test, sbi);
+
+	ext4_hash_init_fake_ext4_dir(ei, sb, sbi);
+	dir = &ei->vfs_inode;
+
+	ret = ext4fs_dirhash(dir, "name", strlen("name"), &hinfo);
+
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+}
+
+static void test_ext4fs_dirhash_signed_unsigned_differ_on_nonascii(struct kunit *test)
+{
+	struct super_block *sb;
+	struct inode *dir;
+	static const char input[] = "\x80\xff\x81\xfe\101bc";
+	struct dx_hash_info legacy_signed = {
+		.hash_version = DX_HASH_LEGACY,
+	};
+	struct dx_hash_info legacy_unsigned = {
+		.hash_version = DX_HASH_LEGACY_UNSIGNED,
+	};
+	struct dx_hash_info md4_signed = {
+		.hash_version = DX_HASH_HALF_MD4,
+	};
+	struct dx_hash_info md4_unsigned = {
+		.hash_version = DX_HASH_HALF_MD4_UNSIGNED,
+	};
+	struct dx_hash_info tea_signed = {
+		.hash_version = DX_HASH_TEA,
+	};
+	struct dx_hash_info tea_unsigned = {
+		.hash_version = DX_HASH_TEA_UNSIGNED,
+	};
+	int ret;
+
+	sb = kunit_kzalloc(test, sizeof(*sb), GFP_KERNEL);
+	dir = kunit_kzalloc(test, sizeof(*dir), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb);
+	KUNIT_ASSERT_NOT_NULL(test, dir);
+
+	ext4_hash_init_fake_dir(dir, sb);
+
+	ret = ext4fs_dirhash(dir, input, sizeof(input) - 1, &legacy_signed);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ret = ext4fs_dirhash(dir, input, sizeof(input) - 1, &legacy_unsigned);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_NE(test, legacy_signed.hash, legacy_unsigned.hash);
+
+	ret = ext4fs_dirhash(dir, input, sizeof(input) - 1, &md4_signed);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ret = ext4fs_dirhash(dir, input, sizeof(input) - 1, &md4_unsigned);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_TRUE(test,
+			  md4_signed.hash != md4_unsigned.hash ||
+			  md4_signed.minor_hash != md4_unsigned.minor_hash);
+
+	ret = ext4fs_dirhash(dir, input, sizeof(input) - 1, &tea_signed);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ret = ext4fs_dirhash(dir, input, sizeof(input) - 1, &tea_unsigned);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_TRUE(test,
+			  tea_signed.hash != tea_unsigned.hash ||
+			  tea_signed.minor_hash != tea_unsigned.minor_hash);
+}
+
+#if IS_ENABLED(CONFIG_UNICODE)
+KUNIT_DEFINE_ACTION_WRAPPER(utf8_unload_action, utf8_unload,
+			    struct unicode_map *);
+static void test_ext4fs_dirhash_casefolded_names_hash_consistently(struct kunit *test)
+{
+	struct super_block *sb;
+	struct ext4_inode_info *ei;
+	struct ext4_sb_info *sbi;
+	struct unicode_map *um;
+	struct dx_hash_info h1 = {
+		.hash_version = DX_HASH_HALF_MD4,
+	};
+	struct dx_hash_info h2 = {
+		.hash_version = DX_HASH_HALF_MD4,
+	};
+	int ret, ret1, ret2;
+
+	sb = kunit_kzalloc(test, sizeof(*sb), GFP_KERNEL);
+	ei = kunit_kzalloc(test, sizeof(*ei), GFP_KERNEL);
+	sbi = kunit_kzalloc(test, sizeof(*sbi), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb);
+	KUNIT_ASSERT_NOT_NULL(test, ei);
+	KUNIT_ASSERT_NOT_NULL(test, sbi);
+
+	um = utf8_load(UTF8_LATEST);
+	if (IS_ERR(um)) {
+		kunit_skip(test, "utf8_load(UTF8_LATEST) failed: %pe",
+			   um);
+		return;
+	}
+
+	ret = kunit_add_action_or_reset(test, utf8_unload_action, um);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	ext4_hash_init_fake_ext4_dir(ei, sb, sbi);
+	sb->s_encoding = um;
+	ei->vfs_inode.i_flags |= S_CASEFOLD;
+
+	KUNIT_ASSERT_TRUE(test, IS_CASEFOLDED(&ei->vfs_inode));
+
+	ret1 = ext4fs_dirhash(&ei->vfs_inode, "Alpha", 5, &h1);
+	ret2 = ext4fs_dirhash(&ei->vfs_inode, "aLPHa", 5, &h2);
+
+	KUNIT_ASSERT_EQ(test, ret1, 0);
+	KUNIT_ASSERT_EQ(test, ret2, 0);
+	KUNIT_EXPECT_EQ(test, h1.hash, h2.hash);
+	KUNIT_EXPECT_EQ(test, h1.minor_hash, h2.minor_hash);
+}
+
+static void test_ext4fs_dirhash_casefold_fallback(struct kunit *test)
+{
+	struct super_block *sb_cf, *sb_plain;
+	struct ext4_inode_info *ei;
+	struct ext4_sb_info *sbi;
+	struct inode *plain_dir;
+	struct unicode_map *um;
+	static const char invalid_utf8[] = "\xc3\x28";
+	struct dx_hash_info folded_dir = {
+		.hash_version = DX_HASH_HALF_MD4,
+	};
+	struct dx_hash_info plain = {
+		.hash_version = DX_HASH_HALF_MD4,
+	};
+	int ret, ret_cf, ret_plain;
+
+	sb_cf = kunit_kzalloc(test, sizeof(*sb_cf), GFP_KERNEL);
+	sb_plain = kunit_kzalloc(test, sizeof(*sb_plain), GFP_KERNEL);
+	ei = kunit_kzalloc(test, sizeof(*ei), GFP_KERNEL);
+	sbi = kunit_kzalloc(test, sizeof(*sbi), GFP_KERNEL);
+	plain_dir = kunit_kzalloc(test, sizeof(*plain_dir), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sb_cf);
+	KUNIT_ASSERT_NOT_NULL(test, sb_plain);
+	KUNIT_ASSERT_NOT_NULL(test, ei);
+	KUNIT_ASSERT_NOT_NULL(test, sbi);
+	KUNIT_ASSERT_NOT_NULL(test, plain_dir);
+
+	um = utf8_load(UTF8_LATEST);
+	if (IS_ERR(um)) {
+		kunit_skip(test, "utf8_load(UTF8_LATEST) failed: %pe",
+			   um);
+		return;
+	}
+
+	ret = kunit_add_action_or_reset(test, utf8_unload_action, um);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	ext4_hash_init_fake_ext4_dir(ei, sb_cf, sbi);
+	sb_cf->s_encoding = um;
+	ei->vfs_inode.i_flags |= S_CASEFOLD;
+
+	KUNIT_ASSERT_TRUE(test, IS_CASEFOLDED(&ei->vfs_inode));
+
+	ext4_hash_init_fake_dir(plain_dir, sb_plain);
+
+	ret_cf = ext4fs_dirhash(&ei->vfs_inode, invalid_utf8,
+				sizeof(invalid_utf8) - 1, &folded_dir);
+	ret_plain = ext4fs_dirhash(plain_dir, invalid_utf8,
+				   sizeof(invalid_utf8) - 1, &plain);
+
+	KUNIT_ASSERT_EQ(test, ret_cf, 0);
+	KUNIT_ASSERT_EQ(test, ret_plain, 0);
+	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
+	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
+}
+#endif
+
+static struct kunit_case ext4_hash_test_cases[] = {
+	KUNIT_CASE(test_ext4fs_dirhash_vectors),
+	KUNIT_CASE(test_ext4fs_dirhash_seed_changes_result),
+	KUNIT_CASE(test_ext4fs_dirhash_invalid_version_returns_einval),
+	KUNIT_CASE(test_ext4fs_dirhash_siphash_without_key_returns_einval),
+	KUNIT_CASE(test_ext4fs_dirhash_signed_unsigned_differ_on_nonascii),
+#if IS_ENABLED(CONFIG_UNICODE)
+	KUNIT_CASE(test_ext4fs_dirhash_casefolded_names_hash_consistently),
+	KUNIT_CASE(test_ext4fs_dirhash_casefold_fallback),
+#endif
+	{}
+};
+
+static struct kunit_suite ext4_hash_test_suite = {
+	.name = "ext4_hash",
+	.test_cases = ext4_hash_test_cases,
+};
+
+kunit_test_suites(&ext4_hash_test_suite);
+
+MODULE_LICENSE("GPL");
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 48483cd01..72645bd92 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -321,3 +321,7 @@ int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 #endif
 	return __ext4fs_dirhash(dir, name, len, hinfo);
 }
+
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4fs_dirhash);
+#endif
-- 
2.34.1

