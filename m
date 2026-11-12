Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458845;
	b=0vb3bSNufIQLIVzl6KsKfAVVpqb097jtEFT2kXJgYLYpYvT4TU//RSOUpf2nuZy+qn5R
	 PJFI4BCvKMfosNXHyQ3BccJiRbzQLqMBxH990/pCR9x/9UjPlBVIve7XFK5+quYO0JXR+
	 1qRXv9OFIXY7kHOQ35R0xn0hDTAFgDXAJuhUfMVXeJtiFd+CjdkdUju9aYj09wNxz48mH
	 awRVVpvyTp2n/4kLcx9xrppxcpMsuKKDZET/SxJzsABNkvpRXpXzF8cXxWT3fwqKLi0Al
	 dEuNJaRQm7h5MRq51U6h8+j8z3/1aQgj9y/sgBAzYikXHtpPF8w1vCBq8D1BUimOVdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TxVEboxq1ppl+wPTR7ZTJEx37CMkrkqy6sO+31terNs=;
	b=xSkf+peHT+ngRztRFE30FJc4JZQ5xgnQ9peJ2EILCBuH5L6jIANdtVfHm/pd1dKWWrLF
	 0QoxhopGSUvgfJU65zUFh0iZbZUqHfPXLIdXkErNiO5HVvIPzi8db5ti60QY5DnWVjYJo
	 3WzS11gVsSVMvU7/cqYrvnJ0EXkpFPJ3ibTZgjhQVD6aNLLVtD6QXVM7ktejqgyfrznOy
	 mWrp9lcivPjWSbsTfNcs4UsPHJGlS0BPhLY8v0D7P7Mf8rfL6+gWoYgQq3XVl0jrIHVXD
	 Vnw+L8SmoaTPkkyIANNvDe2QUdOlxZFUMPD1818FSpyhI22qa/Fmt5frl3HHmuqqpkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=WqoPstcM;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FDD60A260E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84FDD60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=WqoPstcM
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKA6031214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=TxVEboxq1ppl+wPTR7ZTJEx37CMkrkqy6sO+31terNs=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=WqoPstcM6Gx0sdGC1c/z2ghsRW+a6OcxeExGUNEmxUAKGZF/iXcSIP8Vzn+DcK9ll
	 3pqW99MdTNGaZUjNWT2J4gJIK9IlTxFQLxOx5tdSd7P3kLvsD23EJwKbgtWpeDxOfa
	 I/Lkp2OZFVrQbLJHNnmPsn+1P8fu/8qgzsSPaTojdEsn4do7Bh7YO6GZ2PhvYeP7B8
	 wYNUhD1peX3dYFrRgz3oUU0XfwaKzOiXHYXKn5qAR9Hk7VqWgegkA9aj7KiGOUOuZo
	 XHsEBYpRj5NbUQq64B1knI2PfcF2pdx0nzb7fuzaeTCfO+dv23AHpVTs6uMHQDn+Ri
	 N3MkWLBDP6XOw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4C8732E0153; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 14/23] ext4: reject online shrink before probing the device size
Date: Wed, 11 Nov 2026 23:47:03 -0500
Message-ID: <20261112044712.1577296-15-tytso@mit.edu>
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
index 0fd097d58a59..6a55efc7ae82 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -1305,6 +1305,8 @@ static void test_resize_fs_across_resize_inode_to_meta_bg(struct kunit *test)
 			-ENOSPC);
 	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, o_blks - 100), -EINVAL);
 	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, o_blks), 0);
+	/* n_blocks_count == 0 is a shrink, not a read of block ~0ULL */
+	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, 0), -EINVAL);
 
 	/* 2. Simultaneous resize_inode + meta_bg -> -EINVAL */
 	ext4_set_feature_meta_bg(sb);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d3507b175382..467292fc478c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2043,6 +2043,15 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
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
2.56.0.542.g3ef89b7020-goog

