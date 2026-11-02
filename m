Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644040;
	b=WMPocLNLx21Oe7IeHa1uqFd/BrS9L+Ri4oaYRF0SPAW6DW6K50aohvV8j7HX9Kae/9yL
	 6vxwxxFN7VfTlVqZJY5t6HD47P6UMi9JYjxkVenJ+DEUOl3ktNLYVKFuIsFbx/XG5qRZU
	 vNYdty5LuzODwhW3UHAYONtZF6mEg6QBCgNf+2tHDP/HRBz7F2jCXiN14WIMwJbAXtH9W
	 8R3cMNq3bihJczcb3XK5y/OfZoW4AJaKZ1RHfidHU3/IhveUpcQjUcgi6stxfkdgVA73A
	 35wnCHVrlcfUpO8u29HRAMcNKROrs0953XjpYOzjNDOyyjtweGY6sbPKYQCDhp45IyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644040;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ESVfipfuEurDIlI4px67866MfLT4Bx5O7ToMFTa1QIM=;
	b=47i8qNG/JJUzSlM0OQtAZjviIoAwScts8dfcTeRM7iAue4hNwUxsswc1kkONMU6q/6d3
	 KrG0mg8SyDRc1hPfTZPz+0wZqQPb/Se2yJKvXM6L4hO8FIBSN6p3iHTKqrgrdiOsH7BO1
	 Uthryn7CWKLGRtD8aWdwqtQkPVrQkGxZpZbPKFEx01gm8iS34h+Xwzrs3pyuvEOdJ4/VK
	 nUoparffsqL6uyAhycrlmsqpMEuyK9pcVTn7XoyVmQi0yPZ2BtFrP4AtTYN/KSITmvN1f
	 Y6Dczy0DktSlNzHO+mNyeOlWFIXtuiAqQnpnGQKjwDVF/KBtMPrkp4JMg7fbDnbl/3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CVFhblb7;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D680A606A32E;
	Mon,  2 Nov 2026 18:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D680A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CVFhblb7
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HikX23547735;
	Mon, 2 Nov 2026 18:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ESVfip
	fuEurDIlI4px67866MfLT4Bx5O7ToMFTa1QIM=; b=CVFhblb7107D/FxiYWv6VL
	cWLvlPSEiV5+OKTdhvEHLG/8nmck5j8Zs9yTcEvpXKpwXthxWPVsGBvNQQ0/38Kp
	vE3OVe8BZCGr7u2LFyfIlUtMZt3WKkcM04EcZqJdo4JVLnEcNblwgpUwKAiqtE97
	fP0HInEUk/J2rgQVbwjnCbAZpukWzwZ5hHXRww2Es7XnMxXLj3PTbJwnKTTCSHQv
	ox8W3A/XVrNOxNzjx99BWN84vw70RT1/vzgoquT1eFvdFhCzq+JO2ck7gaHQLxhl
	p7TJiIjXQQLtWkWvNCB7JEv2qJrhDcA7yd0rIkSu59iIh47s60sA4/fdbg3ooVPw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn826j63x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HYtJi1313033;
	Mon, 2 Nov 2026 18:27:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hnwbxy0hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IR4TE45416766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:27:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4711A20043;
	Mon,  2 Nov 2026 18:27:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3572820040;
	Mon,  2 Nov 2026 18:27:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:27:01 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:19 +0530
Subject: [PATCH 4/8] ext4: don't zeroout if we have inflight unwritten IOs
 in non buffered-iomap path
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-4-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: BGomrpxdOO5WddmTOC7u6Z-gVALSbdbr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfXws/YyotBuGSq
 q7MDGzmcNn4WPD5VHSNWhCBtugKeIuqgXGO0D7XHa7/4enOtyLN2rF74/zDwff6GRxaVQ4GRlNU
 CHIUbM7R2z4UevgueRbmN0MjWIVIm/wlILi4R0+XpfQxHx6eOLqBWurvV+K1X8a9PDqAK/hEL/G
 DRX+4vmuUwgWzfMPgUo593Kkd5HotfIZpXn4xdBNvy9OWwqvpUKln2puP6h7XI8LWdm35furotx
 IISXll9v9oTv1pXK9zazNxaxBksnfQMJgOZmKzawwGM/BveyQHcOlDc1RzFEKcZLCN+rjXssTEU
 fEjj2Tm0FeiVpoH05Xsw+RfR8Q/0zx8BIce7nqy+7+YKGSxtlKIThKHcNYeXemIOL4yqmWUg+px
 h6PY/lAK35SpXo38C0RQJWgfxStRAeUdHBT3Al514n4GiwaoAKQ98mrlm88xfCDFC5qA8QYstKo
 BhmJ3yd20beQAvzHbKQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX2rjLlO1/CWGj
 oegssZB5rHJ/28rDfrtRQIx36LWMw7N1etmyOZbAJhfc/Ait+pMxCnySfMwzOL8fsmQJxUZeanL
 9Q4g1mhGJB+jcYl+5befXbLwSeNd72U=
X-Proofpoint-GUID: I1WkiKBmXnbIHVZxC8UOYlue_A34EHcS
X-Authority-Analysis: v=2.4 cv=EsJHPicA c=1 sm=1 tr=0 ts=6ae8d5fb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=09TKUD67hj14zptcu9kA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

When endio conversion of an unwritten extent fails (e.g. ENOSPC while
trying to split the extent), ext4 falls back to zeroing out the unwritten
portions of the extent and marking it as written. This is safe only when no
other in-flight writes have valid data underneath other parts of the same
unwritten extent, otherwise the zeroout would silently corrupt that data.

Commit ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
changed the dioread_nolock writeback (non buffered iomap) and dio path to
submit I/O without pre-splitting extents, deferring the split to endio.
This means multiple concurrent writes can share a single unwritten extent,
and a failed split on one of them could zeroout data belonging to another.

Fix this for dioread_nolock non buffered iomap writeback by making sure the
writeback path increments the i_conv_pending_ios counter when it encounters
an unwritten io_end, and decrements it after all the io_end_vecs have been
converted. The existing checks in zeroout paths then use this counter to
suppress the zeroout fallback whenever there are other unwritten IOs
pending conversion, preventing silent data corruption.

Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h    |  7 ++++---
 fs/ext4/extents.c | 29 +++++++++++++++++++++++------
 fs/ext4/page-io.c |  6 ++++++
 3 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1a01b1f809f7..44cd9f12d350 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4113,14 +4113,15 @@ extern int ext4_resize_end(struct super_block *sb, bool update_backups);
 
 static inline void ext4_set_io_unwritten_flag(struct ext4_io_end *io_end)
 {
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN))
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+		ext4_conv_pending_inc(io_end->inode);
+	}
 }
 
 static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 {
-	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
-		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
+	io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
 extern const struct iomap_ops ext4_iomap_ops;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d255884cf075..96d8ad012b2a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5286,6 +5286,19 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 {
 	int ret = 0, err = 0;
 	struct ext4_io_end_vec *io_end_vec;
+	int n = 0;
+
+	/*
+	 * We take a single i_conv_pending_ios count for every unwritten io_end
+	 * however each io_vec also needs its count to prevent a neighboring
+	 * io_end_vec zeroing its data. This can't be accurately done during
+	 * submission so do it here.
+	 */
+	list_for_each_entry(io_end_vec, &io_end->list_vec, list)
+		n++;
+
+	if (n > 1)
+		ext4_conv_pending_sum(io_end->inode, n - 1);
 
 	/*
 	 * This is somewhat ugly but the idea is clear: When transaction is
@@ -5295,16 +5308,20 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 	if (handle) {
 		handle = ext4_journal_start_reserved(handle,
 						     EXT4_HT_EXT_CONVERT);
-		if (IS_ERR(handle))
+		if (IS_ERR(handle)) {
+			ext4_conv_pending_sub(io_end->inode, n);
 			return PTR_ERR(handle);
+		}
 	}
 
 	list_for_each_entry(io_end_vec, &io_end->list_vec, list) {
-		ret = ext4_convert_unwritten_extents(handle, io_end->inode,
-						     io_end_vec->offset,
-						     io_end_vec->size, NULL, 0);
-		if (ret)
-			break;
+		if (!ret)
+			ret = ext4_convert_unwritten_extents(handle,
+							     io_end->inode,
+							     io_end_vec->offset,
+							     io_end_vec->size,
+							     NULL, 0);
+		ext4_conv_pending_dec(io_end->inode);
 	}
 
 	if (handle)
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4c5c77da2a5e..00abef904702 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -190,6 +190,12 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 
 		if (test_opt(sb, DATA_ERR_ABORT))
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
+
+		/*
+		 * Conversion was skipped so drop the count that submission took
+		 */
+		if (io_end->flag & EXT4_IO_END_UNWRITTEN)
+			ext4_conv_pending_dec(inode);
 	} else {
 		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
 	}

-- 
2.55.0

