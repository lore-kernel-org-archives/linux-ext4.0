Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=e92U4fXIs2Mv9I2dy8FYwtKJnXwjCPx+JSKmf+cy0jY32fuZVmlxm4ytZR4urPopajA/
	 9Ekgxhw2pMJpzuWUI0+Any7TEKPPIys26RdisHprz2PqbwgUIaTArNFNqCPK7RX9wjl9j
	 t/vxPClaSTiZ1rRlgacsx1gUHmdpqI5iR0P6xqkZcd/nnr2ea+0mFI0AkH4XXgKq7Nn/n
	 /C2kGr10Jz1mfDMGhJHySnCSCy89PWP8oEsgOBS7POGPey4JiaLIAHB/tqZbl/MuiURwF
	 BR3B3sOIlKjXBsfhQ6Rrgjbrys2Q42iNaz3Jdku2Yja0ETtA9xo6dN6SiPhvOevbz8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6ZsnNLa7T/OWoqFeyBqirfXtpbpvWV4Rc5ffulz0U2c=;
	b=4sMy3Mg2q2+79tRa9cLB7aiRZMCODR/dop9hO5IgRK1GrpIERUQKvDkGcLvbFITgiarh
	 7K6oD7IpWw5GmTbrunZUIPTrXsjU4oJIRofJAxJHU4X2HwY7ImQjg3bEY/MQl7DLQFr45
	 1P9U2GFKt5BtDjyNErpihgPg3kTm2igSIZKbbbeCpqBfXpMESPdovrTtMuE9m+OQLPG84
	 lZb4JHUYe9d4jDNn+Pls/kNFSghBHtuyEm3hOhR3cGoS86jmwM1kaIiX+XYo7pQwNanyz
	 lnpPSpb3jecJMh1HNo9eG24AVV2didrFFbRb595o5QkwKiERg03ZsGSam1D6KMEk7OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HjTkvmtx;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CFB60A2601
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53CFB60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HjTkvmtx
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHWBs029852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=6ZsnNLa7T/OWoqFeyBqirfXtpbpvWV4Rc5ffulz0U2c=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=HjTkvmtxr4X46QoXOS2QLvvLDfzxucVtcJFoONhgXLqX6PEi6Uel3nrAXLv64wa2E
	 S8iE5kjz2jlXxii+j9PD6Rf9HcAj/67p3JlefWhmW75v7MRwczVtxTTY6es1Q6T3zM
	 0NnCZTBIVqI2QBNUaoWjk/7sQyqnlIuDVZVdVW7KdSKDTd7JS//W6vs/KCnuBJGE7w
	 JX76MUyPt5rbBhYaqo0nhQ9/xR2szDKaRlHlUoTdTso4JkO/GoImDU/1uUxUFMv7cB
	 wOiiGpgmv5T5CfVZJctVSaNrAPZhaiPL4pJlHgXo3bHHzcd11TqAUy9I1arB/4sB7T
	 2FVyM14fp66Og==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 240A52E0148; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 06/32] ext4: handle s_lastcheck_hi in the get/set tune superblock ioctls
Date: Thu, 19 Nov 2026 14:16:53 -0500
Message-ID: <20261119191719.1943298-7-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
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

struct ext4_tune_sb_params exposes last_check_time as a __u64, and the
superblock stores the time of the last check as a 40-bit value split
between s_lastcheck and s_lastcheck_hi.  However,
EXT4_IOC_GET_TUNE_SB_PARAM only reports s_lastcheck, and
EXT4_IOC_SET_TUNE_SB_PARAM only writes s_lastcheck, leaving any
existing s_lastcheck_hi in place.

So timestamps past 2106 are truncated when read, and setting the last
check time on a file system whose s_lastcheck_hi is non-zero results
in a timestamp that is off by a multiple of 2^32 seconds, which
confuses the time-based fsck check in ext4_setup_super() and e2fsck.

Read and write s_lastcheck_hi along with s_lastcheck, and reject
values which don't fit in the 40-bit on-disk representation.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 62 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c      | 12 +++++++--
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index bcc150a83d8f..ea91b8827e96 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -17,6 +17,7 @@
 #include <linux/iversion.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/part_stat.h>
@@ -27,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
+#include <linux/uaccess.h>
 #include <linux/uuid.h>
 #include <linux/workqueue.h>
 
@@ -901,6 +903,65 @@ static void test_tune_sb_feature_prereqs(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, sbi->s_csum_seed, seed);
 }
 
+/*
+ * Verify that last_check_time is validated against, stored to, and
+ * reported from the 40-bit s_lastcheck / s_lastcheck_hi timestamp.
+ */
+static void test_tune_sb_last_check_time(struct kunit *test)
+{
+	struct ioctl_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	struct ext4_sb_info *sbi = &ctx->sbi;
+	struct ext4_super_block *es = ctx->es;
+	struct ext4_tune_sb_params params;
+	struct vfsmount mnt = {
+		.mnt_root	= sb->s_root,
+		.mnt_sb		= sb,
+		.mnt_idmap	= &nop_mnt_idmap,
+	};
+	struct file filp = {
+		.f_inode	= d_inode(sb->s_root),
+		.f_path		= {
+			.mnt	= &mnt,
+			.dentry	= sb->s_root,
+		},
+		.f_mode		= FMODE_READ,
+	};
+	unsigned long uaddr;
+
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_LAST_CHECK_TIME;
+	params.last_check_time = 1ULL << 40;
+	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			-EINVAL);
+
+	params.last_check_time = 0x123456789aULL;
+	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			0);
+	es->s_lastcheck_hi = 0xff;
+	ext4_sb_setparams_test(sbi, es, &params);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_lastcheck), 0x3456789aU);
+	KUNIT_EXPECT_EQ(test, es->s_lastcheck_hi, 0x12);
+
+	/* EXT4_IOC_GET_TUNE_SB_PARAM reports all 40 bits */
+	uaddr = kunit_vm_mmap(test, NULL, 0, PAGE_SIZE,
+			      PROT_READ | PROT_WRITE,
+			      MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	KUNIT_ASSERT_NE_MSG(test, uaddr, 0UL, "Could not create user mm");
+	KUNIT_ASSERT_LT_MSG(test, uaddr, (unsigned long)TASK_SIZE,
+			    "Failed to allocate user memory");
+
+	KUNIT_ASSERT_EQ(test,
+			ext4_ioctl(&filp, EXT4_IOC_GET_TUNE_SB_PARAM, uaddr),
+			0);
+	memset(&params, 0, sizeof(params));
+	KUNIT_ASSERT_EQ(test,
+			copy_from_user(&params, (void __user *)uaddr,
+				       sizeof(params)),
+			0UL);
+	KUNIT_EXPECT_EQ(test, params.last_check_time, 0x123456789aULL);
+}
+
 /*
  * Verify ext4_update_backup_sb, ext4_update_superblocks_fn, and
  * ext4_update_overhead across primary + 4 sparse_super backup groups (1, 3,
@@ -1427,6 +1488,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_tune_sb_dir_index_hash_state),
 	KUNIT_CASE(test_tune_sb_feature_prereqs),
+	KUNIT_CASE(test_tune_sb_last_check_time),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 4ccdf98ed7a0..f296a5ee1f45 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1308,7 +1308,8 @@ static int ext4_ioctl_get_tune_sb(struct ext4_sb_info *sbi,
 	ret.mnt_count = le16_to_cpu(es->s_mnt_count);
 	ret.max_mnt_count = le16_to_cpu(es->s_max_mnt_count);
 	ret.checkinterval = le32_to_cpu(es->s_checkinterval);
-	ret.last_check_time = le32_to_cpu(es->s_lastcheck);
+	ret.last_check_time = ((u64)es->s_lastcheck_hi << 32) |
+			      le32_to_cpu(es->s_lastcheck);
 	ret.reserved_blocks = ext4_r_blocks_count(es);
 	ret.blocks_count = ext4_blocks_count(es);
 	ret.reserved_uid = ext4_get_resuid(es);
@@ -1347,8 +1348,10 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		es->s_max_mnt_count = cpu_to_le16(params->max_mnt_count);
 	if (params->set_flags & EXT4_TUNE_FL_CHECKINTRVAL)
 		es->s_checkinterval = cpu_to_le32(params->checkinterval);
-	if (params->set_flags & EXT4_TUNE_FL_LAST_CHECK_TIME)
+	if (params->set_flags & EXT4_TUNE_FL_LAST_CHECK_TIME) {
 		es->s_lastcheck = cpu_to_le32(params->last_check_time);
+		es->s_lastcheck_hi = upper_32_bits(params->last_check_time);
+	}
 	if (params->set_flags & EXT4_TUNE_FL_RESERVED_BLOCKS) {
 		ext4_fsblk_t blk = params->reserved_blocks;
 
@@ -1434,6 +1437,11 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 	    (params->errors_behavior > EXT4_ERRORS_PANIC))
 		return -EINVAL;
 
+	/* s_lastcheck{,_hi} hold a 40-bit timestamp */
+	if ((params->set_flags & EXT4_TUNE_FL_LAST_CHECK_TIME) &&
+	    (params->last_check_time >> 40))
+		return -EINVAL;
+
 	if ((params->set_flags & EXT4_TUNE_FL_RESERVED_BLOCKS) &&
 	    (params->reserved_blocks > ext4_blocks_count(sbi->s_es) / 2))
 		return -EINVAL;
-- 
2.56.1.708.g77570a6a1d-goog

