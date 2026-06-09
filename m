Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46E536CDEB;
	Tue,  9 Jun 2026 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781019954; cv=none; b=R2t+DEvh43lltqmFHW6kBhv+McaDumAc2rQrbCZ0jsZkoGz/MtSGkVTWiHGh2QbaRsBYtvEYnDDP+3JJvahAKpPWjm5fzUNARvtqF9wMOGL0MWDu1bMNzrx+8QLXNIFH25nz25++YbCn3FQ1Xt3u2hCI6qa0o51XK4I94ZH4qy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781019954; c=relaxed/simple;
	bh=AG1j9wBNsruCAB2gD/jdW+DPxl474x/ejrfORbQrz9E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WBD++0S7nvU/rRPBfup2hmGdIeZv6QzYWOy4IBN3cZXyTVY2ETPMRS1TTGRF/OZWRYbm8RX81vHd5D0UwHkQR5vzwk7Q2N6gvYzA/dhHGxx5eDlYmUIE4ewb3XWcWrBuEQdg5xAFlnP3JKz45kCLed9Tn6lwk4+i8l+eSpo0YIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=aFNeHX6E; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="aFNeHX6E"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 659Cr1sS2794272;
	Tue, 9 Jun 2026 15:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=PaN2GNmC2
	sLv/9kbv+sdnd+wv9E0naKBK46mqiF91VI=; b=aFNeHX6EyLjHQU+ZQUzEdND4l
	i4jSdWIEWMrniYXimL2IyJ9ctUITOI9YjNHD69DK7+80Tw93j8iGBB9wOix/5kSD
	VzgOpUO6nvIeMYY00Rkbgt4RCIOe0BQO0Y+kz/r13iUlTM40pneabHLypjtq+NJj
	Ed4MlesB/gbyPNbSMn6RY8AsrLDF1axP2mE/Wk/hGYmp/+TlRPsDXn2ozDSV2a4O
	npyyGLVgLEVpWMsXCNsWZFhENh9CHkx/9IILE2Ih71jqoyBfgsH5Y7befi0QYgbc
	PPPmXw15Dq33gb9hBOIueNFvlfIlTDeMdDlbJPvjoW7TBEDI8sc7miuT+B3bg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4em8rxmwgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 09 Jun 2026 15:45:10 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 9 Jun 2026 08:45:09 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 9 Jun 2026 08:45:06 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <daeho.jeong@samsung.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] ext4: move inline data cleanup to ext4_writepages to fix deadlock
Date: Tue, 9 Jun 2026 23:45:05 +0800
Message-ID: <20260609154505.2104659-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HZvCq8P4JCj0woNcPwapPW9ftwJw_enM
X-Authority-Analysis: v=2.4 cv=FP8rAeos c=1 sm=1 tr=0 ts=6a283506 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=MzcaG34XF0Z6mWSAjsQA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: HZvCq8P4JCj0woNcPwapPW9ftwJw_enM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDE0OSBTYWx0ZWRfX5aUBNAiWeMf+
 35AtK6VUgnKqfvcj3ugc+9AxvbBj5uFHWFObEVjQExd5vRO6UGpEY8pSd8Skxw3t0bdPMlYBji0
 NolM3NULblurVaqJ2iEKV2VZLbo8eKAmeAYqjHyGp01/qoa41fJLxZ109MJ9n96U7TUUTPT9JRR
 peYc/TxKspRvxzl2RnQBQ9gULZTUoAwLklxC3n4kqRj5Z9IlqUXWnDCQZNMRI60wiZfwDGCZZQt
 Z/rrpJ/CRjXdajoZlMulLNjffUjfrQN9GN9IDjcrZrcpx+UkGq9oi3n+68g3byq3F8gPTLRdlca
 bfaQOwhT85LXDfQpRt/uMSbrGYzHPZStqT8JxI0W5JO5ayh9RVcG6GFnf8DA5jwYh0TRpc7eRQB
 Z6R1lYyuII8gDi/fymleGmIfkRXjFsIS4N1bDLsGArQw9eSqf7s9tGdN5QPgjSspOw0gx+dAFWI
 4PGYC4PvdYFB7HJsJFg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1011
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606090149

ext4_do_writepages() calls ext4_destroy_inline_data() which acquires
xattr_sem while s_writepages_rwsem is held (read).  This creates a
circular lock dependency with the xattr writeback path:

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

Move inline data destruction from ext4_do_writepages() into
ext4_writepages(), before acquiring s_writepages_rwsem.

This is safe because the other caller of ext4_do_writepages()
(ext4_normal_submit_inode_data_buffers, invoked by jbd2 during commit)
can never encounter inline data: jbd2 only tracks inodes with
block-mapped dirty ranges registered via ext4_jbd2_inode_add_write(),
and all such registration paths either explicitly bail out when inline
data is present (ext4_journalled_write_end) or are logically
unreachable for inline data inodes (ext4_map_blocks requires block
allocation, ext4_block_zero_eof requires existing blocks).

Reported-by: syzbot+bb2455d02bda0b5701e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inode.c | 47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..0c7461ab4fd0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2810,24 +2810,6 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	if (unlikely(ret))
 		goto out_writepages;
 
-	/*
-	 * If we have inline data and arrive here, it means that
-	 * we will soon create the block for the 1st page, so
-	 * we'd better clear the inline data here.
-	 */
-	if (ext4_has_inline_data(inode)) {
-		/* Just inode will be modified... */
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out_writepages;
-		}
-		BUG_ON(ext4_test_inode_state(inode,
-				EXT4_STATE_MAY_INLINE_DATA));
-		ext4_destroy_inline_data(handle, inode);
-		ext4_journal_stop(handle);
-	}
-
 	/*
 	 * data=journal mode does not do delalloc so we just need to writeout /
 	 * journal already mapped buffers. On the other hand we need to commit
@@ -3038,6 +3020,35 @@ static int ext4_writepages(struct address_space *mapping,
 	if (unlikely(ret))
 		return ret;
 
+	/*
+	 * Clearing inline data acquires xattr_sem, which ranks above
+	 * s_writepages_rwsem.  Do it here before taking the rwsem to avoid
+	 * a circular dependency:
+	 *   ext4_writepages (s_writepages_rwsem) -> ext4_destroy_inline_data
+	 *     (xattr_sem)
+	 *   ext4_xattr_block_set (xattr_sem) -> iput -> ext4_writepages
+	 *     (s_writepages_rwsem)
+	 *
+	 * This is only needed in the ext4_writepages() path.  The other
+	 * caller of ext4_do_writepages() -- ext4_normal_submit_inode_data_buffers
+	 * (jbd2 commit callback) -- cannot encounter inline data because jbd2
+	 * only tracks inodes with block-mapped dirty ranges registered via
+	 * ext4_jbd2_inode_add_write(), and all such callers either bail out
+	 * for inline data inodes (e.g. ext4_journalled_write_end) or are
+	 * unreachable for them (ext4_map_blocks, ext4_block_zero_eof).
+	 */
+	if (ext4_has_inline_data(mapping->host)) {
+		handle_t *handle;
+
+		handle = ext4_journal_start(mapping->host, EXT4_HT_INODE, 1);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+		BUG_ON(ext4_test_inode_state(mapping->host,
+				EXT4_STATE_MAY_INLINE_DATA));
+		ext4_destroy_inline_data(handle, mapping->host);
+		ext4_journal_stop(handle);
+	}
+
 	alloc_ctx = ext4_writepages_down_read(sb);
 	ret = ext4_do_writepages(&mpd);
 	/*
-- 
2.43.0

