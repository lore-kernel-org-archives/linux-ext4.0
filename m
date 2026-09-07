Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E05C466B1B;
	Mon,  7 Sep 2026 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788779590; cv=none; b=D+mjQtCHzbcr4u8anLUjXrdQDc3fiA+SJh/LdAo0OPPvzhbG0cEdk+ykR2tIFoqTtsz4Hgs+yr7VugqMLOx/fCRhDCNzTqFpuNLM0Od5OaQVJKPTcSdzCopbl7VoaKABVrjhhmyHaoOw9F5IUxzEmKDpwXoEgKEQbdP9MN2nta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788779590; c=relaxed/simple;
	bh=Ekzk3MqDiT7uliB8bjQOXmBal1Huaf90hFgwbgS48ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW3hlI+5OHu7BH81N3TgzaBIcc34YVMNv82JOuJ//3Yctvvc+dhnoJQA60t9WZooH6AXqrLKEZhUGbuV0NZtUgWA6KgRTTY8yQhOz6Hw1jHdnm8+7J1c8elfu6xFiVquPTB843NCmu3Zro2GNUgLOVtdpgKasuFvYvCoUzzDBiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hdkvL4R6Fzcq5yD;
	Mon,  7 Sep 2026 19:13:02 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hdkvJ0mpczcq5yD;
	Mon,  7 Sep 2026 19:13:00 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTP7a67373d60166b075aa5b476ce5b50df
	Mon, 07 Sep 2026 19:12:59 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
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
Subject: [PATCH v2] ext4: move journal state away from orphan list updates
Date: Mon,  7 Sep 2026 19:12:42 +0800
Message-ID: <a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
References: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
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

Exchange s_journal and s_ext4_flags with s_err_report_sec and
s_li_request, which are used for error reporting and lazy-init
management. This separates the common journal and flag readers from
orphan-list writes without adding padding or shifting the intervening
allocator fields. Preserve the comment describing s_orphan_lock.

Only these four member offsets change, and sizeof(struct ext4_sb_info)
remains 2496 bytes with the tested x86-64 configuration. Compiled layout
checks with quota disabled, lockdep, PREEMPT_RT and i386 also preserve
the respective structure sizes and all other member offsets.

On a system with two Xeon Silver 4208 processors and a filesystem
without orphan_file enabled, mean throughput improved by 13.52% for
stress-ng dnotify and 31.70% for unlink.

This targets users of the legacy orphan list. The orphan_file feature
avoids this lock in normal operation and remains the main scalability
improvement. Tests with orphan_file enabled show no clear throughput
change within the observed boot-to-boot variation.

Results from repeated tests comparing v7.3-rc1 and v2:

                       Mean throughput       Mean change
Feature      Test          base         v2           (%)
legacy       dnotify    19562.38   22206.66        +13.52
legacy       unlink        38.82      51.13        +31.70
legacy       fallocate    233.55     234.14         +0.25
orphan_file  dnotify    27702.16   27582.55         -0.43
orphan_file  unlink       116.93     116.52         -0.34
orphan_file  fallocate    235.20     235.89         +0.29

Descriptive 95% t intervals from the four paired log ratios (df=3),
expressed as percentage changes:
  legacy:      dnotify [+4.83, +22.92], unlink [+22.53, +41.48],
               fallocate [-1.40, +1.94]
  orphan_file: dnotify [-5.44, +4.96], unlink [-2.76, +2.13],
               fallocate [-0.82, +1.42]
These are intervals for the paired geometric ratio, not the arithmetic
mean ratio above. Four pairs do not establish performance equivalence.

For legacy dnotify, perf c2c shows remote HITM samples on the original
journal/flags offsets, but none on their new cache line after the
change. Local HITM samples and orphan-lock contention remain. The
combined HITM sample density of the orphan and journal lines is lower
than that of the original shared line.

Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>
---
Changes since v1:
- Replace explicit cache-line alignment with a four-member exchange.
- Keep the mutex comment and all other member offsets unchanged.
- Retest this layout against v7.3-rc1, including orphan_file controls.

v1:
https://lore.kernel.org/all/20260903021836.962624-1-jonaszhou-oc@zhaoxin.com/

 fs/ext4/ext4.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 724a27e8be61..16ef01078233 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1641,9 +1641,13 @@ struct ext4_sb_info {
 	struct super_block *s_sb;
 	struct buffer_head *s_mmp_bh;
 
+	/* timeout in seconds for s_err_report; 0 disables the timer. */
+	unsigned long s_err_report_sec;
+
+	/* Lazy inode table initialization info */
+	struct ext4_li_request *s_li_request;
+
 	/* Journaling */
-	struct journal_s *s_journal;
-	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
 	struct mutex s_orphan_lock;	/* Protects on disk list changes */
 	struct list_head s_orphan;	/* List of orphaned inodes in on disk
 					   list */
@@ -1747,11 +1751,10 @@ struct ext4_sb_info {
 
 	/* timer for periodic error stats printing */
 	struct timer_list s_err_report;
-	/* timeout in seconds for s_err_report; 0 disables the timer. */
-	unsigned long s_err_report_sec;
+	/* Keep journal state away from orphan list updates. */
+	struct journal_s *s_journal;
+	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
 
-	/* Lazy inode table initialization info */
-	struct ext4_li_request *s_li_request;
 	/* Wait multiplier for lazy initialization thread */
 	unsigned int s_li_wait_mult;
 

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.43.0


