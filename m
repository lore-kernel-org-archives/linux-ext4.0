Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E975C220698;
	Mon, 23 Mar 2026 01:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774231148; cv=none; b=Euh3lDf2AQHKYDkF6CXBj9G1uO3Qt+SyUfcl8M1b5juRPWMr1bFwYWjBYfKx1CM+sn2HbnoL8goGqIIHqMToGRwu2GNaGZ8E5IGdssDheNeNlzafTwOnomqCcCEKG2N8hn4CLoAd+rHhcM5thReANLJvrVBSgFpF9DtsaRohzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774231148; c=relaxed/simple;
	bh=mqsWQIny/xtNJkDzyP34DuNr/8tEIVM+sUUaF8Pk6j8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g+2hon3IBd4SGyixBGZO2jXvrqkVImsRCXivRj0ST0yYohKu4gAn4ATjURv/rDQROoBZcTMkPZ1VA1yxg0h0oqalvIgBi+R5oEzjOwujb3Jn4kiwGgWd3vpGiisBSdz9vFBLXHgT6DNjNdJSTn/KEH0Xw/M5I3FfTH2T7UzT+Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=S3bBQPX5; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="S3bBQPX5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1774231086;
	bh=U6CfW020VaiCPJpEFzx5LZvJi0pfiqwCtRTy25AdTTg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=S3bBQPX5ymw+RqT1ue8TMrmtolKDX80H+u121Rpf8b3hdX9lJDZD2csigcC0ns0kC
	 ya7Kv81gBpNRutrno1cjcdahQ3YbbfCdqd9Y9zHRalLXk4UjUhg+3Oolt5IlRSfek7
	 OS1ghl0N98Q8yTDWLPiOJjlhWoXe+XSc2/t6TLXc=
X-QQ-mid: esmtpgz14t1774231081t9973f5df
X-QQ-Originating-IP: R8HxEBsUaKMU7NU7hpM9fSc9EgbyRv2GSZHwRmuhTSk=
Received: from hongao-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 23 Mar 2026 09:57:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16343628199778094862
EX-QQ-RecipientCnt: 9
From: hongao <hongao@uniontech.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongao <hongao@uniontech.com>,
	syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: [PATCH] ext4: skip split extent recovery on corruption
Date: Mon, 23 Mar 2026 09:57:52 +0800
Message-ID: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MNbA5mkmBXEJj4uCN+9aC4/dSBxy97O0dx2AQipHy9DIU10cKXzymZtR
	maVKS209yqplDu0APaHeECvdbt8GgLsY2/NMlAkQsu62Rmdi0F0AhgycQqDFrHElX/VB5Um
	Q02MGv0awaGVEWCX7KIKiBqspjrq11QRWy+ZxnrzDL6z1UImclhG+tltM2l6eKs5lQdi/q6
	9TH9oga2vdYNr7KrwiI+AJ+1X8Z76Dr0Vu4Ty+O7MpBM99zyMr4TMUZZsyWFlqV9iQ0QYzg
	zPYdEnT+K46cwSAN2u2pzAF4gaVIlmRK/Kb/NCzHHmB/TjTffnHkmI9q3hrm44VwtpM8WZN
	QFuZWS5MKYmox6R77leowuO2JTxKdSG7VG268XRMcdN/dUJzKxfgPVCmGp1CDM5YaqjbnJz
	h9Qv51g4e6H7ryr4eE5p7beCbLgkcOwWZTWVBTt8LLjTlkMuiYFJy/uU3zMYY0ZiyjYaO5M
	MlGZbj84IkAtNTZWWFC9MOxs8bDGPwnsLtAa0vQZrauu0ybLLiurCrsKGnhY0aLspymk0dl
	1zLr6Xs3myoGFAATX3yTl4rSQagpjTfvGHrYDG8Ccbxa4La0GYEW2YiwtWl3Z3krwl7xaAN
	Oy1tVQRM/QfmG+FUEIX2w8VOczb9wxe6fyq+HCl3gW1/GpumJNNwol0S0iLsKMxtfvaHSLS
	ZJm5YV0m+zZyIbBKZDM6ouPxBkUG1SAtq23qQrSj2popbZ7FbtJ4vtrCQ+jI9WvwPG3tvNW
	vm3hEUvBSIWRGCPPAm0xxMpkq3ydnryVnTw+qasHGDm/WdVQNdTDtTawkT4NYSwMCBwFadc
	vWRjxexn3Qx+LfeVNR+T7xbGkluqZpLNthBU2rURxgnozOP/fcoi4otA1TZxLqEU5EG9Eae
	4DPwTVsh6k1mqdOYgCcYA1s+uxLIEfNmaWeq/Y1KOY2TvGffrcXOhAycEb0VSOTmSWBXZPM
	b/kNM+mem1+0Z22dGR+mDadnyYhMFPFxcwYOXz5vsxgQ2YsA4xKJKAuw9bFwWpoPtohI0bG
	4gxoRXc9bsVJuq+qY0ZT5HTb9V9iLe2aRowE1gxjlJTySw0Nmt
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

ext4_split_extent_at() retries after ext4_ext_insert_extent() fails by
refinding the original extent and restoring its length. That recovery is
only safe for transient resource failures such as -ENOSPC, -EDQUOT, and
-ENOMEM.

When ext4_ext_insert_extent() fails because the extent tree is already
corrupted, ext4_find_extent() can return a leaf path without p_ext.
ext4_split_extent_at() then dereferences path[depth].p_ext while trying to
fix up the original extent length, causing a NULL pointer dereference while
handling a pre-existing filesystem corruption.

Do not enter the recovery path for corruption errors, and validate p_ext
after refinding the extent before touching it. This keeps the recovery path
limited to cases it can actually repair and turns the syzbot-triggered crash
into a proper corruption report.

Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
Reported-by: syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1ffa5d865557e51cb604
Signed-off-by: hongao <hongao@uniontech.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae3804f36535..aba9947fd151 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3239,6 +3239,9 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 
 	insert_err = PTR_ERR(path);
 	err = 0;
+	if (insert_err != -ENOSPC && insert_err != -EDQUOT &&
+	    insert_err != -ENOMEM)
+		goto out_path;
 
 	/*
 	 * Get a new path to try to zeroout or fix the extent length.
@@ -3261,6 +3264,13 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
+	if (!ex) {
+		EXT4_ERROR_INODE(inode,
+				 "bad extent address lblock: %lu, depth: %d pblock %lld",
+				 (unsigned long)ee_block, depth, path[depth].p_block);
+		err = -EFSCORRUPTED;
+		goto out;
+	}
 
 fix_extent_len:
 	ex->ee_len = orig_ex.ee_len;
-- 
2.51.0

