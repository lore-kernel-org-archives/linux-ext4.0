Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969AC3E6387
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.0
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783583794; cv=none; b=K8UxnzwYluIhaHg+4j///9IQeuhP+GVBRKy27luW5HuCo+KjciQL3IU3KppzTPpcwcuQldETYBU6pEnuHVvpoo8tCpqTwUNsgjXxNCULoxNBtNgTLxepXEPuWsonLpQ8KhjxOwBIQ9Y9sSGPhuVbSpczBFxdEcwsVZmzk++g26M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783583794; c=relaxed/simple;
	bh=CZD6MIlewiB5H4154SDA6D5UkpOqrSmZJtoYwgttREA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KPWuoCJXTjrwBWktKjKcP4w/toF+YBo17n3NKBMSms7Om+GxTIAGJ/QQpdstBi88NEuObusyPi9YPTvd0EPannWcRkpXc73/sses+cBN5cvz/PwwmocidHXPM+fDZTTYdCxLdDLcIQvb+rKHNIMXKPBihRqgHhE/2kn3i9GBMYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HFX6BbZq; arc=none smtp.client-ip=74.125.228.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFX6BbZq"
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c888c19b85dso492679a12.0
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jul 2026 00:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783583792; x=1784188592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q864uR6XEgmXa8OQsth34L+SyfDYyZ9cwD42T62AOO8=;
        b=HFX6BbZqeOJLOttSS/IbNnGo/WXX3NDJZV288uZRZz9xjUoRUT30sFavMkYjzeguJg
         Hs6vWNrajBneByT+4kU2Jbj5Lxj1KtKBq2t1+1xAtrZm/DQGmUOfuvfsrfOfa/CUhJuJ
         yGoiAtw2yo31gx1j2gXC59OMC6bFJOH5Q7otzMPJ20vyMJrMzof5MZKu++oGZ1T9Nu7P
         EVrxkJW6Y1uGWh2HeBPlvGN2DXyhTj3w37bw0PqKZsWUeIev/jEiANGJ6QDdFLKMUKMw
         2CSRcFtT7zFlQw46WK1gH5tyV/JQ0IwahSeocEd29OgOJPPQfF1/8HDr5ClxDlCI9/wu
         +wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783583792; x=1784188592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q864uR6XEgmXa8OQsth34L+SyfDYyZ9cwD42T62AOO8=;
        b=XxfRwvQhSoKUR9Q6Pr9ab2ykTFnr6yXS8fWg6/ZJx7lSmljeLjozTzZj4KB/jcwXRL
         6r2/eniMzjIVbKVyrofDj9SihfRW39Af3cVkILatHFeO07bNDVKSVA0gUfB9VK/XZmYp
         7HBt386jTVQAHPl/pRGbghWXBtNaIfgxd0GlezXFrrE+u1XUU0oQTsqDkPUwfJYFKOyf
         mbZH8E6iTlIHxihkhq/mEYdj3ovA6I1F+UJR6kjri3nEcETKZrB+jw9h5l5qbYNsK7GC
         UL0k7eJJRc9ivB/QJV/bpjUSqF2v8CW3Aj8Z5UsDkKOpL6jdJ/rH2F02yotRi39jWgB6
         rW/g==
X-Forwarded-Encrypted: i=1; AHgh+RqTro0Y7K5pLAZ6DKPfo9gShZHYMeFkQYCiJvQlAKbLrCjUFSKPVD28XuGijhjE5VmRONe3D97cqQ2Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyHcQfwvD8ZCXCC1GVW38asT8AZt2kVWiW3WHOJ8yKyUAvbGwIx
	2gZsbKCjbQS3C1+QvdfSh/YXAI5MYljVmDxoin0N80FEpTsE8ySnuS+7
X-Gm-Gg: AfdE7cnwenQlwanENZ/ZsUtQuvMKOlMtM71pt6wNGL1EFZidP7Kqjsqxs+ttX68pclQ
	NltSYzYvo0nLpOGL8GqQdKWu7ffb80Lf1Bw2B39BR/fz6WlUNdWQ/yi3HH5VJQV8KS1fEzWlqHL
	HrAmBSM+n8qldViXlkVjGk4l83TyzW/B53Ra7rtQ+jcSBXwwX6CLo80tL8rk27VNZcfVqhKY6hL
	HSN1kFIY0l0BKC5L9QaLgFZLjYdkhQH1OBb2UtmpnpcRxmuATaFhs4ThFLuAnYmw2e1MZPjAx2i
	gibynhpDjfz7kBuywyxyO5gu+T3QtIFxvtr04HDDkjZy+riW+3OQp5wS+erQYVW/bZBszN2vD6n
	1CmNPxx+fneDNraaFtNGkZ7AKUiouFbrjeRQAv7GcsvmtJ2FrxnUmIIdnYl85v+d5IYpUIr4BNR
	lzY43yFMg0OThJDP+uc/m/9FeJtwMrqiOZezNPNOF9W+tHDKl/zsZblpC2TD+09PYh
X-Received: by 2002:a05:6a00:410d:b0:845:f107:38c8 with SMTP id d2e1a72fcca58-84842f9f270mr5532806b3a.47.1783583791643;
        Thu, 09 Jul 2026 00:56:31 -0700 (PDT)
Received: from localhost.localdomain ([159.226.94.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84856d5d619sm799176b3a.39.2026.07.09.00.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:56:31 -0700 (PDT)
From: Longxing Li <coregee2000@gmail.com>
To: akpm@linux-foundation.org,
	willy@infradead.org,
	linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Longxing Li <coregee2000@gmail.com>
Subject: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
Date: Thu,  9 Jul 2026 15:56:13 +0800
Message-ID: <20260709075613.854-1-coregee2000@gmail.com>
X-Mailer: git-send-email 2.47.0.windows.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_add_complete_io() queues the inode's i_rsv_conversion_work without
holding an extra reference to the inode. If the inode is unlinked and
evicted before the delayed work runs, the inode slab object gets freed.
When ext4_do_flush_completed_IO() later accesses io_end->inode, it is
accessing a freed/reallocated object -- a use-after-free detected by KASAN.

Take igrab(inode) when first queueing the work (only when list is empty to
avoid duplicate references), and drop the reference in
ext4_do_flush_completed_IO() after processing all io_ends.
A per-inode bit (i_rsv_need_iput) tracks whether the extra reference
was taken.

This is a defense-in-depth fix complementary to the upstream fix
c678bdc99875 ("ext4: fix inode use after free in ext4_end_io_rsv_work()")
which adds consistency checks in ext4_io_end_defer_completion(). Both fixes
address the same root race but from different angles.

Fixes: ce51afb8cc5e ("ext4: abort journal on data writeback failure if in data_err=abort mode")
Reported-by: Longxing Li <coregee2000@gmail.com>
Signed-off-by: Longxing Li <coregee2000@gmail.com>
---
 fs/ext4/ext4.h    |  2 ++
 fs/ext4/page-io.c | 15 +++++++++++++--
 fs/ext4/super.c   |  1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 56112f201cac..239e6c0a3d3c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1179,6 +1179,8 @@ struct ext4_inode_info {
 
 	/* Lock protecting lists below */
 	spinlock_t i_completed_io_lock;
+	/* Track if ext4_add_complete_io() took an extra inode reference. */
+	unsigned short i_rsv_need_iput:1;
 	/*
 	 * Completed IOs that need unwritten extents handling and have
 	 * transaction reserved
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 39abfeec5f36..294c0bcbbb7f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -262,8 +262,12 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	wq = sbi->rsv_conversion_wq;
-	if (list_empty(&ei->i_rsv_conversion_list))
-		queue_work(wq, &ei->i_rsv_conversion_work);
+	if (list_empty(&ei->i_rsv_conversion_list)) {
+		if (igrab(io_end->inode)) {
+			ei->i_rsv_need_iput = 1;
+			queue_work(wq, &ei->i_rsv_conversion_work);
+		}
+	}
 	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }
@@ -291,6 +295,13 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 		if (unlikely(!ret && err))
 			ret = err;
 	}
+
+	/* Release inode reference from ext4_add_complete_io. */
+	if (ei->i_rsv_need_iput) {
+		ei->i_rsv_need_iput = 0;
+		iput(&ei->vfs_inode);
+	}
+
 	return ret;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87205660c5d0..10a5d863d9b9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1418,6 +1418,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
 	spin_lock_init(&ei->i_completed_io_lock);
+	ei->i_rsv_need_iput = 0;
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
-- 
2.34.1

