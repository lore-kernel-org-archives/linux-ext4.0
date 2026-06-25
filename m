Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D391332EC8
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416408; cv=none; b=mSAbhNASzhcDvVuaSPPFZ+5ogipukMui0dJ7ayLz62SsleBriZvelML7XUSAstHoAOsw5h8OwY7tA/+iisBQAY5j/HkwF1IQcS6BhHYSveQcJOV4ao3o+czYa4xa4M+16EyAP+deAe8hBmea2ENKyf0TlBW09u5oCZvUpdx5LHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416408; c=relaxed/simple;
	bh=yZWPP/G9skjr+crfJtYaPXXkzvoArI/K6rsUg7et6c4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igUz2VB/QIWxVUl73i6YoCbTFn+fHTgFfUixJruwYA4B/jHEAdwV0wcvRxdeSoaxaQZXeLISSj0aU3fn7NYmhMs1wdJZbYsb2+lxfhBS5FvSni+4wqyR+hMY08qlBSAYz9akMsPM0Mm6pZdiGmpbLlWqPRDi1d5EFuBjTrU+4MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtadajHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtadajHp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A9F61F000E9;
	Thu, 25 Jun 2026 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416407;
	bh=XsZ46uKXILyL4OD78eBcn5uVT9nq1t4gxADDNaCPPjU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EtadajHpO4BK2HOabwkmOQXo/tudvBq9tZ7pebYt1sGD/potBvG+7YUpSrwNJcEp9
	 LBP7LEkc2sJOiD5cjGTxupSzDeHTjv4eK42HU1zNqsa4K4Po4rSGDTNLt7cQBpnEZT
	 UzYBnCwhyuteFr2L26kAqIf8ZHEDUCXeadJT+ySAYdBSW6F/WSESgx7StXo8fy+xCe
	 RGZSqU/wkgYN1P2XGXgbOaKqjkhXLpjarijsWwnas9R/X9YObYmA2xBvoH+apFBk/S
	 UhJgbYNg3HB/RicaxAau3f74NB41CND9Zhu/wuVQTvBjdSc7aNUGw3V60y/StXc4Pe
	 VT+4BFGCCYD7Q==
Date: Thu, 25 Jun 2026 12:40:06 -0700
Subject: [PATCH 3/6] iocache: bump buffer mru priority every 50 accesses
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607203.1810839.12183998072570470675.stgit@frogsfrogsfrogs>
In-Reply-To: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
References: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If a buffer is hot enough to survive more than 50 access without being
reclaimed, bump its priority to the next MRU so it sticks around longer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/support/cache.h   |    1 +
 lib/support/cache.c   |   16 ++++++++++++++++
 lib/support/iocache.c |    9 +++++++++
 3 files changed, 26 insertions(+)


diff --git a/lib/support/cache.h b/lib/support/cache.h
index cd0e8c20e2f3ea..c57cebf99cf589 100644
--- a/lib/support/cache.h
+++ b/lib/support/cache.h
@@ -180,5 +180,6 @@ int cache_node_purge(struct cache *, cache_key_t, struct cache_node *);
 void cache_report(FILE *fp, const char *, struct cache *);
 int cache_overflowed(struct cache *);
 struct cache_node *cache_node_grab(struct cache *cache, struct cache_node *node);
+void cache_node_bump_priority(struct cache *cache, struct cache_node *node);
 
 #endif	/* __CACHE_H__ */
diff --git a/lib/support/cache.c b/lib/support/cache.c
index ece0adeceda8ed..44397ea3bc7ac4 100644
--- a/lib/support/cache.c
+++ b/lib/support/cache.c
@@ -715,6 +715,22 @@ cache_node_put(
 		cache_shrink(cache);
 }
 
+/* Bump the priority of a cache node.  Caller must hold cn_mutex. */
+void
+cache_node_bump_priority(
+	struct cache		*cache,
+	struct cache_node	*node)
+{
+	int			*priop;
+
+	if (node->cn_priority == CACHE_DIRTY_PRIORITY)
+		priop = &node->cn_old_priority;
+	else
+		priop = &node->cn_priority;
+	if (*priop < CACHE_MAX_PRIORITY)
+		(*priop)++;
+}
+
 void
 cache_node_set_priority(
 	struct cache *		cache EXT2FS_ATTR((unused)),
diff --git a/lib/support/iocache.c b/lib/support/iocache.c
index 59b71306f4dd41..82f805e1000e97 100644
--- a/lib/support/iocache.c
+++ b/lib/support/iocache.c
@@ -57,6 +57,7 @@ struct iocache_buf {
 	blk64_t			block;
 	void			*buf;
 	errcode_t		write_error;
+	uint8_t			access;
 	unsigned int		uptodate:1;
 	unsigned int		dirty:1;
 };
@@ -566,6 +567,10 @@ static errcode_t iocache_read_blk64(io_channel channel,
 		}
 		if (ubuf->uptodate)
 			memcpy(buf, ubuf->buf, channel->block_size);
+		if (++ubuf->access > 50) {
+			cache_node_bump_priority(&data->cache, node);
+			ubuf->access = 0;
+		}
 		iocache_buf_unlock(ubuf);
 		cache_node_put(&data->cache, node);
 		if (retval)
@@ -627,6 +632,10 @@ static errcode_t iocache_write_blk64(io_channel channel,
 				     ubuf->uptodate ? CACHE_HIT : CACHE_MISS);
 		ubuf->dirty = 1;
 		ubuf->uptodate = 1;
+		if (++ubuf->access > 50) {
+			cache_node_bump_priority(&data->cache, node);
+			ubuf->access = 0;
+		}
 		iocache_buf_unlock(ubuf);
 		cache_node_put(&data->cache, node);
 	}

