Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E44391820;
	Thu,  9 Apr 2026 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775735268; cv=none; b=I4ipVaPsex4fMWGwijJqutFg6158UlgQGbu9FPKOgQ8/RDxdBFjdlgsuwLUvLVBMOYp7n+vZuNNLRvT6Ov70saHeuLnQqjFujADkinvCOKrTZy8riNoCa10+AK0UF6LMpes+gPMNcTy7iwpxWOXz51zxFp/gjnP1c1A3e/YGW2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775735268; c=relaxed/simple;
	bh=UBWP4HMYIq3fCF5zPk//N+07aF3jABzOqwEjmLuncd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EVTJPszpaBd+0m22njfa0UJ3aW6ZKnvatYVnJNxuC8rikgn8lD4uLHq0Wthx5REUYlg1onF/oO0pN8n+O7jCVwxUNGNZpWuoaUaHT2cJBiA/Xub1Etg8s0aVaHlCih84iTYD+fIVnmPjAs0rdHzX+7/8bT91KIhvuwnA0mkr/Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4frypw0bsCzKHMk3;
	Thu,  9 Apr 2026 19:47:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4266340592;
	Thu,  9 Apr 2026 19:47:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgAHC9vQkddpnPjFDw--.28749S4;
	Thu, 09 Apr 2026 19:47:36 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2] jbd2: fix deadlock in jbd2_journal_cancel_revoke()
Date: Thu,  9 Apr 2026 19:42:03 +0800
Message-ID: <20260409114204.917154-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAHC9vQkddpnPjFDw--.28749S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw15XF4rJr15JF43XFWrKrg_yoW5JFyUpF
	98KFyYkrykuF1qk3Z7Xay5JF13Gw4kGryUCFZF9wnIkF45XF97KFW7K3WYqFyjvrs7Xw4v
	qrWjya4rua109rDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUQID7UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Commit f76d4c28a46a ("fs/jbd2: use sleeping version of
__find_get_block()") changed jbd2_journal_cancel_revoke() to use
__find_get_block_nonatomic() which holds the folio lock instead of
i_private_lock. This breaks the lock ordering (folio -> buffer) and
causes an ABBA deadlock when the filesystem blocksize < pagesize:

     T1                                T2
ext4_mkdir()
 ext4_init_new_dir()
  ext4_append()
   ext4_getblk()
    lock_buffer()    <- A
                                   sync_blockdev()
                                    blkdev_writepages()
                                     writeback_iter()
                                      writeback_get_folio()
                                       folio_lock()   <- B
     ext4_journal_get_create_access()
      jbd2_journal_cancel_revoke()
       __find_get_block_nonatomic()
        folio_lock()  <- B
                                     block_write_full_folio()
                                      lock_buffer()   <- A

This can occasionally cause generic/013 to hang.

Fix by only calling __find_get_block_nonatomic() when the passed
buffer_head doesn't belong to the bdev, which is the only case that we
need to look up its bdev alias. Otherwise, the lookup is redundant since
the found buffer_head is equal to the one we passed in.

Fixes: f76d4c28a46a ("fs/jbd2: use sleeping version of __find_get_block()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
v1->v2:
 - Switch to using sb_is_blkdev_sb() to check whether the bh belongs to
   the bdev.

 fs/jbd2/revoke.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 9016ddb82447..e4c2fbd381f1 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -428,6 +428,7 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_cancel;
 	struct buffer_head *bh = jh2bh(jh);
+	struct address_space *bh_mapping = bh->b_folio->mapping;
 
 	jbd2_debug(4, "journal_head %p, cancelling revoke\n", jh);
 
@@ -464,13 +465,14 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * buffer_head?  If so, we'd better make sure we clear the
 	 * revoked status on any hashed alias too, otherwise the revoke
 	 * state machine will get very upset later on. */
-	if (need_cancel) {
+	if (need_cancel && !sb_is_blkdev_sb(bh_mapping->host->i_sb)) {
 		struct buffer_head *bh2;
+
 		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
 						 bh->b_size);
 		if (bh2) {
-			if (bh2 != bh)
-				clear_buffer_revoked(bh2);
+			WARN_ON_ONCE(bh2 == bh);
+			clear_buffer_revoked(bh2);
 			__brelse(bh2);
 		}
 	}
-- 
2.52.0

