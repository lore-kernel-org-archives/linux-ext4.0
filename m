Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC72D73A0
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 02:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789352436; cv=none; b=SAcZrwURbc1FiVywwH9YOi71a+g1/g6FgocWg6Fmh9ZICWPcAAHaVemiXaD/BQxgaeS1+9dF+/VB8usxjwuTbgSE4alT8fqYFWqW9VKyGsKDgWjd6lwmpYk+slcJhrcVw8l6/j2BosI03a+blWWIN3qEXz1GV+5kGXvXjnWoMvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789352436; c=relaxed/simple;
	bh=0Qd6VNErFQJtimtxfSKBpBARx5y/d9yO2c9nB4hWrUc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=W1IQJDTGlo+nO1ELxJVdSUDFs2orl5qFpBzonnndX8IkVJaq12d2CZ3GRLIKde3L2evZQeoprk8sahz+fNzjJDMEa6RT8VRoZZ7nk8B93sabsSMmG4Uzr0s5sikI2NdMdE3N3wbbvpGyggZZS0wf0XLeOZKaJTvfgWyMjIxPEUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=lqL6gCMc; arc=none smtp.client-ip=203.205.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="lqL6gCMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789352425; bh=GMkEUR6J11OOHq6Ton9+fvb8GegJTNea8KmYv+aC3/g=;
	h=From:To:Cc:Subject:Date;
	b=lqL6gCMcw3herRpWgY5wbmeCBBAeXek6LhZmKpan3kQG4Py5NSWK7xFbxMTvAzY05
	 1Ob/2fzD4g/MJQBVVVaXPGu6VGi1BQ0JXkLxuP769J5ymBgiQv4AAbgSPrIoGqANb3
	 6Rr8Pq/OI9be6UA6U0mf8P6qSJMv2IxfNPYWLQc0=
Received: from DESKTOP-AT5F202.lan ([223.70.84.224])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 5160E6E6; Mon, 14 Sep 2026 10:20:22 +0800
X-QQ-mid: xmsmtpt1789352422tzpo7rurq
Message-ID: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
X-QQ-XMAILINFO: MZhTzTQHiBHmrv/7F2rWhBp1WHVtGwh8jaCSiw8ujqEfr+7Y21KN9/I9do6SbZ
	 cbys8ZMwGZeJe/JDUBPFqMVoADBoNYuOHkOuVNTg+dj0x1ZL+XrPhY265le94SqCjm3JTlkJbLVC
	 vEKaIU59lT9FEh+HBC5QUjdjXYO8GiTahwC/63JKX4yV6bfWKM5OOVJnPL73diFeB0bFx42djrxr
	 RlwOH/OCuGmqsVKTabucmMDcnj/S/A37SYygDr+BXwDGXrdG29YfX/EkBgKRNHwUXs5Ij21Wpcow
	 i8T3I/n9ERtFISZf8p0eDXphhqDObi+iHGN/NwW/TNHrM5MJM74826y6qNQv7EcEnAoIqDoijlZ4
	 OevTq5D/brj3muBd6IpUyO4X5vHZ2mGKxHZiJUCdIEmzh0e/qRUVZufydgw0wAwk41WJQ8QeXXjx
	 ULlEnkf+/wwOGAGRj4DHCZnWwggBihMwFzU4jGR1I2VaRwzte0qBXvYFkRAdq6EW0PBjX+dIWg14
	 btml8Fyr2xdVdo5ZJ/Z4g1L0eAkU6q+wl1NW/sBpXKaU3cx0s7Al7wKQKSYKhIyK25C5dQ8eesnx
	 O2Hilis3r4UjB6ibcT5If2QK5JvPM4mx+vfX04V5/7SWffmfgV3oOS9rKNI9Ht4lEwJlwAy4dy3Z
	 aQvcxMAnapFdfYIxavUvrcIbJWH4kZqH6//JWHyAdAoLe4T2aSinDVifSe8UGWkOoOgaROycbmSR
	 yOHxwwlCNst6iOTY6M2m9L80gXWQSexB41jMeM6UHjInUCK4XIdmnPqE8zIG5JN/UXOx+pTdcYUj
	 kYkZnodu/qAb7/1AfgaLdtNFF/Zv6HiH6mfpHEybapv9BStOb9sz1Hf4FUSpiXKITEy2C+1KwZr9
	 FovHB/CvCG7MkBcNfv72JCfmC+S/a/EMAg5P5NFWHHcbrD8MPKoXdEJhyG2NMd1jV18XylIS2zx1
	 eUijzkxzUIsGRy8nLtEGHb0VGiGwGZqA32D9h1dFrN2CS5OU9RGB3J02YYlNhzM6/HBPZO8ERAzU
	 Lzu3UunaggaYObuSMwRKVk0J1zJsCMdJ1VDy/faIinf0K1SuOzld+QWOeNoIeiNabEplMQeA5gUL
	 ApdVKG
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Date: Mon, 14 Sep 2026 10:19:20 +0800
X-OQ-MSGID: <20260914021919.1299680-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

when the bh's transaction is committing and the bh is part of the folio,
journal_unmap_buffer returns -EBUSY and triggers a warning.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes:https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-JLDCqQWEmd9ELtkzddA@mail.gmail.com/T/
Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inode.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..6bb94afd5100 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3429,7 +3429,27 @@ static void ext4_journalled_invalidate_folio(struct folio *folio,
 					   size_t offset,
 					   size_t length)
 {
-	WARN_ON(__ext4_journalled_invalidate_folio(folio, offset, length) < 0);
+	tid_t commit_tid;
+	int ret;
+	bool has_transaction;
+	journal_t *journal = EXT4_JOURNAL(folio->mapping->host);
+
+	while (1) {
+		ret = __ext4_journalled_invalidate_folio(folio, offset, length);
+		if (ret != -EBUSY) {
+			WARN_ON(ret < 0);
+			return;
+		}
+		has_transaction = false;
+		read_lock(&journal->j_state_lock);
+		if (journal->j_committing_transaction) {
+			commit_tid = journal->j_committing_transaction->t_tid;
+			has_transaction = true;
+		}
+		read_unlock(&journal->j_state_lock);
+		if (has_transaction)
+			jbd2_log_wait_commit(journal, commit_tid);
+	}
 }
 
 static bool ext4_release_folio(struct folio *folio, gfp_t wait)
-- 
2.55.0

