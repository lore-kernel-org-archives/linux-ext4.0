Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BF9403129;
	Tue, 26 May 2026 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808159; cv=none; b=r9yWo5GIYwyegm/PsVDSzpCDSiC0ruZrPaUiaghoWEG04DaaE8Xg8P1JFyjlN06uv0kRx5P4WI6t0T9Muwc2mdtosDTreFFeSJ0i9rxLZFcaZ/pR7J3etOd6EDjBkb9DwFbDlGBsc9g4kUcCixpbg9g74O1b4QXIooAMXPS216E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808159; c=relaxed/simple;
	bh=jRpo8YbOv/KyfnRJcaF3vv/Y6tICX4m5qp5RklVA3iM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=StSsxB6XI9+eHqEe+5eL1BYwhlV2VUTBQC1E9MYny/b2QnhcEScNzAtpaBXR/E4e7zilct8v+Lz1rqFa22nSPxv2zcs4a/KCn7RvS6u2LgauSKBIs3duUP28F4yZu2r+n5cBzvlkwqAwjm9q7ixM/7wf4sYKjzm6JRCANdP4O7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qwp24YmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qwp24YmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4C91F000E9;
	Tue, 26 May 2026 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808157;
	bh=s8vRg/2eu+WCVkyRk3KkELjuEcNYOgskGstyofYq5EQ=;
	h=From:Subject:Date:To:Cc;
	b=Qwp24YmXN+yfXpSBsAjMzhG5PCwjuzHQV4E23THv0YFhZeZ+HYTWPP4dSZN0qdihe
	 PZ9JEVgTYvyRBy/8BI0wHqRJD57Vd4Xer8fO4R4uhVpVFpEqUq4vpf8dQNAcasAIG3
	 stmEVdMajYk1cE8xkrCtZvLqABraRpWnO7mjiGH7YZ3Z6qUauXEyex0tjhG8X8nNzY
	 PsTgWXFmdb5UaVUjP239slV5IK1ZSaoPYz1wvI3zB+TmdYQWa7T9QhqocX7X4tV2XA
	 dDRnWLE52Ku9o5WRzpWLw8inQx+WZFikSJ21odYXeC70gn8rKinnOhuPAN5Jp68Omm
	 xpgA4MwaLXS2A==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/8] super: retire sget(), convert iterators to RCU
Date: Tue, 26 May 2026 17:09:02 +0200
Message-Id: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI63FWoC/yWMyw6CMBAAf4Xs2Zq2tEX9FeNhtyxQjWC6+EgI/
 27R40wms4BwTixwqhbI/EqSprGA2VUQBxx7VqktDFbboL0N6j3lm5KeZxUoHjQdQyT0UPpH5i5
 9fq/z5c/ypCvHeRtsBaGwooxjHDZ1R5k57613nTuG2jGbgE1tTONai1w7il5T6zvnuWhY1y/ZC
 ZSHrwAAAA==
X-Change-ID: 20260526-work-sget-6bc80b96cba5
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2738; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jRpo8YbOv/KyfnRJcaF3vv/Y6tICX4m5qp5RklVA3iM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp/1ItX5a6XTOWv1PRdmFJ1UVLFdfeaQerLVSluZz
 Jkv9/Mv6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIiTbDX9GwlKPz03VWs8x6
 J8G10MZ6u+uhvoCvt7kZA+qrJNoPaTH8j+NjFK/xSipfp5bOvJ6bWbO65JenyAr1z6JXlbams6t
 wAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

* retire sget(): CIFS plus the two ext4 KUnit tests (extents-test,
  mballoc-test) were the last in-tree callers, and all three convert
  cleanly to sget_fc(). That lets sget() and its prototype come out,
  taking ~60 lines that only existed to be kept in lockstep with
  sget_fc() on every publish-path change.

* Walk @super_blocks and @type->fs_supers under RCU, pinned by
  refcount_inc_not_zero(&sb->s_count). iterate_supers(),
  iterate_supers_type(), user_get_super(), do_emergency_remount(),
  filesystems_freeze() and filesystems_thaw() no longer hold sb_lock
  across the cursor advance.

  The conversion goes in four small steps. Drop sb_lock from
  setup_bdev_super(): the {s_bdev_file, s_bdev, s_bdi,
  SB_I_STABLE_WRITES} tuple is publication of immutable state, and
  SB_BORN already gates every reader via super_wake()'s
  smp_store_release paired with super_flags()'s smp_load_acquire. Then
  convert sb->s_count to refcount_t -- mechanical, every increment is
  still under sb_lock. Then switch the write-side list/hlist ops to
  their _rcu variants; @super_blocks gets list_bidir_del_rcu() so the
  reverse-walking iterators (filesystems_freeze, do_emergency_remount)
  keep a valid ->prev on the unlinked entry, matching the canonical
  pattern in kernel/nstree.c. Finally, convert the iterators themselves:
  cursor advance via READ_ONCE / rcu_dereference, with the previous
  entry kept pinned via its s_count across the rcu_read_unlock ->
  callback -> rcu_read_lock cycle.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (8):
      ext4: convert extents KUnit test to sget_fc()
      ext4: convert mballoc KUnit test to sget_fc()
      smb: client: convert cifs_smb3_do_mount() to sget_fc()
      fs: retire sget()
      super: drop sb_lock from setup_bdev_super() tuple publication
      super: convert sb->s_count to refcount_t
      super: switch list manipulation to _rcu primitives
      super: convert iterators to RCU readers + refcount_inc_not_zero

 fs/btrfs/super.c               |   2 +-
 fs/ext4/extents-test.c         |  22 +++++-
 fs/ext4/mballoc-test.c         |  17 ++++-
 fs/smb/client/cifsfs.c         |  43 ++++++-----
 fs/smb/client/cifsfs.h         |   3 +-
 fs/smb/client/cifsproto.h      |   3 +-
 fs/smb/client/connect.c        |   5 +-
 fs/smb/client/fs_context.c     |   2 +-
 fs/super.c                     | 167 ++++++++++++++---------------------------
 include/linux/fs.h             |   4 -
 include/linux/fs/super_types.h |   3 +-
 11 files changed, 127 insertions(+), 144 deletions(-)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260526-work-sget-6bc80b96cba5

