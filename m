Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115862;
	b=x7y9zDPqHJPO+fqZP7zTkBePAoqW2AI+It23AF3ehoE74a4P70VEdiqwXXj4UHxHg7Qd
	 wFPml9gbznIIJ/3axufww+LArSJbL4rVc5NAOZ4Gag6IQBRg3HcDcixr3ktKnCy8Th3/z
	 2tYVVsW5YYhHRoSsQyBBB8nq2Aic9W4mdJVtLOQ93Rx1RgjERuPMXzGhywu3kJ71ExAg/
	 Cxd+Z+KnWiMi6oMU3+O2M02+PwXIgS0ta1py39qSO+4sx2NM7DnLk+8Q9icYqEh+qyvrp
	 i4YlM11dhsMBXEUQyaXnqHOQ6+JmMBg7cbceAw1kD3I4xzhnRJH+AIkOiBQ0OeOaU1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115862;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VLHJkjf3gXdfdDaV1LbPrqnRNtEvuZ/x9Aa658U2p+o=;
	b=ztD+8xaUQ3I8Pw8+4N877jlfBxPtoSJ2wXjOvqEUafZtIZthTdCm3hwqXKZqj7pCl9Kp
	 pCEOSx+9yu+jtT+aD1G4x+FqrQZjKPFtMBPv32XY2xW1HFdt7vTqfZ9zyy6WGnANVu7r1
	 znD4dF011qmdSQxgrehHPfY+x2axx6amdKVFje6RsEhsv0rA4WXikpstgdmAx59p4284N
	 yD3oiTVWrmV2kSghICmkAq4Yd4BxYpViEjRa7xAKzxkvQuPyvRRfmkelPxPFF0wR8wypK
	 gHsN65WCDomIdV+4LU8zfGenmvWU9VbxstfyCyYNQ5c7IgKe163mmy/Nsz8NIBng3Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=R6jPRfS2;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E42606A32A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78E42606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=R6jPRfS2
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYQe029987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=VLHJkjf3gXdfdDaV1LbPrqnRNtEvuZ/x9Aa658U2p+o=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=R6jPRfS2opwd0eMIR3DvTxDt5KWu8L8d5vCN/BGz2fzNc1JKE2em1Tjx/awcosOe9
	 GMRSu4bjczdnzBh55Qf3zV0eVxW3WiDMr8s2fqNpWGpXvxoBWZOiPaVi5ICZP0lZkh
	 vKGk4FN5FRmZ3ZQ649P02KCmjgTnz2rqzpfZ05YXAfZvHf34OflndpEy5rX+1CXAs5
	 pRMzlLRfvxaYhuUb1Ph0UTNxFxVxz1WDmrThGzVgVtxhyiLKzGGxaupcWkcl9sRzT7
	 pzsKgHHmx1//qFA94lT9I8rPAO/IwbYWZeg1T++GFDkSbzJllOrxIS0pg1lP2jA2ba
	 rpqpOLE9v5RVw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 64E882E015F; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 26/32] ext4: flush s_ea_inode_work before clearing EXT4_FC_REPLAY
Date: Thu, 19 Nov 2026 14:17:13 -0500
Message-ID: <20261119191719.1943298-27-tytso@mit.edu>
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

During fast commit journal replay at mount time, ext4_xattr_delete_inode()
or other xattr helpers can drop the last reference to an EA inode via
ext4_put_ea_inode(), deferring the final iput() to the s_ea_inode_work
delayed workqueue.

Previously, ext4_fc_replay_cleanup() cleared EXT4_FC_REPLAY from
sbi->s_mount_state and freed replay tracking structures before flushing
s_ea_inode_work.  If the delayed worker ran afterwards (or before
mballoc initialization completed in __ext4_fill_super()),
ext4_evict_inode() -> ext4_free_inode() would no longer see
EXT4_FC_REPLAY and could attempt journal/mballoc operations on a not-yet-
initialized filesystem.

Call flush_delayed_work(&sbi->s_ea_inode_work) at the start of
ext4_fc_replay_cleanup() so all deferred EA inode iputs drain while
EXT4_FC_REPLAY is still set.

Extend test_fc_replay_regions_and_scan() in ext4_fast_commit_test to
verify that a deferred EA inode queued via ext4_put_ea_inode() is
evicted with EXT4_FC_REPLAY still set before ext4_fc_replay_cleanup()
returns.

Fixes: 4f48af3dc755 ("ext4: introduce ext4_put_ea_inode() for safe deferred iput")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/fast_commit-test.c | 73 +++++++++++++++++++++++++++++++++++++-
 fs/ext4/fast_commit.c      |  6 ++++
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/fast_commit-test.c b/fs/ext4/fast_commit-test.c
index 55b33f0d6e0a..74a101140f3e 100644
--- a/fs/ext4/fast_commit-test.c
+++ b/fs/ext4/fast_commit-test.c
@@ -27,6 +27,7 @@
 #include "extents_status.h"
 #include "fast_commit.h"
 #include "namei.h"
+#include "xattr.h"
 
 #define TEST_BLK_SIZE		1024
 #define TEST_BLK_BITS		10
@@ -134,8 +135,14 @@ struct fc_test_ctx {
 	bool use_custom_es_lookup;
 	struct extent_status custom_es;
 	int custom_es_ret;
+
+	/* Deferred EA inode eviction tracking during replay cleanup */
+	bool ea_evicted;
+	bool ea_evict_saw_fc_replay;
 };
 
+static struct fc_test_ctx *fc_active_ctx;
+
 #ifdef CONFIG_QUOTA
 static struct dquot __rcu **fc_test_get_dquots(struct inode *inode)
 {
@@ -152,7 +159,41 @@ static const struct dquot_operations fc_test_qops = {
 };
 #endif
 
+static struct inode *fc_test_alloc_inode(struct super_block *sb)
+{
+	struct ext4_inode_info *ei = kzalloc_obj(*ei, GFP_KERNEL);
+
+	if (!ei)
+		return NULL;
+	inode_init_once(&ei->vfs_inode);
+	return &ei->vfs_inode;
+}
+
+static void fc_test_free_inode(struct inode *inode)
+{
+	kfree(EXT4_I(inode));
+}
+
+static void fc_test_evict_inode(struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL) {
+		struct fc_test_ctx *ctx = READ_ONCE(fc_active_ctx);
+
+		if (ctx) {
+			WRITE_ONCE(ctx->ea_evicted, true);
+			WRITE_ONCE(ctx->ea_evict_saw_fc_replay,
+				   !!(sbi->s_mount_state & EXT4_FC_REPLAY));
+		}
+	}
+	clear_inode(inode);
+}
+
 static const struct super_operations fc_test_sops = {
+	.alloc_inode	= fc_test_alloc_inode,
+	.free_inode	= fc_test_free_inode,
+	.evict_inode	= fc_test_evict_inode,
 #ifdef CONFIG_QUOTA
 	.get_dquots	= fc_test_get_dquots,
 #endif
@@ -859,6 +900,8 @@ static void fc_cleanup_all(void *priv)
 		ext4_es_destroy_stats(ctx->sbi);
 	}
 	deactivate_super(ctx->sb);
+	rcu_barrier();
+	WRITE_ONCE(fc_active_ctx, NULL);
 }
 
 static int fast_commit_test_init(struct kunit *test)
@@ -884,6 +927,8 @@ static int fast_commit_test_init(struct kunit *test)
 
 	ctx->sb = sb;
 	ctx->sbi = sbi;
+	WRITE_ONCE(fc_active_ctx, ctx);
+	ext4_init_ea_inode_work(sbi);
 	test->priv = ctx;
 
 	/* Superblock and ext4_sb_info setup */
@@ -2211,7 +2256,33 @@ static void test_fc_replay_regions_and_scan(struct kunit *test)
 					    PASS_SCAN, 1, 10),
 			JBD2_FC_REPLAY_STOP);
 	KUNIT_EXPECT_EQ(test, state->fc_replay_num_tags, 2);
-	ext4_fc_replay_cleanup(sb);
+
+	/*
+	 * 6) ext4_fc_replay_cleanup() must drain deferred EA inode iputs
+	 *    while EXT4_FC_REPLAY is still set before clearing replay state.
+	 */
+	{
+		struct inode *ea_inode = new_inode(sb);
+
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ea_inode);
+		ea_inode->i_ino = 500;
+		ea_inode->i_mode = S_IFREG | 0600;
+		clear_nlink(ea_inode);
+		EXT4_I(ea_inode)->i_flags = EXT4_EA_INODE_FL;
+		WRITE_ONCE(ctx->ea_evicted, false);
+		WRITE_ONCE(ctx->ea_evict_saw_fc_replay, false);
+		sbi->s_mount_state |= EXT4_FC_REPLAY;
+
+		ext4_put_ea_inode(ea_inode);
+		ext4_fc_replay_cleanup(sb);
+
+		KUNIT_EXPECT_TRUE(test, READ_ONCE(ctx->ea_evicted));
+		KUNIT_EXPECT_TRUE(test,
+				  READ_ONCE(ctx->ea_evict_saw_fc_replay));
+		KUNIT_EXPECT_FALSE(test,
+				   !!(sbi->s_mount_state & EXT4_FC_REPLAY));
+		KUNIT_EXPECT_TRUE(test, llist_empty(&sbi->s_ea_inode_to_free));
+	}
 	memset(state, 0, sizeof(*state));
 }
 
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index d56c45ee0d61..67264b935127 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2426,6 +2426,12 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
+	/*
+	 * Drain any deferred EA inode iputs queued during fast commit replay
+	 * before clearing EXT4_FC_REPLAY and freeing replay state so that
+	 * ext4_evict_inode() -> ext4_free_inode() still sees EXT4_FC_REPLAY.
+	 */
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	sbi->s_mount_state &= ~EXT4_FC_REPLAY;
 	kfree(sbi->s_fc_replay_state.fc_regions);
 	sbi->s_fc_replay_state.fc_regions = NULL;
-- 
2.56.1.708.g77570a6a1d-goog

