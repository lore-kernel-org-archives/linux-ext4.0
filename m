Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115861;
	b=HGQwAtvp9wFoP24UFG4cPc9oe02gF5wO0db/Xxa8aHRD/+uVxbzOzg7Kaubrd6m0JPC7
	 lWd7894CGgYNxiFkMkT1VnoL3RT6EIYqS9+gnJbbXRyCye/PuZHuZfraH8cFalSoe10sl
	 5IPu214PXCaQyohJl4ADbuxk7MucUy2IRMy9eeIXmrJsXescAgtnHCBT08qDbT8W1BMbC
	 nzk9RpDfGjXN8Ef0+2icNvc11rN09hS4mAxnoivcvZkolh8G8Ye6iqie/Ofmg3i0OJn/f
	 UOtTaCuMLegoj4dhot50BekXLzVln+0RBCS+E46EtFI00Z23H5ib406mOFDKDcic8bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115861;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PYiHILN7SYqv6sI1xtSxUBgaGu0DU2ji/9lWpxyYZ/E=;
	b=z69oQm+J9b+qBf9MOzZlqhCFy+WZPFwqgbXjTTGn8MZu17A/vXTOJ+w6mXytEcU1WEBG
	 8/ibAAVGbUbDAYtvFRUPz3tvWNgi2w2s/pRlRt/HrnOjBVVWW6oK+Y/MQxgxNIQ5Y99Gp
	 Ler8lWFnKe9dMxXbral/TsspNO7lHVPYbHoAPdtZj+HHYhjCB82cBv29T2DdXPaLZy7/J
	 T2qnlQ5FGOMRkC8P4ZfXuELWTbPpQ+eKx3LS3wj0I0czXuOupOmH4uyLNe5BEXHADaFf/
	 jZnjSkKe41npnCSjzQTYdkR4gTI6nuB4EnDt9pkXZZqcwhqGM7URM+kdlNSCUyakQ2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FJmapUvK;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A3F606A32C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04A3F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FJmapUvK
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYBO029974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=PYiHILN7SYqv6sI1xtSxUBgaGu0DU2ji/9lWpxyYZ/E=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=FJmapUvKBn1G+CNle5Fy8rZHjnln7FlsY0T6KJaa9lGywPdMY4OXG+cG+7deNbM+a
	 OIerOQB3rSJoRiKlfKK8jDd8VEEIiNVLJvO71I3f8GXwjZnKOdFgbQgyeKf1zFOM8H
	 dNsBLa69AENwvEsCOZ2xyPba1c4nNSN7tiP3tc8PwJmv+bBNUHXzqLX4H0P6cl9eQd
	 mUQfGbImQelFWmmZjif+sNqsFfIEDus1mCF/fnqjXIyZ9MqPssGufeEEu1ogIaIRus
	 M4AIeCsFjC0aKdUHgzEuGHCoLN06k6QGWWKEUy9ZR+LuMQtH3D72K4jINBuNlAIpgj
	 Za7PkofEGJlWw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5E1EC2E015D; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 24/32] ext4: propagate cache flush errors from ext4_fc_replay_inode()
Date: Thu, 19 Nov 2026 14:17:11 -0500
Message-ID: <20261119191719.1943298-25-tytso@mit.edu>
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

ext4_fc_replay_inode() writes the replayed on-disk inode and then
flushes the file system device's cache, but it ignores the result of the
flush.  If the flush fails, fast commit replay reports success even
though the replayed inode may not have reached stable storage, and
journal recovery completes as if the inode had been replayed.

Return the error from ext4_fc_issue_flush() so that a failed flush
aborts the replay.

The other ignored cache flush errors, in ext4_init_inode_table() and in
ext4_fc_perform_commit(), have been fixed by
commit baf9a298bdd7 ("ext4: check return value of blkdev_issue_flush()
when initializing inode tables") and
commit 49ac01dd7d43 ("ext4: check return value of blkdev_issue_flush()
when starting a fast commit").

Extend ext4_fast_commit_test to verify that a flush failure during
inode replay is propagated, and that a flush failure before fast commit
blocks are written to an external journal falls back to a full commit.
Make the lazy inode table zeroing test in ext4_ialloc_test check that
the barrier flag is passed down to ext4_itable_zeroout().

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/fast_commit-test.c | 28 +++++++++++++++++++++++++++-
 fs/ext4/fast_commit.c      |  2 +-
 fs/ext4/ialloc-test.c      |  5 +++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fast_commit-test.c b/fs/ext4/fast_commit-test.c
index 07cb9c043cd2..55b33f0d6e0a 100644
--- a/fs/ext4/fast_commit-test.c
+++ b/fs/ext4/fast_commit-test.c
@@ -117,6 +117,7 @@ struct fc_test_ctx {
 	int fail_fc_get_buf_on_call;
 	int fc_get_buf_calls;
 	bool fail_fc_wait_bufs;
+	int fail_fc_flush;
 	int submit_inode_data_err;
 
 	unsigned int fc_submit_bh_calls;
@@ -794,7 +795,7 @@ static int stub_fc_issue_flush(struct block_device *bdev)
 
 	ctx->fc_flush_calls++;
 	ctx->last_flushed_bdev = bdev;
-	return 0;
+	return ctx->fail_fc_flush;
 }
 
 static int mock_submit_inode_data_buffers(struct jbd2_inode *jinode)
@@ -1993,6 +1994,21 @@ static void test_fc_commit_paths(struct kunit *test)
 	memcpy(&tl, ctx->fc_buf_data[1], EXT4_FC_TAG_BASE_LEN);
 	KUNIT_EXPECT_EQ(test, le16_to_cpu(tl.fc_tag), (u16)EXT4_FC_TAG_INODE);
 
+	/* External journal flush failure falls back to full commit */
+	{
+		unsigned int failed_before = sbi->s_fc_stats.fc_failed_commits;
+
+		ctx->fail_fc_flush = -EIO;
+		ctx->fc_submit_bh_calls = 0;
+		ext4_fc_track_inode(&ctx->handle, file1);
+		KUNIT_EXPECT_EQ(test, ext4_fc_commit(&ctx->journal, 10), 0);
+		KUNIT_EXPECT_EQ(test, atomic_read(&sbi->s_fc_subtid), 2);
+		KUNIT_EXPECT_EQ(test, ctx->fc_submit_bh_calls, 0U);
+		KUNIT_EXPECT_EQ(test, sbi->s_fc_stats.fc_failed_commits,
+				failed_before + 1);
+		ctx->fail_fc_flush = 0;
+	}
+
 	ctx->journal.j_fs_dev = &ctx->bdev;
 }
 
@@ -2448,6 +2464,16 @@ static void test_fc_replay_inode_and_dentries(struct kunit *test)
 		KUNIT_EXPECT_EQ(test, le32_to_cpu(de->inode),
 				(u32)TEST_FILE2_INO);
 		brelse(bh);
+
+		/* 3) Flush failure during INODE replay propagates -EIO */
+		sbi->s_fc_replay_state.fc_replay_num_tags = 5;
+		ctx->fail_fc_flush = -EIO;
+		KUNIT_EXPECT_EQ(test,
+				ext4_fc_replay_test(&ctx->journal,
+						    &ctx->fc_bhs[0],
+						    PASS_REPLAY, 0, 10),
+				-EIO);
+		ctx->fail_fc_flush = 0;
 	}
 
 	ext4_fc_replay_cleanup(sb);
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 9beb423b208f..d56c45ee0d61 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2041,7 +2041,7 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 out:
 	iput(inode);
 	if (!ret)
-		ext4_fc_issue_flush(sb->s_bdev);
+		ret = ext4_fc_issue_flush(sb->s_bdev);
 
 	return ret;
 }
diff --git a/fs/ext4/ialloc-test.c b/fs/ext4/ialloc-test.c
index c68b60c95961..fede9fd0772d 100644
--- a/fs/ext4/ialloc-test.c
+++ b/fs/ext4/ialloc-test.c
@@ -2670,12 +2670,13 @@ static void ialloc_test_init_inode_table(struct kunit *test)
 			   !!(le16_to_cpu(ctx->gdps[0].bg_flags) &
 			      EXT4_BG_INODE_ZEROED));
 
-	/* 7. Zeroout I/O failure (-EIO) and emergency RO (-EROFS) */
+	/* 7. Zeroout/flush I/O failure (-EIO) and emergency RO (-EROFS) */
 	ctx->gdps[3].bg_flags = cpu_to_le16(EXT4_BG_INODE_UNINIT);
 	ctx->fail_itable_zeroout_err = -EIO;
-	err = ext4_init_inode_table(sb, 3, 0);
+	err = ext4_init_inode_table(sb, 3, 1);
 	ctx->fail_itable_zeroout_err = 0;
 	KUNIT_EXPECT_EQ(test, err, -EIO);
+	KUNIT_EXPECT_EQ(test, ctx->last_zeroout_barrier, 1);
 	KUNIT_EXPECT_FALSE(test,
 			   !!(le16_to_cpu(ctx->gdps[3].bg_flags) &
 			      EXT4_BG_INODE_ZEROED));
-- 
2.56.1.708.g77570a6a1d-goog

