Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E834A436349;
	Fri, 15 May 2026 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778836742; cv=pass; b=sL4MR9LALmxpngOqBjKt4RYB7PST+147wmttyK+WtSD7jFHMmNo4ALRCo9wHQ5B8mKCkQvXPUFlCSoXzwiR9FOkRs/y+/tqwjv1HaBEmvEM3YBybDnrh3yPcoJeIc72QQ4qh/OrLRF/9gqZnSQZ5gRtXmwwbjF6nxEDueNZGhxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778836742; c=relaxed/simple;
	bh=+yE1p6OSaGLxS/+eq6Fnm6dUI9swvEJApEv3fwmYiJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qK3V9LrhPyXStX1ra+xtw4znd0PB0zspMVLfUl8C+svTqkpYeWZwPHwZ135XUgP63EOOesv8KyF3QfpwhoJgeaWStLsU6u0LCPn1Uy3PyBU3dL60JGajmjTT7MyWsT2AxRD3xzs/+RhJYzSwo57+oCo1TFAUzz60V5DzBzKB4TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Lv9joksJ; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Lv9joksJ"
ARC-Seal: i=1; a=rsa-sha256; t=1778836726; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=n2J56C+hxtT6cb4KK9LDlcO/1PkhSnRBTaCZ3w/VGa6EqRyG2H5wDQYYM3aWD9gMuzFdMWCydTimiRS24XCxcefi8bc+qmvZlIBgNRt+4AdjXeJqL3I291ch4bNIssA1kC0DBtbBtDPaPG7p9NnExZZp9RYiHmDFsb09bSLDHVQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778836726; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JdbliOzcolRKEYGZh38c3fQhnCCr1sUK1VXYsbL0qeQ=; 
	b=aE3NV+WfqjGHvy8ut8CDZbreRrfOq7J+ANe6QmMBz/NcjCMfAukGE/sTowanu/PZJ5V4ucTjsEerhrBGjmXtzPKi8OCopYFjJppbIodEiqjuopf1lTcfpbZt9JqjN6tBnT8F0/JCmSIZae+k38DbL+ziVOfPWCtmK0VfXOl3G9I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778836725;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=JdbliOzcolRKEYGZh38c3fQhnCCr1sUK1VXYsbL0qeQ=;
	b=Lv9joksJPdvwEPMvG8HWcHCO6h9q2Dyu1TpaikRoyPvzuSL4GPwSORcDUU3iZCG+
	I7i1ycpZmOsEeY6i5KeHMkUigOcUriJ8akdo9wgT3JTxOeX9yOivaHj518LiYvO7dO+
	mZBAPYIhCC/rkYiE4vUGLotna1yT8fLjSyg8tQWA=
Received: by mx.zohomail.com with SMTPS id 1778836723508296.3848190021571;
	Fri, 15 May 2026 02:18:43 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-ext4@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v8 0/7] ext4: fast commit: snapshot inode state for FC log
Date: Fri, 15 May 2026 17:18:20 +0800
Message-ID: <20260515091829.194810-1-me@linux.beauty>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

(This RFC v8 series is rebased onto linux-next master as of 2026-05-09,
commit e98d21c170b0 ("Add linux-next specific files for 20260508"), and
depends on patch "ext4: fix fast commit wait/wake bit mapping on
64-bit" [0]).

Zhang Yi in RFC v3 review pointed out that postponing lockdep assertions only
masks the issue, and that sleeping in ext4_fc_track_inode() while holding
i_data_sem can form a real ABBA deadlock if the fast commit writer also needs
i_data_sem while the inode is in FC_COMMITTING.

Zhang Yi suggested two possible directions to address the root cause:

1. "Ha, the solution seems to have already been listed in the TODOs in
fast_commit.c.

  Change ext4_fc_commit() to lookup logical to physical mapping using extent
  status tree. This would get rid of the need to call ext4_fc_track_inode()
  before acquiring i_data_sem. To do that we would need to ensure that
  modified extents from the extent status tree are not evicted from memory."

2. "Alternatively, recording the mapped range of tracking might also be
feasible."

This series implements a hybrid way: it implements approach 2 by snapshotting inode image
and mapped ranges at commit time, and consuming only snapshots during log
writing.

Approach 2 still needs a mapping source while building the snapshot
(logical-to-physical and unwritten/hole semantics). Calling ext4_map_blocks()
there would take i_data_sem and can block inside the
jbd2_journal_lock_updates() window, which risks deadlocks or unbounded stalls.
So the snapshot path uses approach 1's extent status lookups as a best-effort
mapping source to avoid ext4_map_blocks().

I did not fully implement approach 1 (making extent status lookups
authoritative by preventing reclaim of needed entries) because that would need
additional pinning/integration under memory pressure and a larger correctness
surface. Instead, the extent status tree is treated as a cache and the
snapshot path falls back to full commit on cache misses or unstable mappings
(e.g. delayed allocation).

Lock inversion / deadlock model (before):

CPU0 (metadata update)               CPU1 (fast commit)
--------------------               -----------------
... hold i_data_sem (A)             mutex_lock(s_fc_lock) (B)
    ext4_fc_track_inode()             ext4_fc_write_inode_data()
      mutex_lock(s_fc_lock) (B)         ext4_map_blocks()
      wait FC_COMMITTING (sleep)          down_read(i_data_sem) (A)

This creates i_data_sem (A) -> s_fc_lock (B) on update paths, and
s_fc_lock (B) -> i_data_sem (A) on commit paths. Once CPU0 sleeps while
holding (A), CPU1 can block on (A) while holding (B), completing the ABBA
cycle.

New model (this series):

CPU0 (metadata update)               CPU1 (fast commit)
--------------------               -----------------
... maybe hold i_data_sem (A)        jbd2_journal_lock_updates()
    ext4_fc_track_*()                 snapshot inode + ranges (no map_blocks)
      mutex_lock(s_fc_lock) (B)       jbd2_journal_unlock_updates()
      if FC_COMMITTING: set FC_REQUEUE s_fc_lock (B)
      no sleep                         write FC log from snapshots only
                                    cleanup: clear COMMITTING, requeue if set

The commit path no longer takes i_data_sem while holding s_fc_lock, and
tracking no longer sleeps waiting for FC_COMMITTING. If an inode is updated
during a fast commit, EXT4_STATE_FC_REQUEUE records that fact and the inode
is moved to FC_Q_STAGING for the next commit.
The only remaining FC_COMMITTING waiter is ext4_fc_del(). It checks
FC_COMMITTING and FC_FLUSHING_DATA while holding s_fc_lock, drops s_fc_lock
around the sleep, and rechecks FC_COMMITTING after a FC_FLUSHING_DATA wait
before deleting the inode from the fast commit lists. This keeps inode
lifetime/deletion synchronized with the commit thread's transition from
FLUSHING_DATA to COMMITTING.

This series snapshots the on-disk inode and tracked data ranges while journal
updates are locked and existing handles are drained. The log writing phase then
serializes only snapshots, so it no longer needs to call ext4_map_blocks() and
take i_data_sem under s_fc_lock. This is done in two steps: patch 1 drops
ext4_map_blocks() from log writing by introducing commit-time snapshots, and
patch 5 drops ext4_map_blocks() from the snapshot path by using the extent
status cache. The snapshot also records whether a mapped extent is unwritten,
so the ADD_RANGE records (and replay) preserve unwritten semantics.

Snapshotting runs under jbd2_journal_lock_updates(). Since a cache miss in
ext4_get_inode_loc() can start synchronous inode table I/O and stall handle
starts for milliseconds, patch 1 uses ext4_get_inode_loc_noio() and falls back
to full commit if the inode table block is not present or not uptodate.

ext4_fc_track_inode() also stops waiting for FC_COMMITTING. Updates during an
ongoing fast commit are marked with EXT4_STATE_FC_REQUEUE and are replayed in
the next fast commit, while ext4_fc_del() waits for FC_COMMITTING so an inode
cannot be removed while the commit thread is still using it.

The extent status tree is a cache, not an authoritative source, so the snapshot
path falls back to full commit on cache misses or unstable mappings (e.g.
delayed allocation). This includes cases where extent status entries are not
present (or have been reclaimed) under memory pressure. The snapshot path does
not try to rebuild mappings by calling ext4_map_blocks(); instead it simply
marks the transaction fast commit ineligible.

To keep the updates-locked window bounded, the snapshot path caps the number of
snapshotted inodes and ranges per fast commit (currently 1024 inodes and 2048
ranges) and falls back to full commit when the cap is exceeded. The series also
handles the journal inode i_data_sem lockdep false positive via subclassing;
journal inode mapping may still take i_data_sem even when data inode mapping is
avoided.

Patch 6 adds the ext4_fc_lock_updates tracepoint to quantify the updates-locked
window and snapshot fallback reasons. Patch 7 extends
/proc/fs/ext4/<sb_id>/fc_info with best-effort snapshot counters. If the /proc
interface is undesirable, I can drop patch 7 and keep the tracepoint only, or
drop even both.

Testing and measurement were done on a QEMU/KVM guest with virtio-pmem + dax
(ext4 -O fast_commit, mounted dax,noatime). The workload does python3 500x
{4K write + fsync}, fallocate 256M, and python3 500x {creat + fsync(dir)}.
Over 3 cold boots, ext4_fc_lock_updates reported locked_ns p50 2.88-2.92 us,
p99 <= 6.71 us, and max <= 102.71 us, with snap_err always 0. Under stress-ng
memory pressure (stress-ng --vm 4 --vm-bytes 75% --timeout 60s), locked_ns p50
2.94 us, p99 <= 4.97 us, and max <= 20.07 us. The fc_info snapshot failure
counters stayed at 0.
These hold times are in the low microseconds range, and the caps keep the
worst case bounded.

Comments and guidance are very welcome. Please let me know if there are any
concerns about correctness, corner cases, or better approaches.

RFC v7 -> RFC v8:
- Base the series on "ext4: fix fast commit wait/wake bit
  mapping on 64-bit", which the fast commit wait/wake paths now depend on.
- Factor out small ext4_fc_wait_inode_state()/ext4_fc_wake_inode_state()
  helpers so the repeated FC state wait/wake mapping stays in one place.
- Use trace_call__ext4_fc_lock_updates() at the guarded tracepoint call site
  so the static branch is not checked twice.
- Address the Sashiko feedback around the commit-time snapshot lifecycle and
  snapshot stats accounting, including the FC_COMMITTING /
  FC_FLUSHING_DATA transition and stale snapshot sizing fallback. [3][4]

RFC v6 -> RFC v7:
- Rebase onto linux-next master as of 2026-05-09, commit e98d21c170b0
  ("Add linux-next specific files for 20260508").
- Address Sashiko review feedback for RFC v6. [2]
- Fix the reported snapshot range arithmetic issue near EXT_MAX_BLOCKS to
  avoid cur_lblk / range wraparound in the snapshot walk.
- Report successfully snapshotted inode counts in ext4_fc_lock_updates when
  snapshotting stops early, as reported by Sashiko.
- Use READ_ONCE() + div64_u64() for the fc_info lock_updates average, as
  reported by Sashiko.

RFC v5 -> RFC v6:
- Rebase onto linux-next master as of 2026-04-08.
- Address tracepoint review feedback by relying on enum auto-increment for
  snap_err values and by switching the guarded ext4_fc_lock_updates call site
  to trace_call__ext4_fc_lock_updates() to avoid the double static_branch. [1]
- Keep lock window accounting unconditional for fc_info while using the guarded
  direct tracepoint call.
- Fix the inode debug print format exposed by the rebase.

RFC v4 -> RFC v5:
- Patch 6: Make ext4_fc_lock_updates snap_err human readable via
  TRACE_DEFINE_ENUM() + __print_symbolic(), using a single TRACE_SNAP_ERR
  mapping while keeping the enum values stable for tooling.

RFC v3 -> RFC v4:
- Replace lockdep_assert movement with removing the wait in
  ext4_fc_track_inode() and using EXT4_STATE_FC_REQUEUE to capture updates
  during an ongoing fast commit.
- Replace dropping s_fc_lock around log writing with commit-time snapshots of
  inode image and mapped ranges (recording the mapped range of tracking as
  suggested by Zhang Yi) so log writing consumes only snapshots.
- Avoid inode table I/O under jbd2_journal_lock_updates() via
  ext4_get_inode_loc_noio() and fallback to full commit on cache misses.
- Use the extent status cache for snapshot mappings and fall back to full
  commit on cache misses or unstable mappings (e.g. delayed allocation).
- Add tracepoint and /proc snapshot stats to quantify the updates-locked window
  and snapshot fallback reasons.

RFC v2 -> RFC v3:
- rebase on top of
  https://lore.kernel.org/linux-ext4/20251223131342.287864-1-me@linux.beauty/T/#u

RFC v1 -> RFC v2:
- patch 1: move comments to correct place
- patch 2: add it to patchset.
- add missing RFC prefix

RFC v1: https://lore.kernel.org/linux-ext4/20251222032655.87056-1-me@linux.beauty/T/#u
RFC v2: https://lore.kernel.org/linux-ext4/20251222151906.24607-1-me@linux.beauty/T/#t
RFC v3: https://lore.kernel.org/linux-ext4/20251224032943.134063-1-me@linux.beauty/
RFC v4: https://lore.kernel.org/all/20260120112538.132774-1-me@linux.beauty/
RFC v5: https://lore.kernel.org/all/20260317084624.457185-1-me@linux.beauty/t/#u
RFC v6: https://lore.kernel.org/all/20260408112020.716706-1-me@linux.beauty/
RFC v7: https://lore.kernel.org/all/20260511084304.1559557-1-me@linux.beauty/

[0]: https://lore.kernel.org/all/20260513085818.552432-1-me@linux.beauty/
[1]: https://lore.kernel.org/all/acZJl8QUYEq8voqQ@BLRRASHENOY1.amd.com/T/#u
[2]: https://sashiko.dev/#/patchset/20260408112020.716706-1-me%40linux.beauty
[3]: https://sashiko.dev/#/patchset/20260511084304.1559557-1-me%40linux.beauty?part=4
[4]: https://sashiko.dev/#/patchset/20260511084304.1559557-1-me%40linux.beauty?part=7

Thanks,

Li Chen (7):
  ext4: fast commit: snapshot inode state before writing log
  ext4: lockdep: handle i_data_sem subclassing for special inodes
  ext4: fast commit: avoid waiting for FC_COMMITTING
  ext4: fast commit: avoid self-deadlock in inode snapshotting
  ext4: fast commit: avoid i_data_sem by dropping ext4_map_blocks() in
    snapshots
  ext4: fast commit: add lock_updates tracepoint
  ext4: fast commit: export snapshot stats in fc_info

 fs/ext4/ext4.h              |  73 ++++-
 fs/ext4/fast_commit.c       | 768 +++++++++++++++++++++++++++++++++++---------
 fs/ext4/inode.c             |  51 +++
 fs/ext4/super.c             |   9 +
 include/trace/events/ext4.h |  53 ++++
 5 files changed, 805 insertions(+), 149 deletions(-)

-- 
2.53.0
