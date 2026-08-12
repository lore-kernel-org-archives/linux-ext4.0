Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C136F2BB13
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 04:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786509962; cv=none; b=U2b825Iyy+WRYPp5xLLsJEtGafJIuw69a8uv20R3U9eDMzkFz1wAHwuHYX6z1YDDQom7klo/Sk5FxLCcAn69XZES8D+VioGCkXHAC+Kzov0BkP/TN1Mqrm6Ln6hjyMxqPLEFZi0RauDacB3fSPe6tmLd6rzEhdihoOD4BpMJFQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786509962; c=relaxed/simple;
	bh=ycr7ZyRPlY5GqzTELDN45sJLOhk02Aoy+ZJeVITGcdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=siM0t0tTD+gtUzXbv6G6Ce0qEJkrAhKBMzJYwmHRZL2iNeskSeJCUUjm8zCcnI9o4cnHe0mr7PCypAexFD4Fql00dK2/klTtKoe6Gzrev8jslcZAGx5sYhAor8GKEs0YriAaSLwikQ7UNXFzn2Qj4KaCPtzx+TH6Z0hY5lNQKUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4AZkd32; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4AZkd32"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso837359a91.2
        for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 21:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786509960; x=1787114760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v7shIJWKb/OHSa0XUd1+ZefwQCvgu/6ANZMc16A8ONM=;
        b=X4AZkd32so9ZcUau/05y1CHGhm8Y/w6iMZghp2v2EfivLwe1PCYC7LA/Sdl+e15Xra
         45f4f/iVahzLg9mSnVUzpB7oAK+cP/5l7g2UZ0SkvFMPXl/fq/puW1BxMy0aw2s1eMnc
         RxrGHREJqrtPSHqYzg4ca4IwdVGG4P0LCzIolRPzrAsQla0R72oTzSdCsaDaeHyJDBYs
         4ZCmfy3cdvOeOQl7cwN2psZrOtaDg2Kx1ezGp3q+3+nTWnjM8KB36CI9LYVm0srlI/YG
         7Kwz0UtiYrKKSH6MnOSBuZjvz39344D5NpzUkdrJC37/aJM/d3qLkP6ucMW53xSLpr4w
         Tu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786509960; x=1787114760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v7shIJWKb/OHSa0XUd1+ZefwQCvgu/6ANZMc16A8ONM=;
        b=tMKXaNhO42uy+5zrpo240NJl28IsstTdRpX/hfLiN8HaZJQNnCP8a58V+InI1E93aV
         e/JitxFYjUrsaPinc1HVhsGeUv6Eq7dd/9te9XRHfRA7sw5zO54ktY5QyALOJEC6A7hv
         m/r77dO41ZAY95npeVvw9xj9DoorW4SDNTO4Rx1nfxWnwxMMu4Ua+G5YpZ6QBT7uSfSu
         Iokl4PiVnE5CeQgnpNClqegUVuMIq3pbG+i6vg67WWCuvB3r4XCyJno62Yj43metd47o
         16GSdzv653ZPqSkmjMksJuoLkyqu7tC84xCAmIzpSfL5ATgGfef7roj/HF87qOI/lYp9
         J3ZA==
X-Gm-Message-State: AOJu0YxfZsKgHF2jatTU0LXncsg1Trl1Yw8TEpkguhQKvrmuxIU+dYVD
	FZjPBw0V5cZ9XZJDFMMPsjbf0O3DQo2UJlZlSIzW+LgZHLicZ8N6KeHOE/wPAbqk
X-Gm-Gg: AR+sD1014M/NIJjQ7LALKeWrmXZNjq3tGWojgL4DJOae9UxCIGweMdYs7mkLQtLC4yC
	L5TjOk+H7029EAeGHuq3n9gjDzw964eqr8Daltqr2OvJcdkKkZfyrHkG5tn+4jicPoKXWOiXfF6
	Ukewhf9fXamh3o36WoDb+gZo9IZVzp4Mf+HKa6+kN2m+znnRxv80bGxGN+gjvCbf/35phS5k/cJ
	lZFGN37B6XcGbS3GcXYlqGq1mmJC5KVgYQfvXCOHumV9RwyHuFQAwjhHn+l6tQGOzjl/n33O/Hd
	6DLv0SqEY0CabO3DYBPuZgOpPGtJ5NRnd8TJ+iW56pV3djX+FOgD3v4wyFu1IFuWZl3HEe87oGp
	MzkCRYtiQQiCQrwxbA5evJmj8MFpMskoufbYkuB/W200s05i3iW7MxmtihnKY5clw3WLLEoXgjZ
	4JQqj14nX1F3hHNJrsmDSu/RUkvO+aQAAoU1ON9G/XhDlY+uMeUrE6EH//2hXhYwariUCGDWFDz
	a8CGVy7alBuKSavCtSB1uJdw0PXIomDOUMK4sho0G0tUQ8Mdm1YeQ9VGBBWwaNFJcyIPKYuj3S+
	nzwWtJluhrVzjBucw5/QEfeKFjqzxEY6fRa4mSyUHo50ommGJE1fe4mPmEIcI2Y=
X-Received: by 2002:a17:90b:48ca:b0:38e:4f41:83df with SMTP id 98e67ed59e1d1-3930142adf5mr2723817a91.15.1786509959932;
        Tue, 11 Aug 2026 21:45:59 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f8893496sm2052443a91.2.2026.08.11.21.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 21:45:59 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [PATCH 1/1] ext4: drop extra ea_inode ref in cached-block reuse path
Date: Wed, 12 Aug 2026 12:45:56 +0800
Message-ID: <20260812044556.2209787-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_xattr_block_set() acquires a reference to the ea_inode via
ext4_xattr_inode_lookup_create() before constructing the new xattr
block.  In the new-block allocation path this extra reference is dropped
after ext4_xattr_inode_inc_ref_all() accounts for every entry in the
block.  But when mbcache supplies an identical existing block and that
block is reused, the cached block already carries the correct refcount
for its entries, and the extra reference is never dropped.

The cleanup block at the end of the function only calls
ext4_xattr_inode_dec_ref() when error is non-zero, so the success path
through cache reuse leaks one refcount.  Each reuse event adds another;
eventually the saturated refcount prevents the ea_inode from being freed
when its last real reference is dropped.

Add the matching drop when the entry was not written directly to the old
physical buffer (bs->bh && s->base == bs->bh->b_data).  In that case the
reference belongs to the old buffer, which the later release_block()
handles.  When s->base is a clone or a fresh allocation and is discarded
in favour of the cached block, the extra reference must be dropped.

Found by the Sashiko AI review bot while reviewing the xattr
saturation-livelock fix.

Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
---
 fs/ext4/xattr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e228..cf26932a528b9 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2107,6 +2107,26 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			mb_cache_entry_touch(ea_block_cache, ce);
 			mb_cache_entry_put(ea_block_cache, ce);
 			ce = NULL;
+			if (!(bs->bh && s->base == bs->bh->b_data) &&
+			    ea_inode) {
+				/*
+				 * The reused cached block already holds a
+				 * reference to the ea_inode.  Drop the extra
+				 * reference from
+				 * ext4_xattr_inode_lookup_create() unless the
+				 * entry was written directly to the old
+				 * physical buffer, in which case the reference
+				 * belongs to that buffer.
+				 */
+				error = ext4_xattr_inode_dec_ref(handle,
+								 ea_inode);
+				if (error)
+					ext4_warning_inode(ea_inode,
+							   "dec ref error=%d",
+							   error);
+				iput(ea_inode);
+				ea_inode = NULL;
+			}
 		} else if (bs->bh && s->base == bs->bh->b_data) {
 			/* We were modifying this block in-place. */
 			ea_bdebug(bs->bh, "keeping this block");
-- 
2.55.0

