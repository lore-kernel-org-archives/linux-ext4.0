Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792325;
	b=H8KChW7T6Zy2mVCXQdFIYUIScejmlimVe2K/V0rSDx4OBHdhUuwRa+dTh6xtml/tTaTW
	 JYWYYHTPJTfgrbYVEozSV2NFhXsf06CSggoPiSZwO3XX+O9jqNwltvd2bQT5lQ5uWWoD4
	 WbAqPLaBN+WVZcG39+4XIh/T1bQ/zMIWdh5RhpqIZBmNUC5bMq1O1WfHHbDZS/SDJXqaB
	 +fnjCU/F5QaGu10wz3d44lOaekDyWoSuZlbvPlzgRzzTm5TSun03SI6PGNL/cOsObTg/I
	 Aq8LXI6IlIcC4DABqMDTmzhfm1Dvd3n8CRsX4pgWKfgu9aggPkqOxpMMeuayVrkUH9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792325;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=lpg0ncoykmDKs1xSMSt2yglWbBoIGA5BdLYsorDT/EU=;
	b=krtWNycUd6++uc2pKKf+IP8sJkQEzsezKBOE4GKCTGm/Y+8TUBqbVP3d4CWqV0DvnWiB
	 9qMHwXWO7wL+o53HobPvBZ7V3Lpv8pDxyVaANU54BnzQ+KAt2/qmWbZNRrpw4aPLAf4jV
	 Md7XvornL3QUkVnulWV6PBqxIKMj6nopyp4FQV5wVxW9LU1SxX2YA6eJSwaL1ayZo6klr
	 +DotUt4IFC52rg20WrDJPP86CoFnh+6Zi/d3Kwo5j6tuRfCxdntnTJbhxz7OZwl7gzbFV
	 vm1tulsMW3Be5VJMg3um0RBKgyu3jPhZIaa/DgSixXnOYnD+f4fOgvS3qo+psY8wzUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=pX4bPleS;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8A606A330;
	Fri, 27 Nov 2026 15:12:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72A8A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=pX4bPleS
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4i4e2011451;
	Fri, 27 Nov 2026 15:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lpg0nc
	oykmDKs1xSMSt2yglWbBoIGA5BdLYsorDT/EU=; b=pX4bPleS6wxBuFWlJfQAqw
	+U99RJm0md3V/BcXqIZkpOWSEkBmI2hyPjVrVF9HT9NjnD+V5aRO7+jzi8p7uJCV
	6mrh5A/R7Yr3Ibuows+5r+9C9+RFeUvVp6zaySYmfUmzk66EKkRpEmZAazGQVop0
	znkRpSVz+b1i1VUJCJAJHygNki84/cwplOpgVYRlRHCfRJclowxqWq6hKdrbI1rW
	k6YObOkJW2EAkt+5u7NY0T3vgrJ2Jf0n6kvheRcMn9L5mvFtdtMpI6hlRuahfOAI
	6BjesTNozK0dOev0OPfQj/ZGLFlIPlByZDAnkyIdvLkiUHBZnT/TNSyGoBrPsbwQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34p4wdsw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4IV13999029;
	Fri, 27 Nov 2026 15:11:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j6x3h2kw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBYuZ41550186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3035B2004B;
	Fri, 27 Nov 2026 15:11:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D00220040;
	Fri, 27 Nov 2026 15:11:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:30 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:53 +0530
Subject: [PATCH v2 06/13] ext4: add tracking for unwritten to-be-converted
 ranges in dio write path
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-6-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX6DoooQSfG8AN
 OFI7X0aNS++KCt83X3x6L915sDXyjSyTx5l6otmxTZH/MiRYC3NRonQPnq2fiHNvhUbeQpk9Ync
 FJskFxFfukLzi/Zoi5kp8HA43KVAf9c=
X-Proofpoint-GUID: 65GoiJ_G8t6bBBUHAEkTpTYduOnR6cEd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX/I22UvHWNGqQ
 U/wiBl1enCQnjoaMW+KXPgvZ7uR7J+SXpg6/y1F49Qj8a1GOiSLySip6XjYz4fYVQVdknBo2F25
 5ZbOxdyy0LhWSWSWClhj8jzZROcXLFIZFGFrwKGAv0x4F0OrfeFIi31ESi0wpiy4N5ZHozIn8w8
 aYqAJ73Ees69nT7W6bRs1zx/F/aaYezEmVLyedr5/ssVU4HZXuQ5xtho0Z3ZgWaE8Uq/ExQntWw
 egIYEL0153GYmlvZV96ZHiDZ3U6KoE+4W+DlmCXPaSVpBDdkfQ87uxqoXx5lLX0/KXN53vjK5Sn
 kcor82KHcIsp7pIsC3q5onmm6xQavQuRZK2CbDVGXMaQG0A2teyoNYYBFudygVHXQdJYdutORqP
 6WxIy5SbHniNwKQCRagLe8yGlY1lKWGisiIGrySknirhmk+ptGEPF27c3220ovpZlLARXynIHsr
 6BYA+IQHeufKgQcU3ZQ==
X-Proofpoint-ORIG-GUID: kJapyHt46rB7uhbWLooVnjTPEh4d1m9y
X-Authority-Analysis: v=2.4 cv=QabzLcbv c=1 sm=1 tr=0 ts=6b099dab cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=wT1gK5xhNOhQJJZUSJAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Make sure dio write paths pass the EXT4_GET_BLOCKS_CONVERT_PENDING flag to
track unwritten ranges that are about to be converted. This enables
tracking such ranges in extent status. This avoid data corruption by
allowing endio extent zeroout code to avoid zeroing over such ranges.

Error note:

Ideally, on an IO error we should clear the CONVERT_PENDING bits since they
will not be converted, however, this is not straigh forward in dio. This is
because nothing stops parallel overlapping dios to mark the same range as
CONVERT_PENDING. If one of those fails, clearing CONVERT_PENDING would be
wrong because the other dio is still depending on it.

For simplicitly, we just don't clear it at all on dio errors because:

1. Clearing unconditionally exposes the range for zeroout corruption that
CONVERT_PENDING was designed to solve. Not clearning it is much more
forgiving because it just disables zeroout fallback on such ranges.

2. One sideeffect is that we would end up leaving these stale unreclaimable
CONVERT_PENDING es entries but this would be rare and hopefully future IOs
would consume the stale CONVERT_PENDING ranges if this happens.

3. Solving it would require much more intrusive changes to refcount track
each CONVERT_PENDING extent status.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h  |  2 ++
 fs/ext4/inode.c | 39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8cce99d68978..72de06efb4b2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4221,6 +4221,8 @@ extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags);
 extern int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 				  struct ext4_map_blocks *map, int flags);
+extern void ext4_clear_convert_pending(struct inode *inode, ext4_lblk_t lblk,
+				       ext4_lblk_t len);
 extern int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
 				  struct ext4_map_blocks *map, int flags);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e4c0e1396ab..4aafd0aaea69 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -783,6 +783,37 @@ static bool ext4_map_mark_convert_pending(struct inode *inode,
 	return ok;
 }
 
+/*
+ * Drop the convert pending extents in the given range from the extent status
+ * tree. Convert pending is set when we map an unwritten extent which is
+ * expected to be converted to written for endio soon. If the IO fails, nobody
+ * will do that, so just drop the cache.
+ */
+void ext4_clear_convert_pending(struct inode *inode, ext4_lblk_t lblk,
+				ext4_lblk_t len)
+{
+	ext4_lblk_t end = lblk + len - 1;
+	struct extent_status es;
+
+	if (!len)
+		return;
+
+	while (lblk <= end) {
+		ext4_lblk_t start, stop;
+
+		ext4_es_find_extent_range(inode, ext4_es_is_convert_pending,
+					  lblk, end, &es);
+		if (!es.es_len || es.es_lblk > end)
+			break;
+		start = max(lblk, es.es_lblk);
+		stop = min(end, es.es_lblk + es.es_len - 1);
+		ext4_es_remove_extent(inode, start, stop - start + 1);
+		if (stop == end)
+			break;
+		lblk = stop + 1;
+	}
+}
+
 /*
  * The ext4_map_blocks() function tries to look up the requested blocks,
  * and returns if the blocks are already mapped.
@@ -4012,7 +4043,8 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 	else if (EXT4_LBLK_TO_B(inode, map->m_lblk) >= i_size_read(inode))
 		m_flags = EXT4_GET_BLOCKS_CREATE;
 	else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		m_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
+		m_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
+			  EXT4_GET_BLOCKS_CONVERT_PENDING;
 
 	if (flags & IOMAP_ATOMIC)
 		ret = ext4_map_blocks_atomic_write(handle, inode, map, m_flags,
@@ -4082,7 +4114,10 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		 * especially in multi-threaded overwrite requests.
 		 */
 		if (offset + length <= i_size_read(inode)) {
-			ret = ext4_map_blocks(NULL, inode, &map, 0);
+			ret = ext4_map_blocks(NULL, inode, &map,
+					      (flags & IOMAP_DAX) ?
+					      0 :
+					      EXT4_GET_BLOCKS_CONVERT_PENDING);
 			/*
 			 * For DAX we convert extents to initialized ones before
 			 * copying the data, otherwise we do it after I/O so

-- 
2.55.0

