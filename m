Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458845;
	b=d/+u5ipOxSAwa21IT4eUHFh/o6kwEhxDMs2twoq74Emcd0AwBGhSbOa6sOlUlZ/melMk
	 621wo4RgnGKxQ8DUZFPmVuLrIrUtI1+tZSJ7k36Y43Rwa9WiqHfO1dQ5JFoeumNO9ljx9
	 EdZ4VuFHSjYAMNfC2PKgLEDU8fXgYnFjORusIaZeeSPjQhVX+2RhsgG1/kBg3gEt54Y//
	 7TLz2hXIx1l4xc7T62jbYCv3LRPvMFFRMvFNLtBCkjgo1B3BUq46bUaSqOV8RIerLNlxx
	 iYgNDqGzazfLWR6mbTfrjrmX07qckD4evGYg1+sVvxxrQ0p5FGjAoAPSewbZjmhhU5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7PBD4lC+fgQap3VnBACnP+7Lk0O+RNcNFMi88IcbhNk=;
	b=iyTh6wv7CD35IqkzPThCU2H5pQbfzOgogYWJqNFObJOh3DnfZ8yCY9LsQVaKjd5seGyL
	 /lbAsoMxSBDBw5azl4LdH/pIIVvmOBBEKHXarfmofWN9EDHsB8j1xNv3kvklbUB79AFfY
	 TbewvTFcghi59E+Kd5LMhrNgu75YHozIfVC/ORYnxIjiTXzPPDSzb64F4b8iqw7Rkm1gx
	 FHDtOn3pk8ygr52wCtE8o0qTkX3WNnr4e7A4hGN5Zls+d04lZdQQXY5CKEEg/npw6YtSm
	 Xr6JoZbK6ZGLyGwKplJFmrRTpSfYiTdTXc6f6RQeBEPbWOioqKvNeVaLD1aHv0iY7FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Pwtw08QN;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681EF606A338
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 681EF606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Pwtw08QN
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lK5M031180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=7PBD4lC+fgQap3VnBACnP+7Lk0O+RNcNFMi88IcbhNk=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Pwtw08QN4mONSW8eJREVO7aMF2Rh1/MiI0dgJ7NlZ77UAO+IYT0Bv70QjjqjnEIKW
	 EV+4VJGwJnZ1MxS3TIxpsqlMGjV5gGwHm8U208s/KYg2AMf9rzEgAAkvCEGgFojIrj
	 TwOOvpXNPgtr0JxJWQxXG6iYVHbtA+JUVU7QuLsna0FfmEwbQeaPVrf39tF/VXxcV3
	 Ba6PTUmIrfBcHps2cUSGFbVzb4aHuitImufDYWcGOwIoZRhkKcWtWh4PoT9NoQB56R
	 Lv7PpvRSnPFDyXyNRAVVBu1kDNcyAlYW1oMWDoQDa/OO/9kF3xm+fRixxMz4JQu5bq
	 d6+VMyJmDO1cw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 332A92E0148; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 06/23] ext4: handle s_lastcheck_hi in the get/set tune superblock ioctls
Date: Wed, 11 Nov 2026 23:46:55 -0500
Message-ID: <20261112044712.1577296-7-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112044712.1577296-1-tytso@mit.edu>
References: <20261112044712.1577296-1-tytso@mit.edu>
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
index fd7b4ff2cd81..831b7e032fad 100644
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
 
@@ -889,6 +891,65 @@ static void test_tune_sb_feature_prereqs(struct kunit *test)
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
@@ -1398,6 +1459,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_tune_sb_dir_index_hash_state),
 	KUNIT_CASE(test_tune_sb_feature_prereqs),
+	KUNIT_CASE(test_tune_sb_last_check_time),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 8bd4958217e0..9e2bde83a033 100644
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
 
@@ -1432,6 +1435,11 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
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
2.56.0.542.g3ef89b7020-goog

