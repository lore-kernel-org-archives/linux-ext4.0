Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519033;
	b=R3UFC5Inid9MV087uLJAYsZtAScIiigByDZLbe7wUDze5QCX1zzxQ8Ekyk2jXPHDaeZF
	 P8GkpiEFmls6So9HqG7g8ZjPjxcP5r16a8YshnsSsuxrq1DydY/PRRamypwIOnmR4GWMy
	 YT+dxZjWxBzRzSlGzEQpXMXCMMdQ1eYNVdpCzrFZYoyTFJFYwWW1Oqr28LbknhaxzbwMR
	 3fo5PFTq5eMf9t0FlOmODRQlct40S3Ys+eZdDUPRf2yYu09s60RUCIqenC4/1UqzmnLmz
	 Cn2PAkqOFkgFKiCk/0RiIT6WvBFlmV9tDDKwXmspNU2wM+sGBF6dC+U1ix4uxVmKlog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519033;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KO6dxUkUXU98c4tED+8CA7XbSFtv+fywcNSILwQLmRE=;
	b=VeqWD/CJejcObXBnM3k7Le+xzcyAjon84LHFv87CmqHsmq01nf5NPYERcd/AE1eANRRC
	 1372xA0/W1XC7wDcNiXB0wbOsfRwuJt3x88RARIpAt5xmh4NPFTfCOAyGfemnNawpc1oz
	 3nFrcC7t1K9i0Aheu1FCFdk+415QYaKHGL0Khm5uPDRQm6D2UNK+5Gdy91imoy0t6D3Au
	 +xxUPgEpXadzTbN7PlsEwkQTHFNO05zDyBfrwCWsFawrx8tptdLKJPioNrBzbyvxE8FZL
	 eS3Fodnbf9rMBUlZPIUQgP85OObAmKly7phmoEtwPCxd6yVCvdASOTC6JiU/RkyNSnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fDL3tPMW;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CE5606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 11:17:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4CE5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fDL3tPMW
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso1703648a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 03:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795519032; x=1796123832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KO6dxUkUXU98c4tED+8CA7XbSFtv+fywcNSILwQLmRE=;
        b=fDL3tPMWNdKUcFDChCEmhaWh4YN4v+A35ZYvklJlr2+Vh1FtOpNcu6OqJyFH4qfMqD
         OegljK8p/wVmoM+TSKgQTX/d9fSBWQKX0X1Mj/tVod9Fh9eqZabIRlYx6TZP9tH/dBsO
         KJWG2NyWBccXuu36HfmBi+3uJ5JUnbwbtSU97xaVWibeWBNnwFXOxv/kux/BE6AmqoCH
         KW4zUQhUylI2+E96dWe3ng5JTtSg6P//Xz7yrblmgKt4b8+ff3wUegZGKjAiv1mokFqS
         GRZUwJoWw+ZR2pQRK29LVrlI4DLcp2DYIbYHjPHCcNg5Ol82Mc2uw9r2uEB1z161MXGk
         mRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795519032; x=1796123832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KO6dxUkUXU98c4tED+8CA7XbSFtv+fywcNSILwQLmRE=;
        b=MetNXpiPAk6h8A+h6CAptF2Vr1MZKeLWx0dDl/hw9wmZ5wnrhBdL1q6AzAaTY2FaxS
         LB79ffp9hYPvilvzXdIqz3ZQKDyrcyDxk6q0Ug6Lmxg5m8JX4U+ehl8n4TfT1AAM5S+m
         yZWUiq1i+8C/GJx7iWryFE/OAOvjbz18ewAF5teoV1JOWQ1HLXzdCauUXO9Wbcc1uoIP
         GUrj6Wt1adPJtBXYDUyo2/8B79cwgASvCgoDbnVGwL9Wik3igoau5zsHKWJI37eTJfDK
         /2IzzAptuo8M2BIbRZC1IA1dEllA4nxYrezRO76msaGi/rNn+mAwDyto9mYy2f2OApMm
         C+UQ==
X-Gm-Message-State: APuU4Z/gWhcNZ7TM45mZDUQ68hd3+NVYyyK57gOAJzN8e7a35k/Cy/cE
	wDcvROH/b/Ff6R3/mbxOP+VEaTobQQlJ4hrj4jwOUuwyl/87fTfJvQ+KM1aeTw==
X-Gm-Gg: AZFdTZcXk4qf0YqqW0ufmzQvqbkgL8XrKXEcv9HsR8WRqdE8tl8o2DPadYU1NzrGXl7
	uymX1ZjJjmqFYJynq3EoltCXCRNFeXo/3fy9jU2R9WRBgRZD2T4Tk0vnc7g5cD8dKJmtGTBVsua
	+E2q511P2z6CTHc32v4Xaot4kkgncBTzpqLwhTqgzH9UA3J1UWnKvej5O/rJYIUPoDeB2RfWkhP
	UNuPpcJVuPdvPUBhkdx9oth3bW5UXtQdBLrW9MfjcuwWCa9yiXA8IEyYXoCl1O/91bjVU/tf3Tx
	ZHcOvQznrGyhab4Z0CiPTPuzye4jDn4qBlM7aBY4Vb4tfMsgjpXqkmHaHeKKOeshkgpI4G1smsp
	E1NMCQtk0cqmedVlFBLYmXDI/xMAS9eO6EWA+HI+MqABrPQjRXcsg9t/05kmLFeLJkr2AH3CUDF
	2UJMBSMmEXWhL2KHB/+3FgTcSS/WjvCveRZGXZYUDSow/5y7CIJP3vYVk46nkX10zL8++ruk3qt
	H8iE7hpR4zBs02S2csEMUneyqVCnfgYphO/3FV8V6sjmHCwyVqWxUNhNjDRb2G3HtwRKtwa2U8h
	H6yS2uhcOr0n2F6QlTfDayFrh+NOgaRBlJJge4FT2p3JCGcDvAgGsdkbCXQVjWAidtEc1Dk=
X-Received: by 2002:a17:90b:4a48:b0:3b3:cde6:d8d3 with SMTP id 98e67ed59e1d1-3b41c961793mr11242289a91.38.1795519032109;
        Tue, 24 Nov 2026 03:17:12 -0800 (PST)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b8c2fcesm7801756a91.4.2026.11.24.03.17.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Nov 2026 03:17:11 -0800 (PST)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH 1/2] ext2: Reject a superblock with an invalid s_first_ino
Date: Tue, 24 Nov 2026 19:17:07 +0800
Message-ID: <20261124111708.24204-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
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

ext2_fill_super() takes s_first_ino from a revision 1 superblock without
checking it.  ext2_get_inode() and ext2_nfs_get_inode() only reject
inode numbers below EXT2_FIRST_INO(sb), so with s_first_ino == 0 an
inode number of 0 gets through, and (ino - 1) wraps around when the
block group is computed.  On such an image, opening a file handle with
inode number 0 (open_by_handle_at(), or an NFS client if the filesystem
is exported) triggers:

  block_group >= groups_count - block_group = -1, groups_count = 2
  WARNING: balloc.c:51 at ext2_get_group_desc+0x5b/0x90 [ext2]
   ext2_get_inode+0x9c/0x160 [ext2]
   ext2_iget+0x63/0x4b0 [ext2]

Depending on s_inodes_per_group, the truncated group number may also
land inside the filesystem, so that some other inode is read in place of
inode 0.  Values from 1 to 10 make the reserved inodes reachable through
file handles.

ext4 rejects s_first_ino < EXT4_GOOD_OLD_FIRST_INO at mount time since
commit c37e9e013469 ("ext4: add more inode number paranoia checks").  Do
the same for ext2.  As s_first_ino is an int, this also rejects values
of 0x80000000 and above, which turn negative and make every inode except
the root inode look reserved.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 fs/ext2/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index a40f530872a4..8a4412231394 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1014,6 +1014,11 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	} else {
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
+		if (sbi->s_first_ino < EXT2_GOOD_OLD_FIRST_INO) {
+			ext2_msg(sb, KERN_ERR, "error: invalid first ino: %u",
+				 le32_to_cpu(es->s_first_ino));
+			goto failed_mount;
+		}
 		if ((sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
 		    !is_power_of_2(sbi->s_inode_size) ||
 		    (sbi->s_inode_size > blocksize)) {
-- 
2.43.7

