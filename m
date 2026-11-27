Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792311;
	b=z/TZfNPu1+ULq34g9xm1Lr+NhXitdQM16+iGp6Tvy42CRbLG6cjKvYMWdrN8fU9bUg6h
	 4cekYbWChkkOYyRQ/wjuN1GxLDMOMbCnVL7q4HpMYF8iFeZtfByNL0Jsk56eTrS55bjQY
	 k5TdT5/yS6vadc/pr0kizPIQ6tqXTd02w9L9hRNxh+T/6zgNfNY14OGrKi6LrgKQctljj
	 GgEP1k4yPHcUHI+anuieIjw9ayMggKvyeZvlYY8XenzUDsQhfJRDJomrac8AO5gqdESiP
	 9pnfx1hPHldhj3H+JZpZem34zXXuOKwfxQL/X504pUMD/Y6Xc/pK8HteVADy51jVs/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792311;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=dyS864XugS7h/gUWr8xN9X1g0tq2NNstvIMq0kQdU6o=;
	b=z/xDeo16CDDnoAeqUrhNnkYteXbyqICa1iUkUgTBvgRbXRlxjSP1zbOVr1yyCjwiuzqQ
	 +KTCNGYVfjRVHI32SAL/j5hyFTsUOcPk7jdR9UPuSNL/HGsH0HZKLCFO+4kMfLTV2w06y
	 d5d5N2vBQRAbv5PsoN1K4eooa+qUKeAH3Y8rB65dhsICLr82ekFVHDCI8h3brI+2Ec1ma
	 7wtubjmAOXQ0LSRWz/s78Mcn7msYu1hbom7d9DQAFhpR4tbDahp+Kh7PlCbPHWzKEl0SQ
	 kC32DHtZuANNNiwoBLIDJ+yRvx+kqz3+cCL+acZFWWOWN5GTtLY8x4DF/93saRuK5Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="DTX//72a";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C022606A327;
	Fri, 27 Nov 2026 15:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C022606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DTX//72a
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE5If42012620;
	Fri, 27 Nov 2026 15:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dyS864
	XugS7h/gUWr8xN9X1g0tq2NNstvIMq0kQdU6o=; b=DTX//72aWCAHS02vPTlRbU
	O2sxxvQUje+q4cR3/wMYES3NlezZp2wJVCXghwWFXC9nB0mtdrr6TjX2Ju1i7I3d
	HTFznPRabhuB4YXQWScR3HSPvjoxs+1DZNKQRnxCgx1AILqWF41VDAi7sqNRFEIa
	pAEoRMhxSrRl5VuazzSLCiOtNQt4/Et8vzGsZnF6O++dGyBsAH75X7EwC2IDS/Mo
	VNB6tCCGfIUo0LGRlrNQiR+rPWwNJesXepzJH7MOiQ+HMS66lhFr7daiFeVS9Ops
	OqAP8cwwgs8G8zGtttm///R7X8d/IM/V+H4+RS1eH4r7N3eMpq5FLxKCHHrWh6EA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34p4wdsn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4Jpc3245601;
	Fri, 27 Nov 2026 15:11:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx9a4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBUB956492442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82EA420043;
	Fri, 27 Nov 2026 15:11:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E53C120040;
	Fri, 27 Nov 2026 15:11:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:27 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:52 +0530
Subject: [PATCH v2 05/13] ext4: add support to track convert pending ranges
 in ext4_map_blocks()
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-5-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX49ZPjqMm9TzT
 ZSZ/45yvSrILMb7EHnekdcOJADKUvedAZRZqPgJzCfacdiKHgwh6wyhw2aAopWUVkqe0JGjVc6K
 icEssKcV+moC6Sb7GVTMkKVNaoYtFP8=
X-Proofpoint-GUID: oOvQfXOuSF9RjwXBvEc4GBe9UNa-ogqw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX/upYymAmsoau
 kugRjyBBns8tFbHH0noTnuzSKJt+mKleGo75q4mYKztYvNASytzdoCUOlF6tXgZtee1eBqubGJA
 lZ72swHcngTzLs5b/xMArEmDsIXaBpjsX6Jg8g01pTHddnTfTc7wUrNw2UFBnGtvUJ4r0uE9lpG
 yk382m3VhqbhzuMtSEe5S3WoswaQ2e1Q4DUrdL67XNSAcAKFs3/KzHVhq/tjGzDePK7RbXN9fqg
 WFP5ku/pnboVwxR4DEbqmP5oFFPS4xqmKuTAJ3cncWp4GXDN5G/z1xYIepPydKxu6F+Qi38kBMf
 HP34AKwPDvb0ZL9cmvCZfZPztdIuGAgnPHVYDpRRo1W2VbkSJVs8S8M21mb6+s4UmNYalKJPRwt
 /fsMYisIRDHCwcfEJCcptVnzQPkKEleGFIyqvKl2vcyghsKXzVaRCLHcACLPx00YUziJ2TLyibv
 XVeTXIrvosNy7eNeVPQ==
X-Proofpoint-ORIG-GUID: LG1o2HiO97i4mF0uNpGfiFpDjiMNgjoZ
X-Authority-Analysis: v=2.4 cv=QabzLcbv c=1 sm=1 tr=0 ts=6b099da7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=QXQYgmwZ4l3Dsd5QC2oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Introduce a new get block flag to indicate that the caller is about to
issue IO over unwritten ranges and hence wants them to be marked as
convert pending. This allows upcoming changes to query such ranges before
trying to zero them out in endio.

We need to be careful to always add the CONVERT_PENDING extent status entry
under i_data_sem because the upcoming changes will use that sem to
serialize with the endio zeroout path.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h              |  9 ++++++++-
 fs/ext4/inode.c             | 23 +++++++++++++++++++++--
 include/trace/events/ext4.h |  1 +
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 646c017dda1c..8cce99d68978 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -748,6 +748,12 @@ struct ext4_new_flex_group_data {
  */
 #define EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF	0x1000
 
+/*
+ * This range will get converted from unwritten to written soon due to endio
+ * conversion.
+ */
+#define EXT4_GET_BLOCKS_CONVERT_PENDING	0x2000
+
 /*
  * The bit position of these flags must not overlap with any of the
  * EXT4_GET_BLOCKS_*.  They are used by ext4_find_extent(),
@@ -766,7 +772,8 @@ struct ext4_new_flex_group_data {
  */
 #define EXT4_EX_QUERY_FILTER	(EXT4_EX_NOCACHE | EXT4_EX_FORCE_CACHE |\
 				 EXT4_EX_NOFAIL |\
-				 EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF)
+				 EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF |\
+				 EXT4_GET_BLOCKS_CONVERT_PENDING)
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7fc5fb7e819..3e4c0e1396ab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -750,6 +750,9 @@ int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
 
 	status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 			EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
+	if (status == EXTENT_STATUS_UNWRITTEN &&
+	    flags & EXT4_GET_BLOCKS_CONVERT_PENDING)
+		status = EXTENT_STATUS_CONVERT_PENDING;
 	ext4_es_insert_extent(inode, map->m_lblk, map->m_len, map->m_pblk,
 			      status, flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE);
 	map->m_seq = READ_ONCE(EXT4_I(inode)->i_es_seq);
@@ -911,8 +914,17 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	/* If it is only a block(s) look up */
-	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0)
+	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
+		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
+		    flags & EXT4_GET_BLOCKS_CONVERT_PENDING &&
+		    !ext4_map_mark_convert_pending(inode, map)) {
+			map->m_flags = 0;
+			map->m_len = orig_mlen;
+			goto create_retry;
+		}
+
 		return retval;
+	}
 
 	/*
 	 * Returns if the blocks have already allocated
@@ -934,8 +946,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
 			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
 			ret = check_block_validity(inode, map);
-			if (!ret)
+			if (!ret) {
+				if (flags & EXT4_GET_BLOCKS_CONVERT_PENDING &&
+				    !ext4_map_mark_convert_pending(inode, map)) {
+					map->m_flags = 0;
+					map->m_len = orig_mlen;
+					goto create_retry;
+				}
 				map->m_flags |= EXT4_MAP_MAPPED;
+			}
 			goto out;
 		}
 	} else if (retval == 0) {
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 4313694cd4e9..fb18fdcb3003 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -46,6 +46,7 @@ struct partial_cluster;
 	{ EXT4_GET_BLOCKS_CONVERT_UNWRITTEN,	"CONVERT_UNWRITTEN" },  \
 	{ EXT4_GET_BLOCKS_ZERO,			"ZERO" },		\
 	{ EXT4_GET_BLOCKS_IO_SUBMIT,		"IO_SUBMIT" },		\
+	{ EXT4_GET_BLOCKS_CONVERT_PENDING,	"CONV_PENDING" },		\
 	{ EXT4_EX_NOCACHE,			"EX_NOCACHE" })
 
 /*

-- 
2.55.0

