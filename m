Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014198;
	b=rkFfqEufoH1d8gBEnWnMEV2y0/IglH1cPnsHwHdcsSAw4m1Ko3NSEGQU73cgFcPM3lFM
	 QxobfuRZs8cgHJMB4M9mJlOsOoJP0tZo21hga8qkjhXRdyIGVHO6u1jIrZJXnqGPzKNLQ
	 luc1GnKD/GkIQMk/0SxfsENIbjVY9MNlRera2/cCk7MEDUYmesV+10eV+fy7BQN6aFluO
	 Gv+Zv3WmMBIkC0Y2iVIez6KXNvfJjMO8yvSnKs2/FsLiOJTRz03D/7izEYLjtiZZkp9cJ
	 UPBsnU9P69u3sDiTj6XYt8opLKUhw+6RYp9K87GMwSRrnACGmsqxiM2BX+yOfYaOnTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014198;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7LYxGGwIkqePbtMipPF4iM+09AE8uF1vkCzbobCtyac=;
	b=l1CRrFz4UHbxvtF5BDqAO/5A9frrSUUw5Vn+O2LRRmCHYfSax8xIZEnm2myiS3I23+2W
	 WbpdRVAsMW+0P0j2y7IZ2NOoVjNyxUVXVTTr5EhqZ6Drd4H9MkSZNYoxaxBYcI4T28QM7
	 yxhdhHwHchvTtAFtHT6z1BPuOuO8tM4Qch+SYo1sPfhGf8K4jiIwynws436bX+0n2JwlC
	 PFF4KsyX4XD+ktK8D8Gz6VqLUSkUkSA5pxLF67yd2KSOYLbMcmq2DcDEldi942ZWbNF38
	 IxAmS3UXpkjAwDylkZytnj25uVSahhWT3MU3+GKlfcB06qIKUgEktefXzYr1FryiEzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=JYDWX0e3;
	arc=none smtp.remote-ip=162.62.57.64
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FC4606A32A;
	Wed, 18 Nov 2026 15:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7FC4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=JYDWX0e3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795014166; bh=7LYxGGwIkqePbtMipPF4iM+09AE8uF1vkCzbobCtyac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYDWX0e3ERQ2MvAjP+6TjPbFRcYyJNk4Dyb39y82WG9YlfYnavY9l9+Zwn5tK1zaw
	 gk2lg2GI6QouMsnpThsdSRY22WWTSsETWjOhhvGOvHJTAmkUxUH1tRp9iN6epFzqmg
	 Av5JUQiObtsiRIWy/Q4hlW8zjkAptdgyNlB3fk8s=
Received: from ikun ([221.176.157.242])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id A9848DD; Wed, 18 Nov 2026 23:02:41 +0800
X-QQ-mid: xmsmtpt1795014161tiywfohef
Message-ID: <tencent_D2DD501AA53948B131F7FD6358E036A4E70A@qq.com>
X-QQ-XMAILINFO: Mdc3TkmnJyI/5h8nstZLCzm3Dpl64DrEY1Rthw00rDHQ9TnQPdPdqSKLTvDdcG
	 vwQDBZp4e/C5KksNGyNtjB2wVN696Pt5U5PhlSFlglEoRGa8mORmjUlz8lBJMSEJ7BqWy7WaeDBH
	 akb5lMj5rqUUKyIxa6v7vfGCzuYLMnlaHt2Uw0VbCN0ABe7YhV29pbDLZNT71ZmhggOqdhG74nUG
	 od4UyVzIj1vXrt/2OTYbU/XGcpF2zPO0rbIriaBmxZ15yaZQ4oblM+ZwiNlUmvPBzfVmEve6vzCt
	 4KV6rlIX2Q3dWq0F1xgAgtKkkaE6pXgNJEPI8/i8M2W+f2taOzG/9ycNtfFX8RWAziZN/878KlHm
	 SMhzr9211sUuoZGQeNi6Sly1m0I2QRXa4FRYS2SVSvCwE9NP8a3q/rf4hN7RhcmE3tuW4JJNc3QF
	 leBJsFXrIGgdYfe3h2H3glUWnveg3Xcmw2ZHh1lqjvW4JfnJEaK+9mEBxejwuD069XSnstIav4o/
	 VBCtg41BSFHxKqDwxaDI/mQWqjK4GVPrnc6U5MocErquiBfItizI7m8US32M30LrhjlZe1renRAw
	 XvoZlnG4IcKA6Qr1HWPHh83aY0tiOhVkW9XTkBhRNYr15CrRfrXsKXEwvlxh45PeNGi0q/Ea3Zw2
	 Ch6UsMXNFZ7GL3NAe4lzJ8++BJjb+Zpe+njCwASFAFBWYkVXtp1Vz4tYIzCo3KMw/Vk0dSUl8Rhw
	 0bS99QRMTDu5GJpAlAXrJtbvmimF3dsps8AwyXBr0zZPTvGaTXoUKxnC3qazrfgd/nAjO48ObbPL
	 g1bqUMZE79GZx/35jvEywRRh3mQwfl3or6s4bHKYKE/+bH4l5NY0Ieyl6Qvve350qvAtrG3BczYe
	 y8BZkuHdC3Rm/iW3G9tvjd1JMYmWE/LGFX3mertRMXEOWdkzcxh8u7jsV8xdTEzKuo+MaDax+46C
	 U5eFMCrxptKIASs7JQI6NCMvBDI4ERzumBtLNrcHQar2wCSTD+vS5s0O4rRNqeEj+cN6cM+MCtub
	 7WmMnzz4+STnwxjC/AC3jqnZo/JSb7CaDYmbZyVddN6/qYGfFHD67b/jO4+BYE4by0XPtGF2Nmd8
	 b9Z+mBRsjlt1xxOMI=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
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
Subject: [PATCH v4] ext4: reserve inode write access before unlinking entry
Date: Wed, 18 Nov 2026 23:02:41 +0800
X-OQ-MSGID: <20261118150241.6679-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com> <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com> <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com> <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv> <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
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
Signed-off-by: Alan <3164729207@qq.com>
---
 fs/ext4/namei.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

v4:
- Restore the omitted Signed-off-by trailer. No code changes from v3.

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

