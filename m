Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458846;
	b=jKALwrkf30bxVQqNs5F5XbiAck7VfoTb+bwpDZeq+uC/BS+9Xn7oODcYnTabrboVS0UN
	 mzGrYCtYLR3UC0BrwlmwsJ6OQ0A0/XURyQHCBRTlWbON/rkIkfOZ1gqXx/ijB3RkaVwxF
	 ATop69ArgN80JJmPCduJdLbqxlNrqlTg+sDBBjcZ2/TY8wuOtv5OZ2SZGNnLi3Hxfp/7O
	 isHIhSju/OpKEmFXW1AX55baigUrK84Bg116P8Zopx0pcSSzFNMuluG2CmX0qjgFafF8H
	 urzs+y7XlC7iQfoSyxRCU/NovNqEGw412Zmh+4Qi/uKCz23EjMhA8yYtgsa5A9EYnZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458846;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lxcoS8gpJX3Tczd7p7zvxhZiqAIhnaRi3EwVoHs1Spc=;
	b=TY9kY9w30lHSN1zyVfRAXcLEiYED/ppFHZR8siEUoDlp2MhCLyHcRgtDi3TKw5zeUdLX
	 EUzAHs4PbpkStF212nhHAEy+5FWGUUVj3Kn7o5rDQbq+XrJ+yAXuRgoeFnTeF104ZoG3h
	 /gLe9Ibnn2B/pkFQFTP7f8CEQ1Gvb0Hwx+ZEUrCLAfyO3J/0LqaryARmk6wbcd63Z3fFx
	 o+CtR/kKRPFmJyilxjy/oF9/hjUMrlceOwq1nZCL5u7Y7LQCdSVbcfGZXS8wiz4rBvtRM
	 UM9wdfSZsCZPz6jDpZf+f+kW4QtzIFbuCj2Iap509IQTPYuhdYmXD2BRnxb3T0vUEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=kuD1L2Dz;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872E360A262E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 872E360A262E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=kuD1L2Dz
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMP9031290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458843; bh=lxcoS8gpJX3Tczd7p7zvxhZiqAIhnaRi3EwVoHs1Spc=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=kuD1L2DzKvlc6k7NL4AZxb67c4GQLDSD8u4DvtCR3ih0UPDZ9iPouDUu5O7QeBtLt
	 q4bMb+fxXnS4SQaqogXrfh0R+svRLdxBO29gtnv/IyORF8OSQUmvfWCkjsKiM/7tkS
	 Mr4AZ3MpR1ekk7z2tXLedoXu6zlonFmxRER3lyttK6206iBg9YTQpP+Jjq/DJeb29Y
	 2HtiNkTaxfvkpM7ouHTtNo8SO7HgqxHKXtfFcptDbpCyqdGdXNtz/8HpzCvDRWABtC
	 2eFK6WD0DpONrXiOsRqFojeS1LBIPu3bdZQlWS0kXcPWs2fJnsCmBanXfPGBmEwR8x
	 iADqk/z/3y2jA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 62C852E015A; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 21/23] ext4: fix device comparison overflow in ext4_getfsmap_dev_compare()
Date: Wed, 11 Nov 2026 23:47:10 -0500
Message-ID: <20261112044712.1577296-22-tytso@mit.edu>
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

ext4_getfsmap_dev_compare() returns the difference of two u32 encoded
device numbers as an int.  new_encode_dev() places bits 8-19 of the
minor number in bits 20-31, so any device with a minor number of
0x80000 or higher encodes to a value with bit 31 set, and the
difference of such a value and a smaller one does not fit in an int.
The comparison then has the wrong sign.

With an external journal on a low-numbered device and the filesystem
on such a high-minor device, sort() orders the handlers as
[data device, log device].  ext4_getfsmap() relies on the handlers
being sorted in ascending device order: a query covering only the
log device hits "fmh_keys[1].fmr_device < handlers[i].gfd_dev" on
the data device first and breaks out of the loop, so no mappings are
returned for the journal device, and a full query reports the devices
in descending order, which breaks pagination with the last returned
record as the next low key.

Use cmp_int() so that the comparison cannot overflow.

Add a KUnit test with a high-minor data device and an external
journal device.

Fixes: 0c9ec4beecac ("ext4: support GETFSMAP ioctls")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/fsmap-test.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/fsmap.c      |  2 +-
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/fsmap-test.c b/fs/ext4/fsmap-test.c
index 63a1061b413a..ef7681cf9964 100644
--- a/fs/ext4/fsmap-test.c
+++ b/fs/ext4/fsmap-test.c
@@ -765,6 +765,61 @@ static void test_getfsmap_external_logdev_and_multi_device(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, head.fmh_entries, 0U);
 }
 
+/*
+ * A data device whose encoded dev_t has bit 31 set (minor >= 0x80000) must
+ * still sort after a lower-numbered external journal device, so that devices
+ * are reported in ascending order and log-device-only queries work.
+ */
+static void test_getfsmap_high_encoded_datadev_order(struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *sink;
+	u32 datadev, logdev = new_encode_dev(FSMAP_TEST_LOGDEV);
+	int err;
+
+	sink = kunit_kzalloc(test, sizeof(*sink), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sink);
+	ctx = fsmap_create_ctx(test, 12, 0, 1, 128);
+	fsmap_set_group_tables(ctx, 0, 2, 3, 4);
+	fsmap_mark_clusters_used(ctx, 0, 0, 12);
+
+	ctx->data_bdev.bdev.bd_dev = MKDEV(259, 0x80000);
+	datadev = new_encode_dev(ctx->data_bdev.bdev.bd_dev);
+	KUNIT_ASSERT_GE(test, datadev, 0x80000000U);
+	KUNIT_ASSERT_LT(test, logdev, datadev);
+
+	ctx->mock_journal.j_blk_offset = 16;
+	ctx->mock_journal.j_total_len = 64;
+	ctx->sbi.s_journal = &ctx->mock_journal;
+	ctx->sbi.s_journal_bdev_file = &ctx->log_bdev_file;
+
+	/* Multi-device query reports logdev (2 recs) before datadev (6) */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_EQ(test, head.fmh_entries, 8U);
+	fsmap_expect_rec(test, &sink->recs[0], logdev, 0, 16,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[1], logdev, 16, 64,
+			 EXT4_FMR_OWN_LOG);
+	KUNIT_EXPECT_EQ(test, (u32)sink->recs[2].fmr_device, datadev);
+	KUNIT_EXPECT_EQ(test, (u32)sink->recs[7].fmr_device, datadev);
+
+	/* Targeted query against only logdev */
+	memset(sink, 0, sizeof(*sink));
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = logdev;
+	head.fmh_keys[1].fmr_device = logdev;
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_EQ(test, head.fmh_entries, 2U);
+	fsmap_expect_rec(test, &sink->recs[0], logdev, 0, 16,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[1], logdev, 16, 64,
+			 EXT4_FMR_OWN_LOG);
+}
+
 static struct kunit_case fsmap_test_cases[] = {
 	KUNIT_CASE(test_fsmap_unit_conversions),
 	KUNIT_CASE(test_getfsmap_invalid_flags_devices_and_keys),
@@ -773,6 +828,7 @@ static struct kunit_case fsmap_test_cases[] = {
 	KUNIT_CASE(test_getfsmap_1k_bofs_bigalloc_and_meta_bg),
 	KUNIT_CASE(test_getfsmap_count_only_pagination_and_abort),
 	KUNIT_CASE(test_getfsmap_external_logdev_and_multi_device),
+	KUNIT_CASE(test_getfsmap_high_encoded_datadev_order),
 	{}
 };
 
diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index f41c2298d196..dd465b27f879 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -69,7 +69,7 @@ static int ext4_getfsmap_dev_compare(const void *p1, const void *p2)
 	const struct ext4_getfsmap_dev *d1 = p1;
 	const struct ext4_getfsmap_dev *d2 = p2;
 
-	return d1->gfd_dev - d2->gfd_dev;
+	return cmp_int(d1->gfd_dev, d2->gfd_dev);
 }
 
 /* Compare a record against our starting point */
-- 
2.56.0.542.g3ef89b7020-goog

