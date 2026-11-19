Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=GryfokoPQorvm+pAKnSWZqu7b3lywjS0zOyh8XmffCV/Li2h1cggwU0gKOxqu6ZBQZnO
	 6QBZCxThbnDDaJh0p43G7SGx/seLDYju4PaV8jECD5gUQ87692lTlif27B730hpccJAGB
	 btODGBsgUIwVu8P6l/MQ6PA5wsLCdH5BgdSgOPBLAKWcAeVTmytcynKp9D3hDVTF2LLXt
	 3lTMwaGZFn/nvPOTgemLurSxwIqUQwI+prhBg7PouDuPiV5r33fFjnQTScXrX7EATr9VC
	 Q5gZiYC3Ucqbtnyyygn6fCM0Of7LWk+rqKhXpNHcY/gAb1T9TFQoJiXzYgPyjGwZamg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xA8eUQHICCGWBEh7hK6eMqwKZ5NrjevV92mW3tpgOuQ=;
	b=q+3SHmIM3mT7IKkSrKm+F6q14SG7HBPCsgNrEx+DHTLwHXeC/fN/UAYJfoiwk5TuBgCd
	 3BBmQJ1MYLE3YnKr7UBCJ/CLXyQQzX3p6KbUNcke6VfzKXxImeXPDhrW9k/SdU/E9kgZ0
	 IMQ96fIVUQKJgNKr0Rt8XtjBrLkrwykk3A6gzTZNmiEIQsLe6rcZXIfjgP0CRWNr23gs1
	 CLC62xbc0bYt/VGPc6jOB3zn8/e2QY+IVCZ71LXvnQiuFDk6jQTFI9jM+Hs3ofeAhL32R
	 SecsU3vS2PdR4uhzwn63IYAh7/PmcwBvLlUPEtxzt65mA0Kc482orY04dvG+Jl0JseQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=C95e6HLT;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA4F606A333
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADA4F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=C95e6HLT
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHWxB029886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=xA8eUQHICCGWBEh7hK6eMqwKZ5NrjevV92mW3tpgOuQ=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=C95e6HLTpm6/GSJDd9OASYp5R5Fnh7X0kpjn60bzF50ezScIPvRExR49nG7UxFx7G
	 RJQvtCugNomnsIanPPIdbqxX5wCpwLJkQoTvVfvLSc+ztDOYUljscNC4cmGsLwXZXS
	 ZHMvPHapCAXMDhE5JexmGnRM3nOcActXstNWzc6ZsxERBM4UZl20tWtIDJva9eWun2
	 +dwte7ltqp6/bC8ip9vKfJ1jcPI+aRzn670ovH5VqMVoExngY5/yRy8p3H1xWe58MU
	 nQZasmVQwEyzov95E7b39OBLH8MGgMj46kO7n2hKGsi+k8p3XiV41Z/++eCDPtHNCL
	 rNFSxSVwIsO4g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 369C32E0151; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 12/32] ext4: reject EXT4_IOC_GROUP_ADD inputs larger than a block group
Date: Thu, 19 Nov 2026 14:16:59 -0500
Message-ID: <20261119191719.1943298-13-tytso@mit.edu>
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

verify_group_input() checks that the group described by
EXT4_IOC_GROUP_ADD lies on the device and that its bitmaps and inode
table are inside [start, start + blocks_count), but never checks that
blocks_count does not exceed EXT4_BLOCKS_PER_GROUP().  A blocks_count
covering several groups is therefore accepted, and the metadata may be
placed in the second (or later) group of that range.

ext4_group_add() then hands ext4_flex_group_add() a flex group made of
the single on-stack input and bg_flags entries.  When
setup_new_flex_group_blocks() marks the group tables in the block
bitmap, set_flexbg_block_bitmap() derives the group index from the
metadata block number and uses it to index flex_gd->bg_flags[] and
flex_gd->groups[], reading past those single-entry stack objects and
modifying whatever block number it finds there.  Even without that,
adding a "group" larger than a block group leaves s_blocks_count
inconsistent with s_groups_count.

Treat blocks_count > EXT4_BLOCKS_PER_GROUP() as a bad blocks count,
before the device read.  A zero blocks_count is already rejected by the
free_blocks_count < 0 check, and the start + blocks_count addition
cannot overflow because ext4_group_add() checks it beforehand.

Fixes: 61f296cc4975 ("ext4: let ext4_group_add() use common code")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize-test.c | 12 ++++++++++++
 fs/ext4/resize.c      |  3 ++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
index da08bfbd2fe2..8bfca3c53aef 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -944,6 +944,18 @@ static void test_verify_group_input_rejections_and_acceptance(struct kunit *test
 			-EINVAL);
 	input.blocks_count = RESIZE_TEST_BLOCKS_PER_GRP;
 
+	/*
+	 * 4b. blocks_count spanning two groups, with the block bitmap in the
+	 * second one, would make ext4_flex_group_add() index past the
+	 * single-entry flex group arrays.
+	 */
+	input.blocks_count = 2 * RESIZE_TEST_BLOCKS_PER_GRP;
+	input.block_bitmap = start + RESIZE_TEST_BLOCKS_PER_GRP;
+	KUNIT_EXPECT_EQ(test, ext4_verify_group_input_test(sb, &input),
+			-EINVAL);
+	input.block_bitmap = start + overhead;
+	input.blocks_count = RESIZE_TEST_BLOCKS_PER_GRP;
+
 	/* 5. Last block beyond underlying device -> -EIO */
 	ctx->device_blocks = start + 100;
 	KUNIT_EXPECT_EQ(test, ext4_verify_group_input_test(sb, &input), -EIO);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index a873527fbfd7..f28bcdb71a12 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -181,7 +181,8 @@ static int verify_group_input(struct super_block *sb,
 	else if (input->reserved_blocks > input->blocks_count / 5)
 		ext4_warning(sb, "Reserved blocks too high (%u)",
 			     input->reserved_blocks);
-	else if (free_blocks_count < 0)
+	else if (input->blocks_count > EXT4_BLOCKS_PER_GROUP(sb) ||
+		 free_blocks_count < 0)
 		ext4_warning(sb, "Bad blocks count %u",
 			     input->blocks_count);
 	else if (IS_ERR(bh = ext4_sb_bread(sb, end - 1, 0))) {
-- 
2.56.1.708.g77570a6a1d-goog

