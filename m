Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B317390C9F;
	Wed, 20 May 2026 07:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779263207; cv=none; b=jyN6Bo7pt8/LAgjnpzDUExeRmU3ydYT52GNZVXQW1x7daj+9mwlFqoAI+B1q98qAvyqgJ93Lci1cNRpsz7o82C8j77DsOixYzRN205IaPiuPN2vOIt70K97+TNveP9cPPHSTv/7oAtsBtb3FFz5Dg6iHqPZVtQV7lZcXuIzVFSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779263207; c=relaxed/simple;
	bh=ScUzg3IrkpK8UH8K4b5y4H4gc9ujvSJ93DPtPX6e5Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TxJaQohS967L/e1LLdkgCeGCb5mGx2cfkOgrTPiqH0P7ZhXYpGrZvCfaOfozGvqLDwZmQdllf6BHZpIH+KDhdSkTP9vHdIE6+UhCXwOGglNSVQDA41qqypkuxnBb3u7SR9Wom54H7aIr+NRhhQ/8f9WfsCjBXQGcoXYNRgZutCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 090d574e542011f1aa26b74ffac11d73-20260520
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8645e478-4481-4964-a9bb-30fc8fac3518,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:16e3021d54140d1b6665a0493407114d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 090d574e542011f1aa26b74ffac11d73-20260520
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1463869907; Wed, 20 May 2026 15:46:39 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	neil@brown.name,
	brauner@kernel.org,
	jlayton@kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH] ext4: Fix ERR_PTR(0) in ext4_mkdir()
Date: Wed, 20 May 2026 15:46:34 +0800
Message-Id: <20260520074634.53656-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
It should return NULL instead for success and ERR_PTR() only with
negative error codes for failure.

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a47fbd8dd30..8cadaeb15b2b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3054,7 +3054,7 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 out_retry:
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 }
 
 /*
-- 
2.25.1

