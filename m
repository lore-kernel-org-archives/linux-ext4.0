Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FEE3F8EC3;
	Mon, 27 Jul 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149752; cv=none; b=kl6IA9HKSGciXZ6Xx3n2B4SrTITwk0/HHs6KkMkbwFtdkYdw+vKXv/4pJvQgJ1UKCS8QGPvUp6dK0FWznI5QIrWlgKKKsIIbWaultUrIzCzE8mP6FTITu0IODFlt63AeopYRo2V1RuXnzLvczg3si0cxSOjt8YHWMf50toIUfUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149752; c=relaxed/simple;
	bh=3r4kCX5rg9ZuBn//xyZNVepLu8qPXm4TL/1wmve++UQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCFmb1eghYGtPOCQi34nlHxV8ISwa17eeym3fOp4bwDvRL5DX+1JIRnl891CBfdL/tqxdMP8o8TmPFZhijy1qMQjSZe3EUO+BR39P0wx5x7zruXH60e6ankpapC13hE6OLFYkMpJ0wl+zxa1tvnhRid0a1xqhRMNHmQBr5jJcK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=bsEm3TwI; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="bsEm3TwI"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAO3tj690879;
	Mon, 27 Jul 2026 10:55:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=sxjBObQY8VMwf+yRiGA2CUd9kVlf3sq9iHmcss7DeTo=; b=
	bsEm3TwIUVzi0b34FAnrmH/Fz2RZbYE24c+ezmOLZ/egM1KSp79s2ogoM6tll3f7
	jlZqT1drcOwMEv+diWC1PiI7Z89OTwCumHnYyfnxeQCLYsjeD5B4VTqiGicOBOLS
	IkDfAIK6Pntusn7779P1H6cc+zoeUYWfLNwF1UzmvFu+5wH75n3OErHPknADkwOa
	qovF0x+fQMvtmvT5fXyFOgltKjCCCV8m2R5tuWoh517hTVncv2+k2fcwidRn4IOn
	XLpJbWi6EYGCY8K4QbhaTAzfihPh2+9laY0/73vRZ3kGoSPX6KU5yCfQTJAKjInI
	dxagX9XGxNGfKiEGnXRCww==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmjnft3ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 10:55:11 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:55:10 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:55:07 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 9/9] ext4: populate extent entry atomically during inline data destroy
Date: Mon, 27 Jul 2026 18:54:41 +0800
Message-ID: <20260727105441.3213095-10-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXzk/zf9C8omp2
 UPV44fwgIZI0yxgVDtjnmotqXlwAWA5Kt3PzyrcOvnHOTPjBScL+17vbsM4sukWgSHfQo8M0Q1N
 hIgf069gD+v9jx94ABm1NITJsw0PXwchOKlseqiHxiXE7oddNy00
X-Proofpoint-ORIG-GUID: DupudVk3AMWzC2mIgVm2REbawmEXb51R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX1pI7xRZ8hMAe
 e/42T0u/MsqXvoSZ/W4pSkAP2z9sPx3+c61Ze40tnInbhv0T9Of8px9lLoql90lG3HlXaUT4Iy9
 APP5Ll3afw2EraG/FTl2xDMdCr0eVomHhdgRb/R+e0SaSDHNzeXTIWF9HQ8JXuedk3Kx5/2T26B
 zLDyElCBS9Dtd4dEXRcHNi/vrirFf/Wwq2aFxp/AyP33VbplAA80bM+oCmfR+k4KnZ4mNm9ocCx
 qTrBWcaXidW5/OCLNIIoiPFGyLlss9EHl+tmDUhMu9fDEcZr2BzJNgpQ5eS6LC9KdcVdxMq39R5
 bkCfZH9N12lUq+u1bJHxsyxRnogEZjxlMAOThwQYowBExdVXrhJ3GrylSOZoRV9BkORCYhl2wH0
 UutDQroZocRfSuFXBKNXCZFVTuDVwypykKyIhbPHOhKSuIOHTNzOaEDyoj93OW5PJpinMCtEMt2
 EzB/1Q18cR4beNIDrXw==
X-Authority-Analysis: v=2.4 cv=MuRiLWae c=1 sm=1 tr=0 ts=6a67390f cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=f8wF4Msc7tSbbMyjxr0A:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: DupudVk3AMWzC2mIgVm2REbawmEXb51R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Pass the pre-allocated block number to ext4_destroy_inline_data_nolock()
so that the extent entry can be populated under i_data_sem, in the same
critical section where the extent tree is initialized.

Previously, ext4_convert_inline_data_nolock() wrote the extent entry
after ext4_destroy_inline_data_nolock() returned (and released
i_data_sem).  This left a window where concurrent readers could see
an empty extent tree via i_data_sem read lock.

Now the entire sequence -- clear i_block, init extent tree, populate
first extent entry -- happens atomically under i_data_sem write lock.
Other callers pass 0 to preserve existing behavior.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inline.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 009a4e058793..e0b80273e322 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -385,7 +385,8 @@ static int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
 }
 
 static int ext4_destroy_inline_data_nolock(handle_t *handle,
-					   struct inode *inode)
+					   struct inode *inode,
+					   ext4_fsblk_t pblk)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_xattr_ibody_find is = {
@@ -433,7 +434,21 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 		    S_ISREG(inode->i_mode) || S_ISLNK(inode->i_mode)) {
 			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
 			ext4_ext_tree_init(handle, inode);
+			if (pblk) {
+				struct ext4_extent_header *eh;
+				struct ext4_extent *ex;
+
+				eh = ext_inode_hdr(inode);
+				ex = EXT_FIRST_EXTENT(eh);
+				ex->ee_block = cpu_to_le32(0);
+				ex->ee_len = cpu_to_le16(1);
+				ext4_ext_store_pblock(ex, pblk);
+				eh->eh_entries = cpu_to_le16(1);
+			}
 		}
+	} else if (pblk) {
+		/* indirect mapping: set i_data[0] directly */
+		EXT4_I(inode)->i_data[0] = cpu_to_le32(pblk);
 	}
 	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
 
@@ -750,10 +765,11 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 
 	/*
 	 * Data is safely in the allocated block.  Now destroy the inline
-	 * data (which also initializes the extent tree via
-	 * ext4_ext_tree_init) and then insert the pre-allocated block.
+	 * data and populate the extent entry atomically under i_data_sem
+	 * (inside ext4_destroy_inline_data_nolock).  This ensures no
+	 * concurrent reader sees an empty extent tree.
 	 */
-	error = ext4_destroy_inline_data_nolock(handle, inode);
+	error = ext4_destroy_inline_data_nolock(handle, inode, pblk);
 	if (error)
 		goto out_free_block;
 
@@ -763,20 +779,6 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
 	}
 
-	/* Insert the pre-allocated block into the extent tree */
-	if (ext4_has_feature_extents(inode->i_sb)) {
-		struct ext4_extent_header *eh = ext_inode_hdr(inode);
-		struct ext4_extent *ex = EXT_FIRST_EXTENT(eh);
-
-		ex->ee_block = cpu_to_le32(0);
-		ex->ee_len = cpu_to_le16(1);
-		ext4_ext_store_pblock(ex, pblk);
-		eh->eh_entries = cpu_to_le16(1);
-	} else {
-		/* indirect mapping: set i_data[0] directly */
-		EXT4_I(inode)->i_data[0] = cpu_to_le32(pblk);
-	}
-
 	error = ext4_mark_inode_dirty(handle, inode);
 	goto out;
 
@@ -1419,7 +1421,7 @@ int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 	int ret, no_expand;
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	ret = ext4_destroy_inline_data_nolock(handle, inode);
+	ret = ext4_destroy_inline_data_nolock(handle, inode, 0);
 	ext4_write_unlock_xattr(inode, &no_expand);
 
 	return ret;
-- 
2.43.0

