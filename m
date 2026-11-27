Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792294;
	b=YzRZ3WtKD1J5dE5dafU8V7rEiIu751MfzavtfQUKrDMzEbAbAkSZDFPxfTaOYro9HeCS
	 jGIuM/UFVglWIBU1gnUHN3PjYSfPh+ZijuteQXbFligZKQuzf+NjMvXabJZBuq7hLpU+3
	 lbALq1btmEWAXEv4xly29lFEQVKflddbh8e4POC5z/FtsOTBmjZYCkjEXvX/l0Dv9Cthd
	 UucP0IbXD3dunSdP4uEho2AhGZUfXL4UFbJ90n8BvY82tNXddPSb/xLiMrDoN3yCUBajb
	 uC6WdMQGzKUWltX3cRg1okLBQSa1MEwC8kSToXTntWlMadaRcHDJChgI+NfVm64Vq7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792294;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=voYKhjwh4kAQNKY0DObnUntFyU1PYq7mrenLzSv2Czw=;
	b=eWhIoy763xrYPlwFjduZ7KL8cL4cS8CvpYIZqDQB0D5J+x8y8mOftapuaiD7Bx2cleCd
	 kjznkl5EfsFPv8QuXJpUQ0b28jnN3i5WsA9vSsmpHPdAQPjay52ivr5EaM2+dgZzhf8Y5
	 I2/a2leIhkB4XSa7gEChnXBjH1Ei0/gl6bhaFMVCWeMuTVIMbCY15Wpi4AbjCycGuNbYw
	 fwM2JwUVOUOJIVmCUOvUzFkMYfCsVwE5OA3fcHqG39W9prTICRGOLhNOemlUWA4MAVNO/
	 1KsByHeQa8Kf9apOHv91UsInj5QGUpXKDa25P8pv13CDPfgK7BctTEFwpI0/dhM5BNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=fKEcejIM;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF3606A323;
	Fri, 27 Nov 2026 15:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0BF3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=fKEcejIM
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4eIH3419404;
	Fri, 27 Nov 2026 15:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=voYKhj
	wh4kAQNKY0DObnUntFyU1PYq7mrenLzSv2Czw=; b=fKEcejIMBBlv+OPO+vtSHQ
	x/1MD0qeUWSvwlPxMjnENxMOtI5G8v3mLnk6f4AbJFJcO9/T0JcCjtfgRLn8ajgC
	Y886YvyngkUhux8UM2uO+IBrIGk3raPkZQ1SBgiIyxqMVwU1DECmJtnvox6ka2zN
	5uLGDW9Zh0LGbRPC17XTqiPC/IUIiYR6eFbF6r2KvCpojx67QRQ4c6K+40g643KP
	ghywryo94YdGG8rCihHAjGwVoH8r0bs9scDo7GCw6p2hSSPwi7Hm5IA3MuGJ68NQ
	LTUHnjIoXRB0wy/t6sIu7nfSKxmX+xj4wyyLaoy58TluSuEOPIU9HnMF/3xqrcxw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fape7r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4IRq861630;
	Fri, 27 Nov 2026 15:11:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6mjg4j3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBLb447776038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDE362004D;
	Fri, 27 Nov 2026 15:11:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B3982004B;
	Fri, 27 Nov 2026 15:11:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:17 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:49 +0530
Subject: [PATCH v2 02/13] ext4: introduce CONVERT_PENDING extent status
 type
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-2-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX+hSrb+TWAE69
 iGmrqBxYQky4RwxshDzp/3L7mwagDiTTJaF3S0yGah6NYx2OPeZvkgdia6H7xMYeO74vp8kNO3s
 qxNux29beWfPMDpVF0HCs5g+fr56q0HIfWymEkaE0f2C7vGIFIo0KV/gdhfGfKwet6kn6CeK6wO
 1hNr5QVDqb02T1tAxS6Msz2cGbwUkSWWVPpDMZzhXLoeVtdipTaU54Nq3reQA011sKndROyX/CA
 9K6e0fJ5F7TNg2/teUM2v8YsoGGdTaKGTrqJnqVYOxB5AIFP0E0u+QBcbrtzltI/QDODW5kcGD5
 nHvxxWclX8SYdDIucaAXOzHqEXKnVYKI1gQ069drFs9qCbGxH0BGRtwYUirM6VoLR1BV8p/8aoC
 zHrYVsoYn8R9bWZNOKOd5q3EH5rzbz/o/cpCe0UOmxCjkq1RcxB6yKC1ezBgm1J0D3zgAfJLdrn
 lpMlxIQ2I35TXgzB48Q==
X-Proofpoint-ORIG-GUID: lEU_CwWrDxuJphqWBSk3rxisCDzuJNP1
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b099d9c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=LI9O5cAE_hu846yXmVEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: IYeFc_4MsLFtoCo3MDjo25FtAUt4RQFR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX1nxHG+++0uvY
 5It+hAzDWO2EOcYSkveryN4PNF2t7Shnn8otuiz5KKbtNRZDnmI/c/zMbdFVmngBTwQT4lJqLHH
 ZZJ0X6/IauaiHePxe1dvuPINd0O73Xk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611270060

Add support to track ranges that are in an unwritten state but actaully
cover valid data. These are the unwritten ranges which have an in progress
disk IO, but are not yet converted to written via endio handling.

Upcoming patches will use this extent type to avoid zerooing out such
ranges during endio extent splitting, because they cover valid data.

The lifecycle of an extent undergoing write is now as follows:

1. Say we start with an extent (0,10,unwrit) which is also cached in es.

    Ondisk:     [0,10,unwrit]
    es cache:   [0,10,unwrit]

2. We perform a write to (0, 5):

    Ondisk:     [0,10,unwrit]
    es cache:   [0,5,conv_pending][5,10,unwrit]

3. IO is finished and endio handler converts (0,5) to written:

    ondisk:     [0,5,writ][5,10,unwrit]
    es cache:   [0,5,writ][5,10,unwrit]

An extent of CONVERT_PENDING type will behave similar to an UNWRITTEN
extent for most of the purposes like read. Just that we will take special
care in es cache to make sure the conv_pending range is not split or merged
so that we don't lose the status. Similarly, it also can't be evicted from
memory because we don't want to lost the status.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents_status-test.c |  8 ++++----
 fs/ext4/extents_status.c      | 18 ++++++++++++++++++
 fs/ext4/extents_status.h      | 11 ++++++++++-
 include/trace/events/ext4.h   |  4 +++-
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents_status-test.c b/fs/ext4/extents_status-test.c
index 825d12513e4a..014475bae07c 100644
--- a/fs/ext4/extents_status-test.c
+++ b/fs/ext4/extents_status-test.c
@@ -452,13 +452,13 @@ static void test_es_bitfield_written_and_unwritten_encoding(struct kunit *test)
 static void test_es_bitfield_delayed_and_hole_encoding(struct kunit *test)
 {
 	struct extent_status es = {};
-	/* 59-bit physical block field (64 - 5 status bits) all ones */
-	const ext4_fsblk_t max_59bit_pblk = 0x07ffffffffffffffULL;
+	/* 58-bit physical block field (64 - 6 status bits) all ones */
+	const ext4_fsblk_t max_pblk = ~ES_MASK;
 
 	ext4_es_store_pblock_status(&es, ~0ULL, EXTENT_STATUS_DELAYED);
 	KUNIT_EXPECT_TRUE(test, ext4_es_is_delayed(&es));
 	KUNIT_EXPECT_FALSE(test, ext4_es_is_mapped(&es));
-	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), max_59bit_pblk);
+	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), max_pblk);
 	KUNIT_EXPECT_EQ(test, ext4_es_show_pblock(&es), 0ULL);
 
 	ext4_es_store_pblock_status(&es, 0ULL, EXTENT_STATUS_HOLE);
@@ -472,7 +472,7 @@ test_es_bitfield_referenced_and_pblock_update_preserve_state(struct kunit *test)
 {
 	struct extent_status es = {};
 	const ext4_fsblk_t initial_pblk = 0x123456789abcULL;
-	const ext4_fsblk_t updated_pblk = 0x07ffffffffffffffULL;
+	const ext4_fsblk_t updated_pblk = ~ES_MASK;
 
 	ext4_es_store_pblock_status(&es, initial_pblk, EXTENT_STATUS_WRITTEN);
 
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index b7fb8502f9d4..28528f19be1d 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -529,6 +529,9 @@ static inline bool ext4_es_must_keep(struct extent_status *es)
 	if (ext4_es_is_delayed(es))
 		return true;
 
+	if (ext4_es_is_convert_pending(es))
+		return true;
+
 	return false;
 }
 
@@ -594,6 +597,12 @@ static int ext4_es_can_be_merged(struct extent_status *es1,
 	if (ext4_es_type(es1) != ext4_es_type(es2))
 		return 0;
 
+	/*
+	 * Don't merge block range that's about to get converted to written.
+	 */
+	if (ext4_es_is_convert_pending(es1))
+		return 0;
+
 	if (((__u64) es1->es_len) + es2->es_len > EXT_MAX_BLOCKS) {
 		pr_warn("ES assertion failed when merging extents. "
 			"The sum of lengths of es1 (%d) and es2 (%d) "
@@ -1076,6 +1085,15 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 	    ext4_es_type(&chkes) == EXTENT_STATUS_DELAYED)
 		return;
 
+	/*
+	 * An ondisk unwritten extent is allowed to conflict with
+	 * convert_pending since the latter signifies an ondisk unwritten extent
+	 * about to be converted to written due to endio.
+	 */
+	if (status == EXTENT_STATUS_UNWRITTEN &&
+	    ext4_es_type(&chkes) == EXTENT_STATUS_CONVERT_PENDING)
+		return;
+
 	ext4_warning_inode(inode,
 			   "ES cache extent failed: add [%d,%d,%llu,0x%x] conflict with existing [%d,%d,%llu,0x%x]\n",
 			   lblk, len, pblk, status, chkes.es_lblk, chkes.es_len,
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 01cddcaaa68e..2247f811f6c3 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -36,6 +36,7 @@ enum {
 	ES_DELAYED_B,
 	ES_HOLE_B,
 	ES_REFERENCED_B,
+	ES_CONVERT_PENDING_B,
 	ES_FLAGS
 };
 
@@ -51,10 +52,12 @@ enum {
 #define EXTENT_STATUS_DELAYED	(1 << ES_DELAYED_B)
 #define EXTENT_STATUS_HOLE	(1 << ES_HOLE_B)
 #define EXTENT_STATUS_REFERENCED	(1 << ES_REFERENCED_B)
+#define EXTENT_STATUS_CONVERT_PENDING	(1 << ES_CONVERT_PENDING_B)
 
 #define ES_TYPE_MASK	((ext4_fsblk_t)(EXTENT_STATUS_WRITTEN | \
 			  EXTENT_STATUS_UNWRITTEN | \
 			  EXTENT_STATUS_DELAYED | \
+			  EXTENT_STATUS_CONVERT_PENDING | \
 			  EXTENT_STATUS_HOLE))
 
 #define ES_TYPE_VALID(type)	((type) && !((type) & ((type) - 1)))
@@ -173,7 +176,13 @@ static inline int ext4_es_is_written(struct extent_status *es)
 
 static inline int ext4_es_is_unwritten(struct extent_status *es)
 {
-	return (ext4_es_type(es) & EXTENT_STATUS_UNWRITTEN) != 0;
+	return (ext4_es_type(es) &
+		(EXTENT_STATUS_UNWRITTEN | EXTENT_STATUS_CONVERT_PENDING)) != 0;
+}
+
+static inline int ext4_es_is_convert_pending(struct extent_status *es)
+{
+	return (ext4_es_type(es) & EXTENT_STATUS_CONVERT_PENDING) != 0;
 }
 
 static inline int ext4_es_is_delayed(struct extent_status *es)
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 92048da9dae4..4313694cd4e9 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -77,13 +77,15 @@ TRACE_DEFINE_ENUM(ES_UNWRITTEN_B);
 TRACE_DEFINE_ENUM(ES_DELAYED_B);
 TRACE_DEFINE_ENUM(ES_HOLE_B);
 TRACE_DEFINE_ENUM(ES_REFERENCED_B);
+TRACE_DEFINE_ENUM(ES_CONVERT_PENDING_B);
 
 #define show_extent_status(status) __print_flags(status, "",	\
 	{ EXTENT_STATUS_WRITTEN,	"W" },			\
 	{ EXTENT_STATUS_UNWRITTEN,	"U" },			\
 	{ EXTENT_STATUS_DELAYED,	"D" },			\
 	{ EXTENT_STATUS_HOLE,		"H" },			\
-	{ EXTENT_STATUS_REFERENCED,	"R" })
+	{ EXTENT_STATUS_REFERENCED,	"R" },			\
+	{ EXTENT_STATUS_CONVERT_PENDING,	"C" })
 
 #define show_falloc_mode(mode) __print_flags(mode, "|",		\
 	{ FALLOC_FL_KEEP_SIZE,		"KEEP_SIZE"},		\

-- 
2.55.0

