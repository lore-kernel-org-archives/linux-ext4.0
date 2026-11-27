Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792321;
	b=QUcOQsVrwEFMg4p/V7dPXx48JGzbalSW0eLAh8fh3tD4anV1fr2UTZKEmK3pCZsJ3lCK
	 QlmY6Uq+1QSA+GcW0Sv1N1tnSN9LIfaRnCLSC6HAQXTjJK121trg+ZCXT3kwqB6Axr3El
	 TzDoyBO3qInRia3n/UhIASZMYy9GtS4SUOdk2jG8IZOOZWLzOpWvYpznGkFr3bKaaQS7C
	 38lYDCetvDmBEIUnY1ZPlqvA4ta/LW0Ne5WiO10qovfKae8yCgeCtkCUauxuNmoloZK12
	 e5MJco7ccTlrVPwKiAMbyTfsoQd4tsHeN5EmYjQqLaMIoG6xNUysKLOS5byS3UBUsZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792321;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=JU/r0zrRnlonNopF8YGjIlPUjE3YQXAC9mYpkCQLc24=;
	b=G/PtvC9Onrwbo8QYrqan9B8J3fKarJwJCKBcV48kbfeZoBMa/ujLi4xnbNE1C3HUall7
	 WpXaiSi9jMvwQ39i/4CoPlPvouElHvWv5PICr3rBOeefobbexHciUzojfoXQQdv6kO96C
	 AGFC4k02ZJ8Hjo0/ElG4gHNLhERqNX3apf7ktwQ5juiwWTojHetxDk50Pj1bB/tG/yC4u
	 95Lh3joTRU9JPr409m2ZcwjFQW/wAIq8S9D0+S00wTy/oLqvtxs0cajru0pnRO1oWjzdK
	 8l/GWlNRBWtRq64Eua+goxNNKsZOuJaXcKBTYkCLHUmhchASuwkcGzw9LsWY8198vxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=QKCc72p3;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C9606A680;
	Fri, 27 Nov 2026 15:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F2C9606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=QKCc72p3
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4ZCS3266060;
	Fri, 27 Nov 2026 15:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JU/r0z
	rRnlonNopF8YGjIlPUjE3YQXAC9mYpkCQLc24=; b=QKCc72p3bNjCi8lq92crHy
	K0Hw3AFW6Bw9/dSe+MLWy9EZ9hhn0Hlf3Xq+NgbyOkEbcOKeBBJcJ4NMErpboyx/
	JrfUNZYEZYhOohFx2/cSTPtXLBeM0NCjiASK7BCn1WNwfeOlqk6woBuOnhntn/Fw
	hJ632sA2/KATI3nw8udCvXjuQV43Umhe4SFB6i7g00CHHniKANpQHG+KvyOZmV0O
	7mczi8hyKKzdLhCFfOO5YTxGGCQF7aJZbCUp0FdLgqNtBXbW5h+yzqQBKwyNhRlk
	zDlhF5zxa0Z50+e4IJFAjk40rfdiwuy/bq/pmfpVD9U4gsgIIZDHLY2QLxOOwVWA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fkxcd9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4Kj03893271;
	Fri, 27 Nov 2026 15:11:47 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j6uccu36c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBiNA53740004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E84A20043;
	Fri, 27 Nov 2026 15:11:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 883A32004F;
	Fri, 27 Nov 2026 15:11:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:41 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:56 +0530
Subject: [PATCH v2 09/13] ext4: don't zeroout if conv pending ranges are
 present
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-9-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX2ldktSaV0xaD
 t5ekJpb7ucg/VnmfxMyy1nzefYpyC1mMmT+rqj76MMUGpjEVi4gNky3rE3OiTSGAikSR0hfrqWC
 DxhxmJ0R+aKy+M4E7FFXC1PYnhK8orU/e66hadGSOkQ1+BeGNrB/ooi7wwmLBuOrlSEaaXIlt7I
 ock7xA5/5EMTiMODge8pum3LXCY0EOIkW1JT/553f+bFF1rz7yCkVct9EmSb3dP5zDU7QD1SChA
 xyS4QLlJJj9Tlc/CHIZ/kqym1lNmf1WkqC6wjo5rwEiTQfIhjhF0dMavYaAXGILxsmSmCzfOBA/
 IwX7AQ0kwnZoonIUtEb7WOYMLbfquueyC320RtdUKZABZvpsGWoSFwolExs8Pj4NDTX9U9zeFbw
 FlJBsgqqQwc5Gd94/F545QHE3KItj2coVDWdH5n/hEXuVjTbMP2y20jhBj4ToyutcAmSdSPeHxj
 8xoNvhM7G8W9qbEqcnQ==
X-Proofpoint-ORIG-GUID: QPDNnRKa0w8iOGwu_uMWhKZGRY1RTy1H
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX76sGGb4rKMxN
 8r3GKlMIwBBS0Cftb5oM7Efj0+rswfe34xEoZpe0WNLEIee3kS/Rm2SW5JAYCVjM4S1xacNYlL7
 LcJHeoyDglImNwT/Z6S1ittEKc7sjew=
X-Authority-Analysis: v=2.4 cv=A9z5rKWG c=1 sm=1 tr=0 ts=6b099db4 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=u8s7KiqzkzNccwjNZRwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZN7Kqvs78u-kd6-0HDQZEWrmiiVGUpsY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Currently, if ext4 is unable to perform a split due an error in endio, we
have a zeroout fallback which zeroes the neighboring ranges if they are
unwritten and converts the whole extent to written without splitting.
This is helpful to offset any transient endio errors, preventing data loss.

However, there exists a race which was causing us to zeroout valid data.
This was as follows:

1. Make an FS with no reserved to root reserved blocks and fill it
   completely.
2. Delete a file so that ext4_sb_info thinks there is free space but
   mballoc doesn't have any (until txn is committed).
3. Now when endio kicks in it eventually reaches:

ext4_handle_unwritten_extents
  ext4_split_convert_extents
    ext4_split_extent
      ext4_split_extent_at
        ext4_ext_insert_extent
          ext4_new_meta_blocks  // extent tree split/grow needs a block
            ext4_mb_new_blocks
              ext4_claim_free_clusters  // thinks we have free space but
	                                   mballoc has none until txn
					   commit frees it
              ext4_mb_regular_allocator
                // return -ENOSPC
    // ext4_split_extent fallsback to zeroout
    ext4_split_extent_zeroout
      // We try to zeroout surrounding unwritten ranges. This code has a
      bug where we zero an unwritten extent which could have valid data on
      disk whose endio has not yet converted it

The main issue is that zeroout assumes any unwritten extent is valid to
zeroout but it could actually be a soon-to-be-converted extent holding
valid data. Patches leading up to this patch have added a new extent status
cache entry that can indicate such soon to be converted extents.

This patch modfies the zeroout path to query these extents before taking
the decision to zeroout or not, hence allowing us to prevent the data
corruption.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 48c36322bbc8..b816e9edb041 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3342,6 +3342,7 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 	uint64_t lblk, pblk, len;
 	int is_unwrit;
 	int err = 0;
+	loff_t map_end, ex_end;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3349,16 +3350,35 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 	ee_len = ext4_ext_get_actual_len(ex);
 	is_unwrit = ext4_ext_is_unwritten(ex);
 
+	map_end = (loff_t) map->m_lblk + map->m_len;
+	ex_end = (loff_t) ee_block + ee_len;
+
+	/*
+	 * zeroout is only possible if we don't have range in the extent that is
+	 * pending conversion (ie IO is complete and endio conversion is
+	 * remaining) This is so that we don't accidentally zeroout a valid data
+	 * range we have not yet converted.
+	 */
+	/* Check left side */
+	lblk = ee_block;
+	len = map->m_lblk > ee_block ? map->m_lblk - ee_block : 0;
+	if (len > 0 && ext4_es_scan_range(inode, &ext4_es_is_convert_pending,
+					  lblk, lblk + len - 1))
+		return -EINVAL;
+
+	/* Check right side */
+	lblk = map_end;
+	len = ex_end > map_end ? ex_end - map_end : 0;
+	if (len > 0 && ext4_es_scan_range(inode, &ext4_es_is_convert_pending,
+					  lblk, lblk + len - 1))
+		return -EINVAL;
+
 	if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		/*
 		 * EXT4_GET_BLOCKS_CONVERT: Caller wants the range specified by
 		 * map to be initialized. Zeroout everything except the map
 		 * range.
 		 */
-
-		loff_t map_end = (loff_t) map->m_lblk + map->m_len;
-		loff_t ex_end = (loff_t) ee_block + ee_len;
-
 		if (!is_unwrit)
 			/* Shouldn't happen. Just exit */
 			return -EINVAL;

-- 
2.55.0

