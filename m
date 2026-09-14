Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8574D3ACA7F;
	Mon, 14 Sep 2026 07:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370220; cv=none; b=fkrDj1faeK727Mk8A6sP7lB344vMyEMApSQ30nq1hpf6pdyjJ6uIYg8wDRmSr6d5wdVTS0O5Mbp89m2dIy6kLAo7D68W4krSVzzq90wab3Djuj0UFB3+DjLMTi7HvZzVF1TmU5XY/6IFPAFixfsCWCWe3yOnvEIirEkVvCBpbeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370220; c=relaxed/simple;
	bh=eKHB7MfBj0IguylIYjLWeVC5LnMSpSyyrq+zUkTwLX8=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=dsc/b7nAuWJfjUNxcYjzOMdSW5Pr6UsG7tfCJgAcjC3rGEE4XDu8TLLdmxHlnvZr71PTqbk5igjaFjPA6DhNoean/cXYLi86QeWn85SiNzkwcKYr10y6tfLtI/g4+Zn+TV9BJOutM45glM1VPsGZe9jIHKjODOnn3ji1cCLuTkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=NEpiELQO; arc=none smtp.client-ip=203.205.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="NEpiELQO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789370209; bh=GogiiBIuLlE0MdtpCIkJteKnRJY5wkoihOLQDRksfOo=;
	h=From:To:Cc:Subject:Date;
	b=NEpiELQOTfE7LzDrgE5Djklh/ynM+dj1DKXe5vAQxCTTGBLPwzm0v8ZtgzoYnOdqZ
	 KlHCCP+k9hf5bg0FWcq1bWoPoCj0hPYW3Uguso3p5nXISecWHGSEPqEwzUyzrkxEuA
	 n5Ey4133mK5xqtLNnVIXMeDFQi00aDd8RLNq9elg=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 42E3E4BF; Mon, 14 Sep 2026 15:16:46 +0800
X-QQ-mid: xmsmtpt1789370206t69158870
Message-ID: <tencent_46F42EDFC0F504046B160E939DB76255EE08@qq.com>
X-QQ-XMAILINFO: NxKoLLhE22aTIX2g66ENyH70bwnS5uFkkoXVaNjiPVrk9X3vYppTMJKXmRkQkn
	 vfXETtANo5piX7o8B3g5LTtrRAF4+MoWbLm6LHsWVOw8vh0wSciuqtBP/1+BzHL3tAnXUY3KsOdC
	 E25+57V/1hREfr1Y0tHrFLZZ+41FEvQznbMbwHrFkvEvRjXw8BA9ZlxZBez8fCxmNZmXgSUEiXXr
	 ONAkmePisA6rikpLy3hJ5vXIUS2xXonuX9OLsrxk515CnnfrXvFkJdBH8Jqsx2UanoVc+5JiTafm
	 JXU7wYIZRLIxjmRxM/Lmvy0ufULB9gW3xeE5SoRw8AMg95N2DpiHbpMgK/cGmRaGIOtxBPjJ8lJ0
	 1w26qPVFWwoIo43ko9fleGuO++MFrtCmUhp2fPbrK7xWZZ3eiNpag+VIPq4o1HOuowrJ64BuDZcg
	 3qmEpR7xhoMobQA1rphbujJn8tnwgqVXZxZo1bX/nwnJI+Ke/HSNwDgPkKSJKTwP7PwMUfkFifrl
	 VsMqfwzJCEEJhAXZ/eqS1b3/4UCU7mfJIIy5quZTOVTMH5zknkpBkXFGMc+Cs3+ZKvsAW9yebQ9f
	 03IrZK00xDutEubYWYS1VD72URDAyVhRNf9kRDkaVAs3YHgpFu9A+UqGIvukH8vxKhRdO5ynkpee
	 oARddKX6D+JhAfTwB7kpUhL48kq6q/NukXj8NRJHEFcwSDKKJEFZ+IbXNeKpyuXG5LoDaKUiNJOw
	 YfVeufUbh2Heelma9DEA8Z5s1uCVa9Xw4OOIrDVL3vWmpT7/fwI7Wcx5TUD0v6Rq2AEQKovmRRkt
	 KYcXi6udBI44Hihhyhop0LbjS0+NdshrZBW38Gj7dIRXmjgH3eiSf7wtbJ0h9BRoPRIcA9KO35qS
	 FyH7vDp/frm0k8faSj64IDzj92AYQ/E8Md3NPT8Ed+UuyHGYLiB6Wk++j2EET9OHiXzGBzzrHJhX
	 qfuNijVMhMuTKQLpaTqtSppEj+dGRVC0dimtgD98E+63aI6IH1ZiOX4E/joQhiacGYUymtOJo=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
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
Subject: [PATCH] ext4: propagate errors from fast commit i_blocks replay
Date: Mon, 14 Sep 2026 15:16:45 +0800
X-OQ-MSGID: <20260914071645.567625-1-781735889@qq.com>
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
---
 fs/ext4/extents.c     | 4 ++--
 fs/ext4/fast_commit.c | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c3655..d67e30cf44ad 100644
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
@@ -6333,7 +6333,7 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
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

base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
-- 
2.34.1

