Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB8817B50A;
	Mon, 27 Jul 2026 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149756; cv=none; b=HK238MLD45EzvIiWareBRXc2Z2WDQOKvRjirngHF2XDdK1r0xjBxuS6sWPth/QqaY6qZU4kIbzVt3BwlqPY7qMBUFKRw6guCQOgun7+UWWdcY1pbqVkgZ721GbPEvc3+/sGzZ5AlhnMBYaN7rR/eaZrZHRr57FTCQqdFBeS9XgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149756; c=relaxed/simple;
	bh=Pn0t+mBEVqpfmn+NZ8mntJTs4wffyPQnGaDhqkcUKdI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2ZF5o0CC7zKaTLiaq5UjjNmbXCRvjcDcQHGsACWdDdJRWGZK7h78z7az1kLE6q2fuftBBRipM0B9nX8q4v2X52fY8dWU/1/C7DG8RSsUy4pSrLQ8teYN2icceI8hIe+2ZC/fQDpapQIAOWMymQzasHvzBVVbPq1UmrzQ06r2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=rVpuePI8; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="rVpuePI8"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAOWvR479001;
	Mon, 27 Jul 2026 03:54:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=5TaqXC5WoGHLFgmFKV9DoymfPcHx2eoj2M57ZdJt2U0=; b=
	rVpuePI8MB+DbeBQYslyDM/1muN85Jftae0SHUfelIqiiwd740WgsYi8PddT2d3X
	ZLEcFI0odLVO2yeHdkwkWixQQPXjr/B/aSnHKE9kizdZ/AqBXgBcGvCiNWCoudm/
	BIzS+lp99m8EksH52h79mK/Fgtsk7A1hHfw4r3YqJRu/NanmoGEnVZ/XGnNrbIgs
	tlFRqos8tcPPVK1GqtGH/qe6IvrK7a5XApI2GQvOrAFhdMnPfg5eWSMtKAhdy/0Y
	LxbXPFoUQZayabAvW4WdlWVSH+tosQQbrj89EMZSJ381R//J45+p+yO+68UWd0ul
	q9JXW/5NQWlFuIKtMbizTg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmvnf1r1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 03:54:56 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:54:56 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:53 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 4/9] ext4: remove inline data write paths for regular files
Date: Mon, 27 Jul 2026 18:54:36 +0800
Message-ID: <20260727105441.3213095-5-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX9ovynGSYsMsd
 pGJpL4H1DNAKnoMukaUpmh1DlNmSeCbru4qSJemHHyJbUVmD6zhb86lk8KART9CKJk2x5NCQ+Dc
 t6560CisQ0IGivRlHy0gKyGam2HPlTk3SbKvqoZa3UVs701X7GiF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX9Wqh4X/OSwv0
 LFsuBY9hCjmVQYNqeDdEeBJQZrfrfHN4AZqQCV/WC8zVKh2LOIVU9Bc+2kvznR+YeXvPCt5lqoE
 V0jhkSUx5MUB8omTVmuDE4rq/bzuX4yQlQKPwcTph7SNRu5KW9e0jB3E1yaeM25XcABBUfWmrGh
 kdD41MZ4a2VrTMnxRwWPhelU3RTx+aXFrt4YKgowQD0MhKdarjrwtLwVwJ4JzN7O2fgWiFfYlC6
 W/BEp2d8hkhUOJRdbzfHCE4Bll/fuWylhYcHQM91MfIYbSznoALWf4fBM5fdVTl+PMZrKHRPzFR
 7/e2LNTmmp98pkrMia8qWdo8/QM4PBUCvEpyVc/mFdj0MQsosQ2i/97zgW9H5CiXjet4IV62jLd
 XnHA1ix8io/FxHzrTrrcj8oN3xASiXko53G+/YhOY3uc6B2ynT4YlNCBFdg1Vxfxt+hrzBOXbBy
 zR49WfuaoS5dGVzYcGw==
X-Proofpoint-GUID: AUs0DpIbsuoaHRWYDdu7Vd8N9pUTAlur
X-Authority-Analysis: v=2.4 cv=M7x97Sws c=1 sm=1 tr=0 ts=6a673900 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=phv1Q4LNkAy9ipzM26kA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: AUs0DpIbsuoaHRWYDdu7Vd8N9pUTAlur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Any write operation on an existing inline data regular file now triggers
immediate conversion to block-based storage instead of writing inline.

Remove ext4_try_to_write_inline_data() and have its caller directly
call ext4_convert_inline_data().  ext4_generic_write_inline_data()
converts immediately for the non-DA path.

Directory inline data operations (ext4_try_add_inline_entry) are
preserved as directories benefit most from inline storage without the
write path complexity.

Read, truncate, and convert paths remain intact.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ext4.h   |  4 ---
 fs/ext4/inline.c | 94 +++++-------------------------------------------
 fs/ext4/inode.c  |  3 +-
 3 files changed, 9 insertions(+), 92 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 21a951f10636..5f0448b960fe 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3759,10 +3759,6 @@ extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
 extern void ext4_update_final_de(void *de_buf, int old_size, int new_size);
 
 int ext4_readpage_inline(struct inode *inode, struct folio *folio);
-extern int ext4_try_to_write_inline_data(struct address_space *mapping,
-					 struct inode *inode,
-					 loff_t pos, unsigned len,
-					 struct folio **foliop);
 int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 			       unsigned copied, struct folio *folio);
 extern int ext4_generic_write_inline_data(struct address_space *mapping,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8f1efe4297a0..0803fa8eade7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -699,97 +699,19 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 					  bool da)
 {
 	int ret;
-	handle_t *handle;
-	struct folio *folio;
-	struct ext4_iloc iloc;
 	int retries = 0;
 
-	ret = ext4_get_inode_loc(inode, &iloc);
-	if (ret)
-		return ret;
-
-retry_journal:
-	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_release_bh;
-	}
-
-	ret = ext4_prepare_inline_data(handle, inode, pos + len);
-	if (ret && ret != -ENOSPC)
-		goto out_stop_journal;
-
-	if (ret == -ENOSPC) {
-		ext4_journal_stop(handle);
-		if (!da) {
-			brelse(iloc.bh);
-			/* Retry inside */
-			return ext4_convert_inline_data(inode);
-		}
-
-		ret = ext4_da_convert_inline_data_to_extent(mapping, inode);
-		if (ret == -ENOSPC &&
-		    ext4_should_retry_alloc(inode->i_sb, &retries))
-			goto retry_journal;
-		goto out_release_bh;
-	}
-
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
-					mapping_gfp_mask(mapping));
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
-		goto out_stop_journal;
-	}
-
-	down_read(&EXT4_I(inode)->xattr_sem);
-	/* Someone else had converted it to extent */
-	if (!ext4_has_inline_data(inode)) {
-		ret = 0;
-		goto out_release_folio;
-	}
-
-	if (!folio_test_uptodate(folio)) {
-		ret = ext4_read_inline_folio(inode, folio);
-		if (ret < 0)
-			goto out_release_folio;
-	}
-
-	ret = ext4_journal_get_write_access(handle, inode->i_sb, iloc.bh, EXT4_JTR_NONE);
-	if (ret)
-		goto out_release_folio;
-	*foliop = folio;
-	up_read(&EXT4_I(inode)->xattr_sem);
-	brelse(iloc.bh);
-	return 1;
+	/* Inline data is deprecated: always convert to block format */
+	if (!da)
+		return ext4_convert_inline_data(inode);
 
-out_release_folio:
-	up_read(&EXT4_I(inode)->xattr_sem);
-	folio_unlock(folio);
-	folio_put(folio);
-out_stop_journal:
-	ext4_journal_stop(handle);
-out_release_bh:
-	brelse(iloc.bh);
+retry:
+	ret = ext4_da_convert_inline_data_to_extent(mapping, inode);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
 	return ret;
 }
 
-/*
- * Try to write data in the inode.
- * If the inode has inline data, check whether the new write can be
- * in the inode also. If not, create the page the handle, move the data
- * to the page make it update and let the later codes create extent for it.
- */
-int ext4_try_to_write_inline_data(struct address_space *mapping,
-				  struct inode *inode,
-				  loff_t pos, unsigned len,
-				  struct folio **foliop)
-{
-	if (pos + len > ext4_get_max_inline_size(inode))
-		return ext4_convert_inline_data(inode);
-	return ext4_generic_write_inline_data(mapping, inode, pos, len,
-					      foliop, false);
-}
-
 int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 			       unsigned copied, struct folio *folio)
 {
@@ -828,7 +750,7 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 		/*
 		 * ei->i_inline_off may have changed since
 		 * ext4_write_begin() called
-		 * ext4_try_to_write_inline_data()
+		 * ext4_convert_inline_data()
 		 */
 		(void) ext4_find_inline_data_nolock(inode);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ad14dd58a003..f9e1f0a6024d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1312,8 +1312,7 @@ static int ext4_write_begin(const struct kiocb *iocb,
 	index = pos >> PAGE_SHIFT;
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
-		ret = ext4_try_to_write_inline_data(mapping, inode, pos, len,
-						    foliop);
+		ret = ext4_convert_inline_data(inode);
 		if (ret < 0)
 			return ret;
 		if (ret == 1) {
-- 
2.43.0

