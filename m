Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514A5227BB5;
	Sun, 22 Feb 2026 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771764663; cv=none; b=Xn9nqa9MhqhcBcd/azenEDmyGMHq4bhi5n11zbBQwEdTJhGlXV/y13qg4mQy8CGr6lUgK2bnq9Za78Zs8S5I5HmDLXNFZqlH2mcFV+1sIavR4fJKjN5KWXxqaf7I2h44FsMK8/p/gRcqN/WKICbcxTQSm+2prrlAdmN3d55Mcdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771764663; c=relaxed/simple;
	bh=9alrkBii7inAJ/v6zEDQ0djgRTb3ajjY9W3aAARBa3s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pY6y7D3VurV2t8MoMP/MQfRRry9/SgHA3RGOwkOJfLt8FP91MXAl7yEzIeCK2P8WDA0tzqEfOIDufpvz9PPR48XNr2ukS9zMzyyNHKsjfpcfx49fQeShKJLPF+S9kHI3WCiK7veaXa16sdDewKF6om98aJjVJj3jQ5ZAXjKU1Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=JL6jwXj2; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="JL6jwXj2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jPA+43cqeK52PPxzLr+du30rPQWvLcOSdwAm6ahrmw0=;
  b=JL6jwXj2iz3wpPRD+BooY4yzu44S3R+jDvRZVKBuhYJk45ZmAYfX1vMd
   jbWuhxcc/25L4AW2CxSJnpg8tSBGBO4JKcFjIQhO849sAo1Azjb74QXbp
   7by9WSyutFP+Fg2ttooJoyVHRZOwVA6SEiI5bGR6OGhncPw95svoyamnp
   c=;
X-CSE-ConnectionGUID: 6eo86DJaQOeqF1UV3+Yh7g==
X-CSE-MsgGUID: YUuEAlChTDSHSWnOzF5WmA==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.21,304,1763420400"; 
   d="scan'208";a="264592694"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.102.196])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2026 13:50:58 +0100
From: Julia Lawall <Julia.Lawall@inria.fr>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Matthew Wilcox <willy@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4/move_extent: use folio_next_pos()
Date: Sun, 22 Feb 2026 13:50:49 +0100
Message-Id: <20260222125049.1309075-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A series of patches such as commit 60a70e61430b ("mm: Use
folio_next_pos()") replace folio_pos() + folio_size() by
folio_next_pos().  The former performs x << z + y << z while
the latter performs (x + y) << z, which is slightly more
efficient. This case was not taken into account, perhaps
because the argument is not named folio.

The change was performed using the following Coccinelle
semantic patch:

@@
expression folio;
@@

- folio_pos(folio) + folio_size(folio)
+ folio_next_pos(folio)

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 fs/ext4/move_extent.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -224,8 +224,8 @@ static int mext_move_begin(struct mext_d
 	}
 
 	/* Adjust the moving length according to the length of shorter folio. */
-	move_len = umin(folio_pos(folio[0]) + folio_size(folio[0]) - orig_pos,
-			folio_pos(folio[1]) + folio_size(folio[1]) - donor_pos);
+	move_len = umin(folio_next_pos(folio[0]) - orig_pos,
+			folio_next_pos(folio[1]) - donor_pos);
 	move_len >>= blkbits;
 	if (move_len < mext->orig_map.m_len)
 		mext->orig_map.m_len = move_len;

