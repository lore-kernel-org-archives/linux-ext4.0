Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8B8317167;
	Fri,  8 May 2026 12:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242575; cv=none; b=u8o2jktEBANncAtxGSoY5Iirbr0wVzxS/yf1uPDc0tCbqFM6wEDVGM48YBX5l/JpbnnkdGOk1tx/oOZh7lUYeKd8QiYlHf3pkfDL3n73zHYWGhL/bdeZVN/vbxBcSUmArPcp6aQ4VXSIfkfPhQpqUpZ3jDiJprIFMVp0VWV9r0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242575; c=relaxed/simple;
	bh=HN2Y0oSr2no+o0YAxTU4luc1gJdMzXkybzkEc45bndE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taplGCyhql/aJGCuxUFRbiVqgt//H97YL4kySet3EfxVx9TBZILjPY6rdrZIOl0drmqmqlW2ehiXdsmt1AWrv8aUGA81VU8XBMAd8JAlU/GQ7o9aabjvF6sE/4GCt/H4eQjJB4FUo2e7mtYR11m4GtZthoHDXvoO25mRkNYCcV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V1t2o2KI; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V1t2o2KI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242561; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MrEYE1T1bmers4GpxJo71+7yS7QaAHf/z3ZcYCpLD80=;
	b=V1t2o2KIkzS6HWNveVAwKINcWvyvd64fiSWzHwS/CxuYFvMC/2H1WgBzbmuf2VyzC8JPUnWt9zvs0+9S72iQBCwaCKPx2FDJ9kE3YLHVOxLxkVkxOKdDmoUUfTaM+/CH/TwZCooFa9t62qoelIn7WtzBXDyCsOo0VeO0KKqq+s0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgnl_1778242560;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgnl_1778242560 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:00 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	ardb@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH RFC 02/17] lib/crc: crc_kunit: add kunit test for crc32c_flip_range()
Date: Fri,  8 May 2026 20:15:24 +0800
Message-ID: <20260508121539.4174601-3-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
References: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kunit tests for crc32c_flip_range(), validating correctness
against naive full-buffer CRC recomputation.  All tests use a 64KB
buffer and a non-zero CRC seed to match real-world usage (e.g. ext4
metadata checksums):

 - ones_lookup[0] single-bit verification.
 - num_bits=0 no-op, first/last byte, full 64KB flip.
 - Random single-bit flips (100 iterations).
 - Random multi-bit contiguous ranges (100 iterations).

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 lib/crc/tests/crc_kunit.c | 85 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/lib/crc/tests/crc_kunit.c b/lib/crc/tests/crc_kunit.c
index 9428cd913625..46f9df5b58e4 100644
--- a/lib/crc/tests/crc_kunit.c
+++ b/lib/crc/tests/crc_kunit.c
@@ -470,6 +470,90 @@ static void crc64_nvme_benchmark(struct kunit *test)
 }
 #endif /* CONFIG_CRC64 */
 
+/*
+ * Test crc32c_flip_range() against naive full-buffer CRC recomputation.
+ * All tests use a 64KB buffer (2^19 bits = INCR_MAX_ORDER limit)
+ * and a non-zero seed to match real-world usage (e.g. ext4 checksums).
+ */
+static void crc32c_flip_range_test(struct kunit *test)
+{
+	size_t buflen = 65536;
+	size_t total_bits = buflen * 8;
+	u32 seed = 0x12345678;
+	u32 expected, flip_crc;
+	size_t start, num_bits, b, pos;
+	u8 *buf;
+	int i;
+
+	buf = kunit_kmalloc(test, buflen, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+
+	/* Test 1: Single bit at bit 0 (verifies ones_lookup[0]) */
+	buf[0] = 0x00;
+	expected = crc32c(seed, buf, 1);
+	buf[0] = 0x01;
+	flip_crc = crc32c_flip_range(expected, 8, 0, 1);
+	expected = crc32c(seed, buf, 1);
+	KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc, "Single bit at bit 0");
+
+	/* Test 2: num_bits=0 should be a no-op */
+	memset(buf, 0, buflen);
+	expected = crc32c(seed, buf, buflen);
+	flip_crc = crc32c_flip_range(expected, total_bits, 0, 0);
+	KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc,
+			    "num_bits=0: expected=0x%08x got=0x%08x",
+			    expected, flip_crc);
+
+	/* Test 3: Boundary flips - first byte, last byte, all bits */
+	buf[0] = 0xFF;
+	flip_crc = crc32c_flip_range(expected, total_bits, 0, 8);
+	expected = crc32c(seed, buf, buflen);
+	KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc, "Flip first byte");
+
+	buf[buflen - 1] = 0xFF;
+	flip_crc = crc32c_flip_range(expected, total_bits, (buflen - 1) * 8, 8);
+	expected = crc32c(seed, buf, buflen);
+	KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc, "Flip last byte");
+
+	memset(buf, 0, buflen);
+	expected = crc32c(seed, buf, buflen);
+	memset(buf, 0xFF, buflen);
+	flip_crc = crc32c_flip_range(expected, total_bits, 0, total_bits);
+	expected = crc32c(seed, buf, buflen);
+	KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc, "Flip all 64KB bits");
+
+	/* Test 4: Random single-bit flips (100 iterations) */
+	memset(buf, 0, buflen);
+	expected = crc32c(seed, buf, buflen);
+	for (i = 0; i < 100; i++) {
+		start = rand32() % total_bits;
+		buf[start / 8] ^= (1 << (start % 8));
+
+		flip_crc = crc32c_flip_range(expected, total_bits, start, 1);
+		expected = crc32c(seed, buf, buflen);
+		KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc,
+				    "Single bit at %zu: expected=0x%08x got=0x%08x",
+				    start, expected, flip_crc);
+	}
+
+	/* Test 5: Random multi-bit ranges (100 iterations) */
+	for (i = 0; i < 100; i++) {
+		num_bits = (rand32() % (total_bits - 1)) + 1;
+		start = rand32() % (total_bits - num_bits + 1);
+		for (b = 0; b < num_bits; b++) {
+			pos = start + b;
+			buf[pos / 8] ^= (1 << (pos % 8));
+		}
+
+		flip_crc = crc32c_flip_range(expected, total_bits, start, num_bits);
+		expected = crc32c(seed, buf, buflen);
+
+		KUNIT_ASSERT_EQ_MSG(test, expected, flip_crc,
+				    "Range [%zu, +%zu): expected=0x%08x got=0x%08x",
+				    start, num_bits, expected, flip_crc);
+	}
+}
+
 static struct kunit_case crc_test_cases[] = {
 #if IS_REACHABLE(CONFIG_CRC7)
 	KUNIT_CASE(crc7_be_test),
@@ -490,6 +574,7 @@ static struct kunit_case crc_test_cases[] = {
 	KUNIT_CASE(crc32_be_benchmark),
 	KUNIT_CASE(crc32c_test),
 	KUNIT_CASE(crc32c_benchmark),
+	KUNIT_CASE(crc32c_flip_range_test),
 #endif
 #if IS_REACHABLE(CONFIG_CRC64)
 	KUNIT_CASE(crc64_be_test),
-- 
2.43.7

