Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9983D391E49;
	Thu,  4 Jun 2026 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780558619; cv=none; b=f3jBvO/HsmYmMY4bwyllgplSLCyVsnAsAgbRIlzBAYltLq3z2stiUvoxpf9owLcJZwL5rDmhLVpwmYBzZicpGJopH93YBVRB/dxLnbg4ZA6vllLn3e22zTpyoc9x7iKz/xDv+8n2d5GkgSvvQN42KpnnAii/bBwjGgkUq69Eggk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780558619; c=relaxed/simple;
	bh=fIaJSmVjC22uSCZ/bvL3JCp0QGmlxjI9kPCwX7pU/qc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QO/RoBv7CPhG2cGKFJLQw8o6j0ZXimwwnVRmLWE6xj4+wi3ltMqdJXB7ReNASAT4del/+kF66782HkkzqQ5vd+fnGh7g5m4lRowKZhFDCsnyYAPEqebm8lg0vGrCgK/VNqDLKhYtAxzIdwJipGQfub9PEeRKExDX7FQedX12Q6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 271636385fe811f1aa26b74ffac11d73-20260604
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:694b5c62-a43d-41eb-a8b7-f1168845157a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:c2ede84e310fa58621bc8912ff95acf3,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 271636385fe811f1aa26b74ffac11d73-20260604
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 662302851; Thu, 04 Jun 2026 15:36:51 +0800
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
Subject: [PATCH v2] ext4: Fix ERR_PTR(0) in ext4_mkdir()
Date: Thu,  4 Jun 2026 15:36:47 +0800
Message-Id: <20260604073647.211279-1-zenghongling@kylinos.cn>
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

---
Change in v2:
 -Add pre-reivewer
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

