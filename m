Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792322;
	b=4nxL1xOalqxqI9S0eFSVJ/Dwcpx8JLW8QFOqKfNIpVTxIvEQzDaVu32hw/f966ZWlYaZ
	 KltPs2GAlqI/QV6iV/oxCsBB/iqr6ePq8X3kjbyoKerAqSWnMQovMsjwIbBHfnm/zZ/w/
	 LYP8GHQtPfDijSl/V2ZToLa32s82FpOFXIr4oU/pdFe/9fmmvERWge2QrR6k4aCPa3Tjm
	 Gfs5oUNKwOOJDWFEZq7JNLD9yDfGo6XxprU0XKtKTTgrX0VgiqiG037nO5hLWXJHO/GAZ
	 9rkdmQpltIMefuXXxSMaOuz49IBIdwNI+/EYrKZpZA58SposzBzdAM3wux4g1R+Db7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792322;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=w8eyuHu9tFfpczUx79eh2XRIDU8ZZI7KJLyaZGvYyqA=;
	b=b0E0qDrjOj2rpspQv6D1DQu4AJnWUpUUS8Q69mO4ZzPC9Uh+YP8NH+mjz9mT25FAtiJ/
	 QreID+dBxQKpXcZuuDnkxwAtqpY8X7pfyRAYP28WtmHEaO8hFBvZGwKQhlYNi9zJAADcB
	 tAhtRwwq4ANjjrt51WxtiU4P5unxJAZFdbu4ULYFQ5/fsC4IeoqP+ZGuhwtc47GKyuCcq
	 4oFYNi2ehnVkNJskUQydhRyWf2ioPMBBOVAjCJMree6dP0VmkQcGW2TlyDfZZS5fFJADK
	 fMe162F7h644yOLsgUWHV9tQ6GjnfawV9WCPpssAJdW3RRPQR287TfAtprdW59Vjz2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=BI2MurAK;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968B4606A329;
	Fri, 27 Nov 2026 15:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 968B4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=BI2MurAK
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE55gl3266952;
	Fri, 27 Nov 2026 15:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=w8eyuH
	u9tFfpczUx79eh2XRIDU8ZZI7KJLyaZGvYyqA=; b=BI2MurAK7VWRFt7w1cyBS6
	UJbF/1gKqBAeZv2Nh5WuHX628gq+s3bb/2gXMGZgvn80Xk/kVSDCM02INSm1B0XC
	k6Tx9/XQKEvAqGEWza+/cqB+FBx7FpEhwSft745VxbI+BDjhRyFhdilhJsXv2Mu+
	qapQXAh7c5lkYIYHgR+lhae6xaZwzaLwWcfGoEr0U5xootd/xcp588KPeWd0Q/+3
	5Vzwt+NhZyKeEe1W+fzHBCX3uVXeA6HGItijkxpSzee4g6tKcsytYFgYfztUl2KX
	fLbD5/CSJsprewn9YEAgmLD0A/yhq5OQXQANFEvtQya/h7t9WKXeqVHEtr+bboiw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1nkcw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4Ii8861624;
	Fri, 27 Nov 2026 15:11:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6mjg4j51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBlmr51052980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF12820040;
	Fri, 27 Nov 2026 15:11:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B53CD20043;
	Fri, 27 Nov 2026 15:11:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:44 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:57 +0530
Subject: [PATCH v2 10/13] ext4: add tracepoints for extent split and
 convert
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-10-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: QaVw2ecXin49QJQpOAAsS-g_KuVMr0Mo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX5El8Cz0Gj9jm
 IrhpN+VPT9FNbcKdXnfs/HrDxICmYS4u52IF0FOXnTTmzrM7i+8RaztZzaeYtUuD3HArN86e/SD
 LWmYy2KATP+NQF/M98OHdEfSpvYSndU=
X-Proofpoint-GUID: Wf3-WFKZJD-yTB_mLsqVRF8qGSKPk_jm
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b099db7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=Prt9tqb_RUX6htn9Vf0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfXyLwADGUI/F5d
 WALMdDkRVVXYLdFas/1Orq/vLPlf6aYNRqWPiWK6FnRRbowc2cOgrXGYKxGuwUt5Ndw2Uks3UR1
 67qqZkVsuCgdCQlNQjrlFAAwRZE1CW1pSZjp0K/rtLTLdZ0KqPblBJ54sVfTmExkxkBNzXNb42O
 3RA8T6nhLO73yJAVX0KkECiJkXIPGW9CylGE/1cI3APfCYPC7VOBzm3iIh6DolWN4UkgU7DrLFb
 kw9+lEerNMw6J52V30uQazKZzvVoC34sLDrhFStCnTohNBwUGfPBq9rstRS25CEHd0NqPyovlpg
 6AUA4uRhu6Ahhq1F9yZ7YkmZ8+33S6d7sSSzFt4Yy9zSEBzZCw5JDnMxnx69pgQKfXHcnh5FV2O
 6GgLUydHIswG0fan5qBodEXGU/G3gp+VP+tZ3/f+Aud1RZ/XiNR8XCP44lyqcQC2FXcUBJxWNhR
 axgzCH9zx/XWoCBhIHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Add some useful tracepoint to track how the extent split, conversion and
zeroout fallback behave. Also add a tracepoint to track conlicts in extent
status cache.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c           |  29 +++++++
 fs/ext4/extents_status.c    |   2 +
 include/trace/events/ext4.h | 189 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b816e9edb041..0f5d9f3c42a9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3390,6 +3390,10 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 			pblk = ext4_ext_pblock(ex);
 			err = ext4_issue_zeroout(handle, inode, lblk, pblk,
 						 len);
+			trace_ext4_extent_zeroout(inode, ee_block, ee_len,
+						  ext4_ext_pblock(ex),
+						  is_unwrit, lblk, pblk, len,
+						  err);
 			if (err)
 				/* ZEROOUT failed, just return original error */
 				return err;
@@ -3402,6 +3406,10 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 			pblk = ext4_ext_pblock(ex) + (map_end - ee_block);
 			err = ext4_issue_zeroout(handle, inode, lblk, pblk,
 						 len);
+			trace_ext4_extent_zeroout(inode, ee_block, ee_len,
+						  ext4_ext_pblock(ex),
+						  is_unwrit, lblk, pblk, len,
+						  err);
 			if (err)
 				/* ZEROOUT failed, just return original error */
 				return err;
@@ -3421,6 +3429,9 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		len = map->m_len;
 		pblk = ext4_ext_pblock(ex) + (map->m_lblk - ee_block);
 		err = ext4_issue_zeroout(handle, inode, lblk, pblk, len);
+		trace_ext4_extent_zeroout(inode, ee_block, ee_len,
+					  ext4_ext_pblock(ex), is_unwrit,
+					  lblk, pblk, len, err);
 		if (err)
 			/* ZEROOUT failed, just return original error */
 			return err;
@@ -3519,6 +3530,9 @@ static struct ext4_ext_path *ext4_split_extent(handle_t *handle,
 			goto try_zeroout;
 	}
 
+	trace_ext4_extent_split(inode, map, ee_block, ee_len, flags,
+				unwritten);
+
 	goto success;
 
 try_zeroout:
@@ -3882,6 +3896,9 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 	struct ext4_extent *ex;
 	struct ext4_extent converted_ex;
 	unsigned int ee_len;
+	ext4_lblk_t old_ee_block;
+	unsigned int old_ee_len;
+	bool old_unwrit;
 	int split_flag = 0, depth, err = 0;
 	bool did_zeroout = false;
 
@@ -3897,6 +3914,9 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 	ee_block = le32_to_cpu(ex->ee_block);
 	ee_len = ext4_ext_get_actual_len(ex);
 
+	trace_ext4_split_convert_enter(inode, map, ee_block, ee_len, flags,
+				       ext4_ext_is_unwritten(ex));
+
 	/* No split needed */
 	if (ee_block == map->m_lblk && ee_len == map->m_len)
 		goto convert;
@@ -3933,6 +3953,10 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 		if (err)
 			goto err;
 
+		old_ee_block = le32_to_cpu(ex->ee_block);
+		old_ee_len = ext4_ext_get_actual_len(ex);
+		old_unwrit = ext4_ext_is_unwritten(ex);
+
 		if (flags & EXT4_GET_BLOCKS_CONVERT)
 			ext4_ext_mark_initialized(ex);
 		else if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)
@@ -3952,6 +3976,11 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 		if (err)
 			goto err;
 		ex = &converted_ex;
+
+		trace_ext4_extent_convert(inode, map, old_ee_block, old_ee_len,
+				old_unwrit, le32_to_cpu(ex->ee_block),
+				ext4_ext_get_actual_len(ex),
+				ext4_ext_is_unwritten(ex), flags);
 	}
 
 	/* Lets update the extent status tree after conversion */
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 244cc0f62196..6c5340dce6ed 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1136,6 +1136,8 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 	    ext4_es_type(&chkes) == EXTENT_STATUS_CONVERT_PENDING)
 		return;
 
+	trace_ext4_es_cache_extent_conflict(inode, lblk, len, pblk, status,
+					    &chkes);
 	ext4_warning_inode(inode,
 			   "ES cache extent failed: add [%d,%d,%llu,0x%x] conflict with existing [%d,%d,%llu,0x%x]\n",
 			   lblk, len, pblk, status, chkes.es_lblk, chkes.es_len,
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index fb18fdcb3003..988f86729ea2 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2273,6 +2273,49 @@ DEFINE_EVENT(ext4__es_extent, ext4_es_cache_extent,
 	TP_ARGS(inode, es)
 );
 
+TRACE_EVENT(ext4_es_cache_extent_conflict,
+	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
+		 ext4_fsblk_t pblk, unsigned int status,
+		 struct extent_status *conflict_es),
+
+	TP_ARGS(inode, lblk, len, pblk, status, conflict_es),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	u64,		ino		)
+		__field(	ext4_lblk_t,	lblk		)
+		__field(	ext4_lblk_t,	len		)
+		__field(	ext4_fsblk_t,	pblk		)
+		__field(	unsigned int,	status		)
+		__field(	ext4_lblk_t,	conflict_lblk	)
+		__field(	ext4_lblk_t,	conflict_len	)
+		__field(	ext4_fsblk_t,	conflict_pblk	)
+		__field(	unsigned int,	conflict_status	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->lblk		= lblk;
+		__entry->len		= len;
+		__entry->pblk		= pblk;
+		__entry->status		= status;
+		__entry->conflict_lblk	= conflict_es->es_lblk;
+		__entry->conflict_len	= conflict_es->es_len;
+		__entry->conflict_pblk	= ext4_es_pblock(conflict_es);
+		__entry->conflict_status = ext4_es_status(conflict_es);
+	),
+
+	TP_printk("dev %d,%d ino %llu new extent [%u/%u) pblk %llu status 0x%x "
+		  "conflicts with cached extent [%u/%u) pblk %llu status 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk, __entry->len,
+		  __entry->pblk, __entry->status,
+		  __entry->conflict_lblk, __entry->conflict_len,
+		  __entry->conflict_pblk, __entry->conflict_status)
+);
+
 TRACE_EVENT(ext4_es_remove_extent,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len),
 
@@ -3369,6 +3412,152 @@ TRACE_EVENT(ext4_block_zero_eof,
 		  __entry->i_disksize, __entry->did_zero, __entry->zero_written)
 );
 
+DECLARE_EVENT_CLASS(ext4_split_convert,
+	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
+		 ext4_lblk_t ee_block, unsigned int ee_len,
+		 int flags, bool ee_unwrit),
+
+	TP_ARGS(inode, map, ee_block, ee_len, flags, ee_unwrit),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	u64,		ino		)
+		__field(	ext4_lblk_t,	m_lblk		)
+		__field(	unsigned int,	m_len		)
+		__field(	ext4_lblk_t,	ee_block	)
+		__field(	unsigned int,	ee_len		)
+		__field(	int,		flags		)
+		__field(	bool,		ee_unwrit	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->m_lblk		= map->m_lblk;
+		__entry->m_len		= map->m_len;
+		__entry->ee_block	= ee_block;
+		__entry->ee_len		= ee_len;
+		__entry->flags		= flags;
+		__entry->ee_unwrit	= ee_unwrit;
+	),
+
+	TP_printk("dev %d,%d ino %llu m_lblk %u m_len %u ee_block %u ee_len %u ee_unwrit %d flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->m_lblk, __entry->m_len,
+		  __entry->ee_block, __entry->ee_len,
+		  __entry->ee_unwrit,
+		  show_map_flags(__entry->flags))
+);
+
+DEFINE_EVENT(ext4_split_convert, ext4_split_convert_enter,
+	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
+		 ext4_lblk_t ee_block, unsigned int ee_len,
+		 int flags, bool ee_unwrit),
+	TP_ARGS(inode, map, ee_block, ee_len, flags, ee_unwrit)
+);
+
+DEFINE_EVENT(ext4_split_convert, ext4_extent_split,
+	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
+		 ext4_lblk_t ee_block, unsigned int ee_len,
+		 int flags, bool ee_unwrit),
+	TP_ARGS(inode, map, ee_block, ee_len, flags, ee_unwrit)
+);
+
+TRACE_EVENT(ext4_extent_zeroout,
+	TP_PROTO(struct inode *inode, ext4_lblk_t ee_block,
+		 unsigned int ee_len, ext4_fsblk_t ee_pblk, bool ee_unwrit,
+		 ext4_lblk_t zero_lblk, ext4_fsblk_t zero_pblk,
+		 unsigned int zero_len, int err),
+
+	TP_ARGS(inode, ee_block, ee_len, ee_pblk, ee_unwrit, zero_lblk,
+		zero_pblk, zero_len, err),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	u64,		ino		)
+		__field(	ext4_lblk_t,	ee_block	)
+		__field(	unsigned int,	ee_len		)
+		__field(	ext4_fsblk_t,	ee_pblk		)
+		__field(	bool,		ee_unwrit	)
+		__field(	ext4_lblk_t,	zero_lblk	)
+		__field(	ext4_fsblk_t,	zero_pblk	)
+		__field(	unsigned int,	zero_len	)
+		__field(	int,		err		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->ee_block	= ee_block;
+		__entry->ee_len		= ee_len;
+		__entry->ee_pblk	= ee_pblk;
+		__entry->ee_unwrit	= ee_unwrit;
+		__entry->zero_lblk	= zero_lblk;
+		__entry->zero_pblk	= zero_pblk;
+		__entry->zero_len	= zero_len;
+		__entry->err		= err;
+	),
+
+	TP_printk("dev %d,%d ino %llu ee_block %u ee_len %u ee_pblk %llu ee_unwrit %d zero_lblk %u zero_len %u zero_pblk %llu err %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->ee_block, __entry->ee_len,
+		  (unsigned long long) __entry->ee_pblk,
+		  __entry->ee_unwrit,
+		  __entry->zero_lblk, __entry->zero_len,
+		  (unsigned long long) __entry->zero_pblk,
+		  __entry->err)
+);
+
+TRACE_EVENT(ext4_extent_convert,
+	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
+		 ext4_lblk_t old_ee_block, unsigned int old_ee_len,
+		 bool old_unwrit, ext4_lblk_t new_ee_block,
+		 unsigned int new_ee_len, bool new_unwrit, int flags),
+
+	TP_ARGS(inode, map, old_ee_block, old_ee_len, old_unwrit,
+		new_ee_block, new_ee_len, new_unwrit, flags),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	u64,		ino		)
+		__field(	ext4_lblk_t,	m_lblk		)
+		__field(	unsigned int,	m_len		)
+		__field(	ext4_lblk_t,	old_ee_block	)
+		__field(	unsigned int,	old_ee_len	)
+		__field(	bool,		old_unwrit	)
+		__field(	ext4_lblk_t,	new_ee_block	)
+		__field(	unsigned int,	new_ee_len	)
+		__field(	bool,		new_unwrit	)
+		__field(	int,		flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->m_lblk		= map->m_lblk;
+		__entry->m_len		= map->m_len;
+		__entry->old_ee_block	= old_ee_block;
+		__entry->old_ee_len	= old_ee_len;
+		__entry->old_unwrit	= old_unwrit;
+		__entry->new_ee_block	= new_ee_block;
+		__entry->new_ee_len	= new_ee_len;
+		__entry->new_unwrit	= new_unwrit;
+		__entry->flags		= flags;
+	),
+
+	TP_printk("dev %d,%d ino %llu m_lblk %u m_len %u old [%u/%u) unwrit %d -> new [%u/%u) unwrit %d flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->m_lblk, __entry->m_len,
+		  __entry->old_ee_block, __entry->old_ee_len,
+		  __entry->old_unwrit,
+		  __entry->new_ee_block, __entry->new_ee_len,
+		  __entry->new_unwrit,
+		  show_map_flags(__entry->flags))
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */

-- 
2.55.0

