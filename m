Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D1A318EC7;
	Tue, 15 Sep 2026 01:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437537; cv=none; b=hyrvfdNWjrkN37b4g1DeTTui6KDiqHjBi7au1PrC9JyVdXXitfFJlLXq2IyVoHPOB7PSEo2ZXECYgrwGWwB1CSdiCU/TJJjeaBV9fqaW19tRj7n79LJlocTZkOvjRRe8z6mkPNBaLTb7GqQ5qm6MBkvu7OAA8AS8oQYXEfdxZkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437537; c=relaxed/simple;
	bh=FN8WjdxOGAFG3G1A6muAmBqyDA2TmlJtcfibr6xfxXI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=TpeH2nt/qhfUwHhsYND2d8xxe5N9G+dfCOFy9kw96iZcu+mySeBw1LqHFqfDyhxJhtWswOrvYpJ4YyapDODr9r/hgdJrfTTtGiC3k9zRla2p1BM1AlKNF0rJ+TN/IhUBns2wYL1IAgKnLtqX9mIuWQmQbIupNO12UEW5BU3a+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=EKZkpl56; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="EKZkpl56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789437524; bh=uJhP7pghNh27yatsnw3vuh8TA7NgBiYtWCubNtiu5rg=;
	h=From:To:Cc:Subject:Date;
	b=EKZkpl56Ni++rZdKTccxHvQG/QerHqKIgyIPBCdgEp+Uv3YoITEURB7uGSRdKxASS
	 DCsuSU+XCdAXM/8BUH+IGhRhGrIID8vkJvZF61wAFkt6w4al3sm03hZUd+LYZK98Cq
	 MJSoUB60ikaSWmarD+Pu2r0F0tkbsBWaBlj4v16E=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id EA3222CC; Tue, 15 Sep 2026 09:58:35 +0800
X-QQ-mid: xmsmtpt1789437515t0n93olsp
Message-ID: <tencent_FBD69AA6034FE7AF98BC3B90CB1EF012C106@qq.com>
X-QQ-XMAILINFO: N0wO3GTqxQkwwOV9h1Y8Pf6BZ5Y3piV0+asf7ajYqthLQRAMeFFGWt6Q5vIPGf
	 sa9w5m4/HbeGD1321/Ld3zHq2pirYw7CsBEL+ZweBlIWcRimK8sdbqLGaYcoVWkEXl8pb+Rb/mgY
	 zcTI4R13a2jKAjt0Jp9iV6Qs6dQeQ4Houo64alW/X6aLe0FrPhIwOtmWn6PUWweMSyK8Eodwcas/
	 rV733kFCdSzfu3kbt30jNGviRXf9XOCz6CuihdVDG/kadwQug+GQ+qPlmhBjJ4w4Y/7MlJWBNdIZ
	 1eAS/kz9AD4AgvONqBvPtP61Uz/qnS8rAFaMZru4DYQOQFy/PhkyeoFwTjZZ3hZmjHAVMZd0xgPP
	 ivQUtnn5fkFkoI+g6wfsnf9Tct/8g/pM3WJ5rIsVVkWnxDrP6pADEZZIWa/v5J4HC0ZwbtwTQhEk
	 Zo3PrjXGGM/EX4B1twxH1jqbBh+DJtfS4rKff4FWyOf1KYOxtrwNLPL2pSJZoOOHfriH39EXnwtY
	 zGuLP8hjxpZg31ZkbDrTAcdO9Y5mJybebwP01xCZQNHEPLa1facxSibgv/xl5MSDdOowRvTXEVih
	 rB0kiQWP6sVgIJbfEtz9oWoeevMKJuTk/eZmXPSw7XGnPgfkEoM9wPqbkMO2ZEyY1GzKvxlysr7Y
	 TVrW2ExeakYhp5yeg6sn8TQn5bUfdP/PncM7omhOFnFm3nUSvrnTf1/fxCAgseBI9xvbqmZMKpM1
	 MtsMvrIKLSfczMd8ZneVllL077zRJ+JoN5scPh5cpWWH5k6eBFz2QSOoLWZETdbaB3DPx8j2E4cJ
	 bRwhUInZ50sACH2YTjclXZpjD5WvMnpgmOn2UAYQHQ7mp+fZm57ihv0JdlfE3bsrkWcfcr/2gMsz
	 7sbhjonYR9D+vrbSnhc6HiGGZNris80rRCN23OtBMpFH3nWytR6GeW5qbvppzHztOJE6o3rmYlwC
	 EFMZVvMcgGhBlHYQcvqdURvWJUKLRW7DJXYrCLA32bYkkF0tW8wuBUNVKxGVenbMiFklIJaJCxHv
	 D/LycjzJROUYU1UeXdF2F7EHv8I5fYCDczgmMK1AutfUqk2GK8b3qMZGtRNp1nlfSZ209ocHjd5d
	 1jOeEF
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
	lty <781735889@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: propagate errors from fast commit block cleanup
Date: Tue, 15 Sep 2026 09:58:28 +0800
X-OQ-MSGID: <20260915015828.1426799-1-781735889@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lty <781735889@qq.com>

ext4_ext_clear_bb() stops scanning when ext4_map_blocks() fails, but it
returns success to its caller. It also ignores failures from extent lookup
and replay-region allocation. ext4_fc_replay_inode() ignores the helper
result and continues replay with stale block bitmap accounting.

Propagate all cleanup errors from ext4_ext_clear_bb() and abort inode
replay when cleanup fails.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org

Testing: QEMU fast-commit replay with an injected -EIO at the
ext4_ext_clear_bb() mapping call. The unpatched kernel completed recovery
and e2fsck reported a free-block count mismatch; the patched kernel aborted
recovery with EIO. Also built the ext4 target objects with the expanded
error paths.

Signed-off-by: lty <781735889@qq.com>
---
Changes in v2:
- Propagate errors from extent lookup and replay-region recording.
- Abort inode replay when block cleanup fails.

 fs/ext4/extents.c     | 31 ++++++++++++++++++-------------
 fs/ext4/fast_commit.c |  5 ++++-
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f8c805d80c33..ba6dee8829a5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6369,29 +6369,34 @@ int ext4_ext_clear_bb(struct inode *inode)
 		map.m_len = end - cur;
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret < 0)
-			break;
+			goto out;
 		if (ret > 0) {
 			path = ext4_find_extent(inode, map.m_lblk, path, 0);
-			if (!IS_ERR(path)) {
-				for (j = 0; j < path->p_depth; j++) {
-					ext4_mb_mark_bb(inode->i_sb,
-							path[j].p_block, 1, false);
-					ext4_fc_record_regions(inode->i_sb, inode->i_ino,
-							0, path[j].p_block, 1, 1);
-				}
-			} else {
-				path = NULL;
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				goto out;
+			}
+			for (j = 0; j < path->p_depth; j++) {
+				ext4_mb_mark_bb(inode->i_sb,
+						path[j].p_block, 1, false);
+				ret = ext4_fc_record_regions(inode->i_sb,
+							     inode->i_ino, 0,
+							     path[j].p_block, 1, 1);
+				if (ret)
+					goto out;
 			}
 			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, false);
-			ext4_fc_record_regions(inode->i_sb, inode->i_ino,
-					map.m_lblk, map.m_pblk, map.m_len, 1);
+			ret = ext4_fc_record_regions(inode->i_sb, inode->i_ino,
+						     map.m_lblk, map.m_pblk, map.m_len, 1);
+			if (ret)
+				goto out;
 		}
 		cur = cur + map.m_len;
 	}
 
 out:
 	ext4_free_ext_path(path);
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8110b01e36c1..8c24e882aee8 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1941,8 +1941,11 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (!IS_ERR(inode)) {
-		ext4_ext_clear_bb(inode);
+		ret = ext4_ext_clear_bb(inode);
 		iput(inode);
+		inode = NULL;
+		if (ret)
+			goto out;
 	}
 	inode = NULL;

-- 
2.34.1
 

