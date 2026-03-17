Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822C628A1E6;
	Tue, 17 Mar 2026 08:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773737529; cv=pass; b=Remjwo/i6Q/xqvnQ4xYd+GlZ8TjPxDPrG4zyJbJ9ytY/g7iiCqOKM6ei04y5dvQthO9cmKVypSoJ1hTKPtKlPa2VAsFxeCHy23dsR+mQhiD0IvuvOJ2mq/MH8k1RMCBzM+u9+wY9n8XzfOMcaqbZk25Oo2HRmV7WfItTpu7MHIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773737529; c=relaxed/simple;
	bh=pPVgC7XALicaXqiFRqn5ENOKIdE0tV8l4YECfF86Yio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOHib/PeyZwWS26RV1D95A55jOOdWpQyBZrKutZO6XaeP1t4sJXB8Y83IruWUer53mYRcJh3DB4KJde3iqA5ZlVP2YKG/EJRxYzZT/+4rijZS0JBT3hMBABuZ3TMya0BV7z0gypgdfbZXGMgCG4LJqD3UgDBeDe1SJI/jIojVqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XLcLjTlm; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="XLcLjTlm"
ARC-Seal: i=1; a=rsa-sha256; t=1773737213; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JezJaqyFIfS9G8rZszV2Aak172v0p/+7Plqvi2s7uZAN88kyEY5XBDU+dUIIc7QoDt1cT/CiQ6rofwV5pad8o4ymC7YJnj4M5bhok5uFkmFYs+Kbwn4fWJSDKOP5aKmPe4PkAU2VVcWdsfXDfZ5NI8ZdjDnIDemDwZ3S4uob2Qc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1773737213; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=mdUkB7ZoMlS0Nm7V75WGCv98FsNNiW9rTV9vSFiRbYU=; 
	b=enGpw7Jtb6QPSiNRzfmWkcVU+A8kTZdlumKt9GHZRAboMj+CMMN1vqeyKzA7zHloH7EaLI/WGxFeTrXO8TbF0uPhjp3IQMCt0lkeZG//zGP60R3BanhLIhFvTUbNmYrxjQdjzWkkBqv4CWOCpYHP1jM3XfRBiCVgsNwbYZb+VBI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773737213;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=mdUkB7ZoMlS0Nm7V75WGCv98FsNNiW9rTV9vSFiRbYU=;
	b=XLcLjTlmPs/Ff0n7zhgEoLatOJOoRp7gEWDjdGbz0Oa7y0BNcvZohlR2M5xEzLYp
	SnjId5PIUltYlimLLTtkHj9yMwMZfINXikbEb2+H3Z0cI1IwlnrEDhRqNO+q9Rhy69b
	RnIpUSCJcUAmJ5edV3Y1UEG8hR6AMK2lmGozA0Xo=
Received: by mx.zohomail.com with SMTPS id 1773737211427721.5850976716408;
	Tue, 17 Mar 2026 01:46:51 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [RFC v5 4/7] ext4: fast commit: avoid self-deadlock in inode snapshotting
Date: Tue, 17 Mar 2026 16:46:19 +0800
Message-ID: <20260317084624.457185-5-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317084624.457185-1-me@linux.beauty>
References: <20260317084624.457185-1-me@linux.beauty>
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
index 809170d46167b..966211a3342a0 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1210,13 +1210,12 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 
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
@@ -1226,12 +1225,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
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
 
@@ -1241,10 +1248,6 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 			break;
 	}
 
-	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
-		if (inodes[nr_inodes])
-			iput(inodes[nr_inodes]);
-	}
 	kvfree(inodes);
 	return ret;
 }
@@ -1312,8 +1315,9 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1565,6 +1569,25 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
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

