Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563BE2DC357;
	Mon, 11 May 2026 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489165; cv=pass; b=BQI+LpGZqApvQD/YCpGQmAfnj6UpwXF5qyQFgqPdszE6E5Eq04C3EcM0MNuY5XVnOKwWCNhdlrBk0THfyLLUFw+rBdfzlP38aOGkihUgxpgDCWjVuYFCwNadReiWvxLOL/T0samhjB9evOeAlVxQXWfnWM0aG20tli8IxUFtWV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489165; c=relaxed/simple;
	bh=3t4RVB/WVQnMJ9CP14QFMTycPdqOlWMmWgsBNjyLuDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC1pHGGEqdEZsW/ta2LjIPgVkswkDKrYSwRLAbhOpAsPHnAV3oq8hj2hVNjI6VqCwv6UX4vbmz6LKPkM3XAvNzkAQY4wVE6FCtQOz9vX01E9ePv77x8BQb8NaxuYkrfVVWPCSWHSwOdKd/GW6ELG364rNXsL59dNbSTFM4ZZihM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=oxJ0H9fg; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="oxJ0H9fg"
ARC-Seal: i=1; a=rsa-sha256; t=1778489033; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Gx7lXXPBO2hCZmi3H31tM4HZetzM9AeCT2cfeO6pGIfh2dxcAJE8VqpERWKjZh4ulU13Ha4PLzN0h59cnv4k430sS2mcaLiGSwFud9fiiMS5/nYn+8rKD9zrXcrd1+PuCY53q6wjd6RY6h0NngzfoxrB+zhZXPzfjTD8Hm+LxVQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778489033; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=cB8mv5pgJ8VYeNK+vanExt3/tJtti6pjz35jqbs2VNY=; 
	b=YHA1iGK27ctICWpw6JIQIlftfhCCC6PO0Yx9NVSJBIXnWJOmO3p6pqudwAhs0OE1YE3F5o/xPwOOwS5L7U5nk4LiLCjkDt0FRWasvG6Cu34oXcRmAIZ5hVnet5m/Kz/25M+oBQmPfkZhIkWAHhyNSx2FrJbTDE9A4D3Qxjf/4vM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778489033;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=cB8mv5pgJ8VYeNK+vanExt3/tJtti6pjz35jqbs2VNY=;
	b=oxJ0H9fgGDTpBKdGB1Nnep8mEOAr8Kor+EKtm9nlEyxZuSqeUlp76QbKmW2hlLf5
	n0/VBb03A1tMP0JM93BQhQ2BDq4Ss5YuhWO2jHHCv3rJjYApuiI1V3oPqwA6ChDuOMO
	TaVpVhtuW1g2W/Y+43QIcXpR9l2MO26SSV882xDg=
Received: by mx.zohomail.com with SMTPS id 177848902915965.24901118520575;
	Mon, 11 May 2026 01:43:49 -0700 (PDT)
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
Subject: [RFC v7 4/7] ext4: fast commit: avoid self-deadlock in inode snapshotting
Date: Mon, 11 May 2026 16:42:59 +0800
Message-ID: <20260511084304.1559557-5-me@linux.beauty>
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

ext4_fc_snapshot_inodes() used igrab()/iput() to pin inodes while building
commit-time snapshots. With ext4_fc_del() waiting for
EXT4_STATE_FC_COMMITTING, iput() can trigger
ext4_clear_inode()->ext4_fc_del() in the commit thread and deadlock waiting
for the fast commit to finish.

Avoid taking extra references. Collect inode pointers under s_fc_lock and
rely on EXT4_STATE_FC_COMMITTING to pin inodes until ext4_fc_cleanup()
clears the bit.

Also set EXT4_STATE_FC_COMMITTING for create-only inodes referenced
from the dentry update queue, and wake up waiters when ext4_fc_cleanup()
clears the bit.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 fs/ext4/fast_commit.c | 47 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 273bf34031ae..f9bb18c0b549 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1195,13 +1195,12 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
-		inodes[i] = igrab(&iter->vfs_inode);
-		if (inodes[i])
-			i++;
+		inodes[i++] = &iter->vfs_inode;
 	}
 
 	list_for_each_entry(fc_dentry, &sbi->s_fc_dentry_q[FC_Q_MAIN], fcd_list) {
 		struct ext4_inode_info *ei;
+		struct inode *inode;
 
 		if (fc_dentry->fcd_op != EXT4_FC_TAG_CREAT)
 			continue;
@@ -1211,12 +1210,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 		/* See the comment in ext4_fc_commit_dentry_updates(). */
 		ei = list_first_entry(&fc_dentry->fcd_dilist,
 				      struct ext4_inode_info, i_fc_dilist);
+		inode = &ei->vfs_inode;
 		if (!list_empty(&ei->i_fc_list))
 			continue;
 
-		inodes[i] = igrab(&ei->vfs_inode);
-		if (inodes[i])
-			i++;
+		/*
+		 * Create-only inodes may only be referenced via fcd_dilist and
+		 * not appear on s_fc_q[MAIN]. They may hit the last iput while
+		 * we are snapshotting, but inode eviction calls ext4_fc_del(),
+		 * which waits for FC_COMMITTING to clear. Mark them FC_COMMITTING
+		 * so the inode stays pinned and the snapshot stays valid until
+		 * ext4_fc_cleanup().
+		 */
+		ext4_set_inode_state(inode, EXT4_STATE_FC_COMMITTING);
+		inodes[i++] = inode;
 	}
 	ext4_fc_unlock(sb, alloc_ctx);
 
@@ -1226,10 +1233,6 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 			break;
 	}
 
-	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
-		if (inodes[nr_inodes])
-			iput(inodes[nr_inodes]);
-	}
 	kvfree(inodes);
 	return ret;
 }
@@ -1297,8 +1300,9 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	jbd2_journal_lock_updates(journal);
 	/*
 	 * The journal is now locked. No more handles can start and all the
-	 * previous handles are now drained. We now mark the inodes on the
-	 * commit queue as being committed.
+	 * previous handles are now drained. Snapshotting happens in this
+	 * window so log writing can consume only stable snapshots without
+	 * doing logical-to-physical mapping.
 	 */
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
@@ -1550,6 +1554,25 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 					      struct ext4_inode_info,
 					      i_fc_dilist);
 			ext4_fc_free_inode_snap(&ei->vfs_inode);
+			spin_lock(&ei->i_fc_lock);
+			ext4_clear_inode_state(&ei->vfs_inode,
+					       EXT4_STATE_FC_REQUEUE);
+			ext4_clear_inode_state(&ei->vfs_inode,
+					       EXT4_STATE_FC_COMMITTING);
+			spin_unlock(&ei->i_fc_lock);
+			/*
+			 * Make sure clearing of EXT4_STATE_FC_COMMITTING is
+			 * visible before we send the wakeup. Pairs with implicit
+			 * barrier in prepare_to_wait() in ext4_fc_del().
+			 */
+			smp_mb();
+#if (BITS_PER_LONG < 64)
+			wake_up_bit(&ei->i_state_flags,
+				    EXT4_STATE_FC_COMMITTING);
+#else
+			wake_up_bit(&ei->i_flags,
+				    EXT4_STATE_FC_COMMITTING);
+#endif
 		}
 		list_del_init(&fc_dentry->fcd_dilist);
 
-- 
2.53.0

