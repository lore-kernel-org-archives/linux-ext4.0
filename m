Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458845;
	b=woEoGdTipWEVunZ3ZVfwbeFAR80iBX5Vi2G1GfmDkG+O3acATh4ar28oT1XMXERDM0ae
	 EVmwHmkfE2zxpeAnjP25AHz/h4xcG5zRyXDEfCvCgpQxqwrQo9uwvyyY0C76W5f4LFHBL
	 ulpBylpCS8tLb85vVMzXYiND1Q3O3ODLZribS2arzr1dGmFrs96N1w02prLWUSGNHS1Ew
	 eNioCP5KOMdb0YK0/vqzomoud/05JH5V97nF9M9PBbMMKL+oBG7cXEepq2R+F8zEHCw4X
	 JBmnGLE2QKZzKIDbS4wZC2qqunYpGUXQaQFdAK7R9SsAT0tjquDhtSB3dFolIjosPuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0RL37LYngq7vkZgOrAh43MpxnPsfG6YNF0kk+KbaPPQ=;
	b=Y+/JzhR5ntgZSQ7pgrSf2EBOFbvWQLGvDbc/TuK/8Yq4pans6xkizxhh5KN9SpQ1RtAE
	 pnXc89WfrrnQ6unPTcwaOBczAhNrI1+NwbreEOlI5wIfupZ4/Yy2ETCU8lMZIseV+rLlm
	 H9GqxYRWpPSOQgir4L/yJ5IxVgts2H5c+I26JTcBK4pGOfJd/Tq/KBoMkureuJqt2o3iV
	 LD8JeaRqEv5BOD7p05Qu7CpjVAMzUC4ALsnhgmTo0N4DrJWS+RN5IoqbhIpOUVOvPZ4Ki
	 Nmt4fo0TDgYPEPZ44xPRSmnnI7k3JpSkTlFA/l+Lnv5nIg6oG5GGGP2cL6xz9N6u3BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=IRxqpbt5;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47917606A339
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47917606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=IRxqpbt5
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKnw031215
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=0RL37LYngq7vkZgOrAh43MpxnPsfG6YNF0kk+KbaPPQ=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=IRxqpbt5fmkB1mlUfG63ehP5Y+YdxGgoMz6qeftnzbNg7XlC3L92gCukt0tlOTzXb
	 /RUIhyx21/EQ8FxtSFra4wmOYZgY0JSyCl9kPdsKqdrUCFtlN/ph6/cKi23ZA/iE9D
	 B4jrlwYA2iaw/Fgx2Ertg3xgX/r+LmEhBMQUocfhvnssvqWS2M1w7p8Fkb2lsQGvA1
	 Gw15ee92yT8cEWb2H3xe+gWk1pkWM+5uAaBjs2033boGeYHuhMhCw8W2sw0hMkWXt9
	 MqwHszfsEYeWSUFYAZU7qF4MPcn6kHqachSA697KgzSvma2YJCt+JAVMg53rfiUlIx
	 i7YS8b14aJlyg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4625F2E0151; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 12/23] ext4: reject EXT4_IOC_GROUP_ADD inputs larger than a block group
Date: Wed, 11 Nov 2026 23:47:01 -0500
Message-ID: <20261112044712.1577296-13-tytso@mit.edu>
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
index 32de2876416b..4a08a47b3481 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -950,6 +950,18 @@ static void test_verify_group_input_rejections_and_acceptance(struct kunit *test
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
index 2ecd758be38e..5e3b4e9f99f8 100644
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
2.56.0.542.g3ef89b7020-goog

