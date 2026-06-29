Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AEB3905FD;
	Mon, 29 Jun 2026 05:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782711202; cv=none; b=u6mcYTR86mHsMOfTBN1WpjgnQZ3lQOFOJDRd/nh2SgaY/6I6vYLtEDjNSxh9NAS8+DRXj8yO7HsGDgt/vql23LdjhrE2nN7h0kNlo10CKpQ68hZNIx3ps2H+G8Pl0jVRoqB/rzaGNGzpxsPRy4iX9MnHOjxd158w3n4cvaD7fKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782711202; c=relaxed/simple;
	bh=9FRiAHDvMqUhv17NiGaEoPzt3cU95Ez604hg2Yk68w0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bxTQD0Wua10yc/toGZdKcPQ8ShIFB44EgMYGqViydxSAD858Un87nR2TuaY6E+fq+idrZ6L6jN1meLroxiQ34k1S0gnOf/IpsHc2jKdsYwsHF0hnd3qbSDXOKC1/Qgj2vYNTISF1aqciHWaYG1sLaHZ3bBN6Op5jwb+M1sxwcPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=o814/PHb; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="o814/PHb"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T4PSYC1865529;
	Sun, 28 Jun 2026 22:27:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=3JoxqRi3k
	wkO9Gnc49FiGuCR6JBZ2i6PKPGI9LQltmA=; b=o814/PHbGu8y8AjRLYNR8egkO
	e+rmNmTQ28zwoml6NO1HTMNPW7MVA7Kf2Cd3wOQB4zm6v5Bwz/+GJSpDebeeZMG+
	86XVESzYWug+mwbJ9PJTEAYNSCXIULuSONWIfflKMuiEBFw3V4QidoidgcNk/QvS
	Fv89NGVFvRk7N/rLGdzMsxaD2TYL8jdgbyhRLQtv+ilOP4BBngy2/o0DV7Vnv5HE
	2Y/9eNt3CLqunHixyOIVt7p2rj1+CGPJKAiZWBGUajUnjWuPgUSeVQ90ujIG2ICK
	EUaZj1uRJn6MRhNvU6s4oFfrBAavtR5oyW7EygyRDXUEdItfgclDo++jLZqyg==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f29syhjmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 28 Jun 2026 22:27:36 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 28 Jun 2026 22:27:35 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 28 Jun 2026 22:27:32 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] ext4: fix deadlock in ext4_evict_ea_inode() vs cache_find()
Date: Mon, 29 Jun 2026 13:27:32 +0800
Message-ID: <20260629052732.1442618-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PS8JltzOh2kFdIqDS3Bp_nQ3HZChpNYR
X-Authority-Analysis: v=2.4 cv=HsJG3UTS c=1 sm=1 tr=0 ts=6a420248 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=Q5H4fTE2DoctMCsY8McA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: PS8JltzOh2kFdIqDS3Bp_nQ3HZChpNYR
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA0NCBTYWx0ZWRfX+70IHXdqOsIC
 Avphhl6m86v9m3Kjc5hhIepz9TOMkK/EifZmhJcqtGiMnCLMCXqGnbyR5SrAryQ80iwH7985F8l
 FYMD0X6qZhewjUUuDDZlaZQwRH1KShMz/1pNPSmBmoqXpQ6MJ5pu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA0NCBTYWx0ZWRfX1aZBCJ+zn7Bv
 d5bue2gsDBdPGmIl5k7F5m5lPcrguu8vYgPBmVCmNwk5mCzmTFplRC85AVX2jPrYxDlD0LRVjhY
 UBB7YHXtJDry3Jm2QVKG1f0uYHH5kCNETkVd0UnEYN302Y4Z7fr/5E/2Rh7qaHWaKOINMAj3jf3
 bW1bLmm99puCOWdroJtUenH9Y3bVN2Pic714E21iBsLRWFzIL4H6zhi0OWZ8kPaXklYIhayRGsw
 RmMxlndUGtrKaAG/In+3nUJBIPMOw38YHFuw3yIk9HO8Qowl4D7NbfSun2bRGM+pOS9VO8QUd+o
 dzQKoKGdhgw5CfkGKOymq8EQsfEoOEMrDMuUyD38qnuZ0c53UcBFY3EClAaHDYnqHZE43mmEOEt
 TfGgcl/qHlJtpydlz+KZRVlOjoxEF9iN1m8rcyhlSJ8vAyfY8zDLZgYovXngTTacMIMWf/gttT4
 q2uTFiJSZVYXr5MegNQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290044

ext4_evict_ea_inode() calls mb_cache_entry_wait_unused() to wait for
the EA inode's mb_cache entry refcount to drop before deleting it.
This can deadlock against ext4_xattr_inode_cache_find() which holds
an mb_cache entry reference while calling ext4_iget():

  Thread A (evicting EA inode X):
    ext4_evict_ea_inode -> mb_cache_entry_wait_unused  [waits for refcnt]

  Thread B (setxattr looking for dedup):
    ext4_xattr_inode_cache_find -> mb_cache_entry_find  [holds refcnt]
      -> ext4_iget(X) -> __wait_on_freeing_inode       [waits on I_FREEING]

Thread A's eviction sets I_FREEING and then waits for the mb_cache
refcount to drop.  Thread B holds that refcount and waits for
I_FREEING to clear -- circular dependency.

Fix by making ext4_evict_ea_inode() non-blocking: try to delete the
entry once, and if it's currently in use, just leave it.  A stale
entry is harmless -- subsequent cache_find() calls will iget the
evicted inode, fail validation or data comparison, and skip it.

Fixes: 458aee4a6e5b ("ext4: remove EA inode entry from mbcache on inode eviction")
Reported-by: syzbot+fd5533bcd0f7343bb8ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd5533bcd0f7343bb8ca
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/xattr.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 85ad2561474b..8ca2c87b1db3 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -471,12 +471,16 @@ void ext4_evict_ea_inode(struct inode *inode)
 
 	if (!EA_INODE_CACHE(inode))
 		return;
-	/* Wait for entry to get unused so that we can remove it */
-	while ((oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
-			ext4_xattr_inode_get_hash(inode), inode->i_ino))) {
-		mb_cache_entry_wait_unused(oe);
+	/*
+	 * Try to delete the cache entry.  If it's currently in use by
+	 * another thread (e.g. ext4_xattr_inode_cache_find), just leave
+	 * it -- the stale entry is harmless.  Waiting here would deadlock
+	 * if the other thread's iget is blocked on this inode's I_FREEING.
+	 */
+	oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
+			ext4_xattr_inode_get_hash(inode), inode->i_ino);
+	if (oe)
 		mb_cache_entry_put(EA_INODE_CACHE(inode), oe);
-	}
 }
 
 static int
-- 
2.43.0

