Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115858;
	b=XRUwsR6NMBeW9eJgx09afbPzBhmxpRg23pNUXmuJ5G/dyW7ToYg6ercLL+sBshgeyuzv
	 IRRBbQDvmdL3HUgn2jvNc4jgsPwt5YyJsCDIDf/n7SeE2aRN7kSWdOikE4Utyh/hzvcAP
	 IWU59FnpigYdL78dqAV5F0L6h5BJF/s1sBb54AR7LYfyvFMKrTA+6fbKF2B7KSI0ceOPI
	 gJaDSLz6l8t89gTb+5CgbQmh79mZdV+T6PnT5aYYLajfbZm3RKjs+byxhZcasWjGEVaFz
	 2KWz/jqzkDmshkXAthW7qGezvGynR6UvuYJxufuSdGOGvUXcoYvxBTbfscuQiX53ELg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115858;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sh+ycXO5Mh8jvpT0fVPJS1MUFgkjQCtZ6MHlbyQu5uc=;
	b=RZH3+C9VwM/E0CJEjsaWYl+QHP5iGddXfSSmteeSLc/6mbNUXa5GuFzZmfOj1t7D9lr4
	 oSe8OB7xhzGLUg8pc6y5MekdNpC3TtlhQ2KmM7BYlb5aj+8t93EO3fpL5qpMAE2eb0+t3
	 S6M8KkzvLIBZJmLX+ojwM5JdcdmRt0nXwOiLHxag0tZ0VYZhwJyYfZbEGiA/ApmAkNZfS
	 biXhZ0fh60cnks48KHdY6kWn3g9kyc1ZEdsl4UU/nJrqpooYi08LL3tfk7P50YSV5GXK+
	 fL2FWWTMCZZ6pbYV+qF0slyUw9EXeElYq48s9uoMOKBLVgiXLS51lLzsRWsHALrklGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MciTQPu6;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84580606A337
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84580606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MciTQPu6
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYCi030002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=sh+ycXO5Mh8jvpT0fVPJS1MUFgkjQCtZ6MHlbyQu5uc=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=MciTQPu6m3zzdRmJdWiLQjViXF4JUZHg8sO0k7Tlup83034QNUHlb2NgCXOXflnkc
	 2T5rVdk826MZQpbvM/eSclvZkUgMuF91P2ZsZ6jOUNBYZn2Gma23P9FpehomLAz/qE
	 i6dJSt2dLa6kIs5xJ1VNpXKR1dpIilvBDKEIxjVNatS5pVjrtCagmYuECNWRYtxF5d
	 Kh+4HvH55EigQ6rH2eJvaHaF2WP+RgO7/+Vl6ZiAqrhs1wL4zwPrv4UvngmCJBP6e1
	 ZLDv9fTfmTMq7C5g17zcfH1cXE+n5iLwFx98POFFxNpGpMCO3BmsuqkVJTNhH1Y7YA
	 MqOpIYqn2hH6g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 7540D2E016B; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 31/32] ext4: set bh->b_bdev on mock buffers in resize-test
Date: Thu, 19 Nov 2026 14:17:18 -0500
Message-ID: <20261119191719.1943298-32-tytso@mit.edu>
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

When block:block_dirty_buffer event tracing is enabled,
ext4_group_extend() -> ext4_mb_mark_context() ->
__ext4_handle_dirty_metadata() -> mark_buffer_dirty() invokes
trace_block_dirty_buffer(bh), which dereferences bh->b_bdev->bd_dev.

resize_init_mock_bh() in fs/ext4/resize-test.c previously left
bh->b_bdev NULL, causing a NULL pointer dereference in
test_group_extend_partial_last_group() when tracing is active.

Pass &ctx->bdev into resize_init_mock_bh() so all mock buffer heads in
ext4_resize_test have a valid bh->b_bdev, matching ioctl-test.c.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize-test.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
index 1a4c1963648f..de825679d7bc 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -155,10 +155,13 @@ static struct file_system_type resize_test_fs_type = {
 	.kill_sb	 = kill_anon_super,
 };
 
-static void resize_init_mock_bh(struct buffer_head *bh, struct folio *folio,
+static void resize_init_mock_bh(struct buffer_head *bh,
+				struct block_device *bdev,
+				struct folio *folio,
 				u8 *data, size_t size, sector_t blocknr)
 {
 	memset(bh, 0, sizeof(*bh));
+	bh->b_bdev = bdev;
 	bh->b_folio = folio;
 	bh->b_data = (char *)data;
 	bh->b_size = size;
@@ -200,7 +203,7 @@ static struct buffer_head *resize_get_or_create_bh(struct resize_test_ctx *ctx,
 		return NULL;
 	}
 	blk->blocknr = blocknr;
-	resize_init_mock_bh(&blk->bh, ctx->bh_folio, blk->data,
+	resize_init_mock_bh(&blk->bh, &ctx->bdev, ctx->bh_folio, blk->data,
 			    RESIZE_TEST_BLK_SIZE, blocknr);
 	list_add_tail(&blk->node, &ctx->blks);
 	get_bh(&blk->bh);
@@ -734,8 +737,8 @@ static int resize_test_init(struct kunit *test)
 	ctx->es = (struct ext4_super_block *)sbh->b_data;
 	sbi->s_es = ctx->es;
 
-	resize_init_mock_bh(&ctx->iloc_bh, ctx->bh_folio, ctx->iloc_buf,
-			    RESIZE_TEST_BLK_SIZE, 99);
+	resize_init_mock_bh(&ctx->iloc_bh, &ctx->bdev, ctx->bh_folio,
+			    ctx->iloc_buf, RESIZE_TEST_BLK_SIZE, 99);
 
 	active_resize_test = test;
 	kunit_activate_static_stub(test, ext4_sb_getblk, resize_sb_getblk_stub);
-- 
2.56.1.708.g77570a6a1d-goog

