Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8403D1709
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621691; cv=none; b=GVOgTO0lL4iaj9hLhBgJ/x7+hVZiYui26UqYijEHWNKcDQ6nnzvnUdgOadzrsXw/k9nUyXs1geZPUuoHCSE3ZkZfrRvTn7SkwO20Eb9+4kPb1dUbxxRfQFWyQOfAL5bV2mTPHzSoVbFDYvBdSzppvTQuq259iuSogIxychk7+kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621691; c=relaxed/simple;
	bh=B1aGoafSodbJHnZvQa4U88gzZAbdOk4anLe8al4k4+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3C37cEMKSM9o9x/ur+S52iM4Tpva4xQ7EuWb6EGn2/fbpLarZbizx9hALD3jlTS8nxRd3zFJNx4DSsNSUAl4hDQkrYzkCvlVukzQ+rGxK5PqI7NxKSNYrIhGwg6qvjRR2Xg+prZwXF2yQxva/GJFOHER1a+RCqQ3I9HKlVWCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNVHRsXU; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNVHRsXU"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8114a4542b2so33656777b3.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621684; x=1786226484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fFKjhKiLwW7000gY04FDp9HuhYK5pnv34+ERWpP83n8=;
        b=PNVHRsXUp0XCXnD8Q+OJb7MgdABLPwXgxvpcqQWg4VuxEPmBLymrH5x1rcy08o+/9t
         ZGNL91aWrTxK+/zmIESs8niMIAbrmnsJ8IdweXdnxfTINbPcwllz9HQzaDWZUf/lpUyG
         CG76ga41gnn4KB8Fp5Qfbb4MrLbyOft7dCNVuLy/jKpiqPKmywoBG3iJSi4pn0Ndk+MW
         Z9jHubiQBK9UUscfGZ5iX9eEoUMaASP7WwczxwGJyUQdAIZ7yErDlmdI7JpkNaFHzj0r
         gqJESLFvRnPXoH3zZPAy8K9Ue2PTHvhTBwBPpHDYQpMsDszYEefsqIvEQRkDBVRFKnVs
         Imdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621684; x=1786226484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fFKjhKiLwW7000gY04FDp9HuhYK5pnv34+ERWpP83n8=;
        b=UIOjbhWEKoqT2nKtQPrg8GTGkD7hwxefu+BncqYT0oQpWgCjuf4UgYbgc+7pHKXvaR
         tjWSKbjZOnDZPRkLqfFrxZslqTiZzMnBGyvDkj5tODhJo7vE7HR21E8wgoJKuPJquf1s
         t/whLFhDyM2JJMGXX87klFytVwg8MESRKZotjHxP37fbEHcjkyKPfZDk9Hy1i6Sn9Bsc
         N97aVOhgIs9blx493ZCkmm6OxY9QJiscQ/lKS8/65n2B719tAbc2Yoeh4HU9u2zPd+hx
         i4bFcmgjhxfoq/xyEAwASCHm4cwXZxuywQcpG0+bDLp79C4/R/cBfoJewQEoBl199a8A
         I7cg==
X-Forwarded-Encrypted: i=1; AHgh+RqpYVdIRTWPST2T2arCXGaGOvBbN51AXYSsdFTQstSQdkSniSuJEjdfEJyRQpmPX4e2HaO9VBGQ5yht@vger.kernel.org
X-Gm-Message-State: AOJu0YzJNnqJ92I5uSDkstjyGwVn8oJNDSSm7ISG+/S+6Jh8sgeN8kBl
	0yMYWhTJa9IOLlbOwaawmgpehmkFuy0w5+d0QtrMwP+QpEOzbl8lGVyy
X-Gm-Gg: AR+sD10cSqX24ESmWjnX2jes7Fu2Qdsdi+Gxw1rhxtN4lBRSS4L3l+R7mwPB20DhLZ9
	M7pBbwMByzeWyY3T2F/fkGBzx2moTo/zannpkGji0kJk8nBJKjByaOSK4IU6JuFUaNX+iBpqB2l
	nWS/IM0xcVIzlWUMHJrjWfM7gaURzH488msdb7QftmCHIlcTXhPYlVYewUp3+8FJ0l62yh+rCud
	omQrWd4vDfszrHIYElEgqQh6VkpTfqneaBFkiI7dSUrY2lwbbuYm5EJoLdXdRFv/XrOU5VvSJ3e
	rqVZ0LftfN8knkq491yiyzXJdX1Qm42iZPBwodWVyYo2mdj1cCfjcaqz9kav4ANpybrMqP3k0D1
	/MjKWnz9kGB1iJKq7JRABs+G5ocmtOd9CFUJrcaeU6que7p42VsbnYc2JBo1dP2iEQbKnzGkbB8
	5UsbTfLszOdkhU/qybNvNgUutlKTUF/CwK0NCdNlhn5U2JMCEcT22liQWUYc/5DKqZfRbJY4p7Y
	snHzr0=
X-Received: by 2002:a05:690c:d8f:b0:80d:a249:4854 with SMTP id 00721157ae682-81fd4b59a06mr68933057b3.17.1785621683893;
        Sat, 01 Aug 2026 15:01:23 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:23 -0700 (PDT)
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
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 10/19] exfat: check for a directory write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:54 -0400
Message-ID: <debeabce46c73ff63152dbdb67eba64d60c45c98.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

exfat_update_bhs() waits for the writes it issued and then tests
!buffer_uptodate() to find the ones that failed.  That relies on the write
completion handler clearing BH_Uptodate on error, which this series
removes: a buffer whose write failed still holds the data the filesystem
asked to be written, so declaring it not up to date is wrong and makes
callers re-read it.

Test BH_Write_EIO, which is what the completion handler sets and what this
code actually wants to know.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/exfat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 6f11a96a4ffa..dfd0bbf31c94 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -187,7 +187,7 @@ int exfat_update_bhs(struct buffer_head **bhs, int nr_bhs, int sync)
 
 	for (i = 0; i < nr_bhs && sync; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0

