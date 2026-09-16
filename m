Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EAB3FD12A
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 07:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542660; cv=none; b=pEO3rpcppxJBURxKakqT/kBbcHdmfv3bPvB15WF2U2Om8fG+ebSkN4UKwMmBMXQCQC+BqanZ/arpERuQYEwyw6Bakt8nY17o3fR8F37J45umYZ6O60/aejzmxEhI1Us8WpxdPzZBhwoaQ7WA+dLO7PHaVctk6bG6h4uCOzzajxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542660; c=relaxed/simple;
	bh=BOyNczjwY1481415FU16xdMtsys9Keob7mvrHoY57e0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iSvPMXxrds3GkU3rCCdHUx/eBIWC3zT5b5Cd2B9TikAAQDA8XNTMpg0oYcEE+EWZU0i8+47pWqZ7kBhTXO/sg7VTNPSUhY+qCTA5nbQ6kL/VpBsSncIX/JlrrJ1Barptf5QuBD51U+Db5yvpVPGR/mNAJ1hxZzYLJYYSETX8lp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y6Hc+yMS; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y6Hc+yMS"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cea4ae2cso544719a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 00:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789542650; x=1790147450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ErVH+2TuW07Le+Zr6PYdSFXTlmKMoWUBH05vRHa71x8=;
        b=Y6Hc+yMSfe+hsnXaEZtX4jiXUKsKTY3yCGwkyAkcnzA53slD8ry0eA0CHq5UE9u7x/
         nWuFT3UlMLJMsb6wILYQ3phuf0Fd8RIBkVojEN35xnTxQZDohlZnfMYkQ06Mr3AZYV6Y
         e7iQpmTtEsr00QGf0lTJ7TH6PgWM8qo4602UB/By9zNCvgKd6TEhXXfPcZ+TvucZa4k4
         knXWyROeb3YRoHH8T1TeFUgz2lPQfFz6/8gia35EPprpEcY9/6QIxBFVHW5C4AobRDm+
         v1qprVXmmsTqPoYRLtz6J3cGiQHqtFGZy4Qn6W2q38WQQ/53+WYIP6PmoYKxNEwD1Cb2
         dfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789542650; x=1790147450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ErVH+2TuW07Le+Zr6PYdSFXTlmKMoWUBH05vRHa71x8=;
        b=j5XU2VUchI9f5asxOoMSbJaRTho1lnVXlY/DxJJiR/foyRoDRwGiXNSHoOijAiBeL8
         +swlNY4PFHIZKGPDGSTZbbERhkhuhILpNnqkBcGX0c3ZF/Ck3+Z3Z7eBqhWZqz4jJOf1
         SzRtcQ2003qH5yaJRMAlvU00gaAOQ85FCeNcCyipOwmm6K5kumMoi9eLmG4z21Owb9B5
         Eo7K68QuMRoeEJwlFOPMcpS8HQ8TQ6JrMWyBqHcSiUgJarnwOOuS7kZnmK0VkM2JLI03
         GskDeud39A0jyybWZILDSnmfmSJuJD5CeG6jQT8oyU8AOV9LymEQs3ich3fOxnH02Z0A
         xq7A==
X-Gm-Message-State: AFuF++kR0Q9+EXBCQ/oj+wq+KOW7/8+MuMAxhG4hziMTAuHhtVBDqY33
	YC70eU9Hf5Swu9Eo5JSaXM/lFmHoukPDDhxNRGrxM4ujOpFFfGiNC4JXpFvc78gZyTE=
X-Gm-Gg: AYBFou3rp7ISZV+yRTi0Dhtzovu+gl0BEME4C5VscVriH5/4f02hX7tHvCkoiHeBM23
	7E1pkG+zl4iNkz0pdwAFcG7sm5Eb9wlJxO5unqcprioFPeGkGMrzwMFuxoEm2cOFMcO6ZDvH7SS
	Ovy0rgx1q6uH5rAuPnA/3mCCT1ylMB41zBDl+3nJq9mswtZGnZZ5m5Prb2JuaaXp0LOOinQy72R
	/4311flJ7QUWok//v6qtY5L9DPmYsAzKGrYMCg9Ngq50NgJfKs9l2rU5WVk+d6ZdzkrwZrcjx1l
	/gnGrnuww/BFEJip3BAW4mMAf+h5frWlud7qD3PdH2c7iH7V7HUqAzjfBP+siZxVEMJOgYZFfxG
	zBXI3CCkL3T8Q1kaamBKEzRt5Vh/m10Knr7cALU+HFHu5P5BaWd8CSxazpJ+Fy6jlb3OgTru8vu
	MNdHjQzrpZYFDmvZO05GPngIzDIt632dYGZUpt/c68694kWm5iGkr453YmevIYjcqzGiatQ/pzy
	58RRUr1iJqOfqLl+ud5JGeopqnApxoB0VnmHLDKaYGubTeI3WTjY4kbEyDoVkdtqccANmLt8glH
	peMib2+lcjRK/T9mQK7rn1h948VnYYtHLTUEPzobS4hLt66xywggaUBPWJGzJRNSVdIPZpPddw=
	=
X-Received: by 2002:a17:90b:384c:b0:39d:84af:a0b3 with SMTP id 98e67ed59e1d1-39e1e48a02bmr3331357a91.18.1789542649681;
        Wed, 16 Sep 2026 00:10:49 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5a9fd38sm5223230eec.13.2026.09.16.00.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 00:10:49 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	tytso@mit.edu,
	Matthias Goergens <matthias.goergens@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] ext4: drop extra ea_inode ref in cached-block reuse path
Date: Wed, 16 Sep 2026 15:10:46 +0800
Message-ID: <20260916071046.2182813-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_xattr_block_set() takes a reference on the ea_inode via
ext4_xattr_inode_lookup_create() before it builds the new xattr block.
The new-block path drops that reference once
ext4_xattr_inode_inc_ref_all() has counted every entry in the block.
When a separately built block is discarded in favour of an identical
cached block, the cached block already counts its entries and the
lookup reference is left unbalanced.

Each affected reuse leaks one on-disk reference, and the ea_inode and
its data blocks stay allocated after the last xattr referring to them
is gone.  Setting the same xattr on two files is enough when the value
needs an EA inode and the entry does not fit in the inode body: the
second set reuses the first file's block and leaves the ea_inode at
refcount 2, and removing the xattr from both files leaves it at 1.

Drop the reference when the entry was not written into the old block in
place.  new_bh != bs->bh is not the right test: the in-place path can
reach 'inserted' and match a different cached block, and there the
reference belongs to the old block and ext4_xattr_release_block() drops
it, so dropping it here too would under-count.  Conversely, new_bh ==
bs->bh with a cloned s->base (re-setting an unchanged external value on
a shared block) leaks the reference as well, so the check follows both
branches.

If the decrement fails the filesystem is already broken: report the
error and return it without rolling back, putting and clearing ea_inode
first so that cleanup does not retry the decrement.  The reused block
keeps its incremented refcount and its block quota charge; e2fsck
corrects the refcount.

Found by the Sashiko AI review bot while reviewing commit 54b6bd40898d
("ext4: stop retrying saturated xattr cache entries"):
https://sashiko.dev/#/patchset/20260802065941.1726052-1-matthias.goergens@gmail.com?part=1

Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
v3:
- Error path per Jan: report with ext4_error_inode() and return, no
  unwinding.  Put and clear ea_inode there so cleanup does not retry the
  decrement.  After a successful decrement the branch reaches cleanup
  with error == 0, which only puts the inode, so nothing is needed there.
  The new-block path is unchanged.
- Keep the in-place condition instead of new_bh != bs->bh; reasons and
  measurements in the reply to v2.
- Changelog: the normal-path leak does not retain quota charges; state
  the preconditions of the example.
- Shorter comment, EXT4_ERROR_INODE(); rebased onto ext4 dev; Cc stable.
v2: fail the operation on a failed decrement instead of masking it.
 fs/ext4/xattr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5c310747b9650..d9e60b5952d2d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2113,6 +2113,24 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			mb_cache_entry_touch(ea_block_cache, ce);
 			mb_cache_entry_put(ea_block_cache, ce);
 			ce = NULL;
+			if (ea_inode && !(bs->bh && s->base == bs->bh->b_data)) {
+				/*
+				 * The cached block already owns its EA inode
+				 * references.  For an in-place update the lookup
+				 * reference belongs to the old block and is
+				 * dropped when that block is released.
+				 */
+				error = ext4_xattr_inode_dec_ref(handle,
+								 ea_inode);
+				if (error) {
+					EXT4_ERROR_INODE(inode,
+							 "dec ref error=%d",
+							 error);
+					ext4_put_ea_inode(ea_inode);
+					ea_inode = NULL;
+					goto cleanup;
+				}
+			}
 		} else if (bs->bh && s->base == bs->bh->b_data) {
 			/* We were modifying this block in-place. */
 			ea_bdebug(bs->bh, "keeping this block");
-- 
2.55.0

