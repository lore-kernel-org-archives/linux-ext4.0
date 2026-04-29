Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7533121C;
	Wed, 29 Apr 2026 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474936; cv=none; b=Zg5okUOxm+t4oRK3ccGwZZlHf2WwGaO13W4kIAKvWUEuc9KA3W7tenYe4bcRJ4hBpWW0AzmGuIrdXKNbGmAowSUz7CFV4uexs4Kby+6gWSjzB4EzwSqN3P3j8ERv2wS8XWzKUJFsXJ/OygQiiYpTpvp+IdnstnYI9kwhYLkTDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474936; c=relaxed/simple;
	bh=26jYcSEHT20r1Z41rCv39afVmMpkkiHqq/ldUQwWh2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vF0KZSRG7enXi/vpSVrJDNnRlMuTY8FT1eBy8T8jAm1j95l/oMBuTwd49fsznLKbjijZorNXU8L3MkH1/PtGRTCC/Yfd49sOC/MSgBfAYsfdnpDr7ubrHuEXHwhYuPuVABMnRqsT53jGTAnOyHwqXv3CJkk//y++KOBtavsBhAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qbdPwX9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbdPwX9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51266C19425;
	Wed, 29 Apr 2026 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474936;
	bh=26jYcSEHT20r1Z41rCv39afVmMpkkiHqq/ldUQwWh2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qbdPwX9WxzePSZx3nTms6PcQZXUnXJfqvAnZ5B0p/W722dtH4/B7g1/QSjwZs4dgy
	 /7xT+MQS9Aen+K8l8QcNqF7gf78FGZbYnMWdqhmr5nF1PgzyJ8Abni4LV1Qi5rDfIK
	 4GpH9bMuxDKApC/+ixcqQUPV2NFyw9FQJEeAz8lbfFEhFIA/ehi/k72bkxcbH0XaaR
	 gzSSHL0Ic6Kc+u9oyW3LX9O15B6WJB7uWPeVEizCI8WsULmmLqGDE4r3PXcKjR3sV8
	 lqDz+lpOMY8gPIsBNr//MRVrH4/GiAoKq+4RlBcP15RyRayjLEXNgIPrKSpUrKGEXI
	 VPmceGrSANl4g==
Date: Wed, 29 Apr 2026 08:02:15 -0700
Subject: [PATCH 4/4] fuse2fs: enable iomap
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215771.4110581.18263758874889922585.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
References: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that iomap functionality is complete, enable this for users.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    4 ----
 misc/fuse2fs.c    |    4 ----
 2 files changed, 8 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index b10a9a8be00a08..fc72fbe1f00eac 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -2300,10 +2300,6 @@ static inline bool fuse4fs_wants_iomap(struct fuse4fs *ff)
 static void fuse4fs_iomap_enable(struct fuse_conn_info *conn,
 				 struct fuse4fs *ff)
 {
-	/* Don't let anyone touch iomap until the end of the patchset. */
-	ff->iomap_state = IOMAP_DISABLED;
-	return;
-
 	if (fuse4fs_wants_iomap(ff) &&
 	    fuse_set_feature_flag(conn, FUSE_CAP_IOMAP))
 		ff->iomap_state = IOMAP_ENABLED;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 232181bc170183..453e3347b2a295 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1856,10 +1856,6 @@ static inline bool fuse2fs_wants_iomap(struct fuse2fs *ff)
 static void fuse2fs_iomap_enable(struct fuse_conn_info *conn,
 				 struct fuse2fs *ff)
 {
-	/* Don't let anyone touch iomap until the end of the patchset. */
-	ff->iomap_state = IOMAP_DISABLED;
-	return;
-
 	if (fuse2fs_wants_iomap(ff) &&
 	    fuse_set_feature_flag(conn, FUSE_CAP_IOMAP))
 		ff->iomap_state = IOMAP_ENABLED;

