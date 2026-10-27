Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793098456;
	b=EE/baklVKbIxS7Bo6eL5B4CpuCao3tGPRZ267En6BQr65jk+DoQqi8vIE7wI8VMZp5xu
	 UxDwKD5bri/08TQHb0jCyRkIHQTuyKbnVwqwsrgEVj6jw8is7+WSkduFyV6zHggHjPL1r
	 hLcmTt+jjM2iKHWf5aOAeayZg4eyADGJI5Mimohp4GEr4Unxlqe3KPRXtnVkrjlr1l4ZH
	 emD3iTDYhYldUhnB1YSRnyMY5lK/MYaMiopAwjfER6EjSAMamt6ddQM5Uc6BPuRgrbkzn
	 WNHBoAT0sPR7Hmn2i2CWeDYlstRbxISk6W72fLj905f1YxiAGX48yx2t0k0hEbNT2Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793098456;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=bAmTpX3wb0+OqB6R+EmDcJt0ycNIGRnme1NJPYQAjhk=;
	b=5ApGgrhsj7k4jWqG7PGmBj3TyhxrTkY0aAGzsh93Bah0dK2Pt+Yn8gxJ+s60kjyFo5ET
	 ToOpCJ1UBWihRJ4EL6h+oQrBepa+rFC6jgT2AeF5nuEYJodp/a97q50prW+Lymzkt5DJr
	 ZPlF9tgHxqWgnAk2GBPHgBMS29VTDVHt+Q661P3fWYFcBa7tP0Bfuw76UbKc+2fN1H/44
	 fyibXt8dn9v6vh8BQ6TcQK8aeH5Sv0/XEmG6rsykjxN+gBXbe2Iffi0H0z1kWPAtxSnJM
	 Q+sz0p3BNj7Bmtra4kZkh+zYEBU2aO+UYmIOjvEb9dZmlDAcBVRQu1VIFG15aLXzQvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=ZLdnVP0l;
	arc=none smtp.remote-ip=162.62.57.210
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F303606A31D;
	Tue, 27 Oct 2026 10:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F303606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=ZLdnVP0l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793098450; bh=bAmTpX3wb0+OqB6R+EmDcJt0ycNIGRnme1NJPYQAjhk=;
	h=From:To:Cc:Subject:Date;
	b=ZLdnVP0lgWSEA9o5dQFuvNvBrsocR7pWwk5SmBcWEUKYAsxy59r2ghPtP/yrkqWFb
	 Moa4jLCXTe3pmQmwcoQxJeEoVdQwikuVGfh2dN8F3YftA+c//SNOKEvVP1gJXQ/TO+
	 LYusmVLdP6EAcddL/R9P6yW52URjh/fazCC9U/J0=
Received: from ikun.localdomain ([221.176.157.250])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id D839AA33; Tue, 27 Oct 2026 18:54:03 +0800
X-QQ-mid: xmsmtpt1793098443tezgeoo0p
Message-ID: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
X-QQ-XMAILINFO: MMvmMAuO2obdG2dVatWCbVwriijG97k/sObkScKIEVp7Ug7Jrus8sBwEqpEHJ2
	 vBcawWGBe3TjkYDAk9Tu8oqcO+GgsDrF7UefI6axQBC3xkhJAIPpnytklQOEW83plqcihjDxNf/L
	 QgtsWliqP7WYtwFOKGnxN6iNTUhLlJS+8lHtILPcCK8hyJUE4ZBuPr5TzI/nDzynaPG1PbSPyP34
	 zQlQCGNvDIRPzVhDxkmndRTXKeV9uT09JumGPrWIpkfDbLGYpQp/PDxsXYHZVjh+CtpuzI1fln/T
	 j06B+F1Y0ImZ2k11cbblJ2w1wJwFQnT6p4VqiVgSor6ejfIyA72PCyovSYj/wdlBwgTVqOalumoo
	 2brqL/Vb3wSSHsEOKN2HosO7C32bv/LzXWCsDmJH0/6zyn0koD4o6Gho1huHmHAotCyMIrjrLD9p
	 tIjrssoflMkbTcFGIlKJwAgljvSXmcvkoSj2T3RRueHa5CJ2zPeFnUy4XY/Gc3WekVCVQIJuifhu
	 9Cp6hzRbl2cWpNhVvArr+7EBV6ZKBmg8JPRu2GceanHeu9bAlVuMY9ZKkSinMWkw+6eD1E0Vm7Z1
	 UGN3UPdiKwW/ubC0ELwS9OPu0CUOSVnGpTnCFBrtE0F0BLXXjqA0hD/xk/5hlVkWoaD6YnNcGoEI
	 5gjjKz1YV/0MqfS7X9PdcYV7PC5IIK33xgpEYMLpihNDdf7B96AgU5Zqaci1HGFF0Opus2YmQ4x7
	 ADIMutTheseTLGTDd6wj5VE8dq9wNAFZknfm8cFKVX8z+aln+m8jmOMZ/pqm7F71ehph6kwaIFcc
	 omTi5xW0w1QIvbROz5oj7KZJlQrH0Sv2TZkLplj/X/HAiOf5RbiUf+wud3/24CYGuPlxxGngKrcT
	 xQoPPliqWlC/rM/6attk3vtjmpBZLT2X8d6z9LdD3GKNSmV8SBRNgrInMwxB6JyFTOYLWtrSSAcw
	 HJYcAow5hxe5S/aVRnpsCaJathZMO206romOlSRnztmNaMCfhVkhTFtaJnrLKA2UFGKQLfW7VK2s
	 Bb3DvaFiLm66TuAHwghDO8ONVk6K4+GO67E4w6UePDiVyW7K+3qA6IW41WfNBxNKGD96lhFyRCNI
	 tp87MooiP+fhAj+/CXEVWgf0TCCw==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Alan <3164729207@qq.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	Alan <3164729207@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: reserve inode write access before unlinking entry
Date: Tue, 27 Oct 2026 18:53:51 +0800
X-OQ-MSGID: <20261027105351.410286-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
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

__ext4_unlink() removes the directory entry and dirties the parent inode
before it updates the target inode's link count. If the inode write access
operation fails after the directory entry has been removed, unlink returns
without decrementing the target inode's link count. With errors=continue,
the directory update can still be committed.

Reserve write access to the parent and target inode-table buffers before
removing the directory entry. This makes inode-location and journal-access
errors fail before the namespace changes. Keep the existing namespace and
link-count update order, and release the inode-location references on all
exits. Fast-commit replay can skip the parent update when the directory
entry no longer matches the target inode, so reserve only the target inode
in that case.

The source-derived fault injector reproduced this window by returning EIO
from the real journal write-access boundary in ext4_reserve_inode_write().
Before this change, after a normal unmount, e2fsck reported inode 13 as
unattached, debugfs showed Links: 1, and the parent directory no longer
contained the file. With this change, the same error is returned before the
directory entry is changed; the file remains present with Links: 1 and
e2fsck -fn passes.

The failure injection and the repaired run were performed on Linux 6.12.1
with errors=continue and an ordinary sync/unmount; no forced-shutdown ioctl
was used. The repaired change also builds in the current mainline tree with
make O=/tmp/linux-mainline-d135ab-build ARCH=x86 W=1 -j8 fs/ext4/namei.o.

Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
Cc: stable@vger.kernel.org
Signed-off-by: Alan <3164729207@qq.com>
---
 fs/ext4/namei.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1a..312ff0b682123 100644
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
+	 * Get the inode-table buffers and journal write access before removing
+	 * the directory entry. Otherwise, an error while updating either inode
+	 * can leave the name removed but the link count unchanged.
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

