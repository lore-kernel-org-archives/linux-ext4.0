Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307043E4A8;
	Tue, 16 Jun 2026 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623003; cv=none; b=S6qacWl4dObfrP2kSgsJTQL9xtuLlMkSWgZhKlGl+Izh8ha6J/z+5RzgeDxZtjf9aDEC8b8tSR8wXeimngYytLtdy0xAL3hWXBh0ZBYwsVBRZ9CizCFi1JRtCxQnbhIphRzlPa+iET2GCzyyOectBLjRDOmF9Z6cZquKztnjvzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623003; c=relaxed/simple;
	bh=AKMR4rcfe5W+vsdCyv/FCXMxh4cXFwG714RlYILxbG0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TzNZF/4Giyb9HZpfzE2LSuRdahxT4k6wmbhd11kWMNXltZ5Bz0hJ1f86hfyrb6FQXOiL7oWhGqF/JIOJ13GrC/ASLnUoYQGNTOXIfvXh6gJkT5yVKrvSQrucToWXomznOFDRvJbExbqq6AxJeptR7jauZbYZA1hXpXX7Cp/pcVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=e7zCsu7Z; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="e7zCsu7Z"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GDtDiT3878547;
	Tue, 16 Jun 2026 08:16:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=ZX7oLgncPvrLpvWL5YbPKw7bCkgCXFYfcZzlsqCRpbA=; b=
	e7zCsu7ZTeU8vWcC0iPGxdSN7BVGXb6TyNbTHU61FSAXuG/b8w8l9A98IRc2uoBt
	S6wX93O6lWy7nk1rcJF/NIaLJqECpwoxPmH40+O1gRTGXJaVJnIPEjjjkRz0FsPh
	A/lv4HtuN84tHM7CrpvIDc00xwHFOAtjzBi8ncP9FAJiANNKYE9tPMb2QhJhEgpM
	UolEp8CrlHhmrIuKQR1eRFEC5IqHpIUcrZM8VxA5vKSrAkH3ZWS7Qsc7uQTHbi2w
	N0Efn1/vAPzfXQf7knGbj44rvrZQF92unKzczQRYMF0DWO4BuoGU91fiIc4ZvTLI
	KD+iriuYFHQTQSi4NRlV3w==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es6qdvfq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 16 Jun 2026 08:16:06 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 16 Jun 2026 08:16:06 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 16 Jun 2026 08:16:03 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v7 2/4] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Tue, 16 Jun 2026 23:15:56 +0800
Message-ID: <20260616151558.1728881-3-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616151558.1728881-1-yun.zhou@windriver.com>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DLq/JSNb c=1 sm=1 tr=0 ts=6a3168b6 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=5t83pWKoPL1BlknkHKcA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: KqsZgd3MvY3ck9rmgK0JP-jwceaRs--c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX4X5fOt4/Ptg1
 pjRJGVfXJKWKhxFM4R91i33GLsYCFf9U2qvCG8n1U42HCv7SOUZ/BGfRKLEkR7+tX4Qm7T3CvCL
 RjgLK3RXUcwYHs1d3bUDavWHgFRKlRn/OQbw0AswvqkWO9EB3skXT9i7J608uYlRifRSem+hrQU
 UmOLhZGn9NWGAnVtRShdCrpax/2i09XCje9iotFC+Kabir7HG0PQHHU7ZvXVkuscbRUR1B6Er30
 iiKbmnXNEVr3VWaxDtOOBY4UWRVDKW2oNuDiI366WveNUzn5H2JwvHNOpFib8WpivbcM7elXNSS
 QH2Cm/YIG2DLBVb+qgouHEz8DRcu358yDimSxKUb3t9VuKPItvimSX16qLABd8b9J3pby//lPyH
 vJJOHpI1n3C1gkiqaXIZH2yIzqTBPnuRBoMXVqsIUGtzRH/hNXrIipSuhBuSJb+ed52st39LTWr
 FkNHx3YaYTjZOuIwoDg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX6qPy2j4cB74h
 j1XZLQ7HMHG4H40YYzMuyxW6vgwcQ2A2Rdw8j98Lvv6Uv+kNJ8cUf80OaZyuSHIoTXLx4byzbuK
 uO6Mtc47mchZH9oTasElRyrr+uMTOFGyVzRkVMcK4NJ/n6CbTiBP
X-Proofpoint-ORIG-GUID: KqsZgd3MvY3ck9rmgK0JP-jwceaRs--c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160156

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 09dcfb6bf48c..1de0aaa28e63 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -264,6 +264,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.43.0

