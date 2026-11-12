Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458846;
	b=WxSfqojRQh0Z/MMYr5+ZZXyHPUyF1fyKNcBxoFDJ+1BSfR525SwmA6FPamfmx4EmcP+0
	 xhy5eexGxIaru09h71Kay8doreCftB1hqzVk6GjtkSw5UMad8t76DPNGXTbkoRzhfKPUf
	 Ho81zZT78yYzfPlmDIwkZZCQvyMYfRQ3XeyWRBILyhPVF/hhLNErXj+I2jzpVmPiqXKRD
	 NT7Unu5MYxUZAde6452g2xSI5PwoLuDqEPI9GP9sxC7mHkXXeOatn157WrnqCEFVYSQ7F
	 FJjyITkiRl5/4n3W1evBDjAiomaYlJSIXiUPv4Gl6H5j0Gf3tkwfVFUXE7vDgRYJwEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458846;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vm0bA05Iq3yW3dxwPyISfHnQpAcVAlSCK13Q0yR2m8Q=;
	b=hyCM+mzuJftdPJ3piImYiKnwxTtxnS99EDJ7E5iG5dRmhtgEGv20W80HFfpgM+VQoihJ
	 a25GkxtFcoKMVpxddoTK+WaQF09um6HorKiZq/XJyneiaJm0LMk4rS6DdGTdDSPCDc9nD
	 YWkoydX3D82rzTC1H2Aps82DbWjuHapIdUjL6+2MLuWb6IgIYroAzIqxjvD4y4RFewkAv
	 G/vTFycZyF+dSDSiPby//HK5EqPy7xHqmPtpgZicXoBxbnyg4LM6jUUg1cgapxtxHEdIp
	 v9vyzmxK3B9CnzxHClZn4jzsqM6hLBE5ZNWlHYl+nljIlExi9lSU7sQnM1oOkk8Zljw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=SHDLELKT;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21BF60A2638
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C21BF60A2638
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=SHDLELKT
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMSi031266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458843; bh=vm0bA05Iq3yW3dxwPyISfHnQpAcVAlSCK13Q0yR2m8Q=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=SHDLELKTimUoRZMVTR13LL8+kM0G0tYclb8b5fEsG6l/Pivc64vx9nNxcza90DJiW
	 btytFGXoaSaSXr+faXoHw8gkeyNY/zeXb1AC+djDt9bHZl+4GHLgtY4JJ+V1f/cwG1
	 jIv/Vdx03soUQd8dKBVN9s7EXEISmQ4ogX/NqX0D5NmYlxWIwAN71XE02tcEGyGI+4
	 FHtxzSckyJBcR4Hn7IYfSutAYbcho7wwGPCDlYD0zT8pCXGQ9whT+VpE6Hdm7RnfRX
	 4vwaPga5g8emLvEN97nzm/OcEY2Iscs2wQDEjgOojqIEROf3S8m6VXndwcM+2Wv2Nv
	 n6NuoEv6W8VRQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 58F4D2E0157; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 18/23] ext4: fix EOF clamping of the range in mext_check_adjust_range()
Date: Wed, 11 Nov 2026 23:47:07 -0500
Message-ID: <20261112044712.1577296-19-tytso@mit.edu>
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

mext_check_adjust_range() clamps the requested EXT4_IOC_MOVE_EXT range
to the end of the original and donor files with:

	else if (orig_eof < orig_start + *len - 1)
		*len = orig_eof - orig_start;

orig_eof and donor_eof are exclusive (the first logical block past
i_size), so the range [start, start + len) runs past EOF as soon as
start + len > eof.  The extra "- 1" has two consequences:

 - A range that ends exactly one block past EOF is not clamped, so
   e.g. orig_start = 0, len = 2 on a one-block file walks and swaps a
   block beyond i_size.

 - A zero length makes the unsigned "start + len - 1" wrap to
   ULLONG_MAX when start is 0.  The comparison is then always true and
   len is "clamped" to the full file size, so the later !*len check
   never fires and a request to move zero blocks moves every block of
   the file instead of failing with -EINVAL.

Compare against start + len instead.  With that, a zero length is left
untouched by the clamping (eof > start in that branch) and is rejected
by the existing !*len check, so no separate check is needed.  The sums
cannot overflow because start and len were already bounded by
EXT_MAX_BLOCKS above.

Extend test_mext_check_adjust_range to cover a zero length and ranges
that end exactly one block past EOF.

Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/move_extent-test.c | 21 +++++++++++++++++++++
 fs/ext4/move_extent.c      |  4 ++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/move_extent-test.c b/fs/ext4/move_extent-test.c
index e29a392eeebe..dded52fd0b5f 100644
--- a/fs/ext4/move_extent-test.c
+++ b/fs/ext4/move_extent-test.c
@@ -802,6 +802,27 @@ static void test_mext_check_adjust_range(struct kunit *test)
 	ret = ext4_mext_check_adjust_range_test(orig, donor, 4, 4, &len);
 	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
 	KUNIT_EXPECT_EQ(test, len, 0ULL);
+
+	/* A zero length must be rejected, not wrapped to the whole file */
+	len = 0;
+	ret = ext4_mext_check_adjust_range_test(orig, donor, 0, 0, &len);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+	KUNIT_EXPECT_EQ(test, len, 0ULL);
+
+	/* A range ending exactly one block past EOF must be clamped */
+	i_size_write(orig, MEXT_TEST_BLK_SIZE);		/* orig_eof = 1 */
+	i_size_write(donor, MEXT_TEST_BLK_SIZE);	/* donor_eof = 1 */
+	len = 2;
+	ret = ext4_mext_check_adjust_range_test(orig, donor, 0, 0, &len);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, len, 1ULL);
+
+	i_size_write(orig, 4 * MEXT_TEST_BLK_SIZE);	/* orig_eof = 4 */
+	i_size_write(donor, 8 * MEXT_TEST_BLK_SIZE);	/* donor_eof = 8 */
+	len = 4;
+	ret = ext4_mext_check_adjust_range_test(orig, donor, 1, 1, &len);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, len, 3ULL);
 }
 
 static void test_move_extents_holes_and_unwritten(struct kunit *test)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 49adc348dda0..5ee51fde1819 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -545,11 +545,11 @@ static int mext_check_adjust_range(struct inode *orig_inode,
 	donor_eof = EXT4_B_TO_LBLK(donor_inode, i_size_read(donor_inode));
 	if (orig_eof <= orig_start)
 		*len = 0;
-	else if (orig_eof < orig_start + *len - 1)
+	else if (orig_eof < orig_start + *len)
 		*len = orig_eof - orig_start;
 	if (donor_eof <= donor_start)
 		*len = 0;
-	else if (donor_eof < donor_start + *len - 1)
+	else if (donor_eof < donor_start + *len)
 		*len = donor_eof - donor_start;
 	if (!*len) {
 		ext4_debug("ext4 move extent: len should not be 0 [ino:orig %llu, donor %llu]\n",
-- 
2.56.0.542.g3ef89b7020-goog

