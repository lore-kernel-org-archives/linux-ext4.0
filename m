Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E977E36F8E9;
	Fri,  9 Oct 2026 21:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582723; cv=none; b=hsihU/IseoDYGriPl8qU+jEVCXFTBHH5eHBVgHH/OUMOJfgqctV4S/qFQvsV1a653GNjagjjJVTWM9K9KdThdl3xCccQjOZ3mgxfXemqzukljExFT74+9HoMcaN079OfDeoAqp6vlSyT2sTbmH/LvSD+UKuIVyMucchjfZ2eJnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582723; c=relaxed/simple;
	bh=vu8cOwyOk4KK0gZmnTmkJ8oYIw2D6BN4tZqdQhojPPs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=O+lfOL3DliAkmGQQDC2qSW/LN/yhuN8230MOdOKSIGnVqP+2u9Vgoh7GH7VhWVkkSfKm00KQKp19MzxBGeOyXyAneEQC90K0s7W06PNf3g45nvYt30OLX0TDZgidH3I8xwkSc3+FkCAhsb03wT0w1XH3U4UOr2zOtQnw+UIx818=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EeV+xn7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EeV+xn7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEBA1F000FF;
	Fri,  9 Oct 2026 21:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582721;
	bh=sGLkDmS4T9oMQexkKZv2PBhHBcGIaE3bzm/FwVFzgYY=;
	h=From:Subject:Date:To:Cc;
	b=EeV+xn7NGKwKc+NJj1IWDajbyBMTndMURPSqIuBYj2Q1b4YZU3nunvNMYF6I9eSCA
	 CO+tM5fdJfkyxxA0vvpfP65o7O7IgCT6fHGEHBytaSrEDbz5swA1ipZ+iF0vCVrR6y
	 6tXbAOSZGSGc94TjMM1+IIA4VLKasGQCERyhZjUjWlsCpr8oT5UHR5zfCFOp6Ntizc
	 1PhHSSPRZYn30qjIGmxaheZ47NhYeDDGOUZ+Yh4c8H2t5dURuzMILecSufDYOk88An
	 u8EwiTTNASCC02I9lNcRyaHePwo6/1tZhiFXsVzuFM36mVzKHno59OCmi5MqPnB7ju
	 uvI4NhXE5G3Bg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/8] fs: fix a range of UAFs during rcu pathwalk caused by
 non-rcu frees
Date: Fri, 09 Oct 2026 23:51:50 +0200
Message-Id: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ7CMAwEv1L5jKOkh6LwFcQhcQ0NSCmyKSBV/
 TtOOY7XMysoS2GFU7eC8LtomatBOHRAU6o3xjIaQ+/7IXgf8TPLA6/ly4pCC9IYKTCTPw4RTHo
 K76M558ufdcl3plertI+clDFLqjS1U+u5XXHWc22FbfsBCilr75gAAAA=
X-Change-ID: 20261009-work-fixes-rcu-cd9c1eec0769
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4343; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vu8cOwyOk4KK0gZmnTmkJ8oYIw2D6BN4tZqdQhojPPs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPzjJfzfcKXh+pN7NCY+KF+w78OdSUdM8jNmCOgtd
 Zg8u4ZpY0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBErp9hZHgmf/Ww/SQXjZ8n
 UjM5FoVOsjJrmsp8VGHtqilXb7JN7hFmZFi8OY131Y2y6+/De5Um/I9j+mrf3DvB58mkZV+niF4
 u42IEAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

While working on eliding the grace period in namespace_unlock() I went
through what filesystems free when they're shut down and what a pathwalk
in rcu mode can still read at that point. Since 66a97c2ec953's rcu
pathwalk fixes that's the filesystem's job. Whatever ->permission(),
->d_revalidate(), ->get_link(), ->d_hash() and ->d_compare() look at in
rcu mode has to be freed after a grace period. A few filesystems don't
do that.

Most of it is hidden by umount(2). namespace_unlock() waits for a grace
period before it drops the mounts, so a walker that was inside the
filesystem is gone by the time the filesystem is shut down.

But the last reference to a mount doesn't have to go away in umount(2).
A chdir() out of a lazily unmounted directory or the close() of the last
file on it drops it without a grace period. A walker can then still be
in the filesystem while ->put_super() and ->kill_sb() free what it
reads.

With KASAN on vfs.fixes:

- ext4_get_link() reads sb->s_fs_info and the extent status counters in
  rcu mode for a symlink that keeps its target in a data block.

  ext4_put_super() destroys the counters, clears s_fs_info and frees the
  sbi right away. That's a NULL dereference, a use-after-free of the sbi
  or a fault on a destroyed percpu counter, depending on where the
  walker sits.

- The unicode map of casefolded ext4, f2fs and tmpfs is freed from
  ->put_super() while generic_ci_d_hash() and generic_ci_d_compare() use
  it.

- ntfs3 with nocase frees its sbi and mount options under ntfs_d_hash()
  and ntfs_d_compare(). A remount frees the old mount options right away
  too, that one needs no unmount at all.

- eventfs frees an eventfs_inode after an SRCU grace period only, but
  tracefs_d_revalidate() reads it under rcu_read_lock(). No unmount
  needed either.

The ipc patch is a different kind of bug. create_ipc_ns() leaks the
mqueue mount and its superblock when it fails after mq_init_ns(). I ran
into it while looking at the kern_unmount() users.

afs and 9p look just as broken but nothing can reach it today. Both
have a private bdi, and generic_shutdown_super() calls bdi_unregister(),
which waits for a grace period before ->kill_sb() frees their private
data. That grace period is there for the rcu readers of bdi_list and
covers afs and 9p by accident. I don't want them to depend on that, so
they free their private data after a grace period of their own as well.

I appended the reproducers. The race reproducers hold a pathwalk inside
the filesystem's callback for two seconds with a kprobe while the other
side frees what it reads. For the ntfs3 remount the window is a single
load and its dereference, so that one needs an mdelay() in the kernel.
ext4 with a journal needs a kernel without lockdep since
jbd2_journal_destroy() calls lockdep_unregister_key(), which waits for a
grace period too.

Clean this all up.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (8):
      ext4: free the sbi after a grace period
      afs: free the super info after a grace period
      9p: free the session after a grace period
      eventfs: free the eventfs_inode after an rcu grace period too
      ipc: drop the mqueue mount with kern_unmount() on setup failure
      unicode: free the map after a grace period
      ntfs3: free the sbi after a grace period
      ntfs3: free replaced mount options after a grace period

 fs/9p/v9fs.h             |  1 +
 fs/9p/vfs_super.c        |  4 ++--
 fs/afs/internal.h        |  2 ++
 fs/afs/super.c           |  2 +-
 fs/ext4/ext4.h           |  2 ++
 fs/ext4/extents-test.c   |  2 ++
 fs/ext4/extents.c        |  1 +
 fs/ext4/extents_status.c |  7 ++++++-
 fs/ext4/extents_status.h |  1 +
 fs/ext4/super.c          | 13 +++++++++++--
 fs/ntfs3/dir.c           | 13 +++++++++++--
 fs/ntfs3/ntfs_fs.h       |  3 +++
 fs/ntfs3/super.c         | 49 +++++++++++++++++++++++++++++++++++-------------
 fs/tracefs/event_inode.c | 10 +++++++++-
 fs/unicode/utf8-core.c   | 21 +++++++++++++++++----
 include/linux/unicode.h  |  1 +
 ipc/namespace.c          |  2 +-
 17 files changed, 107 insertions(+), 27 deletions(-)
---
base-commit: 3d399224425573875b6f6f1181bd8cf9a28cc7d1
change-id: 20261009-work-fixes-rcu-cd9c1eec0769

