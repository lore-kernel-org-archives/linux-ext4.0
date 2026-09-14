Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386D45A299;
	Mon, 14 Sep 2026 12:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387592; cv=none; b=BFtMNFwT+JYZPYPeOjyzclXq6KL0nlzClTsYJuyC7QqIQ9rTSp5OTd+eahpPZ34EVfnchhNStozEMZ0Fyu430VUHk0Kb3EqHsRfQT17xhRrj7HEqNUEPPiIjAeNG2q9b4lGWzLkLfeLTUEoskaFmeYIeijLMFMx7NU0c3cOJIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387592; c=relaxed/simple;
	bh=oY01YJcyLIVfiiJrtk9fnb4cqJqTGa3kaUG6NYwAfRc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=p+GtVRzXAC39mdUBZCfZNIVApzj4S0mKu1FiUivQQM5nMS07W96m48tVuM09XEpjfalMWS0j5OBewQDV9RlOVYqUSWg/iInxX2fE9RIcBIX+fXhhJdrarIulvlkAmy6V71+87CA1E1VsgYeTZqQ/HV8gzsROXV0ti44+vZR+NqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=j0p3v40U; arc=none smtp.client-ip=203.205.221.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="j0p3v40U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789387559; bh=OQ3dZPCg7p6vmDoNqCvLJME+3BFGMSytax4jBBF8aJk=;
	h=From:To:Cc:Subject:Date;
	b=j0p3v40Ul2KLtpOzAbJk7RdsNZcc10Tv75bixPhGLd0qNYWkZ1T6qlG2IGxF46EMK
	 32J3Uwv95gYQaAHjGsf//i65wJeBZZNNcU1Y9jQ8tyHpIAwphgzra79kZwy0cicGw/
	 rjQuBAKbcLg0yg5XkDzpqTMhE+YLS58YFIxxYw1c=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 17896A1B; Mon, 14 Sep 2026 20:05:56 +0800
X-QQ-mid: xmsmtpt1789387556tljkixubw
Message-ID: <tencent_BCDA824359279D18963B838B15B01BC1CD06@qq.com>
X-QQ-XMAILINFO: Mfa2ogpi8We7GmW621EN/NP4MhPIPyLQBjIC27sYBHFA886TQ4ikAk1X/Smjlz
	 IZeYIghWuEw3nBxDdoaqA+AmZBzk2gJ9QECz4T4mRkQr9H6q/cSh8NbltMtZHoAvSg2ZN+jhF/eL
	 omxLOf9jtYtsFE5I79gt0GtVTLOFL/2HpKEIRtsMqKRISflYyqy13VvmxixqpiRtM8xG5O5sMAZe
	 ieQgVIR2jiYGG0CZ9/tif8R0hBpGQNG/ZHUxUzskCRxonqYB0t6qvmi/5WYOwMPhn5HAs4mAzZ8V
	 lKV1F4tKM81ujiHkTc9r6j9wRH8gz7o1pLRpl/1/140QVYcS5RDkVbp8zwX9sHNrc3DcwIlbwSWU
	 HF1gV+nwxmRIOa3SAE5Vqg94YB3xUKCCBrz2eJK/kIuSpJfv4W+jUGEcgdpM2JOs7Y96dcrcMjTj
	 f8TxanH3+NgMxSPcbtZCJBGVF/WAa7o4aNHzvXo9IY+cycYc/4vHkZ48sngSwwTfDpdeObIZj6J3
	 Ou72GkeyQZZGDjQRj5W77WalvGq3NIyw4yuZ38FesPAAJBSB7t8tFcAe/10FRzvYmHBbBE7xQe9l
	 +/jnoygV8lZo2do64lY79toaTPiC67Blw/+h59EBuc0SoGZ26/yQlTxhkw5DFHTy8QKavX3c8wRU
	 WhI6tJh7IGWhAA54CFQTGrFwDdCydKFaslV74uQk2MD64hMnsX+OwZjptvV7F+Q+hPijQhnry2u4
	 Qm3M4JEuKGLeJ0iKpBZvjeV6xgx1vG9/BTX69nizQPT9MG6h75mBQVDFeF2Lswz9b6OAU1XchybR
	 YNtOI0TJQ/tq5oC8WKu6v1pNyQIXstXdmgrg10GtiyveryEaEfpfSmuVpYbtWyegUnrfO9ezjkgm
	 1YjCY5kDhAICg77oTJlXDD8AlQqgasEdBK6IYGDHIR3uygRCokpzIIbEFO1JjA1JlIpIB/GN0QBm
	 XW1ZArLPW7NF7G5HZehNOviXLLivnRryrCP+atpzcyOkAwFR1r1VwGrgMQ2aKXEMOlWJb31AsFgi
	 2B2TNoSXwW5D1TIHwIfaAd0+GnGnulRxnH+B90pg==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: lty <781735889@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	harshadshirwadkar@gmail.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lty <781735889@qq.com>
Subject: [PATCH v2] ext4: propagate errors from fast commit i_blocks replay
Date: Mon, 14 Sep 2026 20:05:56 +0800
X-OQ-MSGID: <20260914120556.806347-1-781735889@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_ext_replay_set_iblocks() breaks out of its mapping loop when
ext4_map_blocks() fails, but then continues with a partial block count
and unconditionally returns success. The fast commit replay caller also
ignores the helper return value.

Stop the count immediately on mapping errors, leave i_blocks unchanged,
and propagate the failure to abort inode replay.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")

Signed-off-by: lty <781735889@qq.com>

Changes in v2:
- Propagate errors from all ext4_find_extent() and skip_hole() calls in
  ext4_ext_replay_set_iblocks(), as requested by Jan Kara.
- Keep i_blocks unchanged when any replay lookup fails.
---
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

