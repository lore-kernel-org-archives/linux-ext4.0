Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC63C0A07;
	Tue, 26 May 2026 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779822498; cv=none; b=WP5VKTUDt88JmEJB1aerR6J4kqhCx6n9RzyIHch/b0tH7ZFf/g7c0Kd9MirNz10yBmlp2nCgTWYtiJe/HuqIpgw0G6EUD+UTKsYgT2VhqhneAzIzqUQUvOFhcgitI9zDby390Reu2rBXJpDg2R07zYYPg6z9nDlQJJgCVehp/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779822498; c=relaxed/simple;
	bh=M6Ofl9vZNd1cx1rqoYm7t5yej1LTPkeXkivnwSMX3Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=niiFEm/OETcilQjuANkTZhM4ifTRSm7zoHdN5ubCsfpQJ0qaxe2/BWPvYPsmAoGsG3LKKYFaL/uH5IJ+QJzzT36lRkmlU85+0Y0Yt4XrasqJEQiQwhDSb7nTGWW74L7lHK5An4/mkUOnBSyCUSNf3tA1PcZOGOWdMru4OQWHXOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N12vOpud; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N12vOpud"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=y3mH8yhkeAiAt8bn3OeBz3jpXxeq+T//9cHyy40Hsos=; b=N12vOpudRXNe6N9AihnErt9utV
	miij0GDNd319CanSbtdQZITEZaIuhTxBPMDQB9Mn9vt5KVWWlQ9sJcxQzKQzj+MTgy6rOhhWTGI8c
	CD4vJRn1BiDX3IoiUprFsUq+uwEx9Sr387GUcKux436BsorKnw1xrcLwdYOvFhTfp/t0lnBFz+Sc+
	gNruG0V4Z3nyyYCGBXTAehZZSC7iaty9OdHuTkiT7LOhnl2Rz59eSQ4xpPEjosVxkPR0q/SEp1R7G
	WvyM5S9iEr1cIS7uNu8P7/8jNsI//Tk2Opx4hhQXdOHYF3zooq0vQHiyK/VRmz34lPPzQhrs0SQoF
	9rl+ZtRA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRx8I-00000001Qt8-3jQu;
	Tue, 26 May 2026 19:08:06 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: Remove mention of PageWriteback
Date: Tue, 26 May 2026 20:08:02 +0100
Message-ID: <20260526190805.341676-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update a comment to refer to the concept of writeback instead of the
(now obsolete) detail of how it's implemented.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/page-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dc82e7b57e75..bc674aa4a656 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -168,7 +168,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
  * written. On IO failure, check if journal abort is needed. Note that
  * we are protected from truncate touching same part of extent tree by the
  * fact that truncate code waits for all DIO to finish (thus exclusion from
- * direct IO is achieved) and also waits for PageWriteback bits. Thus we
+ * direct IO is achieved) and also waits for writeback to complete. Thus we
  * cannot get to ext4_ext_truncate() before all IOs overlapping that range are
  * completed (happens from ext4_free_ioend()).
  */
-- 
2.47.3

