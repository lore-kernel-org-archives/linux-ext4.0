Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B1A3090C2
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 03:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.149.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785469045; cv=none; b=uZwGsLB1pbW+fw1lvIuXRngrwA9iBzBqEIfcuPHNn/WtdQAb0KyXRiYUnWQVI5URRs1vVzjjipmhvlWNkw/HE5qaE03Ig6Ohia2mVi5qWXDWeOR4NaIW3Gg++mwvKfks/g3F+zfwbgPNgepzJ7BwArPN5hZWkcsZY9OvGABxN3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785469045; c=relaxed/simple;
	bh=+U4ce5xmhegygxtTpWAQ63w7/8jdOye49AyJywFIqpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kb4OHhI+cAhhK5tyRbOqR2PofmFhrk2q4Tk2aDoKON9anaQTe5rInnBd83nkXFVHXXGKf0ZuOJTyCTHTSL+wWUlP5GXBDs+ofDJyGIqiif1dMOQvKyTD8r9e26WFcNjb/BJI74elRn05tvhg8e4hb+8sFVTdoLoBfZTiodE76n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=OJwPATGY; arc=none smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="OJwPATGY"
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
	by mx0a-00190b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V3alSW3112000;
	Fri, 31 Jul 2026 04:37:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=apr2026.eng;
	 bh=vmKIQHfROCqm0qET1gXZWzwtGDUUiYnJSq/4DR+mY+4=; b=OJwPATGY4F7L
	KXtNGNTmDynYjvjYFT7Nfb0Gm4yIHSv/QsySeGKqeytmlDW6Kt5ud476aoJGdg06
	k21C2AxehtrEwpNNyw+ljE1YYIfwOUqWdLRRuz/pyGdD424Gb9887gaWfT7kFDeT
	BOcnwAZolPcbYLk0Ae59zlL+BU1SDpyyA4OOfM4nEYfDu+sHrd35s/EGGjLqYank
	Rqj47SYVFKa2S0leQWQBCoGCkUhOy68hsbI6q/VUv82WAcPove3//uoBkxinhrVp
	X19wLDRxRARmqkFQ5bdNcUaJQE0gY8cL1GShS5i80AfVQx3azc2nfloCUDyJICsl
	/YXq4dlAmg==
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
	by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 4frgkyhw4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 04:37:16 +0100 (BST)
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
	by prod-mail-ppoint4.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 66V3YH8W029003;
	Thu, 30 Jul 2026 23:37:16 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.220])
	by prod-mail-ppoint4.akamai.com (PPS) with ESMTPS id 4fr5ng6dxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:37:15 -0400 (EDT)
Received: from ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 30 Jul 2026 20:37:15 -0700
Received: from ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) by
 ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 30 Jul 2026 22:37:15 -0500
Received: from sjc-lp2nq5qm.santaclara.corp.akamai.com (172.27.164.43) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server id 15.2.2562.43 via Frontend Transport; Thu, 30 Jul 2026 20:37:15
 -0700
Received: by sjc-lp2nq5qm.santaclara.corp.akamai.com (Postfix, from userid 30754)
	id 33555AC0E6D; Thu, 30 Jul 2026 20:37:14 -0700 (PDT)
From: Josh Hunt <johunt@akamai.com>
To: <linux-ext4@vger.kernel.org>
CC: <kknox@akamai.com>, <tytos@mit.edu>
Subject: [PATCH 3/3] tune2fs: Add bounds checking for extended attribute processing
Date: Thu, 30 Jul 2026 20:37:01 -0700
Message-ID: <20260731033701.2657758-4-johunt@akamai.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260731033701.2657758-1-johunt@akamai.com>
References: <20260731033701.2657758-1-johunt@akamai.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607310020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX0rdbHQjJz5hc
 HyQiJDPpq4m60cZdXRK59sTriDR3CJVRM8Vz7Ds39yIdGeh5/JiJ3DEtDyAJN62fgQcYANst0qf
 u6UkhHJeqe6r9f/3Pmscr8A8fzPF35tZ6if8RQALiicU3wE6XC+IEinmj5jLihVgscAZNBLKW/5
 R2vPWKWPfz6B3ZmcchLWqvd6myPf7d0h4OyGXZKCbe0BsR/RHW32mHPt4cIhRc/uj/fhAFWr6aj
 35Mnj4kI8l0JkAGjjEZtWotNjraTnLobrg+drsIZAtHXFTil4DcA8S4p1Jq/NPYgGt6vCDlq8RQ
 3Y21Mbatvla++txJaqL8QjlTClNFldKUsniBEax+tzm+GHiYP4YmDX14N0UaKLas8ScyFqpFWoN
 t+jVs03uvhn98HbN48PeIbV6iYZJWec6DwMu9vqMVuWWi4TXWU6tTM8FdEiJjk0wmpX+zT961Tw
 0G4Gid5BgTwnALqFjFw==
X-Proofpoint-GUID: TIaH7O5p1JZx8AcgtJNu9aLRUUVBmqfX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX1vxN8FC/fX4q
 CtUm/PHiLp0TEq1aqIaTmAvEdg25B5mARTA50DKOq7G7zUYUoYI2eW26QBJcepQbob/IUBjg+cd
 u+mkAoOrS8OM0lpgKUu7HatCMwfZf7Q=
X-Authority-Analysis: v=2.4 cv=XKEAjwhE c=1 sm=1 tr=0 ts=6a6c186c cx=c_pps
 a=NaJOksh5yBwW9//Q5C/Ubg==:117 a=NaJOksh5yBwW9//Q5C/Ubg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=4OENtXgxWbduB0e82o7S:22 a=X7Ea-ya5AAAA:8 a=XAAsN4Lwe4Gh3Z7_UAEA:9
X-Proofpoint-ORIG-GUID: TIaH7O5p1JZx8AcgtJNu9aLRUUVBmqfX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606160001 definitions=main-2607310020

From: Kit Knox <kknox@akamai.com>

Add validation to prevent buffer overflow when processing extended
attributes:

- Check ea_inode size against maximum (64KB) before reading
- Validate xattr entry bounds before accessing next entry

This prevents malformed filesystem images from causing out-of-bounds memory
access during UUID or checksum updates.

Signed-off-by: Kit Knox <kknox@akamai.com>
---
 misc/tune2fs.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3db57632..8c292686 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -744,18 +744,25 @@ struct rewrite_context {
 		exit(1);			\
 	} while (0);
 
+#define EA_INODE_SIZE_MAX	(64 * 1024)
+
 static void update_ea_inode_hash(struct rewrite_context *ctx, ext2_ino_t ino,
 				 struct ext2_inode *inode)
 {
 	errcode_t retval;
 	ext2_file_t file;
 	__u32 hash;
+	__u64 ea_size = EXT2_I_SIZE(inode);
+
+	if (ea_size > EA_INODE_SIZE_MAX)
+		fatal_err(EXT2_ET_EA_BAD_VALUE_SIZE,
+			  "ea_inode %u has invalid size %llu", ino,
+			  (unsigned long long) ea_size);
 
 	retval = ext2fs_file_open(ctx->fs, ino, 0, &file);
 	if (retval)
 		fatal_err(retval, "open ea_inode");
-	retval = ext2fs_file_read(file, ctx->ea_buf, inode->i_size,
-				  NULL);
+	retval = ext2fs_file_read(file, ctx->ea_buf, ea_size, NULL);
 	if (retval)
 		fatal_err(retval, "read ea_inode");
 	retval = ext2fs_file_close(file);
@@ -763,7 +770,7 @@ static void update_ea_inode_hash(struct rewrite_context *ctx, ext2_ino_t ino,
 		fatal_err(retval, "close ea_inode");
 
 	hash = ext2fs_crc32c_le(ctx->fs->csum_seed,
-				(unsigned char *) ctx->ea_buf, inode->i_size);
+				(unsigned char *) ctx->ea_buf, ea_size);
 	ext2fs_set_ea_inode_hash(inode, hash);
 }
 
@@ -775,6 +782,9 @@ static int update_xattr_entry_hashes(ext2_filsys fs,
 	errcode_t retval;
 
 	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		if ((char *)end < (char *)entry + sizeof(*entry))
+			fatal_err(EXT2_ET_EA_BAD_NAME_LEN,
+				  "xattr entry exceeds buffer bounds");
 		if (entry->e_value_inum) {
 			retval = ext2fs_ext_attr_hash_entry2(fs, entry, NULL,
 							     &entry->e_hash);
@@ -784,6 +794,9 @@ static int update_xattr_entry_hashes(ext2_filsys fs,
 		}
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
+	if (entry > end)
+		fatal_err(EXT2_ET_EA_BAD_NAME_LEN,
+			  "xattr entry exceeds buffer bounds");
 	return modified;
 }
 
-- 
2.34.1

