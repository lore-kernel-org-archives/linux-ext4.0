Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792299;
	b=kNjitWgtTw2I01361qh40xCwd5OqAttgueCnhFoGf8bOGEaIhCh+7m3pxIlHidyLXw3P
	 n6upHdD++0Q7gpKS2m+lWeJHHn8Ngm29MsZ5FhI2VJeiOZA0NHJd4WBagZ4TyVrwVoopO
	 mD8IicRTi4c56aPmDabXKHu7hhduqawB8TW5Rp5oPCovH80eE1xCuFWON+fh2reOcKQh9
	 ZzmcJG3INcinfk6dvQkkZsMzdgw/wOZd7id7EFuaAgoUmAh4BRKeGkFt4qEsQj7UU+qZf
	 j/a6xS5eCkMFg+AyQd0kZKufuhzf6P9AhGNFKHB0fjMZQhk4RDa6V7eqbxQ9D5x8qoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792299;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=MrOoOP07+90gpZXdo083rhgJ53+OMdWux7A2uV3LjJI=;
	b=JoenpSU3DnPBFtmpd9rwc6+PgOQ7q2qfnNaahoHy8jB6mt6WsalzYmm6xBawqhbX5N1F
	 zkmkHLLZUn6ZGbRVSIgTQoO7savsDyNYr8ULdS5/IDRIwThQlp+GudtgoPUlZE0Lw0VAU
	 zHKVqc/2FdiUHQOld+beYXftdeHi2Gc5Zi0Ko3fyX5TOGtHIi3elRHpl65Gpwb2fxF3f1
	 BSFh1DvuiaOGsaRe3CstqBRuPKP3IjHyV7puIfv2yXeRY6AysFk2rwvVD52gZWza6iho6
	 aCkDm6lVIYTVuHkb9pwVjyoRIxn1I+M4pXj3OPXv78B1/6cq4FcWTkFvuGGxTDIZTew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ovzKiSbU;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B57606A327;
	Fri, 27 Nov 2026 15:11:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25B57606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ovzKiSbU
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4ptc3419789;
	Fri, 27 Nov 2026 15:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MrOoOP
	07+90gpZXdo083rhgJ53+OMdWux7A2uV3LjJI=; b=ovzKiSbUmnScPScQHnMj57
	kvBK4klAxZK6FihMUs97J9euH45L3h5n+gxC+QWHxXggyr+yC8VeZN1G3kH+z0kR
	zjuz4FpEXSUFXw7wr7B09LxKX+QITnt/Xg58WgkvaBsG9QjeE/Q2O/Uc6lsP410Z
	UvuAEWuzx6ZX0WP2ob7JmvEWha/W/n+JL0M4jxO5JKRpWxN+uUbzM/JHolYDRATM
	c3f/YrBUN7a5clDQyTlb26B86GoL34FQEAybPDfgzaQny7U0pkpiPLYWZBY6N4e8
	PWmCgFe6wx8ROJ4uAmqiEqCyPjoVFJ0psxTGvz4Rf+p5x+3zmbZ72fovV8GL3EJw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fape82-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4EkN3998994;
	Fri, 27 Nov 2026 15:11:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j6x3h2kvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBOCa36110758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A9FC2005A;
	Fri, 27 Nov 2026 15:11:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 805F12004B;
	Fri, 27 Nov 2026 15:11:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:21 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:50 +0530
Subject: [PATCH v2 03/13] ext4: preserve convert pending extents when
 adding unwrit extents to es cache
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-3-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX0+l5kLTJGdWP
 ab3xbYppYY0J8Rkc6kZ4FYpGKx8DgctvtZrFTsZrR1ioKcmlyH5lgNPaIDWIqneXW/RsVkkLCPB
 hSRYR582kVW54Lyl0085n9beijJjexAqkfSc+1od0ASQniAMpzXggkXHtSOLjWRMo43C1LkcyWt
 JIfNDiN37Fei6KLMducqtVQOjHNvstT2+YO9yDC5l0FXIBcqqw5QFGOzdiw34K5pv38NblLZ7KP
 P8x0FTl26fiMIW59TI3zFiCdD3zpdVoHAIAEX7c+PthdTmLuWeWhfxbfTUYciZd2KxIcnM/RDz+
 1znMlpEEhikzrHYr2mx3+hxvZ0HxQSf2JpVTBF80nFp9PFXbShTfr69ZrjCDJ+lscXmC12VAs68
 EaSfF8jBNg+/pGPyyhPpd8oxTekSuJhYhOxBMhLfEAavJZw2yI6dfGWiVh4QEPkG39w9RjP8HwX
 ehE6Jyt76/JdN1vBdLA==
X-Proofpoint-ORIG-GUID: XeDyPzomIBbdeik6va9nBOYyV3gGyWws
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b099d9f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=8Wmn9muYVumICyO1oXkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EGUhQZqGN92SU7x_KpeiPxh3nk8CCdF9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX4mVDfmBePz4t
 k69uyXxJcwvUcnkKb0HSMfqMJ3ZT5HIF0EQkCq6L3ZuBPffVZHYtEkBTb4bTvkto+3DJ+91Ki9E
 X4RA5QXQeCDPO+zGUD4s7713Akd+yXU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611270060

ext4_es_insert_extent() interfaces overwrites the old range with the new
extent type. This can cause a CONVERT_PENDING extent type to be lost when
it is overwritten with unwritten extent.

This is undesirable because paths like falloc will call
ext4_es_insert_extent() which removes all extents in the range and then
adds the new unwritten es extent. To ensure this doesn't end up removing
pending CONV_PENDING extents, we add logic in __es_remove_extent() to check
if we are crossing any CONV_PENDING extent, in which case we don't cache
the new unwrit extent.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents_status.c | 67 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 28528f19be1d..75dd065106e4 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -181,7 +181,8 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end, unsigned int status,
 			      int *reserved, struct extent_status *res,
-			      struct extent_status *prealloc);
+			      struct extent_status *prealloc,
+			      bool *preserve_conv_pending);
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		       int *nr_scanned);
@@ -924,6 +925,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	struct extent_status *es2 = NULL;
 	struct pending_reservation *pr = NULL;
 	bool revise_pending = false;
+	bool preserve_conv_pending;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return;
@@ -946,7 +948,8 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	revise_pending = sbi->s_cluster_ratio > 1 &&
 			 test_opt(inode->i_sb, DELALLOC) &&
 			 (status & (EXTENT_STATUS_WRITTEN |
-				    EXTENT_STATUS_UNWRITTEN));
+				    EXTENT_STATUS_UNWRITTEN |
+				    EXTENT_STATUS_CONVERT_PENDING));
 retry:
 	if (err1 && !es1)
 		es1 = __es_alloc_extent(true);
@@ -956,7 +959,10 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 		pr = __alloc_pending(true);
 	write_lock(&EXT4_I(inode)->i_es_lock);
 
-	err1 = __es_remove_extent(inode, lblk, end, 0, &resv_used, NULL, es1);
+	preserve_conv_pending  = status & EXTENT_STATUS_UNWRITTEN;
+
+	err1 = __es_remove_extent(inode, lblk, end, 0, &resv_used, NULL, es1,
+				  &preserve_conv_pending);
 	if (err1 != 0)
 		goto error;
 	/* Free preallocated extent if it didn't get used. */
@@ -966,6 +972,15 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 		es1 = NULL;
 	}
 
+	/*
+	 * For now, to keep things simple we don't insert an unwritten extent if
+	 * there are conver pending extents already in the range. Hopefully they
+	 * will be cached once we finish the endio conversoin, however this can
+	 * be implemented later if performance issues are noticed.
+	 */
+	if (preserve_conv_pending)
+		goto skip_insert;
+
 	err2 = __es_insert_extent(inode, &newes, es2);
 	if (err2 == -ENOMEM && !ext4_es_must_keep(&newes))
 		err2 = 0;
@@ -978,6 +993,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 		es2 = NULL;
 	}
 
+skip_insert:
 	if (revise_pending) {
 		err3 = __revise_pending(inode, lblk, len, &pr);
 		if (err3 < 0)
@@ -1063,7 +1079,7 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 		}
 		/* Check and remove all extents in range. */
 		err = __es_remove_extent(inode, lblk, end, status, NULL,
-					 &chkes, NULL);
+					 &chkes, NULL, NULL);
 		if (err) {
 			if (err == -EINVAL)
 				conflict = true;
@@ -1502,7 +1518,8 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end, unsigned int status,
 			      int *reserved, struct extent_status *res,
-			      struct extent_status *prealloc)
+			      struct extent_status *prealloc,
+			      bool *preserve_conv_pending)
 {
 	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct rb_node *node;
@@ -1513,6 +1530,16 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	int err;
 	bool count_reserved = true;
 	struct rsvd_count rc;
+	bool has_conv_pending = false;
+	bool preserve_es = preserve_conv_pending && *preserve_conv_pending;
+
+
+	/*
+	 * Reset it, we will set it again based on if the range had a convert
+	 * pending entry
+	 */
+	if (preserve_es)
+		*preserve_conv_pending = false;
 
 	if (reserved == NULL || !test_opt(inode->i_sb, DELALLOC))
 		count_reserved = false;
@@ -1540,6 +1567,12 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	len1 = lblk > es->es_lblk ? lblk - es->es_lblk : 0;
 	len2 = ext4_es_end(es) > end ? ext4_es_end(es) - end : 0;
+
+	if (ext4_es_is_convert_pending(es) && preserve_es) {
+		has_conv_pending = true;
+		goto next;
+	}
+
 	if (len1 > 0)
 		es->es_len = len1;
 	if (len2 > 0) {
@@ -1583,6 +1616,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		if (count_reserved)
 			count_rsvd(inode, lblk, orig_es.es_len - len1,
 				   &orig_es, &rc);
+next:
 		node = rb_next(&es->rb_node);
 		if (node)
 			es = rb_entry(node, struct extent_status, rb_node);
@@ -1597,8 +1631,14 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		if (count_reserved)
 			count_rsvd(inode, es->es_lblk, es->es_len, es, &rc);
 		node = rb_next(&es->rb_node);
-		rb_erase(&es->rb_node, &tree->root);
-		ext4_es_free_extent(inode, es);
+
+		if (ext4_es_is_convert_pending(es) && preserve_es) {
+			has_conv_pending = true;
+		} else {
+			rb_erase(&es->rb_node, &tree->root);
+			ext4_es_free_extent(inode, es);
+		}
+
 		if (!node) {
 			es = NULL;
 			break;
@@ -1613,19 +1653,26 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		if (err)
 			return err;
 
+		if (ext4_es_is_convert_pending(es) && preserve_es) {
+			has_conv_pending = true;
+			goto out;
+		}
+
 		len1 = ext4_es_end(es) - end;
 		if (count_reserved)
 			count_rsvd(inode, es->es_lblk, orig_len - len1,
 				   es, &rc);
 		es->es_lblk = end + 1;
 		es->es_len = len1;
-		if (ext4_es_is_written(es) || ext4_es_is_unwritten(es)) {
+		if (ext4_es_is_mapped(es)) {
 			block = es->es_pblk + orig_len - len1;
 			ext4_es_store_pblock(es, block);
 		}
 	}
 
 out:
+	if (preserve_conv_pending && has_conv_pending)
+		*preserve_conv_pending = true;
 	if (count_reserved)
 		*reserved = get_rsvd(inode, end, es, &rc);
 	return 0;
@@ -1670,7 +1717,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	 * is reclaimed.
 	 */
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, 0, &reserved, NULL, es);
+	err = __es_remove_extent(inode, lblk, end, 0, &reserved, NULL, es, NULL);
 	if (err)
 		goto error;
 	/* Free preallocated extent if it didn't get used. */
@@ -2288,7 +2335,7 @@ void ext4_es_insert_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
 	}
 	write_lock(&EXT4_I(inode)->i_es_lock);
 
-	err1 = __es_remove_extent(inode, lblk, end, 0, NULL, NULL, es1);
+	err1 = __es_remove_extent(inode, lblk, end, 0, NULL, NULL, es1, NULL);
 	if (err1 != 0)
 		goto error;
 	/* Free preallocated extent if it didn't get used. */

-- 
2.55.0

