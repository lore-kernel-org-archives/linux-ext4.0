Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F233CEB99
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 01:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437508; cv=none; b=sS0aMtkfgixIJP7x8X7iHiPHSDXRzupNSLIPQJSeK6XSgNl/KSg9X0QJhZg6coOGwO1IGzrqYYJj2uhCTTuv88jolm+QivbGZIF797BHI4rXn9aIsuEf2CxJVmIHahs3PofT75L4FLOdAR4vWfOfAaWGqSdexoM0Vq5Vl6uXlcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437508; c=relaxed/simple;
	bh=qYQmH8ngtaPac+K8JUQ/yRgZn24J2DIhazz4/5beY64=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=kj75c9a+ffmuRHSFpl0k7cyz5X474vvXrP4cpMOE7f/myTDrF08bDpsgWpVxU5b4VBIg04LPSEj5Ka5S5CWrDlChC45fZD4lZZaccTsmkEopdvQCuYRHydl/ILR5invDQxUNPi+2QFn4zxqsKCLXn6NEXODUO83h1W1b6L7Q+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=CH2S3KU2; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="CH2S3KU2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789437495; bh=FCODJr/2EGdLTB7JhKYj8dAx/+MZjYGcCKafdDengk8=;
	h=From:To:Cc:Subject:Date;
	b=CH2S3KU2uB5wqF1+SlI1WH75+uMinWeMJLL84a1V8IgNdLUpu4MxFulYrD/GTFSk/
	 3vTlk1qxydczAuiFeddhC7V2az2vJFlejIdl0MOOqcws45+C0cyN6MiGX61Z92A9ze
	 707U6IaQFHcaJrW3kzdynqI2dLesBeK76pvDq9+8=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id E8318A2D; Tue, 15 Sep 2026 09:58:03 +0800
X-QQ-mid: xmsmtpt1789437483tg8li2pa5
Message-ID: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
X-QQ-XMAILINFO: MidKUt01ypo8UqRUGtFLetnB2ckaukSR66cv1SuRRpVB2ijPX4l5RGRuVx0Izq
	 Mhg9Dd0qmYRt6H5GyR75TCMA0n5tPM+ktadv9vGSQvDoihoudlyoSejrxh5bXziVFIGytZFUxYbN
	 6jTK7nHzSi81t2TFg+A73PoNLLsiJJga7jpIDd306RgMoSR8tr+5RbCMPqn0u4MxfCMMu2gvBCYH
	 WweCb991jacqhoO7XR1yL33T8pjk7HanZRfVqbGbP2hRxDfI9HQ3ncKVr4UWu/1bs+/lPSX4Y7OY
	 x4pd9RLwSDC2ixOz1gdcnZKNDkaeQL2j9iTiE8sNxbJ53Gmemetrzk76nsRL43SZ0kCO6cKhuRi5
	 7jB0Cp5PCq5uBcSqi5i1n8ak2fWiIQTgV3AxEsUpiBUbd4t5r9d3uc459mwRVJ7nf7eadkdKUXwd
	 Je9MsPb7uknzM38uh5ID1j5U1+jjwAvD3xlFuSRkE5YulWuNNkKSRjNAYgS1RnAIzSStiAmBH8fT
	 VihWp+bwGiqXoT4ZKbMAiBjuYgJGdqU118q8HwCCwn5EzYlSN1POwg7j2UZEvRxzu8RyP7dyQ1fU
	 0/GTP4+60nFEpgS6epc2SIPrYuiT/y5mLVroQuQQzQnreEUW/kZ6+LxhZDa35aDKO7OhhLckD7RF
	 qh4aTnC4cKs2pxpo0TXLs2k2nqvGnFThrIaCJYJoJy8udoYC9PmxIN5zIot0EhY244pF1vPOohMs
	 uP8B8eplwNrtjXGQ14+/MU1hSTJWHS19kr5otAHoWBwtKHQzXKXGahzfp3y6TBMB47N7y/5QT88O
	 3HvsE39i1CgkzGt4/uqh0Qx8fNmlnev8VtsaG3ZuZ4X+0An10Fk5eAR4dc39PSXbx4OIchQaio8R
	 KTlBJFuaedQVwcO8BzsjnEEMgR+sJettw/yLO1OuC+84pAEZiYCHHT0G7JeWXkzHfHDnj1tWjfFs
	 SD+LNKGDfUQ67linHnTIFES05akb0vt4/nTc+jaXybjuKCrAZGqC0m5VPcJ2zAJm5G9JBLwUx83V
	 IQvpM6C5yDF/0N0hpDdb0RINeaC5jyvqnggQX/BKsxgSO/85mYILblPhzaswA=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: 781735889@qq.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	harshadshirwadkar@gmail.com,
	lty <781735889@qq.com>
Subject: [PATCH v3] ext4: propagate errors from fast commit i_blocks replay
Date: Tue, 15 Sep 2026 09:57:46 +0800
X-OQ-MSGID: <20260915015746.1426200-1-781735889@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lty <781735889@qq.com>

ext4_ext_replay_set_iblocks() breaks out of its mapping loop when
ext4_map_blocks() fails, but then continues with a partial block count
and unconditionally returns success. The fast commit replay caller also
ignores the helper return value.

Stop the count immediately on mapping errors, leave i_blocks unchanged,
and propagate the failure to abort inode replay.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: lty <781735889@qq.com>
---
Changes in v3:
- Move the version history below the separator.

Changes in v2:
- Propagate errors from all ext4_find_extent() and skip_hole() calls in
  ext4_ext_replay_set_iblocks(), as requested by Jan Kara.
- Keep i_blocks unchanged when any replay lookup fails.

 fs/ext4/extents.c     | 26 ++++++++++++++++----------
 fs/ext4/fast_commit.c |  7 +++++--
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c3655..f8c805d80c33 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6275,7 +6275,7 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
 		map.m_len = end - cur;
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret < 0)
-			break;
+			goto cleanup;
 		if (ret > 0)
 			numblks += ret;
 		cur = cur + map.m_len;
@@ -6291,15 +6291,19 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
 	cur = 0;
 	ret = skip_hole(inode, &cur);
 	if (ret < 0)
-		goto out;
+		goto cleanup;
 	path = ext4_find_extent(inode, cur, path, 0);
-	if (IS_ERR(path))
-		goto out;
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		goto cleanup;
+	}
 	numblks += path->p_depth;
 	while (cur < end) {
 		path = ext4_find_extent(inode, cur, path, 0);
-		if (IS_ERR(path))
-			break;
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
+			goto cleanup;
+		}
 		ex = path[path->p_depth].p_ext;
 		if (!ex)
 			goto cleanup;
@@ -6308,11 +6312,13 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
 					ext4_ext_get_actual_len(ex));
 		ret = skip_hole(inode, &cur);
 		if (ret < 0)
-			break;
+			goto cleanup;
 
 		path2 = ext4_find_extent(inode, cur, path2, 0);
-		if (IS_ERR(path2))
-			break;
+		if (IS_ERR(path2)) {
+			ret = PTR_ERR(path2);
+			goto cleanup;
+		}
 
 		for (i = 0; i <= max(path->p_depth, path2->p_depth); i++) {
 			cmp1 = cmp2 = 0;
@@ -6333,7 +6339,7 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
 cleanup:
 	ext4_free_ext_path(path);
 	ext4_free_ext_path(path2);
-	return 0;
+	return ret;
 }
 
 int ext4_ext_clear_bb(struct inode *inode)
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..8110b01e36c1 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2002,8 +2002,11 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	 * crashing. This should be fixed but until then, we calculate
 	 * the number of blocks the inode.
 	 */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
-		ext4_ext_replay_set_iblocks(inode);
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA)) {
+		ret = ext4_ext_replay_set_iblocks(inode);
+		if (ret)
+			goto out_brelse;
+	}
 
 	inode->i_generation = le32_to_cpu(ext4_raw_inode(&iloc)->i_generation);
 	ext4_reset_inode_seed(inode);

-- 
2.34.1

