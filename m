Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792325;
	b=0wjbO2irBjmmT5qOvrCQ2hj/reuKatqPb859+uL4Z6i6tlCJOYEYUMycWWAKJkdLg61M
	 BzZysbmo0oas5p7Asxuj/MIoQtyAxonlDcQmYy769UpFOSkcfKff7BAs7uYjygW9n1lCw
	 RbaEY0doWM+i7/ZmlmUumsLr3FAUcGd6SCEXjCqKeHdxd/0XEGYErC9peLOuT8j450zWb
	 3fuK8tQutcwu24Z1vVUPN169RPVXPJG4tz9R8KmbmxvyIM6DKRHNjoWqslG7gk3zoAkf8
	 2SruTbhHPv4vuR3Wj7GN2WRlHvv1aEssG7pFCA9aSiWoA7v5RYU2nM3C4c6UajvNUlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792325;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=HU5IHJB+ykGJFGlbqXpT4HSr3PPjlHCGFtCDvF5MxnY=;
	b=UrYWKuNCs9L26R+5dw27HHkClChbHCf9ZHb3P0madBMLZgxZBhEyZK5esXb0sMajiJ7m
	 2UXHmMZAmEB38m/Ym0/yW0ynnhasEhHgTUwzYe3V510glUHZH6sdVOgl/GGYRmerNbVKb
	 pK8bV+fwdXkkEotdRu+Il6NlnHlbMDDoi5z4Ok3WLY3zicHMreOkzodSUkOJ2TxqFi9dt
	 gecbQhPGv0oQys1w3j69cQC+8UskC+OwTpEnskeWXWUrOterJax9NcYhZ1aUwyXKd+6WO
	 kf8G49jk5E+58X9NCg+Bq/DvhAZlv3JUzq+1Si0aGJ56ABk9x0EUcUXD5b7SQsPV7nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XSCBXUac;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8281606A32F;
	Fri, 27 Nov 2026 15:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8281606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XSCBXUac
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4gdd1650339;
	Fri, 27 Nov 2026 15:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HU5IHJ
	B+ykGJFGlbqXpT4HSr3PPjlHCGFtCDvF5MxnY=; b=XSCBXUacfF4YNyxnMkE95N
	kPo3B/2IQyXyWZa8cpWNM408AJ3uXSwoN14bED2ZRIBQifES5gitg2Ca1qOojnUW
	f8clQjQRVJQk0K9j2yYT2iVDr8B4ZU5DPEYBwE1snSECgSv5wv4QrVrKrtcpDcoH
	3yCXRq6sFNry7PSw4BDpNusqz15tMhzT8r1KZKZPC6209vV+Y01T+lB0+TYcHwHa
	Otc3xEIkzNevlh17IJaIwkwLl4EuUTEGYjOYNhA8TLK9eGojKBuddV8vf+jSyX7S
	i8ARxydlZxBp5dm5HiQSlxc2LG1CbZeB3vhVGZDQAXEn/LlSqlNG+wtxocMQgZBA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3pddk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4IqZ861621;
	Fri, 27 Nov 2026 15:11:53 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6mjg4j57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBoR328967576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C65732004D;
	Fri, 27 Nov 2026 15:11:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56CE120040;
	Fri, 27 Nov 2026 15:11:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:48 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:58 +0530
Subject: [PATCH v2 11/13] ext4: update extent status cache when zeroing
 extents
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-11-4106968e4d15@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b099dba cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=J7yO2ohVuTYQF1nAMCYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX3ZvrGrT6rBUB
 6GE/5Ida8ADw0nuWw+PKRVBUbdAjQOdgZ4UrF8ETsjK+mwYGhlMISFXNRbgv0EJ+y+ap73qsfdx
 oHZkB5qY8Njq95ZxLzPMsOAMYia6sHY=
X-Proofpoint-ORIG-GUID: PCpaOkCcoK20weqjkYAOdGD7UL20vWF8
X-Proofpoint-GUID: uGaysV0xU4rtxrMnBtjxBtl4tpS7mejB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX9wz0vn1xxYZW
 1n45l9DU80STTdYLjvI6l5ONEk5toCkZtMvZ+iEIqO4Z3G09L0lv5fD053Fdw/Pfdy0YY8WkiW9
 Ygkm8YXTFPwNQKpC3+m77hEBVuwHjDxKM68hvKQ5eZt8SXEIdHPx9jC/HYjSKJdtBLdeRQJvcWp
 V1K9K2fl8N3rl5CYXDHqJFLuMurbTOQ4eglwPSWDK3SySs/VEhw/BZ77pHE1e2C2K4kHW4mY/iy
 HNA78OEfJpAj1i4WGDQ+GJay6EFacvrZ/pwEMeoBK7bFeIeWjZZBLUu/GGA/11WNEdsVpnlFZ7g
 Fi1kFpBEqRDMLR/LqivAJTRxDez0e6VT4+v+saOjFnHISwNf5EhAgS/zcKU3jowpi1twtiCuwXq
 PhJwirSdTPsmxwFVoF4DDoiOEV+SDNcIlhFyViHtxODtiXfe2XhPpJEYxcSGK2oBgCSv0zDqWDr
 i2/O9uQ7suaOKan9D9A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

In case of zeroout fallback, make sure to mark the zeroed ranges as written
in the extent status tree. Be careful of only doing so once we are sure the
zeroout has succeeded and we have converted the extent to written.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0f5d9f3c42a9..e8ebc518e58b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3341,8 +3341,15 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 	ext4_lblk_t ee_block;
 	uint64_t lblk, pblk, len;
 	int is_unwrit;
-	int err = 0;
+	int err = 0, i, nr_zeroed = 0;
 	loff_t map_end, ex_end;
+	/*
+	 * zeroed[] is used to record ranges successfully zeroed so only these
+	 * can be added to the cache
+	 */
+	struct {
+		uint64_t lblk, len, pblk;
+	} zeroed[2];
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3397,6 +3404,10 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 			if (err)
 				/* ZEROOUT failed, just return original error */
 				return err;
+
+			zeroed[nr_zeroed].lblk = lblk;
+			zeroed[nr_zeroed].len = len;
+			zeroed[nr_zeroed++].pblk = pblk;
 		}
 
 		/* zeroout right */
@@ -3413,6 +3424,10 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 			if (err)
 				/* ZEROOUT failed, just return original error */
 				return err;
+
+			zeroed[nr_zeroed].lblk = lblk;
+			zeroed[nr_zeroed].len = len;
+			zeroed[nr_zeroed++].pblk = pblk;
 		}
 	} else if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
 		/*
@@ -3435,6 +3450,10 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		if (err)
 			/* ZEROOUT failed, just return original error */
 			return err;
+
+		zeroed[nr_zeroed].lblk = lblk;
+		zeroed[nr_zeroed].len = len;
+		zeroed[nr_zeroed++].pblk = pblk;
 	} else {
 		/*
 		 * We no longer perform unwritten to unwritten splits in IO paths.
@@ -3450,6 +3469,11 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 
 	ext4_ext_mark_initialized(ex);
 
+	for (i = 0; i < nr_zeroed; i++)
+		ext4_es_insert_extent(inode, zeroed[i].lblk, zeroed[i].len,
+				      zeroed[i].pblk, EXTENT_STATUS_WRITTEN,
+				      false);
+
 	err = ext4_ext_dirty(handle, inode, path + depth);
 	if (err)
 		return err;

-- 
2.55.0

