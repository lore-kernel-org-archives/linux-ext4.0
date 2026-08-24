Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073A23F660B
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787564739; cv=none; b=G3l9c60aLkfV2s3H6h1TskmXH0pQv0BkIuOOBv6zt2R6rwqI8TZXRSawuiNXJZ4MXZiNiK6mZQXOStqbOApnNjC2Cu/K6aa8JN16jwuzTIck1E+fVqvY6Hq8cOre/vb9b1sze2N4XqelaQqJ754DZpZ6a0I4sNkrBwQpAXA5Oa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787564739; c=relaxed/simple;
	bh=KjZeTtGd/vUyWsmXWDnWQxybFZuWFNGL+aBkUps34UA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lDVYRKc4Jbo1sodv5AhTdBsNEYLGsMDU95r62z3LKWJ2/6C/SZEz+a0LkjhaxJsFTe1h+2yzuxD2NEonRgbV9oDOyjwpziaMPG95M11BeBiDzJemGvBfYK4rmn89W7qv8W0m1zdWYfCaliUkBB9SQF8TLUsXHsYEaGB54Hloo0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOIKTMhu; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOIKTMhu"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ce98cb8165so31749785ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 02:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787564734; x=1788169534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FtkIhL1WBjtKilHpUZK8ryJa/U1seBmHeDPqnq1dXCo=;
        b=pOIKTMhui+mTpXdw7bsdDDn0PcdR/VREduRETosgISPMW96p5/TnikznnwrhwT3aII
         3NGziIykisM79k0FOfGBZ4Xd/14rzy07//HyhNKErv6QvQo5KElxdihFt1mhfI60NpwZ
         XH9oHLx7ieNGZhLMBNRb5B4aUrgAawNbPvUmX4onfe6lmMDQwTC0AB4QUcXLxwD1o9uz
         yJk8V0IHVP1f4mpE4Kto/oGVWz8LlhBzdf6tVJPsvrceBiAn564a0QBD++tq1vXVZHTU
         f5XXr9hxF0Ij5c6Fjxw/Om46siTEUjV6DZUIy8/9thsdYBcONYv516a5edxSucioV+I2
         ox+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787564734; x=1788169534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FtkIhL1WBjtKilHpUZK8ryJa/U1seBmHeDPqnq1dXCo=;
        b=nCuSenMiXJn8uSwxt175Yy0shHKj2r3ICvu7Q4i0y3P8ugbd0irNwDZU4IkPulCr4H
         xOBDvDbYBk66aSSCZjbW0yUT+46ItmjvKKmNKV+9QI505SG+R8RzEot7+iWOZMhg4h8f
         S8qakbPQm/E7iFg4PBX7HrNN+U/Llz2ZlfK1qry2582B3v3likRFsPLU96Ts36Y8MKlz
         Ybc62HQJcfwMLXWouHv9fZzQmd05Nb3ak11vYyTQrsqL/WmEDfDpQao9W7NVL7FF9dw9
         ws2Zz5Ep0EMk/lX44lMcDS6O+DL0lv1mI9iaZ6nkMzIL+Z5RdZwMQuhFqFgv38aS4LHL
         VQ8A==
X-Forwarded-Encrypted: i=1; AHgh+RoHbp+oB2eZut6jvCDYeoe8Qw6AEBV+Guq4X10wwQ9tdoA/t6ejAVpsnn+S1rV6Oxpkvas+3HolKAZc@vger.kernel.org
X-Gm-Message-State: AFuF++mccuiPXPoLDcQzcOiolv8G7asTd5r3RWMBDMuPYvcr6WioETVa
	XJd8s/h0vfzZsHWPzY8TVGFaNCwhJTtzC29vJ+dfG/Oo8oInky2rYBTa
X-Gm-Gg: AR+sD11ZJ6cX5wbtLRtGD7qc5AkSwGXcml8CB/6ShZ7mySDDN2mwt4OMAR9gLGcqfiA
	b6/VueR9lT/KCUnEEtQLknYJTfiFjhxqnMactyleNWcaHMMiRbv9bS8HP/5YJ5UET4x89YL/uaV
	//CyHgYFPN8Yds1vS/z/NMTptxz4VNrb+mKB1roShESKkag7Kk7rjR/IA19G//pHaYpS2SdYfUZ
	4OC41gu0xI0/sJwlIW/IE8mShcwoKIUmzAEq6mrQS9E6EYRAohapKE3iH/bivaL160QvyUM6C+T
	e2UMj7lv9Xnpc/eT4EFaQS/QoPohYOubz7LeBrhJx7wZG/BtUecFMU8cREmUmMkm1BnoTfYXXh9
	ETs4TCznOPh6E3IkQ8+GbouafXCIieRylMq68pHiOgDGg4ZpvG/uwaEtjf1vFujX24tFDZyLvd8
	2+kHyxPGVn5/n1YKjra1rE0jNMBx1aBU5ojMDYkSc/knWtr7lob8aVyaSobOozaquRPuZ+rsnLs
	qhmWzTvYH0=
X-Received: by 2002:a17:902:f688:b0:2cf:6e5d:23e9 with SMTP id d9443c01a7336-2d61a1aabd6mr356086455ad.14.1787564734175;
        Mon, 24 Aug 2026 02:45:34 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f920e0ddsm23113290eec.24.2026.08.24.02.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 02:45:33 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	jack@suse.cz,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	jun.nie@linaro.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com
Subject: [PATCH] ext4: skip extra isize expansion while unmounting
Date: Mon, 24 Aug 2026 15:15:12 +0530
Message-ID: <20260824094512.2436628-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reports a WARN from ext4_xattr_inode_create() reached through the
unmount path:

  EXT4-fs warning (device loop0): ext4_xattr_inode_create:1485: refuse to
  create EA inode when umounting
  WARNING: fs/ext4/xattr.c:1486 at ext4_xattr_inode_lookup_create
   ext4_xattr_block_set
   ext4_expand_extra_isize_ea
   __ext4_expand_extra_isize
   __ext4_mark_inode_dirty
   ext4_dirty_inode
   __mark_inode_dirty
   sync_lazytime
   iput
   dentry_kill
   shrink_dentry_list
   shrink_dcache_for_umount
   generic_shutdown_super
   kill_block_super
   ext4_kill_sb

shrink_dcache_for_umount() clears s_root before generic_shutdown_super()
clears SB_ACTIVE, so during the dcache shrink the last iput() of a
lazytime inode still redirties it and reaches the isize expansion.  The
expansion can move xattrs out to a block, and creating the EA inode for
them needs s_root, which ext4_xattr_inode_create() refuses without.

ext4_try_to_expand_extra_isize() already declines to expand when the
superblock is not active, but that test does not cover this window.
Decline while s_root is gone as well.  The expansion is best effort and
__ext4_mark_inode_dirty() ignores its return value, so nothing else
changes; the inode can be expanded on a later mount.

Running the syzbot reproducer for 60 seconds produced 3583 splats before
this change and none after it, with the same number of mount cycles.

Reported-by: syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b03894b6ec5753ddf24
Fixes: f31173c19901 ("ext4: refuse to create ea block when umounted")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/ext4/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bd4b778df9eb..6e523a5c8230 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6598,8 +6598,14 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
 	 * s_writepages_rwsem, causing a deadlock with the caller's active
 	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
+	 *
+	 * Skip it while unmounting as well.  shrink_dcache_for_umount()
+	 * clears s_root before generic_shutdown_super() clears SB_ACTIVE, and
+	 * the last iput() of a lazytime inode in that window redirties it and
+	 * lands here.  Moving xattrs out to a block then needs a new EA inode,
+	 * which ext4_xattr_inode_create() refuses without s_root.
 	 */
-	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
+	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE) || !inode->i_sb->s_root))
 		return -EBUSY;
 
 	/*
-- 
2.43.7

