Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F65432BF5;
	Thu, 24 Sep 2026 07:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235483; cv=none; b=bKKhBoGDYo98LLtEyABp/c6lSn9fmJmXybrAdNiO5L6pjUdQjEHBlMUxIPM/6pqimGbC8GmQmcmrUzxitQs5GTtj+rWzpDx1XmvE94xY41NkLCNg7MvRMN2yLhxvRIUvU+7YzHifOpSutuycNbgq+sfGcH69RbpSIH5gLA7yNZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235483; c=relaxed/simple;
	bh=/ZfeYM9rlCAGjs0E/H/v2orfGX8bj4r7ku42xBOZ1v0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TGTrOeT+CyKYK6C/wXXmkCOtfxFVgqoYsyWvTq+PhiX/CzqU0r1aXy8lL47BrGSte7ukLSvJHGlaarqha91vlNoSnYm/gJpnjWT6giG3k1Tn1XfA/SE8d15aC/Tb/y1VNP4PFqUvUUC6dOVge5DwXSSt65maAUbv85ZoPgdyDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dfRpytqT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dfRpytqT"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bPUv1341316;
	Thu, 24 Sep 2026 07:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=oo8/b1y96i9oaVku0pMu/BXBr5wBM7O6F3btee25O
	PA=; b=dfRpytqTppIavnYaorOVfJG3rPdx3ex859aFvfv1fTAHLDAWo9BcPU/PN
	cMUwSgyPq1WX6TMCC539e5usYx6AYFb9aytUtufhohmCVMM5rZwSJG4QgRQCXhH6
	bYb9DAF3DUsTMKP4zX1TYQCgq4o+hKKwmAj77+Nr15/Mr5XRdWgjzUC2uQTf0aKU
	vYFev1D613N8Mb1T5vJAGKcQ1hSXv1mnwzW3nm2Ij/b8brL1XPlO5zMhWPoggM/D
	qR+gD0lNk48DwK7GwAyqbokjBleR9YUQn68gcGDN8jK/VPNwkPYyd6PNcHw4hS9X
	mdsoT8hjResDqx94a4ZPw5h4X6kog==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskg2qq1v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 07:37:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5lYlD1554280;
	Thu, 24 Sep 2026 07:37:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb6qmnmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 07:37:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68O7beev33227030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 07:37:40 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2816E20040;
	Thu, 24 Sep 2026 07:37:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE53120043;
	Thu, 24 Sep 2026 07:37:37 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.215])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 24 Sep 2026 07:37:37 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>, Ye Bin <yebin10@huawei.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] ext4: Fix sparse warning in extents kunit test when EXT4_KUNIT_TESTS=m
Date: Thu, 24 Sep 2026 13:09:28 +0530
Message-ID: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: PEb-m-MYySl3ofgLxS4H8YVjIdqKzOzc
X-Authority-Analysis: v=2.4 cv=I43w19gg c=1 sm=1 tr=0 ts=6ab4d347 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=SRrdq9N9AAAA:8
 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8 a=38smpO3dASqMBLBiBfUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX7lD19RbXZedF
 vQDUp0DA5i4WL2B56HuTW/smtQ87AqqPqBWVX7vsAzTN2Wukjtz9qPgPVxYbA1bDqbIy+sE30Cm
 KWE59nL4mjzG0n61sMhbxG5ohI9Dhx082tjyZvJAm9T0BEHtW3Ds/Pi7HhVZCwflVBC3rRbePA5
 a7vG+Dp8ERvt+z65kcG5OFzwcV6T+xs9eMz/LYCVGZjkG/KswH1Kt5fzynK0zVqo5NG+5+wdWdu
 h8WE5m/BWq9+fFcftYv1fH+cRxiTTMZwhZTkuZHE9Ilg1yP20mlvzmNWPALEDPjjZIaJJoPUZPx
 dK8F6icJ8Bp8DyIw7D2f44Nvvi95Kj4UhoLt4cZaq2OSsO42vzfYKK8wawoN2LZGpspAhKbY+Tk
 ypKsXSRTeG8EHlOSrlxCFXHpg2uN6urvLGexP4yzbWRnoa5YFqoaZEo3NOFyKoTUNDaWm+hdEGt
 j5oVknW5VY0vZLaemig==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfXzaZqm4llB0Bv
 vggrH9C1WvHow3GbedKOGf0ppqBQaKlJ6t9qR49qcTgov47jnqNTz5ykGZumxbEaMwMX28QhKA+
 3D/v9y0+7jMf74lp7YA35mwlOYIxtdA=
X-Proofpoint-GUID: ioHza8Y_6a2aaB63nctA0bpatSDI_5u3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

When kunit tests are compiled as modules, the extents kunit test emits
a sparse warning:

>> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
   declared. Should it be static?

Fix this by declaring it as static.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index bd7795a82607..9669b2197fca 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -48,7 +48,7 @@
 #define EXT_DATA_LBLK 10
 #define EXT_DATA_LEN 3
 
-struct kunit_ctx {
+static struct kunit_ctx {
 	/*
 	 * Ext4 inode which has only 1 unwrit extent
 	 */
-- 
2.55.0

