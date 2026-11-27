Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792318;
	b=ayQq5xwl22wN/uY9yRr1VuknDow/QJ60TiZdh3fNkgwHeh61HIB4aKgjYNZrAUYUibJE
	 TZQgcWCmSVVYf6f+6jyuyKETtJNI0YWgQoCyK/Fh2VVn8d21/T7knPZwm6FIflfiIuW+Y
	 ylUsPyFMEu9euSqloyKip7+oolUDmNG94o0zhx+KsYkPCwio8hoFfqZFvglPRClsnMOp2
	 61Jp7YVy9mbGUaom3JfL+bs7RNRbwDuM3GojvvIKgUPnFPjcUGKMhsU2Gv6WOv4ReWbIO
	 qLrIW1vzpEvIimSVex/ZXQ6SZPVWvWogSCVlvU1Yp3gMmk0sEN+JEb5Y3xuaWl4Ngwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792318;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jIoJy+WpHz8VwnlMrstSlbHq1syCLRTno1W0RXK8W5A=;
	b=Vo4XKd3/IMFTOS9Dn1VngyJ0ihUFCKWAboPPs+z+jWGdbjIYzB3y1+7u2/gOeEi9KF0P
	 lbcxj0DWzQHfzePECDBJGWS22CDSEyckOcjsMwnAmca/VAyr+bK1UmG7vRuaOW7ZfVX/d
	 OF7bZ3ZvuW9R0+I4in9zMZh8dlGISqxCpAbLiZNpRu9olAbWXuo7Uqi7PCPRjulJdNx+X
	 5G0ldUlKdzHVb46NxQDK9rriQV+XMIHwbp5uqEzUpY9FenL4niLaM2fvgjgZP7crh9eDl
	 ZDNznr1GkHM9/ylAI3+UXCnYpU/Pyjlv+Tb87XuwK1zTWcAkOV/XFR9iL04HRFe30jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gKuyEQRw;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93936606A31F;
	Fri, 27 Nov 2026 15:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93936606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gKuyEQRw
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE5Fuw3267089;
	Fri, 27 Nov 2026 15:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jIoJy+
	WpHz8VwnlMrstSlbHq1syCLRTno1W0RXK8W5A=; b=gKuyEQRwX1hif0w77aJWn6
	y3aO8qHXW6n1HmRji9eyaJid7Arg0rTd5sbBdMKYfwsnM0j51J7Sh3dBIH4lNPjD
	okMQYv+aLRvPrZuatzg7sFgybwTX6MspLXPBauR1E6M/mDjQkVN4oO0trqmpjhqB
	nrYDeZK2MvkL9fGCM1wj/GK7uU8JNfn6hsP+NLjRW8gRlz0qiDd7TY1M26fbU77x
	/F2/iZeipq4pg0b6BqtzqGKmlkLieLb33UicQ5MsXebY7oJPM7VqRGj/7tbUwISq
	/PiCLI0EvhcQXRP+IjvDRquJuwyGfnpBPc5PKERkzHD+DpsRfO61uYjNxVhCnYNw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1nkcp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4IRu861630;
	Fri, 27 Nov 2026 15:11:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6mjg4j4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBfoM40108402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:41 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E742E20043;
	Fri, 27 Nov 2026 15:11:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BAF62004D;
	Fri, 27 Nov 2026 15:11:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:37 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:55 +0530
Subject: [PATCH v2 08/13] ext4: add tracking for unwritten to-be-converted
 ranges in iomap buffered path
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-8-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: isAicgJ3UgnLOh321glRsji5JzTY2yhc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX6kylH+j2awu4
 uUd0UfdQFYU5l+xQp+KTuM4GGJZ3/dtZ+3HktNmRQz6tt8Boypij4J6umBNHtYaITykd2nL+YIg
 rpe/JgPW1UTKXiF4XgbnIJa7Ym8WG9E=
X-Proofpoint-GUID: cYUGxIv08y8SRI3vWjm9AjF0jEaiyCr0
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b099db4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=josHmkeEqVZaHiLkUsQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfXw5YIAIprFSlh
 unw8JBog4DIMccT7wY3WfFdU0HQkZAOGwGi17JVjv0hQLTdzRhJ6JThXfU4lBsUVkEsV1QyIF9q
 vs5aB0DHY5Fy5r2G2R+bu6mQM7CY5lAj+lrtooWsvZpIRSBhgUHZEklWZFGESKmwfOMaJbNGByP
 Kz+my+r7RPu5XIoZK1I0HFFRviCs+Xk4TWCuVRcaSHSgQyu3zcVWjbbXUsajmT7luRpLYonJMLS
 Xb3mvLi2XkPJSpeL2Br05mALqWXJeBGFznIBXmVcAO0olZagZyhROuSQQBMXuILzkLW7wywvyA+
 UIieXe5VHaHRL8ffn+DGuUoikblUSJNGbOUTjr9i3pS3WXKA/bnDVMUSRVg5G2e5ik7k1oWXcWI
 nsGHtnIJrowHRIO5VyS7ARksyh80KodFn4aE/0es6EJAHQNppd+MvXhvAoXMv7TXxM4E7VrNxIq
 TAfT7S038PnMktU1ZAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Use the new CONV_PENDING tracking to track unwritten to-be-converted
extents in buffered iomap path in ext4. This ensures we don't zero out
unwritten ranges written by buffered iomap writeback path.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c   | 41 +++++++++++++++++++++++++++++++++++++++++
 fs/ext4/page-io.c | 23 +++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2031b1dd7069..947c20d081c6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4575,6 +4575,38 @@ static ssize_t ext4_iomap_writeback_range(struct iomap_writepage_ctx *wpc,
 	return ret;
 }
 
+/*
+ * Mark the unwritten blocks covered by @ioend as convert pending in the extent
+ * status tree.
+ */
+static int ext4_iomap_mark_convert_pending(struct inode *inode,
+					   struct iomap_ioend *ioend)
+{
+	u8 blkbits = inode->i_blkbits;
+	ext4_lblk_t lblk = ioend->io_offset >> blkbits;
+	unsigned int len = EXT4_MAX_BLOCKS(ioend->io_size, ioend->io_offset,
+					   blkbits);
+	struct ext4_map_blocks map;
+	int ret;
+
+	while (len) {
+		map.m_lblk = lblk;
+		map.m_len = len;
+		ret = ext4_map_blocks(NULL, inode, &map,
+				      EXT4_GET_BLOCKS_CONVERT_PENDING |
+				      EXT4_GET_BLOCKS_IO_SUBMIT |
+				      EXT4_EX_NOCACHE);
+		if (ret < 0)
+			return ret;
+		/* Blocks under writeback cannot be a hole. */
+		if (WARN_ON_ONCE(!ret))
+			return -EFSCORRUPTED;
+		lblk += ret;
+		len -= ret;
+	}
+	return 0;
+}
+
 static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 				       int error)
 {
@@ -4584,6 +4616,15 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 	unsigned int blocksize = i_blocksize(inode);
 	loff_t pstart, plen;
 
+	/*
+	 * The unwritten blocks are about to be written. Mark them convert
+	 * pending before the I/O is submitted so that endio doesn't zeroout the
+	 * range.
+	 */
+	if (!error && (ioend->io_flags & IOMAP_IOEND_UNWRITTEN) &&
+	    ioend->io_size)
+		error = ext4_iomap_mark_convert_pending(inode, ioend);
+
 	/*
 	 * After I/O completion, a worker needs to be scheduled when:
 	 * 1) Unwritten extents require conversion.
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 6753b35311b4..591dd539a44e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -666,6 +666,27 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 	return ret;
 }
 
+/*
+ * The unwritten range of a failed ioend was marked convert pending before the
+ * I/O was submitted but will not be converted. Drop the cached state so that
+ * it is re-read from the extent tree as plain unwritten. Since this is a pure
+ * extent status cache change, i_data_sem shared should be enough
+ */
+static void ext4_iomap_clear_convert_pending(struct iomap_ioend *ioend)
+{
+	struct inode *inode = ioend->io_inode;
+	u8 blkbits = inode->i_blkbits;
+
+	if (!ioend->io_size)
+		return;
+
+	down_read(&EXT4_I(inode)->i_data_sem);
+	ext4_clear_convert_pending(inode, ioend->io_offset >> blkbits,
+				   EXT4_MAX_BLOCKS(ioend->io_size,
+						   ioend->io_offset, blkbits));
+	up_read(&EXT4_I(inode)->i_data_sem);
+}
+
 static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 {
 	struct inode *inode = ioend->io_inode;
@@ -731,6 +752,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 			 inode->i_ino, ret);
 	}
 out:
+	if (ret && (ioend->io_flags & IOMAP_IOEND_UNWRITTEN))
+		ext4_iomap_clear_convert_pending(ioend);
 	iomap_finish_ioends(ioend, ret);
 }
 

-- 
2.55.0

