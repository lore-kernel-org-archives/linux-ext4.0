Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650D0367286;
	Tue,  2 Jun 2026 10:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395282; cv=none; b=Fj/T4qrulzkfLbWIi4MVG5Z2QHiXe35wsFoIFiLitN2okBlOS5ilPSyFJXtNq8OG0Km92morjZgbBDVqgUp7aZbJ/JtbdtF73MjVgf2ZEMjdk+ikq3buR0TKgU8TBdmMRslAlZ2RxtLIDv0KkAWib55/ng+zAFQj0ah4DIjU1gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395282; c=relaxed/simple;
	bh=R+b/lCxqAkpczxbTKOVBkGgONucCv4gdMmGxV19PsgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=om7HxWyRq9gNLLLoziB2dCkxdOKakN+HaLz5UzKY4V53qgyezzu1fZnJ5BtQtbzqXhOWq6vvwupkAQJGflstpmwWpQSZ/elZx1th4L1ViV6ew/97I++I6dYdLDd8QQ3OrG8O0Uhdio03dWDphdUXDKJ6NRBOsntKODtQytvKUhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Mwx2PB00; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Mwx2PB00"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6524eb3h1957774;
	Tue, 2 Jun 2026 10:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ICYgYRz+NR5lp5SigytLsyNfxIbntz7eWdM0PtKV8
	Zw=; b=Mwx2PB00NuAvWLNR+z5E0B7ZTxNvIUo2GBVtTJEFkXKKtJrcYXck/LURs
	XXZhjAaLEg/zCafSLyNc3Y5vg2U1KBdu7lbszW+RoeU+O5ihb5vfeX9ReKaaSx47
	XXzhk3o0zR1o79kVZKcAnfy8JIs8pBL6MXQUHGA5AwsrzBQcuHk4S+YUJjazucrI
	w5fuNnpbbxjKsUsvZfLuMPgW/1/hEcv7E+4VMsLyqOh64531okjensWslKcBXxER
	nNBkY8ONHwM98bNQtEnaoMwfDPU0jqy07EGPpiC3pMZ8YjjRNoPvPS520MoOMVP4
	2HyeabB5De5zIYr8q9BpgS07n/6NQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqm4wa7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 10:14:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 652A96qX023507;
	Tue, 2 Jun 2026 10:14:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egb7k2qam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 10:14:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 652AEZhQ50004448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 10:14:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED2E42005A;
	Tue,  2 Jun 2026 10:14:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A89A2004B;
	Tue,  2 Jun 2026 10:14:33 +0000 (GMT)
Received: from macbookpro.bl1-in.ibm.com (unknown [9.123.4.214])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jun 2026 10:14:33 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH] common/defrag: Skip defrag tests on DAX-enabled filesystems
Date: Tue,  2 Jun 2026 15:44:18 +0530
Message-ID: <20260602101418.55131-1-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: cvDjuCRlxJ_3bth_B4FHflSlKjLrKpvS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA5NiBTYWx0ZWRfXz6M21jrx9kNA
 nAQh/asBcjJ0mmYd9ABx0XiASTuII0neMcQKCJGfH3iOWFjUaWShuSwCgaqHs2NbTGa4Y3WrQ69
 oDxyRLpEeO8vZEVpjnGDhesvyzf24qg6UeCmiTNySawYOfR+QnkgIfQ3s/D+JD5TLi03E00qshm
 HSfCibhqZlfXcC96DZpHbNZSFRh6BlGhCcxR8JRn+y9m4T4BB4uYheao3QSN/cfQxJ2M5dlyANd
 2LSZ31P7vF6FJRWkcimqGWFFNbdIzKUdS/cfDY/mcsmD0dJtnsbiNTGcLKNtK1WeJBrqz9GuOix
 GVmRkMF+3mE70P/iDcBdjYNigPCn+XO9ghvO453XVeWGE3pMCbkkEcoXo/LH9YTstq3TEHmv+RE
 hzYlKCQqZt0pk+Ju4srlXU8dL7ZJliycK8C+3Z0KzeFOB+2NXi8QDArI67O+uvtexRGgn2wgy7T
 EJsvJ6QgQvl1uhaev9w==
X-Proofpoint-ORIG-GUID: pGInta7codqcV-S1eGOsVw-RNNZvsb_g
X-Authority-Analysis: v=2.4 cv=Vf3H+lp9 c=1 sm=1 tr=0 ts=6a1ead10 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=DIPEyOIrT3qq13wk904A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020096

Online defragmentation is not supported on DAX-enabled filesystems
because DAX bypasses the page cache required for defrag operations.

Add check in _require_defrag() to skip tests when DAX is enabled,
avoiding false failures on ext4/301-304, ext4/308 and generic/018.

Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 common/defrag | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/defrag b/common/defrag
index 055d0d0e..28db2f7a 100644
--- a/common/defrag
+++ b/common/defrag
@@ -6,6 +6,10 @@
 
 _require_defrag()
 {
+    # Defragmentation is not supported on DAX-enabled filesystems
+    if echo "$MOUNT_OPTIONS" | grep -qw "dax"; then
+        _notrun "Defragmentation not supported on DAX-enabled filesystem"
+    fi
     case "$FSTYP" in
     xfs)
         # xfs_fsr does preallocates, require "falloc"
-- 
2.45.1

