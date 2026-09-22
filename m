Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC7137C906;
	Tue, 22 Sep 2026 13:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085515; cv=none; b=WugkN1NuqU3sD3fGlKsVHUtw0eANkMjaxTfbXv2Z/dVOI1VTTsSfs2WyG0qZlAlHMkLmzlAA1T+77l4vT8VBoaGIcNF7FIy6ktGCWg27F1+guQerHDsoNi2fdNx967UWcp7WD0FELEfU413rlJlF8guDXTepdI4/i+R8xiGsn3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085515; c=relaxed/simple;
	bh=dYPuXswUPoCHeb16iro5nEvSHWPpNx69QQr+Bwtpe70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MrGlPNdsKZg9Ju9i04fYNA5azi2w2+yGYbl/UWcyh6HQLG8MhxtpsHQtnsjGkGY81+IHFy9kQ3Sixm2HiwX9IjyH/+gYGE1Grkr367lXq/KmhBFM8zOIbD1N/y2alH1An2s0EMA9nU6ta1EmE36wtnVngcFung8d+ZD+Llqgs9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=d+zUK7GU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d+zUK7GU"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBZTt92630850;
	Tue, 22 Sep 2026 13:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vEw8/ye5iA30RNTx4BThB2maglvtHOcIdYMN02uxb
	Lw=; b=d+zUK7GUP62EFyyytXTKomJQzVym7W1lmvspCLbLFWDWTMLn+CgwZZf85
	K7IYlj6m0UYW1/3vn++R5tmmxe4eGfIXYtunHQW17eGT8ESMdRqPaxUEMrf7DJf+
	rf22hrLsDIFzTjfzxQaSNKQruyey7Cw8p1LqjnlPpjPU6VlYThAQDycjLxY2RoG0
	tew7O4WB3QaDP0u6mWnBjci6qONTAorCANgg7idg50Nr6eVQYM+vc3VraAn/SvsS
	O2jTznu1iudAFwagzjg5aZAupICoFa68mxaoRnrV9BtLlug1Qu+8X2UCVuTCpGhr
	8BhdqabMVSI8SR76Lqk6MnD2yvSUw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1p39n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 13:58:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBWURo1521388;
	Tue, 22 Sep 2026 13:58:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gu5bkcmfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 13:58:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68MDwDLP50594266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Sep 2026 13:58:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 622F620043;
	Tue, 22 Sep 2026 13:58:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2E0120040;
	Tue, 22 Sep 2026 13:58:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.139])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Sep 2026 13:58:10 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>, Ye Bin <yebin10@huawei.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ext4: Fix sparse warning in extents kunit test when EXT4_KUNIT_TESTS=m
Date: Tue, 22 Sep 2026 19:28:08 +0530
Message-ID: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: jtEuMfVAzTgpIWRIIEH89mKIpJAIzv33
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6ab28978 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=2-yMNFukYtM-EpJdTCAA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE5NyBTYWx0ZWRfXwi+dWQ7c5/77
 pSdj/1V+uLK63ExcnVrBADJmOfr7df7kni+3sXG1TT+aejndke1ZEpvBwvznTNoIsB9NL6vJzzL
 LckPECowYQq36C6IQ1gW+HL8dwix2wM=
X-Proofpoint-GUID: TnrtW-1NG46oV5SwgOb9lFIOPJJ3Ik3X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE5NyBTYWx0ZWRfXzcby/HPPPAMD
 UtgoOY94o43CpqrTkyGC36Y4e2FZ35BHlqQ2LUNxDyJPhYhNPEZeAgVKGxNoTHziDVfLrMEZk2P
 WAgEabLFsV52HA5mkCEsak+vE94jZkiuP4i98Rg2GXCCAQiwW4IshD91H8cJ5JqFbvcqzIsIn/a
 wtlXMvwAoXkDZ+wEBVb8D+xy+tW9d1aaYiJwrpeDoh5sPr8hxoC8rYsE4RxncJrMysxIuQlKlW9
 2DmTCvKwOm1C8XeaVirollMM/9UxpBAG+9Af2uAhQkSqccdUAsrQp0MdsvmuhA67k05N3cSpp1c
 0KFeQfnIWJ+zSmmraSuOR7m0mylX6u+ZSSSWgE4aenUP9JNevl0fIR9BBSvTq3RJ/EsEVfewIEd
 tOf0RNf8Fo91hMjSOOYHM3FR+6B0O73pJJVXcpYBav5vC45JwybOJ37ZIzXzS4vmizV18yF9CZH
 BwOO4p3lIXQEvkby/3A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220197

When kunit tests are compiled as modules, the extents kunit test emits
a sparse warning:

>> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
   declared. Should it be static?

Fix this by declaring it as static.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/
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

