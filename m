Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434375;
	b=nHfVM6g5E50eFLNhKiNT9tAwBxlxa56B9XsGKMWTfZGytJYDR74J6tGPrEf+fQWISgVB
	 FSVzMvI6b8elBxuIs/0vXF8RU/KF5juHRmlg/05nTBsIiMWwBnJwl5hBoOz8yu9VJh89m
	 7m4dvTQEtT2qTs5O05psw2YRJID+JHuXiEKnsmwuETziHuw/MT55Ajr3P/xLa63HM8O8k
	 f7fgvMOlh3fgU2x1qvpzkFZ29KtEbR8rcm/lHzoXxxvtOJwhP+9Q9Dn8LIBSTiT0y+3Lk
	 u6dzwGUqe2N7H9Z8dyhQp1UWnstMlgoH4KAPz3KOnHx7a6XnaTbVhBhbuSvkJQ5AAgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434375;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=NLrYGFcyxR54trWRMWcMlWuK9FRnOuacJLrlghD9jFU=;
	b=T2eZ78OmUkH7gBJjLjc43qfoSjpI71upAYI+oxdht5GMJ9MLg0KNjeOEcCNeKMCinaCB
	 WQxh+RSeI3Nf8ln//wtZg6KY4GnlSPkOjiluj8FKMFJGqYOHMgNkru73IcqYfE4gRq66e
	 bs9x/xvcM8BM9NrGyGi1/eTrNWEdQup0QR9bf2cGzdL9xlESPVoSGW463L+FbRix4/LBl
	 T2qPVObXLl6X5gF6a0HQ4bgrsflYFRrGRBM3yis6Xp9Zpn+8kIiDuD/fQLn7RhI69xTet
	 vZj9/sShz4yx6lkUl2JUZ3EO9gD1WoZnVORm7RmUqdmX+qFomxbR79iZ0n5NY8lXGyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF379606A31F
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 11:46:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF379606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jY3yl5TQtz200b
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 19:45:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 27C8C40561
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 19:46:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3L+96JwRrrv_xFQ--.11452S4;
	Mon, 23 Nov 2026 19:46:03 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	brauner@kernel.org
Subject: [PATCH] ext4: protect ext4_acquire_dquot against freezing
Date: Mon, 23 Nov 2026 19:46:02 +0800
Message-Id: <20261123114602.66520-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3L+96JwRrrv_xFQ--.11452S4
X-Coremail-Antispam: 1UD129KBjvJXoWxuFy8Cw4xKF4DCw1UXw4rGrg_yoW5uF47pF
	Z3ZFs8tFWqq34xu397Ca1fC34rtw10ga47JF92gr98XFs8X3W8KF1xK34Y9Fy5ArWfurn0
	qF42k34DGw42yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

A writable open of a regular file reaches the filesystem's ->open()
callback without holding any superblock write (freeze) protection, but
ext4_file_open() -> dquot_file_open() -> dquot_initialize() may need to
acquire a dquot and write the quota file.  If the filesystem reaches
SB_FREEZE_COMPLETE in that window, ext4_journal_check_start() hits

	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);

and the open then sleeps in jbd2 until the filesystem is thawed.

The background and the earlier discussion of this problem are described
in:

  https://patchwork.kernel.org/project/linux-fsdevel/patch/20261112135245.3347102-1-yebin@huaweicloud.com/

The initial attempt added mnt_want_write() for every writable open of a
regular file in do_open().  Christian Brauner pointed out that this would
make a plain open(O_WRONLY|O_RDWR) on a frozen filesystem block even when
it never writes -- log files, editors and backup tools would hang rather
than fail on a later write, which is a drastic and unacceptable uapi
change.  As Jan Kara noted, the write comes from the quota acquisition
path, so it should be fixed there instead of penalizing the whole VFS
layer.  Jan also suggested using sb_start_intwrite() in the filesystem's
.acquire_dquot method, which neither deadlocks nor changes VFS semantics.
ocfs2 is already fine because ocfs2_start_trans() takes sb_start_intwrite()
itself, so only ext4 needs the fix.

Protect the quota acquisition path itself: take sb_start_intwrite()
around ext4_acquire_dquot() when no transaction is already running.
Running transactions are already protected against freezing and taking
sb_start_intwrite() inside one can deadlock.

Fixes: 907f4554e252 ("dquot: move dquot initialization responsibility into the filesystem")
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20261112135245.3347102-1-yebin@huaweicloud.com/
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/super.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d0415e5948e1..fc63219f5972 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7110,11 +7110,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 {
 	int ret, err;
 	handle_t *handle;
+	bool freeze_protected = false;
+
+	/*
+	 * Trying to sb_start_intwrite() in a running transaction
+	 * can result in a deadlock. Further, running transactions
+	 * are already protected from freezing.
+	 */
+	if (!ext4_journal_current_handle()) {
+		sb_start_intwrite(dquot->dq_sb);
+		freeze_protected = true;
+	}
 
 	handle = ext4_journal_start(dquot_to_inode(dquot), EXT4_HT_QUOTA,
 				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		if (freeze_protected)
+			sb_end_intwrite(dquot->dq_sb);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_acquire(dquot);
 	if (ret < 0)
 		ext4_error_err(dquot->dq_sb, -ret,
@@ -7123,6 +7137,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
+
+	if (freeze_protected)
+		sb_end_intwrite(dquot->dq_sb);
+
 	return ret;
 }
 
-- 
2.34.1

