Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC9D175A9D
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 03:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.149.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785469043; cv=none; b=RhVDXcnSWantqKrOUjYzVH2K+CPwheUYaTgUaAuRuKZvmDG19Ohf8uv7K9h+5eLbWQ3zjALA1Qvc3bTdLqHC8/6c3bkOoituZLhprXKfpkPDRgbA+AN1CmxVUvWHw5w54FC94jonP17qF3y5S9yfUCVgTY9n2q5D5SGGdldw4po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785469043; c=relaxed/simple;
	bh=bpXmj8D6pzhiHJm9T8Xa25dOeyposqkdIzKgSbajljA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6AQ6rEyVzZb829wceXdQ2tAckeNuSams48j3A3W4EdTLHe1Y1FYLwJB/cp7ej3qtMFORmc+BqkWdy/vXo2w3YKQmLYJF17AXCWEs/WgKpj1lznDz9nL77Auyfc4LZkVF+N0NEfW/EKCud4nm8O3wGcsVsFJYqPM4GWaPCAZspA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=lXW0jGJi; arc=none smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="lXW0jGJi"
Received: from pps.filterd (m0409408.ppops.net [127.0.0.1])
	by m0409408.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 66V2eiqP2344429;
	Fri, 31 Jul 2026 04:37:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=apr2026.eng;
	 bh=esZ3vJCfFW3M8HWe/E+P+psdkE69NUr+xoAbs7xAV6E=; b=lXW0jGJiVFcr
	RfkiSLfEgmUQ3SU13ctkNr7URkYz1rkIBKelXKriYaBe0VGtE8p6FFfKcT8khXNe
	pYUX5gkb29iGj5kP6ACNuKq0xtETJOnCArrdxRjIyDhN/zc5jP9PguYzGYHK+avG
	quMFuL4V2VUwsrwH56i0kYNfRptf9PFriBdxUkMdZ+wTzvN2hc1DuIpRJUjij2jn
	6wYxIxYBIwad7SPi3GMDSjDPyHrTcG3lRaUuBnrVuhrentjEra3WvPhbI/W9ggKh
	jjoO5nGzz4TCP68Z9WTFrYSCep1VM4AWS+DXJC0LcHKF6eecArICfCPJfFMI7cS3
	x0I/WhwFbg==
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19])
	by m0409408.ppops.net-00190b01. (PPS) with ESMTPS id 4fre68u847-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 04:37:15 +0100 (BST)
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
	by prod-mail-ppoint2.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 66V3XxW5011872;
	Thu, 30 Jul 2026 23:37:14 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.221])
	by prod-mail-ppoint2.akamai.com (PPS) with ESMTPS id 4fr5jsk10m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:37:14 -0400 (EDT)
Received: from ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) by
 ustx2ex-dag5mb4.msg.corp.akamai.com (172.27.50.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 30 Jul 2026 20:37:13 -0700
Received: from ustx2ex-dag5mb4.msg.corp.akamai.com (172.27.50.221) by
 ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 30 Jul 2026 22:37:13 -0500
Received: from sjc-lp2nq5qm.santaclara.corp.akamai.com (172.27.164.43) by
 ustx2ex-dag5mb4.msg.corp.akamai.com (172.27.50.221) with Microsoft SMTP
 Server id 15.2.2562.43 via Frontend Transport; Thu, 30 Jul 2026 20:37:13
 -0700
Received: by sjc-lp2nq5qm.santaclara.corp.akamai.com (Postfix, from userid 30754)
	id 8AA3AAC0E6D; Thu, 30 Jul 2026 20:37:12 -0700 (PDT)
From: Josh Hunt <johunt@akamai.com>
To: <linux-ext4@vger.kernel.org>
CC: <kknox@akamai.com>, <tytos@mit.edu>
Subject: [PATCH 1/3] resize2fs: out-of-bounds read/write in xattr entry scanning
Date: Thu, 30 Jul 2026 20:36:59 -0700
Message-ID: <20260731033701.2657758-2-johunt@akamai.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260731033701.2657758-1-johunt@akamai.com>
References: <20260731033701.2657758-1-johunt@akamai.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607310020
X-Proofpoint-GUID: TrYvEvwMTXbnb4BBjPdS-jO-4m9IpuLg
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX6nmcVGg8XxO1
 F7GP9F+LhN3JqEk4QZ08bukgHAX4CpTPvv08FK/fRgIOxdvTScZm9Ej9a7LuzrqdhL/l9srVmq+
 CkrbSDjxIoYTyjeD5wVWeER+TjtwhOE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX97QWF/BUYbmg
 UQ2wAgDEsCHIDHlTo2Rk/zBk4ojv+aYXSvF3PBbeVYQxrrVnZmpj59a4FSBAfc7tPEaHV2BUFw8
 pyz+ByNrBErFgNPK9W5UMYLE4iXvV1HUCdfWLXOSmvExQnmK9VNaD/zEJO3eJM5kSVwYQ7n9x9/
 oRtOKkq7TRbOUqcFU/FVgwIwFYAWees65DYkSqj7aFxOK1hBSG6W0w09x3RV+9jyPFD0uElzxRj
 8/qjUe7rpE4JEHsk0kBE+mspK7Y1lFRiFicxu5SnXQ6SyghZCBhcdbgzYBU97wQBRm051piID8B
 SNNoFS79LjqIA8paPsHPRW6R6bcuPBO88g2WVJ+KwBa9jZa6El326RuXixv2oFf4WLuLhUkPzVi
 0mZohyez2Mmwooom/RoAn9whkVcM/ympignMCDOF1hph98LKj3qV/ITOHW6wIP3dTtF2DMDqFzr
 04B1r5PwCUP10Q8f5iw==
X-Proofpoint-ORIG-GUID: TrYvEvwMTXbnb4BBjPdS-jO-4m9IpuLg
X-Authority-Analysis: v=2.4 cv=HdwkiCE8 c=1 sm=1 tr=0 ts=6a6c186b cx=c_pps
 a=BpD+HMUBsFIkYY1OQe22Yw==:117 a=BpD+HMUBsFIkYY1OQe22Yw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=BYUV7c42er6_Rx9bq0XK:22 a=X7Ea-ya5AAAA:8 a=DxAQt8903IEeH4ef7skA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606160001 definitions=main-2607310020

From: Kit Knox <kknox@akamai.com>

The fix_ea_entries() function iterates over extended attribute entries
using the loop condition "while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry))".
This check is insufficient because:

  1. It does not verify the full 16-byte ext2_ext_attr_entry structure fits
     within the buffer before accessing its fields. With fewer than 16 bytes
     remaining, evaluating EXT2_EXT_IS_LAST_ENTRY() reads past the buffer.

  2. A crafted e_name_len value can cause EXT2_EXT_ATTR_NEXT() to advance
     past the buffer boundary, and subsequent iterations read/write beyond
     allocated memory.

  3. When entry->e_value_inum > last_ino, resize2fs writes to entry->e_value_inum,
     potentially corrupting heap memory.

Additionally, fix_ea_ibody_entries() does not validate i_extra_isize before
using it to compute xattr offsets. A malformed inode with an invalid
i_extra_isize value (unaligned or too large) causes out-of-bounds reads
when accessing the ea_magic field.

Signed-off-by: Kit Knox <kknox@akamai.com>
---
 resize/resize2fs.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index c8964af5..dfefca1d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2045,7 +2045,16 @@ static int fix_ea_entries(ext2_extent imap, struct ext2_ext_attr_entry *entry,
 	int modified = 0;
 	ext2_ino_t new_ino;
 
-	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	/*
+	 * Iterate over xattr entries with proper bounds checking.
+	 * We must verify that the entire entry structure fits within
+	 * the buffer before accessing any fields, as a malformed
+	 * e_name_len could cause EXT2_EXT_ATTR_NEXT() to advance
+	 * past the buffer boundary.
+	 */
+	while ((char *)entry + sizeof(struct ext2_ext_attr_entry) <= (char *)end &&
+	       (char *)EXT2_EXT_ATTR_NEXT(entry) <= (char *)end &&
+	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		if (entry->e_value_inum > last_ino) {
 			new_ino = ext2fs_extent_translate(imap,
 							  entry->e_value_inum);
@@ -2063,10 +2072,20 @@ static int fix_ea_ibody_entries(ext2_extent imap,
 {
 	struct ext2_ext_attr_entry *start, *end;
 	__u32 *ea_magic;
+	int max_extra_isize;
 
 	if (inode->i_extra_isize == 0)
 		return 0;
 
+	/*
+	 * Validate i_extra_isize before using it to compute offsets.
+	 * It must be 4-byte aligned and fit within the inode.
+	 */
+	max_extra_isize = inode_size - EXT2_GOOD_OLD_INODE_SIZE;
+	if ((inode->i_extra_isize & 3) ||
+	    inode->i_extra_isize > max_extra_isize)
+		return 0;
+
 	ea_magic = (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
 				inode->i_extra_isize);
 	if (*ea_magic != EXT2_EXT_ATTR_MAGIC)
-- 
2.34.1

