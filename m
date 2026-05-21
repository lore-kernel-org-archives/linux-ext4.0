Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069BF3C8C62;
	Thu, 21 May 2026 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368565; cv=none; b=pIsi5BtJDftW6rzizQoAmLYnLBTU/mCU6ARqlTrAy0C5QbUpelpCkN41TMproeC+HiXZBaFP4OxGVKl10P/T5UssJHxRMLRKLjb///PGmU2IOiY9NV8KaqJT306VlRQIbS3AXzJQoobcPDmIITFkfzZ6hIw409j2fUsex9KulWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368565; c=relaxed/simple;
	bh=07BS/sfoUCmWx89F25cUmwlHawWWbzRjqxYiGjByx7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WweEH/qL/sAdoFD/2cWfuSEiZ2lPwqNelij19j/rM2ok3+U/zS1hFuLVXMOMhh7apEQDh57GI6HoWVbtz5i581gPIBjz+7QNFewXpUI1vnHbPrgK0vryuU4CH7fsJje0ORxGNq5n2s2C5xAoQet6qBZyOsacmafO8E82E7paPI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.224.235])
	by frasgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gLpNQ3J7sz1HChB;
	Thu, 21 May 2026 20:57:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.27])
	by mail.maildlp.com (Postfix) with ESMTP id 913214056C;
	Thu, 21 May 2026 21:02:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.224.106.87])
	by APP2 (Coremail) with SMTP id GxC2BwBXm2dJAg9qEcSQAQ--.61947S4;
	Thu, 21 May 2026 14:02:41 +0100 (CET)
From: Bohdan Trach <bohdan.trach@huaweicloud.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: mchehab+huawei@kernel.org,
	lilith.oberhauser@huawei.com,
	Bohdan Trach <bohdan.trach@huaweicloud.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ext4: get ext4_group_desc in ext4_mb_prefetch only when necessary
Date: Thu, 21 May 2026 14:59:29 +0200
Message-ID: <20260521125931.16474-3-bohdan.trach@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260521125931.16474-1-bohdan.trach@huaweicloud.com>
References: <20260521125931.16474-1-bohdan.trach@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:GxC2BwBXm2dJAg9qEcSQAQ--.61947S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1rtrWDJr15Kr1xWF43trb_yoW8Cw1Dpa
	nrCF1UCry3Wrs8u3ySg3y0q3WrJw10gr1UJryfWws5ZFy3JryfXFZ7KF1rZF18AFZxZw1a
	qr15Zr17uF1xC37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUbH5lUUUUUU==
X-CM-SenderInfo: xerkvtvqow2ttfk6x35dzhxuhorxvhhfrp/

Getting ext4_group_desc structure can contribute to the cost of
ext4_mb_prefetch() without any need, as most groups fail the
!EXT4_MB_GRP_TEST_AND_SET_READ check.

Optimize ext4_mb_prefetch by getting the group description only when
necessary.

The result is further increase in performance of fallocate() system call
path that triggers ext4_mb_prefetch() via a linear group scan.

Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>
---
 fs/ext4/mballoc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 25e3d9204233..e60499fb5a14 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2861,8 +2861,6 @@ ext4_group_t ext4_mb_prefetch(struct super_block *sb, ext4_group_t group,
 
 	blk_start_plug(&plug);
 	while (nr-- > 0) {
-		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group,
-								  NULL);
 		struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 
 		/*
@@ -2872,14 +2870,17 @@ ext4_group_t ext4_mb_prefetch(struct super_block *sb, ext4_group_t group,
 		 * prefetch once, so we avoid getblk() call, which can
 		 * be expensive.
 		 */
-		if (gdp && grp && !EXT4_MB_GRP_TEST_AND_SET_READ(grp) &&
-		    EXT4_MB_GRP_NEED_INIT(grp) &&
-		    ext4_free_group_clusters(sb, gdp) > 0 ) {
-			bh = ext4_read_block_bitmap_nowait(sb, group, true);
-			if (!IS_ERR_OR_NULL(bh)) {
-				if (!buffer_uptodate(bh) && cnt)
-					(*cnt)++;
-				brelse(bh);
+		if (group < ngroups && grp && !EXT4_MB_GRP_TEST_AND_SET_READ(grp) &&
+		    EXT4_MB_GRP_NEED_INIT(grp)) {
+			struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
+
+			if (gdp && ext4_free_group_clusters(sb, gdp) > 0) {
+				bh = ext4_read_block_bitmap_nowait(sb, group, true);
+				if (!IS_ERR_OR_NULL(bh)) {
+					if (!buffer_uptodate(bh) && cnt)
+						(*cnt)++;
+					brelse(bh);
+				}
 			}
 		}
 		if (++group >= ngroups)
-- 
2.43.0

