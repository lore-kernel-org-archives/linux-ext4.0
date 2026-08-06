Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3D0485CC4
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035598; cv=none; b=shI3PGyLIef3xvMzO4nxf9acTj1MnrxPRLP4AR/zN5GNwYJGZjrY9E2KVJR9gwLwu251ZhpDeuG0gZ7uPIxKWdB0GxAco95C6vGlExajDYxH5f9bKqsd0yie6TPI0C3CWMs9255KGrn5zWu26zdZPeTIp2aPiYUxygiBdN5xUHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035598; c=relaxed/simple;
	bh=0neISYJFH5vf1iYeHnX8wDVudHaEvy72ntuqHszFLec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNQKO6LFFfm85+xnzpiFptwgbROoJZLzndXnSYXjy14PQ6nhZcZP347CtCjcHW8fXtkR8WPsyqaRqMy/7kJ/CiYYEJhYdZEkB1BwQC1SpxZztmos8aisXDFD6goJvlz++jCKUPyq9UGHstmkkTqTx32MqxD1QCx8rcoEt5V36JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J3fTBh0R; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3fTBh0R"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-59b074ec7ceso899289e0c.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035596; x=1786640396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DRJjTotyJT+hr0WWdtFL/ctkn8lHZ3M1r+YQr9eg6EA=;
        b=J3fTBh0RFlRULbxcBAkmHv7k0HwAUDpVGxIh0ib6BjHpitYK/lQlhSFW4kA2A/zl1s
         yY/4XLTCHApnP4f0DpfgswegGLdz1Jyp6O2iTiXt91o9fEKa4ru9slUyB9Zj+NTcNUg2
         pPaObPPMVj7bBxcGrMhNMENPt3WOD6iQnlqmVhF4jcF+5SmQOJwiDndOpiqn3zUvY+OS
         e2oJN0tNk3sWBLeXJEj29tnf88O4CPXNIH1iATv4TJnh3wkOocV7kYeC5cidRsQuGf42
         SDfeqLRexGlN6OPfaU8hie7YLbDCdztdNO2xgG0QsyLkO7luIv0L6sZXyPWc/3eUBwBm
         hCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035596; x=1786640396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DRJjTotyJT+hr0WWdtFL/ctkn8lHZ3M1r+YQr9eg6EA=;
        b=lwdfo3YlI9jjvgn0bAnIXTuwpKCILIRPZRZJUIYKD/SCQ/odET6M64v/Zkzgw8O15q
         CbIdelQJFNBLd0aZia3QCrH4N+wvkDhnMPYHVz3OwFtpeNjvuTFQ4u/6u78mIFmb/Ab3
         99OUeIUoDAsIyhtm0LDvyoIsLoqROZve6+f12Acs6oAbq+ifIbeYA++P2H1QXmrz5e2m
         5gV0gH2cGLphfhTF0yxmTUbiiwiqoRbyQ2EOnmEfVQPCeLNfrbXvSbXZYwt05dz6q0wf
         ZrJ+znTH6RCAa9AB9klvBgge6k4dSlSIAINoqY8lrkutr41j2O1uMY5AXDpHP9ZH6sEt
         YgYw==
X-Forwarded-Encrypted: i=1; AHgh+Ro+JeETF88ZpLrnc0HWSledZk+C5RXbE02xztWaaL2nAn/p0Sr+RRLbhw1Nd029Di02wzdp/T3Mo+xP@vger.kernel.org
X-Gm-Message-State: AOJu0YzSzrEA0+V2KXm+FRyHNuOY0epaRP8IAFPrVjoLK71nEbCpBhSZ
	Z2CO1ukS4856+wl2b4VOsGNyy6noIaaD5l7MXIfoYaz+6MLpWGj+ITGt
X-Gm-Gg: AR+sD11ll6TPlGZNUG4dOdZsg6Fyy6d4wyFAHe2zLBO/ZPDIyZNxXrc4/bMRkx9uG2Z
	hKLbb9q06LZ64pSPnEogjW+fFlavEwYogJgVFiRApKfCCQb0Rv3wBsq8YbnxQaBUQgiLGCSxq47
	lsjEF9WQ4lqgApPjgY5hUar2ZK9VQdbI14JAbH3omY3qoYM05DtbGvMEn+fiid8b3FNqeTSDiXF
	HMwOaaofLXQFIyCZSIs1kkxdO/+4S6I0Cfp5FUz0vpCr4jF1xPoqe72yzXCY32gRaVib4ldeu0I
	9eoD7PQcY2sG5hvMVNtjZjs2F+9+zRs+KIBzne/tThVTWCI7hOLXNZIrO5Bk+kOaqgQnzk74zDq
	4CCMfO5tlBxprCGLoAk3nYiQlCmJL0vpgvVhCDlUheoToZJZc784QcLViwRH6SJib96NdLk5eKN
	/eo4YcpGN/i0yvgfaBga1hiwjoM0FL3YGj8H+0irTHkY0RBdd5c7xWgzaS8V/IpjJ7iXCpoQner
	5lulDU=
X-Received: by 2002:a05:6122:678b:b0:5c3:cbde:1bcf with SMTP id 71dfb90a1353d-5c3fe48e12dmr170712e0c.9.1786035596101;
        Thu, 06 Aug 2026 09:59:56 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:55 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 14/21] ocfs2: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:37 -0400
Message-ID: <05cd3c34f2dc69b542db7baaef058cd75005d4cb.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_write_block() and ocfs2_write_super_or_backup() detect a failed write
by looking at BH_Uptodate afterwards.  That relies on the write completion
handler clearing BH_Uptodate on error, which this series removes: a buffer
whose write failed still holds the data the filesystem asked to be written,
so declaring it not up to date is wrong and makes callers re-read it.

Test BH_Write_EIO instead.  Note that ocfs2_write_block()'s test is the
positive one, so the sense has to be inverted rather than the flag simply
swapped.

The comment in ocfs2_write_block()'s error arm needs updating for the same
reason.  It said the clustered uptodate information did not have to be
removed because the buffer was not marked locally uptodate; after this
series it is, so the reason no longer holds.  Not advertising the block to
the cluster is still the right thing to do - the data is in memory but not
on disk - so only the justification changes, not the behaviour.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/buffer_head_io.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 7bfe377af2df..733ceda79ca1 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -66,12 +66,14 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 
 	wait_on_buffer(bh);
 
-	if (buffer_uptodate(bh)) {
+	if (!buffer_write_io_error(bh)) {
 		ocfs2_set_buffer_uptodate(ci, bh);
 	} else {
-		/* We don't need to remove the clustered uptodate
-		 * information for this bh as it's not marked locally
-		 * uptodate. */
+		/*
+		 * The buffer still holds what we tried to write, but it did
+		 * not reach the disk, so don't advertise it to the cluster
+		 * as up to date.
+		 */
 		ret = -EIO;
 		mlog_errno(ret);
 	}
@@ -446,7 +448,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 
 	wait_on_buffer(bh);
 
-	if (!buffer_uptodate(bh)) {
+	if (buffer_write_io_error(bh)) {
 		ret = -EIO;
 		mlog_errno(ret);
 	}
-- 
2.43.0

