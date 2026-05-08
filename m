Received: from smtp134-24.sina.com.cn (smtp134-24.sina.com.cn [180.149.134.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D083BB40
	for <linux-ext4@vger.kernel.org>; Fri,  8 May 2026 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.149.134.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778223573; cv=none; b=lwHc9iRnECgczyKFvIjr3SjXkYdsEXzA58oeqjhgAWgdqBEoR2VuLYHTWkL3XJWXFVXZ3UsqlSBJFiYGZJhs8cevmGW4iWGWD6j+Ox5W+tlqujCulve+3yOqCvC5dfkURarhKMEZ0E4vzdVy1cNACv8THZzTeI9nHyHz71vORc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778223573; c=relaxed/simple;
	bh=EnYg4YStxteAETbi/pqzyOEawxnwsuPqt4HqxD9x2SI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M+3xslqeyd8OLOhmszJNnLDB1qnOvveicgm/KKfdjHQcmIAmI76nLhrFxIgw4fh+MCUROvaG0laq3+XRVyS0S+n/BSZvXgclXFhVUtbvfMFHQjSz3ZC9CVMsqjcr/kEjsZxLN8vSIl+CszduMYqZHyh9tdRbKYrWxpH7A/HbHfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=X+4ni4mq; arc=none smtp.client-ip=180.149.134.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="X+4ni4mq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1778223566;
	bh=oQlBFXWBtVJr2Gtmt8ckdNW6h+dG64f8U7L3BEb5vF0=;
	h=From:Subject:Date:Message-Id;
	b=X+4ni4mqSi1VI98WHnh2bnG1zKP7MSmnopjGRDqvUtvP6g4UZxFihJocHPLbuDopB
	 l8QfqRzBMol7jCziBGNNRrabqYhe9g0jp8Cb+vN6PEN+FRn3ZWQigAUMzcZrYkXPMb
	 3/D08O3D5iGfJtn1BO3aI5i6elBs92pkirtQmxiU=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.21) with ESMTP
	id 69FD89A50000270D; Fri, 8 May 2026 14:58:47 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 6295883408445
X-SMAIL-UIID: F7F94DC9A00340F5A0DB27FCDA67CEBC-20260508-145847-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	tejas.bharambe@outlook.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Subject: [PATCH 6.6.y] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Fri,  8 May 2026 14:58:45 +0800
Message-Id: <20260508065845.3031006-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tejas Bharambe <tejas.bharambe@outlook.com>

[ Upstream commit 2acb5c12ebd860f30e4faf67e6cc8c44ddfe5fe8 ]

ext4_ext_correct_indexes() walks up the extent tree correcting
index entries when the first extent in a leaf is modified. Before
accessing path[k].p_idx->ei_block, there is no validation that
p_idx falls within the valid range of index entries for that
level.

If the on-disk extent header contains a corrupted or crafted
eh_entries value, p_idx can point past the end of the allocated
buffer, causing a slab-out-of-bounds read.

Fix this by validating path[k].p_idx against EXT_LAST_INDEX() at
both access sites: before the while loop and inside it. Return
-EFSCORRUPTED if the index pointer is out of range, consistent
with how other bounds violations are handled in the ext4 extent
tree code.

Reported-by: syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=04c4e65cab786a2e5b7e
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
Link: https://patch.msgid.link/JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6632.apcprd06.prod.outlook.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 fs/ext4/extents.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7626cf2b07f1..a94798e23c1a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1743,6 +1743,13 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	err = ext4_ext_get_access(handle, inode, path + k);
 	if (err)
 		return err;
+	if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+		EXT4_ERROR_INODE(inode,
+				 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+				 k, path[k].p_idx,
+				 EXT_LAST_INDEX(path[k].p_hdr));
+		return -EFSCORRUPTED;
+	}
 	path[k].p_idx->ei_block = border;
 	err = ext4_ext_dirty(handle, inode, path + k);
 	if (err)
@@ -1755,6 +1762,14 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 		err = ext4_ext_get_access(handle, inode, path + k);
 		if (err)
 			break;
+		if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+			EXT4_ERROR_INODE(inode,
+					 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+					 k, path[k].p_idx,
+					 EXT_LAST_INDEX(path[k].p_hdr));
+			err = -EFSCORRUPTED;
+			break;
+		}
 		path[k].p_idx->ei_block = border;
 		err = ext4_ext_dirty(handle, inode, path + k);
 		if (err)
-- 
2.34.1

