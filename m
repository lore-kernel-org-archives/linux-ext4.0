Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F8C356A24
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 08:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773649244; cv=none; b=p47pUB7Is7nG1LCUm2Ugswy2a1N/LXf8E0MDyCLIuzObcVwCIU4oOqcWgAzTUXBtSsCNVKhnKNsuCwBLd9ZqHy6oKU9sA36+aFDAU0myu0a0kkdXl6MuRE0D1HUID0ajC51tkdqY4DtihYzwPJ9PzNtevTN7+hZ1Me1QGn2Sq2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773649244; c=relaxed/simple;
	bh=oeVzCri6wpeDD6cg8BuScxKUpYVfZuAUzvu3p3QJ8xI=;
	h=From:To:Cc:Subject:Date:Message-Id; b=mizQgK7guWu3IIUAU/whjESIxxti9HIUR5VNBcvK3Ad96re6KDf0XjXQfPGofaEPVf2NJKPOSQqIsoABNLeeqx8gfT2DzR8exLNhLm172B9ILziRtwcwzHGwb7ZyPIRf7JvaA+zgMA2Nf0CalDyrU+JiuGl/TPht1I66zdxpo0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BkTZDjqO; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BkTZDjqO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773649231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc; bh=xQLmof+oFaB/69SzWnte3YNOj3E5zBMIyI7uGACdvnM=;
	b=BkTZDjqOld3UxqavtrcxfuW5Q9q5Clq89l2XrTxGrckJUZsRkg6+ZootacPGW9XZqV9Cv2
	y27ZfF8AB+Wdi1sMjNeOia4A6qALewWGRx+zAA/YgVVdganJMTl5p0tobfY8qU8TUKkoAs
	tR2INgX0D7f5pliFggtKe7tPrzenEvY=
From: Zqiang <qiang.zhang@linux.dev>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qiang.zhang@linux.dev
Subject: [PATCH] ext4: Fix possible NULL pointer dereference in ext4_group_desc_free()
Date: Mon, 16 Mar 2026 16:20:25 +0800
Message-Id: <20260316082025.9574-1-qiang.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

This can happen if the kvmalloc_objs() fails and sbi->s_group_desc pointer
is NULL in the ext4_group_desc_init(), and then the ext4_group_desc_free()
is called, leading to a NULL group_desc pointer dereference.

This commit therefore adds a NULL check for sbi->s_group_desc before
accessing its internal members.

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
---
 fs/ext4/super.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..c4307dc04687 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1256,9 +1256,11 @@ static void ext4_group_desc_free(struct ext4_sb_info *sbi)
 
 	rcu_read_lock();
 	group_desc = rcu_dereference(sbi->s_group_desc);
-	for (i = 0; i < sbi->s_gdb_count; i++)
-		brelse(group_desc[i]);
-	kvfree(group_desc);
+	if (group_desc) {
+		for (i = 0; i < sbi->s_gdb_count; i++)
+			brelse(group_desc[i]);
+		kvfree(group_desc);
+	}
 	rcu_read_unlock();
 }
 
-- 
2.17.1

