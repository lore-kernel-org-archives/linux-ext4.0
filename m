Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115857;
	b=SOzEfzZSnsEJdfkIPg9c3bGG3odkz8J5RIo9zfhO4VGEOzOcJ5yUORGmZTIwwbeB2hkF
	 W25+YgBR4GHLqMGt8MpCUe7+DP+OyzEqJE3ESslJHh3hL0DYjnfWGW9AzPF4yLXKkv9We
	 Le8hN+e2tSn7jQLsiIxVslKyO9lLXWV+Br4zwDLkye77Pfp+PueAZR3pv90brwojcqWvD
	 zug0L7Sk/mUHytXIcz4mYlJDUV92rB3mbh7rxBXSH4CgU986BV2OWo0HHRpYrKsIwHBAR
	 be1i9FIgb0fB3jUyxCK32BCeTSpy6b7MFCrGdxM3vQttDQfp3r0ujcZdOCzFsf7O9xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115857;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hAVXnRuKr2LIIWd7mSX3DJYOzbtvTgDMu/EQ+57tpTM=;
	b=dGKOSYotGVPa4OeERS8QNJKvWEM07nPsPRyQBK+Yu30K2RCInUqv3NJhPazlLgxQirNJ
	 QJ4VGLDpVV/QCngfodGbzQabgoZm25g/2W0t9gG5d5PPvTyRBQKxNcb81GipCJoEjt+gn
	 GucphD8x7rC4ggpFwOhXNmHaZ+sl6b2P0DuvFdHLva6lMVGgUuLDv8nqDMJKl6OHwq/FO
	 wtPP3y6zCtWJZNbJcGdv+3QwCBofeb0n+I2AEi+ic9LWLmlxOui4aqmsxzoRpgOmKaCwT
	 C1JS/ZhrkVctkYcmgtmGIn9OkiAa7BuPtVurcFWtyx9RouWv5PTlx7kfCVPoLCLpvmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=U6IjVmxF;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5090360A2600
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5090360A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=U6IjVmxF
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHW8n029896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=hAVXnRuKr2LIIWd7mSX3DJYOzbtvTgDMu/EQ+57tpTM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=U6IjVmxFibZpISot2ESOQpn92YQSc22A/BEaHff0DI/GDNLXg7tyTv3nPGeu31MgV
	 mL/2rs2588I34WkyfXpbTWhh0Ipwd6OqJ3IGnZvDYKvHmWImC8Bb4O9sbuWJIQ/s1L
	 m+d3lLHidtaLRo2HqxGxYUeE+IBg9WFYSofGO93+lQPTVozTicB+gpWko/SDj4vpKs
	 1OFk0sTnJ4LtEU0RetS8DD3EZHlckdSZn7O/OGV2XXNEOLDCbDMLOcx+F5kLnfoWOz
	 /Esf9XeHqwM21EQtbP0bIqvXOMKHTuWJVhN6JyKYZPxoFdov17HmNO+d5xJ+qgZFzL
	 hlVdPZYBBkmsw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3C85A2E0153; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 14/32] ext4: reject online shrink before probing the device size
Date: Thu, 19 Nov 2026 14:17:01 -0500
Message-ID: <20261119191719.1943298-15-tytso@mit.edu>
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

ext4_resize_fs() reads block n_blocks_count - 1 to check that the
device is large enough before it checks whether the request would
shrink the file system.  EXT4_IOC_RESIZE_FS passes the user supplied
64-bit value straight through, so n_blocks_count == 0 underflows to
reading block ~0ULL.  That read fails (the block layer also logs an
"out-of-range block" error), and the ioctl returns -ENOSPC with a
misleading "can't read last block" warning instead of the -EINVAL every
other shrink request gets.

Reject requests smaller than the current block count before probing
the device.  Since a mounted file system never has zero blocks, this
also guarantees n_blocks_count - 1 cannot underflow.  The check after
the retry label is kept, as the retry path can lower n_blocks_count.

Fixes: 59e31c156a24 ("ext4: fix online resizing when the # of block groups is constant")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize-test.c | 2 ++
 fs/ext4/resize.c      | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
index 36b7f0b8167f..1a4c1963648f 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -1300,6 +1300,8 @@ static void test_resize_fs_across_resize_inode_to_meta_bg(struct kunit *test)
 			-ENOSPC);
 	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, o_blks - 100), -EINVAL);
 	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, o_blks), 0);
+	/* n_blocks_count == 0 is a shrink, not a read of block ~0ULL */
+	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, 0), -EINVAL);
 
 	/* 2. Simultaneous resize_inode + meta_bg -> -EINVAL */
 	ext4_set_feature_meta_bg(sb);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index dc09fcc91c38..11c0b3659d08 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2045,6 +2045,15 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	int meta_bg;
 	unsigned int flexbg_size = ext4_flex_bg_size(sbi);
 
+	/*
+	 * Reject shrinking before probing the device; this also keeps
+	 * n_blocks_count - 1 below from underflowing for n_blocks_count == 0.
+	 */
+	if (n_blocks_count < ext4_blocks_count(es)) {
+		ext4_warning(sb, "can't shrink FS - resize aborted");
+		return -EINVAL;
+	}
+
 	/* See if the device is actually as big as what was requested */
 	bh = ext4_sb_bread(sb, n_blocks_count - 1, 0);
 	if (IS_ERR(bh)) {
-- 
2.56.1.708.g77570a6a1d-goog

