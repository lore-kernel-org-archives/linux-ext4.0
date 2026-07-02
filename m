Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C30143E9C4;
	Thu,  2 Jul 2026 08:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981590; cv=none; b=TZy9zWW5WHbF0vVANruqMBRFl+51DEe9Hi4NEzrasvGA3qaKwVuk6TNuW3yHre0szx0XjPUkAldwgMtQf5YEI9flejle1QP+LHwBcuCW4GD3bL8hv3i5rx69vbmLhXCrBwiluNG5nQh0A2/lX+tQqHyqvkkS11QyVB7AXLCrJ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981590; c=relaxed/simple;
	bh=2PU9Hj2Ar9zyW2tsM1lW8lFQlrR0QMUjJcZks/8jRII=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sMkwCRLKAWOQyQFXpQzHzD/Qag0vofK/NjAuk5foY9tlvU9c05ItLkOljc66LVrXBNMGzp6HKFjObb8vTf18SLx+rQxzgVZ+bniUR7yLALLMscWXYrkxDMkliOrG4CcW1lt1IE89PS3xlw+bjtWCdIpbsAWTpKDjYFC6ZUGWsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=NCJJ3OgZ; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="NCJJ3OgZ"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6625m9ds1143942;
	Thu, 2 Jul 2026 01:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=jLqJy1Z7K
	e/sVQaiZRjJmyEuiZoFV+1m/yeLRSs8Lq4=; b=NCJJ3OgZiVcuWvjpeqA1C+Gv2
	ziBuXyXAehzUTw5jYJHf4QGJzRa/2z9mer9Dmwd+gnY+nN/1G3QG5Tail6I54QcX
	kW2S2plJzmuUCjSxgMNsH1S0YWPxz2P3G8STiYHLI+4rZXPQg1a6mwL+k1h4jp9I
	XJNSXJs9fezsDFrbutjqz3TrkZSFoDofPUGVZKMUTDmLy0FS5on7GwgX9n1+BHOZ
	jN3MY8Re37uvihJeq2wJZ9wNOaw5irrYfLVuTops8hBGs7tSgj8c+Jlq5dWtHz5V
	mTsQGjeYx1Z9ZvG59aiSS7KwUBomMjWK6IBopomt7yz0+iax2DKD7OxPwkIUQ==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f2e1gy233-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 02 Jul 2026 01:39:11 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 2 Jul 2026 01:39:10 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 2 Jul 2026 01:39:08 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v2] ext4: fix race in ext4_convert_inline_data() leading to BUG_ON in writepages
Date: Thu, 2 Jul 2026 16:39:07 +0800
Message-ID: <20260702083907.1638421-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: uGaNaAKfeYFHbBpx1sitsj9XZzatjj62
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDA4OCBTYWx0ZWRfX1iauhDo8e3pM
 PFpEUDaUTqn1Cx4usu5Ou3UJL2W34OO90oyxB10N7vvDnZVeDxErIPUbjLwwM+DKQPTD8zbnzLX
 mxSgg6L5cRzEbY05hP0VapSbAKTbXHaSu2gGmy8Qm3O2HN2reCkC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDA4OCBTYWx0ZWRfX6i+g1B6wFLVj
 HhamTLbefapFIB5lIS2PGz6KZ/GJOROoysx7abNq1j6Ib4P11psw13WRd34SoMFFJMROersktK4
 Yid1RM8It5I5OUmK0YdhIwOh96QsK+vollrv0tiy0o3HJOriYwtfP8k1L7qxGD5ptHjk+gzF/Wg
 wGlQ4OfsUuVGKMsLmDbWrlBsrusC2+S6rzf42mGi8rFEr6aM8PGbxSUqdWYIm6p5LXjYIgj8dCo
 9js/edQxyc5MkOLqe09Y0eqLDSqxcwCKlKWCKmyvRZIsUILxmrfC5ok+69W4/hx130jELlRho16
 lrdOEdu2v1NSmQ6NjG8geoGeeNUIJ46mWAiAImMfEpcAUMt4mBrAJB3SsGQ0N6RgIRzQMlSzDkc
 XdS6yCfcZeDCaJqWHBajSSrPm5NrXgdCXtpSFCHjiO7FNmDAyRNwymtbw4ikTQ/QArtKuT9YMrX
 flprT9qnCa88HdgCg5A==
X-Proofpoint-GUID: uGaNaAKfeYFHbBpx1sitsj9XZzatjj62
X-Authority-Analysis: v=2.4 cv=GsByPE1C c=1 sm=1 tr=0 ts=6a4623af cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=oEAI9EPlwJH1qtimUqwA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020088

ext4_convert_inline_data() has two unsafe lockless fast paths:

1. if (!ext4_has_inline_data(inode)) {
       ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
       return 0;
   }

2. if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
       filemap_flush(inode->i_mapping);
       if (!ext4_has_inline_data(inode))
           return 0;
   }

Both paths can observe a transient state from a concurrent
ext4_convert_inline_data_nolock() that has called
ext4_destroy_inline_data_nolock() (clearing both the inline data inode
flag and MAY_INLINE_DATA) but then fails in ext4_map_blocks() and
restores inline data via ext4_restore_inline_data() (re-setting both
flags).

A racing thread in ext4_page_mkwrite() sees !has_inline_data and
!MAY_INLINE_DATA (the transient destroy-before-restore state), concludes
that no conversion is needed, and proceeds to block_page_mkwrite()
which creates dirty pages.  Meanwhile the first thread restores inline
data and MAY_INLINE_DATA.  This leaves dirty pages coexisting with
inline data + MAY_INLINE_DATA, triggering the BUG_ON in
ext4_do_writepages().

A similar race exists with ext4_da_convert_inline_data_to_extent():
it copies inline data to page cache and clears MAY_INLINE_DATA under
a read lock.  After releasing the lock, a concurrent
ext4_convert_inline_data_nolock() can restore MAY_INLINE_DATA, again
leaving dirty pages with MAY_INLINE_DATA set.

Fix this by:
1. Removing both unsafe lockless fast paths entirely.  For filesystems
   without the inline_data feature, return 0 immediately.  For all
   other cases, take xattr_sem write lock to check state.
2. Only calling ext4_convert_inline_data_nolock() when both
   has_inline_data AND MAY_INLINE_DATA are set.  When has_inline_data
   is set but MAY_INLINE_DATA is clear, a DA conversion is already in
   progress -- just return 0 and let writeback finish the job.  This
   prevents destroy+restore from racing with the DA convert path.
3. Clearing MAY_INLINE_DATA inside the lock only when has_inline_data
   is confirmed false.

Fixes: 7b4cc9787fe3 ("ext4: evict inline data when writing to memory map")
Reported-by: syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v2:
- Reworked fix: root cause confirmed via ftrace.
- Removed both unsafe lockless fast paths, serialize under xattr_sem.
- Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
  progress) to prevent destroy+restore from re-setting MAY.

 fs/ext4/inline.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..87fee117dcc1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1959,22 +1959,8 @@ int ext4_convert_inline_data(struct inode *inode)
 	handle_t *handle;
 	struct ext4_iloc iloc;
 
-	if (!ext4_has_inline_data(inode)) {
-		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (!ext4_has_feature_inline_data(inode->i_sb))
 		return 0;
-	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
-		/*
-		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
-		 * cleared. This means we are in the middle of moving of
-		 * inline data to delay allocated block. Just force writeout
-		 * here to finish conversion.
-		 */
-		error = filemap_flush(inode->i_mapping);
-		if (error)
-			return error;
-		if (!ext4_has_inline_data(inode))
-			return 0;
-	}
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
 
@@ -1990,8 +1976,22 @@ int ext4_convert_inline_data(struct inode *inode)
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	/*
+	 * If has_inline_data is set but MAY_INLINE_DATA is clear, a
+	 * concurrent ext4_da_convert_inline_data_to_extent() has already
+	 * copied the data to page cache and will finish conversion via
+	 * writeback -- skip convert_nolock to avoid destroy+restore
+	 * re-setting MAY_INLINE_DATA behind its back.
+	 *
+	 * Clear MAY_INLINE_DATA if inline data is gone (convert succeeded
+	 * or was already completed).  Do not clear it if convert failed
+	 * and inline data was restored.
+	 */
+	if (!ext4_has_inline_data(inode))
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
 out_free:
-- 
2.43.0

