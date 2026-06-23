Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8502C21E6
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 09:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205554; cv=none; b=ReRtSWtQDJWvtzrR3zGGxAMtzWxjxs2RByZ6Qa9Glv3dndjXmBgoepeBb/1MBJ+OK5oZpaQSWFukn3go0gHN3+qrXdtm648I7/GM3cLJnciWIekKSBG/vCqp6oCwwyL8lIOdv9YMmCpPnsCnUTXO91+w5ofsOW3ChDsKHPaZP0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205554; c=relaxed/simple;
	bh=C2ePjiXBRNuHtWlgtGjxZfYjg23YUH/DnuCn0zkAr9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sFj4PUa7VxFLOBSM2nvIuV7TcJRUfJDyT8AXOnB2EohCXoQ0KAsyWzpKk2v2CwlwWUHrpRe9A3I1iUsp0F6UBbKs6JgVmzCc9ZzIdMOqfYBCRvNTI1pWYEhGFOzjuzRdzqZA/fr9YLGW/+XznIAI0DYnlhnN3ctsBBNtNMxZCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I7ujNkIt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7ujNkIt"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c6d31bfc70so34067905ad.3
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 02:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782205551; x=1782810351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/TONqHesEiZLcKhLuAN7Ro2X9K7Wb3/mcZREbo/K/cc=;
        b=I7ujNkItsMknEehlcR4g+P2WdXmmGuzeMSH0BPPartsm5fX7Ddb3rQpnih7buZ32N9
         9W7SH1MRlivtk7QDpdcSET3gm9OKJdnAsO6oT/lgHJ0tyYtzgzXqwMstO1X98ZGQYFeN
         Yjutsh9bQDa2aSMjubY4ipG4KINDxarSRK1OUn8Hmgnhmo6W5nIN3De6AWTzC7zAYOfM
         PpwoupjVirx0YzTxKDLKvcK9Sf6GjzL0mRA12pI6zgtmfJ/IJXeR6a1nRhbuyYTnTNQq
         DtzFggyRlQ3ihERUlSR3dLwYMoNa82OkyyeE2hqUgjm2gH6QqP3RdxPj9ReiiRTFq1Bt
         WzEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205551; x=1782810351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TONqHesEiZLcKhLuAN7Ro2X9K7Wb3/mcZREbo/K/cc=;
        b=pxiYbRb0wrUAgddmgVAGPHJPIlbTd/PFLrP0v7sQ8EIxaNAiYkhtVUJwaWLylZnQus
         Tx/qZqJ9CSPyIbDT2OkKbMGKWETzOIfLDbozQZTZW9bPQ93KGwSi4Vd1awFKr8WBtQgO
         ghQoIHMyTr+z2vPqGWuNYtB7PCcubWlMH2IU3rqyoHjCpR/012PQiZRQTfDb3xRVWo6e
         w4cL3J85Tuv3DQa+XxPF4QGPOzYF4/1Hywm5WYr5DZo3yzaDAfg1ywvf9+YgJO58Nn62
         Xvx9vh2annUIkJvZv8Q/EOsqEX5FknJ/Swdn6U+VJrc1QRhxeqKiuA5/S0m96Qk9otda
         SBMA==
X-Forwarded-Encrypted: i=1; AHgh+Rrt1p2ZHNKqGninbmZiycac+Mq1Jf5gs1lIuAWBHHNCJf23rq0J0Q489JdDNwXJ6YeKK6pAUdP+yhW4@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqxw2YR6a3fAeTR4Bx3h/MF0MpCyYTFK8etYFeqU05wrzfEzzu
	6jaBcsnUiHjNAVrLfPyC/wLinBITU2y5KY0/3o5s7jafKuvA49PHa2V4
X-Gm-Gg: AfdE7ckXOJ3agpDpsHqhbw5omKsnfsZTAEfsXLvWJ5UwDmxx6VPtlOd6dJoSAS3S8q5
	Pn/yO36tUp3bBzyPlFQWJDbH9yDctOhGoZOOHVCXIXYl0Z6qCjp6A2a5BR3nVFAJU1AfAeuh1uu
	rF+l5xtBiowlPhDYanYh4JOZ8dT+or3ADFDEWLH65KHqw08KnYLNf0YKch05VBDrnKBM+ZsHej0
	Yd/1YYWC48LK+SgBsCa395ixWqZfseckhXih3E7n3ZT4B3jc31tLXozYcG64xcIuAFMqV8mpAWa
	b73qja8WYgT0EdovLEw/HJ7hAQBrOjJyKNdlqYgml6bzpzybI/DWcQEIrJ3WijOlueyRjeJn2kq
	TMb4WzezH+Iou3VtebnlZM8yc2anK5nu16F33SpzsId9myXxZlUm526AQH1lygAHmecHxDURstl
	ofIgdD5fRhDJ3uWBC0UAdoYadSQjHa1XHrffpE4W18v0rV660s8THvhUsoaAoSmFF8nWg7eY3zs
	XWyMIxDk1LCBzqwlVxR0sZxw1V8wo52c3LweC6e/yDiCoaGpEbg29BB+Nezd1SN+Kzj6rSlLJFc
	qOvgZUienrA0+L9Bod0wWOaxyA==
X-Received: by 2002:a17:903:1983:b0:2c1:e426:70f4 with SMTP id d9443c01a7336-2c7c768468fmr21932375ad.23.1782205550732;
        Tue, 23 Jun 2026 02:05:50 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (69.129.240.35.bc.googleusercontent.com. [35.240.129.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af57asm111648685ad.13.2026.06.23.02.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 02:05:50 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: tytso@mit.edu
Cc: jack@suse.cz,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Tue, 23 Jun 2026 09:05:19 +0000
Message-ID: <20260623090519.2239-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
concurrent xattr workloads (using the ea_inode mount/format option).

The deadlock occurs between the running transaction and the eviction
thread:
- Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
  and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
  the corresponding EA inode. Since the EA inode is currently being
  evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
  eviction to complete.
- Task 2 (eviction thread): Currently evicting the same EA inode in
  ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
  blocks waiting for Task 1 to release the reference to the mbcache_entry.

To break this deadlock, perform a non-blocking lookup of the EA inode
using VFS's find_inode_nowait() API. If the EA inode is currently being
evicted (marked with I_FREEING or I_WILL_FREE), simply skip it (treat
as a cache miss) rather than waiting for eviction to complete. If the
returned inode is found to be I_NEW, wait for its initialization to
clear using wait_on_new_inode().

This deadlock was made much easier to hit after commit 0a46ef234756
("ext4: do not create EA inode under buffer lock") which removed
synchronization on the buffer lock.

Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/ext4/xattr.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..8c0082362a9b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1523,6 +1523,20 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 	return ea_inode;
 }
 
+static int ext4_xattr_inode_match(struct inode *inode, u64 ino, void *data)
+{
+	if (inode->i_ino != ino)
+		return 0;
+	spin_lock(&inode->i_lock);
+	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE)) {
+		spin_unlock(&inode->i_lock);
+		return 0;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	return 1;
+}
+
 static struct inode *
 ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 			    size_t value_len, u32 hash)
@@ -1549,10 +1563,12 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	}
 
 	while (ce) {
-		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
-				     EXT4_IGET_EA_INODE);
-		if (IS_ERR(ea_inode))
+		ea_inode = find_inode_nowait(inode->i_sb, ce->e_value,
+					     ext4_xattr_inode_match, NULL);
+		if (!ea_inode)
 			goto next_entry;
+		if (inode_state_read(ea_inode) & I_NEW)
+			wait_on_new_inode(ea_inode);
 		ext4_xattr_inode_set_class(ea_inode);
 		if (i_size_read(ea_inode) == value_len &&
 		    !ext4_xattr_inode_read(ea_inode, ea_data, value_len) &&
-- 
2.47.3

