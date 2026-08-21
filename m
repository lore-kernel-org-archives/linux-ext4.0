Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70706471D03;
	Fri, 21 Aug 2026 10:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306838; cv=none; b=RGhCKMwgPWQ6yt83t3q5SQe9R/r8gFeZM1BxOWwQ8ji5sCTIcaxjMu5hszgfpLSfz5TDt9uwcO8ATKQNLYDbIb1/io/uPH1F5mn47x6vTWEi4mZKzYuAQRZ6P8NyT2QAQ/0ziZvGayuPZxLQB/UFjSLjXD4fciyqmoIhdRBj/cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306838; c=relaxed/simple;
	bh=vF9wAWNQCSylu+wyb1yVHCdGZ3Cw3vf2wZOyWI0P0VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A/q873oQekP8+0bz9bD1GWMu4m19vSi6ZFkK/kxBmWABDtCRaZVXmZzkNqha82zNfXuRLpQEDD59VlWGbeIYdgrncbWiFn2Lebj9Qq+sGG1jMURlOzX2oas8VLrDOV/nwq5UvKFyAqhwJgtcMWi1XwDi2oCezmMJS/P/GWBrZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=X247AOUN; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="X247AOUN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NSHCwHv7yS8/y63bOwsbJ8WsBYqoLopRUEhEJ6k1jlU=; b=X247AOUN4spEVE4WS2XK1qeOu2
	9bTLaA3aVX8dUZOQocBQeKTqYaKaiDeLcP/csFrxl3Dw6R8xj1pIlHPoBOVswLV+KX8Pu1SWggjnv
	Rc5p0G/5c+TcQ2WkvETrAx84jW+x4H342RLux/CeVDCq6ZBWW2FZOgQ6cvnl2wR5ZHvezMwbZ1+d2
	tYd6IVJXF+wmGwceT49kzarv6NvL6WwEe5Ej03xl9hBs6QmEBORUnC6tjQB/hO2TNmd55I5vcEY+d
	y0yCy8E8+JcUpz4A3j0hfokPOO9TayzJKJ0mJ7W5VlhDD0eBGSJfyi38Qwy4bRU7uKG1Wc5mqZLg8
	tcGWDx5g==;
Received: from [151.115.150.205] (port=56752 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxM9L-00000004YC9-1RER;
	Fri, 21 Aug 2026 12:06:58 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] ext4: validate extent root during fast commit replay
Date: Fri, 21 Aug 2026 10:06:00 +0000
Message-ID: <20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

During fast commit replay, ext4_iget() skips normal extent-tree
validation. Replay helpers then call ext4_find_extent() and
ext4_ext_insert_extent() on the unchecked inline root.

A corrupted root can advertise more entries than fit in
EXT4_I(inode)->i_data. In particular, eh_entries == 4 and eh_max == 5
make replay insert a fifth extent past i_data and overwrite adjacent
inode fields.

Validate extent-formatted inode roots in ext4_find_extent() during fast
commit replay, before traversal or insertion can trust the header.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/ext4/extents.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 15972410d460..b95eafb0d5ca 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -905,6 +905,13 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		ret = -EFSCORRUPTED;
 		goto err;
 	}
+	/* ext4_iget() skips extent validation during fast commit replay. */
+	if (unlikely((EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY) &&
+		     ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		ret = ext4_ext_check(inode, eh, depth, 0);
+		if (ret)
+			goto err;
+	}
 
 	if (path) {
 		ext4_ext_drop_refs(path);
-- 
2.47.3

