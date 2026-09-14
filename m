Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF693D891F
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 16:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404153; cv=none; b=uRsjPP1CmPKpcimlz1CcgqV03bGyujfOQdRL/A7rl4TeibXs5uB4I28BqMitzMkTX7yXec+ovEt35munvhC62s98Goo7J0clF+Ym9oILSI9AFm2BBDTs74m1+6xrQ755JvHMp5xdI/NkqDQ8CLxk+SOZ6JeqdMB9eRiVBPjPzrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404153; c=relaxed/simple;
	bh=cBA/rPoGsokusipqRPBz5n9mniPpk4xpWa5Y9OaV8tU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=MivxwVXLiJHoc/IiJU2O0tTyKn/Yb4fV95umMkxG9GBr4iNrksxq2Y2M0AK4NzAVg0YVXQeDIdiEESXJeeYngJg0jyFvDLMt7BHV/4j34zWkfCBh5eMa4BEfIXOXbURCqgJA8CThZqejAondelsF+EUPDpbtDHhia/q5bWfQIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=whFdnTxS; arc=none smtp.client-ip=43.163.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="whFdnTxS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789404141; bh=a6adwwZVRR1A4QS+2cCAxZ4de2Bc5Gj9JEhZGqOEPN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whFdnTxSzAmcFrcJbpYA5HucH5FjryU2Z7aSpppPs0DgG1O+3vJY50C01MEIWHqU3
	 Lfk4srHkv5uzzQrUMIUvsd81WlyVp2Td1gc+MV1K0jIjF2v4QMqr8IWiXRJRFlqrH1
	 IV7+iu2UNB6sAnxuhJ8I1fEFZOEpY9igL3iVplPc=
Received: from DESKTOP-AT5F202.lan ([183.242.101.176])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id A92B909B; Tue, 15 Sep 2026 00:42:18 +0800
X-QQ-mid: xmsmtpt1789404138tvr73lavg
Message-ID: <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3NBFimfPdipYt87QHRlkjui6J1i6DUyQZuOeeq7zaCI2ttoTrCP6
	 0Z18SnDkJp7kGQYTlTMjqZBbHrrzscR/FagdT/egwgPJTMfJYScMZDfPc2lqwSjOG7jeRP64lKUd
	 /kxe0kSrn66fGu4Q03g8/NKsJVbFll7ZLZbSlZPzAg9deONdY6OKDZRefYGMmQdwg0HxiYV3MYUf
	 aFIJFLXcjfjgr/8yMPdyj0p4e2+g6RvLhxWHN+eCXRzFV6MPXCPQd5//mT0S+JPc/hRai6b1MqQF
	 KDkzbwSBMijOaiCSu07CR2rrXmqSkcRFI7BRWFIkr/tL+9iBOOM35cSSL7X8F9Bqs5btBUzSM2cT
	 Y7hxcINjrFqqCJAm7vy0lcy1mBPusgi95CQKlWUXKixq9GUq25+UyMKFA4MFiBHbDmA5++udZP9k
	 n7WI+3QbJw+yeOiQU2MPVgmDurr9DeZ0U/1ljQV8gAhyIhe921Wp9ZKabggU3nZM3Hm1vVWmpXv2
	 3XXXBnbWYzLgUBn3hxb6bd/dxXYUpcSJ3ENmr82oMl0battf0H9Eg8m+itt0ba5cmCDPX8gzjR6U
	 brkYe+eP4S1nvVK5Y+Z5RvQjPvVmL/w9GSYOXafK5HfsafkjoA5sCeHRv8cCa1nINkIK+qWRr2uV
	 aI1h5xBC7RN0Mh/cWHTr6JHLpZM6/F/ZDIUls9ZGy2zQPj8Cx5R+oTlyoTbbgsFJq8k72kljGV5Y
	 j3g/ptRMBcQ1gHuedhYz7K8GKxHefxgesEvMJ59Lih3VPYikXVUTLv5aTsbOr1iWQd5szZGMMEFP
	 lPASN01owZtFeoLBiznGssOOx/TxhtRvfvqN8cEM7uhcj5lbyWvGgS8VQhHHvzUR15S6a0Gd38Di
	 /NAswhb9AxoUOOx4YEh+h1VDKKgpZQ8pr61yAci4uAc8ykjiQjWiu0RLywkPCMvCwuk5RaCylhvN
	 6gxIy+xQnTejmJrv28l0FHb47DUa2Q586mJS4D05zpF+M25aDsLo4gGSvTc7Du/BQwHC6KfuBFtb
	 7038JMSua+vKinl38C/lTV48RxOYfv+oF5bKh0D+ZGMYEtS30X0/gxz17ZJgklnJehkI2eOcOIiM
	 SSjXgmyky1DmdWYaw=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH v2] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Date: Tue, 15 Sep 2026 00:41:44 +0800
X-OQ-MSGID: <20260914164143.1475854-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
References: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks to Jack's suggestion.
Call the ext4_wait_for_tail_page_commit() helper before
ext4_truncate_failed_write() from ext4_journalled_write_end(),
which avoids invalidating the folio while it is being committed.

Suggested-by: Jan Kara <jack@suse.cz>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes:https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-JLDCqQWEmd9ELtkzddA@mail.gmail.com/T/
Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..10a89bbb994a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -56,6 +56,7 @@ static void ext4_journalled_zero_new_buffers(handle_t *handle,
 					    struct inode *inode,
 					    struct folio *folio,
 					    unsigned from, unsigned to);
+static void ext4_wait_for_tail_page_commit(struct inode *inode);
 
 static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 			      struct ext4_inode_info *ei)
@@ -1605,6 +1606,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 	if (!ret)
 		ret = ret2;
 	if (pos + len > inode->i_size && !verity) {
+		ext4_wait_for_tail_page_commit(inode);
 		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
-- 
2.55.0

