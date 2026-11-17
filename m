Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794886810;
	b=KcEzMU/nVS/6UuFJpxB2Oa/lntAndD9stBI9jVeTZj+7vK8JtcIRLM6E3Zh+OS6afF5D
	 VMC9eQUqAAFUqwkLt7qPRJOM+oEm1E+jPNaHlaXI6Ru9rR+In3eNAu/fkpyit5yEiyidk
	 QUM9cmdstDrk4+XU4Zl7zgWgUn/zWaTLIa3M0QrekAZ7hSIdaM/po56Tex2OBHtaXkeEX
	 H8GX9zOBbFSPzTu+c7CozCEEPDuZEGxxdyM3JEuwBS3g63+Kkg9zh15CoAd23p6e1JdeG
	 3kZLACGIBHKFkVnuGsfdFXKagCs60bVj6kqyANKBDogZBIhn94Trg4/iB9GnhSER7jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794886810;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+h+jlzE5c2hq2F/rPSQq3Xc262XJEaUM8Jil9/WOXYs=;
	b=IIaWBLxho83kRLlLt3868jIvoUN/mvEwOhAszGFgNqsTObl0bl54VDDoiZTLtx1Y8BNf
	 IqFl7KWUhOBsEmSUUgwwycKK/HQeiUZ0l09FQc+gXv2wu0xp+qQe4Rxh5yk5bg47UACHM
	 6rF+u8SVzycLLlJsh29n6Gre3Jr8JmI+RRj/qhfq+MB0B7cXbPcV0xumLMEVN8qZkhhVf
	 c1evHm9YebnjxfAGdG5qyMj3WYuD0HFTo00ASWu73+H5uS6VslHdo+/lNkQrnjvNZN8v5
	 DimjEuZ98yPls5gkSdMnMKH+b1Adgm6P9pChVxldjUwDaYgoxUxDpZiA1XJyL5USYcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=nAzCw2J+;
	arc=none smtp.remote-ip=162.62.57.49
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564F5606A31C;
	Tue, 17 Nov 2026 03:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 564F5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=nAzCw2J+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794886804; bh=+h+jlzE5c2hq2F/rPSQq3Xc262XJEaUM8Jil9/WOXYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAzCw2J+eEuv5mbKHzo9zpFhy5GIBR22I3c0pFjpVjPlrgP3LoMeQMytcempqKyWD
	 PD9UAtXV0ZyqWOvkqRh2Pu++d/66SqETBAq262kJlEWo+31NeFhTlhB/vaFgX+XLjB
	 Y/jedavY52a3Ux1Qs72B2JvG7M+eI/ny9EqVXZKI=
Received: from ikun ([221.176.157.242])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 9E739AA0; Tue, 17 Nov 2026 11:39:39 +0800
X-QQ-mid: xmsmtpt1794886779tz88pafb6
Message-ID: <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
X-QQ-XMAILINFO: Nz6nvCBXF1ZF+liHtZ5KaBB1jAMuEmW62PPcaZrO1dDpv50pUZFR1GpWAtyoxQ
	 vlgvZN7BlXnxPhT07NQcF/LUE9ArqcbR/iUyTkbn2OPxDmMcsyStuFsoR0srywvxWWH4v875As3n
	 l4A7TbRh6SdnkSmCWpfntaCouCGNDd7AMP5jgXrZd7M4ii852CB87RG2RXcEZyr9PT1LDyK799cx
	 Lh0SWn/cbHwOgjNOqQwSs15DUEQd8tb6uWiVoIgHwvCXbows4oGcGGvKD3uUPRZQzItygyEfSiTr
	 +sY7VjkIEnAmBjlZyKGBP0zKbe6AJ88pH6y1Mrf9N3kymx+qVB394dJMBn36ik2vB8xFuDQ6zD7A
	 BbaeZD+Y93wb+cDMZf4VGR0iKiirmPcSTrFWLd7S7SgBoMYCKBSp96HAeQp6fkjVmy+mN9eys2Of
	 x3U5jdU6BRNxFZGDLJlbnZBhgtpKOqD92WoMCdDw7cn5KluDP5EoRuoZ8NqLCtyd5LOxEy/x1JTV
	 9HTSbFYaiEU0B8DQMlsi+1ewGR8tW/1l26Ecm8utSclIBH6bFOqF41oHNAp1tNAqkEVO9c76qa7a
	 GKTy65JIbyJ430sh7Dd8MPhHUl3IsfsKBsDeoLNm32Hdm+K7PYtC2mR4IAxxyM2EJAQI2kDjyYWz
	 xPAAGscnvhu625sDdjBwyzTHv68LJstsBT6CrKWUgGIL5DAssZGNRkclN4HyV4SmakusMxLqWS7G
	 97/RseH/or7hiUdvhMhTDpL20Bw+siLaJ+Hn1iH9BLLBMujK5BURcjqGTqFfYe6oA+XbzyEmC/41
	 pgoXnrBmzVcd18BWhUeP8MrsPUxAKRt8VBZ56q+mrq8WhvBNUGHVhXIUL7AovuJYJuVTC7PbPAbD
	 I4p34/olG4zXWknV/asJ34s74tPrOcEzrxQ+Wc2HTPnLlNK4XX3YrJ1ATIulXV9h634fTz41pUKP
	 D8hAoGGkmn9/Ev61r6GASPebm69ZoRAZLpBtcn2g+jXRAs8fAUeearcXqVgvIHfMDBWU7sBx0R7J
	 KYEwA0mg==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Alan <3164729207@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	harshadshirwadkar@gmail.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: reserve inode write access before unlinking entry
Date: Tue, 17 Nov 2026 11:39:38 +0800
X-OQ-MSGID: <20261117033938.4578-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <otvuclstcoaysrnywzdttapxbxg7hq3p7lp3iexy7u5cuj6plx@waqfsi2dg2p4>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com> <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com> <otvuclstcoaysrnywzdttapxbxg7hq3p7lp3iexy7u5cuj6plx@waqfsi2dg2p4>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__ext4_unlink() removes the directory entry before decrementing the target
inode's link count. It then dirties the parent inode. If the parent
inode-table block cannot be read, parent inode dirtying fails after the
entry has been removed, and unlink returns without dropping the target
inode's link count. With errors=continue, this read error need not abort
the journal transaction, so the directory update can be committed without
the corresponding link-count update.

Reserve the inode locations and journal write access for the parent and
target inodes before removing the directory entry. This makes inode-table
read and access errors fail before the namespace is changed. Keep the
existing namespace and link-count update order, and release the inode
location references on every exit path. Fast-commit replay can skip the
parent update when the directory entry does not match the target inode, so
reserve only the target inode in that case.

The original source-derived injection at the journal write-access boundary
is not evidence for a committed inconsistency: an error after the journal
has already aborted cannot establish a committed transaction. The relevant
failure is an actual inode-table READ EIO before journal write access.

Tested on Linux 7.4-rc3 (torvalds/linux commit
aebb7274476403040d582c61478df8f4a7bf9cd3) with QEMU blkdebug and
errors=continue. On the unpatched kernel, the READ EIO leaves the directory
entry removed with Links: 1 after normal unmount; the JBD2 trace shows no
journal abort and records the transaction commit, and e2fsck -fn reports
an unattached inode. With this patch, the same error is returned before the
directory entry is removed; the file remains present with Links: 1 and
e2fsck -fn passes. No-fault controls pass on both kernels. Also built
fs/ext4/namei.o with W=1.

Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
Link: https://lore.kernel.org/linux-ext4/tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com/
Cc: stable@vger.kernel.org
Signed-off-by: Alan <3164729207@qq.com>
---
 fs/ext4/namei.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

v2:
- Clarify that the committed inconsistency is reproduced by an inode-table
  READ EIO before journal write access, not by an already-aborted journal.
- Revalidate the unmodified and fixed paths on current Linux 7.4-rc3 mainline.

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1aa..4c16aa9ad78176 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3233,6 +3233,7 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 	int retval = -ENOENT;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de = NULL;
+	struct ext4_iloc dir_iloc, inode_iloc;
 	handle_t *handle;
 	int skip_remove_dentry = 0;
 
@@ -3269,6 +3270,22 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
+	/*
+	 * Read the inode-table blocks and get journal write access before
+	 * removing the directory entry. Otherwise, a read error while updating
+	 * either inode can leave the name removed but the link count unchanged.
+	 */
+	dir_iloc.bh = NULL;
+	inode_iloc.bh = NULL;
+	if (!skip_remove_dentry) {
+		retval = ext4_reserve_inode_write(handle, dir, &dir_iloc);
+		if (retval)
+			goto out_handle;
+	}
+	retval = ext4_reserve_inode_write(handle, inode, &inode_iloc);
+	if (retval)
+		goto out_handle;
+
 	if (!skip_remove_dentry) {
 		retval = ext4_delete_entry(handle, dir, de, bh);
 		if (retval)
@@ -3293,6 +3310,10 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 	if (dentry && !retval)
 		ext4_fc_track_unlink(handle, dentry);
 out_handle:
+	if (dir_iloc.bh)
+		brelse(dir_iloc.bh);
+	if (inode_iloc.bh)
+		brelse(inode_iloc.bh);
 	ext4_journal_stop(handle);
 out_bh:
 	brelse(bh);

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.53.0

