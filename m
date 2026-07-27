Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60FF3F8ECA;
	Mon, 27 Jul 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149754; cv=none; b=qKZQlSqsHU3/zXuzDWdG2uU4mDJRosBdhAaMZsh8hgg5zZl4KdUx36ONl3ILLJ8WQnNeRdK2hkpRfnxIghHYZJGs/Ckn0s6YG45HIBnPwy4JaYZPi1KpBUkmE2/ksqTrzJklxlt+NX27yYSWpzIWYV02LegLcyAbaPTdr9mz1W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149754; c=relaxed/simple;
	bh=2pDe+QANB+cDD7jHTXbr+3bFHUvGO+3IbrTO1Wz+TWM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UxckIRNGM4RoBUBLYvxXUbsWm3ZeEf0bmUBCtdcfPnw29xYe42lwZFCWsTdJkz3wruevrd6pYPQW4unJYW7JgIRiq819OZmE2NYF/RjAr9ibacoO2h6ZSvE6hj/cefHJsXKRniNUGeQSCS/v+570uExoFl402hMG30c4VxebPgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=W2VX5rUO; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="W2VX5rUO"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAOqZl693343;
	Mon, 27 Jul 2026 10:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=oFLlMMeKeWB1cbnADCHZuSZrzMAqB6vtCzg+qN54/FY=; b=
	W2VX5rUOn6WEMOzoJ6xmAvKkn7j0j/bYjJEeW1n+1xrN8m6yjePAXuqIP4I+Ogtm
	HADk5Yks7/+hcHsoOsqor/fuc+SGqANohS5VHIM2ckmQ3u4nmSj+2lN6l5OEfqTz
	E61AMrD+69DS1l58FVGSE4w0mkt8nUXFyfebieEeGWaP3izQz0iHSD+mllh4jzcu
	cZH01rs1AGgkL2tpEZaPpcAoBnmIFnQSfiVMwvLphq8y7zvfY9BAeWbLx+Ef5/lx
	OJ+mZmi2D9swd6wO0RpEo9i9Yf4sqh+Y5dxW2FtotU1/f4QZ1D86ntcWlJr4PhoS
	gKPSVoHZ5G0cIa9esRh8Gw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmjnft3e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 10:54:54 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:54:53 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:51 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 3/9] ext4: use safe convert path for inline data write overflow
Date: Mon, 27 Jul 2026 18:54:35 +0800
Message-ID: <20260727105441.3213095-4-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXwiJWrsM+6KT6
 2+UcuOP9pi7rogxkuuljJLSbz/Krb9WaVFeNrSlqIv9IhLDTw6jOjFwavW2dmzSxMMbm6A1tKay
 FUhSPddx8pHEVrlxeGVzdiSlFqmpo2zTBfA2sZGnHnXR0VQpJWVD
X-Proofpoint-ORIG-GUID: i1PpL4sK2g24ARVjigONH-QGf2T0f29A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX3wwQV/mH/Bb3
 1eji82m8nYEWcRjWluM02BAovDEl0QqEkDZfnqlJZtgFaA9RCLIHDtkvD0ChFh36WFc/Vu8w7Mr
 CQfngx06UY7MGpKrX+EwXGoG0Kyg6AWxjBvWslX9zpel+2qrcGmQmWqPRp+uznu3GsrAUmWxTUH
 LNEC+6FYAf51DyyfgVz0ZoDI25F3uIC74AgnbN3WIc++fQgnoluUAZzTpyQcbkTpLBCdHqCnqH3
 KsjdHXAa3480VBxBmiPoAJuljQiP/Cylx+KouiOzaonb7iH2OPGxtVRHELI1BEv7vCbH2xZ3dwT
 uOFZdixuSzx5UaiDGwdGvrUNjO+GCIgbA1Fhth94DGmz1jQt2y/AyuqfWGM0TGFHCNRjuyB4Suo
 e/Vs9L01SSAH5cIfp45NgFdDrXcT3kDMe6kWwuNiKzjfn01s9fGPLIyvelWO9I9p9wgRhCYr4l+
 MGW6iQHtkmJr7NOPrrA==
X-Authority-Analysis: v=2.4 cv=MuRiLWae c=1 sm=1 tr=0 ts=6a6738fe cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=TxlLYfGgAixtuDYl-YEA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: i1PpL4sK2g24ARVjigONH-QGf2T0f29A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Replace ext4_convert_inline_data_to_extent() with
ext4_convert_inline_data() in the write paths that handle inline data
overflow.

ext4_convert_inline_data_to_extent() destroys inline data before
allocating the target block.  If block allocation fails (e.g. -ENOSPC),
the inline data is already gone and cannot be recovered -- a potential
data loss on crash.

ext4_convert_inline_data() keeps
a copy of the inline data in a buffer and restores it on failure, making
the conversion safe against allocation failures.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..8f1efe4297a0 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -724,7 +724,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 		if (!da) {
 			brelse(iloc.bh);
 			/* Retry inside */
-			return ext4_convert_inline_data_to_extent(mapping, inode);
+			return ext4_convert_inline_data(inode);
 		}
 
 		ret = ext4_da_convert_inline_data_to_extent(mapping, inode);
@@ -785,7 +785,7 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
 				  struct folio **foliop)
 {
 	if (pos + len > ext4_get_max_inline_size(inode))
-		return ext4_convert_inline_data_to_extent(mapping, inode);
+		return ext4_convert_inline_data(inode);
 	return ext4_generic_write_inline_data(mapping, inode, pos, len,
 					      foliop, false);
 }
-- 
2.43.0

