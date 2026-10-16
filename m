Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55B348463;
	Fri, 16 Oct 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792160749; cv=none; b=bqlhhz8FFDRa+O5voviJteBOAhrg9Q3I0w3f4Wvw7BwFJ2bs6fRq30w0uuLNc6UX6rWHGYkNINOtpE54/y+dZM/0FyNVQprmYWWNy1pLtNyvYS1XG/MlH1SNJOuwTijMn7Kw553Q/db9dc+CVkDpsyPg1+TOVz9xy2EJSSX9K50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792160749; c=relaxed/simple;
	bh=szQp2x9EWR4vfHWya40UsJqPLgUiJaQohaMUPN7CE70=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gevAL8h0muYPIthp6whsa/3qguFfkZOXRFkryfCQIkg58CVxiVfs0FhJ5eoTSBIAjBaolmlJXq+hoZt5Em3Vv7hW6cz7L9TGyfx7DmzYBiuCe8KGKbMG6v96VxqE7qUh/+/q+uxS+agES5DnTw1KEt6EXMADVaR/i/eXBEEMtSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=o1PG1Tok; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="o1PG1Tok"
Received: from localhost (gyproxy-mailtls1-entmail-virt216.gy.ntes [IPV6:2409:8d28:134:eea:4556:1010:dcf7:51f2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5154882b4;
	Fri, 16 Oct 2026 22:25:29 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Cc: Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH] ext4: fix folio reference leak in mpage_submit_partial_folio()
Date: Fri, 16 Oct 2026 14:25:24 +0000
Message-Id: <20261016142524.655789-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1451a877703a2kunm7f44cf27b33ab
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSB9NVhoeSk9DTEpCSR9CGFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSkhPQR4eGkFPTk5NQUpLSktBHxgdTEFOSh
	1JWVdZFhoPEhUdFFlBWU9LSFVKS0hKTExJVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=o1PG1TokcOtgjx7F5d7gI9zkLQ7ziMKJU7tYA375Zr9QHgA8Oa+bSjlu2QqS8NUULh72CLAC/VXLr1oB+sIK2Zz7hquW4Ywceb8l+F4I5D+8kUGJg7yvZiqflteAC6vB/GMkjTeWGA+DzBB5JkN5RVeCeFW4DmKKk0SfrRI5kHs=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=FaoUrVLY9q63hf1mhaJumY0BtzAnUSDQxIIcoiAq7qg=;
	h=date:mime-version:subject:message-id:from;

mpage_submit_partial_folio() obtains a folio reference with
filemap_get_folio(). If the subsequent position check fails, it
returns -EINVAL without dropping that reference.

Call folio_put() before returning from this error path. Leave the
folio locked so that the caller can invalidate and unlock it through
mpage_release_unused_pages().

Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents mapping loop")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..7afba6298fa2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2412,8 +2412,14 @@ static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
 	 */
 	pos = ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
 	if (WARN_ON_ONCE((folio_pos(folio) == pos) ||
-			 !folio_contains(folio, pos >> PAGE_SHIFT)))
+			 !folio_contains(folio, pos >> PAGE_SHIFT))) {
+		/*
+		 * Leave the folio locked so that the caller can invalidate
+		 * and unlock it through mpage_release_unused_pages().
+		 */
+		folio_put(folio);
 		return -EINVAL;
+	}
 
 	mpage_submit_folio(mpd, folio);
 	/*
-- 
2.34.1

