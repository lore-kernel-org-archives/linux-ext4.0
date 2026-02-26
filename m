Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9437B2DC79F;
	Thu, 26 Feb 2026 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115848; cv=none; b=MrVJ1+NiJ+tMcYGyDyeJMmbDH4/jOyahoZ26+QJ+h7YwQ3feswVfjCXH/X0zF2kCK1PdABZsJE0cIwjwC7irCE9MGeKCKXOJhfGJWuj10oql6dnmf+K70FlS0Qn5UTOy1Jv6WturnJFAiWujeHexK32rAZg/nLtON0DBk1L5tu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115848; c=relaxed/simple;
	bh=pfjoUFXEy3CeEoA64ZX2/TEeA+Y+XyxKvOYqAH8XD+E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T1xJg8apZkcBgz3kcY/lxX51fQiDnV5MlOvbR9PQIDK59+vOHDe1knTYXDjAx28TiBrlNtc+/J3xmaqVSZXB126h3DkhJE++DkWvtRP1X6D/r1gz4K5CgVPPO/9dqwv0pFCSs5Wmq0TjN90KN9Eq+t3laAuys0Zwg6skium7s+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0X0aCCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0X0aCCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9EDC116C6;
	Thu, 26 Feb 2026 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772115848;
	bh=pfjoUFXEy3CeEoA64ZX2/TEeA+Y+XyxKvOYqAH8XD+E=;
	h=From:To:Subject:Date:From;
	b=a0X0aCCDq6QY95WiEU9sWDS0Ru5Jik9pQkyITx8zDztCYytwC7rYC70jDevC+O7Si
	 JtjJmNx9wjMaSlHmKGCIxe//BkEXL4yQF5mMfQFYXuMDlw31A10xb9U6svRjup4Qph
	 EbkbZO3L78LQPnVbRJoPNyWT4FgUqSLcnro657DfdrChFbAZmf46GZrDQ6R/GrII4s
	 J1qiDVuPk+NLd6K1rCPwbUeVK6u2ej5llS+Gn5Icq5pOzl79Kf3iIymhFdAmDpKGUU
	 LDig+SGQm9xZtKgWfLqgNRI/PttdolA3YFozu9sAJ5pXOlI0oeBtv7iqpCAIMHTQGJ
	 bvg8xQBt7KvIQ==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 0/3] fix s_uuid and f_fsid consistency for cloned filesystems
Date: Thu, 26 Feb 2026 22:23:32 +0800
Message-ID: <cover.1772095546.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Btrfs, XFS and ext4 currently handle s_uuid and f_fsid differently when
a filesystem is cloned (e.g. snapshot or block-level copy), leading to
inconsistent behaviour across filesystems.

The table below summarises the current and post-patch behaviour.
"same" means the value is identical on both the original and cloned
filesystem.

Cloned filesystem:

              | s_uuid  f_fsid
--------------|---------------------------
EXT4          | same    same
Btrfs         | random  random
XFS           | same    f(devt)
EXT4-patched  | same    f(devt)
Btrfs-patched | same    f(s_uuid,rootid,devt)

Problem
-------
Btrfs currently never duplicates s_uuid or f_fsid for cloned filesystems.
When an fsid collision is detected at mount time, btrfs generates a new
in-memory fsid (temp_fsid), but this is ephemeral — it changes on every
mount. This has two consequences:

1. IMA (Integrity Measurement Architecture) cannot reliably track the
   filesystem across mount-cycle, since the f_fsid it sees keeps changing.
   This does not scale. Whereas on the otherhand if you have same s_uuid
   on multiple filesystems, monitoring per distint filesystem is lost.

2. If we instead allow cloned filesystems to share the same f_fsid (as
   ext4 currently does), fanotify loses the ability to distinguish
   between distinct filesystem instances. FAN_EVENT_INFO_TYPE_FID events
   will fail to resolve to the correct mountpoint when f_fsid values
   are identical across clones.

This series resolves the tradeoff by aligning btrfs and ext4 behaviour
with XFS: f_fsid incorporates device identity (devt) to remain unique
across clones, while s_uuid is preserved consistently matching the on-disk
uuid.

Patches
-------
Patch 1/3: btrfs: fix f_fsid to include rootid and devt
Patch 2/3: btrfs: fix s_uuid to be stable across mounts for cloned filesystems  
Patch 3/3: ext4: fix f_fsid to use devt instead of s_uuid

Anand Jain (3):
  btrfs: derive f_fsid from on-disk fsuuid and dev_t
  btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
  ext4: derive f_fsid from block device to avoid collisions

 fs/btrfs/disk-io.c |  3 ++-
 fs/btrfs/super.c   | 27 +++++++++++++++++++++++----
 fs/ext4/super.c    |  2 +-
 3 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.43.0

