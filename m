Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=43.163.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795011594;
	b=diNgTFpwcVd1klcHVHnuzjfddU1Q1Q3jRsYAQjTUUYpPvJGeiOfF+jtbWMyZGUfaf29W
	 Jr+VDviEcTBo7IwnGDgoBtkLxKfqVSr8bX9St7zHbH9Gn+2X4OJjQKMuze2UkOBJcmWjB
	 wRhnTxXQqo8x+qEeIbpnCAHHw1souOvpcyhjZ5KbuRKkoHRtsQGilV9Nfq0QHCUKJHPDY
	 npa2XroGJ1kJ6NJddPTBh4Y7JKHr/X02b2w5O16CN9RMzKl3CFJ02LuHWiHxYVGTGWOmi
	 w2XTpOq++IVNDKf8vuvi3Np2XQ6uU0Mt2RV941YmrqNnN//IKDSVTOweB3RLuNz/l6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011594;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dSUNXYTPof7VaxfrAjSqlJUYRb7d441TRHvtPsDe9u8=;
	b=yAT40DlKHMq9JZnj6eI4A9LBSJ1KVnbkvk7HVXYZHsyu5Fm80XzGoT2xc3Iu/aNMtJev
	 5OpoDmQegt96Sf5u8Zmh75nnLy01XAMmtconIKsTkbRhIMKG20no+4I2peZKYZJOQWWbg
	 tBqFM6mcPGblqqyq7P+vwaBSvmhtd+GYq/jI2ZtSpcCQYIFwgA22ukiybUyeTNK/oCn3r
	 4JQixkfndX2L3yJFz3VlFjIY6pajM4McQjRNIeYBQFWl8Ngm/SYEwf6ibPHuK3RCpFbbS
	 RRFj6fcCxRrOa17P4JZ8eXxwkS8uuQfU/n8oQN1AIxRzDm5EKx+vtpueXqE1np+iM6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=zFv9+mvn;
	arc=none smtp.remote-ip=43.163.128.48
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.48])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D220660A2606;
	Wed, 18 Nov 2026 14:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D220660A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=zFv9+mvn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795011583; bh=dSUNXYTPof7VaxfrAjSqlJUYRb7d441TRHvtPsDe9u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFv9+mvn042VnSIoNBYDGV8Upi7YdORlIgKZyZ7/Z/vRhtGsDa3az8NezW6+lUkDB
	 2gGr8bliEoegPNFUR4gkiHfQI3A6bNXuRZdIo+iWDL5+FDUrpoOSNlg6DOkDj+7gxJ
	 ZgUXSrd+E/51yj0Rkk6lHUqO52C5HIJstpg1zpsA=
Received: from ikun.localdomain ([221.176.157.242])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 4E383A55; Wed, 18 Nov 2026 22:19:35 +0800
X-QQ-mid: xmsmtpt1795011575taoi6oh7q
Message-ID: <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
X-QQ-XMAILINFO: OZoK8I5s/zCBW8/CD5NJpsKWqzzD/mr3M62EDz845Ou1Jp09CRQR7lXnmgpNtE
	 cRv5D65qXKCDNPGaR1Esy0dkPIMOEfsTAq1bqoB4XY+ZMEWcNfCkTF5fVGQ8E/E7tEnmQhhNGjgg
	 fz/9DrRF5TwWUDcvu9geg20zLDIecpFavB+euBJMPxb9np2EBS2oCmJk7pByvDOCG6Otkz0m44Xx
	 R7UEcifkqTr3jhLEI1jWcGetn4YrHt9s6YhN4syI6EkBwfno16yex9YD/DkZVGJdbiz0YOQrmuu2
	 3RbRkV0dtlfViFBwfnU/VIkq3ih15byGQtfc17jXZuiFXxkPVI+4bgmHigajsZiCH1gu9GzTZR2E
	 AbXjJ5ceb8dFnrhdBaWmpu6n7NjZULNiNVKlJpj62gAIjlnWTeoV/IEuTcA4tVFkaW4ZMsmV60bS
	 uStXDh+s4CKbO2JVZl67erkqyB6jU9j/kbblGSmIMKNLH3w4MRptsFdoh22X2g1OcYnW3BHGCby0
	 Pdz9KQWJnf+SjBIjoPXHH0kBGOrBcYBkdfaUauRzKktfRjZnQIOg5YlD7k/5lhk/D+P3JPKLlava
	 byrwG0WKPl8dHPm4gQ1J1/RoXtrILJEvU9RveOUDZsJXM1o3xO81HLa76Ag6XP1rt8hBVVawlasm
	 yh3lwNHtB79Kzd6NE9i5h4sZuhh6UsfLq4RkNiR41t2KjmoQTNUP27nFQNxzxbQ0q4HstA1YNYfh
	 u6Zuckmi8H6UfsNd0dDXUR2dTIfBtA0C+la+gUR04w+uJldtrYkLCEZmCmgN3BF7HCsLjhNvq+sT
	 1JbOee94Fp3zohzGdeRGd3DueQGfMyrstwSgWwWUCx5f/Eoum718o9ygHpu7Orv3oJm/xETe29lI
	 4Xr7imADeWze1kTNNVri2zvzk4wyXkaKqy1ywSTTpMQnrhdYDLdEN1LKbXEo2zBn5/DqQnqoojLm
	 mJrVJ0M/A48aON9noDp/JkpbhNEJ/pPxy/FEwNN5fLIiy2nUAcj+QF5nR4kSw5TKrjY4egd9LY2x
	 XoYyLZuYGNotOw/R3hdCanp7m75mr0V3WziAgt/efzCyrdrhLst7lNllh6aEnxCO9/UokimNP2Pk
	 ZVCShP
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
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
Subject: [PATCH v3] ext4: reserve inode write access before unlinking entry
Date: Wed, 18 Nov 2026 22:19:33 +0800
X-OQ-MSGID: <20261118141933.49011-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com> <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com> <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com> <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv>
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

Reserve the target inode location and journal write access first. When the
directory entry is being removed, reserve the parent inode in the existing
branch before deleting the entry. This makes inode-table read and access
errors fail before the namespace is changed. Keep the existing namespace
and link-count update order, and release inode location references on every
exit path. Fast-commit replay can skip the parent update when the directory
entry does not match the target inode, so only the target inode is reserved
in that case.

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
---
 fs/ext4/namei.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

v3:
- Follow Jan Kara's suggestion: reserve the target inode first and move
  the parent-inode reservation into the existing !skip_remove_dentry
  branch.

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1aa..27fe5e82d6e12b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3233,6 +3233,7 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 	int retval = -ENOENT;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de = NULL;
+	struct ext4_iloc dir_iloc, inode_iloc;
 	handle_t *handle;
 	int skip_remove_dentry = 0;
 
@@ -3269,7 +3270,21 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
+	/*
+	 * Read the inode-table blocks and get journal write access before
+	 * removing the directory entry. Otherwise, a read error while updating
+	 * either inode can leave the name removed but the link count unchanged.
+	 */
+	dir_iloc.bh = NULL;
+	inode_iloc.bh = NULL;
+	retval = ext4_reserve_inode_write(handle, inode, &inode_iloc);
+	if (retval)
+		goto out_handle;
+
 	if (!skip_remove_dentry) {
+		retval = ext4_reserve_inode_write(handle, dir, &dir_iloc);
+		if (retval)
+			goto out_handle;
 		retval = ext4_delete_entry(handle, dir, de, bh);
 		if (retval)
 			goto out_handle;
@@ -3293,6 +3308,10 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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

