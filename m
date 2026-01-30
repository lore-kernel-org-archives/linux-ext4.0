Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE92FDC5C;
	Fri, 30 Jan 2026 03:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769742795; cv=pass; b=he8Py57ifWb74UFBkErerEhQJuCIHoHtIFSvHivN524co+4C7Uiymt6BUwCSBDtxmuhUUjS0wv8vVkK+IBzgtRts4SkpgWMODzr+UiqF7uGZlIn38JLoATw1dFuG6pyv+MacFsydaA3JDbYhpPlamy3o/qDjxR1IHu4+tiw0fv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769742795; c=relaxed/simple;
	bh=QxD1Nds+HsPoX7x9wIkeO67liZxu3AnrDZDrfbwxVEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bc6+06uC9QZmV9EBMg/eBrmS2aPWviDVBlEdnv6owKWrzUoi1AdqRS3b6S5afjnL3quc4AmyQ9XQWHT8XBycTrrv6VLntmRj8oiu2DBsrsFQGeH18JCi3iWKk/2fpQ/3uUioWpRJ50JwXVI84T641ZTJCUPDYKNZc6QLrz6v7tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=AMzP7biO; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="AMzP7biO"
ARC-Seal: i=1; a=rsa-sha256; t=1769742772; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QX2UA8ag+BtgrfbD585+0LU20jilh0D9i+NL7JE54YMv7OvGjAjbMqo5E2CvZci/dKleHn9xoFNdPGfiKLbm020WKSzWSUiDQDDRS8OwZtNABDKQdK6LVqDCbcQXWWQkrZEgWT2R64CXwkPgo9vCULqZ6OTUI+eyyXraB5scP1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769742772; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=duG12rU890kpQKaDc+uvYR6nAiZ5TCD6IvpJCxX6LVo=; 
	b=KhPHamM4xFpzPVYEvQJRsn124t6ztRtiLfWJUduZI3kopbtvXWTi2Anz9kaCtsT5iR3OApSbN/5KSpv+kOhG41a2qx29aEaOsQtVSEdH4NpvgEj2NoCT/DV39lC50GisWbOJ9bKYLj+Ly3IdttQcfofd6mrR8hFsUq5yaHeu/Y8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769742772;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=duG12rU890kpQKaDc+uvYR6nAiZ5TCD6IvpJCxX6LVo=;
	b=AMzP7biOZnCGWWTWiyNW93FjjGxrWOxbYjXcrOFDcPgeDMm8Q/p4bWXYBrA6PRxH
	pmP4DqbCZQ3lCHmz+qUDThWFMVn4+wWfIYL/yn3GV9PRwSuXBNADJIBP2Qajp3q+Ahq
	lPXjjvDfdAuHOjxpJh6Upx/zPXoE6Dg00sXVk7Ds=
Received: by mx.zohomail.com with SMTPS id 1769742769165893.0734785002115;
	Thu, 29 Jan 2026 19:12:49 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] jbd2/ext4/ocfs2: READ_ONCE for lockless jinode reads
Date: Fri, 30 Jan 2026 11:12:29 +0800
Message-ID: <20260130031232.60780-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

This series adds READ_ONCE() for existing lockless reads of
jbd2_inode fields in jbd2 and filesystem callbacks used by ext4 and ocfs2.

This is based on Jan's suggestion in the review of the ext4 jinode
publication race fix. [1]

[1]: https://lore.kernel.org/all/4jxwogttddiaoqbstlgou5ox6zs27ngjjz5ukrxafm2z5ijxod@so4eqnykiegj/

Thanks,
Li

Li Chen (3):
  jbd2: use READ_ONCE for lockless jinode reads
  ext4: use READ_ONCE for lockless jinode reads
  ocfs2: use READ_ONCE for lockless jinode reads

 fs/ext4/inode.c       |  6 ++++--
 fs/ext4/super.c       | 13 ++++++++-----
 fs/jbd2/commit.c      | 39 ++++++++++++++++++++++++++++++++-------
 fs/jbd2/transaction.c |  2 +-
 fs/ocfs2/journal.c    |  7 +++++--
 5 files changed, 50 insertions(+), 17 deletions(-)

-- 
2.52.0
