Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCB3F8EC3;
	Mon, 27 Jul 2026 10:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149761; cv=none; b=A8ZRUtSXK0T462YYh59I+nFK9XhpI8fhskfxgmHN/BH5bcmZddXupBjC8GZp4wcpXU4Xp16DHz1dw7PzAK1T9WfrbMRWXZq8zWRkrs7Z9cZrTydZxEiAe0Ny0hmzihrx/3Q36hRtYo/kNZpbKgR7cOziUcWx5qJBtJy4kqokzxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149761; c=relaxed/simple;
	bh=bNre+75wJXlqyx1yBKj4zGEkn49pW56ZyWrqgfbSM6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzoxp/2MBq0mmEnHXHMz+96p6NA9CZGDHaEuyJyDyMF6gtv+cPsjfBfvXjwIpxcOQZqXsO203Da5Tg4I6sebpbbiApZ5Ur4qSgG5fS+W+XvtkkwXgj2Hxd/eLxrRmaAyVzw4oFljvhq0a31VlPhQ4eaFVXWCBVgWNZwD4FZBrt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=dtm/eM1a; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="dtm/eM1a"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAOA3S512943;
	Mon, 27 Jul 2026 03:55:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=cx56jS2pqd0B5VnWQWN04RZguPtS406wIeekgFQA0s8=; b=
	dtm/eM1aH+AUuoFJ9ilk1I7xI+kNNtEzweLeOgeNt5QTjo9m5cSVduKRb0cbCy6A
	Ee/Q/f3V2CW7eue7/M8bFjB2mtgOjWf/1gL4A/8gLMU4lQS92ct90OVpJWcrnVtc
	jbA7Err5xGaaLjdgGqWCEVg7txS5K8IP30zc3QsA2lLZLzXIC+7Kr7YJOT+LAuoh
	4kOOWQANyzezhP7Q3w5XWz1wnpUgWuLPgbPeW63+1NOsbMTQoTCkZAyIrUsYSbzz
	68QOVIwgUFFy6//jAcjB2gYEa1P1ejzmYvkmHkHAOAmgn1opEBwF1hH8hdkdlubz
	20OvrHzjwNna31cH8TCmuA==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmre01w09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 03:55:07 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:55:07 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:55:05 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 8/9] ext4: document inline_data deprecation
Date: Mon, 27 Jul 2026 18:54:40 +0800
Message-ID: <20260727105441.3213095-9-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: wYJWNsdl6d7Sc0fHBXqL9MaG8Yp2AMAg
X-Authority-Analysis: v=2.4 cv=E6z9Y6dl c=1 sm=1 tr=0 ts=6a67390c cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8 a=mtzuKPBBSH8L-Q0ydUIA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXyeYwmmkmjlaK
 Z+KPkDC48CL+HPCJTgXXjCpsKYZ+XHyoCZ9NQ+PMkeruZ0GXBy83UQ5tvIGVIrx5/ldGUMcLVtr
 Bpi6YSrjC/uzJbq3C7WUsijYF/1d/wn8aAUlEYD5WuFPra9oePID
X-Proofpoint-ORIG-GUID: wYJWNsdl6d7Sc0fHBXqL9MaG8Yp2AMAg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX6qs8UIm9fFPV
 lhHmNGLmrn6kQqurRQJJFfS56WsQp3ks5BXzOAJ0Fplogx1jL7+pfE3P57X2WMQHeJhO68LWlT8
 29+0jDGWG7nj/GMubM8fLyCZjqAORnzNSGwZsNDJ6D3w+pVTdIsA1FgDh8WYImGz0+z+ejpZNAb
 PNgdTL0KY5krCTjkL4H8P6BFJYXpeWKleJMjblslmeDSbTtgyVDQL+YSwbRsbPvOUacXeD7i0L4
 wmQ9jjYI6zZkW4Ng59mXITJFRTCuKVqaDubs2FbtqumlocBQWYCg507DF8zXvaxOnYyQ4Wenxp8
 zrNoGFfyXBuCQ9KDCdDD9ryo0/63o1gt3ZxPeN9IxlZJqaqUnEE1CuSTEauj4xy2VLga9kjgo2z
 /33AHrjQUlQYIJjwKG2FkjiMBOH+KdkO+V2PSLydf8qMWJtYC0worABRGBDxEJ4DbXsH0GRobk0
 8fheGfZpxch/KaGzGkA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Add a deprecation warning to the inline data documentation, informing
users that the feature is deprecated and will be removed in a future
release.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 Documentation/filesystems/ext4/inlinedata.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/filesystems/ext4/inlinedata.rst b/Documentation/filesystems/ext4/inlinedata.rst
index a728af0d2fd0..8dc1b6d75388 100644
--- a/Documentation/filesystems/ext4/inlinedata.rst
+++ b/Documentation/filesystems/ext4/inlinedata.rst
@@ -3,6 +3,14 @@
 Inline Data
 -----------
 
+.. warning::
+
+   The inline data feature is deprecated and will be removed in a future
+   kernel release.  New regular file inodes no longer store data inline,
+   and writes to existing inline data inodes trigger automatic conversion
+   to block-based storage.  Use ``tune2fs -O ^inline_data`` to convert
+   existing filesystems.
+
 The inline data feature was designed to handle the case that a file's
 data is so tiny that it readily fits inside the inode, which
 (theoretically) reduces disk block consumption and reduces seeks. If the
-- 
2.43.0

