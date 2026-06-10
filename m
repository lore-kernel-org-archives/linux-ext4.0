Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E6A379C3F;
	Wed, 10 Jun 2026 06:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781073792; cv=none; b=i05lrSSk9epfqazfMNjplf8a6fXUOJEAWPvqVsClmB+hiIPBeMAeTTjvh+ulKYUTVVJFxMJ5OmqtRv5I0Oow4Cy4Yl04rbJgqp5mp8Ur9C+Z1UnUe4/+GwDdasHnz/6jU7Ydgp3g9CyScm99BFxHyN0WNuQFWfhAft5ZRoIKEaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781073792; c=relaxed/simple;
	bh=fD7S+j4dBXGvPVPnKXk5HbR3FaikKlQ1GQ3woaiex5E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKMTjONMOwYIyT5oCSayFJBpoGA486DDdtN6mNUKnMsuw1im1ypUyO0090kvhQQI3C2Tt9o9MVOqmW8gBao2fCWy54PI7FH5mrFeUTyQ+Ccv4+nLCGJV3unhs5sfjDGoVxbNiXDTM2ImlMZQPM3VHA8ESNgQuaSWadj+sW9Y6v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=pLrDnuOY; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="pLrDnuOY"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A5nPXY353212;
	Wed, 10 Jun 2026 06:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=2COof7nKzxniXU0wu3qy33JexswggqQ8KVLk7O6LtVQ=; b=
	pLrDnuOY8p2u/GF8CUMVgN3F7k1N9t52VIEShxBi34WW86DwMjvegqvXF0CR3CVr
	tb7ldvjnVItj7C6fgrkfFQaFPtQRWyP1EM5bENBx1LYapI7v2TnA+OrvdqKwE8VE
	ARLo8xT8RytwPaS+NDUK8VwjuyuYXennp/q5ewooBcf1qlVZUqkpLfeDMKf7Gnuf
	V3yerWLBipp10TjLAuoIa1L8ir5ZxeUPRutDe3cFDMpxN6FjtOpQ88hHgEOU3AQR
	SPrXvNq03+t10xXUThhSxHhhat4i0NvGIlB8gvMRWYQkGf4EXbmseEz0JGQOQ/Uv
	lHNktBiTZ+nudWf8WCaGzg==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4epwkq88t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 Jun 2026 06:37:33 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 9 Jun 2026 23:37:32 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 9 Jun 2026 23:37:29 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ext4: drop s_writepages_rwsem around inline data handling in writepages
Date: Wed, 10 Jun 2026 14:37:29 +0800
Message-ID: <20260610063729.3294915-1-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA2MCBTYWx0ZWRfX46/fb7uAThm4
 gUZwxP7NYnAAbAATFfAHp+1MN5vW4pNOlB5xpAP6szv+l6R10WOOUEAkBufglEyd9Q7Vi0aQrtM
 +0s40BZGMbwi1KmS+rgLSYtwa/uceYnkxDbefoN1of2L7boWsZbI13vp1XR/EX19pIOOxTPwbXn
 odMIUN2SiZ3AOgkwEa29IPSaa2FDxZg03HVuJFPs8NkkJTFLlFQHwci3R2t0Ee1uDesPHBJ9V/3
 2HKwcdp3eOMATxPe3DQ9d2LWRc/O5ipOQp/FfsKyd0Tbkcn1D6ArAW5eO7Rp8r59MK9PpnWlBzm
 7iXHrmF5ypu4I4vDUh6NY/Gg1wdpprVOjVB2fYD13rFyh7kHWzZ5jWRgMOHO6PyaO2tuHXwdr+H
 0Zl05AzMQYu8OU5h9Oixd73eqAxzNLH2eroZYYCftCR+4DsjEFfPWy4sK7L/waOQik0x3o81QfK
 3Ck/LH8x/8KbZ20YLfg==
X-Proofpoint-ORIG-GUID: TV3Uh8aKV3IzTUpCcLlUWgYDkzDBOS8c
X-Authority-Analysis: v=2.4 cv=eOAjSnp1 c=1 sm=1 tr=0 ts=6a29062d cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=bJwlv0obxc_OLVI2mnQA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: TV3Uh8aKV3IzTUpCcLlUWgYDkzDBOS8c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100060

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

Fix by temporarily dropping s_writepages_rwsem for the entire inline
data handling block, including the journal handle start/stop.  The
rwsem must be dropped before ext4_journal_start() -- not between
journal_start and journal_stop -- to avoid a secondary deadlock with
ext4_change_inode_journal_flag() which takes rwsem (write) and then
calls jbd2_journal_lock_updates() waiting for active handles to stop.

This is safe because:

 - This code runs before any block mapping or IO submission, so no
   writepages state depends on the rwsem being held at this point.

 - Inline data destruction is a one-way format transition (once cleared,
   EXT4_INODE_INLINE_DATA is never set again).  The rwsem is
   re-acquired after journal_stop, ensuring format stability for the
   remainder of writepages.

 - The can_map flag identifies the ext4_writepages() path (holds rwsem)
   vs ext4_normal_submit_inode_data_buffers() (does not), so the
   drop/reacquire is skipped when the rwsem is not held.

Also check the return value of ext4_destroy_inline_data() to avoid
proceeding with an inconsistent inode format on failure.

Reported-by: syzbot+bb2455d02bda0b5701e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v3: Drop s_writepages_rwsem before ext4_journal_start() and reacquire
    after ext4_journal_stop(), instead of dropping between journal_start
    and journal_stop as in v2.  This avoids two issues identified in v2
    review:
    - memalloc_nofs_restore() in ext4_writepages_up_read() would clear
      PF_MEMALLOC_NOFS while the jbd2 handle is active.
    - Reacquiring s_writepages_rwsem while holding a handle creates an
      ABBA deadlock with ext4_change_inode_journal_flag() which takes
      the rwsem (write) then calls jbd2_journal_lock_updates().

v2: Instead of moving inline data handling to ext4_writepages(),
    temporarily drop s_writepages_rwsem around ext4_destroy_inline_data()
    in ext4_do_writepages(). The move approach had a race where concurrent
    writes could create dirty pages with inline data after the early check,
    and unconditional destruction without dirty pages would lose data.

v1: Moved inline data cleanup from ext4_do_writepages() to
      ext4_writepages() before acquiring s_writepages_rwsem.

 fs/ext4/inode.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..cd7588a3fa45 100644
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
@@ -2816,16 +2819,35 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	 * we'd better clear the inline data here.
 	 */
 	if (ext4_has_inline_data(inode)) {
-		/* Just inode will be modified... */
+		/*
+		 * Temporarily drop s_writepages_rwsem because
+		 * ext4_destroy_inline_data() acquires xattr_sem, which has
+		 * a higher lock ordering rank.  Holding both would create a
+		 * circular dependency with ext4_xattr_block_set() -> iput()
+		 * -> ext4_writepages() -> s_writepages_rwsem.
+		 *
+		 * Drop the rwsem before starting the journal handle to also
+		 * avoid a deadlock with ext4_change_inode_journal_flag(),
+		 * which takes rwsem (write) then jbd2_journal_lock_updates().
+		 */
+		if (mpd->can_map)
+			ext4_writepages_up_read(inode->i_sb, mpd->alloc_ctx);
 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 		if (IS_ERR(handle)) {
+			if (mpd->can_map)
+				mpd->alloc_ctx =
+					ext4_writepages_down_read(inode->i_sb);
 			ret = PTR_ERR(handle);
 			goto out_writepages;
 		}
 		BUG_ON(ext4_test_inode_state(inode,
 				EXT4_STATE_MAY_INLINE_DATA));
-		ext4_destroy_inline_data(handle, inode);
+		ret = ext4_destroy_inline_data(handle, inode);
 		ext4_journal_stop(handle);
+		if (mpd->can_map)
+			mpd->alloc_ctx = ext4_writepages_down_read(inode->i_sb);
+		if (ret)
+			goto out_writepages;
 	}
 
 	/*
@@ -3032,13 +3054,12 @@ static int ext4_writepages(struct address_space *mapping,
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
@@ -3047,7 +3068,7 @@ static int ext4_writepages(struct address_space *mapping,
 	 */
 	if (!ret && mpd.journalled_more_data)
 		ret = ext4_do_writepages(&mpd);
-	ext4_writepages_up_read(sb, alloc_ctx);
+	ext4_writepages_up_read(sb, mpd.alloc_ctx);
 
 	return ret;
 }
-- 
2.43.0

