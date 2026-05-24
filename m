Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9962631E83D
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655050; cv=none; b=iNRnlQzMZUxCWA0TOi9J4C4gTX4sPm+UjUP81SLWekOCrJ0PolseNQaiNkfT3aNc/68kO8d+bZ+JMz5WSIc44Zb9SP6CeCXYpA0nHPteJf2r8cQ+E/BYMD3Lz9SJFGrup7BqH5GWL4KAthPrJZh+jOxCx/C0Hxj575+6aP9+SF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655050; c=relaxed/simple;
	bh=CYNXz4zwWJL9v/Huwi5vpwbfvuB1GDuCXm/RcJXUH+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwxuR7ENbmgDI0Xv6b3DL0NdMWSNiqvV3pJljFmU2ly9wtnuvsnNIbVTLRcDy+AOqCD3osEQHRfCxpGmgOLyHjMlg8ly76uZvlC19LM4buNnqRL7/mshbkZaLaidd3i0Q4S6ucOiIItwGeqo24xNBA27zb7QCBIgQ0iOUQP7QVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWE1b43h; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWE1b43h"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso75295545e9.0
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655047; x=1780259847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7P0fG3DUnEDmle9wQEulWcAbcDYn/9AHx78F5umJiY=;
        b=GWE1b43hqe1NH/zpqIomTqxgKOb/EAj+HhLubfeXiXvoYPQLHIAt7Z57hks5bQghmp
         //lsGKxUthVbIdGcUsMzG6JaLTQVX1vGQB6k5LkmMLBI963h4KqE+sp+6g4443WPZWi5
         F9WKwTg2Nza+w85i2+2lTaiE6pjKYXk+fNsoy4nXi7Lw8CsJrKeMDVKNMY30Fbfxi93Q
         GaQJyxTAoBMnse7WNi8ihJYfpGbAzbzeN1zP9/Vw7m+eSwJWAGc7GTKeJLO/pV8yeEaB
         wYJkKVabLed2WPq4nc19OmJFfkCQ28FdGxZBP3pbwWjxg6XwkEEUON0GqiocY8ACj6py
         2eHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655047; x=1780259847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m7P0fG3DUnEDmle9wQEulWcAbcDYn/9AHx78F5umJiY=;
        b=rVD5EtN/iAAJ0a9UpBCYSN+GlLgemAUuaHX4VpwC3CgZ9XfrKhDvnUw0mfveu1hmPx
         BzSEug68D8tj+m9Ftd1xhenXKn8wNHFmSLIW9yznsFTNLpJeKBLLJ5if4/Yjuar6qoOi
         Sppx4X4vSfckMea1WvKZj0WB3ffCU13OQqkdxVfxQXsYF2RS+1P5DEwqIcntfZyXHep4
         C5RQS4c+kUYfzp1QxN1GJXrnpbkzIWXrDXhuu49yI9A1HdLx4foi6eBn51DHqOC+iVP6
         Vqgc7vXjTmb4BNbZ9ykI7QvIo4lbd1DnA149mlXPkzuGgzBhkZ4IIEbEAePn92vgMxoQ
         o9+A==
X-Gm-Message-State: AOJu0YzvK8qjFr06+/KHyAM//xOPek0WPjT86tgJ03MhTT/5KLxSUWML
	vIeQiNg0YlbshUEJpferkOLLjhwdDXFP4Zt2ukVnL0+gVxKv9HHYz8q0tLgfWg==
X-Gm-Gg: Acq92OFxlNs1YIUElBGkFjSP+oztOq9nGmLWtFZIAe4SWskDYl7VUEOlUnYP6tjKXYL
	mX7sJE11dBYCJR1tECfFBAxCJZnrMx6jv6Ndmf4MZxyvyG8wMMbRiVDHufbG878K15LVI0NUjUb
	UP3fC+CBrb8GgH6LELY0PX37ZRCeun7+Fml3Aws0UYF6JdV5ZsxvU67LEmxws4XPnCjH4bICT82
	Bdf3eXLGSRWB24eHbg8JlDKUOts0yNy5UGX0b8rqWZuY1zP9GXAMtDyXYZdgkmYJ+Jm6W9okCOg
	8p3cUBeiO+6/qNNw1ovR+frHQzX/28KitKz36SRcPQpxUKjb4kEsIlfBSDnaueaIMlFawQEH1Um
	8bvL74QDoFhXuclzWV4SPXHHzZUlfW65JDwB1CyGMJDbiyyZYEemvwmw5fm/FEAoYANKHCRL8YE
	5qN6Pknn0YU0EGA5BvliT7jD8BQ4JwDpha6hz4ZNC5
X-Received: by 2002:a05:600c:a402:b0:490:3d62:eb0 with SMTP id 5b1f17b1804b1-490426d7019mr161471255e9.24.1779655046634;
        Sun, 24 May 2026 13:37:26 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:26 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 01/13] ext2fs: Consolidate duplicate min/max macros
Date: Sun, 24 May 2026 16:36:46 -0400
Message-ID: <20260524203658.12406-2-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
References: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move duplicate min() and max() macro definitions from individual source
files (alloc.c, fallocate.c, rehash.c) to the common ext2fs.h header.

Add include guards to prevent redefinition warnings when files define
their own versions of these macros before including ext2fs.h.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/alloc.c     | 2 --
 lib/ext2fs/ext2fs.h    | 9 +++++++++
 lib/ext2fs/fallocate.c | 1 -
 misc/e4defrag.c        | 1 -
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 3fd921679..ff29b888e 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -26,8 +26,6 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-#define min(a, b) ((a) < (b) ? (a) : (b))
-
 #undef DEBUG
 
 #ifdef DEBUG
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c4fcb10be..374b8289e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -134,6 +134,15 @@ typedef struct ext2fs_struct_generic_bitmap_base *ext2fs_block_bitmap;
 
 #define EXT2_FIRST_INODE(s)	EXT2_FIRST_INO(s)
 
+/*
+ * Utility macros
+ */
+#ifndef min
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#endif
+#ifndef max
+#define max(a, b) ((a) > (b) ? (a) : (b))
+#endif
 
 /*
  * Badblocks list definitions
diff --git a/lib/ext2fs/fallocate.c b/lib/ext2fs/fallocate.c
index 1ef989cd3..82c18ab75 100644
--- a/lib/ext2fs/fallocate.c
+++ b/lib/ext2fs/fallocate.c
@@ -17,7 +17,6 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
-#define min(a, b) ((a) < (b) ? (a) : (b))
 
 #undef DEBUG
 
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 68e937fdb..e07f28cf6 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -59,7 +59,6 @@
 	fprintf(stderr, "\t%s\n", (msg))
 #define STATISTIC_ERR_MSG_WITH_ERRNO(msg)	\
 	fprintf(stderr, "\t%s:%s\n", (msg), strerror(errno))
-#define min(x, y) (((x) > (y)) ? (y) : (x))
 #define CALC_SCORE(ratio) \
 	((ratio) > 10 ? (80 + 20 * (ratio) / 100) : (8 * (ratio)))
 /* Wrap up the free function */
-- 
2.43.7

