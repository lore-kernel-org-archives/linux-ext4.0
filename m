Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBA335F190
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937606; cv=none; b=X0QqBS2lJmwjQPfXKXKs9NkjodXc8UQLblH/lOjnh6gpF3W7bckOTwU1nTQa1pGlIn2f+BUhdutZCseRRezDeu2w3QvpNH55o3Cci792bmJqV2y79/UHdDgLAV1v+eWWaaPmBtwyhBWoBi5poV70w06vrjzUuvFTYd/ILMH3Dms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937606; c=relaxed/simple;
	bh=El1MRaa57Ip41mpYUS0IWSlqnwfT4KcdCW9oVGSRejY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT1QV3idLz3uX3UxMafJp+I55JdGLgz3hjDcMZ6Md8SazQe0s66Dr7NzRX0uyDob7HD9tiYpj+FyYMCQVaPJjZx0Gws44C8Lsl/FUR3I1odzzLObW85tWLKVI8iclF3KWVGtJdc3rOrKJV3yjXaaMG7JD0WOBCkB4iz9Eq54Kzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Re6K2eE/; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Re6K2eE/"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX8jE019534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937589; bh=XDoMPMPdnMA9jtzzi912J66CNgZNhHmT0uwuU2uZlC8=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Re6K2eE/u829wkeH4VRY4H1K6rM9b5bjmHw5RzICsAtDKJBXxoq4WY5Pg/p2YFh1p
	 +iapMpQJVAjn6VrGgEuy3de7BLdSz26+cOVpOONW/2t2yOesDaRaqhVFoAR1GKLnvD
	 6i9JkZ8JarbTCIgWsarDxm/ogVTBUr+/tOb2g/wrogsL/l4btiRV3Lnryb3OkZbUNI
	 CfpV5izLAHlUVSNHFZGXAkLYNoFiYC7DPYg3KGlQNppi18+gZIZE9LZDsSOJwl0qJ3
	 T0EOyLtJRezGBDNbVQaEhUk9q87O8ayDmMUjhZIfMA2v6OTvakA4QVqIR5fMfvfXt2
	 pBju2otjIgA9Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 00AD12E00D1; Mon, 04 May 2026 19:33:08 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 3/7] libsupport: don't use bzero in cache.c
Date: Mon,  4 May 2026 19:32:57 -0400
Message-ID: <20260504233301.2345652-4-tytso@mit.edu>
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

The bzero() function is deprecated and not available in some
platforms.  It's not needed in any case because we can just use an
automatic initializer.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Fixes: 30b3c80ed6bc ("libsupport: add a cache")
---
 lib/support/cache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/support/cache.c b/lib/support/cache.c
index f9669e3fc..aec785347 100644
--- a/lib/support/cache.c
+++ b/lib/support/cache.c
@@ -850,7 +850,7 @@ cache_report(
 {
 	int		i;
 	unsigned long	count, index, total;
-	unsigned long	hash_bucket_lengths[HASH_REPORT + 2];
+	unsigned long	hash_bucket_lengths[HASH_REPORT + 2] = { 0 };
 
 	if ((cache->c_hits + cache->c_misses) == 0)
 		return;
@@ -886,8 +886,6 @@ cache_report(
 		cache->c_mrus[i].cm_count * 100 / cache->c_count);
 
 	/* report hash bucket lengths */
-	bzero(hash_bucket_lengths, sizeof(hash_bucket_lengths));
-
 	for (i = 0; i < cache->c_hashsize; i++) {
 		count = cache->c_hash[i].ch_count;
 		if (count > HASH_REPORT)
-- 
2.53.0

