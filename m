Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AE2387344;
	Wed,  8 Apr 2026 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647319; cv=pass; b=X6ZWLj2CZE0xhJ5vyTob9zidTruqr9WuSp3d0ygFQo4K+MleGtRA/SeF3qTZNsvT+dnqpE0oTkZld8Fwe2kEUhKyWe7a7ZhULmtiBWdVZCPAK69StsAqeJ6VbDa9rwdkNyEBJOVVoQQI0/PiaMT56U0+caSthElYr85YGG0MU8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647319; c=relaxed/simple;
	bh=AKr5Ne+SOqQ2MaUdKMWOqeKOBdL1X/iPI5Ry+IZPdr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuaJyIyvpkP+QkLPOfCn8wkcgtp6hBIFmLD0k1mRO6Llk2cSF2Kx7ZQw2nGXG/Gfg2y0SFCDxCP0/vpVVcxy8qevQej3YeQDl2/9QZHR4W8i6rE/Ofc+Knkk5oxtmmGI9Ni1xIkro8vOkJ8OrvowQKbvw5ouVaog+eoesv50MeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=qlYwjWHf; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="qlYwjWHf"
ARC-Seal: i=1; a=rsa-sha256; t=1775647260; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mziqE4wg/C9GBLJS71Zn/o6TAWIp7Oj+fInmxOTf9Nt42aapgACmOQZ0EpdrUiHxiv0ByKgGn47a1pWJkk5i/Ray+XYGVP6/1VxAMOhsovltR20nMiZGQNtX6Iz5T24jghw1IFymHRIYbkphmsWDUfY5/w7m4HmbnSoJpg6r2nw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775647260; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YnM0+++sh+xA2p+4r3PPfquGYLX2NEmrLyqDB3uwNlg=; 
	b=lacuzT+xOkwtOAMp9FGn/119Vqx5cNgvERdgMndWiazFWZecpMtzXK2XrrTesQsrk0PhFu8nxvvC1mAVB47ehNQunMw/agmHINeaFx7K9QtgvMzR8XVNfBdonX59ZOP4lTylCzRAGJ71EgoOE+Y72eOrn3BTMnVMk9ofUWxNYM4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775647260;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=YnM0+++sh+xA2p+4r3PPfquGYLX2NEmrLyqDB3uwNlg=;
	b=qlYwjWHfHlB1bX8HEH/Xh/8uTq69KF5S9dcSePfkvrZCpZqe9OBXD3euI0eY+Vrg
	TR47cmoTTcWX6JzebaKeKunJSu5dG67ps2UFZz14IKFeGwbtp+vTPfJzKkuUlfagjUE
	6VouT+k1tHjs/ST9tc5WRlpV4xF6NuV1wEDg42Yw=
Received: by mx.zohomail.com with SMTPS id 1775647257949387.91951926297907;
	Wed, 8 Apr 2026 04:20:57 -0700 (PDT)
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
	linux-trace-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [RFC v6 2/7] ext4: lockdep: handle i_data_sem subclassing for special inodes
Date: Wed,  8 Apr 2026 19:20:13 +0800
Message-ID: <20260408112020.716706-3-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408112020.716706-1-me@linux.beauty>
References: <20260408112020.716706-1-me@linux.beauty>
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

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- Rebase onto linux-next master as of 2026-04-08.
- Refresh the patch context around upstream ext4_alloc_inode() changes,
  without changing the subclassing logic.

 fs/ext4/ext4.h  | 4 +++-
 fs/ext4/super.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 98857292c707..66de888ae411 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1016,12 +1016,14 @@ do {										\
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
index 578508eb4f1a..286f05834900 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1425,6 +1425,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
 	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+#ifdef CONFIG_LOCKDEP
+	lockdep_set_subclass(&ei->i_data_sem, I_DATA_SEM_NORMAL);
+#endif
 	return &ei->vfs_inode;
 }
 
@@ -5904,6 +5907,11 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
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
