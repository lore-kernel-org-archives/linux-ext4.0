Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857918;
	b=WvvWw5yfrg1bFsSfRMvWsrEyOXGU5DtmKWEuHUQsXEMbyj/T4d7qLpeA8r3ozEwT4+fC
	 IDfI3oUxbTERb98resPQeCXduefTAWDnb7k5hxwhIkuN28XuA1oMXxbTia7bXHxkqJ4Mj
	 We5QG9id0X1Qwj14MMvygsus3CzZhSsDCW0KX3wSZGuo702UqIwTZG1Fd2KI5BPf7loBw
	 +1p/cVSjXTOvXcPcSH8PTlPxdcMhdNnpf+lcMB4Mt0MX0I58VQYhAx6r4wJSU8mjEM9dc
	 vExvInuTf2t+zbM28t56RIctnI5fkxnC/yRM25C8J8WoTXYXYYNfohPBNfudo1U34ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857918;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jGsjFTTgYKKaMU1FUDk7Rryk+yOYnZHwRRMPZVYxyAc=;
	b=r49mcibv1mTaABoH7TR5Sq05WmM1lWQluEZr6aQBN2D5l1Ebo0FCwBWexy6JU5JFa806
	 bim0Jf81d6WL/fpcH9AhWBRikDxXcKpeM7gKR0w3HdvSYMMehbm1sGtfQVVb4e6Ln8MhR
	 Ld99t1tAAkrbp+JQLDUlOrolkmVJGg/dymQUErgHW3LUAOb/XcS6l//vQfq6KKdQUEuAp
	 qyqk7dZmuo/jlm6cU7liECd1FwRw7y3CwrahEVE/DD1fqStBJExksif2qTacgU+92GJ1h
	 eGnDK9h5Ny0bwk1E8PN0rh9tYzvkb/nC4b0dKJgABsChMrjjqRHp3GZ8hPShPqUsTfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=p+tqQ2JZ;
	arc=none smtp.remote-ip=185.70.43.172
Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88B6606A31B
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 16:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A88B6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=p+tqQ2JZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792857915; x=1793117115;
	bh=jGsjFTTgYKKaMU1FUDk7Rryk+yOYnZHwRRMPZVYxyAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=p+tqQ2JZ2pQuDMwbxEtAV6PJMUI3OXBuYfj1vOzK6bd/gpAbd/fUypvovK4vemyiW
	 lt792+M2somIa3Vy94XwpDvg69P9J1pMCT5NZhYmGVwK++YL9qtF9hHYnRKaSJUCIb
	 q9NXIX/JeqZOAOxxpfm4SJXUA2q0Zf3IchqhmABl92RtU+XQjA24zexnWiowVhStKP
	 Es1YRi8+3Fi2WIQS4gUoCCx1/Z3UOwyAg1KkIcj+c5nDLgRTXa8k5O5VcetzjDji/d
	 k7JWOERhrnc9hgZ5qN0c1WNhiarLM8/g1xfG0uRE7NfPVfaeiWpVCHJ69Jh7JVDn66
	 fXZ1k+dGTeg8w==
X-Pm-Submission-Id: 4jBl8p21hcz1DFT2
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 1/4] libext2fs: limit index in ext2fs_create_resize_inode()
Date: Sat, 24 Oct 2026 18:04:49 +0200
Message-ID: <20261024160452.1818872-2-lukas@czerner.cz>
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

ext2fs_create_resize_inode() walks the backup superblock groups returned
by ext2fs_list_backups() and writes one reserved GDT entry per group in
gdt_buf buffer. The buffer is exactly one filesystem block in size.

The index is never checked against that limit. A crafted filesystem
image (resize_inode, no sparse_super and more block groups than
blocksize/4) can force OOB read and write past the end of gdt_buf
buffer. e2fsck with ASAN build aborts "e2fsck -f -y" with
heap-buffer-overflow.

Fix it by actually checking the index (last) against
EXT2_ADDR_PER_BLOCK(sb) and return EXT2_ET_RESIZE_INODE_CORRUPT if it is
larger than the buffer.

Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 lib/ext2fs/res_gdt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index 33496480..8bd1188a 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -195,6 +195,10 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 		       fs->group_desc_count) {
 			blk_t expect = gdt_blk + grp * sb->s_blocks_per_group;
 
+			if (last >= apb) {
+				retval = EXT2_ET_RESIZE_INODE_CORRUPT;
+				goto out_dindir;
+			}
 			if (!gdt_buf[last]) {
 #ifdef RES_GDT_DEBUG
 				printf("added backup GDT %u grp %u@%u[%u]\n",
-- 
2.56.0

