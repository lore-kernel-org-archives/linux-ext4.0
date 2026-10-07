Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A578267B89;
	Wed,  7 Oct 2026 00:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791333670; cv=none; b=nfPr9sVPZTol4pKBA4G0CE9Pw1QjIJYeWdohTvKTB7sLuxBO+h6mRDo4bjf1xczu2vluu4VRUdCuRk3sHPYINv9UKDwBnDGBhzbBzdsFHFTCH2ZICmHbCrD60eYZQK4xSswuHXv4gecdiBJy0zporOEYrvDTYQRB5/JBUTiLVBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791333670; c=relaxed/simple;
	bh=ZADFq7QMH+Or1Q9xtIq/j5uvZPViwsTrhpuIZTEAh0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=t79mBGl/REvwWYyeZ5dVgJ9LxYpuih7I86XCN3wtUtvbS/f6Rnv1IttoOn9qEN3OFGgdSbXjWVgMBRxddFtcj2/cWj6rviJ/xbE53pXluL5aBMehrSLhF7JKkFjAPGPWe8uJck6y2kcuQ2yYBWUoY3BsmDC8XV59rWCjG+HWCHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZ1RC5ch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZ1RC5ch"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA666C2BCF4;
	Wed,  7 Oct 2026 00:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791333669;
	bh=ZADFq7QMH+Or1Q9xtIq/j5uvZPViwsTrhpuIZTEAh0s=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=bZ1RC5chG+86vq6xdDnc/XLTxEeVk3ksOToZRVmINEeTcfVQwIENDlK3d9NF7565O
	 1XwSfwNaTYHxhSwcjXg7pY6sHBkIDQ1PIpIBIvTPCIWGmfTKTNsjKR9mjYIyo0YTln
	 xRrP46DYsR0wHJSS/KOtNuLCJpJ0g7f6KdQe/w88S1JH6AsdlnOjWi1hZ5W56uhQY0
	 TTuv/b2+/T2EsRTZgRfXdOrCvh1PNNJElBd+Bira9jZ6pMugXtan5UNLlMam9TihwI
	 +0YoWZsEon1mB/GayzvUYNufMPHvMfaUtGQnFUgHrfFINEMrB7FHqLyfb8LCEMvqOq
	 z4ynN8ddkdbIA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65C8CA5FED;
	Wed,  7 Oct 2026 00:41:09 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 07 Oct 2026 09:41:09 +0900
Subject: [PATCH] jbd2: don't start a fast commit while the journal is
 marked empty
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
X-B4-Tracking: v=1; b=H4sIACSVxWoC/x3M3QpAQBBA4VfRXJtaoxSvIhf7M8NIaBcpeXeby
 +/inAcSR+UEXfFA5EuTbmtGVRbgJ7uOjBqygQw1lTENzi4QikcrB0eU5UwTEkvrnK/Js4Vc7pF
 F7//aD+/7Abb1gbZlAAAA
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
 Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Li Chen <me@linux.beauty>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791333668; l=3604;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=wvHXFS/P1TEpWhq+CEih4M/MIQ+Nl9mjPJS2mjRxa/4=;
 b=ipBEXd8AoJ2HwWD5m9ojuEICKKaPMsJj+J5Qt0LSLebxx5XzkWgKhTeehKp/unXYHoSiVoRLE
 qGNkkWbu4IIAvQ+I2S2skJKr4/zA0etNcQoGGiKm5QOUrlVXFYcASTD
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

jbd2_journal_flush() checkpoints everything, and
jbd2_mark_journal_empty() then writes the journal superblock with
s_start == 0 and the fast commit feature cleared. It sets JBD2_FLUSHED
so that the next commit writes the log tail and the feature back, but
only jbd2_journal_commit_transaction() looks at that flag. A fast commit
started before the next full commit writes its blocks while the
superblock on disk still says the log is empty: jbd2_journal_recover()
returns at once and the fast commit is never replayed.

On ext4 with -O fast_commit this happens after ext4_freeze(), and after
a remount to read-only, which flushes the journal in
ext4_mark_recovery_complete(), once the file system is read-write again.
EXT4_IOC_CHECKPOINT and online resize flush it as well. An fsync that a
fast commit handles after one of them is lost if the system crashes
before the next full commit, which can be up to the commit interval
later:

  mount -o commit=60 (-O fast_commit file system)
  echo first > a; sync
  fsfreeze -f; fsfreeze -u      # or: remount ro, then rw
  write b; fsync b              # one fast commit, s_start still 0
  crash (kill the VM), mount
  b is missing

Refuse to start a fast commit while JBD2_FLUSHED is set, as is already
done before the first full commit. ext4 then falls back to a full
commit, which writes the log tail, and the fast commits after it are
recovered again. fc_info counts the refused fast commit as ineligible,
as it does for the existing check.

Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested in QEMU on ext4 dev 9091c97be340, crashing by killing QEMU: the
sequence above loses b without this change and keeps it with it, both
after fsfreeze and after a remount ro then rw. A second fsync after the
fallback is a fast commit again and is recovered. xfstests ext4/044
ext4/045 generic/455 generic/456 generic/482 with -O fast_commit, and
generic/068 generic/085 generic/390, give the same results as without
the change (generic/455 fails on both).
---
 fs/jbd2/journal.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 00f5a98f3d..22576af8c8 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -695,7 +695,8 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
  * it to complete. Returns 0 if a new fast commit was started. Returns -EALREADY
  * if a fast commit is not needed, either because there's an already a commit
  * going on or this tid has already been committed. Returns -EINVAL if no jbd2
- * commit has yet been performed.
+ * commit has yet been performed, or none since the journal was last marked
+ * empty.
  */
 int jbd2_fc_begin_commit(journal_t *journal, tid_t tid)
 {
@@ -714,6 +715,16 @@ int jbd2_fc_begin_commit(journal_t *journal, tid_t tid)
 		return -EALREADY;
 	}
 
+	/*
+	 * The log was emptied and the superblock on disk says so, which makes
+	 * recovery skip the fast commit area as well. Only a full commit
+	 * records the log tail again.
+	 */
+	if (journal->j_flags & JBD2_FLUSHED) {
+		write_unlock(&journal->j_state_lock);
+		return -EINVAL;
+	}
+
 	if (journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
 	    (journal->j_flags & JBD2_FAST_COMMIT_ONGOING)) {
 		DEFINE_WAIT(wait);

---
base-commit: 9091c97be34083587a75db174aab51551d8e8543
change-id: 20261006-jbd2-fc-after-flush-2ef9bbc32cea

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


