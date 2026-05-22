Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2B84039;
	Fri, 22 May 2026 03:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779419466; cv=none; b=LUGW3V2ipytSV69ZzA6VTImEVPSDY+V6kwG55u+Qk5YSaq6v9ygTEpaW720ck7DvGsAvwYVt/PL1lvGyIXTYyZbeeSEmhgm7elr5qzHm9J4fFXxMzA+rUnphmJeY1sI9ItYRPUwGUnIGM14FAahdIx4EyhkGGnZHfvRJY8klzjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779419466; c=relaxed/simple;
	bh=gddCX5NQZJhwugZAz+qwpWzQR5BNUgJ25WVlANHLWbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2s7s0I4Th2taET6gwdkiqYgFNHvPNdl8vU+NZZje3F1L/jqXS70T7ZHQ+4ArucTdDXtmsOLs+a+fc0ADiZfDU+pkYPMvVgGjOn0M5BLF9N+OOUCjKRLag1qWQRsTG/WBwpijOglUkBuxM9o6emF1TiSrFhO2PSR+LFdLye+E5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gM9Hv3YTVzYQttp;
	Fri, 22 May 2026 11:10:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 993DF4056E;
	Fri, 22 May 2026 11:10:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgBHD1szyQ9qrrG7DA--.47182S4;
	Fri, 22 May 2026 11:10:50 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH] jbd2: update outdated comment for jbd2_journal_try_to_free_buffers()
Date: Fri, 22 May 2026 11:05:40 +0800
Message-ID: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHD1szyQ9qrrG7DA--.47182S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJFykGrW7Xw4UJF45Gry7GFg_yoWrXF1Upr
	ZIk3y7XrWqvry8Ar1kZF4rArWYvanrZryUGayUWr93Aa15Cw1vqFy7tw1IyryDCr97Kw4U
	Xr1UGr95Wr4qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

jbd2_journal_try_to_free_buffers() currently only tries to remove
checkpointed data buffers from the checkpoint list for data=journal
mode, and bails out if any buffer is still attached to a transaction.
For data=ordered and writeback modes, data buffers never have
journal_heads, so the function degenerates to a plain
try_to_free_buffers() call.

Besides, The release of metadata buffers has been delegated to the jbd2
journal shrinker in commit 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to
release checkpointed buffers"). jbd2_journal_try_to_free_buffers() is
not used for handling metadata buffers now.

However, the comment above the function still references
jbd2_journal_dirty_data(), __jbd2_journal_unfile_buffer(), t_datalist,
BKL, and BUF_CLEAN, all of which were removed in commit 87c89c232c8f
("jbd2: Remove data=ordered mode support using jbd buffer heads").

Replace it with a description of what the function actually does now.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/jbd2/transaction.c | 39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4885903bbd10..239bcf88ed1c 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2139,38 +2139,23 @@ static void __jbd2_journal_unfile_buffer(struct journal_head *jh)
 }
 
 /**
- * jbd2_journal_try_to_free_buffers() - try to free page buffers.
+ * jbd2_journal_try_to_free_buffers() - try to free folio buffers.
  * @journal: journal for operation
  * @folio: Folio to detach data from.
  *
- * For all the buffers on this page,
- * if they are fully written out ordered data, move them onto BUF_CLEAN
- * so try_to_free_buffers() can reap them.
+ * For each buffer_head on @folio, if the buffer has a journal_head but
+ * is not attached to a running or committing transaction, try to remove
+ * it from the checkpoint list.  This is needed for data=journal mode
+ * where data buffers are journaled: once they are checkpointed, the
+ * journal_head can be detached and the buffer freed.  If any buffer is
+ * still attached to a transaction, the folio cannot be released and we
+ * bail out.  Otherwise we call try_to_free_buffers() to detach all
+ * buffer_heads from the folio.
  *
- * This function returns non-zero if we wish try_to_free_buffers()
- * to be called. We do this if the page is releasable by try_to_free_buffers().
- * We also do it if the page has locked or dirty buffers and the caller wants
- * us to perform sync or async writeout.
+ * For data=ordered and writeback modes, data buffers never have
+ * journal_heads, so this degenerates to a plain try_to_free_buffers().
  *
- * This complicates JBD locking somewhat.  We aren't protected by the
- * BKL here.  We wish to remove the buffer from its committing or
- * running transaction's ->t_datalist via __jbd2_journal_unfile_buffer.
- *
- * This may *change* the value of transaction_t->t_datalist, so anyone
- * who looks at t_datalist needs to lock against this function.
- *
- * Even worse, someone may be doing a jbd2_journal_dirty_data on this
- * buffer.  So we need to lock against that.  jbd2_journal_dirty_data()
- * will come out of the lock with the buffer dirty, which makes it
- * ineligible for release here.
- *
- * Who else is affected by this?  hmm...  Really the only contender
- * is do_get_write_access() - it could be looking at the buffer while
- * journal_try_to_free_buffer() is changing its state.  But that
- * cannot happen because we never reallocate freed data as metadata
- * while the data is part of a transaction.  Yes?
- *
- * Return false on failure, true on success
+ * Return: true if the folio's buffers were freed, false otherwise
  */
 bool jbd2_journal_try_to_free_buffers(journal_t *journal, struct folio *folio)
 {
-- 
2.52.0

