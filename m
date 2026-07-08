Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2443ACF0B;
	Wed,  8 Jul 2026 05:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488340; cv=none; b=O4WpVsiEwMysVap8E+xijj8FWIoDDMBytqerS1TPosfDzwHvgpyQ1BtYwgP8+2hhlVw5gEUDeJK4Saj7w3SMd0wOWNvqaCDpHv4CAAgwAyC55GEhZIDDp7Q50dv1GuUOObDkXVMS0UpT+uqwARWOp1rGS+p1sb0hV3cAqdEfAUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488340; c=relaxed/simple;
	bh=rXR8XAvvpo+mg08LuX2pRgUHy/vbdzQCFeWFga7gwlY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=axqCPn9Hfu4hl5wah6eYHbpCPnic00/g8uMCYx16gPzfchl/1HN9Jbii0xf1fhdB9vfbIlETrQLUhduehjuxveyLv8tm9kcFy+vi6Fkkq3jWe9Rv/6UXdFyGeYhdOqi3ErrJEZoanG0slOBNtDe7dEIUBwy8NXGXkIspbSvM1aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=X6000ENs; arc=none smtp.client-ip=203.205.221.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="X6000ENs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783488329; bh=VhEh3akExY0m4gRFgqfV6CJtZUwnYS2BHigDLqqg5Yg=;
	h=From:To:Cc:Subject:Date;
	b=X6000ENsnp9jdJnykA799CtM/rlOtB195lenk++eNNrzH7jr+MG7XagGwe/dWW4L9
	 XxAISiQw52jdCXytmZrNQSYjo0+/cVKxrRxCQH8gLd2TKnVr6oMKgbh31zDF3wRl1p
	 FD+twz+dAOq1aKdfPrEnqUKlkNgs+8KoGqQ1eBNE=
Received: from ubuntu.. ([123.52.25.101])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 60B194EF; Wed, 08 Jul 2026 13:24:11 +0800
X-QQ-mid: xmsmtpt1783488251t785fqibn
Message-ID: <tencent_B6A92A781E14093CF74314DD20201262EC09@qq.com>
X-QQ-XMAILINFO: MvbG2zern085JB6oqmRoh6w1YQnIyMwsJcG3G4Q7GimdjnyLvn/t1Kc90ucwHR
	 CDjwsBMuz8XVIajKVjJ5Tdtub6m7jNUdK4YzE9ihA1Jf5iXZNmGcTh8bNXE22/RZBo6cPghUZBYW
	 w3uTt6xN+G/3xnEI77STf+trE9AJzyyN8hKD5IUk1zpxJa56ErDkqPffuvrDkjPwJ/JpbBO1HJOm
	 ntVGnsTFvWgMyZuc7XQO9+d3WegWyCs0ZfUyNHN7fgmidOLBSa3SkA/FpJxUG5APZxa5OW2futC+
	 1AEZci+XxiYtRsMq/A70nPt7hRHPx2Yt4lvx6MOG6SApmyqyNWB6wzCgofjhbrRqK/6Hj+vSR39K
	 m7tpAgAv2JyGK+r5SgH06BZHFvWEXVB/iObmpbGHhXqAE/bHuYmvnRKuWsyh6RmAbGPjPnW35pKp
	 dpg/Hc6qXKkMcRXP6h3Rp5x6WIL7KVYeh5UktiHU6Lg5Hsc9MgYOwUgsZRoNwyZvV/PQFfDI0oOM
	 L+B/n3CoimoBjw0W3kck26bhAmUkHLjIfVzc6KT9l1dWbzVKE5C66hS73cXI0JwtVCeI9tRL8wt0
	 vyUBAFya7U3Pe0Kv3OZzOHtZ70YwWTCklbJfDDFY4m+oiVCTrVFz/g2F3swRClKur7OSzPRAVPfM
	 K56rtkP31MiNGc3pF1LfCy19eUX3VaRHU4NK4RtMRPzR7St/OVFjxdNisneydk43vMhfBDTafnE/
	 S2aZnY/EcHuVeBEof1wk8mbN9AlxNcyGtwNQuq3LIg2DUxop6k5qIdHpQGSMxNlLTCIhuehDsDQI
	 vcyAE7THCEi9lFwkIozK9RWMGHYB//rp7vB18rLYKv2UV8rKmojIRmpZg+TJA8Jvvf0oT4Z3ZjfW
	 Tt/ORoebEg5qO8nPdksAhW6Y+H6YlOpXZIFzPNnWzlr7QvT7km0JhbT5TMKRTl14Jq0Gc/WSKUXa
	 iW+yfOMWMuTlmhAEDS1d/3C09DR4xA5Mq2CtEPeYD4gKykeKKaPaxnswOuS9pYWTfuMuzMEEm4IE
	 18jsiVX7mb1kWD0CP4W9H+5PbbHZMtD2CC2kRYR3HgSFjycPK2o4Rf8OrXLIuNt04xPEQ/pCqcuV
	 Ho9aaPt9Kcc/20h2BeIAHy2kc2GkncJ6HvQEEsvnUs3H+ouTg=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] ext4: fix buffer_head leak in ext4_init_orphan_info
Date: Wed,  8 Jul 2026 05:24:08 +0000
X-OQ-MSGID: <20260708052408.920377-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
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
validation fails, the function jumps to out_free. However, out_free
starts releasing buffers from i - 1, so the current buffer_head at
index i is skipped.

This leaks the buffer_head reference obtained by ext4_bread() on the
bad magic and bad checksum error paths.

Fix this by tracking the number of successfully read buffer_heads and
releasing exactly those buffer_heads on the error path.

Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/ext4/orphan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..baa11e079185 100644
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
@@ -635,8 +637,8 @@ int ext4_init_orphan_info(struct super_block *sb)
 	iput(inode);
 	return 0;
 out_free:
-	for (i--; i >= 0; i--)
-		brelse(oi->of_binfo[i].ob_bh);
+	while (loaded-- > 0)
+		brelse(oi->of_binfo[loaded].ob_bh);
 	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
-- 
2.34.1

