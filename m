Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7628E2EFD86;
	Thu, 19 Feb 2026 11:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771501663; cv=pass; b=Lglz7VHOBJ9HQMn70m8oujdhjAjxm3ReyIpIXRpS/Nv9WyXFTIXXXBiNDvrM4UXUOUAR0MQCMmliP9HgmC0hhJCPssxY9V2LUf+yovxSRoUgzI0A23TY0BPY2hXxj+1f+ValCqg76yMwQ46TanVi+utXX2DC8b/GaefzASy7wmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771501663; c=relaxed/simple;
	bh=LY7suJAysGTntkxgUtbRaJMuffDJfTOv0iUwfPbOn+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QvKYjIQKJeWnK113YTSY7/VwHglvqkRb5M1z8d/fIyyTeXSrNW2+YslNbAhcKbu4HXYxSyMBW+/rwjIAzT2JBXctqMRmex/1xCSVrFCrKQW0htX4sf8MzgzWghJfo+trQ/rHoUyXgYKsLZCYd7R93WCL7391BlduwOkDqSaSdOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ggG1Tq4C; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ggG1Tq4C"
ARC-Seal: i=1; a=rsa-sha256; t=1771501623; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Pc/iD7skyiRo03M19Ku5zL/oAHeYr+Xn0FXj4PFiElhL/YpuI3JbqU3rMajSa+ZR+XqQ8BXPFHU8Raq10bP5enTZKXmvVHVTS1SjGOlgDXT/S4r+xWhW2ulEzYEkBV0IYvkLIqYxvw+QxxsLRvoSkajmIwNMgbTRiTE/56EW2Pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1771501623; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=BrTDphID1FazTUyK9mU2nbhmtXa8HS/YY+v6FPHpCxk=; 
	b=cCYNQcf4Vfxz0k2YPvkR583NjLXo0muoW7HLsaj18C5tiRcWkQJmtDvg7XA5S5KVVLfG+tHE/2DVoqVuIG3sIEL56aVny2ze7d0NK4ci2uFFh+fZAUDcYfO/joCWE970ahQ1X4Y++7b57/PbRwWTuMdR/x090Zs8Bc5SFsDMpKQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771501623;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=BrTDphID1FazTUyK9mU2nbhmtXa8HS/YY+v6FPHpCxk=;
	b=ggG1Tq4Cx7v7ouHiuzta89uOdcLqzyQYNZ+ICm8tfQJbkb12/9MYpz6mMVraQr1Q
	+ZvuXGiHFck8PbOKjYH+iK+1NVN0t1gyWa4sZrU4o75vBnJjtyZwTbZMdm5i3rHyipz
	CpVL8uAGSZL8iyI+7I6qsTsbuLR0eXUgg7vNyDec=
Received: by mx.zohomail.com with SMTPS id 1771501620323406.1365783165696;
	Thu, 19 Feb 2026 03:47:00 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] jbd2/ext4/ocfs2: lockless jinode dirty range
Date: Thu, 19 Feb 2026 19:46:41 +0800
Message-ID: <20260219114645.778338-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

This series makes the jbd2_inode dirty range tracking safe for lockless
reads in jbd2 and filesystem callbacks used by ext4 and ocfs2.

Some paths access jinode fields without holding journal->j_list_lock
(e.g. fast commit helpers and ordered truncate helpers). v1 used READ_ONCE()
on i_dirty_start/end, but Matthew pointed out that loff_t can be torn on
32-bit platforms, and Jan suggested storing the dirty range in PAGE_SIZE
units as pgoff_t.

With this series, jbd2 stores i_dirty_start/end as pgoff_t and uses
READ_ONCE()/WRITE_ONCE() for lockless access. ext4 and ocfs2 convert the
page-based dirty range back to byte offsets for writeback.

This is based on Jan's suggestion in the review of the ext4 jinode
publication race fix. [1]

Changes since v1:
- Store i_dirty_start/end in PAGE_SIZE units (pgoff_t) to avoid torn loads on
  32-bit (pointed out by Matthew, suggested by Jan).
- Use WRITE_ONCE() for i_dirty_* / i_flags updates in jbd2 (per Jan).
- Drop pointless READ_ONCE() on i_vfs_inode in jbd2_wait_inode_data (per Jan).
- Convert ext4/ocfs2 callbacks to translate page range to byte offsets.

[1]: https://lore.kernel.org/all/4jxwogttddiaoqbstlgou5ox6zs27ngjjz5ukrxafm2z5ijxod@so4eqnykiegj/

v1: https://lore.kernel.org/all/20260130031232.60780-1-me@linux.beauty/

Li Chen (3):
  jbd2: store jinode dirty range in PAGE_SIZE units
  ext4: use READ_ONCE for lockless jinode reads
  ocfs2: use READ_ONCE for lockless jinode reads

 fs/ext4/inode.c       | 12 ++++++--
 fs/ext4/super.c       | 19 +++++++++----
 fs/jbd2/commit.c      | 65 ++++++++++++++++++++++++++++++++++---------
 fs/jbd2/journal.c     |  3 +-
 fs/jbd2/transaction.c | 20 ++++++++-----
 fs/ocfs2/journal.c    | 13 +++++++--
 include/linux/jbd2.h  | 17 +++++++----
 7 files changed, 113 insertions(+), 36 deletions(-)

-- 
2.52.0
