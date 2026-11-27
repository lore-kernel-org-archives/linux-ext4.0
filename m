Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792319;
	b=pOgw5SmQ349hzqkhIb5Au6t2C5vNi/TL/eidpdnTVC7yGcY9sgMnmUJID6yNJRf5QSyD
	 UOdJFkBTz5pTag9vWE5kJHUNEUMzZsPCO7w47Ov+lCakmq0nVGj45LJDhfKnAOEqB94vr
	 Ad+l3QrOdkbvJ9hWdYRrnOEuleygB/OMrE9yORzn2MyFCZcYaGY5cBsIPlZw5sPq2ETeh
	 wnwCU4qrMEesq/XfDk6aj4phsMMXofJ6R6fi8fyuqxreJKR2nbQjJFFik0bUkcHdJ2t8Y
	 1b0AvYH7KRg+ecgqWNutIEMTcsP2yYA/AUuOzd69gdW5k/tUsvtj9lnuFXcobcs1kcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792319;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=YMUXT0SCY+fDEIb9ieBh5sFaUV9+u6wXKy3xNVGoW48=;
	b=Xsnu1Y8mQVkshXSQRQMMJNgW+lsAwDI3iidCmlx9SmHPcGh2cjY8rqgIZlpe9wly4aZV
	 Hl96GihZCeAuAhaheezFQ6JDdk6tu3UaX8XHDzt7hFBIpd4NaRq/1tKHhpW6Eqg0cZKty
	 7rotNQNHIGKwHLi2kkuPJaPvOeSxRaKmk6Osh4Tj/feA3CmgACLPM0qyOYk6+Inm+BcU8
	 +qkxLFo9nE603s596qLXg6avSIwdcoKv28EZwHDbqfpS8qYbk/kShUV290UlyTFqK74eA
	 kpN+6AM02RwvSIrzNfTuBcLPAdTWfLlTvZRiKKnSOUM3fc9eJwCDdNwKfjPYlj5Vn7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GbuOo4+l;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4F8606A333;
	Fri, 27 Nov 2026 15:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B4F8606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GbuOo4+l
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4kVc1650364;
	Fri, 27 Nov 2026 15:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YMUXT0
	SCY+fDEIb9ieBh5sFaUV9+u6wXKy3xNVGoW48=; b=GbuOo4+lgmRefNGs01tty3
	i4wUb8ItJ36jC+X9IzaoGcj6I4j/Ro5QrYTXkCK1qsHbhH5dBzBDHN5rtVZhJMd5
	QXTX6NQzP78kkkhFYJvmctTaLE+05X/EE9SfvzE84MIv/yV/6CulEaBvJhqe2x0E
	Ct4HISsnY3oi75ZUCCCotYgkJt3w5pqdmu5uTdPsjlm6T9pbngjF+WOT/rF4mBGv
	xwfAtU7kGYA5PIf83Ceh1VbfFUa1K+fUJT2Y0uUV1xiusuNSk4AkBrwGpVttTQdv
	c9FoO1mrFRnJngsLUCliYhEkdfeDEzC4Si9UlRoyr56SBsPEXULGJiZ0OmlSESXQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3pdcx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4KeE3999046;
	Fri, 27 Nov 2026 15:11:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j6x3h2kwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBbZi56361394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:39 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9577220040;
	Fri, 27 Nov 2026 15:11:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABA6C2004D;
	Fri, 27 Nov 2026 15:11:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:34 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:54 +0530
Subject: [PATCH v2 07/13] ext4: add tracking for unwritten to-be-converted
 ranges in non iomap buffered path
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-7-4106968e4d15@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b099daf cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=NAGOLVtzY8axqMEZ4iYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX1wNjj1QSJPxh
 ibwmwZ4AxgWPeoVy3jvGBlW7owi3Kkllh5pTak4wx7o3IE/Peud+Bc2adjv/7V0z6NQc5zon+Fo
 oWAFFV1DqlN6yP7KwA7u/a1wwk6txAE=
X-Proofpoint-ORIG-GUID: LIvb_oUfOBQ8-0I_IsHZSLGhI8M8zrl-
X-Proofpoint-GUID: Ck24X4HDCRg6T9TEX2qO8U_ulz5N5kw9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX26MDj0lA8XXk
 VLMDPs3lkHUW88Q93K6zg8HmgTbqaidYz/jppWkT+y/ElhQVtoIih7rcpG0BzexfwI5PwoBO/1G
 X9LOQb8l6svEtkJJNxxeKSJ1GUZyqWgodDXyIWDfYKByzLE9JCEVQukAh5u+CuLUnaAK+y+NqGh
 eYUxGUAdTyTC3z28qPCGJkca1DUbMAdAGrnCLJGMp1HeZ3EmDGdl1oRrMYOFJAh/D4r9KozWX2i
 +2nYcB2qOxZyZKeza+FeSGOXKngAveuhVrETycQZ/9w6k6kkysxl6Kl2ODe7Cg5VdUxn4sd3MOB
 Eea5Zb7+Q6EJ+biWA+8AiVIIDYxLYqjQWLEz0XwGEcsXKY5qYD0R8pB+d53vUA6addivoRxtcZ0
 2mKDPagZKgG5hoM32km4QqXcLbwXKSPRwHOZFa6hYn2p3NGW/DLc2qw2/XZjeLJgexQf7ljNn3r
 Zt3HKk0Pj4MQr8WkARw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Make sure non iomap buffered write paths pass the
EXT4_GET_BLOCKS_CONVERT_PENDING flag to track unwritten ranges that are
about to be converted. This enables tracking such ranges in extent status.
This avoid data corruption by allowing endio extent zeroout code to avoid
zeroing over such ranges.

Note that CONVERT_PENDING and folio writeback state will always exist
together (serialised by folio_lock()). This ensures paths like
ext4_move_extents() won't silently drop CONVERT_PENDING state (as it drops
es cache).

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c   |  3 ++-
 fs/ext4/page-io.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4aafd0aaea69..2031b1dd7069 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2633,7 +2633,8 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 
 	dioread_nolock = ext4_should_dioread_nolock(inode);
 	if (dioread_nolock)
-		get_blocks_flags |= EXT4_GET_BLOCKS_UNWRIT_EXT;
+		get_blocks_flags |= EXT4_GET_BLOCKS_UNWRIT_EXT |
+				    EXT4_GET_BLOCKS_CONVERT_PENDING;
 
 	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
 	if (err < 0)
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 059827b961ec..6753b35311b4 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -158,6 +158,24 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	kmem_cache_free(io_end_cachep, io_end);
 }
 
+/*
+ * The unwritten ranges of a failed io_end were marked convert pending in
+ * mpage_map_one_extent() before the IO was submitted but will not be
+ * converted, so drop the cached state.
+ */
+static void ext4_io_end_clear_convert_pending(ext4_io_end_t *io_end)
+{
+	struct inode *inode = io_end->inode;
+	u8 blkbits = inode->i_blkbits;
+	struct ext4_io_end_vec *io_end_vec;
+
+	list_for_each_entry(io_end_vec, &io_end->list_vec, list)
+		ext4_clear_convert_pending(inode,
+				io_end_vec->offset >> blkbits,
+				EXT4_MAX_BLOCKS(io_end_vec->size,
+						io_end_vec->offset, blkbits));
+}
+
 /*
  * On successful IO, check a range of space and convert unwritten extents to
  * written. On IO failure, check if journal abort is needed. Note that
@@ -195,6 +213,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 		if (ret < 0)
 			mapping_set_error(inode->i_mapping, ret);
 	}
+	if (ret < 0 && io_end->flag & EXT4_IO_END_UNWRITTEN)
+		ext4_io_end_clear_convert_pending(io_end);
 	if (ret < 0 && !ext4_emergency_state(sb) &&
 	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
 		ext4_msg(sb, KERN_EMERG,

-- 
2.55.0

