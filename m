Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C707C3630BA;
	Mon, 29 Jun 2026 11:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731371; cv=none; b=fiKlH2xrv5iY1/FxH7InlndsWGV7nBO34SBfvuRVPHk+v4nzmZa9fRQ0E3VEwgDvAZquIFr62qxiVozl4SdINPMxSns7biTyFmFZNHcAG3kkQX8ycnr4ymS9YNU99nN6dvoqDAjwR3iSmJRwXixhywCsX/891XE+JLiXfnF9Jo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731371; c=relaxed/simple;
	bh=E1+cyasqIhhhG0DKrgWZkqcZ7B+JOTZvMtUvDwGO0No=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFIyoYrdjaZqit/ZG0LLEkDvo+ul1e3FGgidiocjsFYKJ9jVkraI78oUzhWho/IMkR32ywP0f/omh5UzViD7gqGUxGPeKxWP3aPI2XNCfZzAE0UBAbb+inb68YyKDUOh7I553LYP/fexRfQ0xivjVhD2NS0+zjy+V/DiCcMP93Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Xd+4IlhQ; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Xd+4IlhQ"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TAX45Z2537199;
	Mon, 29 Jun 2026 11:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=PjJJ7+EoFDEmzMlTRk6lk/rg2SZ7toJHLRnfW5/beUA=; b=
	Xd+4IlhQTkzvM24v8IUxOr7v9r59Z9x2eINhPksfKxHNRfAAujeBU81o7w8lHTAr
	9wvWSxWh1Gew2lDGbNBbNcD2RA/qJoDwxYVMiw9LgurJGMfNU1tu5fXOlX0R3E0l
	z96swWIRA1fdJypLV/ngMctUxTYO/yL+z5Pt7Gm0pUEOaj86PYizohvH1Rm0wKXc
	flQObWfazfdNelWHdjqXbkCTevX1BgSMJUk6FsVqsFW8vb+0rBFOqMnOpFHCjiPA
	lOoUTD/RSskMQYIIOSXwz3/o7Wt+EVpEIar/IBkg2FBjVjXmbt5qJVjnIKQLQDKp
	BG2EVSSh8U5XYkkGBmzyYg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0a3ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 29 Jun 2026 11:08:57 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 29 Jun 2026 04:08:55 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 29 Jun 2026 04:08:52 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>,
        <xiaowu.417@qq.com>
Subject: [PATCH v11 1/5] fs: add iput_if_not_last() helper
Date: Mon, 29 Jun 2026 19:08:44 +0800
Message-ID: <20260629110848.3085662-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629110848.3085662-1-yun.zhou@windriver.com>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a425249 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=vCr0if_IiwaKUNF-nsEA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: g0pvSEvyCOu28NxYAkAt9SDnq2URYCPc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfX6wWGi2vzvuSZ
 tDLQWEp35y/d2wzE9wVEt6R2xRoWOe8rn2M+bGv+jyHHoYvtVcKeUjOXhYTUDpqA7/33eUMVC7j
 MJcOOaL8aggcFixn4oE6Pv6eWOmDdRmOnwEFU5jnps/zvmGlII8JW4OlJ42Vfrj8rjGMD7lknfY
 QuILu9p3H2X63MNRsz6zs2ZdOVI6nuz+I5vSig3IesmQp0c8hF82Y2RQoQvZAoDxJM0wqAq0ok+
 QoiXIkhwtXqaZTJjTUpYpuGE0XnTQMNvWzUoczZcbjs+P9MaeXHE6PaM5gVhcEG6kiaOBdsN+sN
 UIWrsu2fXVGIz6D0k3DQ+Z53qQWhjdGOuvs635OxkTh5O3LwOc1KV89/6GjTHbynR74Q0khhEEO
 B1OoCpTOWG72qLXgLnDPhfkKvi290stwnAFc5vTr8bq6vT6/+A/NXpGX1zx4y8kn+K+xAGr9SGT
 X32XrCvd8El2E3KxwqQ==
X-Proofpoint-GUID: g0pvSEvyCOu28NxYAkAt9SDnq2URYCPc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfX/Z/wn5tDIneY
 xVT3lwPSTFe5nsrAm4v/LaLh7zuBBdTedYNrY5wDDZJEi2NmIsmzQiFPJFpdU7X33XVJt5VCsbI
 DlvN2/r4qHtlLfnXAqqxvM4Pfrmr5wG5jzqGMKIT7b+OAFSOhh1p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290090

Add a helper that drops an inode reference only if the caller does not
hold the last one.  Returns true if the reference was dropped, false
otherwise.

This is useful for filesystems that need to release inode references
in contexts where triggering final iput (and thus eviction) would be
unsafe due to lock ordering constraints.  The caller can check the
return value and defer the final iput to a safe context.

Unlike iput_not_last() which BUG_ON's if called with the last ref,
this variant is designed to be called speculatively.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..04f0de78fa7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2413,6 +2413,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
+
+/**
+ * iput_if_not_last - drop an inode reference only if it is not the last one
+ * @inode: inode to put
+ *
+ * Returns true if the reference was dropped, false if this was the last
+ * reference and the caller must arrange for final iput() in a safe context.
+ */
+static inline bool __must_check iput_if_not_last(struct inode *inode)
+{
+	return atomic_add_unless(&inode->i_count, -1, 1);
+}
+
 int inode_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
 int generic_update_time(struct inode *inode, enum fs_update_time type,
-- 
2.43.0

