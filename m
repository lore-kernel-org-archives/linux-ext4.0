Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477FB3DA5CB
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 09:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774343613; cv=none; b=U7KsMBpGfx4eAbn6PmhAMW7Kwe3pwDMbbDq+rrFRFzuwvj+Ta4SwlxhXsc1Xn8f9AaX1wrdlQIJx3wdVlzzXyy3VVyZUNY09zeobQG9P5e8AaIBj8FZm9XNh6aJ0RkE+/oZtkNjk8WsjZBehubih5nop53jZJTbam834uWvS/TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774343613; c=relaxed/simple;
	bh=wI/hihErKn7cdDHBSOkTioHxMT/dpcSO/DMb3V++bZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rdwLj4n7IbyfslYBvVsVCT+ccq88HypUNW5aW/z6kJkXdaAUbdvmzMv0qIUiggOwBye9B/rX3UPeWSb/eLee2Z1svo84rFHO8XW8wu8KY7PvMo7br0cquiy5JxuUdNDYCHMkbjP/oBcZZPDI5hEKcijXWNcTJqHLNtKYvTxmhrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b133f7f2276111f1a21c59e7364eecb8-20260324
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_GENE_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:5b9bfe7d-aee5-42e1-b81f-5411ff8e3a89,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:5b9bfe7d-aee5-42e1-b81f-5411ff8e3a89,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:b7d7cb0a6cd3c7057a77abd950a7500e,BulkI
	D:2603241713175H0GUI0Q,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|898
	,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b133f7f2276111f1a21c59e7364eecb8-20260324
X-User: jinzhiguang@kylinos.cn
Received: from jinzig [(171.8.192.234)] by mailgw.kylinos.cn
	(envelope-from <jinzhiguang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 893019214; Tue, 24 Mar 2026 17:13:16 +0800
From: jinzhiguang <jinzhiguang@kylinos.cn>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	jinzhiguang <jinzhiguang@kylinos.cn>
Subject: [PATCH] doc: correct date in release notes
Date: Tue, 24 Mar 2026 17:12:59 +0800
Message-ID: <20260324091259.1167-1-jinzhiguang@kylinos.cn>
X-Mailer: git-send-email 2.53.0.windows.2
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct the date in the RelNotes/v1.47.4.txt from 2025 to 2026.

Signed-off-by: jinzhiguang <jinzhiguang@kylinos.cn>
---
 doc/RelNotes/v1.47.4.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/RelNotes/v1.47.4.txt b/doc/RelNotes/v1.47.4.txt
index 6e7e1c4c..6c78a2b2 100644
--- a/doc/RelNotes/v1.47.4.txt
+++ b/doc/RelNotes/v1.47.4.txt
@@ -1,4 +1,4 @@
-E2fsprogs 1.47.4 (March 6, 2025)
+E2fsprogs 1.47.4 (March 6, 2026)
 ================================
 
 Updates/Fixes since v1.47.3:
-- 
2.53.0.windows.2

