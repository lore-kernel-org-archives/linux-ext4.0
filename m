Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644037;
	b=KqsE4aH44AtPTkJbzM+3aKxbbPgWZbvaScYnUWa0ISTi7EtiUB0Xx4zsl4IFC2SVLwX/
	 hmTe+Tf3pT+zl4y7Dmz2rbUbLcgUTSeTOiFnFMpjIE65vNtuDrLeenndXlMH4Ri6d4f95
	 26bsPmw6HgWj/bBX+m2kQQFHfx/lNjGs7Ass45roEsNmdZyUwdk/V3MRy5dyEi8OQ04I6
	 L/YCsc7BiRDcbWU2dpPUuzocbX3l++eRZev4WbhGsBJtbrGLCWyjth6aVliRT/0fs4V7Y
	 fEls2qx8d93n8mMjJQ+HAl46CL/P4I7MiHQNXH8RFI9UJhp/+Lxsidh2j7hZrUXoGFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644037;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=0uDJBvBdsM0JNxlUqe+RPaGvpQvKtr72Hxrorln9LyQ=;
	b=mFAL/+Y5C1PNJKQyPsM2lADd3rVHOoQd4o/Er3hjot60pOeGcz6t+zNkllU7C7syRA09
	 d+DvdIAGjSwvZCgz3dJlt/CkBVqLGEaNHSJ2zmX+XvcOV7NSFPZpW5u0k9oo1aDUnlgxU
	 OmePh84bgMrgAjFKbSSxmxhMvg5UDdsAao8I9XV48X8cvNan1Dma9hPm2fa1Bqw8lVqoR
	 4pw5k4fWwwkoaaxqd8STQA9W7WYhE9i8oJRKgP+m5zsgubAzK7FMG/Oq7iiWQd/ejzCFu
	 s8MYQmF8nWLp5MgdS0oGQcpSrbAsxJJHNXbskrc4fQ3PVbvur6iqSme8MxSX+Y8fwUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=JTdVYFT1;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CA9606A326;
	Mon,  2 Nov 2026 18:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5CA9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=JTdVYFT1
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HiXiF2394315;
	Mon, 2 Nov 2026 18:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0uDJBv
	BdsM0JNxlUqe+RPaGvpQvKtr72Hxrorln9LyQ=; b=JTdVYFT1whLY0pW7E47fF8
	u2k6s2C0R89COj2e2yPgCQ0X27MZc/qb/EtFoezZnyE9gxu4NeNhVKeR9fz8raq/
	IUYaRD2mL80NlcGaEMd8Ke/+O2ExZyYya53y/FQD5v9CwwV24A9K0grYY+Ib+d0n
	zgz2iP+iW4aLmiaFyWytYGr/euPQDFl0AinKWTtkVNEAGNH9CHTX8V+/jAQxXZYU
	ptfIFUydzU9LElwkiRK66nnt1WK8ajoTmow6OtexaM7x5U5COaEZpmzKirrTzDm3
	GAyxx9+4G+kuCh6U7RdfqoFBgT2V0/NlBOYJrQrzBr8gUg+tDr/FUfsSswWvtPvA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn6rd267f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:26:58 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HYw4r1340213;
	Mon, 2 Nov 2026 18:26:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hnv5gq5p9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:26:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IQu1b46072202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:26:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 199FB20043;
	Mon,  2 Nov 2026 18:26:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06C3720040;
	Mon,  2 Nov 2026 18:26:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:26:53 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:16 +0530
Subject: [PATCH 1/8] ext4: add extra_flags param to
 ext4_convert_unwritten_extents()
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-1-266d2bb9e6dc@linux.ibm.com>
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
X-Proofpoint-GUID: slXtpYDeSHKgCeJXCx1-MY1ngZ8PDYol
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX/nPuMKCfzdQT
 K6W0SeBULc6RjXfCi/0U1tuJOIKLXC0bygOLqNup3V37uAvjKIENIVWoX36sZzCDBjnckSfVFez
 rsBCbMZ9WwYfMnmjHG3gWBZHhF40d+4Mt8NYh9LDjsmLDWd8WWiZTSkRejTL17Hvz7NEmLA1NGk
 ddjBDh0lr6dds1a7/7v/P27Jyqwylsu+05T08Wzu9DxTg6AlP7OhPrHzjePKrV4r1vJ70GHC1HS
 CUSnqfY7nEvxhQL0FE73T225RDuMNYuRVuBM324Y5hfZDCAenB/icicCY3iiIrh8euKXNK2/4mn
 wanl2o0+a1qqBYIERZD3L+ESNa2N7cIJwFctW0dF6uaXnri6xtBR+se7QYVdaHlctCGh4xImoek
 jHN77bvksYiijcb4F9aJsQeU5YU3TtN86SmMaqstuoEucN9FiFIpL+OQ7V3MaqWU9JoixwB3lqS
 1GRZU+c2SWZuy1mrSJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfXxaGs5mtc5HY3
 CljbpZhaq3Ue8MIbG0fElMRFLxqxH6MYbT72r60kdR7VijNu+navCyq3/ixk6RqGpYp/WaAG7hK
 5h/vKikH5HF8GQkGL2QKrw7s18SRrzQ=
X-Authority-Analysis: v=2.4 cv=QK391QLL c=1 sm=1 tr=0 ts=6ae8d5f3 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=8o_KzcTvTWn_gRpOEOsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: m2NzrC9PNCr4Qwu_lMXANml8ouGMXqpa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

Let callers pass in additional flags for ext4_map_blocks(). This is in
preparation of the upcoming changes.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h    | 3 ++-
 fs/ext4/extents.c | 8 ++++----
 fs/ext4/file.c    | 2 +-
 fs/ext4/page-io.c | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8d3af062a830..b72f90b6375b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3971,7 +3971,8 @@ extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 					  loff_t offset, ssize_t len,
-					  ext4_lblk_t *converted);
+					  ext4_lblk_t *converted,
+					  int extra_flags);
 extern int ext4_convert_unwritten_extents_atomic(handle_t *handle,
 			struct inode *inode, loff_t offset, ssize_t len);
 extern int ext4_convert_unwritten_io_end_vec(handle_t *handle,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7193429a05e1..a229983f91dd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4704,7 +4704,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 			ret = ext4_convert_unwritten_extents(handle,
 					inode, (loff_t)map.m_lblk << blkbits,
 					(loff_t)map.m_len << blkbits,
-					&converted);
+					&converted, 0);
 			if (ret)
 				map.m_len = converted;
 
@@ -5152,7 +5152,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
  */
 int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 				   loff_t offset, ssize_t len,
-				   ext4_lblk_t *converted)
+				   ext4_lblk_t *converted, int extra_flags)
 {
 	ext4_lblk_t max_blocks, conv_blocks = 0;
 	int ret = 0, ret2 = 0, ret3 = 0;
@@ -5195,7 +5195,7 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 		 */
 		ret = ext4_map_blocks(handle, inode, &map,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
-				      EXT4_EX_NOCACHE);
+				      EXT4_EX_NOCACHE | extra_flags);
 		if (ret <= 0) {
 			ext4_warning(inode->i_sb,
 				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
@@ -5248,7 +5248,7 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 	list_for_each_entry(io_end_vec, &io_end->list_vec, list) {
 		ret = ext4_convert_unwritten_extents(handle, io_end->inode,
 						     io_end_vec->offset,
-						     io_end_vec->size, NULL);
+						     io_end_vec->size, NULL, 0);
 		if (ret)
 			break;
 	}
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 50d3c92709c8..06ef7a9b9f83 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -457,7 +457,7 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
 							      size);
 	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
 		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
-						       NULL);
+						       NULL, 0);
 	if (error)
 		return error;
 	/*
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 734d856a6d47..4c5c77da2a5e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -685,7 +685,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 
 	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
 		ret = ext4_convert_unwritten_extents(handle, inode, pos,
-						     size, NULL);
+						     size, NULL, 0);
 
 out_journal:
 	err = ext4_journal_stop(handle);

-- 
2.55.0

