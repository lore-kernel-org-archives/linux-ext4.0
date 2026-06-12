Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B986478F4A;
	Fri, 12 Jun 2026 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781225654; cv=none; b=JyGekKSn9BWVnJVG7fWRFSQY8o01equ0dATBJue6km/0c31R0Ib+Pcl6L+Kxo6wQhxuXdlUCBzpsYyvTti82FGgRxkBaOMP9WgiuLNIfq+MLnZ4sGPRn0hpdS45K6Wfg986SdlT/5/SXPasfO33UOfedDJwxHzEKkOMYKdf/wDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781225654; c=relaxed/simple;
	bh=KCg/Mvpfo4cExKpU8j5gpb1J1x0u+o8dd0bw6cztfTA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vhq2fHsmpme63LmfoaZYjf4/NzxbQsWXTCDfookd7C7HOshDhftiCiT/Dm2mpALg5iFmwL6mLHcLcb3RdT9Aj3KHkfia7eaU+9kKftUf3idx/gwXNcc4rgQKlVLOb8Tj7/E5vyjnBQfy3tnDJzNUSeOP8mTQH2gygjlakiUmiyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=hZhyhjZD; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="hZhyhjZD"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C00jMQ776687;
	Thu, 11 Jun 2026 17:53:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=PXc+GQH+chfuABpvL0HeQn2+hM7Z2VpwLcNt5gDuV/U=; b=
	hZhyhjZDQE/CXS7DB3iRBqtiwpCxFW4l+MEoeak4MHkTY2tMBX2oAyhHO4B1OdG5
	u6ljbvvDW+ImIibwkWYXGUdfCMCZIQngCk9sCAwvPgTl+nF1Gspz3khNONwvtX2c
	Ib21RZhLAak8FBWRvzYPAAeHyW4QAInwmDzh/DKRtTGFwJmO2z9RppUTh3vwagnM
	VN7SAy3iiqxWWXza+wooEpGjq5saMPwWwg20RMk7s/4W7nGYg4yXlfR+SZGFbKn7
	2+USQjm/NzB4P9RO2+tkA18sqHE6YpkaUfoeN8BQ3PAQ3Q4MCH/Mu1F6bQBQBJn4
	No6JsrfGvQcTuXbBetRhWg==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4eqe7sa4rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 11 Jun 2026 17:53:34 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 11 Jun 2026 17:53:33 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 11 Jun 2026 17:53:31 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Fri, 12 Jun 2026 08:53:30 +0800
Message-ID: <20260612005330.1930804-1-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDAwNSBTYWx0ZWRfXz0UB0XJHcL+7
 AC6XLC75Cu6vmn0gQbpwf9GIZNOnDLvclot01aQ+XEFS1CUuP+qBCIysiybkXLlSpnzo7xX+68/
 wuyGMbf/n4uIJcjFw1NIOGgi7KSJBMIxb8ADOl183FHSPSGSBXrl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDAwNSBTYWx0ZWRfX0zpNjhOY8gLV
 tWE+h9zeNvAMrSxh/6uLtKtTKhreZ7pn3l3+YBdK5FDzbTJ5wT+OOr0cT8JPbeswADDCY2N9EyB
 8LqmypnDXFiy4158FDKeVVYKvhLY6XdwQs6kCQdjqtOMeNVkvjpK3fj0nEZBPog5wKziTA2bz+G
 l80NqKN6PqeLqrfWc6/7WswOBzlF5aqqsL1fai+tr2K3ar0jnWix5pxrUZNsGU5SKbGyvX2L3qJ
 dxQM/nKgcXKPg/TYoiVZz8MKcY9RT0YqElhLPDfHbRIQeeOVuwwhP1QdE6DbzxF9He1ByhNGmk/
 8TATjDZqZuf1/y2Z4SGoOY2YtLqoT3q6HLBoegC4o+C2j3OpYQhz6BkVpju6NUFTkC8XGub9kPo
 YqHGKO3P+IvlObkkYKlqcqUtPSXo5eSBaqfpQ/ZYInufJFs4UtSq8AvUhZPGtFtZooEjhya3/t0
 WCfWy3HoyJPGELZu+AA==
X-Authority-Analysis: v=2.4 cv=XujK/1F9 c=1 sm=1 tr=0 ts=6a2b588e cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=ickhoBDU7WVbfUwPdCIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 16zkRH4fHKtwQs9uU8T-r7rJLz8FgC85
X-Proofpoint-ORIG-GUID: 16zkRH4fHKtwQs9uU8T-r7rJLz8FgC85
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_05,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120005

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

Reported-by: syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=212e8f62790f8e0bc63b
Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
v3: fixes Reported-by tag and Closes tag.

v2: remove redundant null pointer check for iput(tmp_inode).

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

