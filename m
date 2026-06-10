Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51212E2DFB;
	Wed, 10 Jun 2026 10:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781087751; cv=none; b=U3JX9XbGtV+5BW3WvUVrvfe7r9EI0+o2779kWq761RmjdGXULngcVWsfBXDoiU2mifXe8uJn2HBlxEjDDWlX2uco9pk2ZMBd0K5h1tjyYfCcvxIPyM+OEnuH+Ru1KXAo+hrCYsVsZeTA//VtAQrqonfx1Dt9DAfGG4vfwUYnl7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781087751; c=relaxed/simple;
	bh=A9KPQvgoPsTdnU3vXVRkmWLqOZsWGzcDwiB2Y00a5/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aaka48Dp6TTA/xR7hdij3QTd0Mgbyqf7CrohQEpoOd+eVBltoearqRSfTPTuMGxtYASH9meo6yQNCPamgOaHmJs7mIFLKl61KIlb2MTlHY04vbCIkSELlfhWx3E/X6DTfSTzH+ScSHl4s52brT/3mD1PdNZjw6h0YAxr20AzUBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=HZA1OlJt; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HZA1OlJt"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A7oBrD562876;
	Wed, 10 Jun 2026 10:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=RgExjr6gNtWlp3Hrq7FRewG1atIvfnU55Cq3syEbAVw=; b=
	HZA1OlJtdk3jxgHBlywzVMbcKVMQ0SvXo6nX34zYUzRv7OBVywepSlposh/tXMU7
	7fmW4b1FOKLVE89vxlAodOOtaw3iWknYqah5e9qDCsruJcRsHluEi5BhZYomWOrw
	akjfsA0oqQ+sOYrq4Rnvjv9P84+5+yyKS4kLPUwFb8HCEkRIdODB7BJnB6cFvfBF
	mx1ZIxxffjFVA9PnNVYuT5O1QMQye0vAnOAZHRDjZHjOkGprhKf7nec6PKGHEjhg
	2IzSjeTUfrKUSjWIrcs8J+b8HVHVNBCcuVyG0V1wpySp727jqPcq2N+g8BuD3IR/
	BLaJg+uNtedlsbuJGIy43Q==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4epwkq8gaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 Jun 2026 10:30:20 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Wed, 10 Jun 2026 03:30:18 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Wed, 10 Jun 2026 03:30:16 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Wed, 10 Jun 2026 18:30:15 +0800
Message-ID: <20260610103015.494413-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260609084007.3432061-1-yun.zhou@windriver.com>
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDEwMCBTYWx0ZWRfX5RaPxaHWVmhv
 doKb06sGx3jpWWFV6vfVIc42+D5JOHlonArMP7WFJO9QxrTje5K1dm9mq+DZ8e5fEmXJqdsVIBY
 BLhev5WKfewVO6sKsFqL/5uB+t9AH5jfOv0WdoH5fygfXfYTqNnM+YsEYr2JyKvS2AVJIyVRgDE
 Gzi3K5Ar0/IcSpDPeUfzwKBkaJ9J/A6Qy/yHjXvRpfir+aUy/WRifHWYS/Vqltl61hAppoPsC6+
 Jd3P1nYJEiLAsnlJFMX3gixy1i4a3nsFQ8r6/4QpLtMCvXtWryggvyxheiT80nnpEw5VaWWCp1H
 jhhTyiYPHBDvvxjndKm0ZV30jxdDd2zOq5no1NnVRdIbSlzxPl3TtS9aKdhagIP6cq+KzLMrgxE
 cXDKEfd9LEi1+XQon3FMsB4hvpp5GUyVUn80J++ahqOQbye2jWT/7kU9pcAvMVAvbLeHRGnKFqy
 EDB1vzT/PIv/KAH+e+A==
X-Proofpoint-ORIG-GUID: 4pCKeUf7njgfk-4duWJH30M2dNEGfRvz
X-Authority-Analysis: v=2.4 cv=eOAjSnp1 c=1 sm=1 tr=0 ts=6a293cbc cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=ickhoBDU7WVbfUwPdCIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 4pCKeUf7njgfk-4duWJH30M2dNEGfRvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100100

Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
circular lock dependency between s_writepages_rwsem and sb_internal
(freeze protection).

The deadlock scenario:

  CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
  ----                           ----
  ext4_ext_migrate()
    ext4_writepages_down_write()
      s_writepages_rwsem (write)
                                 ext4_evict_inode()
                                   sb_start_intwrite()   [sb_internal]
                                   ...
                                     ext4_writepages()
                                       s_writepages_rwsem (read) [BLOCKED]
    iput(tmp_inode)
      ext4_evict_inode()
        sb_start_intwrite()         [BLOCKED]

The tmp_inode is a temporary inode with nlink=0 created solely for
building the extent tree.  Its eviction does not require
s_writepages_rwsem protection, so deferring iput() until after
releasing the rwsem is safe.

Reported-by: syzbot+f0b58a1f5075a90dd9a5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f0b58a1f5075a90dd9a5
Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
v2: remove redundant null pointer check for iput(tmp_inode)

 fs/ext4/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 477d43d7e294..5d60ef10fe11 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -464,6 +464,7 @@ int ext4_ext_migrate(struct inode *inode)
 	if (IS_ERR(tmp_inode)) {
 		retval = PTR_ERR(tmp_inode);
 		ext4_journal_stop(handle);
+		tmp_inode = NULL;
 		goto out_unlock;
 	}
 	/*
@@ -591,9 +592,9 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_journal_stop(handle);
 out_tmp_inode:
 	unlock_new_inode(tmp_inode);
-	iput(tmp_inode);
 out_unlock:
 	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
+	iput(tmp_inode);
 	return retval;
 }
 
-- 
2.43.0

