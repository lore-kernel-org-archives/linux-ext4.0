Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=qaw+RkotVvXlSIYCG7iesQ6ETC/6ZjPlPNS1xKGaek/hNpQ+D1jFvZ27Qs2dibvp0w+v
	 3Ij0f6yJYvhsrieHG3I+e/QKe0Kk2oHsGmPmFNkcpV3LKBIUA3fibWm4pTm/9RMxx1W5a
	 DPKY5WEG5bMTJ0/KfyQFQw20P6iQxZZeY4aoGNrpxl9pyHgn/OyGuX0rNJlfPSxCHNEiM
	 hRHfYtP+63a92IRBWM0DoOMzybT4239WH18CXyX1eYcbRQOKbOZDpOT/Llk6PP1RHc7hU
	 M7pDqqRXWhEcZsRVYRePFs9YYlSuhao9uPneGVGpa3p9fY7/X0rHxkFsrC4YEJwss0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SS5Zc2hKCjnyEpaqFCC43aEyzwOT6FUSYcsEYOnbOpg=;
	b=z5aulZDK93+ZPRh+SDOp0lakaDf1Q/2KTxU+0rY/A/FoTC0E+ENprlbVHsdWCd+MuVSh
	 IJ6cDpR1tXoeAx2cnmPFjWho8yOO7b27ylN96CyBJ39QZbcHmbFDtIrdPkDPjD4tUGgkf
	 cw7XGJxWm2aHysxi9zMrbQ5ybHHj27r1MpSMbbkWq+YAfUo1rAi7lplKHHiIlkEyp+o1i
	 /Dlg2eKDRjVwgR2Ziz12bpB2QAzXXTOEZqpF2pSHT5MjNT9bTFvaQ3kD2imqOlCM6bHE5
	 K4nOoF1xExyblkLDLPYmpuYltI8JovtBd9fJQ+Om2wXLhqJfkG/DEXvXaAr0YfbijwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ioQxR6xW;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8174D60A260C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8174D60A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ioQxR6xW
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYTX029975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=SS5Zc2hKCjnyEpaqFCC43aEyzwOT6FUSYcsEYOnbOpg=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=ioQxR6xWSSk00CjcdcVcVWDKoewvozdidy1Po/jOoRVqrejMmWkHsgr5Dha6NFCsa
	 LWsX/k1da1hC3DaHAcSwLs1WbwWWyYeWvQmOSN9fy1nCLe2y5NvDdNOERrN3loZysR
	 WGcZTarlBUgp5YpD2iI0vIdXWxAzzhHdraQMACP+hgyev+DrYGPE+jAs3qSG7+VRwY
	 wYhjbO2FqGmd2mvj423ciQ1fRrd/92FVjCw7X+spUpn4ayZ0uMrf8kS9SEI0ZNlJm4
	 jpPfsIpSe1leDK7UM2nleNpIp/cg5QRdM8CcLpMltMpm50/+u72Giv3m3zYcuDHk7R
	 WIRJ+kn7T/zgA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 618A62E015E; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 25/32] ext4: validate child dx_node limit and count in ext4_htree_next_block()
Date: Thu, 19 Nov 2026 14:17:12 -0500
Message-ID: <20261119191719.1943298-26-tytso@mit.edu>
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

While dx_probe() validates both dx_get_limit() and dx_get_count() on
root and child dx_node index blocks, ext4_htree_next_block() descended
into newly loaded child dx_node blocks without validating either field.
On a corrupted multi-level htree directory, an unchecked child dx_node
with a mismatched limit, count == 0, or count > limit causes subsequent
ext4_htree_next_block() iterations to step out of bounds past the
4 KiB block buffer or dereference arbitrary blocks.

Extract dx_check_entries() to share the limit and count validation
between dx_probe() and ext4_htree_next_block(), and release the newly
read buffer and return -EFSCORRUPTED before modifying the frame stack
if validation fails in ext4_htree_next_block().

Extend test_namei_check_dx_root_and_probe() in ext4_namei_test with
three regression cases covering child dx_node limit mismatch, count == 0,
and count > limit.

Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei-test.c | 60 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c      | 49 ++++++++++++++++++++++--------------
 2 files changed, 90 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/namei-test.c b/fs/ext4/namei-test.c
index 3126ec43e85e..277a4a4631f2 100644
--- a/fs/ext4/namei-test.c
+++ b/fs/ext4/namei-test.c
@@ -1252,6 +1252,9 @@ enum dx_probe_case_id {
 	DXP_BAD_ROOT_LIMIT,
 	DXP_ZERO_COUNT,
 	DXP_TREE_CYCLE,
+	DXP_NEXT_BAD_NODE_LIMIT,
+	DXP_NEXT_ZERO_COUNT,
+	DXP_NEXT_COUNT_EXCEEDS_LIMIT,
 };
 
 struct dx_probe_param {
@@ -1337,6 +1340,21 @@ static const struct dx_probe_param dx_probe_params[] = {
 		.id = DXP_TREE_CYCLE,
 		.expect_ok = false,
 	},
+	{
+		.desc = "ext4_htree_next_block rejects child node limit mismatch",
+		.id = DXP_NEXT_BAD_NODE_LIMIT,
+		.expect_ok = true,
+	},
+	{
+		.desc = "ext4_htree_next_block rejects child node count == 0",
+		.id = DXP_NEXT_ZERO_COUNT,
+		.expect_ok = true,
+	},
+	{
+		.desc = "ext4_htree_next_block rejects child node count > limit",
+		.id = DXP_NEXT_COUNT_EXCEEDS_LIMIT,
+		.expect_ok = true,
+	},
 };
 
 static void dx_probe_get_desc(const struct dx_probe_param *p, char *desc)
@@ -1401,7 +1419,12 @@ static void test_namei_check_dx_root_and_probe(struct kunit *test)
 							    TEST_BLK_SIZE);
 		break;
 	case DXP_VALID_2LEVEL_AND_NEXT:
+	case DXP_NEXT_BAD_NODE_LIMIT:
+	case DXP_NEXT_ZERO_COUNT:
+	case DXP_NEXT_COUNT_EXCEEDS_LIMIT:
+		dir->i_size = 5 * TEST_BLK_SIZE;
 		root->info.indirect_levels = 1;
+		dx_set_block(root->entries + 1, 4);
 		bh1 = map_and_get_dir_bh(ctx, dir, 1);
 		KUNIT_ASSERT_NOT_NULL(test, bh1);
 		node = (struct dx_node *)bh1->b_data;
@@ -1413,6 +1436,30 @@ static void test_namei_check_dx_root_and_probe(struct kunit *test)
 		/* Continuation hash (low bit 1) matching 0x40000000 */
 		dx_set_hash(node->entries + 1, 0x40000001U);
 		dx_set_block(node->entries + 1, 3);
+		if (p->id != DXP_VALID_2LEVEL_AND_NEXT) {
+			struct buffer_head *bh4;
+			struct dx_node *node2;
+
+			bh4 = map_and_get_dir_bh(ctx, dir, 4);
+			KUNIT_ASSERT_NOT_NULL(test, bh4);
+			node2 = (struct dx_node *)bh4->b_data;
+			node2->fake.rec_len = ext4_rec_len_to_disk(
+					TEST_BLK_SIZE, TEST_BLK_SIZE);
+			if (p->id == DXP_NEXT_BAD_NODE_LIMIT) {
+				dx_set_limit(node2->entries,
+					     dx_node_limit(dir) - 1);
+				dx_set_count(node2->entries, 1);
+			} else if (p->id == DXP_NEXT_ZERO_COUNT) {
+				dx_set_limit(node2->entries,
+					     dx_node_limit(dir));
+				dx_set_count(node2->entries, 0);
+			} else {
+				dx_set_limit(node2->entries,
+					     dx_node_limit(dir));
+				dx_set_count(node2->entries,
+					     dx_node_limit(dir) + 1);
+			}
+		}
 		break;
 	case DXP_DOT_BAD_NAMELEN:
 		root->dotdot.rec_len = ext4_rec_len_to_disk(12, TEST_BLK_SIZE);
@@ -1491,6 +1538,19 @@ static void test_namei_check_dx_root_and_probe(struct kunit *test)
 		KUNIT_EXPECT_EQ(test,
 			ext4_htree_next_block_test(dir, 0x40000000U, frame,
 						   frames, NULL), 0);
+	} else if (p->id == DXP_NEXT_BAD_NODE_LIMIT ||
+		   p->id == DXP_NEXT_ZERO_COUNT ||
+		   p->id == DXP_NEXT_COUNT_EXCEEDS_LIMIT) {
+		KUNIT_ASSERT_PTR_EQ(test, frame, &frames[1]);
+		/* First step stays in bh1 (entries[1]) */
+		KUNIT_ASSERT_EQ(test,
+			ext4_htree_next_block_test(dir, HASH_NB_ALWAYS, frame,
+						   frames, &start_hash), 1);
+		/* Next step descends into corrupt child dx_node at lblk 4 */
+		KUNIT_EXPECT_EQ(test,
+			ext4_htree_next_block_test(dir, HASH_NB_ALWAYS, frame,
+						   frames, &start_hash),
+			-EFSCORRUPTED);
 	}
 	dx_release_test(frames);
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 863a30d50535..533fd3f94c7e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -608,6 +608,25 @@ static inline void htree_rep_invariant_check(struct dx_entry *at,
 }
 #endif /* DX_DEBUG */
 
+static bool dx_check_entries(struct inode *dir, struct dx_entry *entries,
+			     unsigned int expected_limit)
+{
+	unsigned int limit = dx_get_limit(entries);
+	unsigned int count = dx_get_count(entries);
+
+	if (limit != expected_limit) {
+		ext4_warning_inode(dir, "dx entry: limit %u != expected limit %u",
+				   limit, expected_limit);
+		return false;
+	}
+	if (!count || count > limit) {
+		ext4_warning_inode(dir, "dx entry: count %u beyond limit %u",
+				   count, limit);
+		return false;
+	}
+	return true;
+}
+
 /*
  * Probe for a directory leaf block to search.
  *
@@ -697,26 +716,15 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	entries = (struct dx_entry *)(((char *)&root->info) +
 				      root->info.info_length);
 
-	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
-		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
-				   dx_get_limit(entries),
-				   dx_root_limit(dir, root->info.info_length));
+	if (!dx_check_entries(dir, entries,
+			      dx_root_limit(dir, root->info.info_length)))
 		goto fail;
-	}
 
 	dxtrace(printk("Look up %x", hash));
 	level = 0;
 	blocks[0] = 0;
 	while (1) {
 		count = dx_get_count(entries);
-		if (!count || count > dx_get_limit(entries)) {
-			ext4_warning_inode(dir,
-					   "dx entry: count %u beyond limit %u",
-					   count, dx_get_limit(entries));
-			goto fail;
-		}
-
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q) {
@@ -759,12 +767,8 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
 		entries = ((struct dx_node *) frame->bh->b_data)->entries;
 
-		if (dx_get_limit(entries) != dx_node_limit(dir)) {
-			ext4_warning_inode(dir,
-				"dx entry: limit %u != node limit %u",
-				dx_get_limit(entries), dx_node_limit(dir));
+		if (!dx_check_entries(dir, entries, dx_node_limit(dir)))
 			goto fail;
-		}
 	}
 fail:
 	while (frame >= frame_in) {
@@ -861,13 +865,20 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 	 * block so no check is necessary
 	 */
 	while (num_frames--) {
+		struct dx_entry *entries;
+
 		bh = ext4_read_dirblock(dir, dx_get_block(p->at), INDEX);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
+		entries = ((struct dx_node *)bh->b_data)->entries;
+		if (!dx_check_entries(dir, entries, dx_node_limit(dir))) {
+			brelse(bh);
+			return -EFSCORRUPTED;
+		}
 		p++;
 		brelse(p->bh);
 		p->bh = bh;
-		p->at = p->entries = ((struct dx_node *) bh->b_data)->entries;
+		p->at = p->entries = entries;
 	}
 	return 1;
 }
-- 
2.56.1.708.g77570a6a1d-goog

