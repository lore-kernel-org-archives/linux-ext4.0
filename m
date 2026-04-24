Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAA22C3268
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777045413; cv=none; b=fT9VCHY1TSu2BeX2BXBKv9dlZwMrCPbsHcNnr/hJKP+/hg4r2bG0gbcML3GYOHF8DnfEbbJKaLTwMLOcAjxZke4FqyVyk5ucGim+eLTvadvv3T+1MLB7rqs2oNZ7IiEDyKZBBr3EDtTn4YmToXOAT2KpEw1VQOtP0dvGtSOsQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777045413; c=relaxed/simple;
	bh=YW0/RKuW7VWXIMDjTSpW6NyYty4VDl5lMgaa0I42uEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kHh3Bev8MF6/TzJqHsvdsXBfOej4AXVvYVKBBHkW8DwjapwC5lvgMbnYuAEL9juT+nSgYWaGfZTebjvEbsQ9PgmGm/fZE8NmwLY+qaLaP5BhHtCBqZiSPOq2EY3xND97zxAKsmyqyYq2jaTqJHbRhGDp9ycayoFNZqlMcD1K3Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ddh5Ot1S; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ddh5Ot1S"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so87585965e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 08:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777045410; x=1777650210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8wUdieFdZi5XDyPTiCxzwYVa2/zVVbZ+K+hznFHM+5c=;
        b=Ddh5Ot1SRY1H4weRm7ROJ51VBX+xf4O9KstVrgBVj6amdnbYvYA6FCJ6iLLZjGpZuK
         nJnLtIJx36bfMPxHuwttVgWqw7kng9T/2JhS26JuYf4WZbzjGNWXMfoK1GWD7A+0Wz5Y
         mpm1T2XoDy5ca/lzWg4tDvoVeXjVawGMFJdS2khQSfKLJnbglsF379Fkbl7Rxvc+Jx5r
         6nQ5orJ2Qz2M1NaGwKqLNEnl8JxLnYeT6SCpckZYaGZkCgAYcK/C+EI/JL9ehSD+2vlQ
         1/jEJ9uXUfTNBWR3xGyBW578hVC1GFnaAsYrcwpWYdUbCYN0BdGVVG6qoJMWNTCOySDR
         O0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777045410; x=1777650210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wUdieFdZi5XDyPTiCxzwYVa2/zVVbZ+K+hznFHM+5c=;
        b=CudofB5EAJdiuQ2ARRDDbt75KBC4pyy3tA4FNKfQQljk5BtIauSG59Vk2nSXopXawe
         +vLCbGI08hiHtjboXs7ba3ZV5ZPvcqrC6xkvOP9vKNG/POm93IuV/MsQgipV3C7+d+SM
         wWcesivHP6ocU2XegaIF7zEEgVktFtXDLzfs2t/DRhsDWPw5HiKx97EoywUyr5o4H4Ed
         4oXkn0HmelDKd5BORTUwM+keAOjDZH1M1sjm6W+4j2moIRquXDWwXLRl/hmq5/twquyJ
         1h24s7/O2S6KYO+m9o3lvbpfptwLk5p5ZAQYzGn8gutgQ/5qYis+j/UzhUeDQHZP82FO
         VaaQ==
X-Gm-Message-State: AOJu0YxVzVllUCpdQT8rwk0a0koYCsgzDXQLfEOeI8TpZaHrbKSmLCUd
	kJr2L0yxfkm6oBHLx7LvPoLkMGgaMYz5UeXnbArlrx8PozCObp+mZYFJ
X-Gm-Gg: AeBDievDAfmyDKH2R5Ghdj6fus23nmQWD1M+wm4AWKHhvHW0zg4N0GY+4ykW1GIHMWv
	Ye3EmUnKOLY0szbFlWFWGY1UyVFn8CXmVPm1JuzvqbgqpNlvlnn68Ybn/yJ4gm4L7ZEzF2iWY5e
	beiBW6OVDMb2MvlUzxpkIQxtODC6R2ySCXDjq08kP9If6rzpkcK0QjoGp0B8tI2g8SiOoOqQJNA
	iPiVEeq8pcAStYdNbELeSUwBcH3JuEcGIS/tpiiu0YEmdD7rfP7XCjLAQh1msjFt9Omfaw/iuKs
	jeywUfuCg1T3NamdR7U3ic6gtLhKQbwiwqHcalwtnK4z5yr8t/xA56Fpc8e5zEGZNaCFNHGwDDj
	18SE+2HBrlGkNzVPTzsmYi8zR5zNWJqRSy+aqkcKa/cFzNsdIIYaoHahOroTtKMi8H6r0TnHt+u
	HJC+tfptvoh/l6eeECefX0e/Uh+g==
X-Received: by 2002:a05:600c:4e4f:b0:488:d6eb:e63c with SMTP id 5b1f17b1804b1-488fb778703mr461070845e9.15.1777045409744;
        Fri, 24 Apr 2026 08:43:29 -0700 (PDT)
Received: from kali ([41.142.67.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5c4b9e8dsm55702905e9.7.2026.04.24.08.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 08:43:29 -0700 (PDT)
From: Abdellah Ouhbi <abdououhbi1@gmail.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Abdellah Ouhbi <abdououhbi1@gmail.com>
Subject: [PATCH] ext4: Use %pe to print PTR_ERR() in extents.c
Date: Fri, 24 Apr 2026 16:43:07 +0100
Message-ID: <20260424154307.169881-1-abdououhbi1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix coccicheck warning
./extents.c:3272:12-19: WARNING: Consider using %pe to print PTR_ERR()

Replace %ld with %pe and PTR_ERR(path) with path pointer.
The %pe specifier automatically converts error pointers to
human-readable error names instead of raw error codes.

Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 125f628e738a..91c97af64b31 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3268,8 +3268,8 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	 */
 	path = ext4_find_extent(inode, ee_block, NULL, flags | EXT4_EX_NOFAIL);
 	if (IS_ERR(path)) {
-		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
-				 split, PTR_ERR(path));
+		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %pe",
+				 split, path);
 		goto out_path;
 	}
 
-- 
2.51.0

