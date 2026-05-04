Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79BE3DD533
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937610; cv=none; b=aZb8YxF+1Wo123ja6H+15Gh5dYOEykDOKpFDuxN54lWxs2GGstNiMuxVP+YvoRH2HcrV5Wdts7kYvS9g2qCOlNT+nJdFJXmfrfZH/qeu3w3xP5KJcXkibyowCLO7hEkWvkwTXxp4ypLwtCzifTuhinfvezVulcOlL+uU7zNS4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937610; c=relaxed/simple;
	bh=1S2j6ay/3yBBykUq/b2w0moq+XPnEJIDyFaLJboasdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VORHnGKIxxXJoroNK9W1h8vGr2xDcq8Z0CCAd0toGKqM9XuMJWSSXdrc6IIqzMe4orgiI2Tg79ByAmWG2kMwoAWW8RRl3xmkRAynP+a0tBIZN7y53wrQqcSztcJHt6IpFt/RdLqxY/gp/z46bZyFo776bumXCdzpl63rGbj7E9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=inE+Pmks; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="inE+Pmks"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX9oc019588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937591; bh=NSLBzVzyVfl4N0kVXMeMl/SAyCxBf7H6PtpCOS284jM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=inE+Pmks79VY86w/SfBavUkr1LN6+IcL1ejy5Bcl208Jw8B2Qxk+VR1UzEXDlNw/i
	 w7SBj5iV+O5Ei6NnNDTpkbY2Osu96hMNS2WdXtDyyD4kPVlSvPudu0R1iC2e7iJG+p
	 CFlikI8vGKTYc7peS001T9Guv+s8dOyxzQUbXLSpvG9yJBwZD/BF7/EzEywlo/R79G
	 x0/GnAmoy+QPxrIMHqQVTbYOB+eGyRI4Eq3u5cLWfi6x1vVfb4+elJ764JU6dPephv
	 5GVC9s1rP8eSBd0jC1DSGuTaxkIbRWSulM5cAgiln2WgkMv2kCdjzsmaBUcw2hnONn
	 lIOZl6C15nRXw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0981F2E00D6; Mon, 04 May 2026 19:33:08 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 6/7] libsupport: fix gcc -Wall warnings
Date: Mon,  4 May 2026 19:33:00 -0400
Message-ID: <20260504233301.2345652-7-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504233301.2345652-1-tytso@mit.edu>
References: <20260504233301.2345652-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/support/cache.c | 12 +++++++++---
 lib/support/cache.h |  2 +-
 lib/support/list.h  |  8 ++++----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/support/cache.c b/lib/support/cache.c
index aec785347..ece0adece 100644
--- a/lib/support/cache.c
+++ b/lib/support/cache.c
@@ -15,6 +15,12 @@
 #include <stdint.h>
 #include <errno.h>
 
+#ifdef __GNUC__
+#define EXT2FS_ATTR(x) __attribute__(x)
+#else
+#define EXT2FS_ATTR(x)
+#endif
+
 #include "config.h"
 #include "list.h"
 #include "cache.h"
@@ -711,7 +717,7 @@ cache_node_put(
 
 void
 cache_node_set_priority(
-	struct cache *		cache,
+	struct cache *		cache EXT2FS_ATTR((unused)),
 	struct cache_node *	node,
 	int			priority)
 {
@@ -820,7 +826,7 @@ cache_flush(
 {
 	struct cache_hash	*hash;
 	struct cache_node	*node;
-	int			i;
+	unsigned int		i;
 	bool			still_dirty = false;
 
 	if (!cache->flush)
@@ -848,7 +854,7 @@ cache_report(
 	const char	*name,
 	struct cache	*cache)
 {
-	int		i;
+	unsigned int	i;
 	unsigned long	count, index, total;
 	unsigned long	hash_bucket_lengths[HASH_REPORT + 2] = { 0 };
 
diff --git a/lib/support/cache.h b/lib/support/cache.h
index 71fb9762f..cd0e8c20e 100644
--- a/lib/support/cache.h
+++ b/lib/support/cache.h
@@ -83,7 +83,7 @@ typedef unsigned int (*cache_node_resize_t)(const struct cache *c,
 					    unsigned int curr_size,
 					    int dir);
 
-static inline unsigned int cache_gradual_resize(const struct cache *cache,
+static inline unsigned int cache_gradual_resize(const struct cache *cache EXT2FS_ATTR((unused)),
 						unsigned int curr_size,
 						int dir)
 {
diff --git a/lib/support/list.h b/lib/support/list.h
index 0ec8de525..54e8e2360 100644
--- a/lib/support/list.h
+++ b/lib/support/list.h
@@ -148,13 +148,13 @@ static __always_inline bool __list_del_entry_valid(struct list_head *entry)
 	return ret;
 }
 #else
-static inline bool __list_add_valid(struct list_head *new,
-				struct list_head *prev,
-				struct list_head *next)
+static inline bool __list_add_valid(struct list_head *new EXT2FS_ATTR((unused)),
+				struct list_head *prev EXT2FS_ATTR((unused)),
+				struct list_head *next EXT2FS_ATTR((unused)))
 {
 	return true;
 }
-static inline bool __list_del_entry_valid(struct list_head *entry)
+static inline bool __list_del_entry_valid(struct list_head *entry EXT2FS_ATTR((unused)))
 {
 	return true;
 }
-- 
2.53.0

