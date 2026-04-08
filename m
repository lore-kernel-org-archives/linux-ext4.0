Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057E421CC5A;
	Wed,  8 Apr 2026 11:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647374; cv=pass; b=Vbkl19s62xZZqNat3cB2TysODPCubpc7QWGewfKG0bPDADtbc7efvh1SbfFUSsJHjKyQm5xx60OtkBUyGSl32nGzv3nLp09yK93K7kkRXbNFg6SjEpx8gcAPeq0dydXKa4R1D7wS1EVIQPWmrwi5QmmaWiFg81rHVuqL3c7+kmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647374; c=relaxed/simple;
	bh=cdViAXIRvRTwHbSVIuQGHJ3iK3mlSgOi21LRzhT8Frg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d92wjhdtl5doaNR2STt0Rvepp2LRlr0KvnhMYxlluLaKepOdibrnAYnGRZI219vdZiS8AO1Z2u218g5rS6TrtYgrM9voSKio65z6vqaok8hqdu5LZ7R9nvK3pkfMytX0M0iub++XJFYG+Ktnb642CcBdRlgTwDPOQnUDC45qC8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=SK1ZOL6r; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="SK1ZOL6r"
ARC-Seal: i=1; a=rsa-sha256; t=1775647272; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Qgs5to2Kqp9eovFAXHseUT7kLJu8eswOwNdQn0bth37CTiuMzaeCsZoDnJQV5WnZS4ApHru9tZnb08y8dCs/Ax/NnE59HiMjLgBLu8mhithQZ9hHhr8POhXkClgD3IYS2v56HtvzL5auy9MwepNDffSoqVUnFSdH/nGpFlitkwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775647272; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HKCxdts6cIZPLinOc8np4ie5tl7nN4i8vAqvBYDOhyQ=; 
	b=LyiebhBLs8LiL6nfWpLpLRj2J4btJlgNhYFdYRNCVnxRHSSuWlAbDKzRp7yn/jrTG0glymFMcz8qqlwAVKNGymP0X3X6SDU88dR1xgUkNADcyFuou83bNZlVHLjlNoVdPmNqaPjC83e17j8R61HMyJSa5wNkWLTym4LTTsW9lAs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775647272;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=HKCxdts6cIZPLinOc8np4ie5tl7nN4i8vAqvBYDOhyQ=;
	b=SK1ZOL6rSI3r+68R2f3pZh9l58rYNr8SNLAzUcQH0sozEvYjNh4/i6Bpw3DGghrL
	bjr7fNihC7GeJdETZNr1od+GX/J/Cx4Ea9WciqN8eA8vhiUk/D0okvU73vLIXrQJe0F
	1DXyQRCiSFtLUoclogNhCM062NiIqMt0YrMemS2M=
Received: by mx.zohomail.com with SMTPS id 1775647270387580.785757473374;
	Wed, 8 Apr 2026 04:21:10 -0700 (PDT)
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
Subject: [RFC v6 4/7] ext4: fast commit: avoid self-deadlock in inode snapshotting
Date: Wed,  8 Apr 2026 19:20:15 +0800
Message-ID: <20260408112020.716706-5-me@linux.beauty>
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

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/ext4/fast_commit.c | 47 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 5ed884cc4b5c..f28e732e9be7 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1211,13 +1211,12 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 
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
@@ -1227,12 +1226,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
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
 
@@ -1242,10 +1249,6 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 			break;
 	}
 
-	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
-		if (inodes[nr_inodes])
-			iput(inodes[nr_inodes]);
-	}
 	kvfree(inodes);
 	return ret;
 }
@@ -1313,8 +1316,9 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1566,6 +1570,25 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
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

