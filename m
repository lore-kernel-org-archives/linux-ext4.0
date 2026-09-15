Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EE139792B;
	Tue, 15 Sep 2026 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789468176; cv=none; b=Vbe6AlF9VvrgmUAmty5Aji0Th4NVPt0jxr37yy+Qwkhbn43wMcPM3UmMsTdd7XvnxMtZ1vzBGDmGiAz9IoE8GUv9g2QPHgidGaQJ4JLcrBVdlipYV6MiznXVt1y8AneyUxa+XN80auuNj8geM4f9tm5WqEUsMv9qJBqT6vuH7Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789468176; c=relaxed/simple;
	bh=1RpgCj+ADbWhNGzxmxEcDvDGJqQhnR2IAlDrVo7Jvnw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=nr2GhZADYdv93EYwM0czd9paajC+PUWEtBRBGw199xTN6zjlnM5Jj0aJY6r6rVPMRPkMg9suT2JrN8NZ/VSbwWkfln5pbyMcu+IGh6KiTN+kGIaX67F3fQ5QSq0Y3ydX35QP/fFADDzH8vGp2fW7iCraL6cKmlCCfUXYqWkpiyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=VkQLfQ9P; arc=none smtp.client-ip=43.163.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="VkQLfQ9P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789468165; bh=nUAK22Y2G0ATU+KXVlzCp23EoDjRCW50/SpE6pjhmR0=;
	h=From:To:Cc:Subject:Date;
	b=VkQLfQ9PHHhUjgPthEI6EMpcFbbFTOAyYdcm3wCS4DX5YyNamxk92Z6IQQZaLEXtf
	 Vn6g13LlWc5OJlVVUYFw7oAZJR4BseBSdj6xTCcqoVY2utmoUBfJzS+YTjcx8btDef
	 4sZMCN408Bs9Yod7ZOIrA9OBh70e3USidW5uFLXo=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 756296FE; Tue, 15 Sep 2026 18:29:22 +0800
X-QQ-mid: xmsmtpt1789468162tysjk5fs1
Message-ID: <tencent_B320F7091730E06C02BAB57D87B0CE363107@qq.com>
X-QQ-XMAILINFO: MStTOrhA1CLVOyTk0nv5vP5WRTFbP1bCN9gLuhaJmPexIRBPraR8CzbUryQvZr
	 ED1RmO/sdspVYKkxwr05WXVFEhdb+hQAHN2D7wo4IKDY1XJMcOcvGhBTBpSVSUiTfzALwKFbTice
	 qsg7hRnDyJNrIPahCdwmC/YNVbot8Od2YLXvpYgH0i41X0y97yHuHXswjNq8E+Xpgb2xZbAIV0gN
	 XcunAz/NgtPDoe3YU/KaoT/9VoignVJByT54Yts+/MVG7H4hxYYKGArkf8gr7CXrjc59TZHbVOyc
	 px6vwA7J/vW3MuQjP4eMcFFwoT8H3yLtIXuvK9+St/1joZGisGX5vl8LJdULKZW40kRk6Q4A8UrG
	 HzEPjq43ZB+/zLL+HC+kB9uHf11JLs3NxY7KnwMpaQbv1wCKItORBSiox4hQflaErAkmB55k58aW
	 7dwfRFyWimxFjyxe49Cc4R5ooZt9bhyg9ZYia5iKaC7M2yMMGjIYoafKQAW92JwxwZvOlV404z8J
	 MLCOV3kjBo7ovNOkAiApMTYuf/4jxrG9jMHW7/6vNHUX86iKBbb9xllxJX8HjVkoD1CXLiNcjuPS
	 /JV9FVN1MjkK7ab1+KsqQiiiQP8gujLnhpEG5cGPfrVYW3JrS62/sGFwiX0ygMzqCDOuhtL8wQHG
	 TP7Uf+IqFsWgtP1DbtZTfFjdGD93b7PpCV3KDwQoaEQ7I0wfMDSKTadaoPQ0dtomRi3d5rG2d+st
	 4v4gNgCSgJ0CVAgm7heo9YEiItnFqdiOiLf3/Ypo6w8iten2qWf8JDi++8M1Kfi5zQWRp4BLIWRd
	 6Iznw+SCj2yw4XoNLAqy19Huns8LWG9g1jfOyDwoYWUhguq+5NNawUSBzSKDb2Woe07lgv63Jwt+
	 EHU0IEzhDAXjD6CDZS2GJK/5TCiXYOsVOrpdp/wjuynY509upcX+ZOr+evHcaaVmcMG1yQRH2T+U
	 DUMqhETGH7IIWQpqZhZD+DKuEF1YsoO2S5DelHkQqaEa5Ze0Iq5Z5Z4HWaSwu5RkYvncNJhgGMMX
	 4WUTMKI2cjJz92TtZGzpmZv3QdlUx/gE76AyNJgw==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: lty <781735889@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lty <781735889@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: propagate errors from fast commit bitmap rebuild
Date: Tue, 15 Sep 2026 18:29:22 +0800
X-OQ-MSGID: <20260915102922.1911010-1-781735889@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_fc_set_bitmaps_and_counters() rebuilds block bitmaps for modified
inodes during fast-commit replay. When ext4_map_blocks() fails, the helper
stops scanning but previously returned success. Errors from
ext4_find_extent() were also discarded, so replay continued after an
incomplete bitmap rebuild.

Return errors from the helper and propagate them through both replay call
sites so journal recovery aborts when bitmap reconstruction fails.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org

Testing: With CONFIG_EXT4_DEBUG, QEMU fast-commit replay was run using a
temporary fault injection that forced -EIO in the bitmap rebuild mapping
call. The unmodified kernel reported recovery complete and mounted the
filesystem; the patched kernel reported journal recovery failure and mount
returned EIO. Built fs/ext4/fast_commit.o and a complete x86 bzImage.

Signed-off-by: lty <781735889@qq.com>
---
 fs/ext4/fast_commit.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..274d4b95ed17 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2314,13 +2314,13 @@ ext4_fc_replay_del_range(struct super_block *sb, u8 *val)
 	return ret;
 }
 
-static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
+static int ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 {
 	struct ext4_fc_replay_state *state;
 	struct inode *inode;
 	struct ext4_ext_path *path = NULL;
 	struct ext4_map_blocks map;
-	int i, ret, j;
+	int i, ret = 0, j;
 	ext4_lblk_t cur, end;
 
 	state = &EXT4_SB(sb)->s_fc_replay_state;
@@ -2348,13 +2348,14 @@ static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 
 			if (ret > 0) {
 				path = ext4_find_extent(inode, map.m_lblk, path, 0);
-				if (!IS_ERR(path)) {
-					for (j = 0; j < path->p_depth; j++)
-						ext4_mb_mark_bb(inode->i_sb,
-							path[j].p_block, 1, true);
-				} else {
+				if (IS_ERR(path)) {
+					ret = PTR_ERR(path);
 					path = NULL;
+					break;
 				}
+				for (j = 0; j < path->p_depth; j++)
+					ext4_mb_mark_bb(inode->i_sb,
+							path[j].p_block, 1, true);
 				cur += ret;
 				ext4_mb_mark_bb(inode->i_sb, map.m_pblk,
 							map.m_len, true);
@@ -2363,9 +2364,14 @@ static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 			}
 		}
 		iput(inode);
+		if (ret < 0)
+			goto out;
 	}
 
+	ret = 0;
+out:
 	ext4_free_ext_path(path);
+	return ret;
 }
 
 /*
@@ -2589,8 +2595,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 	}
 	if (!sbi->s_fc_replay_state.fc_replay_num_tags) {
 		ext4_debug("Replay stops\n");
-		ext4_fc_set_bitmaps_and_counters(sb);
-		return 0;
+		return ext4_fc_set_bitmaps_and_counters(sb);
 	}
 
 #ifdef CONFIG_EXT4_DEBUG
@@ -2609,8 +2614,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 		val = cur + EXT4_FC_TAG_BASE_LEN;
 
 		if (state->fc_replay_num_tags == 0) {
-			ret = JBD2_FC_REPLAY_STOP;
-			ext4_fc_set_bitmaps_and_counters(sb);
+			ret = ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
 
-- 
2.34.1

