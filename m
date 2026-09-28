Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195954AC14E
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 11:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595630; cv=none; b=gRT9DnIoGzuVe6YpZ4J4NEi1e2qq0ZURmB6vmrg5eNALzMawaCEZ7R9+rx1dShlFfI5syRLhMp0/YnmXJyvpfaq5xP5HFiazEkJfjff8Jlshx3njco+9Wy+VsX90j6okCuVrV0bIvZqupk1u/DyHiKMREPeFdrUaCI080tiBQCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595630; c=relaxed/simple;
	bh=Lzr5bEcyEtqxOcsi0a6Wx4YdU9NF9pl4pgfrg72dBeU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=HMzG4fJj2GtIni81hH2tRztFLH0j4gqPQ9I6GQwl7y/iR+DC6vKBkb0Mt6IoU1ljAhKWXA2GnHInHKciSEtELhkdv93v0P/L14XgueSVk9M8bjlCfzq9BLDm0noeVApmm8UMn0CkwleShRo6OA41CCmm5Ui9ygu0x4xxUlnUhNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=URGaXcjk; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="URGaXcjk"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-144f7915355so2440565c88.3
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 04:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790595628; x=1791200428; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xOrrX4VASxwxOHIje5fqVHmltt8bEneArNzq9Pnrg3Y=;
        b=URGaXcjkTBf7gnd63ov5D8Xti1JAlEd7m6aJVQQlZiEpmRoBLZsKj+qCyMJQhFTpwj
         hIrN3g6nnLoHfB+GJm7W+Z6VAkQ2GbXZe4rWAdF5w66MaS/aMa2z9f/ar0M7IFtohf+H
         DJYClU3ZFJLSTONZY16xMJEjrt51BTPW/2ObGLFew2/63e3ZkO7sQUgDzkoaU4wIW3wV
         BP+P5qVP4F5Sqd6TYciM1YuF2Kjm/REl3oesCSB3cH1lOp31Ih2tgUBJb9PDTC06Xn+j
         Po5ryvYm/l0QQb48WhPUCC06jrhliBERXbQRydYRWoyCdjMe9fY4lHERZbO+J+CUGGK4
         u7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790595628; x=1791200428;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xOrrX4VASxwxOHIje5fqVHmltt8bEneArNzq9Pnrg3Y=;
        b=eaMdslTyvXDI26OKLre2IeSSQRPo1acMfE/wIc4hgBl0b2qzAizjMP9wR8n6zzPTI+
         h6jzk056woyQFY6PTFagmpcxzVswKBuA9ZOZqYiV8Eef5waO3ICO0UR5oqWt7KGKqaSN
         kR+Ycz3STelNSy2/OlZRmJ7VeKsAuEORAW7XQh2PglxwYldrtI+k0vpF7NOx+RnDlN58
         80oCRTmZQdulPscrz6m2Ww3qyQBTrdzzBqfzi3vkvtBuP4ZbxSY1CeuRJK2KG27gogxw
         urHImNfH1JkfMJoaLRMl14UAtlWOBuuJ7rXy8/JHgWZKG/M8R2hN96Kr8GBijolxUmiy
         pQaQ==
X-Gm-Message-State: AFuF++kQnV7E/f5l5rWOojGKGTTOGrpBaq2orUEgsJOsrB4D/flX9k0q
	hAm44CzlzGl1nmwrbvUrhah7llzUijCpop+Pusw/2Bq1aF8fcaO7lRaC
X-Gm-Gg: AYBFou1406tDuRXZ3EtF3zipBTm49pu9rG+oH6qice74MYG8pTTFo1fl3NbHNZJ7/RO
	C3bVzrNk9O8aEZYRypzYHgiVXvHQjBZf1ErvUuUS1qZ5XDzPC/HtD6RLeCIUdcSI0XunBUrH9Nl
	HGViJIGdKEX0QX+NyluypflvqtdIGkMVGsxaKIdi8KdFElSuGXwieWUzP/3lVV2Vu50BQjij3rd
	Wq2Wiw+ZF9K/MrbbXeJ/xV6Zd+KXK06v2b1K4veX3sqJKQghIz/WdfOz3Sf6b9xu8E0to5v+MHg
	IgITLUfiGD4oAjfI3utE9igETmUh3fZh3a45vE8GSk+RVD20mM5wqGLKqnIOxRlIiYHnmcHtJlD
	48uF1k+vFnfGvbO7IlD7C7IH1kPaQkiJDtQGkxQHIgHrKEaGI7DS1ZIMTWY5crXXcXZ3o5Xgwtn
	DCOHQni/zgkVSbVUt061bBzFojZGofFWM42XXYeHxQpnSfKfLs7xzEj24HcDc8AvkDwZP8bB5VL
	0yfog==
X-Received: by 2002:a05:701b:2902:b0:143:56f8:dc5 with SMTP id a92af1059eb24-146cfec877bmr9086036c88.23.1790595628009;
        Mon, 28 Sep 2026 04:40:28 -0700 (PDT)
Received: from [127.0.1.1] ([47.88.22.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ac67c3f8sm24289375c88.3.2026.09.28.04.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 04:40:27 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 28 Sep 2026 19:40:21 +0800
Subject: [PATCH] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com>
X-B4-Tracking: v=1; b=H4sIACVSumoC/x2MSQqAMAwAvyI5G6ilrl8RD6VNNZcojYgg/t3ia
 RgY5gGlzKQwVQ9kulh5lyJNXUHYvKyEHIuDNbYzox0w8Y10nw5JUYMXlPxTKGLrU29651IXIpT
 Dkank/31e3vcDq4kNiG0AAAA=
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

The extents_status shrinker's count_objects() callback,
ext4_es_count(), reports the number of shrinkable extent_status
objects via a percpu counter. do_shrink_slab() reads this count
exactly once per invocation and derives a one-shot scan budget
(total_scan) from it, then repeatedly calls scan_objects() in
fixed-size batches until that budget is exhausted.

ext4_es_scan() never updates sc->nr_scanned, even though
include/linux/shrinker.h documents that "the callee should track
its actual progress" in that field. Because sc->nr_scanned defaults
to sc->nr_to_scan before every call, do_shrink_slab() always
believes a full batch was examined, regardless of what __es_shrink()
actually did. When __es_shrink() hits an empty sbi->s_es_list and
returns immediately having examined nothing, do_shrink_slab() has
no way to tell "there was nothing to scan" from "a full batch was
scanned and none of it was freeable". It keeps calling scan_objects()
until the original, one-shot total_scan budget is drained, even
though the shrinkable list emptied out long before that budget was
used up.

Make __es_shrink() report the number of extent_status objects it
actually examined through a new nr_scanned output parameter, derived
from the existing per-extent nr_to_scan counter that es_reclaim_extents()
already decrements as it walks the tree. Have ext4_es_scan() copy this
value into sc->nr_scanned, and return SHRINK_STOP once nr_scanned comes
back as zero, since that only happens when sbi->s_es_list was already
empty and no further calls in this reclaim pass can make progress.

Tested by fallocate(2)-ing 10000 4K files (to populate the shrinker
with reclaimable unwritten extents without also exercising the
extent_status "referenced" second-chance path, which needs a
separate two-pass accounting of its own) and triggering
"echo 2 > /proc/sys/vm/drop_caches", while tracing the
ext4_es_shrink* tracepoints:

                      total scan_objects()   calls with
                      calls                  nr_shrunk == 0
  before this patch   429                    189 (44%)
  after this patch    165                    1 (0.6%)
  after (rerun)        242                    1 (0.4%)

nr_skipped stayed at 0 throughout every run, confirming the wasted
calls came from the stale one-shot budget racing ahead of the real
list state, not from the existing precached/trylock skip paths.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 fs/ext4/extents_status.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..05ded0c018e08 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -184,7 +184,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      struct extent_status *prealloc);
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-		       struct ext4_inode_info *locked_ei);
+		       struct ext4_inode_info *locked_ei, int *nr_scanned);
 static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
 			    ext4_lblk_t len,
 			    struct pending_reservation **prealloc);
@@ -1670,7 +1670,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 }
 
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-		       struct ext4_inode_info *locked_ei)
+		       struct ext4_inode_info *locked_ei, int *nr_scanned)
 {
 	struct ext4_inode_info *ei;
 	struct ext4_es_stats *es_stats;
@@ -1679,6 +1679,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 	int nr_to_walk;
 	int nr_shrunk = 0;
 	int retried = 0, nr_skipped = 0;
+	int orig_nr_to_scan = nr_to_scan;
 
 	es_stats = &sbi->s_es_stats;
 	start_time = ktime_get();
@@ -1738,6 +1739,8 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		nr_shrunk = es_reclaim_extents(locked_ei, &nr_to_scan);
 
 out:
+	*nr_scanned = orig_nr_to_scan - nr_to_scan;
+
 	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
 	if (likely(es_stats->es_stats_scan_time))
 		es_stats->es_stats_scan_time = (scan_time +
@@ -1774,15 +1777,30 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
 {
 	struct ext4_sb_info *sbi = shrink->private_data;
 	int nr_to_scan = sc->nr_to_scan;
-	int ret, nr_shrunk;
+	int ret, nr_shrunk, nr_scanned;
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
-	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
+	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL, &nr_scanned);
+	sc->nr_scanned = nr_scanned;
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
+
+	/*
+	 * es_stats_shk_cnt is a percpu counter, so count_objects() can report
+	 * a stale/approximate value that is still positive even though
+	 * sbi->s_es_list is actually empty by the time we get here. When that
+	 * happens __es_shrink() returns immediately having examined nothing
+	 * (nr_scanned == 0). Without SHRINK_STOP, do_shrink_slab() has no way
+	 * to tell "nothing was there" from "nothing was scanned yet" and will
+	 * keep calling us with the same stale freeable count until its scan
+	 * budget for this priority level is exhausted one batch at a time.
+	 */
+	if (nr_scanned == 0)
+		return SHRINK_STOP;
+
 	return nr_shrunk;
 }
 

---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260928-fix-ext4-es-scan-nr-scanned-5af70744f6cd

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

