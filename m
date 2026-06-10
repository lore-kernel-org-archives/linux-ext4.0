Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F5632B112;
	Wed, 10 Jun 2026 05:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068169; cv=none; b=jF0WFVCKB32dXAF7UjTW/5mO5V2kOnCOxB1ndUJKAhicLnA1TSy4SgB7eCli0+RiRHyPbHESo9EEC5KLioWDsbYRc64r1fAlH2WQ0UwmJnqjrMnce5yQwT3/07HUr8P3bn6JDYc/7LFKkiizDL52ZtFom/D0c/KJCGkXAOYNOuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068169; c=relaxed/simple;
	bh=wY1/xzUFDBMhvqi2UnZsUIzR6eleQu5mVYb49if05FE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nk5WUubeL8V1V5UL2MAzpQwQ4sRnB4H/v6lNsgkMXjSn0rPyqefNLWfhBRgFNn/WddEQ37UsNuUKbY0FjOTNd4CN3dAXXb39PnFtSL3+hzMzUUZt7jyZMFA78xHMQoqPLT4yQBRTiRrgdv9nIgCIA0L7qtJAWOMbDoLmyvDhYmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=bsTfqkze; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="bsTfqkze"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A3h4kI136221;
	Wed, 10 Jun 2026 05:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=bXavdpV5FBAkKNSxxOLkvVdf/DFn4jq55p6k+WmJ3Xg=; b=
	bsTfqkzeP+zHn0ecuQ0Ki38HHw34zZKst0pJg/hN5ZVuNmaKIBM2wILF5/EQmIvQ
	n0376VsVvqfBAFr/nSKpeu7Z9IGko4iAG8vfkrIU6wODA/nknyvD4dUkY1Qj+XmF
	kx+1KNzF5A9obJrMPE4B+Hju4HwtasE9KrNEniq07DyJ+5Wt4CAzLBs5vPTv0Jm0
	rjDaVjd8RdRFyZF2TGZqbdx6nOfslE50eJrUtcooOZtwf18166UuL3rVALw5VUgI
	GjluVFEW29mENsZM0Jjg429v/T/uEhXVEKoWQlKoxZI2qwxXQmfiA6gCiiFy7tyd
	dK+sz/iqvzUxOq6a2Z5H/Q==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4epwkq86py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 Jun 2026 05:08:43 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 9 Jun 2026 22:08:40 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 9 Jun 2026 22:08:38 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ext4: drop s_writepages_rwsem around ext4_destroy_inline_data
Date: Wed, 10 Jun 2026 13:08:37 +0800
Message-ID: <20260610050837.2768429-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260609154505.2104659-1-yun.zhou@windriver.com>
References: <20260609154505.2104659-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA0NSBTYWx0ZWRfX2mr7GVQlyaGm
 e3DZfPArQl0uHA6QZH8szmVjSBjvlj3FyDDHek1vkxcDZrKw4F4o6ketWeHRkR8PSNCM2vJ1MXL
 dfj72dOBnJ/S5Nc1K0eKi3XjvYMuMElVCYsVI/h0c9Ub8mnyx+EBt5GEbiFi4xMALIpvA+JWUnH
 8y/oTWRbFKhC1iIW4Z+Q/MwPpV5zUJl51L72tBI6iIXzWW46tktPbNmPcyfpZ2+qX6LBt77/fPn
 ZpJ0IzVMXE2bL/DqcHxV/HBqJcRF+Re4JlJTqQkAXmQUKrxbvmG6tdu+Gidvr84q/D0PZOM+ytU
 yBbePEatW22DOCT2hzgUpPG2pfDaWLS3SOxySpWZ/X6rBEXl11co0dYwl8+u86QdTACZA1b9NiJ
 p5ohZNqdryWNjeaS+boPdfHuz8p5dkhUM3A9lf7+n2lkBhn7i8vdmZJnlWdtaPhZJEKoskyXTPI
 CKh1wnGZN+EZui1Mhkg==
X-Proofpoint-ORIG-GUID: CrVSvASnxpCqc4ITAtxVn3__rUlaT4pt
X-Authority-Analysis: v=2.4 cv=eOAjSnp1 c=1 sm=1 tr=0 ts=6a28f15b cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=PexMM_OV13WYALEybcEA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: CrVSvASnxpCqc4ITAtxVn3__rUlaT4pt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100045

ext4_do_writepages() calls ext4_destroy_inline_data() which acquires
xattr_sem while s_writepages_rwsem is held (read).  This creates a
circular lock dependency:

  CPU0                               CPU1
  ----                               ----
  ext4_writepages()
    ext4_writepages_down_read()
      [holds s_writepages_rwsem]
                                     ext4_evict_inode()
                                       __ext4_mark_inode_dirty()
                                         ext4_expand_extra_isize_ea()
                                           ext4_xattr_block_set()
                                             [holds xattr_sem]
                                             iput(old_bh inode)
                                               write_inode_now()
                                                 ext4_writepages()
                                                   ext4_writepages_down_read()
                                                   [BLOCKED on s_writepages_rwsem]
    ext4_do_writepages()
      ext4_destroy_inline_data()
        down_write(xattr_sem)
        [BLOCKED on xattr_sem]

Fix by temporarily dropping s_writepages_rwsem around the call to
ext4_destroy_inline_data().  This is safe because:

 - This code runs before any block mapping or IO submission, so no
   writepages state depends on the rwsem being held at this point.

 - Inline data destruction is a one-way format transition (once cleared,
   EXT4_INODE_INLINE_DATA is never set again).  The rwsem is
   re-acquired immediately after, ensuring format stability for the
   remainder of writepages.

 - The can_map flag naturally identifies the ext4_writepages() path
   (holds rwsem) vs ext4_normal_submit_inode_data_buffers() (does not),
   so the drop/reacquire is skipped when the rwsem is not held.

Also check the return value of ext4_destroy_inline_data() -- previously
ignored, a failure would leave inline data intact while writepages
proceeds assuming block-mapped layout.

Reported-by: syzbot+bb2455d02bda0b5701e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v2:
 - Instead of moving inline data handling to ext4_writepages(),
   temporarily drop s_writepages_rwsem around ext4_destroy_inline_data()
   in ext4_do_writepages(). The move approach had a race where concurrent
   writes could create dirty pages with inline data after the early check,
   and unconditional destruction without dirty pages would lose data.

 fs/ext4/inode.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..7ec16adf4685 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1694,6 +1694,9 @@ struct mpage_da_data {
 	struct writeback_control *wbc;
 	unsigned int can_map:1;	/* Can writepages call map blocks? */
 
+	/* Saved memalloc context from ext4_writepages_down_read() */
+	int alloc_ctx;
+
 	/* These are internal state of ext4_do_writepages() */
 	loff_t start_pos;	/* The start pos to write */
 	loff_t next_pos;	/* Current pos to examine */
@@ -2824,8 +2827,21 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 		}
 		BUG_ON(ext4_test_inode_state(inode,
 				EXT4_STATE_MAY_INLINE_DATA));
-		ext4_destroy_inline_data(handle, inode);
+		/*
+		 * Temporarily drop s_writepages_rwsem because
+		 * ext4_destroy_inline_data() acquires xattr_sem, which has
+		 * a higher lock ordering rank.  Holding both would create a
+		 * circular dependency with ext4_xattr_block_set() -> iput()
+		 * -> ext4_writepages() -> s_writepages_rwsem.
+		 */
+		if (mpd->can_map)
+			ext4_writepages_up_read(inode->i_sb, mpd->alloc_ctx);
+		ret = ext4_destroy_inline_data(handle, inode);
+		if (mpd->can_map)
+			mpd->alloc_ctx = ext4_writepages_down_read(inode->i_sb);
 		ext4_journal_stop(handle);
+		if (ret)
+			goto out_writepages;
 	}
 
 	/*
@@ -3032,13 +3048,12 @@ static int ext4_writepages(struct address_space *mapping,
 		.can_map = 1,
 	};
 	int ret;
-	int alloc_ctx;
 
 	ret = ext4_emergency_state(sb);
 	if (unlikely(ret))
 		return ret;
 
-	alloc_ctx = ext4_writepages_down_read(sb);
+	mpd.alloc_ctx = ext4_writepages_down_read(sb);
 	ret = ext4_do_writepages(&mpd);
 	/*
 	 * For data=journal writeback we could have come across pages marked
@@ -3047,7 +3062,7 @@ static int ext4_writepages(struct address_space *mapping,
 	 */
 	if (!ret && mpd.journalled_more_data)
 		ret = ext4_do_writepages(&mpd);
-	ext4_writepages_up_read(sb, alloc_ctx);
+	ext4_writepages_up_read(sb, mpd.alloc_ctx);
 
 	return ret;
 }
-- 
2.43.0

