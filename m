Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F0D46C85D
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353399; cv=none; b=TlEKW9uvrth7dQPra/APKASypnrSZnRKAJaDHcKdGkRVo3EnuqtKG0pa+M7Pwe41IPdn9TVlvqUWGXIE/vDP4kIwEwa8+klPpUORu1z7AZ9yyrW3Lj7iiBJghjhlpdNKzp02pi5EV+akEv4lKhnCvKMN0xHGdrieKaAWNmPEXd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353399; c=relaxed/simple;
	bh=dm3LN+/ZsUKIhfnc4z/JFkhcplzF7edc+ByCQORKFDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3+UK93/se280rtAnoYMXE+4Ezqe5s48ay9rzIgdC/jA4JYRV8sn/rg5x9Wo3Eke8pcBT6XILqzThe/k1c3tt2U/Ou98f0lMVQQwJ0iM90i1CDZF1qJFlqqaVZVX6dqNXGqwzD3N7z96iTC3lzLqF4oGL/mc7ZP4iod7xuY4gWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QccZjmF0; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QccZjmF0"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so1068389a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353387; x=1785958187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H36vbA9+RdAkC7K19J81IrluTjdhjew2liZ0qqBsVew=;
        b=QccZjmF0dV+R/Z/5hQgnky5glmKN8xTzvq8+jC6iMaG3XbzP6sSk9BbWuvpb7yaiO9
         suAxxi/0qGUqI2cM69ZjtwXHIs5ZC7IDPz6jaUcOZtO3g6IEvS+5HWnjN1uG6SilbQyJ
         d0gVDbl2/EH5ouPif8YBXXoBmKl2xCzdwJ9o0qw21QAVC31LsjBweIhUTq7ykEqlQaqt
         ctZTfVAIXaW8cjVCgpNm1C0Oip4PjqenNZuH8tx5hg8ClcKbT+GX/n1eA7gSR7b/M3ek
         H3a4UHZ8wUMKQjNQyr4G82mpYZLcCq8Qq6/9xyjGVZAASv0nMvUGhMgeSHPSWW1tcG/5
         MOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353387; x=1785958187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H36vbA9+RdAkC7K19J81IrluTjdhjew2liZ0qqBsVew=;
        b=Rugrs7JdWRUNvz6vd0D42D96+IbKiOnq01sJQhvqPEY9+yAoDhRQkPoshy75JH0RAV
         GJbqSuE25VCJbOyEbDblqoPuZEz9S/B9LUWPBJTHsjwgIswQ1YP3cboYM9KHzmgwsBT0
         QPaG4LzeJmaYYnTmWWP6px44lrrRovK4Z3EcIoYHIVdEEpda+rA4RsdYgol1UJX9VLQD
         ShMf+qhzBswddA1QjgEd/65akeP//pPSBgm8WWSGKzl5yRIFpycjDnfih03+cLnKj75Y
         Z1Q+tBWPAb+bMMSqcya23EUd3DZBQm2Mzem2q4Wwhw04xMx640wHzNiP+r19WU31AVxt
         IIiA==
X-Forwarded-Encrypted: i=1; AHgh+RpKFeXbDWBYLDoJKHdDtsarGSVpaIFZaCK5AB3Pr0vf71e/gcpyPTsmfdOAQEyvYzBwRvkH1opfbtOc@vger.kernel.org
X-Gm-Message-State: AOJu0Yybua43C+PpRJ/rJcVrY1suJFU/7A1l4lB28QY3NGCfHRfag+RP
	e8c5fHjMRIKcosTw+ByAgPlBH/dqUwc4OoHTHHiNUrtQqYx3VpDcj61wwHbYpg==
X-Gm-Gg: AR+sD12HfBsHLeRbW8aR2cvOPXA/diaWhG+CUQ1aKFTF8saJE+qJoNTfTCxoX+SOmY8
	JwwVXEx/S4GCMNQu5Yw0UqJFzhGjzNYgARuZc6TnmIDc33cVjTC4NNCZCFZ/xTUjTx35uSbPwdy
	YU2lZ7Uqqm0OY5xY9yfOEbyu2ehiwnIaHrz4XY3TgI7dF5iCfT5alSduHotZzeMt4vajR9kl9uw
	p2tsOy/8YZZQn6dXU2PcBXr65AKTH4+pniqmibAleb/UHjPOuuseiyFvZY0R272DyQMOcEUJ+xn
	nYcGsigUTdD581YnikEVBu2wjfpprDBVbAcAGkNrdNu8mPZrwORSyE7THimFlYBZT0Hp9QoDd/V
	yKhfWJ0/xG+ZsADI971Qc6yqMpr2AP8Lg2/F+1N5QsXP2ClN+v13H4qzD0D0lD0mm9GLyADg/6c
	8nRvaFw5/9ph5m7OynURIPBEzjOljFYQmqyZt5gANp8trxpehQuEQaad716daJvuJ6A6ZKsYeii
	MIHMd7XqDOL5YjgmXT0BXpa6du6RFMFDoblt156
X-Received: by 2002:a05:6a20:7284:b0:3bf:aab1:cc8b with SMTP id adf61e73a8af0-3c8ba547a35mr9358525637.46.1785353387239;
        Wed, 29 Jul 2026 12:29:47 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4d::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb79a3767sm1259481a12.7.2026.07.29.12.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:46 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 02/22] iomap: split iomap_iter() logic into iomap_iter_next()
Date: Wed, 29 Jul 2026 12:27:17 -0700
Message-ID: <20260729192737.3190206-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for changing iomap to use an in-iter (->iomap_next())
model, move the iomap_iter() logic out into the new iomap_iter_next()
helper function.

iomap_iter_next() is added as an inlined helper so it can be called
directly by ->iomap_next() implementations where the begin()/end()
callbacks can be direct calls.

The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
also provided to generate the boilerplate ->iomap_next() wrapper
functions that simply forward to iomap_iter_next() with the appropriate
begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
the case where there is an explicit end() callback.

No functional change intended. The one would-be behavioral difference is
that on the iomap_end() error path (ret < 0 && !advanced), the old code
returned with iter.status left as the caller's last value whereas the
new code zeroes it, but this is not observable in practice as there are
no in-tree callers that read iter.status after the iteration loop.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 116 ++++++++++++++++++++++--------------------
 include/linux/iomap.h | 102 ++++++++++++++++++++++++++++++-------
 2 files changed, 145 insertions(+), 73 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 63617ec48250..bf7d4cccc1a7 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -10,11 +10,12 @@
  * Release the iter folio batch. Note that the iomap flag is meant to control
  * the I/O path for the mapping and may not be set in error situations.
  */
-static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
+static inline void iomap_iter_clean_fbatch(const struct iomap_iter *iter,
+		struct iomap *iomap)
 {
 	if (!iter->fbatch)
 		return;
-	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
+	iomap->flags &= ~IOMAP_F_FOLIO_BATCH;
 	if (folio_batch_count(iter->fbatch)) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
@@ -46,51 +47,27 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 }
 
 /**
- * iomap_iter - iterate over a ranges in a file
- * @iter: iteration structue
- * @ops: iomap ops provided by the file system
+ * iomap_iter_continue - decide whether iteration should continue
+ * @iter: iteration structure
+ * @iomap: the mapping that was just processed
+ * @srcmap: the source mapping that was just processed
  *
- * Iterate over filesystem-provided space mappings for the provided file range.
+ * Helper normally called via iomap_iter_next(). Called after the previous
+ * mapping has been finished to determine whether there is more of the file
+ * range left to process.
  *
- * This function handles cleanup of resources acquired for iteration when the
- * filesystem indicates there are no more space mappings, which means that this
- * function must be called in a loop that continues as long it returns a
- * positive value.  If 0 or a negative value is returned, the caller must not
- * return to the loop body.  Within a loop body, there are two ways to break out
- * of the loop body:  leave @iter.status unchanged, or set it to a negative
- * errno.
+ * Returns 1 if there is more work to do, in which case @iomap and @srcmap are
+ * cleared so the caller can produce the next mapping; zero if the range is
+ * fully consumed; or a negative errno on error.
  */
-int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret)
 {
-	bool stale = iter->iomap.flags & IOMAP_F_STALE;
-	ssize_t advanced;
-	u64 olen;
-	int ret;
-
-	trace_iomap_iter(iter, ops, _RET_IP_);
+	const bool stale = iomap->flags & IOMAP_F_STALE;
+	const ssize_t advanced = iter->pos - iter->iter_start_pos;
 
-	if (!iter->iomap.length)
-		goto begin;
-
-	/*
-	 * Calculate how far the iter was advanced and the original length bytes
-	 * for ->iomap_end().
-	 */
-	advanced = iter->pos - iter->iter_start_pos;
-	olen = iter->len + advanced;
-
-	if (ops->iomap_end) {
-		ret = ops->iomap_end(iter->inode, iter->iter_start_pos,
-				iomap_length_trim(iter, iter->iter_start_pos,
-						  olen),
-				advanced, iter->flags, &iter->iomap);
-		if (ret < 0 && !advanced)
-			goto error;
-	}
-
-	/* detect old return semantics where this would advance */
-	if (WARN_ON_ONCE(iter->status > 0))
-		iter->status = -EIO;
+	if (ret < 0 && !advanced)
+		return ret;
 
 	/*
 	 * Use iter->len to determine whether to continue onto the next mapping.
@@ -98,29 +75,56 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	 * advanced at all (i.e. no work was done for some reason) unless the
 	 * mapping has been marked stale and needs to be reprocessed.
 	 */
-	if (iter->status < 0)
+	if (WARN_ON_ONCE(iter->status > 0))
+		/* detect old return semantics where this would advance */
+		ret = -EIO;
+	else if (iter->status < 0)
 		ret = iter->status;
 	else if (iter->len == 0 || (!advanced && !stale))
 		ret = 0;
 	else
 		ret = 1;
-	iomap_iter_clean_fbatch(iter);
-	iter->status = 0;
+
+	iomap_iter_clean_fbatch(iter, iomap);
+
 	if (ret <= 0)
 		return ret;
 
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+	memset(iomap, 0, sizeof(*iomap));
+	memset(srcmap, 0, sizeof(*srcmap));
 
-begin:
-	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
-			       &iter->iomap, &iter->srcmap);
-	if (ret < 0)
-		goto error;
-	iomap_iter_done(iter);
-	return 1;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_iter_continue);
+
+/**
+ * iomap_iter - iterate over ranges in a file
+ * @iter: iteration structure
+ * @ops: iomap ops provided by the filesystem
+ *
+ * Iterate over filesystem-provided space mappings for the provided file range.
+ *
+ * This function handles cleanup of resources acquired for iteration when the
+ * filesystem indicates there are no more space mappings, which means that this
+ * function must be called in a loop that continues as long it returns a
+ * positive value.  If 0 or a negative value is returned, the caller must not
+ * return to the loop body.  Within a loop body, there are two ways to break out
+ * of the loop body:  leave @iter.status unchanged, or set it to a negative
+ * errno.
+ */
+int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+{
+	int ret;
+
+	trace_iomap_iter(iter, ops, _RET_IP_);
+
+	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+			ops->iomap_begin, ops->iomap_end);
+	iter->status = 0;
+	if (ret > 0)
+		iomap_iter_done(iter);
+	else if (ret < 0)
+		iomap_iter_clean_fbatch(iter, &iter->iomap);
 
-error:
-	iomap_iter_clean_fbatch(iter);
 	return ret;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 21e73cb9c51e..36490c08d6e9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,24 +212,27 @@ struct iomap_write_ops {
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
 
-struct iomap_ops {
-	/*
-	 * Return the existing mapping at pos, or reserve space starting at
-	 * pos for up to length, as long as we can do it as a single mapping.
-	 * The actual length is returned in iomap->length.
-	 */
-	int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
-			unsigned flags, struct iomap *iomap,
-			struct iomap *srcmap);
+/*
+ * Return the existing mapping at pos, or reserve space starting at pos for up
+ * to length, as long as we can do it as a single mapping.
+ * The actual length is returned in iomap->length.
+ */
+typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
+		loff_t length, unsigned flags, struct iomap *iomap,
+		struct iomap *srcmap);
 
-	/*
-	 * Commit and/or unreserve space previous allocated using iomap_begin.
-	 * Written indicates the length of the successful write operation which
-	 * needs to be commited, while the rest needs to be unreserved.
-	 * Written might be zero if no data was written.
-	 */
-	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-			ssize_t written, unsigned flags, struct iomap *iomap);
+/*
+ * Commit and/or unreserve space previously allocated by iomap_iter_begin_fn.
+ * Written indicates the length of the successful write operation which needs
+ * to be committed, while the rest needs to be unreserved.
+ * Written might be zero if no data was written.
+ */
+typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
+		ssize_t written, unsigned flags, struct iomap *iomap);
+
+struct iomap_ops {
+	iomap_iter_begin_fn iomap_begin;
+	iomap_iter_end_fn iomap_end;
 };
 
 /**
@@ -317,6 +320,71 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 	return &i->iomap;
 }
 
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret);
+
+/**
+ * iomap_iter_next - finish the previous mapping and produce the next one
+ * @iter: iteration structure
+ * @iomap: mapping to finish and then repopulate
+ * @srcmap: source mapping to finish and then repopulate
+ * @begin: callback that produces a mapping for the current position
+ * @end: optional callback that finishes the previous mapping, or NULL
+ *
+ * Inline helper that implements the common body of an ->iomap_next()
+ * callback: it finishes the previous mapping via @end (if present), decides
+ * via iomap_iter_continue() whether to keep going, and obtains the next
+ * mapping via @begin.
+ *
+ * This helper is marked __always_inline so that when a caller passes
+ * compile-time-constant @begin and @end callbacks, the compiler can call them
+ * directly, avoiding the indirect-call overhead.
+ *
+ * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
+ * negative errno on error.
+ */
+static __always_inline int iomap_iter_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap,
+		iomap_iter_begin_fn begin, iomap_iter_end_fn end)
+{
+	int ret = 0;
+
+	if (iomap->length) {
+		if (end) {
+			/*
+			 * Calculate how far the iter was advanced and the
+			 * original length bytes for end().
+			 */
+			ssize_t advanced = iter->pos - iter->iter_start_pos;
+			loff_t len;
+
+			len = iomap_length_trim(iter, iter->iter_start_pos,
+					iter->len + advanced);
+
+			ret = end(iter->inode, iter->iter_start_pos, len,
+					advanced, iter->flags, iomap);
+		}
+		ret = iomap_iter_continue(iter, iomap, srcmap, ret);
+		if (ret <= 0)
+			return ret;
+	}
+
+	ret = begin(iter->inode, iter->pos, iter->len, iter->flags, iomap,
+			srcmap);
+
+	return ret < 0 ? ret : 1;
+}
+
+#define DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, end_fn)		\
+int name(const struct iomap_iter *iter, struct iomap *iomap,		\
+		struct iomap *srcmap)					\
+{									\
+	return iomap_iter_next(iter, iomap, srcmap, begin_fn, end_fn);	\
+}
+
+#define DEFINE_IOMAP_ITER_NEXT(name, begin_fn)				\
+	DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, NULL)
+
 /*
  * Return the file offset for the first unchanged block after a short write.
  *
-- 
2.52.0

