Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E852D3769EF;
	Mon, 29 Jun 2026 11:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731375; cv=none; b=UlO9UddGHRcFl3gVkUM0yB3HXckDLiA2mXpgBJdvgtV9LTlq7MP7gSA8B8N0m21/PIyGxObMxy2ZGD5b1p211HIGbvyx4qBvM9k7cpqTzuNhsL3aJqqSq4oqT+6+IFDtClUlFcXHevwHjfP7p+2+8MysFbcPGX6jPtEFw3SxdjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731375; c=relaxed/simple;
	bh=LS+/2clPOxVT7z1IhcOKyn7keiKylbrqbInEiU/EyPg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=faC78lwha4rLqbAtQoeKxIA+TV1KedLte+9K08YewqnJg8UgFvWavN1O5WnkeLyTFjnX3Qzc1hcBMyhplVxl/Zjt5vdPJvwJ+nuADUfZLR1gXFZ8vUQREnRvSpTsa4dD9yeu3xZHVInhwHECXuWe4mPNzmD2Po0gxq6C+GY3BH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=eVrjsunD; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="eVrjsunD"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TB0dbj2584848;
	Mon, 29 Jun 2026 11:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=cYAm/oBStJ16pt+fuhP7SCGixpp5p5A3mG0bSJDNz8I=; b=
	eVrjsunD1dAXhXs97+NMhay7Oaa9C0ZrrjXOUUtudBfW8IhX4YeZiYA4Wq6KCB4A
	jJSevDR42r402RHtB476jXG0U4eK3BBoW0p9VJDj9W6ae9x3RL8GXXn928gNrctd
	wCOZRC34MePSgg9fL/aJVyfAmp+yUz6lB1kPz9GMnvdKritp4KOP+PdP7bOMbfC7
	HuKP5trIV8zVbtauctnjSiyXKRmpYvlCC3VaBpj7ZRJT5d9X82O0R2r+gTfQBBZp
	gIikeC2SjIgTlwbIo64/9z2Qvp9tPflVRcmzBU7NMtZWw65PF9SNfE2B+Ax9y0wB
	gFKiznM84JX3+Q12lcUTUQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0a3um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 29 Jun 2026 11:09:11 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 29 Jun 2026 04:09:10 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 29 Jun 2026 04:09:07 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>,
        <xiaowu.417@qq.com>
Subject: [PATCH v11 5/5] ext4: prevent deadlock from duplicate EA inode references on corrupted fs
Date: Mon, 29 Jun 2026 19:08:48 +0800
Message-ID: <20260629110848.3085662-6-yun.zhou@windriver.com>
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
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a425257 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=dZbOZ2KzAAAA:8
 a=z0aaWccmHJNCRRfF0b8A:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: xo3pFelMdCD3YaLfA20xoSQ_P3KSp4vl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfX8iLMZYRtN+3e
 QCaSADGr5nsiowoAGMKf4vgAKdsMRGalFO9WAMcJs2wj/xWiukBQ5Zb8EcHNCRi+FFxJBPZT8+n
 3b9HRmdefkeG9gvV1SZ4qg2TGfxVbdocWAAWdKIyWpgYLmaJDvcYTkXAVQat8LSUp45tBDAiNx3
 sDwq424fNxEAWMJS00akI6wf3XdBx/B3jwd47pgcZYSrHQw8TeE8nzCjwxIJO/f4uFXi3pwJjqK
 z2s1yYHnHuIoilGSc4OFduWXpkduNgq6JndFXWh702zFXG34xuPzToFa+b6j1WnBNiCPPOkTHtr
 4TAGNuPiEOtk6i1upwS4tW18mYi+lgu2OwZmTh1C96kTpybB2tmaI31NIQlCcGtwZbedKDsOZhi
 /KUa6CJ1Dn42a37CEtykinezq82fgeuMMTTt70/FnZiDgGkVWKBg/HIxmWVx8tsDhYIY2armnEh
 mD4C/z9DlbMa3o22axA==
X-Proofpoint-GUID: xo3pFelMdCD3YaLfA20xoSQ_P3KSp4vl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfX5afn+ec8u316
 JxyatEni5fG0XgGX+lZmDOj+Arf1CfRE4i+EGjTXYZBnIG9Gif/CWt1cVg/FADwDGET1DowLPAu
 i7uz4VB0PZoSQKuwpyEuxmi/I/VSQNGAV6kD9bv0/L4POEd66Sm7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290090

On a corrupted filesystem, multiple xattr entries within the same block
or ibody may reference the same EA inode.  When
ext4_xattr_inode_dec_ref_all() processes such entries, it decrements the
EA inode's refcount to zero (clearing nlink) and releases it via
ext4_put_ea_inode().  If the deferred iput worker begins evicting this
inode before the loop encounters the duplicate entry, the second iget()
blocks on I_FREEING while the worker's eviction path waits for the
caller's jbd2 transaction to commit -- ABBA deadlock.

Fix by keeping a small on-stack array of EA inode numbers whose nlink
has dropped to zero within each dec_ref_all() invocation.  Duplicate
entries referencing such inodes are skipped before iget, eliminating the
deadlock window entirely.  The array starts at 32 entries (more than
sufficient for any valid xattr block) and grows dynamically with
GFP_NOFS | __GFP_NOFAIL for the pathological case.

For legitimate EA inode dedup (same ino appearing multiple times with
ref_count > 1), dec_ref only clears nlink when ref_count reaches zero,
so such entries are not added to the skip array and are still properly
decremented on subsequent encounters.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Tested-by: Xiao Wu <xiaowu.417@qq.com>
---
 fs/ext4/xattr.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 01b9aff0cd25..85ad2561474b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1152,6 +1152,25 @@ static int ext4_xattr_restart_fn(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
+/* Track an EA inode number in the dedup array, expanding if needed. */
+static void ea_ino_array_add(unsigned int **ea_inos, unsigned int *nr,
+			     unsigned int *size, unsigned int *inline_arr,
+			     unsigned int ino)
+{
+	if (*nr == *size) {
+		unsigned int new_size = *size * 2;
+		unsigned int *p;
+
+		p = kmalloc_array(new_size, sizeof(*p), GFP_NOFS | __GFP_NOFAIL);
+		memcpy(p, *ea_inos, *nr * sizeof(*p));
+		if (*ea_inos != inline_arr)
+			kfree(*ea_inos);
+		*ea_inos = p;
+		*size = new_size;
+	}
+	(*ea_inos)[(*nr)++] = ino;
+}
+
 static void
 ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			     struct buffer_head *bh,
@@ -1166,6 +1185,10 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 	int err;
 	int credits;
 	void *end;
+	unsigned int ea_inos_inline[32];
+	unsigned int *ea_inos = ea_inos_inline;
+	unsigned int nr_ea_inos = 0;
+	unsigned int ea_inos_size = ARRAY_SIZE(ea_inos_inline);
 
 	if (block_csum)
 		end = (void *)bh->b_data + bh->b_size;
@@ -1183,9 +1206,24 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 
 	for (entry = first; (void *)entry < end && !IS_LAST_ENTRY(entry);
 	     entry = EXT4_XATTR_NEXT(entry)) {
+		unsigned int i;
+
 		if (!entry->e_value_inum)
 			continue;
 		ea_ino = le32_to_cpu(entry->e_value_inum);
+
+		/*
+		 * Skip EA inodes we already processed.  On a corrupted fs,
+		 * duplicate entries may point to the same EA inode; without
+		 * this check, the second iget could deadlock on I_FREEING
+		 * if the deferred worker already started evicting it.
+		 */
+		for (i = 0; i < nr_ea_inos; i++)
+			if (ea_inos[i] == ea_ino)
+				break;
+		if (i < nr_ea_inos)
+			continue;
+
 		err = ext4_xattr_inode_iget(parent, ea_ino,
 					    le32_to_cpu(entry->e_hash),
 					    &ea_inode);
@@ -1218,6 +1256,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode, "ea_inode dec ref err=%d",
 					   err);
+			/* Track if nlink==0 to skip duplicates (eviction risk) */
+			if (!ea_inode->i_nlink)
+				ea_ino_array_add(&ea_inos, &nr_ea_inos,
+						 &ea_inos_size, ea_inos_inline, ea_ino);
+
 			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			continue;
 		}
@@ -1235,10 +1278,22 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		entry->e_value_inum = 0;
 		entry->e_value_size = 0;
 
+		/*
+		 * Track nlink==0 EA inodes to skip duplicates later --
+		 * they risk I_FREEING deadlock on re-iget.
+		 * Check nlink before put since put releases our reference.
+		 */
+		if (!ea_inode->i_nlink)
+			ea_ino_array_add(&ea_inos, &nr_ea_inos,
+					 &ea_inos_size, ea_inos_inline, ea_ino);
+
 		ext4_put_ea_inode(parent->i_sb, ea_inode);
 		dirty = true;
 	}
 
+	if (ea_inos != ea_inos_inline)
+		kfree(ea_inos);
+
 	if (dirty) {
 		/*
 		 * Note that we are deliberately skipping csum calculation for
-- 
2.43.0

