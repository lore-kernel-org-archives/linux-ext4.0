Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794484761;
	b=5CCX+NDwjNQ7j/H2aarBuIgQfYWlBhgZD/jpUfxdu8rz8p6aJz2A538L9p1Rg4sCgC30
	 Ctx6js61vv1+XtPxnDXPNRY0YaTgj/YeWhwNNmIY19b0jC4XGPGBSWLv4SfH8oRmuolPH
	 cYlu2exLN4rj1kgavMnA7QFzhlqfWEHgjUtbqE4+i+FhjH/sz1+G00riT4t8fg2MUEuqi
	 tMjI/B3NDwWpoldx3uwTQA8NfiHfFQUnuewKyW2uNzfvzXIOkZhhEAXiWnBG7NwZwqoj7
	 f1b+q2XqN4vlTzahEmwYG0f0wriykfcGhS8iGQSBPXUon2mMiIzvVqYusb9LPcBEw/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484761;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XGkQWQUPPqTVyUnHum1hbkxRtjJRRu5gjrKtGjsWYE8=;
	b=kvFW2OXOAPwL0WY5q7fI9XpKyC2yDYTFgki8ZznTb2uFD/wjvGSp9xMXxFtICbMCVhkz
	 WsB7pi0AMozngDbaOAwVsJfJkZRTdruuGKv2oKAfc8IMojJgHdGGuPFY00x5PC4bZVuP1
	 RVpIYL3DhurFXHtwiYW+Bk1cbsuujpc2ohGHTAgLO1JCMtJEraEc6TAw0NuWAWHoPjGUi
	 GKNWmmyUCwRhXixHaMI1a9r6Ww9b8Zh6bnBRsuRfXK8WnsuA5ZkpQQhbqEDHppCkTtltF
	 oI8Yj6VwVw12NHAmEjNEGD4c9RjttC6iCm72I9akPyJNnJfdszyxQC6i3jMEjfsqvfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ab3UbyWb;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06940606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 11:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06940606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ab3UbyWb
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b58d6f67a5so2436315b3a.2
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 03:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794484760; x=1795089560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XGkQWQUPPqTVyUnHum1hbkxRtjJRRu5gjrKtGjsWYE8=;
        b=ab3UbyWbcgXwXJW3Ybl0YOl9lqd2Wue1dbPeC3wp4y53+xf9O7K02ZVoQAGGzqwoii
         MaHT+DWpmWyUlWpJq2WkNqXcMPtHC20N3e714izzYuTo27REFUSIJ8/Re2qCw+l80a96
         w2ObMf2FUcY3pwhoNIhZt+7t7cjXzTvb3dYDWADEg0v3gkCBt7ZYkuj5ZbK9Yvl/zbgW
         mMvF/YtecJOCNjuhX913UrYDbPiVrVu82vMxf95y1azHkZmPf68GBnU+W9IK/ojcM2uo
         CSlezRDKwVZVT7eUYnKUX+urB/WhFHkaC0We0K9Nllo84ni57NNNDcLd/b317lkUj0N0
         OjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484760; x=1795089560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XGkQWQUPPqTVyUnHum1hbkxRtjJRRu5gjrKtGjsWYE8=;
        b=lmRmNcS1dJWgZxis7Hm0XvpEp2IzA0088lzZgpb0+Rx55oxDDjwiGrUJgF+oECDjkX
         xJ9qA2F2HZ6fJdLB90eyzYmd9f94Re4WUoIF9CURUSJSQlzmIlpyPPPV4Cf4ImeyJK5g
         RtF4/4Q3NHlAdzLtPnsxMDKOf8QnRuLnk+Ov1vv90VDwAVDZ2KeL89T22hMFgVI2K92e
         kNkTgnftbObyUx3v3UnHomG9zabMFhZ7g17dZKS/tqm5EGFbBt0wFslAqPvNlQniwMLb
         MSN4ca/Uw9aBI0GIMLKSsTtjUjx9GoakjBNeVdYox7O7D+0ZAgTLdEcfFOzO7u7yJG7A
         hNsA==
X-Forwarded-Encrypted: i=1; AL+hErFLMlqxwTlfEA/BT6W5cciCWRiejvzrPurpYgQDHRizomGL30Qw5lgu2g/TJgokZdnbNUdV72LWhTjJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+tlh2b2ch4KVPg/ztiefs3JRkGxbBgh6gx1Wq76P99b348mREv
	3jekJhsCVB8B+2gUkh0yWByyvwdilyEWDHPKEaap7jMXkL0tzGvGNRZT
X-Gm-Gg: AYBFou1uOXoH4JXU12HRaMfWrwtNtThcwH0cnwHiB0gGn4rNKtY+OZn4HAYQbdPKs4c
	urJ8/uw8bWg+f9R0q1n9sTQxCq8UyChjYgT28LXVox2Bq5O3R/d9bhbe5Jm6aG3RmPQQtt+kuUd
	h6rEuYeualRHyt/tQOrefWKigPCdHNjoT3ibr8++FK0R7W7ZMfwZapxcp3TdIhrFo+GJXzzLKvi
	0jQmZm0cmHoQ8AVP2TSWSDDhtXW4RCADhu7CxWVTb6TI7wdLeSAAGBUfvdxPmxXbv2xLcZoyb3M
	2b0MEGKHWKxycBr7jxGXCa067xfxARHJhv4XsiSLRa1jFx56R8y6UUTHfcWf6Lhr75U/ISilXcE
	R0ppVeP6uey8fbjOBHxlLlrnbpXnEs4OiZ9nliaBrm5Xlr5llZiVyODpwuuZV3NELK2fm0tdUkh
	dBc+wkyA83WVqnQmhql/Dw4Paa+J+AzfnjS5VnFEgKoozuXOa6uVvsQFj1b8wYWmXAGIh2PZHKG
	wayosVAGu6ED7q9yUkFZLsjlbM33LEKeY4sO27i+Vh6f70gxA4ngUnrwfk0kT6XOL6OPFpP/XFL
	HEQgPYK1nCQ3gbJfVWjR8QkTFGc132LfEpbkZ9iRwes3xzHKlpf7GcZmNr7o1BWXYgUYB7Thjw=
	=
X-Received: by 2002:a05:6a21:3a87:b0:3e2:6ee4:a758 with SMTP id adf61e73a8af0-3f2fead83demr5830011637.54.1794484760038;
        Thu, 12 Nov 2026 03:59:20 -0800 (PST)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baabad405fsm3234798b3a.57.2026.11.12.03.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 03:59:19 -0800 (PST)
From: diasyzhangqing@gmail.com
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qing Zhang <diasyzhang@tencent.com>,
	syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
Subject: [PATCH] ext4: wait for tail page commit before truncating a failed write
Date: Thu, 12 Nov 2026 19:59:06 +0800
Message-ID: <20261112115906.17915-1-diasyzhangqing@gmail.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qing Zhang <diasyzhang@tencent.com>

In data=journal mode, a failed extending write can leave buffers beyond
i_size attached to the committing transaction. When blocksize < PAGE_SIZE,
invalidating these buffers in the partial tail folio returns -EBUSY,
triggering a warning in ext4_journalled_invalidate_folio() and leaving
invalidation incomplete.

Call ext4_wait_for_tail_page_commit() before truncating the page cache
in ext4_truncate_failed_write(), as is already done when shrinking a file
via ext4_setattr(). The helper releases the folio lock before waiting
for the commit to finish, then retries invalidation.

Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
Closes: https://syzbot.appspot.com/bug?extid=f111db4cb2acd44eb2f4
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
---
#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

 fs/ext4/ext4.h    | 1 +
 fs/ext4/inode.c   | 2 +-
 fs/ext4/truncate.h |  2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f38fec3167fb..505ec38fa508 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3214,6 +3214,7 @@ int ext4_get_fc_inode_loc(struct super_block *sb, unsigned int ino,
 extern int ext4_inode_attach_jinode(struct inode *inode);
 extern int ext4_can_truncate(struct inode *inode);
 extern int ext4_truncate(struct inode *);
+extern void ext4_wait_for_tail_page_commit(struct inode *inode);
 extern int ext4_break_layouts(struct inode *);
 extern int ext4_truncate_page_cache_block_range(struct inode *inode,
 						loff_t start, loff_t end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10cd85d4c721..f59c4a5b7561 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6845,7 +6845,7 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
  * buffers that are attached to a folio straddling i_size and are undergoing
  * commit. In that case we have to wait for commit to finish and try again.
  */
-static void ext4_wait_for_tail_page_commit(struct inode *inode)
+void ext4_wait_for_tail_page_commit(struct inode *inode)
 {
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
index ce84aa2786c7..c10e4ab4242e 100644
--- a/fs/ext4/truncate.h
+++ b/fs/ext4/truncate.h
@@ -17,6 +17,8 @@ static inline void ext4_truncate_failed_write(struct inode *inode)
 	 * We don't need to call ext4_break_layouts() because the blocks we
 	 * are truncating were never visible to userspace.
 	 */
 	filemap_invalidate_lock(mapping);
+	if (ext4_should_journal_data(inode))
+		ext4_wait_for_tail_page_commit(inode);
 	truncate_inode_pages(mapping, inode->i_size);
 	ext4_truncate(inode);
 	filemap_invalidate_unlock(mapping);
-- 
2.43.0

