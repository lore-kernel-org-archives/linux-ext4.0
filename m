Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0D1A9B46
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774892750; cv=none; b=gFW+UfL6v9KovgmkbfoemsxjzIDyMHFlOSahPzVqsimRQdMWtJrVDsodjk25xLEi2ATMBzWuyBri0w4ykqjAiSsZoHLp0X0PhlBn/6aDrYat8HmjNpkIeFINScfa5WZD679wip6C6LlfOwlbTBDPBRh/qBE9LVMN3Exuuk37l94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774892750; c=relaxed/simple;
	bh=C4nLq0ZGxU9C1mpoMpaPcjRYC/MiF+813k19aIfQorE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cZzHluReWDPVlk3tNqiM70YZQs3ekdtw6LbXDb5uf5hmi9f8EabiY1VwR3CwPhLewCMyYPjzk4hW7qxVf6uGAku6ZiNbVo+6f5uXd4FNRD6myaZK4JVkwy2UIE4YCQKNw3EC9u9Uw+VnAFytqG0ezNtEgJxoQiOFtGvHRxykGOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aW4q9RIh; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aW4q9RIh"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ad9f316d68so21180095ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 10:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774892749; x=1775497549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0jnXaIJZaI+XJciwHz8zOlF+UyD+Bi1KdMrKx3w+c8A=;
        b=aW4q9RIhxk0JbvljSfPJzQFf7ViyucGyCKLzqT6SO9W1NJV6jflfqhfSo5E8kbmemG
         FO0vFz4aBqUUWS42aqhQ4UFlBJJO3ST2oaKpK2ctQJlZymdrPCzh0+kJ9MKfQ8P+9BCP
         Dw9/EjYqVF5yAUCLe194Of6ZIG1+yz3hpOFlnpSdaREBrNVBOr6yrUkuSOh5SK9uyWen
         9IqCSd9uSMaD67JEe6IVrg84rDwKEzhJJBVi9oq5SgNSnA+Z6y11d6+qbU9Qp4Zf/aJL
         84RrfWIvaeE9OaOpG/RHSfgyvHVhCKSpciKuwAiAebMwqalm6Xzc+YudawYmc2AuudES
         abTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774892749; x=1775497549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jnXaIJZaI+XJciwHz8zOlF+UyD+Bi1KdMrKx3w+c8A=;
        b=o2KUQ1yZJwKjqTAn5luxelIfMCq28C6F78hEngkH18/C9R1jOKhFGuYdR6rBhkM0g0
         bZdbx95uxBIWahBvJWo8iTqltpE7E/4dvke7jXAE0L5u9wLO71/3fHf7njhHUUY7eIIw
         0sszCFdvqpyax63AVy9tiTl/QS1mLu4hXlpGPU1O1k7yBCs+dcD1IcvadXRUVmSA7xTR
         deY9hCNazFvnK4Z12PFyfZuQfN1pQJ6GBCuaVE7pTqf34Zsk04wiQN/zHzvAqNw7RCgQ
         ab/oyFusmkRwv746+3koYaORfi5wyDz+WAoUhGW1IIBl82xLxaCCaMzkbzh3jKjkbiMx
         dNSQ==
X-Gm-Message-State: AOJu0YyzYSbQafXkPovC9mi2i+Q0veQfIvEcwyNW0RqEolakCyCZ/4WQ
	crh9zRh4CZR47f5BX6VjykZjWcBLjF/PVntk++z0O9xt5Fu6iozL1UcZube8Npz/sqXmMw==
X-Gm-Gg: ATEYQzyx64JMCyZMIYZHus+EzWIVfL7mcTm1xjkbwYV/WJ/OtCpSLbA10kUnuywmnTO
	8yaHMqTz0vkO8o4paqDmhbCFq0FnyVFpHHOtq0+rsLvbXzO4pjM0G52QGT7XATaV+62bH0Wtna1
	aWUY+SSE+v+Q8BD4l3G3F5eQ3T4ZaM3VfJKKLJRNeLoBR12heDGlspjjpIHqp884oh7g+OJU9VH
	bZdz83HqdkobQcipAOFWANyHWEKBzMZJ68nLdp4NNdTJxvDRzHhaiPCNoFHZoon5e66Ik10TZ7J
	PkvC4vUKsFHF3LZWrI7MIvASygahPypz1hO98yF9R59bE4mInC9YRLjcMh7AHzrXhM3HhlphAC+
	90YI3TSob55ZPaqQymTBTdEmX4hBxnSuyzWvX+osKDgOYknHKu6XA+26e+ybFpJVhyTiua/96KG
	jMouVPviaA+cdB6zU2c/IaayQBxDm1OIjz
X-Received: by 2002:a17:903:32c6:b0:2b2:4775:fa02 with SMTP id d9443c01a7336-2b24775fd98mr88081045ad.48.1774892748653;
        Mon, 30 Mar 2026 10:45:48 -0700 (PDT)
Received: from localhost.localdomain ([240b:11:b6c1:f600:94fc:1e9:a262:57b8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242680132sm90934415ad.32.2026.03.30.10.45.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 30 Mar 2026 10:45:48 -0700 (PDT)
From: skoyama.kernel@gmail.com
X-Google-Original-From: skoyama@ddn.com
To: linux-ext4@vger.kernel.org
Cc: Sohei Koyama <skoyama@ddn.com>
Subject: [PATCH] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
Date: Tue, 31 Mar 2026 02:42:48 +0900
Message-Id: <20260330174248.71268-1-skoyama@ddn.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sohei Koyama <skoyama@ddn.com>

The commit c8e008b60492 ("ext4: ignore xattrs past end")
introduced a refcount leak in when block_csum is false.

ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
get iloc.bh, but never releases it with brelse().

Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
Signed-off-by: Sohei Koyama <skoyama@ddn.com>
---
 fs/ext4/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7bf9ba19a89d..19c72e38fb82 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1165,7 +1165,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 {
 	struct inode *ea_inode;
 	struct ext4_xattr_entry *entry;
-	struct ext4_iloc iloc;
+	struct ext4_iloc iloc = { .bh = NULL };
 	bool dirty = false;
 	unsigned int ea_ino;
 	int err;
@@ -1260,6 +1260,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			ext4_warning_inode(parent,
 					   "handle dirty metadata err=%d", err);
 	}
+
+	brelse(iloc.bh);
 }
 
 /*
-- 
2.39.3 (Apple Git-146)

