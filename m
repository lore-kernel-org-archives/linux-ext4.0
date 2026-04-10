Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904CD32D7F8
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 03:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775793406; cv=none; b=dXk7p/vzzu6gTI0Ek1b4F//sSBWlYPz+mpF8Iyyuepi14tiD2UzkpsUNsV8eLxCkdX7nwmZfkI0vfKk9LxAr2jCKGtu6focGpxj8zR1byUe0NEdm8vMR2Av+pb9vm+8EzV/1ZZImNcD7rZehHxlKPCYCkl0g5s7CBghg1VjVxCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775793406; c=relaxed/simple;
	bh=6VgrxJ/EKckn/f1V4UYs/as2VQQE71/j43gR36E7BhE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DIZ90CI+qiKoO/BK6wuJPRSr5v2sCtCKf46KMSB4BhUHRVSW9T9vny5cajEgNN2N5OSrpl41N3tUJVXlTE14y5TICHM3sHf5S8NHuCfL1t7akVUIsFF2pmOraL/uwib5O6iWntUCjsY1w5w7ofEnKu8rOCKq0vY3Y60FZkl5p04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vxu0JNNn; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vxu0JNNn"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b23fcf90b2so15523085ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 09 Apr 2026 20:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775793405; x=1776398205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=68Y2KOu6IjWpqsJxmRaUt28cJkLdrMRf5M9uj6SY5BA=;
        b=Vxu0JNNnwdFztIyl/KOQvCeKter0rO6CAn6x/W0jP5s0Cs/JwNFU9YbANt/WJoizG6
         qt/ljOHzC5cSgEof2vDaSKxO4wxhpt/ES3EH0C4IWPGeZzqX6ebkJTsMxiVj+dek+9zB
         OcryjeCewqh5rnatv2n6EjCZt5NhZu2oHna1rMctS15fklvRc+LbdVUlSwBgwYOWF6Yo
         BoO7t99bl2xh5+6vfeukcc/cRVauyDI9w6LJuU7qalJtjNybTY1fgDiKsfZSpQPUeZN8
         iHnx+Dr4lGl1p08FzUEaCeGHTziPaXIhzYUgbWlFBT5VjOR5GPmrUlUs41T8EuTZyuWS
         ZfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775793405; x=1776398205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68Y2KOu6IjWpqsJxmRaUt28cJkLdrMRf5M9uj6SY5BA=;
        b=hcnGpfv0q2r0RIQvedien9ewg4LUipUzJvv0gDo9fYqpzSOygFlcgLbdJ9TBZD8yMP
         lRhHRMVLo1H2e5BfvyFHd4lQJtsfvfKtmHRte4Tyfz64oaWl9DNbrGKCGFfKUmFuooBT
         5eHDs+ZJ5KG2T6h3WiUeOJ868wwTKlTkhF8kTWMUggSDDghckV7atT0N4YT+82d2lGOY
         h6+P5WAQqHYo9BNf9JQa+qX/nkpFEAWYdAox/0481M8k4llosjCiXbL8KDXjiWBQ8Xpi
         aRPDCRmz4dD5LEXGW+HJuqsI3hSZuEex8M7o1pRPQs5241fUjALOUB/vnQm9T3Kp0VwD
         anRg==
X-Forwarded-Encrypted: i=1; AJvYcCUGWIXwsD/AIH7e7sbs9FipL66CMDd35v6zRa1vOZn0A+m5T9vtU9Mi5P8Yddz5lW5+n8XbNQADnMlF@vger.kernel.org
X-Gm-Message-State: AOJu0Yxikr37602bkxrA/oxg5kWXrqWKXcNi3S0tiLg9qzI4qvdvymn+
	1vjC3v2UQiCrpAjQ+4q/jqPyEQ5MDri8bs9dYAoeHM1fx/yuMiwqsd8G
X-Gm-Gg: AeBDieskdtJ4IA9MJqB36SYf+dg4PSu7h1o/UlRcnL8TGWwefjqWYk3J2KJmBnVFMrM
	Ep2UCrJf+Wg+QodWTxgLkNsD16BxwGhF4FBtsI3t9eqMf4gBbeDnphoEqUJtJTEfj/0XQZGx+lV
	uactrulDUjkzuSWVGc6R98NYEfnj6xysH8nJFQoQs21BfIsTDdy1pe6ejh/AGjoxoQnBKCypkNf
	0pfs4UW1dgVZYfzTb3yGGMc+Gn8xrFB+uiPxkDpAgfw7uYT1bKwoM4xS0XG4Pfc9M2RBhlVoTo6
	GyuCyVmxR+Z4JKvgn8PZyxZt2Rx/cGy3q6wwOcOK6h/qQ3KUfkvlyNLIzi+1nhZNzPgBA7Cco7c
	JGX74GNPKS8NDcwYxWh2DOMgParVZkfqTzlzWDN4rT17clB2Fu28f1uXwgGd1C1150zBqYEQTnj
	IsQbJNiBenfkZp35PMLXnNNef6EgMxbD/aGxrFyvJCh98l0b3rovta
X-Received: by 2002:a17:902:b48f:b0:2b2:d12e:beae with SMTP id d9443c01a7336-2b2d5a65c0bmr10742495ad.42.1775793404825;
        Thu, 09 Apr 2026 20:56:44 -0700 (PDT)
Received: from n232-167-136.byted.org ([36.110.163.104])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f37086sm10850555ad.68.2026.04.09.20.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 20:56:44 -0700 (PDT)
From: guzebing <guzebing1612@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	guzebing@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: make mballoc max prealloc size configurable
Date: Fri, 10 Apr 2026 11:56:35 +0800
Message-Id: <20260410035635.1381920-1-guzebing1612@gmail.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guzebing <guzebing@bytedance.com>

Add per-superblock sysfs knob mb_max_prealloc_kb (min 8MiB, roundup
pow2) and use it in request normalization.

When multiple tasks write to different files on the same filesystem
concurrently, each file ends up with 8 MiB extents. If the preallocation
size is increased, the resulting extent size grows accordingly. Due
to the readahead mechanism on NVMe SSDs, files with larger extents
achieve higher sequential read throughput.

On an ext4 filesystem on an NVMe Gen4 data drive, dd read throughput
for a file with 8 MiB extents is 455 MB/s, while for a file with
32 MiB extents it reaches 702 MB/s.

Steps to reproduce:
1.Configure the maximum preallocation size to 8 MiB or 32 MiB:
echo 8192 > /sys/fs/ext4/nvme13n1/mb_max_prealloc_kb
echo 32768 > /sys/fs/ext4/nvme13n1/mb_max_prealloc_kb

2.Run the following commands simultaneously so that the extents of
the two files are physically interleaved, resulting in 8 MiB or 32 MiB
extents:
dd if=/dev/zero of=/mnt/store1/501.txt bs=128K count=80K oflag=direct
dd if=/dev/zero of=/mnt/store1/502.txt bs=128K count=80K oflag=direct

3.Read back the file and measure the read throughput:
dd if=/mnt/store1/501.txt of=/dev/null bs=128K count=80K iflag=direct

Signed-off-by: Guzebing <guzebing@bytedance.com>
---
 Documentation/ABI/testing/sysfs-fs-ext4 |  8 +++++++
 fs/ext4/ext4.h                          |  1 +
 fs/ext4/mballoc.c                       |  2 +-
 fs/ext4/super.c                         |  1 +
 fs/ext4/sysfs.c                         | 28 ++++++++++++++++++++++++-
 5 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index 2edd0a6672d3a..316ae1d1ec18b 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -48,6 +48,14 @@ Description:
 		will have its blocks allocated out of its own unique
 		preallocation pool.
 
+What:		/sys/fs/ext4/<disk>/mb_max_prealloc_kb
+Date:		April 2026
+Contact:	"Linux Ext4 Development List" <linux-ext4@vger.kernel.org>
+Description:
+		Maximum size (in kilobytes) used by the multiblock allocator's
+		normalized request preallocation heuristic. Values are rounded
+		up to a power of two and clamped to a minimum of 8192 (8MiB).
+
 What:		/sys/fs/ext4/<disk>/inode_readahead_blks
 Date:		March 2008
 Contact:	"Theodore Ts'o" <tytso@mit.edu>
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7617e2d454ea5..bce99740740f5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1634,6 +1634,7 @@ struct ext4_sb_info {
 	unsigned int s_mb_best_avail_max_trim_order;
 	unsigned int s_sb_update_sec;
 	unsigned int s_sb_update_kb;
+	unsigned int s_mb_max_prealloc_kb;
 
 	/* where last allocation was done - for stream allocation */
 	ext4_group_t *s_mb_last_groups;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bb58eafb87bcd..f5f63c56fcdac 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4589,7 +4589,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 					(8<<20)>>bsbits, max, 8 * 1024)) {
 		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
 							(23 - bsbits)) << 23;
-		size = 8 * 1024 * 1024;
+		size = (loff_t)sbi->s_mb_max_prealloc_kb << 10;
 	} else {
 		start_off = (loff_t) ac->ac_o_ex.fe_logical << bsbits;
 		size	  = (loff_t) EXT4_C2B(sbi,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a34efb44e73d7..f815e31657cc9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5447,6 +5447,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		sbi->s_stripe = 0;
 	}
 	sbi->s_extent_max_zeroout_kb = 32;
+	sbi->s_mb_max_prealloc_kb = 8 * 1024;
 
 	/*
 	 * set up enough so that it can read an inode
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017fa..6339492eb2fa7 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -10,6 +10,8 @@
 
 #include <linux/time.h>
 #include <linux/fs.h>
+#include <linux/log2.h>
+#include <linux/limits.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
@@ -41,6 +43,7 @@ typedef enum {
 	attr_pointer_atomic,
 	attr_journal_task,
 	attr_err_report_sec,
+	attr_mb_max_prealloc_kb,
 } attr_id_t;
 
 typedef enum {
@@ -115,6 +118,25 @@ static ssize_t reserved_clusters_store(struct ext4_sb_info *sbi,
 	return count;
 }
 
+static ssize_t mb_max_prealloc_kb_store(struct ext4_sb_info *sbi,
+					const char *buf, size_t count)
+{
+	unsigned int v;
+	int ret;
+	unsigned long rounded;
+
+	ret = kstrtouint(skip_spaces(buf), 0, &v);
+	if (ret)
+		return ret;
+	if (v < 8192)
+		v = 8192;
+	rounded = roundup_pow_of_two((unsigned long)v);
+	if (rounded > UINT_MAX)
+		return -EINVAL;
+	sbi->s_mb_max_prealloc_kb = (unsigned int)rounded;
+	return count;
+}
+
 static ssize_t trigger_test_error(struct ext4_sb_info *sbi,
 				  const char *buf, size_t count)
 {
@@ -288,6 +310,7 @@ EXT4_RW_ATTR_SBI_UI(mb_prefetch_limit, s_mb_prefetch_limit);
 EXT4_RW_ATTR_SBI_UL(last_trim_minblks, s_last_trim_minblks);
 EXT4_RW_ATTR_SBI_UI(sb_update_sec, s_sb_update_sec);
 EXT4_RW_ATTR_SBI_UI(sb_update_kb, s_sb_update_kb);
+EXT4_ATTR_OFFSET(mb_max_prealloc_kb, 0644, mb_max_prealloc_kb, ext4_sb_info, s_mb_max_prealloc_kb);
 
 static unsigned int old_bump_val = 128;
 EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
@@ -341,6 +364,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(last_trim_minblks),
 	ATTR_LIST(sb_update_sec),
 	ATTR_LIST(sb_update_kb),
+	ATTR_LIST(mb_max_prealloc_kb),
 	ATTR_LIST(err_report_sec),
 	NULL,
 };
@@ -431,6 +455,7 @@ static ssize_t ext4_generic_attr_show(struct ext4_attr *a,
 	case attr_mb_order:
 	case attr_pointer_pi:
 	case attr_pointer_ui:
+	case attr_mb_max_prealloc_kb:
 		if (a->attr_ptr == ptr_ext4_super_block_offset)
 			return sysfs_emit(buf, "%u\n", le32_to_cpup(ptr));
 		return sysfs_emit(buf, "%u\n", *((unsigned int *) ptr));
@@ -557,6 +582,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
 		return reserved_clusters_store(sbi, buf, len);
 	case attr_inode_readahead:
 		return inode_readahead_blks_store(sbi, buf, len);
+	case attr_mb_max_prealloc_kb:
+		return mb_max_prealloc_kb_store(sbi, buf, len);
 	case attr_trigger_test_error:
 		return trigger_test_error(sbi, buf, len);
 	case attr_err_report_sec:
@@ -695,4 +722,3 @@ void ext4_exit_sysfs(void)
 	remove_proc_entry(proc_dirname, NULL);
 	ext4_proc_root = NULL;
 }
-
-- 
2.20.1

