Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8391A9F83;
	Fri, 11 Sep 2026 03:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097495; cv=none; b=QWoEpfAk/qsdJH9KeUODbVrZskjNQ1jPfbehsrl/tU7ah8kV4QsuqkZ4VLvYB9tO6EpQtV8o6micJG7WW3iQxSI/sCP/HIXarAqWjabFwWdr+LSjcnTESFxkG5lhoUzmqZtwIYkAvlFxJGuW+eWjfsDxN+aDFpNjBzo4BKtB6sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097495; c=relaxed/simple;
	bh=Ft2SFu4NoMEvgsy+ZPKRWgUrkZATMlh7uqCA6lPK47E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw81Xv+7EFe09ISX02zUmKMgvf7l5BEyMAT8GliIKS2Yy8wRlYFrUHJE+kSzO00+HBMuEH+XAoZBKfRCNXUHD01iBaHJAtclVP9TYXZfbl0yHwqM7uUq6H70UkZuF/BCTqW7+4ttBh8aa5uWuDF7C0lRfoMbODs1ooxycIK837w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hh0Ss5lmvzbKSss;
	Fri, 11 Sep 2026 11:31:25 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hh0Ss0ngDzbKSsF;
	Fri, 11 Sep 2026 11:31:25 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTP9aef44ab773e7a3b17ddf712549750e3
	Fri, 11 Sep 2026 11:31:25 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: linux-ext4@vger.kernel.org
Cc: Jonas Zhou <jonaszhou@zhaoxin.com>,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	louisqi@zhaoxin.com,
	jianhuizzzzz@gmail.com
Subject: [PATCH v3] ext4: move orphan tracking away from journal state
Date: Fri, 11 Sep 2026 11:31:13 +0800
Message-ID: <67ae57ef2ee3ac27ab844c22594351c83142d86f.1789097450.git.jonaszhou@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp>
References: <575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>

From: Jonas Zhou <jonaszhou@zhaoxin.com>

In the tested x86-64 layout, s_journal and s_ext4_flags share a cache
line with s_orphan_lock and s_orphan. Legacy orphan-list updates
invalidate the same line used by unrelated journal and inode paths.

Move s_orphan_lock, s_orphan and s_orphan_info together below
s_journal_triggers. This separates orphan-list writes from journal
and flag readers while keeping the related fields in logical groups.
Add a comment identifying the orphan tracking group and preserve the
existing member comments.

On a system with two Xeon Silver 4208 processors and a filesystem
without orphan_file enabled, repeated tests against v7.3-rc2 recorded
mean throughput increases of 11.06% for stress-ng dnotify and 35.93%
for unlink.

Tests with orphan_file enabled showed no clear throughput change
within the observed boot-to-boot variation.

perf c2c shows remote HITM samples on the original shared line, but
none on the separate journal line after the change. Local HITM samples
and orphan-lock contention remain.

Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/all/575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp/
Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>
---
Changes since v2:
- Follow Jan's suggestion to move the orphan tracking fields together
  below s_journal_triggers, instead of exchanging journal state with
  the error-reporting and lazy-init fields.
- Add an Orphan inode tracking comment.
- Rebase and retest against v7.3-rc2.

v2:
https://lore.kernel.org/all/a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com/
v1:
https://lore.kernel.org/all/20260903021836.962624-1-jonaszhou-oc@zhaoxin.com/

 fs/ext4/ext4.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 724a27e8be61..166910914973 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1644,10 +1644,6 @@ struct ext4_sb_info {
 	/* Journaling */
 	struct journal_s *s_journal;
 	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
-	struct mutex s_orphan_lock;	/* Protects on disk list changes */
-	struct list_head s_orphan;	/* List of orphaned inodes in on disk
-					   list */
-	struct ext4_orphan_info s_orphan_info;
 	unsigned long s_commit_interval;
 	u32 s_max_batch_time;
 	u32 s_min_batch_time;
@@ -1786,6 +1782,12 @@ struct ext4_sb_info {
 	/* Journal triggers for checksum computation */
 	struct ext4_journal_trigger s_journal_triggers[EXT4_JOURNAL_TRIGGER_COUNT];
 
+	/* Orphan inode tracking */
+	struct mutex s_orphan_lock;	/* Protects on disk list changes */
+	struct list_head s_orphan;	/* List of orphaned inodes in on disk
+					   list */
+	struct ext4_orphan_info s_orphan_info;
+
 	/* Ratelimit ext4 messages. */
 	struct ratelimit_state s_err_ratelimit_state;
 	struct ratelimit_state s_warning_ratelimit_state;

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0


