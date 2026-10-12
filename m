Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DD7489869;
	Mon, 12 Oct 2026 11:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805681; cv=none; b=fgAuJMP4xKMyuD8hNVYQQNpqQaOKbLQ9qm/H2HS9AUeCbv3YqFDK003xuHzNYGpq0z8rR/kyJ5Uk9ANtZtLs6/CinnwrV4WGzICqVHV6Tl4mCLzu3tABfVXqb8pIyWS0gDYAIIHrqnCkCtv9KnpPt2UdyZQfagLI3+mP/lSuuU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805681; c=relaxed/simple;
	bh=cQEHHmELmdZw7Sx3ATP+f56PMCGYH35Lpfm+fq7+MRs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lpeURnlNdA6ElWdSLHMcivuO4AO7dqRW74hAairfPyiD2rqJKV2EofFRxBfcvLmlOwhySicIE8HsfoTU/hjXpUNToxmCLmlVfEFCTGEvdyAP7QviCNuuFTbBB0ZA7+0bTLaVktSMYRXL3RCdTRkGzqC9poiuPilw+3GbJyMGfn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=MUmyBEa6; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="MUmyBEa6"
Received: from localhost (gyproxy-mailtls0-entmail-virt215.gy.ntes [IPV6:2409:8d28:140:849:c9f1:798d:951b:9e3f])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50bb2b782;
	Mon, 12 Oct 2026 19:47:40 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] jbd2: check return value of blkdev_issue_flush() when checkpointing
Date: Mon, 12 Oct 2026 11:47:11 +0000
Message-Id: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa12ff09baa03a2kunm0f9a87bb47e826
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDS08ZVhkZHUkZHx0fGEhCSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSk9LQUNPQkEYQh1KQUxCQx9BQk5KGUFCHk
	gdWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ01CVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=MUmyBEa6HDXdI+USUo9JFVROTWG1Xt0Xnz2ya0Lx3oQzV8diE10E2u8Gy1a2BT1HiscLya88/TarJFKT22UOwHv/Da1FdOKPi2swVYsNazRmmKhAVucNx9Y43SaEf2RO/RskC1Zk4zC1e3VZsMpYcBAHz38Uwq44wXosgN8QqHc=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=vyAgpXVMNNpDwbaYB9wrxTvAVCQ8Jnh2UT/qE4Hjs5U=;
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

