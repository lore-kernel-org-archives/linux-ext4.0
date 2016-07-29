From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add ability to control the pseudo-random seed used by ext4
Date: Fri, 29 Jul 2016 12:00:35 -0400
Message-ID: <20160729160035.26626-1-tytso@mit.edu>
Cc: agayev@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57010 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbcG2QAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jul 2016 12:00:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 uses a pseudo-random generator in a few places: to spread out
directories when htree is not enabled; to randomize thethe wait times
for MMP backoff and lazy inode table initialization.  For benchmarking
purposes, it's useful to control the psueorandom number seed, expose
this via /sys/fs/ext4/<dev>/prandom_seed.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h         |  4 ++++
 fs/ext4/ialloc.c       |  6 ++++--
 fs/ext4/mmp.c          |  6 +++---
 fs/ext4/super.c        |  3 ++-
 fs/ext4/sysfs.c        | 20 ++++++++++++++++++++
 include/linux/random.h |  1 +
 lib/random32.c         | 10 +++++-----
 7 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ea31931..3dbb03a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -35,6 +35,7 @@
 #include <linux/fscrypto.h>
 #include <linux/falloc.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/random.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
@@ -1491,6 +1492,9 @@ struct ext4_sb_info {
 	/* Precomputed FS UUID checksum for seeding other checksums */
 	__u32 s_csum_seed;
 
+	/* RND state for the file system */
+	struct rnd_state s_rnd_state;
+
 	/* Reclaim extents from extent status tree */
 	struct shrinker s_es_shrinker;
 	struct list_head s_es_list;	/* List of inodes with reclaimable extents */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 35f3518..09a1458 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -485,8 +485,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 			hinfo.seed = sbi->s_hash_seed;
 			ext4fs_dirhash(qstr->name, qstr->len, &hinfo);
 			grp = hinfo.hash;
-		} else
-			grp = prandom_u32();
+		} else {
+			grp = prandom_u32_state(&sbi->s_rnd_state);
+			pr_err("ext4 random: %lu\n", grp);
+		}
 		parent_group = (unsigned)grp % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			g = (parent_group + i) % ngroups;
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 23d436d..99f69dc 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -258,12 +258,12 @@ exit_thread:
  * Get a random new sequence number but make sure it is not greater than
  * EXT4_MMP_SEQ_MAX.
  */
-static unsigned int mmp_new_seq(void)
+static unsigned int mmp_new_seq(struct ext4_sb_info *sbi)
 {
 	u32 new_seq;
 
 	do {
-		new_seq = prandom_u32();
+		new_seq = prandom_u32_state(&sbi->s_rnd_state);
 	} while (new_seq > EXT4_MMP_SEQ_MAX);
 
 	return new_seq;
@@ -342,7 +342,7 @@ skip:
 	/*
 	 * write a new random sequence number.
 	 */
-	seq = mmp_new_seq();
+	seq = mmp_new_seq(EXT4_SB(sb));
 	mmp->mmp_seq = cpu_to_le32(seq);
 
 	retval = write_mmp_block(sb, bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c13a4e4..2c86b98 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2969,7 +2969,7 @@ static struct ext4_li_request *ext4_li_request_new(struct super_block *sb,
 	 * spread the inode table initialization requests
 	 * better.
 	 */
-	elr->lr_next_sched = jiffies + (prandom_u32() %
+	elr->lr_next_sched = jiffies + (prandom_u32_state(&sbi->s_rnd_state) %
 				(EXT4_DEF_LI_MAX_START_DELAY * HZ));
 	return elr;
 }
@@ -3274,6 +3274,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_bdev->bd_part)
 		sbi->s_sectors_written_start =
 			part_stat_read(sb->s_bdev->bd_part, sectors[1]);
+	_prandom_seed(&sbi->s_rnd_state, 0, true);
 
 	/* Cleanup superblock name */
 	strreplace(sb->s_id, '/', '!');
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 1420a3c..f74d34b 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -26,6 +26,7 @@ typedef enum {
 	attr_feature,
 	attr_pointer_ui,
 	attr_pointer_atomic,
+	attr_prandom_seed,
 } attr_id_t;
 
 typedef enum {
@@ -90,6 +91,21 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	return count;
 }
 
+static ssize_t prandom_seed_store(struct ext4_attr *a,
+				  struct ext4_sb_info *sbi,
+				  const char *buf, size_t count)
+{
+	unsigned long t;
+	int ret;
+
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret)
+		return ret;
+
+	_prandom_seed(&sbi->s_rnd_state, t, false);
+	return count;
+}
+
 static ssize_t reserved_clusters_store(struct ext4_attr *a,
 				   struct ext4_sb_info *sbi,
 				   const char *buf, size_t count)
@@ -178,6 +194,7 @@ EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(extent_max_zeroout_kb, s_extent_max_zeroout_kb);
 EXT4_ATTR(trigger_fs_error, 0200, trigger_test_error);
+EXT4_ATTR(prandom_seed, 0200, prandom_seed);
 EXT4_RW_ATTR_SBI_UI(err_ratelimit_interval_ms, s_err_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_UI(err_ratelimit_burst, s_err_ratelimit_state.burst);
 EXT4_RW_ATTR_SBI_UI(warning_ratelimit_interval_ms, s_warning_ratelimit_state.interval);
@@ -216,6 +233,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(errors_count),
 	ATTR_LIST(first_error_time),
 	ATTR_LIST(last_error_time),
+	ATTR_LIST(prandom_seed),
 	NULL,
 };
 
@@ -313,6 +331,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
 		return inode_readahead_blks_store(a, sbi, buf, len);
 	case attr_trigger_test_error:
 		return trigger_test_error(a, sbi, buf, len);
+	case attr_prandom_seed:
+		return prandom_seed_store(a, sbi, buf, len);
 	}
 	return 0;
 }
diff --git a/include/linux/random.h b/include/linux/random.h
index e47e533..64b70a8 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -45,6 +45,7 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
+void _prandom_seed(struct rnd_state *state, u32 seed, bool mix_with_hwseed);
 u32 prandom_u32_state(struct rnd_state *state);
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
 void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
diff --git a/lib/random32.c b/lib/random32.c
index 510d1ce..5134111 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -157,8 +157,7 @@ static u32 __extract_hwseed(void)
 	return val;
 }
 
-static void prandom_seed_early(struct rnd_state *state, u32 seed,
-			       bool mix_with_hwseed)
+void _prandom_seed(struct rnd_state *state, u32 seed, bool mix_with_hwseed)
 {
 #define LCG(x)	 ((x) * 69069U)	/* super-duper LCG */
 #define HWSEED() (mix_with_hwseed ? __extract_hwseed() : 0)
@@ -167,6 +166,7 @@ static void prandom_seed_early(struct rnd_state *state, u32 seed,
 	state->s3 = __seed(HWSEED() ^ LCG(state->s2),  16U);
 	state->s4 = __seed(HWSEED() ^ LCG(state->s3), 128U);
 }
+EXPORT_SYMBOL(_prandom_seed);
 
 /**
  *	prandom_seed - add entropy to pseudo random number generator
@@ -204,7 +204,7 @@ static int __init prandom_init(void)
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
 		u32 weak_seed = (i + jiffies) ^ random_get_entropy();
 
-		prandom_seed_early(state, weak_seed, true);
+		_prandom_seed(state, weak_seed, true);
 		prandom_warmup(state);
 	}
 
@@ -429,7 +429,7 @@ static void __init prandom_state_selftest(void)
 	for (i = 0; i < ARRAY_SIZE(test1); i++) {
 		struct rnd_state state;
 
-		prandom_seed_early(&state, test1[i].seed, false);
+		_prandom_seed(&state, test1[i].seed, false);
 		prandom_warmup(&state);
 
 		if (test1[i].result != prandom_u32_state(&state))
@@ -444,7 +444,7 @@ static void __init prandom_state_selftest(void)
 	for (i = 0; i < ARRAY_SIZE(test2); i++) {
 		struct rnd_state state;
 
-		prandom_seed_early(&state, test2[i].seed, false);
+		_prandom_seed(&state, test2[i].seed, false);
 		prandom_warmup(&state);
 
 		for (j = 0; j < test2[i].iteration - 1; j++)
-- 
2.9.0.243.g5c589a7.dirty

