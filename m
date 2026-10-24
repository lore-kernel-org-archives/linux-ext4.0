Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857920;
	b=dOHdLR0BYZbCGoa+0BkPxVRBcNuzclnS7usTaIjPuYun5UFum7yHwervj5yIcKtrjOSS
	 4vEyyvKUEW/mWFaF1FkOJTC/2ltPOU16vsRMN2dxVNpq1MypHBtf1xx5YOAfRH9q1riP3
	 mjAk2CDUf0Mr8Qsgpov5RjkIDZi0cs0bFVxWJX2uftuThXukPjhdfADEoxnFDEJ3D4cYU
	 fDoFvLS4e1guaR7cQ5nKODeoESplf/gOHQ7xn1QJIP+yttpjsdUcG40hrQo+S0itewev8
	 y/pLm9JAPVu/yG9TCpuFIFZLJ34TkQLI0pB+ovbUsJbbwXaW7tReQfa/+NUom2cioVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857920;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hVgThhcRCYh8sAbxVokuu/U7tl0eZd2jEc5JAAlXnsM=;
	b=DReVgEO/BYY7jseYhF7PhHPNAbaZn6i5Kc0XEpFy8QmEN1yOLAZEpUcl6gawnThd+X25
	 5tkc4E+qeiOuc6WhkOQvrXf2VMBF7Wa1WtBXLAUnAxpvxjhlzFOJxL3gRIy/YlJgc2eQG
	 FtR2+OBhAs2dKxIkCE69LaIsrlo9jdjplEMAZwtTyKG1oeeQgRStez8JFj8adiwpjqfTm
	 Oc94Ps6SEuq8ubFCkIvHcEKOjdwzdeV9gfpZ05ucLS9Pm/mR4AEY7/p+XBISWGYkshzNz
	 wE7MNifZPs7bjChp0xmxwzXSn4ebW0CiGKhvyQSUU3/o86FG/kicZB42JXozHgUs0zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b="K3/6R16q";
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F7E606A31D
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 16:05:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98F7E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=K3/6R16q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792857917; x=1793117117;
	bh=hVgThhcRCYh8sAbxVokuu/U7tl0eZd2jEc5JAAlXnsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=K3/6R16qJWgg606dvtWUkuI5BFo0IndmV4jU3SGQTpfSSF+nQjsCZdyff4NHUseZC
	 R2lnwUn+DXR/tTDtCb/7bjkUHRHGYiUKfGpb8UYawv5xXjFrvBOlL1fHPnBDjnFhcn
	 O55NVjzDG5OqaSWuBnG3QUaHUwgkOaJCYdOBtGsRVEDTnzdbnp0A6MmG/EtztMY482
	 1keS12GYxDhDEzTjcHXRUhqQ1EHiMiQTKHBot5WpSaGjZxoG6UMKAR+A7RlHariAHM
	 Ynunr+7IVTOlVI7+KIrPDcdWlzkZQaDKxFVXyAUj5P6aeD9AfyuFkXPOPnW8a9ifIY
	 xRjtltFxS98YQ==
X-Pm-Submission-Id: 4jBl8r1XsWz1DDnY
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 2/4] e2fsck: limit index in check_resize_inode()
Date: Sat, 24 Oct 2026 18:04:50 +0200
Message-ID: <20261024160452.1818872-3-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261024160452.1818872-1-lukas@czerner.cz>
References: <20261024160452.1818872-1-lukas@czerner.cz>
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

check_resize_inode() reads one backup GDT block of the resize inode into
ind_buf and walks the backup backup superblock groups, comparing
ind_buf[ind_off] against the expected block number. The buffer is
exactly one filesystem block in size.

The index (ind_off) is never checked against that limit. A crafted
filesystem image (resize_inode, no sparse_super and more block groups
than blocksize/4) can force OOB read past the end of ind_buf buffer.
e2fsck with ASAN build aborts "e2fsck -f -n" with heap-buffer-overflow.

Fix it by actually checking the index (ind_off) against fs->blocksize /
sizeof(__u32) before reading ind_buf[ind_off] and goto
resize_inode_invalid if it is past the end of the buffer.

Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 e2fsck/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index cfc0919a..eb1c7e52 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -831,6 +831,8 @@ void check_resize_inode(e2fsck_t ctx)
 		for (j = 1; j < fs->group_desc_count; j++) {
 			if (!ext2fs_bg_has_super(fs, j))
 				continue;
+			if ((unsigned) ind_off >= fs->blocksize / sizeof(__u32))
+				goto resize_inode_invalid;
 			expect = pblk + EXT2_GROUPS_TO_BLOCKS(fs->super, j);
 			if (ind_buf[ind_off] != expect)
 				goto resize_inode_invalid;
-- 
2.56.0

