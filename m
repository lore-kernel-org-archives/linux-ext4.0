Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51AF34B1AD;
	Mon, 27 Jul 2026 10:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149747; cv=none; b=fbU9SPf+Vl0Pkezyt3d94inZnrG0GFHp5BB1K8hM3EuQ+u5Jy5KNqqnZsuIgDMhdUlsxmCrM/wgDUZS4aHE36mfuGCsyRSWd6G7PMEYD+LAkrnvR+4dcEqudSRcd0Hvo+8QIUES7t2OMY2CIVvQ9JdckeyTD9ST7rWj9w/brNB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149747; c=relaxed/simple;
	bh=l4tlWegdlkJYkz4H9pjC7oaVVOl7VxDFnljXDxYYUp8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VMWExwKjWuNrIhuYUa2Nn9DOu1TKHz2+UGEQTHv2HN4hy0NwyccvQ1NIo+IqLdQoPKEGAgFdZE8bvDUg0SlVujZXlxGwFSmkhiqWqV3TDd66PUTZx2Uc2oRG45XjlrMzrNWtWm9BHJmS93CWnWtfVIzMX++PlBg8f1YB8HHgm40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mHDWKUrC; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mHDWKUrC"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAO9pD512940;
	Mon, 27 Jul 2026 03:54:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=czv7SMJEr
	FqxALRREYPeuToCGH0GPLVsTkPslw31x8w=; b=mHDWKUrCxOd5LBucOFZ395gb3
	Zxf9TYexvzCnlSWXs1/jQv8oF2DJBAgSQug2MQTvy3ICWzfGPdZl8pFmbNwlEkUX
	9SDqTyKKC+1Zj3qr7I1JWMCVNm7KIv3Byzc5J74UY5RTNlzX+G8mi/ZFEe07Aa6W
	0Q0uEeUW0OWU/gqXoKzxq3Rd/4Jfnm5nIXnakHc+R3zDCoZlz5D+P0THazfIPvgw
	Yhtr7L2TrX/M9WajwMm6vkLhB41BmHEhLgCsYLLwR7eHXQszud6/6/ZLtiFeWGo0
	aUlppjA63T58HG5NH/3Eg6UH+BwYw9sW1HtohNlvcU5LdOt1sD5YirbDiwkBQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmre01vyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 03:54:45 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:54:45 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:42 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 0/9] ext4: phase out inline data write paths for regular files
Date: Mon, 27 Jul 2026 18:54:32 +0800
Message-ID: <20260727105441.3213095-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _z0Rr-zFNyc1_UfWkIxDQfksEN42u9r1
X-Authority-Analysis: v=2.4 cv=E6z9Y6dl c=1 sm=1 tr=0 ts=6a6738f5 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=sOrpzHietMZ_bCKKR54A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXwrGfioqVCwtZ
 dELX9JmYV0+xmjyQIGiAC5zERHe9DwYt9bvXf/AIBMpzOtLMOJNUrEgJ2mok/sJ4tjdE7Wa4E+1
 JIXJ+ZOE2tivJvc7vl0d0V/eiU9tvtHXv++vAZ26+67H+NazukB2
X-Proofpoint-ORIG-GUID: _z0Rr-zFNyc1_UfWkIxDQfksEN42u9r1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXyHPoR9VtwxA1
 7t96Pt0cPjUmeC1lb+tzJ0SNE/6DtQzSvnbnDXj2CMLm3d+xn/2CCP3dpo3F0IIFRVEGTzt7yBM
 iZpq5e6eek7u0Xnx2n6SUAPoYD/sbYQpy23dpXY/iZZdV4Mcur+HiYDzukUy48YitgVbsZigAWj
 bboAqExqlk1GlSrxlFFTbNj/0RDkLGB8zDAflPquXCe1iAhKFmAonStjfTHVwIbj8tNllRTS27J
 UVq8yQ+GFArb+63gQcrUJopxWYECjA/qY2OwYbA+Ft2fRhjOfmEbABWriGqHm57VExTjEqBUDhe
 4EFSqRqHr6FYPcDjjTV0YFzr40lDA6WKmH5IPFT6phHe+RkjONTSZgNdJwh1P13YwF0c6UvE4j+
 SrQN6DZPLLx4/421RbJrdOxpoO9B1WGP1bQ+ZikmEvuiibZJrkgY1wSKF31Yu+iIYLOM30OlXAk
 j4Ho9BOInDHaA5eBrMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

This series phases out the inline data write paths for regular files
while preserving directory inline data support.

Motivation
==========

The inline_data feature has been a persistent source of bugs in
ext4 over the past three years:

- 15 kernel bug fixes since mid-2023, including fixes for BUG_ON,
  use-after-free, out-of-bounds reads, race conditions, and data
  corruption
- 4 e2fsprogs bug fixes in the same period
- 6-8 syzbot reports currently open or continuously reproducing,
  including "kernel BUG in ext4_write_inline_data" reported 5 times
- 8+ CVEs: CVE-2023-52786, CVE-2024-42304, CVE-2025-38222,
  CVE-2025-38701, CVE-2025-40167, CVE-2025-68264, CVE-2026-31451,
  CVE-2026-31452

The root cause is architectural: inline data requires special handling
in write_begin/write_end, writepages, page_mkwrite, truncate, and
directory operations, with complex locking interactions between
xattr_sem, i_rwsem, i_data_sem, and page locks.

The benefit is minimal: inline data saves at most one 4K block per
small file.  In practice, very few regular files are small enough to
benefit from inline storage -- mostly only small directories gain from
it.  Major distributions do not enable inline_data by default in
mkfs.ext4.

Approach
========

Rather than removing inline data entirely (which would break existing
filesystems), this series takes a phased approach:

1. Emit a mount-time deprecation warning
2. Stop creating inline data for new regular files (directories retain
   inline capability as they benefit with minimal complexity)
3-5. Remove inline write paths and dead code for regular files
     (DA convert path addressed separately in patch 7)
6-7. Rework the conversion path to be atomic (no restore needed) and
   fix the syzbot-reported BUG_ON race
8. Update documentation
9. Close a pre-existing theoretical i_data_sem race window

After this series, existing inline data files are transparently
converted to block format on first write or mmap.  Reads continue to
work normally.  No data loss, no user-visible behavior change beyond
the conversion.

Testing
=======

- Full ext4 build passes with zero warnings
- xfstests smoketest (ext4/4k): 7 tests passed
- xfstests smoketest (ext4/inline, -O inline_data): 7 tests passed
  (fsstress + dm-error with inline_data enabled filesystem)

Future work (separate series, after community consensus):
- e2fsprogs: deprecate mkfs.ext4 -O inline_data (warn or refuse)
- e2fsprogs: add offline conversion in e2fsck/tune2fs to convert all
  inline data inodes to block format and clear the feature flag

Yun Zhou (9):
  ext4: add deprecation warning for inline_data feature
  ext4: stop creating inline data for new regular files
  ext4: use safe convert path for inline data write overflow
  ext4: remove inline data write paths for regular files
  ext4: remove dead inline data write code
  ext4: allocate block before destroying inline data in conversion
  ext4: remove DA convert path for regular file inline data
  ext4: document inline_data deprecation
  ext4: populate extent entry atomically during inline data destroy

 Documentation/filesystems/ext4/inlinedata.rst |   8 +
 fs/ext4/ext4.h                                |   7 -
 fs/ext4/ialloc.c                              |   4 +-
 fs/ext4/inline.c                              | 518 ++----------------
 fs/ext4/inode.c                               |  25 +-
 fs/ext4/super.c                               |   6 +
 6 files changed, 70 insertions(+), 498 deletions(-)

-- 
2.43.0

