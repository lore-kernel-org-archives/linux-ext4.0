Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4A8414430;
	Tue, 13 Oct 2026 01:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855668; cv=none; b=FApBnxZnKSK+7OyjSIV9wfLH018U/8j7E3mL4hAUkCpH2AUuoaeIt/RykbUENpetPmnF8JFlJKcrbCr78vRNyiif/S9Juu0YnYPQskt7ZTudSzISab4Xhwl1k/Qvu5KlNl7oOKFmoqn78B+joVhDl0MDlrTxWjdoVvqTTL8GehI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855668; c=relaxed/simple;
	bh=YJRlazg5QsL/y79yYMixv4JDEMKPMWl41OOPS/6WTOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Judy0TIs8z6sb5XtDCljeqDG7mnzWOQzAy2Hsz3EveL9oZTYkm0HQj52/J9iXT8VGW1jHuoFop6meIVaRPfB9hMzGQKsVg4QPI+5PBSGUzP3L9fBOMhOXxeylgaDGsxmDR3vtJyKG0bnE2739RRC4LFN03EY/mYco4qRfrHuRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=dGQHgVLc; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="dGQHgVLc"
Received: from localhost (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [IPV6:240e:471:430:37de:7ca5:8deb:704c:6197])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50cb20ab6;
	Tue, 13 Oct 2026 09:40:59 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/3] jbd2: check return value of blkdev_issue_flush() when checkpointing
Date: Tue, 13 Oct 2026 01:40:26 +0000
Message-Id: <20261013014028.1152277-2-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013014028.1152277-1-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa132eb893903a2kunmb88d3ae949bae7
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGBpNVhpDHhhLSkMYH0xCQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0seQU9MSkFPSEtBSEwfHkFMGBpOQUMfHhlBTEtPGEFNSk
	JMWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ01CVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=dGQHgVLcDvxqk5zcO2zOcbugYkZfWMtAPR2ZtkhzQ0oR6l2qo7Bo8QtfFHW08wCHnHPNwTgDKNZacD/ZPs5+h0Erx/ommT11ER8LlPG75MjQyb50hAQklIQ5RUxWVK4zDnNTx0h148O3/DMzJAtlQwrFW/c+vEshKMT/tcxExNU=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=Z8ytFmjSG2iKp7uCnnbxl0GToVPS6y6xjh9NXApiaC4=;
	h=date:mime-version:subject:message-id:from;

jbd2_cleanup_journal_tail() calls blkdev_issue_flush() on the file
system device to make sure all checkpointed data are on permanent
storage before it updates the log tail in the superblock.  However
the return value of blkdev_issue_flush() is ignored so if the flush
fails, we still advance the log tail.  After a crash the journal
recovery will consider the checkpointed transactions as committed
and skip the replay while their data may have never reached the
disk, which may lead to a filesystem corruption.

Abort the journal when the flush fails, similar to how we abort
when detecting writeback errors of the file system device.

Fixes: 79feb521a447 ("jbd2: issue cache flush after checkpointing even with internal journal")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/jbd2/checkpoint.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 513273712010..9bbce4c8cadb 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -346,8 +346,14 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	 * need this to guarantee correctness.  Fortunately
 	 * jbd2_cleanup_journal_tail() doesn't get called all that often.
 	 */
-	if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(journal->j_fs_dev);
+	if (journal->j_flags & JBD2_BARRIER) {
+		int err = blkdev_issue_flush(journal->j_fs_dev);
+
+		if (err) {
+			jbd2_journal_abort(journal, err);
+			return err;
+		}
+	}
 
 	return __jbd2_update_log_tail(journal, first_tid, blocknr);
 }
-- 
2.34.1

