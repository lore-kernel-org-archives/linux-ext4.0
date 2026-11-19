Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=psg5vinrIFJQmEo9CvkCKMuJv6WXeOGZVSZumqPDSuHCYyCuGLqhwoPDMH+CJUbdFpdQ
	 xjh0FJKHEunrC30xgkOQ9Xjlyg9bbp1A+SU/0DoZE+MGOccBEa+yfVCSV2+/OMaBzEVjD
	 acoeVY7Z5K1g7oStVrL9fSQ3q2ENbp5TuE9QX8dahP79+9MefvOhbxKeRmyA1g16qtnTY
	 Hx0WbL65Ixn+OIQsf4LFuat9pOIzv6dERpqVFChUIXD7cGjNh6Pu082qOnFaAPm3ksphC
	 CqghZLT/sYhL6/Is3+5pKD+YAnY6IB5KMAq70dd7P6GjnlrUfQIiaxMggFepuvAOgcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XyYguqFpXEmGzIQxC5v9zVC1YxdXxYK9qq07FOKI2Uk=;
	b=rU2uBvQOyUAWysZ+s+IAXX9B1eSO93kMRsFtiJ0zvLHx75GmWzvdzRFtq9ffdaMicLy/
	 xEm83dKy3Kx1mL/jCeDSuwqM2qznYoVObOczhtvGCWFHoZv6ftinDei+QJav2wBdOzkQm
	 MZkEfAhGe3NSg/iLSAZeSIfCHSt+peCFLuIxs/XHOyfCs9fipTzgjAjduFJL+XmfZr/HR
	 pCdE1gSPaALHVIJxs4SETsicVHq0lFuf6J4sHk2qWPPpuycOClejzd7Z9cnRU0U8IrT89
	 xTMCjRJHfzFMz8VrnWChKUV0jVrO+hT0tydJiYvvcJFw4m6n5jj+LW0mgTe2rw0bgDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Sqj9WVV6;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7FD606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A7FD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Sqj9WVV6
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHVUV029804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115852; bh=XyYguqFpXEmGzIQxC5v9zVC1YxdXxYK9qq07FOKI2Uk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Sqj9WVV6V+TCLp3Hwhj5rAxIkwWlzwdiVNelYQrNAsM+MfKQbY+LVbFFkMkQz7PUM
	 UGC48WEDBLumPwpcwsd4ZaHes2q2T8uhY8KkMS2UgIfQJwhqDddjVtjWkewVkNV3Ws
	 wPTDb7kzzEAKTA28uJd2uZO9ZoEjIfRYKLfxhO/aS6unKWfv07MjJfAm1+DS4ccMgg
	 fuREqPUNbcwVkiaG+cT7uwmmFLsqcM6u9A1cqzytOBir3R1yHX3aXosXcTKL3/IgyL
	 +dt+gxSGMZs3NPZBRm2Qi8jkpm+4Qsm1vi2LHmrS3/uU0OaqkBlJDxgrNcVlSWF8w5
	 drxeCf9Qro0uQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1133E2E00BB; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 00/32] ext4: lots of misc bug fixes
Date: Thu, 19 Nov 2026 14:16:47 -0500
Message-ID: <20261119191719.1943298-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While an LLM was creating a whole batch of KUnit tests for ext4[1],
the AI found a large number of potential bugs.  After validating the
list of bugs using a smarter LLM, and adding further fixes found from
Sashiko review feedback on the v1 KUnit series, the fixes for the
valid bugs are in this patch set.  A summary of the bugs, how they are
fixed, their criticality level --- e.g., "Critical (data loss)", "High
(metadata corruption)", "Low (32-bit compat)", etc. --- as well as
notes on the fixes dropped or trimmed during the rebase onto dev can
be found in report-bugfixes.md[2].

[1] https://lore.kernel.org/r/20261119155658.1940864-1-tytso@mit.edu
[2] https://drive.google.com/file/d/1pnTKAVf9pAoCK27619uP4_3_hpE04SkR/view

The patches in this series are available at the ext4.git tree on the
branch pu[3], which is based on the ext4-kunit-tests branch[4] (commit
4deecb8567ff), itself based on the ext4.git dev branch[5] (commit
008aad6508e3, on top of v7.4-rc2).

[3] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=pu
[4] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=ext4-kunit-tests
[5] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=dev

I've dropped or trimmed all of the bug fixes which already fixed by
patches submitted and in the dev branch.  I've checked the still-open
patches at https://patchwork.ozlabs.org/project/linux-ext4 and I think
there aren't any more duplicates.


Changes since v1[6]:

 - Rebased from the v1 KUnit series (on v7.3-rc4) onto the v2
   ext4-kunit-tests branch (on ext4.git dev / v7.4-rc2).
 - Dropped three ext4_ext_migrate() fixes now superseded by dev
   (their KUnit regression tests were moved into ext4-kunit-tests as
   "ext4: add KUnit regression tests for inode migration fixes"):
    * "ext4: cap migrated extents at EXT_INIT_MAX_LEN" (superseded by
      commit b0a3f2c102e8).
    * "ext4: don't treat a handle restart as an error in
      finish_range()" (superseded by commit 3b6aee59883c).
    * "ext4: don't clobber the migration result in ext4_ext_migrate()"
      (superseded by commit 82e2a5743b6a).
   (The ext4_ext_migrate() extent-tree ownership bug previously listed
   as a known issue in report-bugfixes.md is also now fixed in dev by
   commits 047061e6a6da, ed8c07b7692c, and 7c1f0eea4a9b.)
 - Trimmed two fixes partially superseded upstream or in dev:
    * Retitled and trimmed "ext4: only update s_mount_opts when
      EXT4_TUNE_FL_MOUNT_OPTS is set" to "ext4: only validate
      mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set", as commit
      981eec6c300b ("ext4: only update tune mount options when
      requested") in v7.4-rc1 already guards the copy in
      ext4_sb_setparams().
    * Dropped the bigalloc buffer_head leak fix from "ext4: don't
      allocate over indirect branches that failed to load", now fixed
      in dev by commit 79dd565874b3 ("ext4: fix buffer_head leak in
      ext4_ind_map_blocks() error path").
 - Added 10 new core ext4 bug fixes (with KUnit regression tests)
   uncovered from Sashiko review feedback on the v1 KUnit series and
   follow-up inspection:
    * Skipping EXT4_DIRENT_HASH() / EXT4_DIRENT_MINOR_HASH() reads on
      fake directory entries and rejecting crafted EXT4_FT_DIR_CSUM
      entries with nonzero inode or name_len.
    * Using loff_t for i_size in ext4_inline_data_truncate() to avoid
      32-bit truncation at >= 4 GiB.
    * Initializing converted inline directory blocks under the buffer
      lock and before raising i_size.
    * Propagating blkdev_issue_flush() errors from
      ext4_fc_replay_inode() (the other flush sites in ialloc and
      ext4_fc_perform_commit() are fixed in dev by commits
      baf9a298bdd7 and 49ac01dd7d43).
    * Validating child dx_node limit and count in
      ext4_htree_next_block().
    * Flushing s_ea_inode_work before clearing EXT4_FC_REPLAY in
      ext4_fc_replay_cleanup().
    * Zeroing dirty EOF folio tails before raising i_size in
      ext4_setattr().
    * Using atomic i_version accessors in swap_inode_data().
    * Rejecting multi-block atomic writes split by
      fscrypt_limit_io_blocks() with -EINVAL without triggering
      WARN_ON_ONCE(1).
    * Protecting extent status shrinker statistics updates and
      seq_file reads with s_es_lock (updated for SHRINK_STOP from dev
      commit ec14be6c39ce).
 - Added two KUnit test fixes at the end of the series uncovered
   during tracepoint and RTC-less VM verification:
    * "ext4: set bh->b_bdev on mock buffers in resize-test" (fixes a
      NULL dereference with block:block_dirty_buffer tracing enabled).
    * "ext4: avoid zero i_dtime wrap in ialloc-test on RTC-less VMs".
 - Verified the full series across UML and x86_64 KUnit runs
   (579/579 passing, including CONFIG_IA32_EMULATION=y), clean
   sparse C=2 checks, per-commit CONFIG_EXT4_KUNIT_TESTS=m modular
   builds with KCFLAGS=-Werror, and checkpatch.pl.

[6] https://lore.kernel.org/r/20261112044712.1577296-1-tytso@mit.edu

Theodore Ts'o (32):
  ext4: only validate mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set
  ext4: return -EFSBADCRC when skipping a corrupt backup superblock
  ext4: don't allow enabling casefold via EXT4_IOC_SET_TUNE_SB_PARAM
  ext4: persist the htree hash seed when enabling dir_index online
  ext4: enforce feature prerequisites when tuning a mounted fs
  ext4: handle s_lastcheck_hi in the get/set tune superblock ioctls
  ext4: pass missing ioctls through ext4_compat_ioctl
  ext4: fix inverted err_report_sec check in ext4_update_super()
  ext4: fix err_report_sec_store() timer and value handling
  ext4: fix inode table accounting in count_overhead()
  ext4: handle flex groups straddling s_first_meta_bg in online resize
  ext4: reject EXT4_IOC_GROUP_ADD inputs larger than a block group
  ext4: propagate ext4_alloc_group_tables() errors from ext4_resize_fs()
  ext4: reject online shrink before probing the device size
  ext4: fix EOF clamping of the range in mext_check_adjust_range()
  ext4: bound the MMP update and check intervals
  ext4: fix MMP claim of a cleanly unmounted filesystem
  ext4: fix device comparison overflow in ext4_getfsmap_dev_compare()
  ext4: don't allocate over indirect branches that failed to load
  ext4: don't stop EXT4_IOC_GET_ES_CACHE at uncached ranges
  ext4: don't read dirent hashes from fake directory entries
  ext4: use loff_t for i_size in ext4_inline_data_truncate()
  ext4: initialize inline dir block under buffer lock before raising
    i_size
  ext4: propagate cache flush errors from ext4_fc_replay_inode()
  ext4: validate child dx_node limit and count in
    ext4_htree_next_block()
  ext4: flush s_ea_inode_work before clearing EXT4_FC_REPLAY
  ext4: zero dirty EOF folio tail before raising i_size in
    ext4_setattr()
  ext4: use atomic iversion accessors in swap_inode_data()
  ext4: reject atomic writes split by fscrypt without warning
  ext4: protect extent status shrinker stats with s_es_lock
  ext4: set bh->b_bdev on mock buffers in resize-test
  ext4: avoid zero i_dtime wrap in ialloc-test on RTC-less VMs

 fs/ext4/dir-test.c            | 157 +++++++++++++++
 fs/ext4/dir.c                 |  19 +-
 fs/ext4/ext4.h                |  31 +++
 fs/ext4/extents-test.c        |  30 +++
 fs/ext4/extents.c             |   9 +-
 fs/ext4/extents_status-test.c |  44 +++-
 fs/ext4/extents_status.c      |  44 +++-
 fs/ext4/fast_commit-test.c    | 101 +++++++++-
 fs/ext4/fast_commit.c         |   8 +-
 fs/ext4/fsmap-test.c          |  56 +++++
 fs/ext4/fsmap.c               |   2 +-
 fs/ext4/ialloc-test.c         |  30 ++-
 fs/ext4/indirect-test.c       |  90 ++++++++-
 fs/ext4/indirect.c            |  17 +-
 fs/ext4/inline-test.c         | 150 +++++++++++++-
 fs/ext4/inline.c              |  31 ++-
 fs/ext4/inode-test.c          | 141 +++++++++++++
 fs/ext4/inode.c               |  64 +++++-
 fs/ext4/ioctl-test.c          | 370 ++++++++++++++++++++++++++++++++--
 fs/ext4/ioctl.c               | 147 +++++++++-----
 fs/ext4/mmp-test.c            | 222 +++++++++++++++++++-
 fs/ext4/mmp.c                 |  67 ++++--
 fs/ext4/move_extent-test.c    |  21 ++
 fs/ext4/move_extent.c         |   4 +-
 fs/ext4/namei-test.c          | 189 +++++++++++++++++
 fs/ext4/namei.c               |  86 +++++---
 fs/ext4/resize-test.c         | 129 +++++++++++-
 fs/ext4/resize.c              |  70 +++++--
 fs/ext4/super-test.c          |  37 ++++
 fs/ext4/super.c               |  28 ++-
 fs/ext4/sysfs-test.c          |  55 +++++
 fs/ext4/sysfs.c               |  21 +-
 32 files changed, 2260 insertions(+), 210 deletions(-)

base-commit: 4deecb8567ffe0167209b34c2183e18795c05fc6
-- 
2.56.1.708.g77570a6a1d-goog

