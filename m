Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7D133DEFC;
	Fri,  6 Mar 2026 09:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772788260; cv=pass; b=XhtxkXxRqGh/j//accifKYvMY1q4xB8fyHx18kA6LwiN3qrrH+i0QATNh/Yp5vYxXc0kpgK4QbyKD5SJGxtA2E12QUIYrZZsWPv5L7feE/7XkZmvySovYXmBT31w0NUgeZX3x63cps8c5gl9h9CIOypf+07YNPBMpLqCdtZYV1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772788260; c=relaxed/simple;
	bh=Vrvj/Hz9mHwDjSo7ZWHDvw9X5Iwnz90mvGTE/luJ03A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDNK3O+ZE7SRTBe1sUSP6eCN4kQ9VJ4m65BFPc69mq0Z/A+Z13fFHr6/6B/anMiGv8HBxuFgo6BxyDhNrGuROrgyLzvC/s9Oco0AbZdMYsJfDDuFyBhwXUNd0l8fBNupmcfUWMewFOscDw0kmKEzLhik1b86G/89oFdrxAAtC5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=a5nhWPXd; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="a5nhWPXd"
ARC-Seal: i=1; a=rsa-sha256; t=1772788231; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KXaHqSGEOMMiemKWltAh0DB/oiTNymrsdlQIEBFiPIHizS3rtSkOVXO6dbEGjq0l5OXQjJsRQiorug7FNMJjRoiIIj2r0P+yPe5BR5xNLJXpvZYY2kGCPL+C0N7SjEw/TbBkmy5LSTqKKR67xfQ1tP9/TFQvd7MJbXE2c0cDsvA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772788231; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pJ0kj7owG62bsgS4T1OkFHO8CXLZzKqBToAuEVC/SoI=; 
	b=IbUVkEuzTaWeo+rAXfi0OMWhNHMUlqaGzmKCqoZcud/vBm5Ro5mU7JOZxzs9vBzrNCMkVKxpwC9pzsoq0Kf61+ePtbGC/TJAsckvB9RnbU7UPCPzU6eElkQov1N1HsGdAXt6sVFX/ud4qqQseQnLg4y7uQg9ZOAorz3xpDBI080=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772788231;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=pJ0kj7owG62bsgS4T1OkFHO8CXLZzKqBToAuEVC/SoI=;
	b=a5nhWPXdYLZoSxZqGekiEACbAYn9h7cHZyWxvwNr4jV6EM4tbetvym8IJRLDwTsp
	38/svZQxRIsxVCUGBzwuVkf3Mc2O7E65WyMFoEcjTkXImUxDGMC2ZKnEuLrwb1qgO5z
	wUbIb0s8ECXZlExle7spWvdyJmMYNlcyEVdGy+Xo=
Received: by mx.zohomail.com with SMTPS id 1772788229551199.97655860003874;
	Fri, 6 Mar 2026 01:10:29 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH v4 3/4] ocfs2: use jbd2 jinode dirty range accessor
Date: Fri,  6 Mar 2026 16:56:41 +0800
Message-ID: <20260306085643.465275-4-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260306085643.465275-1-me@linux.beauty>
References: <20260306085643.465275-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

ocfs2 journal commit callback reads jbd2_inode dirty range fields without
holding journal->j_list_lock.
Use jbd2_jinode_get_dirty_range() to get the range in bytes.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Li Chen <me@linux.beauty>
---
Changes since v3:
- Add Reviewed-by: Jan Kara.

Changes since v2:
- Use jbd2_jinode_get_dirty_range() instead of direct i_dirty_* reads.
- Drop per-caller page->byte conversion (now handled by the accessor).

 fs/ocfs2/journal.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 85239807dec78..68c2f567e6e1b 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -902,8 +902,13 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
 
 static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 {
-	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
-			jinode->i_dirty_start, jinode->i_dirty_end);
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+	loff_t range_start, range_end;
+
+	if (!jbd2_jinode_get_dirty_range(jinode, &range_start, &range_end))
+		return 0;
+
+	return filemap_fdatawrite_range(mapping, range_start, range_end);
 }
 
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
-- 
2.53.0
