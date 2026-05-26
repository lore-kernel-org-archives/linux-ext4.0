Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E4409639;
	Tue, 26 May 2026 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808171; cv=none; b=YraF8x8rUO+GzhLqJkEXwuWXPlUzz/6BRG8G69302XEeLATL7XFJaEYaa32E+ZAPGn9OsdQnJoc1tSX+RUUG1amDx8N/C+HhmBk80cxuELlfnX1dtP1KBzpwuOaqp6KyZZHWYGx/iQGKbEFVxbkBO+aRWvCWILrh0Dw4gaQlmME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808171; c=relaxed/simple;
	bh=JVSWW4piANkvMf1y9OYS3GUlJT3hNKjzl/VyXbIt/wc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eEfhbRZ1EmtyYR2Z4P6AqOqtM0RPMAE0HnYYNVlCpNZJD/fznvfGMnfcV0YLhlnvuRovcIsfdN205UkuFf/lAmJ4I5eAH+iQ6Ja4yYy+JgcpGKpkdW89fNBXHhQzNheW+6qzDsU/oURuc05KDp7+PawtVHCA6hC63M8a2JMZWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpxa5Uy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpxa5Uy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224C01F000E9;
	Tue, 26 May 2026 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808170;
	bh=CcegIaNjhbozbWWnB9bYqhoJHNe7mOr8p75bTAgtCkk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dpxa5Uy/A7V4JvaNvBdQ7FgV9rOn7CRQnnDqLXKHyc5uiC1x2l1DHZXDwDv/WYIpJ
	 nFG8CrapLRouL6E1nTVDUNBFGjJ+IC0owKEgUOKFGCahFHC47bzfcikg6s+C27Um04
	 JWrtS4OXPKjUfSKGFp031beuUrWKAz5QzerEwWJ6YxK7Lla+z4X8PVuc+7YLHrofvv
	 HlgyMxPxmlp95GGcpi2eFn7v/9dfG8qeV32Tq9U2i62kZZ2r4DLvdCP5zHpy6QAGWk
	 DRPDwTSLA6wuR7Njn7A8BIRWxD6d+U1Zj3sF4bHYzkqSQYHPg4NI7oOWcRD0oylqXE
	 clsgAZj6lnOtA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 17:09:07 +0200
Subject: [PATCH 5/8] super: drop sb_lock from setup_bdev_super() tuple
 publication
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-work-sget-v1-5-263f7025cedd@kernel.org>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2245; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JVSWW4piANkvMf1y9OYS3GUlJT3hNKjzl/VyXbIt/wc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp+9ImuhcXBQUnGffdkj0xr+7ZOLvufdnMDbE9TFL
 SvzSPpJRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETcrBj+ypiJzDC77vp/udEl
 yQMvXa8e2Dft98Sd+4+scv//9K2TkDojw/T3x22P7DkmsVSnrezrnYunXz5V3xoc7Sb4RVR2974
 IGx4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The tuple {s_bdev_file, s_bdev, s_bdi, SB_I_STABLE_WRITES} written by
setup_bdev_super() is publication of immutable state, not list
integrity. The sb is already on @super_blocks and @fs_supers at this
point (sget_dev() -> sget_fc() put it there) but SB_BORN is unset, so
any iterator that calls super_lock() blocks on
wait_var_event(SB_BORN | SB_DYING).

The SUPER_ITER_UNLOCKED iterators (filesystems_freeze,
filesystems_thaw, do_emergency_remount) do not look at s_bdev, s_bdi
or s_iflags so they cannot observe a partial fill either.

When vfs_get_tree() later calls super_wake(sb, SB_BORN) it does

    smp_store_release(&sb->s_flags, sb->s_flags | SB_BORN)

and any reader gating on SB_BORN via super_flags() loads sb->s_flags
with smp_load_acquire(). The release/acquire pair orders the four
prior writes against the load of SB_BORN.

s_iflags is a shared field so use WRITE_ONCE() on the
read-modify-write to keep the compiler from tearing the store.
retire_super() is the only other writer of s_iflags and only runs
against an already-born sb under s_umount.

This drops one of the five sb_lock acquisitions in the mount path
with no behavioural change for any reader.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 5fe8cea9f8fe..c451f689c7b3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1576,13 +1576,16 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 		bdev_fput(bdev_file);
 		return -EBUSY;
 	}
-	spin_lock(&sb_lock);
+	/*
+	 * Publish before SB_BORN is set. super_wake(sb, SB_BORN) below uses
+	 * smp_store_release(); any iterator that observes SB_BORN via
+	 * super_flags()'s smp_load_acquire() sees these writes.
+	 */
 	sb->s_bdev_file = bdev_file;
 	sb->s_bdev = bdev;
 	sb->s_bdi = bdi_get(bdev->bd_disk->bdi);
 	if (bdev_stable_writes(bdev))
-		sb->s_iflags |= SB_I_STABLE_WRITES;
-	spin_unlock(&sb_lock);
+		WRITE_ONCE(sb->s_iflags, sb->s_iflags | SB_I_STABLE_WRITES);
 
 	snprintf(sb->s_id, sizeof(sb->s_id), "%pg", bdev);
 	shrinker_debugfs_rename(sb->s_shrink, "sb-%s:%s", sb->s_type->name,

-- 
2.47.3

