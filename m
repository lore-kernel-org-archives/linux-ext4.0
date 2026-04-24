Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DA62F069D
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777046126; cv=none; b=rICEF377mtimoJA+WRV+VLBSTMCVUoe06tY+Um0shS+qcmkWkGl6mivZG3SPnXzCByqVs/m7N7z0Jz0vfaKVGEnlC7gn6msDjtdMxoekLKsXKi802I5+SlAVlgQxGYn/FRWBoA/HfpaV9HDS9HBVM1mNwe6DzqN+AF64CCGXB/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777046126; c=relaxed/simple;
	bh=O+NwYZPZmuaZ8yiQJeSyI2dWI3z7BpsQ3W3NvgGRxsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=onMtA+2ESETYal5K0TFTLyxlt7kXo/Ex299Mhn3ioS4wHoKrAONRUIF9yrTqnaOqKCCSoNOzaZ/DTskoeteQ3yp8Q+JcBq9CSRQtmtc49kESGnqSdGiUlsKmA/8arPf04WzYYtgJ3RBPOfU89pNItsMyb3NujbVwp54BEVlNUZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=syIF3n4m; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="syIF3n4m"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43cf7683a28so5468626f8f.2
        for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 08:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777046123; x=1777650923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EHfaM41/Ticte7TagLJMtblky2w2uHhJquIVzUhFxa4=;
        b=syIF3n4mDC/hth3SQhVLitOyhStoKDwwfPe5kN8rad6LIUO5bUHRoWbmX1t9J2egKB
         ZlxiEpcsU/o6MLoQfTxANw0zSDSwdh1ohf9UY7cvNxgZtWBM5z1+uWjdL8imkwKGNUS5
         qfD4mFGnx7e30iHXVbVrTJEj1bwQ/b5YQt+G7OGnLwwoFSirOETTgHK9ckgKh02OPpmJ
         yelxiF6wkcNj9RaSpqFPZlPrvf79bvYcEZuccXpnc30qoKTulRkfPK1CMES959g2ndUW
         2tDvzQL2pUNpzij3iB303GCKbaLUjmQyv40ObFMUHfctXT1HuCYL5kX5/G4W9SIKoiTA
         5Wuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777046123; x=1777650923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHfaM41/Ticte7TagLJMtblky2w2uHhJquIVzUhFxa4=;
        b=NWhN1N7JGwcCr9FkH91UbwI7bNh/WNt0t+X9JY9Nibvu4xxxkY/rys1P6WfzmkIOdc
         C67gpy2un5MIWsUAx1B/HLZNV5rGnDGL6wbxv9SXyXW2uQfIntJFRzLEslHEBWuRzhwX
         2HE9VsjeXqtuRk0JOfnhkaRTDh07xWUyfZoB8B7gqzY6DxeJWCNY88F0DU/IUeaSCuXV
         44RI5p90Py9dLSWiHGCFRdaXJ2+STjCA3UZ0iKCv6pMvGqfdrlOnyTMPaPx7rGJtVAEu
         gT+RaFdZRpFgjbTacFBlDz/W6qYWg5GUZ3g+vIpPvj9LBCoDNjo4HM1FiadYVMmZgP3Z
         cofw==
X-Gm-Message-State: AOJu0YzwE7dpci14NS51Wyt74jm/837dnolshM6hYpQvub6+Vc686h93
	QZuqE85oOyh2ngdn18M0+7ytqTWoDXloCJIA5OAeEh6xRP+0f9HJ9MJkWG6ETGs7
X-Gm-Gg: AeBDievoBVbv5ox09jxdFJ1ny8tbopc261nwwP/LKx2/UXeBSXLIS2xsl+KhiyvSMcT
	SCpJ9DSunuxWhr4mbIHT29z8xXyH07LZYgoIuuGdtegEAXghv22GhvM1ESQ7b9EUTyEX48qEuHw
	cEJUNsl3NBMAB8e/SPpTYLCZ26g8srRv4FHTOwwgm8AhVANTkzOe6xlmh5/TyvGbsN5SM5N0wO9
	3yU0ZQpbknTjEj2NDFn45fyRp1OpWv9WhLR2BzGXExGtyzQRewoITbwENKxm0O8QxBm8C5AWlTf
	VtprBoS0nX3Loeby1kYoeG2QrfkNwDb7Kb2xo9Am8w3bqW4x0xM7GM2UFbKcTUwqNkzmDkon4Pj
	xjsm/9sFAFZnbrN4d08O2wYSLf+H4dBzTAFSYuUcmwLOhJFf8wxjgCiaYcPxN9ExRb0woKLjh/Y
	y/cHaOjGbh525UQ5yI3mthodIvQg==
X-Received: by 2002:a05:6000:2888:b0:43d:7b90:fa21 with SMTP id ffacd0b85a97d-43fe3dcaefamr52255092f8f.12.1777046123044;
        Fri, 24 Apr 2026 08:55:23 -0700 (PDT)
Received: from kali ([41.142.67.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1365sm65244521f8f.7.2026.04.24.08.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 08:55:22 -0700 (PDT)
From: Abdellah Ouhbi <abdououhbi1@gmail.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Abdellah Ouhbi <abdououhbi1@gmail.com>
Subject: [PATCH] ext4: Use %pe to print PTR_ERR() in super.c
Date: Fri, 24 Apr 2026 16:55:08 +0100
Message-ID: <20260424155508.186235-1-abdououhbi1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix coccicheck warning
./super.c:5981:32-39: WARNING: Consider using %pe to print PTR_ERR()

Replace %ld with %pe and PTR_ERR(bdev_file) with bdev_file pointer.
The %pe specifier automatically converts error pointers to
human-readable error names instead of raw error codes.

Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..4b69e0879731 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5977,8 +5977,8 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 		sb, &fs_holder_ops);
 	if (IS_ERR(bdev_file)) {
 		ext4_msg(sb, KERN_ERR,
-			 "failed to open journal device unknown-block(%u,%u) %ld",
-			 MAJOR(j_dev), MINOR(j_dev), PTR_ERR(bdev_file));
+			 "failed to open journal device unknown-block(%u,%u) %pe",
+			 MAJOR(j_dev), MINOR(j_dev), bdev_file);
 		return bdev_file;
 	}
 
-- 
2.51.0

