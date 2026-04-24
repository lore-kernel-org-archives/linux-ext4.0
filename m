Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E819301460
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777044196; cv=none; b=NYrzN1nEDxU8S9es6AXo58LNLPYKMY6/q5EaGqpsD6t86K5QdezcQ/KTpoSicI0v3cr1Q4SzQ4+aolsvQXc2GDIq2PUwMPe0a5eahQDfetcUoslPJsTa7GhZ+oUlrvlz3Q0q8Scfld46W+EpzF9WcyE0acGORM54ac45rK0POkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777044196; c=relaxed/simple;
	bh=87aAIT7JLiM4IKflKuaLO5AfGd6MxQHvEtXiFf1Gi0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s8oVHBkqSjV8N72Kbqh1Cp71RySqpq1MEsY9XGjMcKYyDHOg9qm+lnw9WbS8I+RJiyHs1+TNYF1WORQlVS7Ygkrym2Z/pgU39u/lhhv6EqLxatrupozESfA4z0eixlVB7RTlDgNv7Kyvi4p80xn6Sohi5gIgZVMlCXBNkWlE9no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+28firq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+28firq"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so47979795e9.1
        for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 08:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777044193; x=1777648993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tsBKJQ94VXQFSEK55ii3607B/EMG8Iu5B+b4vCeqHeM=;
        b=O+28firq7OYZ73ip70TjVTO3TpBvVXojZsLoSZiVCm/i/CeA6goOuoQV+KVHxj7+MD
         cWmigfKzlx6qOWysg97Wt76hvexKntVhilhwcQPNc+u+o3XsL0EXuXEtTaqYE5IqT/Of
         p7VqqMr1zpFTxvtjDhaFUaq7+2nQ2AAmT8y3biXLAuLhSoXw65Ao9hn8amDF9pL2uV6W
         m+AHqGrZNjg7KsRM+4PVWaJZ3dAc45aOWICJun4kGwWzQSBxE406Pq1TSJksLZS1qD/I
         p8s3k11+BSu58oGz2AxXoCjG1uzwL0WILynAKpAMXIYs1pcILhJmG25IrDlPmTuhJiHd
         p7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777044193; x=1777648993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsBKJQ94VXQFSEK55ii3607B/EMG8Iu5B+b4vCeqHeM=;
        b=DFtP3Z4qh3OXc2HE4QCAolJWR697r25tyZZg1+N1hw1pUIlkbw0fWZ2R8oEiCzwYp9
         nETuR5Kdn/g5/z/VU2zdWDfgN6jFFc9GWDvqpxJJR4Z9qV08wPfIJceQZD92ivunRCJZ
         cYW5p6FcA3I8qwOn1gb84QzaN+F8g2l1X5NMO3uyVp0sONPT8k1yYe0ZstyZa30G7Dit
         iSMdEUeDHlToARS9M3NJCAvJMcz/YXBHEW+pLItqoOTfH3kjQF+7iGq3D4bMoeudSpWH
         EYehbjrN+RwbG7OKotZ0SANxEHrGRZJhuGrKzjLn7J2EsXMlIfFeShRMnS/pDcMhy48+
         bTFw==
X-Gm-Message-State: AOJu0YzrFsbzmyxZq6Tx1k+2cuFWdYNChQJOcMjefD/9EJjKdHsVI4iM
	vek+fNd6D6Y5azJw2goi1UlxGwFd1t9romX1chmFwi2fkWLLcY5rEGQj
X-Gm-Gg: AeBDieumsPeTar5OCpT+zhaenirLpu3YXmTNhjqBOKlMR3qw6eVs344Pp+2yAH/sYZZ
	wABHIsKXaDzrec5V9fATZNfg13qPbryqfttWRXKGPjJyzAXwwOnTwJZza7FYsmQS2xonoKvjpgm
	iHq6iJEQ63ZSdHzQef/tqRFIFtKkI5+adUdMpm7X4WDx6nySwsNCpK+T60bGKgJ4gaNXJNmdqZi
	j9kumPmRqWWFX+Zvdtie7GvV8/VK7kvV525WLr939Zf9vnLv7ivzJqZimbkqznwuklhg7gSmRhF
	WYzOt5NpfI4S9dgQzg4/m9WOho59Jk3yqWUWq6f3zkriNySvhRTEFHBuUHzgn/0Be3iu7wBczwG
	x54XEBsdDGWnbuawgRr16B2rJEie8iFFX7ciuaR7f1GaooEt1jLl2rgrm0S709V7oYFbVPhXKcq
	ULhrZUmphTv5XKLXPy7OPh2W0Ktg==
X-Received: by 2002:a05:600c:8b84:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-488fb76e4aamr503935035e9.17.1777044192443;
        Fri, 24 Apr 2026 08:23:12 -0700 (PDT)
Received: from kali ([41.142.67.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-489e124f6c7sm109113735e9.29.2026.04.24.08.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 08:23:11 -0700 (PDT)
From: Abdellah Ouhbi <abdououhbi1@gmail.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Abdellah Ouhbi <abdououhbi1@gmail.com>
Subject: [PATCH] ext4: Use %pe to print PTR_ERR() in namei.c
Date: Fri, 24 Apr 2026 16:22:45 +0100
Message-ID: <20260424152245.142308-1-abdououhbi1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix coccicheck warning
./namei.c:150:25-32: WARNING: Consider using %pe to print PTR_ERR()

Replace %ld with %pe and PTR_ERR(bh) with bh pointer.
The %pe specifier automatically converts error pointers to
human-readable error names instead of raw error codes.

Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
---
 fs/ext4/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a47fbd8dd30..c0cabf172020 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -145,9 +145,9 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	if (IS_ERR(bh)) {
 		__ext4_warning(inode->i_sb, func, line,
 			       "inode #%llu: lblock %lu: comm %s: "
-			       "error %ld reading directory block",
+			       "error %pe reading directory block",
 			       inode->i_ino, (unsigned long)block,
-			       current->comm, PTR_ERR(bh));
+			       current->comm, bh);
 
 		return bh;
 	}
-- 
2.51.0

