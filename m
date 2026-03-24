Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053D37E319;
	Tue, 24 Mar 2026 01:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774317562; cv=none; b=jKUiJ9vZ56ZNR0KDYmD1YeV+NDGyJ57WRTaL6u1OuQ6GqlLZG7PamoHP/eK/nWu8VVT3gRkjVNSpADGbqfCS8gYGOpuwsBDUrpf//+ucC1cTSP2EZHSmSz+F3NHCWVBZTm0ci+eaTU0J1gY5/zoBF6B6DWUNtJq7pD4Tg9NdGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774317562; c=relaxed/simple;
	bh=abIFJ8smRTBqrvZnrPhpdohK2tW99nCYiFH2Pizf88I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfLkqgQebwgCq7d6XE/vM8yUFkG3CN8PrvBVaXQtvVVQCPn1Aopp1as2k3O2iv+VUHRGURRu4uZHW903hoO6cnp0zfETZAGhSsUB3q/Mfwb+f7oEvejN1lKLTG4powOE9BkufZeYBq+0EOuYoNftqfJnPSAHaxglt48p+w9AZD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=GILh9+Pb; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="GILh9+Pb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1774317511;
	bh=oCrreMXCnwpdAby3dPZAlqXRykCRYbzSUk7p2Y0wsKg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=GILh9+PbjZHStIDrf9GgW+QwZCCTxW9F5fjs8tlUKOJh6ATS95vYu79kj3h1c+RQW
	 A5on9oXBR9ihAUhIoAVMfSPSrnaioan9Derkyy9u+U+9bpJNNBUID+ZsWJl3QclDBA
	 3yLEklm/7N7yVBphaHSP97gUEfavlZjAazKaxTgY=
X-QQ-mid: zesmtpsz4t1774317502tbbaf9c55
X-QQ-Originating-IP: aDNpvSpBjxKjNoAy0XmL/wtWtxE8Ch9KTjJNxwgGFW0=
Received: from hongao-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Mar 2026 09:58:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17027558838027790740
From: hongao <hongao@uniontech.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: [PATCH v2] ext4: skip split extent recovery on corruption
Date: Tue, 24 Mar 2026 09:58:15 +0800
Message-ID: <EF77870F23FF9C90+20260324015815.35248-1-hongao@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
References: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MKbpLBOB35npTDTzjbRJRvWHJ1P7NPAsHiprx/EgBRFHHqMyPZmi6Pdy
	R7LNwnsTqUUWvFH3BNCV/cvhm+kx8is2S4Vm1uAzvbF4rQGzJ9+ygpz6ViLLXlKppoSUltH
	OjMj4BaGKymHnUHRIphEKI43OuJUugUCx2Wwm6kvJl3Sk7wK40qhlT/zHRX5Rvu5Y8MXpIU
	xhe8XWfKMmz/9EyNqqbeBpV/QjsVj3BnVncK+S8t+EAxrq4GbQ8U6Huz2wyl443Vd00ik31
	EB7e5EHm4w/wW7sLeKWfdc3TGtE5Pv0BMA45PfENUbcPCj1T2sNSPyBaRdF+1Qm+Xs/zrs8
	UB5fsVUul1M/L4yJEzS+ZoZHUJGq3fqwh8u3N0SnZSET9yaQc3Gef46s0D/sWD20tq+2TxB
	+xGxX65DjdNxG7PVYeyxKhx2E3J9R3LB8ehKmkTk/teWsB6uqF4i37atjAsDouag2Bn7+x4
	03sakdyVF9JdB3IJRg//udcxZR4uCUNn/Gq0QG9Fxfto4xoAdZvTamWD2xGArzGN51lr1uP
	Anw0Bn8f0A2HJYFGOc0c6szyVH5+8gFMC8QT/k7RvyVcSUKCm79mLKLbhsORmCZKx5UlCLg
	rNWxTv7E9baYLlsid1hF5jcAvQK0R4q9WwIx8tqlOQK8Xd1uonHSY/onub1gHIKRXYZ2Eoc
	Acu4L37r+4/bFSR5LzvuFco+gMSixssm0ys3AURQiWvmfIbYJdd0YrmKeUSX3xVxhMM8P5h
	1/hQaO70rUIdXRJyX1k3B2obszmyFA91pGLkvwkFNBVWBDX1npX76lfHxUfLmmK1vRC6BGS
	9ogfL3XvXwBSsjD/2zcdKVRzlhTb1QVyA1DM+YJ9W0JsFqumlEp7LoFYpd9vrKWDIu5OM/i
	FNJWFnXyXNwB0WHSxUe+KrZRGIlYlaRfQd1gF0e178sXK13LJ+7dWlamdqw4cua7vzAe692
	yS67NdZopBPyn7oyIojko7Z20Ph2IMMI30CNdOOWkFm03BnbookXwezJMoiL9gotrSnyESD
	mG5x875FDret/61c7x4AoXsF4PMRcG1KDr++vkw4G0Tbktp+HJ
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

ext4_split_extent_at() retries after ext4_ext_insert_extent() fails by
refinding the original extent and restoring its length. That recovery is
only safe for transient resource failures such as -ENOSPC, -EDQUOT, and
-ENOMEM.

When ext4_ext_insert_extent() fails because the extent tree is already
corrupted, ext4_find_extent() can return a leaf path without p_ext.
ext4_split_extent_at() then dereferences path[depth].p_ext while trying to
fix up the original extent length, causing a NULL pointer dereference while
handling a pre-existing filesystem corruption.

Do not enter the recovery path for corruption errors, and validate p_ext
after refinding the extent before touching it. This keeps the recovery path
limited to cases it can actually repair and turns the syzbot-triggered crash
into a proper corruption report.

Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
Reported-by: syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1ffa5d865557e51cb604
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: hongao <hongao@uniontech.com>
---
v2:
- move the p_ext validation before ext4_ext_get_access()
- add Reviewed-by tags from Jan Kara and Zhang Yi

 fs/ext4/extents.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae3804f36535..10af8dee0f1a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3239,6 +3239,9 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 
 	insert_err = PTR_ERR(path);
 	err = 0;
+	if (insert_err != -ENOSPC && insert_err != -EDQUOT &&
+	    insert_err != -ENOMEM)
+		goto out_path;
 
 	/*
 	 * Get a new path to try to zeroout or fix the extent length.
@@ -3255,13 +3258,20 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		goto out_path;
 	}
 
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+	if (!ex) {
+		EXT4_ERROR_INODE(inode,
+				 "bad extent address lblock: %lu, depth: %d pblock %lld",
+				 (unsigned long)ee_block, depth, path[depth].p_block);
+		err = -EFSCORRUPTED;
+		goto out;
+	}
+
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
 		goto out;
 
-	depth = ext_depth(inode);
-	ex = path[depth].p_ext;
-
 fix_extent_len:
 	ex->ee_len = orig_ex.ee_len;
 	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
-- 
2.51.0

