Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644044;
	b=4EhJ+329/Ubzg/yF/AF4cm6rRkfcE9BvltCnZKFLE+hFtCi2CoYh1JjHNI2z4AfoKiBO
	 laqkCN+ehK1j1K7uCCk51cemvmA6P65qP4xHegoonfAz98tvZWzUmrTQZ4HUXQcod1A/7
	 DrTMO1pUL7MRt3CuvI5k12WIBQ7zW9ejlHkHyi26h39jGkWWTuAzAwilZLgTd3vcXlBg+
	 HT722BEfy+xTgr2mOzfx/57feK3iBXrHiathXTrB+3BcEI0vMUSEWecgJGaz1RDiPk9ZZ
	 nK/GBVeqR338SPX2wa8xlBtc/poBxH0T1Ei5HkbWYEVfnHeyXL30pZNSKWi05BuOByA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644044;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=DP2GZEmFT1z+cmcWrf3/nIHk4cOH/jhMVFGut6e4U+g=;
	b=kbPVOI3/pGovkjG5ncA5qtrl1XUJVzTpJha+OVqxRxJrJpmj/X+1oBJpRLwh2cjtLGEY
	 4Ebm8xLl+po3YzO9AuNAwVWr54UGqQ3IwGJUn5TIycFoj2AWqNcZD2dm56gIiZyaHtcUY
	 /aZyU4es8GRd3Ex3gEawCb/vsZDOItv7/58rfa0Z8TmnqZ0SHM7GPRa4CAP9K7xUo3O8y
	 ub9TO+OEelT8E1JKdowNu8o3PlCAsh3Yte3avuyZzPvZFk4VBuQVGhgIn+yPT0NSQ3Kls
	 SK7b09Fi4yX/w28POzqrvnktUGvcdnRArkKp2MscQB7jlOPJttpJZsKRSucM5YwYjzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=bXNuYhml;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38836606D830;
	Mon,  2 Nov 2026 18:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38836606D830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=bXNuYhml
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HiYDU3558473;
	Mon, 2 Nov 2026 18:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DP2GZE
	mFT1z+cmcWrf3/nIHk4cOH/jhMVFGut6e4U+g=; b=bXNuYhmlCbkN9HYnNxr2r8
	Es3wAN3JLY/h8CNjTJ+kLsIhJ5cf/FRplUdEReEofAX2iPA0VKrqS8hQ65cg5NHP
	WdQORfrfV0uj4c1fnpfxg32KosiGQ9QZb7SyCePmy+5+9mBSDmAPyylqtwfbEP/7
	UqrqLtZtpnDeTjsM2tIEWbDhLy+Sv//ss6eLoe3fLb81aJtM7IOrFeeMPujRGorN
	7T7ArATZbqwxIBqPb6l41gXydO2jaBHRCheS9NCoSEuOoiv8mXnQXQMDn9JPz5Zp
	FMvxG8i+xREgc/TDB0kiWPTxNg00ie9+os6B1bmETY/ks3rMWnYa1DuhAvkd3XUQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn7yrt235-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HZ3tr1272225;
	Mon, 2 Nov 2026 18:27:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hntnpydeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IRBaM43647360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:27:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 886F920043;
	Mon,  2 Nov 2026 18:27:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 939D620040;
	Mon,  2 Nov 2026 18:27:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:27:09 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:22 +0530
Subject: [PATCH 7/8] ext4: don't zeroout if we have inflight unwritten IOs
 in buffered iomap path
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-7-266d2bb9e6dc@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=Mcr5KJ/f c=1 sm=1 tr=0 ts=6ae8d602 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=9Cz5wMJeLnYX5g6PH5cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX9DkTaJlBbtwc
 pkz1ESirburqnHEyUMCbHlBSAneALR5D2jBxemuvRPOsvXOCMUqjaDvyt5GJfjzJh7byIqyUR6o
 YWVnrF/VgRoAz1tCrycbfIKTqqLLIWI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX7H+nJMYVrFn8
 q9uyTUZKHGOHOrN6XtPSZEZNS4oUGABsSUbd+sM3vXBEfm+0BGaaR0+7iiP51QCAJ/TmLDSC666
 UBZ3u7GyyEjIK7XIeEB6P4H2VBLoTNrwyBJ/Rw6qzt2uNUTpAYGV6nqss7TFkbMg5zZdW8k1frl
 8JS2TegI7WzL82GDhci7BLlmS/MmnwP9bjiKFlaSc7+nB/YKH8JgCVp9CZdfSGYmGC9sxQ3fHwf
 enM5QhMJZQqpnldDjPux9qWtP3JZsO2pFrN6ZeaFeXZOSsWb6I62japtpYTJYbHC5qeYuKYqJuB
 jfGFGVQIxolqqrD38ynQ2M3Nt+/e6cVYrX2ZrL0Y+BbmGsNfVGbSkskVlpzcl1MWwFdDeSp+2AW
 e9h3g6lwPKGxXR9RJllycknAMPgnIV+9FeMztKFVaMrKlVDVGj/+5ul6o5r3lwoTyuwv4S8DFis
 sAf/d540iwTE/lD0pew==
X-Proofpoint-GUID: XBzPUjBvY6bSNWUiX6sZQrlKmj80vtm8
X-Proofpoint-ORIG-GUID: Wdckbhf_CtiijEXSV11OdCQkXCZHgti7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020072

The i_conv_pending_ios counter tracks the number of unwritten IOs that
are currently undergoing endio conversion, and is used to prevent
ext4_can_zeroout() from zeroing out unwritten extents that have valid
data pending conversion.

Enable the tracking for the buffered iomap writeback path by incrementing
i_conv_pending_ios once per submitted unwritten ioend in
ext4_iomap_writeback_submit() and decrement it after extent conversion.

Fixes: 8c4f6e337634 ("ext4: introduce a mount option for iomap buffered I/O path")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c   |  3 +++
 fs/ext4/page-io.c | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9d7d4da0071f..0c924ad8210b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4585,6 +4585,9 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 	if (ioend->io_bio.bi_end_io)
 		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
 
+	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
+		ext4_conv_pending_inc(inode);
+
 	return iomap_ioend_writeback_submit(wpc, error);
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 00abef904702..e99816017a18 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -652,6 +652,21 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	int credits;
 	int ret, err;
 
+	/*
+	 * We increment conv_pending for each IO we submit but endio might have
+	 * merged them into a single ioend. The data of all merged sub-ioends is
+	 * covered by a single conversion, so drop their counts keeping just
+	 * the one count for the single ioend we will try to convert.
+	 */
+	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN) {
+		struct iomap_ioend *sub;
+
+		list_for_each_entry(sub, &ioend->io_list, io_list) {
+			if (sub->io_flags & IOMAP_IOEND_UNWRITTEN)
+				ext4_conv_pending_dec(inode);
+		}
+	}
+
 	ret = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (is_disksize_grow)
 		trace_ext4_iomap_wb_disksize_pending_complete(ioend->io_inode,
@@ -704,6 +719,10 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 			 inode->i_ino, ret);
 	}
 out:
+	/* Drop the count of the head ioend now that conversion is done. */
+	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
+		ext4_conv_pending_dec(inode);
+
 	iomap_finish_ioends(ioend, ret);
 }
 

-- 
2.55.0

