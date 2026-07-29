Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A33DB336
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353445; cv=none; b=LkZqGGtqDLJdEIb/ieSLNBeGwqC4XZk4Y9uQqZqWx0jpHNF26+H/y7rxnc7sYOpdGiQxT4S0FoHV5OY2OOwctR3qbMC/wkr5Exn21xQkJnGIoZFWs1eGc0uUg750T1BmTCIIx3b1duTAJMMQ4Sshy63TRMDhc9VVt1oxDg7HmM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353445; c=relaxed/simple;
	bh=Uw7C4e5uBhT8vXzKYITTNDOJUa2oJzwBgsvCUtyl1dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ05d5tAmoQRnO9qA41C6ozDTU5nVt6V0mE5FxRbyZEDDKVSEhpOVAOpA7XBfc4YgOT3/3cvvxoDBOCTGZaI1kF/8bQf6x+C/a29ccmvPKFjD0I/2hfCv6KY33Rea/GIgJalS3WlZbGjLnWLKynbTQO6AY5eMHJBQXy2wQPaKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CB+iZfNb; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CB+iZfNb"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cf452def93so396535ad.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353437; x=1785958237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=StgZMYvucPudjQFyQxx/n6i1IzSm0NIyISLaDyFfQ88=;
        b=CB+iZfNb8n1QXOPMjAuwEz8vRdsdStTKjEWzSqsEr6sNZMDsC1sIC2EQG/SBgyxx4H
         qdi0T2Aprc+q96d47OZMbAU+/N3OSvbF3kkOvI+Qv1gOT3wgMJERREMsky3UXNBMdtHc
         zc5U1XB/my0sSkx8ESD8CNdZF0/twawTjTOI3Mv7sekgMda0THc3vr3WbKkueFB9nrxj
         FAWn2RiP/RxuTqln0s2U3EUm7qgrSsAQQg2Si6xByNBN+jRy5dFdhPwR49LGYlEhhxUA
         7NqD+CbCSmO0ZFlRhhhpVQ3NWXzbzXOz1T3z+/P25/6NVqqxmZRulyqi8HK8bwiu0OHw
         Xqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353437; x=1785958237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=StgZMYvucPudjQFyQxx/n6i1IzSm0NIyISLaDyFfQ88=;
        b=ez2umFjQnfJYSGi+BBPpIvf8ZFveT7wFnaWUG5/Bj0b+dwDYyFAv+5SUFK/39k7ec7
         S2+sY5BDrHMu2P+VmV91Bd5e7hqruSibVKP3qjcmAtPNQ+B9gp/Lnq7TFNLMXn2eKPsG
         KuNPpuTwyKSjeuBEaAG0TtGE5TISaA9V3nZZUTcg/GHltoqSBwj4yHKYnZjODvwhNGt9
         cm9pog93RDKgWf3Lw1ZiGauJNpJehZs0FOnAKVFUgaj2M8vn2cv4/x/h4ni6uzK1oDMR
         L/DLJNtJSIO8HO9Iyfcghqf2CIYCB8kaH6xyWQVboiF0xC3chNgo0ZHDgI/02F1m7KEs
         s82w==
X-Forwarded-Encrypted: i=1; AHgh+Rq0O1kQvCux9DmFbXhHRIrJOA91VZbU0zCbm+eN1wa9dqRxRLUSWSPtDT/n0bmNRsi9CKkPbDoNhs2+@vger.kernel.org
X-Gm-Message-State: AOJu0YzvP0R36gjiV9mg05ZfYIl+oIFF1RbCrrA9qA+5nTOlZKexbzQ3
	MyCYSW+8Wp86FqCkifJLo4NdcjjJkT2nCWR95SJ7W0h4oq+DYaE+muaL
X-Gm-Gg: AR+sD12YOSjW61fo71f3yykbjT3z+8OFjhV+WDeCYLcT4Nprw228fbGwrUAr2q53TFx
	KgCgrf/dbGpr3igAQA0PKsl2yTOR5RBXo2evv3FrMaRLLQ+PdKqnOwmwUDkO5yRYPaa2YH7wk1A
	Dg7ChIny7OvuRkdawlp5Bie5m8cEfUAOBQ578omhVZsQMNLdmDTmf87QWkWjdRtNe5RpPAAmAQr
	WR/NrMzPDhuiWrvDCNTwm/Szrg2L6W7G1fRwG3m+DKpYmdUAbKJi2/sBWtvxAK/LYReRlEoju2D
	kBMWDoEQCQvZ3OnOmwz9AeAXNB+4HNE44fNcFd8vHodH2f4QRFOTA+iFjBiPDR8nwfyc4Cvhig4
	D1S2aCblI0j9n3YnTwUYJZicmwBmFo75dxVSG+JwKBUGQcf9uMUsKroA1ZiR1H8wRGeGCeUX0mq
	CDuiWq/Aabw3WwgAe0eI1mGqFq4WDLLcUBF9erxh65Fk+uBtRE7+xQ1+uwSJoxsdoNymlcLh9Gj
	IzFE00grlDaUWjgt7UiD+hpkO5nqx1choFTOTM=
X-Received: by 2002:a17:902:fa10:b0:2cf:b9f9:18bb with SMTP id d9443c01a7336-2d0266889b1mr22693885ad.4.1785353437030;
        Wed, 29 Jul 2026 12:30:37 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d024b114a5sm14066635ad.21.2026.07.29.12.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:35 -0700 (PDT)
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
Subject: [PATCH v5 20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Wed, 29 Jul 2026 12:27:35 -0700
Message-ID: <20260729192737.3190206-21-joannelkoong@gmail.com>
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

With all in-tree filesystems implementing ->iomap_next(), drop the
->iomap_begin()/->iomap_end() path.

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 6 +-----
 include/linux/iomap.h | 6 ++----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6285..e8a988107530 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -118,11 +118,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	if (ops->iomap_next)
-		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
-	else
-		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-				ops->iomap_begin, ops->iomap_end);
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
 
 	iter->status = 0;
 	if (ret > 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index d203d9fe0f89..0bc1beb47a09 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -195,7 +195,7 @@ struct iomap_write_ops {
 };
 
 /*
- * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ * Flags for iomap_next.  No flag implies a read.
  */
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
@@ -240,8 +240,6 @@ typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap *srcmap);
 
 struct iomap_ops {
-	iomap_iter_begin_fn iomap_begin;
-	iomap_iter_end_fn iomap_end;
 	iomap_iter_next_fn iomap_next;
 };
 
@@ -256,7 +254,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_begin flags above.
+ * @flags: Zero or more of the iomap_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
-- 
2.52.0

