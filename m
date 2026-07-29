Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14744854FD
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353436; cv=none; b=PW6xdliaozrnVkEVFp/+yDLgDi2KnCuY3sdgZn7UW9DucnqIt4kVYwps1POWHGhW8iEVOiJClwR2Gn1pfoqfwHfsJ3b+uaMicrePS9FNgiwAVRhFWTVoRZrejNlu10AB1ejHf2Epu1C+OFDG80Y0XC4SmUww7L6irlmwCBVaUnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353436; c=relaxed/simple;
	bh=HHxOrJYOsxXujbtNOZYiKxqT98cJWgSli6XX9Kw9VZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEti4r72nmWud1w8dEGMeISHfDNo6DcF5oTCa8LViBz7wIJaEnYG+WO2GLq12sCg/qu8gbgByaRQgpBD4OGlcTZjxMSIF7daPqeLdCxb4IxaqRxnfWR5T4Alz4KzgMfNcD1FmarI3zXPPlyBwW4Zwri2rAnkruMSttdlr9wKB+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S0fdQQKh; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S0fdQQKh"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so1364699a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353428; x=1785958228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t0Y5kYgnq47GiPzAl5xZ9gQOM4CGwKa3ZKYndZjd3EM=;
        b=S0fdQQKhubEJVvtcP6mSjEz2uh7/SlOOBBMzv+9LFfzzs3rK0XYemHPoSjM+ijVCt7
         WlgeYotHsvR9kqAuJ00qCPDTYeHQ1IHxuX1A2CJxRp+NcwmZx3NayL9c2LY5b2CDp6Nu
         GKZNPH+l3w4gl0wG52+LP7opcMvgh4yKDoNCz/G62ViK0lZCiCyZcpVdtDqYadpP5S/v
         D7GrFYZhbXkUuSrBdKpiXVjQgRKYgO8eBQBelikL58EbNUu6mQTCccApExkwT+ZAcki6
         J8s0NeyqRpzdbsqmMfWJT2Gs5LmNRn4hHG9U5N5VuOe8Sgx+viBZdnNcaEMOCmHsgKza
         gBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353428; x=1785958228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t0Y5kYgnq47GiPzAl5xZ9gQOM4CGwKa3ZKYndZjd3EM=;
        b=JJ0766sGT1cB2hE4cmRt+quMR+k3zvW54zNz/yjUmXljdemN58mEbewjRjydUnCUbU
         9p7UQOHubXF+yb7CldbetTSCd5DAO1Uqi194y8XydlBy0ysEKRgFrA+QgVRm7eaX12Vc
         7/NZu+K82BEftgTP7+c3IcQE524l7kwfqnYrXBOGESPhM5T9h1gVaDfIblxKJREGftuV
         W94Z0bQxkmCPJnK/i5vStCPzNX5izMIp/aYwF+I6uPKe8jdJEdjXxYFLwca+MXOyxhtj
         C6D0id/OV0iu8cLuHzHWGaEOIv6MUOJ8mW6/seCjMo3MVCHUdbsSZGjc3eg+OCM1MR2c
         gABQ==
X-Forwarded-Encrypted: i=1; AHgh+RqAGy0IrmTDCqLRZaQVT58W39wFoW9WVjD7LxldWERnrhJ4wPJYpF596p6gvvXacJmxdhImS5UvkAKp@vger.kernel.org
X-Gm-Message-State: AOJu0YyW8vSmc+CzTsCZV+rSXUNEEN/2G4vQGBxTyRyPWkVQgqlJBvrJ
	INGLxCYgt3FIb1q0w1UfmAEuFomuxobUN9A8IQam1fL22wGXd8b6cv4f
X-Gm-Gg: AR+sD11zdfAk7FXkztsJ07qcw0BhJzgPxUdxKaIaBxQ8LcyVDpacfpYCriffLmaGe6t
	XDA5r4M0TpBCqME34kCnOB4bi71bd+9O579mxj/4sEwaVSWn7ygi4VDnW+Kir6Of0oUS2U7mH/y
	S5S9ZMQzx2Jq0jzDvE8bWfpt1K+Sc/OpzRBedFuWKHAhvKnCfUDZq9Sx7K7VdspD9Hzs8PPMLg0
	9wO/mLMrG9pOquikis4A1RbeUXgQ+GagvZOnAF/YgVEoMX3bh6APbmj5UtpYgGb6nfQ+mFpgvTa
	rLkg4HBT8fSdRfKDR2BC+zoNkUI6GD5gC+tsyRutAvWgyO7DN3HxwkAjPjvTKYqDFgR9scJw+tG
	x9B10QQM5djksBYwDUov4uX2bDTxaA5FUYAI5dYbzYGeNEaFHV6UTTYrKVcfnSgotUF2KOif9T+
	gcdVPTQ7Cxa09YU/GUddqTBqNdehp+cr0vPgYrC9hqE23M/Y1xoSMcCNSSV71Ej7TBcEzyl4oyu
	rsRxakkaB8zziBkBKn/3bvwXsSUOqyHeuaKPSxFJl4TgzMSnMQ=
X-Received: by 2002:a17:90b:3d84:b0:38e:1497:af5b with SMTP id 98e67ed59e1d1-38f98eff6fbmr167757a91.1.1785353427774;
        Wed, 29 Jul 2026 12:30:27 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f1353fdsm1829513a91.8.2026.07.29.12.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:27 -0700 (PDT)
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
Subject: [PATCH v5 16/22] gfs2: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:31 -0700
Message-ID: <20260729192737.3190206-17-joannelkoong@gmail.com>
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

Convert gfs2 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/gfs2/bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 51ac1fd44f78..73c626971163 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1200,9 +1200,11 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(gfs2_iomap_next, gfs2_iomap_begin,
+				  gfs2_iomap_end);
+
 const struct iomap_ops gfs2_iomap_ops = {
-	.iomap_begin = gfs2_iomap_begin,
-	.iomap_end = gfs2_iomap_end,
+	.iomap_next = gfs2_iomap_next,
 };
 
 /**
-- 
2.52.0

