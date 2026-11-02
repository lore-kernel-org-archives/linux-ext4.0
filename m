Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644036;
	b=PcuVZ0L1xQ9Xg+kWqzM9EIGq9fG/lrOfuV5iRzA0Xf32ZbYClJ4tI4eHoSWeTmXxZzi9
	 l2oWRC7lH68YAH2UzLD0umocgPw5RvaP3NBU6XHRSH/j3Q3ceK71nVYbIvVEAmwNd2K/1
	 FJrddjw+wh90hrOYge2nixtCMPVXme4966iLlzpcWVURFqeOoExXY01DtNdtmJXmZYUyr
	 uAxW2JTNRM7JahsQ535laVW9kY1zjZyWZJYG+j87s/+gs94RqIjrS78Bhn6EPmS3vUO/k
	 jCRuzjeGf+uAvB79aCXP8L0+fK8wlXmPWfG367oTvU5VxPABKFs43O1O8Qw+EHS8pbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644036;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ok+J7wwb8qEeqwOc1QSPxabE9zzVpuStFmQMFQzaNMA=;
	b=ZsJDWfg0WctHGpDpsSOgIlxgoguzTkxmC8Y1lSC7a47/XvfNLQDHwIhuUSZykAG5fKle
	 3yqGtS343d946BfbG5CBbhOVlPULGBKY1AZDU4PQBELFZSrPnOzIl2+7+Xerti/nNdADA
	 EumCjJc+GVdt7Iy4cPF7iBWtha8nDLJ3yCI8278nQP5mWLWo0Cr8iR7Z2026NurNAf3A2
	 qfEf3w7DbXZPftak+fioaV8hj/1rB0UgdkU+zOovGHcH1kFOhq0sxJC9nDG2KbKnOMJbG
	 hVzgzhqPbADxYmfHxjvvTa507ed/tFmVIfE/OK2narzz/B45eqRHFxMwlEohstq7rmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Dyh3EMmW;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCFA606A327;
	Mon,  2 Nov 2026 18:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABCFA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Dyh3EMmW
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HiLOR3547365;
	Mon, 2 Nov 2026 18:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ok+J7w
	wb8qEeqwOc1QSPxabE9zzVpuStFmQMFQzaNMA=; b=Dyh3EMmW1/MxTytIKNzWo9
	PiUh8RKpKcBCYmadp9mNHl235JYc2VBG/XskVjrG0fXc2XK3nKXwYP5r6tyYP6/R
	FPBRLuWC1B/Ipqows+h7cMoJDFIkiHukRHFIFrTfxXdxwFNKy9r30aZ4iBeyCP+m
	NXcoiXAYLrVPF6XRXtUdi3KTcpekzIIrdMJrND2z9FB00UdjKjLt9G2q14dYXGiZ
	+XuzMQAcemsZDVipd9PjJXShAcMlDEFx8yinQpS1xDe5gXXMkGE6iA4HbKyXwQTN
	O3iVL6pg+cIyuf+Eip8sLhoeSktPxOw0tSbmy/1/vyMFezcu5oHY8GionTlySDgA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn826j63s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HnrDl1298152;
	Mon, 2 Nov 2026 18:27:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hnu1vfb0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IR1pZ49414622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:27:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B368020043;
	Mon,  2 Nov 2026 18:27:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7939020040;
	Mon,  2 Nov 2026 18:26:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:26:59 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:18 +0530
Subject: [PATCH 3/8] ext4: add tracing for i_conv_pending_ios tracking
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-3-266d2bb9e6dc@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: _0VGcD1mI6favHwAolkF2Epa1BN8SS3E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX7bsB/LVbTjYk
 wrBdmwtWP6cxsP74xuRPLo4xrQec3+4KbQyoXcsVKoncz3a5QsrQaqEa5+FhxILJRThQlBV+myy
 0oP5pcl54QAeRaq0PCEk4eTMHMcRuW8qW6QmZOBrXfQkagHNq00w4hfuk5C2r9eCggXF6MMVKzt
 0qVosEz0sxHqT0TS7/pWX3mZ+sDDNCW1NPscatcS2sCPPdrhrZ31W/z6L1m5BRhFVMrQgluCOkV
 t1PwJWYOmjDwfQgQJZP6rvu2OQ8UBliCWaDUhXShbIsRS+a4OhtH2NF8Edm2riBYZigi3aMmI3K
 vHN0Mr3qubqbCoqTQkzqPk/yakBApezyVM/55h3EAGlo9e4I9RQB3eJxIvHgFCpV/IGyY1WnCz2
 +74Lbu6mZbsMu8rGZiIh2Q4tP89SgQXZIj+5ZuSR6NWtrwwa6r0l4n9thtgUI+FLefSLHR1N/vK
 wFCd2yURPDLNqheEY6w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX16PgKh74Dt7I
 WhEivB5mpss5uLsmmf6nn2fn+9JEXOqJtCRoBDFjaE9B7wsu3+xxrTJh9HMP8MoBm4eOymQuZd6
 Vhy4nAQ32LDPcJYMhmzB5leJbD75aZQ=
X-Proofpoint-GUID: JCbrgk1iUg-cTrGQe0U2vplLdKXMwjg_
X-Authority-Analysis: v=2.4 cv=EsJHPicA c=1 sm=1 tr=0 ts=6ae8d5f9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=N9xzdwjjHSbJzcdf8AMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

Add tracing to track changes to i_conv_pending_ios count.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c             | 11 ++++++++++-
 include/trace/events/ext4.h | 24 ++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 280ba3d359e3..8b5cb37cdd6d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -673,7 +673,16 @@ static void _ext4_conv_pending_mod(struct inode *inode, int n)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
-	atomic_add(n, &ei->i_conv_pending_ios);
+	/*
+	 * Only use the full ordering variant when tracing is needed.
+	 */
+	if (trace_ext4_conv_pending_ios_enabled()) {
+		int new_ios = atomic_add_return(n, &ei->i_conv_pending_ios);
+
+		trace_ext4_conv_pending_ios(inode, n > 0, new_ios - n, new_ios);
+	} else {
+		atomic_add(n, &ei->i_conv_pending_ios);
+	}
 }
 
 /*
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 7d255c47c446..f1754b2e836c 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3367,6 +3367,30 @@ TRACE_EVENT(ext4_block_zero_eof,
 		  __entry->i_disksize, __entry->did_zero, __entry->zero_written)
 );
 
+/* i_conv_pending_ios accounting tracepoint */
+TRACE_EVENT(ext4_conv_pending_ios,
+	TP_PROTO(struct inode *inode, bool add, int old_ios, int new_ios),
+	TP_ARGS(inode, add, old_ios, new_ios),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(bool, add)
+		__field(int, old_ios)
+		__field(int, new_ios)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->add = add;
+		__entry->old_ios = old_ios;
+		__entry->new_ios = new_ios;
+	),
+	TP_printk("dev %d:%d ino %llu %s i_conv_pending_ios %d -> %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
+		  __entry->add ? "inc" : "dec",
+		  __entry->old_ios, __entry->new_ios)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */

-- 
2.55.0

