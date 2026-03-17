Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B82347523;
	Tue, 17 Mar 2026 08:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773737374; cv=pass; b=cNRogjq3ifPWTaIwMckDH5b+S1yBfQYlhR8oFSkDhPyJiYLEi8IIsPeRQZ0a6osBRATB1XUf4zPQ6CxFm9noRuuXbB4G7gu1kLZOw0v1rZYx8vawslgmGNthACY/nswe301KoGodiKaBjiADVEYycnalLPS3eg53xFf5zmY+VJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773737374; c=relaxed/simple;
	bh=2T1XEP+0MbcGvf5V4jkWy/jAlUceMp6GSTuQIhUYAm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxxXHAxcdZTO55Vf+AySKQgEIv3ccU1h3b5GeWtzHgfccnPRu0rXE6h6BXiLKUDPuS/g5gtJHUUUIyiMcHNv3ckl4bXRtNlTT+Gvq1/SClz1bEhszqo9isszkahvl9XwIg/LXBz9pk4cvxDtv/2dyKvmsBDmcmS2s+f1MgfwdY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=h3slt7MN; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="h3slt7MN"
ARC-Seal: i=1; a=rsa-sha256; t=1773737207; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fryVqFhxzvVeMHpI/nWxveNM4UdB+jJhipE1ePCuTQyHACojZ0DS3oErYr2pOk3hWwzMHlHDlpkSLYcMoLyh+TJHE/rqewN63q61yV7QT/G4iz1qX0X387anNI/fMlLVTpzlE4R88VOqn+DytRKi+A0YvAjoI+lOv5gy9G5mUFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1773737207; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rDK5gClFMcbUS8LdYCJMAjdOkGkFNx9hD8v2sQ0+bsw=; 
	b=MzEBrYqHbnMXc7c9pM320X2sF3OtJ2FENNxzowq//tVclDjVWwtwmB321Gcq6PxL1QrNiO222vtwwIQ/HsHkC6UNo4E7OXHg0poorJ2q9YmTGLHu1XgF8h69GoiC9e0jGOXL5pZFa+tmYDFxD42HxxWgvA+0Tpxa2wbfPVzarIo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773737207;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rDK5gClFMcbUS8LdYCJMAjdOkGkFNx9hD8v2sQ0+bsw=;
	b=h3slt7MNz0BCbeMG3aQcwjhRcN25E2QM/XlfDGlzfDn3M/MDBhvPq6KRNlEV1nSL
	d6nYzBtpdZ2INluGW654jdtEAEdEm22lwoclgMY82ai2cmEQ7/t3Eck2t/sYTXrtrIZ
	+1FHhZW5HPKlR962DvXfTEu6unOhOAh+JIXDhnC4=
Received: by mx.zohomail.com with SMTPS id 17737372049957.253615372300146;
	Tue, 17 Mar 2026 01:46:44 -0700 (PDT)
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
Subject: [RFC v5 2/7] ext4: lockdep: handle i_data_sem subclassing for special inodes
Date: Tue, 17 Mar 2026 16:46:17 +0800
Message-ID: <20260317084624.457185-3-me@linux.beauty>
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
 fs/ext4/ext4.h  | 4 +++-
 fs/ext4/super.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bd30c24d4f948..2e1681057196a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1025,12 +1025,14 @@ do {										\
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
index 79762c3e0dff3..4f5f0c21d436f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1423,6 +1423,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
+#ifdef CONFIG_LOCKDEP
+	lockdep_set_subclass(&ei->i_data_sem, I_DATA_SEM_NORMAL);
+#endif
 	return &ei->vfs_inode;
 }
 
@@ -5863,6 +5866,11 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
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

