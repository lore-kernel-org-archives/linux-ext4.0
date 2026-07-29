Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A7F4963CE
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353391; cv=none; b=OrpZwpT5BReX0MJekqkrlXklvmmh2K7kAP8kgaY6MK2VtAuvhmTmdn8jCwsYJBBgbrnOdpAwyYH2rTtsLoP9dEtRl4T1eahWOec6R1kkWq9mr56nj5pArbHkmBmjp1sTOLR7JLdXE3VeSP0I6NfHGSdLQpB8LrEw/2s3UCchRog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353391; c=relaxed/simple;
	bh=Vp11QT/0XbYaCBpKeV6yIhKanTWoDvDmVvwl/BDJxK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd7bJp0xrrqt2PTjwdsie9Y2UVzO1mvvxx5dcEfccG/VCZC0YIF+VC33McFhJTa0LtpHToxhIMeTfabSxKrGd+6vnY8SHbusToTzaBASIP0kt4DxOnskUZXMEbrb8WRHuC4FHNhA+1ZuWRgoVp3+KxEQ/Jtxjam5fByn3jWS0n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAwL+yC0; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAwL+yC0"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cacf197759so20902985ad.2
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353384; x=1785958184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmSJR2GgSO3TGzDFe0h5lMf1baXvMm5mznLJAPlA6WE=;
        b=VAwL+yC0Ued8kqFGT4RC3I6wmsQ2jkVi3Ck0RZdurA3JRvbocqjhecMiYUdLeDBj4s
         tgxnFF6CILfsBIg/fuKVzCOwKO+H6/6IcIiS7GhF+6FSrGDQqOFwS6FhUZ14S74fgDbi
         gYK1jF+EVtzFg32rIzJZBD269CR141PdV+BF8rUG7oIU14/Q+xMWErQAeoR8k9fTP4LH
         b0tzELOvzKJO5Ymud+8lqEfS0xuc4y/RAUv0LwgUhB5HzlvWnSQ0h5H3hoJXxJQEPfhR
         CAcx0WQPTM6UGd2MigXxUL5JlEAxFUA1/oOlihKQAwi1C+Wk1gn+WigNDlsWFnvMT/Up
         rJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353384; x=1785958184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmSJR2GgSO3TGzDFe0h5lMf1baXvMm5mznLJAPlA6WE=;
        b=G7jggK9xrT1DHM+nkpDPzVBdNfO8wHL/KAGxmO+sJQqIL4+n4PLsKvvETuXrA4i9un
         SQtTmpBR0pRDzOGwOEu27ePV4hHqUJqrKCIWdTxFovwUCSNv58mwDVoEHm/8TRcJ+rh8
         8rUcSOqKNajLyB3Ttk1T1u16YXgwATxLo2hdOT0BEJUoQhyxQ607YRjNfXtcaPpg0XUF
         y2EFH6HU1vBTUa8xQIEiz238KulhuQMjkKF2yua/4hZOKBTlHlq3S/p8JVY6XXrCJ/We
         uZG2SlciubtUwar8VInpfeZ4BGwLI6d02DXrCp+fhznUwauxuFssMMt8bq2xSedbOGbL
         CkSQ==
X-Forwarded-Encrypted: i=1; AHgh+RocbO2E4JHn48y4ZP3PbgG+RJ+Y3uIQWO2qqZmhXgQwTJzmE0uziCof9wK8dVdW8BQEZEmTdp2AHBZn@vger.kernel.org
X-Gm-Message-State: AOJu0YywP+k0ijAD2xZASTPnqQg6VxoPpA0YST29feq0xjrSEE3k9EYv
	72hIJFLpyPp2FzLqT1rRftR7NJ/9uVyYwB90m4jpkf4mkS3HOz0LCwQp
X-Gm-Gg: AR+sD12SpMcKsrIdzmvm5C2l9eMqZgNi97IfMFuFdd7Xbul4wmODLQfzplH+8YlxDFD
	NR0frnpUu8qL+3BBN5rPvfAn6GJSfQObEmmi9d/3/maRhlloYIyTW0W0DdT4E2kv4fAVMmW9uhN
	stj/lQTVwwInTgVrlCOmd5cOYQ+4hQ0Lo06eyTvlxET1UpaPeVHEdj6CJg264KtywldMFpiWI7m
	zKwhUTNdSNcUanKkMyahqGffpcbgSe9oDPWx8VGjkySsri2UVSsVXg1ZO8hidfhDPLUY2l416ZS
	liQrdB4jHxOz6InLtIiWVYoYEt9Kb1PiLRSxSqXO91DhjdNt2MSVZ6DA6KAw7gia26H8hmdH11C
	RXF6NooYEInWzdir/mC6ByZoEKSQijEw8pm4kvr1m7gqK1L4MJjPHOEm9iWojeSHErJyrUT7OBM
	/n27aSeKNKjX5xscfBXRdGIslvOwRSxT/phPMHOrEsGF+TeoCs/TDedbD7TLCHOVl2MI2wn4wIB
	lmYn+ip7g+IJNTWf8r08qrI8zFW2aLMuZynmyU=
X-Received: by 2002:a17:902:e845:b0:2ca:9ab:e725 with SMTP id d9443c01a7336-2d033994b84mr1930845ad.1.1785353383967;
        Wed, 29 Jul 2026 12:29:43 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a18abasm16069385ad.5.2026.07.29.12.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:43 -0700 (PDT)
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
	linux-xfs@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 01/22] iomap: release the folio batch on iomap callback failures
Date: Wed, 29 Jul 2026 12:27:16 -0700
Message-ID: <20260729192737.3190206-2-joannelkoong@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

A sashiko review of an unrelated patch points out that the folio
batch mechanism used for iomap zero range fails to release the batch
in a couple error scenarios. If either calls to ->iomap_end() or
->iomap_begin() fail, the direct return paths bypass the batch
cleanup.

The ->iomap_end() case is not a practical issue at the moment
because there is no user of the mechanism that returns an error from
this path. The ->iomap_begin() case is theoretically possible
because XFS can invoke the fill helper and error out at various
points thereafter. This subtly complicates things because XFS does
not transfer iomap_flags to the iomap data structure in the error
path.

To deal with both of these issues, first make sure to invoke the
cleanup helper in the error path for either fs callback. Second,
update the helper to clear the flag unconditionally and release the
batch so long as it is populated. This more clearly delineates the
purpose of the flag to control the I/O path and not necessarily the
status of the fbatch, so add a comment around this as well.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/iter.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..63617ec48250 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,12 +6,18 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Release the iter folio batch. Note that the iomap flag is meant to control
+ * the I/O path for the mapping and may not be set in error situations.
+ */
 static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
+	if (!iter->fbatch)
+		return;
+	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
+	if (folio_batch_count(iter->fbatch)) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
 }
 
@@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 						  olen),
 				advanced, iter->flags, &iter->iomap);
 		if (ret < 0 && !advanced)
-			return ret;
+			goto error;
 	}
 
 	/* detect old return semantics where this would advance */
@@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
-		return ret;
+		goto error;
 	iomap_iter_done(iter);
 	return 1;
+
+error:
+	iomap_iter_clean_fbatch(iter);
+	return ret;
 }
-- 
2.52.0

