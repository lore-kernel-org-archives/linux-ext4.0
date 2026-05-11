Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C213A257A;
	Mon, 11 May 2026 08:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489104; cv=pass; b=GUjnEQqTJ4QojQ4DAPptGMyOrmc4AfwHjXQeKdfE9yX8blxIwu1kPoSdyL6StzG7/Wdup03JsrkRZlRWHBvjQbIWZzB1i31s75wRUhTLmgY1Zb2ge7KVrZqAZpBoVOrK687K0GKEM/Mz5TGM+roeQmxFnjH9Ule/XZBZl+T6V80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489104; c=relaxed/simple;
	bh=ChWYJXEq+lFSmys907g8j0n4wRymG24Yq7Xh+QFIbEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxLe/w6WAE/GTd1reXD5cbKcyDyzcb/mlt/Hs9fONGkTnZrHGv+BQEHBqQTM4+F/pMZaBTOQeE8Suo71x9zCWoEbozQ+hcfCQbbLPzJ7sIGhH8MH8Vm6st2e9Pi9jEcUjE8v60CEZnXVQOg37bnmX0ifiOuHU1j0G1RUCIoCHNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=X4l7GTFS; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="X4l7GTFS"
ARC-Seal: i=1; a=rsa-sha256; t=1778489023; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XBwMwB2/y9MdGOhfbArGkyaXszYIkCqlN9v/0F4PyrPi/z3jzSsKI1FoR1W/X3X3qMrmHLinQ5vEyRPrxH9kniL0DvoGd9z3cSO9FY3Ekwb0sbXAcnPRVqQt7PiecglsuR3M22TurXtJ5g51Uz+6HUvxtRv7gxoxJbTcTPwQLZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778489023; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=PbH7XFK/c7E9Ejy2BVWdbwpFXmuC5Rq+dtQ0ZQ6Xx18=; 
	b=hB1mEcT/7FHNv4iqYZXkFrmbYfJxwvLdbLrzShxSv9Xio366qFSPsfj4q7MKcQvMjwIPUvCyl+lOnG+BZG9NOOwKY0wEGLCXf8wEM6Lj0NmDBiJI/bW7FgOg5VbOYu4gq93DZhqTqTc8ZdjUc2t3DCbc4/xHjqsHsFeA08mXxR4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778489022;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=PbH7XFK/c7E9Ejy2BVWdbwpFXmuC5Rq+dtQ0ZQ6Xx18=;
	b=X4l7GTFSu9paPCzyEbm22I6++OFzB3/ef0hADouOGl5eQdPWIIpHZEUng1pM5ExS
	AWaGqHe8UrDHyrG84TFyj2JlfHk4Xq9DKbwl0Vl4UhM8viDjNLwlU8aNP0DJ5ktHnNE
	eoOpLTY/nWBLx2ldg+TdF0xM54UagXxyvXqItcY8=
Received: by mx.zohomail.com with SMTPS id 1778489019274642.7961050691373;
	Mon, 11 May 2026 01:43:39 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC v7 2/7] ext4: lockdep: handle i_data_sem subclassing for special inodes
Date: Mon, 11 May 2026 16:42:57 +0800
Message-ID: <20260511084304.1559557-3-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511084304.1559557-1-me@linux.beauty>
References: <20260511084304.1559557-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Fast commit can hold s_fc_lock while writing journal blocks. Mapping the
journal inode can take its i_data_sem. Normal inode update paths can take a
data inode i_data_sem and then s_fc_lock, which makes lockdep report a
circular dependency.

lockdep treats all i_data_sem instances as one lock class and cannot
distinguish the journal inode i_data_sem from a regular inode i_data_sem.
The journal inode is not tracked by fast commit and no FC waiters ever
depend on it, so this is not a real ABBA deadlock. Assign the journal inode
a dedicated i_data_sem lockdep subclass to avoid the false positive.

Inode cache objects can be recycled, so also reset i_data_sem to
I_DATA_SEM_NORMAL when allocating an ext4 inode. Otherwise a new inode may
inherit an old subclass (journal/quota/ea) and trigger lockdep warnings.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes in v6:
- Rebase onto linux-next master as of 2026-04-08.
- Refresh the patch context around upstream ext4_alloc_inode() changes,
  without changing the subclassing logic.

 fs/ext4/ext4.h  | 4 +++-
 fs/ext4/super.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e01d00dbc077..05c8f67625b4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1015,12 +1015,14 @@ do {										\
  *			  than the first
  *  I_DATA_SEM_QUOTA  - Used for quota inodes only
  *  I_DATA_SEM_EA     - Used for ea_inodes only
+ *  I_DATA_SEM_JOURNAL - Used for journal inode only
  */
 enum {
 	I_DATA_SEM_NORMAL = 0,
 	I_DATA_SEM_OTHER,
 	I_DATA_SEM_QUOTA,
-	I_DATA_SEM_EA
+	I_DATA_SEM_EA,
+	I_DATA_SEM_JOURNAL
 };
 
 struct ext4_fc_inode_snap;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..3c869f0001c5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1431,6 +1431,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
 	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+#ifdef CONFIG_LOCKDEP
+	lockdep_set_subclass(&ei->i_data_sem, I_DATA_SEM_NORMAL);
+#endif
 	return &ei->vfs_inode;
 }
 
@@ -5910,6 +5913,11 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
+#ifdef CONFIG_LOCKDEP
+	lockdep_set_subclass(&EXT4_I(journal_inode)->i_data_sem,
+			     I_DATA_SEM_JOURNAL);
+#endif
+
 	ext4_debug("Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
 	return journal_inode;
-- 
2.53.0

