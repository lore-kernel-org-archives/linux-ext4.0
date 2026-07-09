Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36E21E098;
	Thu,  9 Jul 2026 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783608128; cv=none; b=s4cVRFgPYdvQFi218pE+ci1mNC4ujYZnTuyJHHX7TAGmQZEFytAzlXu704UfVxmT3XVIhne1wYHZkk5NavTxuj+lsmu/hpEN741rqWg+1svElfqMdsugZ/Iu4sDVbq+lQC1ueZWmC8agVbSWU/q/7LuFVFhO3AneFqCE1boVyU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783608128; c=relaxed/simple;
	bh=5ottCpNDE1WmqbJevyWvrX4ev7Blag38xS8h4rofc4I=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=naGURp1p1mMMpRjbyySPP6llYEruNq5+GxwZnVoDhsPVVJCFKWGXrKqPSLJJ9AbP494uwzOe9HzLHaq1ycV6gi+W/lCPgGDjG8jQ20V30ABoyEawSlMmTkxZEoANwLBRol6b5CItiJuTAxBjDc7jpVYAFUHwALpgmuAYaUlMJrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=zfuRROv4; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="zfuRROv4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783608114; bh=qJfTiMAAPHiz4ejXAjMxJoec/42G8cxNQn5dvFkF8RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfuRROv4fNaaFPiFgESnDsba5AeUCSr+I8bdmCmR6zmaOSQ7reC2tuz8GoF9/qBs4
	 1EJlXoT92ij6vsAbBvzemRWZtHOeeJ7NoY2ThAeDS9Jux1RKDAqpGHHUBi6OaiQ5re
	 QhVwYg7vej+0LHQcz3vmKb3Tat/3LJcUPvSuUdeg=
Received: from ubuntu.. ([218.196.207.7])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id A733B0A3; Thu, 09 Jul 2026 22:41:51 +0800
X-QQ-mid: xmsmtpt1783608111tq9mveypv
Message-ID: <tencent_B38798612A159E21450ECF959016371B0807@qq.com>
X-QQ-XMAILINFO: OK7NBzdNss/RstsQSmPAqdubzjnsAHrdftMO6m7yDHtn4uvtysDFUfuiFIZ5qL
	 /AGzjKln5dHm6GwCCfzw0oG4qidmW3+j8Uu3KCduGQbv94ou8H7ZTguhSkFf79Xp92rqAR3i+ji0
	 POl/qXEkcD6VseaueSviPvJ603MXE5Yzw8uHzsRL+39X/Yp5bKovjqcIAOvsuQ58en5lKZLaPEM6
	 GNti6m0zLElWCv+qRk/M8hs1wBN97EZJmgtmaWVLXST78hv8asQVmHHOc6XLosojP+XN6J9tqHUE
	 ieGfcDTiZ458sNeZuFcxyIYZI/mJqfNhRBjYgLMw+DzCVzA7LAKEb5FEOuNLfCZVaoPH7Tfa2Nbt
	 /REaTxCNNit5gnTiJeU3pP7FZGe5MZBYly7MddBMVTnMJFi/C9FJadncNu2jOgt2YTJYj5WJHWGD
	 rVDTjWuPr/2+vFRAEWTvVtWGZSzShellrJiWRTUazFTzkv3VW+zkrSF72Iu6LA+/j91jWnyl7Uvd
	 4LCsDzEasqKL3PF98hH2CJYfXdaj2uqSBJyPGq5vcyb2P1+52EtrY3DoB5Vg7B1NKVxN0oyUnA4/
	 NcpxXHS0x782nLj6RmBSI7s99FNx4mBisfvxmoiIGnWiABmXTkQ5ssQrrFF9/rK8JeM+GrQlaOQJ
	 cBlDsJ/X33Q8lJGlLVpdXo4bS5EvEHGEg6TCok/B7Q7J5wUGwKh/Tu5fZzjoOcS6HrRJGZW1+s/T
	 GHcsjGy+F/wGY2wzJMe54GDWsQB4lLmRJYvi5Iv31XeNVy4iCNLv6cNRmyraubA0+jR4SN8/s5eM
	 sHdTrCtXzIr2PkAwJCJSQmBxIvo+wSf+BMj1+/ii4GW7bFA6YU2JScBBx/OWT7Yfn3Q5pMYlpxEm
	 9xOo3WbzE5/4u6juZyAk7a8oglHmHHzMkGkyieh2eG1oEkTBwRMlxQflEoes1UZkFgOqX/0Rc638
	 fYjtYJlj3IN4dcw0tsfgMWnp7uV62JOp5q70hd28M6haRQ6dG9Z2xYwnZreZT+OpCWGTrK+VhCZ3
	 UDr7Ydy92cCztVsat2hfJxguu+T6KZOHDENCJuEs3Ilfb5YcuH63Bl/Jvv906khlGsGhw6rQ==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v2] ext4: fix buffer_head leak in ext4_init_orphan_info
Date: Thu,  9 Jul 2026 14:41:51 +0000
X-OQ-MSGID: <20260709144151.1050695-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <wxzgqewgav3zhaoxbv6eyztoebyvrusaiajyu6rq4yoyitzowd@jzruszx6eetq>
References: <wxzgqewgav3zhaoxbv6eyztoebyvrusaiajyu6rq4yoyitzowd@jzruszx6eetq>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_init_orphan_info() reads orphan file blocks with ext4_bread()
and stores the returned buffer_head in oi->of_binfo[i].ob_bh.

If ext4_bread() succeeds but the orphan block magic or checksum
validation fails, the function jumps to out_free. However, the old
out_free loop starts releasing buffers from i - 1, so the current
buffer_head at index i is skipped.

This leaks the buffer_head reference obtained by ext4_bread() on the
bad magic and bad checksum error paths.

Fix this by tracking the number of successfully read buffer_heads and
releasing exactly those buffer_heads on the error path.

Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/ext4/orphan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..7095ba1564f6 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -572,6 +572,7 @@ int ext4_init_orphan_info(struct super_block *sb)
 	int i, j;
 	int ret;
 	int free;
+	int loaded = 0;
 	__le32 *bdata;
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 	struct ext4_orphan_block_tail *ot;
@@ -613,6 +614,7 @@ int ext4_init_orphan_info(struct super_block *sb)
 			ret = -EIO;
 			goto out_free;
 		}
+		loaded++;
 		ot = ext4_orphan_block_tail(sb, oi->of_binfo[i].ob_bh);
 		if (le32_to_cpu(ot->ob_magic) != EXT4_ORPHAN_BLOCK_MAGIC) {
 			ext4_error(sb, "orphan file block %d: bad magic", i);
@@ -635,8 +637,10 @@ int ext4_init_orphan_info(struct super_block *sb)
 	iput(inode);
 	return 0;
 out_free:
-	for (i--; i >= 0; i--)
-		brelse(oi->of_binfo[i].ob_bh);
+	while (loaded > 0) {
+		loaded--;
+		brelse(oi->of_binfo[loaded].ob_bh);
+	}
 	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
-- 
2.34.1

