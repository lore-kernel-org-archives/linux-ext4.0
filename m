Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C814854E2
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353440; cv=none; b=qU6aLIGOjaLfq7pK31yoldDR6eNGrQ7hyHLcBPjOYjs5IQnlX90aPiatnZApsqc4gXOEs6ban2AmsABVhuGpESsmn5u4dQwRAeXtcNOwalhMxMzuIlSvP2uhXTNsOk9e9v9f4BwgbbKb2rCgZnxpJQxFMmQS/TR7fYE+QihryUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353440; c=relaxed/simple;
	bh=2UyWaEZMu+4JOZjsadUpJV4QsMl/vanPQVWy4b/+7s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzExdt9KyWpFEyJHd3AXK+hHKIeTez1zC71lbJXd8LNAY8atoVVlVOjIgeLSIAT5FVQ9x02/MopbNv3v61ZCity+ufAKyg+R7UTlpTJ0QT8/Xqjel0po4kRL2pSSTJpY49z0VGwi8r1gAkdDFw/zyuadzhRwgyFPyVvOgbqoyNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z6i4SquM; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z6i4SquM"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8423f236418so1125488b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353432; x=1785958232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9VX4eRtECNtngpeRNy7/vdvjlvGkPSiIhLvkw8E1S3w=;
        b=Z6i4SquMFm986SyNARlcEeZBVh3i5xEAI3wjci9K365s/1qwpY8RLCBELN0GWsFN9j
         RMjN06PZWmMRKD073AxkJKZDWPWCSi3AOF90D9q6kIUtQeRbYefXP1hokf8+KfF/Yncg
         x3QLGS2NXD9y8/7rumWPkShFvBHFjA/OzJS4KfddL0yb6R4rOZAb0ZgH561w+otJ9cd7
         KQN/QOQa0rGsb/FtORC+vT3Xd6Af/CA/cF8AonFEev/9nihA2FRJ2UoRH6Qf6hzqu2fg
         sC8NhTCHwU5sAvaAqnv7I1omSlRchrvJDDGpNnO34mbWGPVlVewVRpY2nBDnwFXL6LnR
         Zr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353432; x=1785958232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9VX4eRtECNtngpeRNy7/vdvjlvGkPSiIhLvkw8E1S3w=;
        b=kmexP22oFoc7UX27XkIJo4Zt8daphDQ1rle9XUIsXpmXI7Iympc2EPmIBr6djArqAj
         0b5fNDIGk1xnud1spXO5YannnG6NRVk/Z4t7Vf9Fc6AlMJYNxrafeJnLn/OiRe6TbD82
         N4oQCbQx+NZLnuChpqGYPPO/slqT/M27yJU2DQq3A6Bc/wnJoEInGOb//9J3CIPH07/w
         OHWSieNJHMFWtemeEYJXFNjODjuwr7qZguMe/4wA7HXOJhaPLGs6w1gjsVCHuuOxs44g
         yAdFdqh1dwOVwzvNyTTGK1WkLQQF7uH9ipLj3vZRehVvosqqY/J1cv69B1RMfVvOsOGm
         0Hkg==
X-Forwarded-Encrypted: i=1; AHgh+RpeoEgNfzXrVSCTtL9wuxNKvV2KWXEQZoISypqn9KuJo1bi/n3gCopJ1ZDYNXEZPDN/Fvo3M7kCXXib@vger.kernel.org
X-Gm-Message-State: AOJu0YyHRM+v0ydbpY07f/jYaTisYo8GtfA05Xg6nbaT/4AOSCof0ydb
	PRa39MIWkPuYHxEc5DOAU/2Yet/yQe3aPwE6eexj0Qig/eKBpeP3I/sN
X-Gm-Gg: AR+sD13QA3K8XsEyVEEni7RGt8RbaUFMxBxKBIRliCtnJ8A9m2/Fs65lk/hBo0FTa48
	Slj/mdM+yil6i2Sv/AflqRrR76H3GwzLPSmNHJy3hMcDrcoIhW/QLTNjry7vjdhHg3xaE4WBWaG
	8CaklBg15FLqKyV+wVwHyg73LqYCxNSQwqASlevHxRheYoVWbbxUSp2iwNao5bOAGnaapjwYCvV
	Fy2GRANo3WzsDfAuo454VrqHJ2e5A2FhUGilD0dMS2QVL/ECARTBXP6PjSzWMkDc8fMSIKpI3Br
	AIdrZ7Kxovowwo1YxGEdovrzjw2uWHnurytUpGWXEx/QsHPhpfmZuiqi/ypHoe/j7dBQx7NagKQ
	O082wdCJtZ4bBugUXnlQ8xiM4/iMu+qw6J4iIW+VTUqJ76T7Ym4tqEMx7Qk78l0anTCAOMQmy0B
	08M0NeURDco2ymWX1FgNmsRBuwljTvCi3vNLiPmeKQAJdXaMAEiWzLSW5AribLmxezErhf7gohy
	CoQrlC8pH2k+XjPD4NK8XFj9wNgf7o1kI8jYQ9Nqq7Udtl5xx8=
X-Received: by 2002:a05:6a00:ad5:b0:845:c694:5c3d with SMTP id d2e1a72fcca58-84eb9ee401dmr81840b3a.1.1785353431955;
        Wed, 29 Jul 2026 12:30:31 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe1d07dsm1855035b3a.8.2026.07.29.12.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:31 -0700 (PDT)
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
Subject: [PATCH v5 18/22] fuse: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:33 -0700
Message-ID: <20260729192737.3190206-19-joannelkoong@gmail.com>
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

Convert fuse iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
macros, which wrap the iomap_iter_next() helper to finish the previous
mapping if needed and produce the next one. No functional changes are
intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dax.c       | 6 ++++--
 fs/fuse/file.c      | 4 +++-
 fs/fuse/virtio_fs.c | 3 +--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 8b53625ac7ab..85cdf0199bc0 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -653,9 +653,11 @@ static int fuse_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(fuse_iomap_next, fuse_iomap_begin,
+				  fuse_iomap_end);
+
 static const struct iomap_ops fuse_iomap_ops = {
-	.iomap_begin = fuse_iomap_begin,
-	.iomap_end = fuse_iomap_end,
+	.iomap_next = fuse_iomap_next,
 };
 
 static void fuse_wait_dax_page(struct inode *inode)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ea4a15a7635a..1c346802f877 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -890,8 +890,10 @@ static int fuse_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(fuse_iomap_next, fuse_iomap_begin);
+
 static const struct iomap_ops fuse_iomap_ops = {
-	.iomap_begin	= fuse_iomap_begin,
+	.iomap_next	= fuse_iomap_next,
 };
 
 struct fuse_fill_read_data {
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index df25d4faca41..f15e516ebcb5 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1024,8 +1024,7 @@ static void virtio_fs_cleanup_vqs(struct virtio_device *vdev)
 }
 
 /* Map a window offset to a page frame number.  The window offset will have
- * been produced by .iomap_begin(), which maps a file offset to a window
- * offset.
+ * been produced by .iomap_next(), which maps a file offset to a window offset.
  */
 static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 				    long nr_pages, enum dax_access_mode mode,
-- 
2.52.0

