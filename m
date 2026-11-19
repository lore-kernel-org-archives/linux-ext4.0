Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115858;
	b=FqYQnL9bhvJAXSTs6NucNj893msCeTRM2Td1t64/9ryYkvjjCC4gpHU16zOKm/u/dKiB
	 Hxa6b1xRD7uZNjju4ozyHAX4imkVqaADpw19vaZna33b36fomUoZ0ldkxr2POCwqAi+1+
	 FGM/nwzpuw3QodqwIwT74O/y1c2sxyeK+s6jrv/AZAtDbyq8B9a1RiGpmXBTNsMO/I7dw
	 2q/OrdsHwC9p1TXBXe9OdOkmHyoldlRqx2kvsyq2ppfJKKGxI36hHuKz/6LpwrIb5D3l3
	 k17QVGn2Ki3jwtndmFOr5Qve1vfmazkgrK5myeuzqpO318SILZxs2Oq66y6eMobndxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115858;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PLMGAtDoVE6DemA+J9b8mdrxC9vHxIx3cSlIfWcaqHI=;
	b=V6AxHeVKVeaXy1JPmHxHwDkfx0gh0pb0Mdy7i/hTEvNNaO6fW7NtdFP82sg4SLhyGiy2
	 RfUcNLHR0MXPc/Sz5ttbuJU39UQpwhS4m9f1UGDhL9u/lCbLXhda6/Ed4gCw5Mkwmm/DZ
	 zAnquhiccj0HjoPB+tLBXp42XLxhMTAfBf/BTaRy4VWcCexJjaN9Hl1+EttdOJfvZDIHH
	 Qarim+Fekkb5Zsu2z0oH8bb85DzaK2aA54NgY4HbNYDURqmYUAFvEyH4CWUsS/nOPza40
	 AGFYQkC0A6ocDxSXYJw7jtIeQyWOu8HlE+iRjCErO0cJr324BKjj4t/X47ov0gHtW5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=JNKi2EIF;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FA60A2633
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C2FA60A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=JNKi2EIF
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHXNe029923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=PLMGAtDoVE6DemA+J9b8mdrxC9vHxIx3cSlIfWcaqHI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=JNKi2EIFbPripczeAnBwdIlS06Ky1pSRG8+VWT/AkOohN57cuc1tVqGX+fMs7Vgh3
	 QX/v3fB+IkKBaO5wC0ncjNRiI59S9CpW6mKf4VtW/mTWWn4KD3Er3l3TrNTS1kv7eh
	 DS9uZJQv+iTISH3hzKFHm5UA3DfTSZewZESmRWjnFMew1sAY5unLY1w29zuANnFYSp
	 bXXIopwbnNYgXjir06wGXAbHXRU5MZ8+46rsiLeQtf7/macbna7tF/3sx7ROvS57u5
	 /A8hiUSoEIbdMDZnFanfRsZ76nWIQ2EYDaK4R5eptoLT7T48pVGJlKHB/ejrdh7MHj
	 js/4916+eAPew==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3F9722E0154; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 15/32] ext4: fix EOF clamping of the range in mext_check_adjust_range()
Date: Thu, 19 Nov 2026 14:17:02 -0500
Message-ID: <20261119191719.1943298-16-tytso@mit.edu>
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
index a3e002f14109..b6b84553b1cc 100644
--- a/fs/ext4/move_extent-test.c
+++ b/fs/ext4/move_extent-test.c
@@ -805,6 +805,27 @@ static void test_mext_check_adjust_range(struct kunit *test)
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
index 15f4126c5c51..76f36b17c7e4 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -556,11 +556,11 @@ static int mext_check_adjust_range(struct inode *orig_inode,
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
2.56.1.708.g77570a6a1d-goog

