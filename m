Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54C31DDC35;
	Tue, 27 Jan 2026 09:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506452; cv=none; b=c3Yhve3AE6yfpntUhh3F28iVm9erwvWLVRsIoNzdAZbYWz/FRMd6AgLxHi+i8CDjCh2qP6ctLZOhPSc/6Co2Om5ybQ0Q2jjZKQAx/skUuCKv74nCCSNKoubE4wDzDoXpPcaRvDw9DWtXJWrzIoNI+sYxak2BH0Fhd7NBcoKxIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506452; c=relaxed/simple;
	bh=L+QIuse+ozhQ0Fo/DWNk4BPyA1lKRir4oBdAXLHS+Hs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nO+rVCgMbcYe3EzwDV9irRUOJE4hk7a8lOOOhm+1S6C4/IuQ/t2ifk+2HA9OsJCU7aoPUVk2nDpSAOmKrY/xGuZrXNFVFllFmijwi74/lwHZe9ZDkxN6aZCsusLxoWU/2CvguI+ZCiiwjVboftNVkSgve5hRdgwwhBF2D7yInP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxTms2fz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxTms2fz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88B87C116C6;
	Tue, 27 Jan 2026 09:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506452;
	bh=L+QIuse+ozhQ0Fo/DWNk4BPyA1lKRir4oBdAXLHS+Hs=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=WxTms2fzvAFF1S+pyQW2k6hIKzPkz5PkcOUIv6zVrHht4IVh8BEVz70JdQenuhx3i
	 c1tJIX7aGh+aGYTAlrbjjCIK+CXpicfSFRui2erbcdngFpeTvyKQCE/Zlm5JIKHACj
	 tIXuTiAXNGeuL3cMHnBQtnLXaRonRcRgEbgrbD5vRUJkjdp60IjS6xCNgE+IMvYiH0
	 QY0wfkCxw6G+76bMNK8uKf5X5UI4M156jfVInVPjqt14PAymVpHWy0uLuEWNLM7WUb
	 HCchBeq2Xzwd2PnM5R10ITQ8To/GlSEN7XvSEHYmR4uB8/XRuYokb49B0wkun1+Oqk
	 qu8Ta1TTDcNaQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5BDD19515;
	Tue, 27 Jan 2026 09:34:12 +0000 (UTC)
From: Jiucheng Xu via B4 Relay <devnull+jiucheng.xu.amlogic.com@kernel.org>
Date: Tue, 27 Jan 2026 17:34:10 +0800
Subject: [PATCH] ext4: EXT4_I(sbi->s_buddy_cache)->i_state_flags is not
 initialized
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260127-origin-dev-v1-1-cafda25e307f@amlogic.com>
X-B4-Tracking: v=1; b=H4sIAJGGeGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQyMz3fyizPTMPN2U1DJdyzQLE0Nj0yRLU1NTJaCGgqLUtMwKsGHRsbW
 1AP5MSmpcAAAA
X-Change-ID: 20260126-origin-dev-9f84135b9555
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, jianxin.pan@amlogic.com, tuan.zhang@amlogic.com, 
 Jiucheng Xu <jiucheng.xu@amlogic.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769506451; l=1571;
 i=jiucheng.xu@amlogic.com; s=20250821; h=from:subject:message-id;
 bh=YWP7kPJlOX7OLc+FLI3fR6NkrBzeRbLZcst1TTgNbyA=;
 b=f0Hg3TtsLr4287r90uzc7VGPUI1SUs5bqUrBtUn0WdVP0MYcsg5XZQwNcCvU3XErB11/1f/8P
 cICYbUnQQV3AkdS2lTKlDEsb0lpCMgqXWLVd5Gxs1uM4b8id+zxkTWr
X-Developer-Key: i=jiucheng.xu@amlogic.com; a=ed25519;
 pk=Q18IjkdWCCuncSplyu+dYqIrm+n42glvoLFJTQqpb2o=
X-Endpoint-Received: by B4 Relay for jiucheng.xu@amlogic.com/20250821 with
 auth_id=498
X-Original-From: Jiucheng Xu <jiucheng.xu@amlogic.com>
Reply-To: jiucheng.xu@amlogic.com

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

The i_state_flags originates from an inode that was previously
destroyed and then allocated to s_buddy_cache; it requires
reinitialization.

The relevant log during umount is shown below:

EXT4-fs (mmcblk0p28): unmounting filesystem xxx-xxx
EXT4-fs (mmcblk0p28): Inode 1 (39878178): inode tracked as orphan!
39878178: 1411f3c7 e0182705 78cc454d ac11f000  .....'..ME.x....
da10433b: 1a2e0146 792e03d0 9c2a04d1 0c788ad3  F......y..*...x.
a91573cf: 44270388 4f4202ea 721a12ea 340cbce0  ..'D..BO...r...4
89cb2f37: 0d13f000 4f270414 1a0b01f0 4f880fe0  ......'O.......O
810e3bc2: 3f0c02f0 482b0009 02e048d0 83f43f2a  ...?..+H.H..*?..
3f37c9f7: 02880aaf 00000000 00000000 00000000  ................

Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
---
 fs/ext4/mballoc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dbc82b65f810fed89da7fa7149d3a05de6f107d6..20b07b2bea31ea81ffbd0b4ace3a7b218c8f4dd5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3521,6 +3521,9 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	ext4_set_inode_mapping_order(sbi->s_buddy_cache);
+#if (BITS_PER_LONG < 64)
+	ext4_clear_state_flags(EXT4_I(sbi->s_buddy_cache));
+#endif
 
 	for (i = 0; i < ngroups; i++) {
 		cond_resched();

---
base-commit: 4f5e8e6f012349a107531b02eed5b5ace6181449
change-id: 20260126-origin-dev-9f84135b9555

Best regards,
-- 
Jiucheng Xu <jiucheng.xu@amlogic.com>


