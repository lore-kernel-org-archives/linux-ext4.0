Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792308;
	b=jbwHy96EvEgJPx475xMjrzoYlNprwqmURBURh1KWEMAGb7mS3v2nnZWelaAoeazeauoh
	 hJPTEfaYuUOIVcJdQSqeuo99h0Zg4Hcz/Ov5rxD14arzzdyGklJBknwWqLCUmUW7VIUyF
	 FwmXOeBem2xVoN3LTAKCyEXrFP4DfejpTLhe2Y+zF3JmtLqtgo3/03V3qyptJkhVMAdLs
	 afCzADICVn6ZySE1RhcIjMGPt7zRsY/CFvbbzN57rnAY22LEJv/kRFeh1YGHaqJ0YxhNN
	 NB5eyobCq4fafazYadbyhgtm3o3KSD7B7RfZZJ8d0rKG8R2O5lOB1nJhjPD28Fw2jYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792308;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=M1GXl96824Jzl+Uc+dhOyCLLWzQ7m/EV4DGixYMFAW8=;
	b=L1KDmYnivtUFj94YI1T5D93Afy+TQ3DCBB3GZO0QMQNIhLVJ2wzFDeZnc2CHdQHpyMbe
	 q67BCcQn+tuJIJQAqo3F5sTvE09nNXLCXYUS968VnZxTCX0QPdHqUrkbAxnmCQ+OvC9k8
	 K0SCEI24YsQ/iTXJb6n7B+3eYQd/AaLlcmHy7cX+hETHdet/boFh1yt1ANjxtpw1qYD90
	 xQv2g4NLgwsQq5CnCmTFWZq+FDVo1z50V9KuScLFUHPUx8ehsjBxf7EQme7+B70bTd+fw
	 mEVR071gBZ0lMBYqUFAkoF43In9sl0Yvh93tzROyCyqTMa3XrMGYVP9+aMaPsadfpLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Ih5yMsL1;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B2606A31F;
	Fri, 27 Nov 2026 15:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E5B2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Ih5yMsL1
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4sWM3266007;
	Fri, 27 Nov 2026 15:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M1GXl9
	6824Jzl+Uc+dhOyCLLWzQ7m/EV4DGixYMFAW8=; b=Ih5yMsL1NRrN9ju9vlWthz
	hsPiOoWdBfvn8tnEe5vRyHlwUvBUSS3d+w3e4oqswPvhQDqINNknFR2vNyGN6dKF
	DWfKaHmfMiNpaliwjFu727kKje1SBLkQfcyoAbmZN+dRfgI83EUUbG4e299QU39g
	LOpkJvlIXZxu7yy+9I9dgI+UlUikWciLI+y0QVvvxGaWZKPs/z7toO8Q21bWD0tg
	+Ja5cwCl812wPP9v6O9b7Phl3UJNW7wa6MzukFsbA20baAYY74SkBCA5GjuitBPz
	XlPwMGc+YS9o5BSGbhv/eohHZv5ILHKBcwf2m1929bSQLtv6jIVM6drsucZPacWw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1nkc2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4HD92819254;
	Fri, 27 Nov 2026 15:11:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5kfaappg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBRrI47972804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50DD920043;
	Fri, 27 Nov 2026 15:11:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE6A42004B;
	Fri, 27 Nov 2026 15:11:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:24 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:51 +0530
Subject: [PATCH v2 04/13] ext4: add es helper to convert unwrit to convert
 pending without changing i_es_seq
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-ext4-endio-zero-bug-v2-4-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: iutXvNjv63ZGoePqEQwafpAoHETQXnPz
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX/yoHHf0EI49J
 267HHHPEBFzhEHHTNWEDB8YU0tsFUk00OfLmNFB2lS7iOOczhbfcvsEbFLTvFtsDREMbcdJwgPL
 br00CTWmMnY3IZi35cAxE1I5yK1yo+I=
X-Proofpoint-GUID: uszr9xIuqhuRE2BMzHByGzMuxlXJWouQ
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b099da4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=_N9tQ_OlymrJwtHD:21 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22
 a=VnNF1IyMAAAA:8 a=MdhCsysiuOGiCJvRt1AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfXzf1zhyaVxApv
 7ux6amTnGEOzhqg9TH44v4qkVGTGfjRmoC+l4VgyTjhaIhTodntJDbIQ3yxjEHuefgeaaJHlCTU
 4a3u30/GszxGAnczW9bgfgGgOjJPwJX8BIqh9ncP+idySDKZPw+i/ddJIjSTMc+P0pcUtaXFXPJ
 m2LgaUShAwMeqOuFDGSLMI9vV28emiNyP81/xuofc8aeUFIjt5sCoTCbbXB54R0+07ZR8p8MBfS
 2naOusAWIPWB84RsNdOCqV6YxrDqbIEyWPLEc7V4yoGT4QXilDMxoOPebpWYw0go8vTDIzBO7UD
 d86k7waEMiui+23ZsOvpLIjibYi/7gr4qDtzJhUMX83Jai/mfMCv4TF1KFfBuzbi1/IFrk0/oUq
 730HbG3fHfM93DepLdOB5sDp4I9tDBNXv1g8V9ERYvaZF50xxtVPPZdDuhTTkSU1afHd7rzN0Vm
 hihy0iSH45djrLMp5SA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Upcoming codepaths would often want to convert an existing unwritten extent
to convert pending in extent status cache. This is essentially not an
operation that needs to bump the i_es_seq because both of these types mean
the same thing for most of the code paths that care about the sequence
counter. Hence, introduce a new helper to change the extent status without
having to bump the extent status cache.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents_status.c | 45 ++++++++++++++++++++++++++++++++++++---------
 fs/ext4/extents_status.h |  2 ++
 fs/ext4/inode.c          | 23 +++++++++++++++++++++++
 3 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 75dd065106e4..244cc0f62196 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -907,14 +907,10 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
 	return 0;
 }
 
-/*
- * ext4_es_insert_extent() adds information to an inode's extent
- * status tree. This interface is used for modifying extents. To cache
- * on-disk extents, use ext4_es_cache_extent() instead.
- */
-void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
-			   ext4_lblk_t len, ext4_fsblk_t pblk,
-			   unsigned int status, bool delalloc_reserve_used)
+static void __ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
+				    ext4_lblk_t len, ext4_fsblk_t pblk,
+				    unsigned int status,
+				    bool delalloc_reserve_used, bool inc_seq)
 {
 	struct extent_status newes;
 	ext4_lblk_t end = lblk + len - 1;
@@ -1004,7 +1000,8 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 		}
 		pending = err3;
 	}
-	ext4_es_inc_seq(inode);
+	if (inc_seq)
+		ext4_es_inc_seq(inode);
 error:
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 	/*
@@ -1036,6 +1033,35 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	return;
 }
 
+/*
+ * ext4_es_insert_extent() adds information to an inode's extent
+ * status tree. This interface is used for modifying extents. To cache
+ * on-disk extents, use ext4_es_cache_extent() instead.
+ */
+void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
+			   ext4_lblk_t len, ext4_fsblk_t pblk,
+			   unsigned int status, bool delalloc_reserve_used)
+{
+	__ext4_es_insert_extent(inode, lblk, len, pblk, status,
+				delalloc_reserve_used, true);
+}
+
+/*
+ * ext4_es_mark_convert_pending() marks an already unwritten range as
+ * CONVERT_PENDING. For most of the codepaths CONVERT_PENDING is treated as
+ * unwritten everywhere (except the endio zeroout path, which is already
+ * serialized with i_data_sem) hence we don't bump the i_es_seq here.
+ *
+ * The caller must hold i_data_sem in shared (at least) and must have made sure
+ * that the range is unwritten.
+ */
+void ext4_es_mark_convert_pending(struct inode *inode, ext4_lblk_t lblk,
+				  ext4_lblk_t len, ext4_fsblk_t pblk)
+{
+	__ext4_es_insert_extent(inode, lblk, len, pblk,
+				EXTENT_STATUS_CONVERT_PENDING, false, false);
+}
+
 /*
  * ext4_es_cache_extent() inserts information into the extent status tree
  * only if there is no existing information about the specified range or
@@ -2488,6 +2514,7 @@ static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_init_tree);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_insert_extent);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_mark_convert_pending);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_cache_extent);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_remove_extent);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_find_extent_range);
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 2247f811f6c3..b1bc34af786f 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -140,6 +140,8 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 				  ext4_lblk_t len, ext4_fsblk_t pblk,
 				  unsigned int status,
 				  bool delalloc_reserve_used);
+extern void ext4_es_mark_convert_pending(struct inode *inode, ext4_lblk_t lblk,
+					 ext4_lblk_t len, ext4_fsblk_t pblk);
 extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len, ext4_fsblk_t pblk,
 				 unsigned int status);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9368a68db289..f7fc5fb7e819 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -757,6 +757,29 @@ int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
 	return retval;
 }
 
+/*
+ * Mark the unwritten range in @map as convert pending in the extent status
+ * tree. This is used by the zeroout code to ensure we don't write zeroes on
+ * such unwritten ranges and hence must be serialized against endio conversion /
+ * extent zeroout, which hold i_data_sem excl.
+ *
+ * Returns false if the extent status tree changed since @map was looked up, in
+ * which case the caller must redo the lookup.
+ */
+static bool ext4_map_mark_convert_pending(struct inode *inode,
+					  struct ext4_map_blocks *map)
+{
+	bool ok;
+
+	down_read(&EXT4_I(inode)->i_data_sem);
+	ok = map->m_seq == READ_ONCE(EXT4_I(inode)->i_es_seq);
+	if (ok)
+		ext4_es_mark_convert_pending(inode, map->m_lblk, map->m_len,
+					     map->m_pblk);
+	up_read(&EXT4_I(inode)->i_data_sem);
+	return ok;
+}
+
 /*
  * The ext4_map_blocks() function tries to look up the requested blocks,
  * and returns if the blocks are already mapped.

-- 
2.55.0

