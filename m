Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103825;
	b=Wa/Qrzsaif24RYCWiVDCjBDjY2Vi2EJKTWme7OZD5RoIKfrdGD83q6fVIG2yInU7KZEj
	 /PtOYgGBfLKP5tLVJHymqHhm2eQqGBbqmhhgbFHgB69jJ+UPxZVIdoafRSGP30i23jqzX
	 MOtPDSyfMIoOnlxyxhReArACRcr+YNh3q/dXZWJHazsB0SPnzAgGa3O/glezftefxrD9f
	 q1VzGB6ip+gGeMAaL9nl1+qdI6WO56AHzmRAw0nEUCrdJ+14dOEo7I0v7MqCgCEkReL6Q
	 h658ibbt/WuE6N8wKm9r7ktXYdnE22yegYiEhyiYOsT8GP/1sKB4nESEA+HwXMpm+/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103825;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AmPOcqk14RXDJ7VTp6EkJ38VMQbhJTDpFAyaDxHqk7I=;
	b=LMnC19kH20imZ+PszEfqjpzNVAyHSJN4MDBqhFmKkul/IjPxpdhdi/NUcYa4wgs6fQ1c
	 W2TycPwuP9QXFyxY3Hr3U9QdFfcbsK8DIDYLrGClIhYQtxrGqikrDjIJoFgnI4iJ5Sku4
	 hhnXuSbPt/7t43VAtTr36DikjIxkiEZQVczLRqhyByRIiR0kbbEAQkI8wv8pEVzMg5mAE
	 PMSAr+kAvVNflwKw86hNHENW8yQeNxgsfMSobkMCSaDftIcPP3bCbqJZcUz6eLBxpPIOu
	 KGNrxox+i/3DxRZlRuQBf6FmXikE1BZXuK5vdQlo4jwyu4musN83ALmT9AJyzjWV3hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=eUTRCCBs;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2509606A334
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 15:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2509606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=eUTRCCBs
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJFv0WP001487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 10:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795103821; bh=AmPOcqk14RXDJ7VTp6EkJ38VMQbhJTDpFAyaDxHqk7I=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=eUTRCCBsYC9Bl/uiRHMalcwp9XQJEc8cKak8z+h/1/u0quxxyhwV5Tgs5x1prd71N
	 1lrMbLHf38Vf9Lx2urK0XUd4KVS7aH/SPSm7WgsOYk+kD/aaLmTFcUSXUTNiG2FE1L
	 XRu1mUFCHobrJSdfOJJoNcwLc/pfoOLQ3hhYjotulCHK9Go2ouLiyZ8kwMIiLyq7Gg
	 xUeSmdUXLX2xw5I9tX7l45Fwkf9GoZ+WKBA4m+4SnBc1BCbxz+v9pFRBHI05Do6sU5
	 +iAwBUSdAJZhlNkffMGyDF0Ohz8SxN0YK052EGShrnCqa6W4Lw4znkSaNVEcJ7His+
	 TMs9mxm0Ys1KQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 39DDD2E00BB; Thu, 19 Nov 2026 10:57:00 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 00/26] ext4: add lots of KUnit tests!
Date: Thu, 19 Nov 2026 10:56:32 -0500
Message-ID: <20261119155658.1940864-1-tytso@mit.edu>
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
Content-Transfer-Encoding: 8bit

These unit tests were written using the writing-kunit-tests.md
prompt[1].  It has received human review, as well as multiple passes
with LLM's, especially since the -v1 release.

[1] https://drive.google.com/file/d/1MVZIhlG79kTRX_A65phWiZkTPJEtypsL/view

While the LLM was busily generating these unit tests, it also found
around two dozen potential bug fixes[2].  Those will be sent in a
separate series.

[2] https://drive.google.com/file/d/1pnTKAVf9pAoCK27619uP4_3_hpE04SkR/view

The patches in this series are available at the ext4.git tree on the
branch ext4-kunit-tests[3], which is now based on the ext4.git dev
branch[4] (commit 008aad6508e3, on top of v7.4-rc2).

[3] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=ext4-kunit-tests
[4] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=dev

Changes since v1[5]:

 - Rebased from v7.3-rc4 onto the ext4.git dev branch (on top of
   v7.4-rc2), updating test stubs, teardown helpers, and expectations
   for upstream and dev changes (ext4_es_destroy_stats(), const struct
   mnt_idmap *, buffer_write_io_error(), handle_t * zeroout arguments,
   blkdev_issue_flush() error propagation, sb_find_get_block() inode
   bitmap lookups, the 2 MiB max orphan file size, flex_bg sibling
   directory spreading, and stopping cleanly on incomplete fast commit
   replay).
 - Dropped "ext4: zero s_fc_replay_state in ext4_fc_replay_cleanup()",
   superseded by commit 2d36dbdbf575 ("ext4: free fast commit replay
   state on failed mounts") in dev.
 - Squashed "ext4: add KUnit tests for ext4_ext_split() leaf and index
   splitting" into "ext4: add KUnit tests for fs/ext4/extents.c".
 - Added "ext4: add KUnit regression tests for inode migration fixes"
   covering the ext4_ext_migrate() fixes now in dev.
 - Addressed build, sparse, bisection, portability, and test-lifecycle
   issues reported by the kernel test robot and sashiko-bot, along
   with follow-up verification fixes across UML, x86_64, i386, arm,
   and arm64 (including 16K/64K pages, lockdep, KASAN, sparse C=2,
   and per-commit CONFIG_EXT4_KUNIT_TESTS=m builds):
    * Deduplicated and reordered EXPORT_SYMBOL_FOR_EXT4_TEST()
      exports, dropped unused mballoc test wrappers, and moved the
      SB_ENC_STRICT_MODE_FL fix into the namei test patch for clean
      modular and CONFIG_UNICODE=y bisection.
    * Fixed 32-bit 64-bit-division link errors (div_u64/div_u64_rem),
      big-endian EXT4_EXT_MAGIC checks, sparse warnings (__le16/__le32,
      __percpu, __bitwise, flexible-array structs, upper_32_bits()),
      unaligned bitmap word ops, and large stack frames in tests.
    * Fixed mock superblock and inode teardown (attaching s_root via
      d_make_root() so deactivate_super() drains fserror_worker(),
      moving ext4_es_remove_extent() from .free_inode to .evict_inode,
      draining RCU callbacks via rcu_barrier(), and registering KUnit
      cleanup actions for early-abort safety).
    * Fixed lockdep key initialization, i_size_ordered_init() on mock
      inodes, CONFIG_HIGHMEM folio copies, 16K/64K PAGE_SIZE block and
      buddy-group spacing, SMP/preemption test races, RTC-less i_dtime
      checks, and !CONFIG_QUOTA / !CONFIG_PRINTK handling.

[5] https://lore.kernel.org/r/20261112040638.1576836-1-tytso@mit.edu

Theodore Ts'o (26):
  ext4: add KUinit tests for fs/ext4/extents_status.c
  ext4: add KUnit tests for fs/ext4/extents.c
  ext4: add KUnit tests for fs/ext4/xattr.c
  ext4: add KUnit tests for fs/ext4/namei.c
  ext4: expand KUnit tests for fs/ext4/mballoc.c
  ext4: add KUnit tests for fs/ext4/inline.c
  ext4: add KUnit tests for fs/ext4/fast_commit.c
  ext4: expand KUnit tests for fs/ext4/inode.c
  ext4: add KUnit tests for fs/ext4/ialloc.c
  ext4: add KUnit tests for fs/ext4/balloc.c
  ext4: add KUnit tests for fs/ext4/orphan.c
  ext4: add KUnit tests for fs/ext4/block_validity.c
  ext4: check multi-block overlap on left traversal in add_system_zone()
  ext4: enable full feature coverage in fs/ext4/.kunitconfig
  ext4: add KUnit tests for fs/ext4/super.c
  ext4: add KUnit tests for fs/ext4/sysfs.c
  ext4: add KUnit tests for fs/ext4/ioctl.c
  ext4: add KUnit tests for fs/ext4/resize.c
  ext4: add KUnit tests for fs/ext4/migrate.c
  ext4: add KUnit tests for fs/ext4/indirect.c
  ext4: expand KUnit tests in fs/ext4/extents-test.c for file range
    operations
  ext4: add KUnit tests for fs/ext4/fsmap.c
  ext4: add KUnit tests for fs/ext4/move_extent.c
  ext4: add KUnit tests for fs/ext4/mmp.c
  ext4: add KUnit tests for fs/ext4/dir.c
  ext4: add KUnit regression tests for inode migration fixes

 fs/ext4/.kunitconfig          |    7 +
 fs/ext4/Makefile              |   12 +-
 fs/ext4/balloc-test.c         | 2403 ++++++++++++++++++++++
 fs/ext4/balloc.c              |   11 +-
 fs/ext4/bitmap.c              |    5 +
 fs/ext4/block_validity-test.c | 1598 +++++++++++++++
 fs/ext4/block_validity.c      |   11 +-
 fs/ext4/crypto.c              |    4 +
 fs/ext4/dir-test.c            |  993 ++++++++++
 fs/ext4/dir.c                 |   37 +
 fs/ext4/ext4.h                |  255 ++-
 fs/ext4/ext4_extents.h        |   21 +
 fs/ext4/ext4_jbd2.c           |   21 +
 fs/ext4/extents-test.c        | 2625 +++++++++++++++++++++++-
 fs/ext4/extents.c             |   99 +-
 fs/ext4/extents_status-test.c | 1646 ++++++++++++++++
 fs/ext4/extents_status.c      |   23 +
 fs/ext4/fast_commit-test.c    | 2714 +++++++++++++++++++++++++
 fs/ext4/fast_commit.c         |  180 +-
 fs/ext4/fsmap-test.c          |  796 ++++++++
 fs/ext4/fsmap.c               |    3 +
 fs/ext4/ialloc-test.c         | 2731 +++++++++++++++++++++++++
 fs/ext4/ialloc.c              |  104 +-
 fs/ext4/indirect-test.c       | 1293 ++++++++++++
 fs/ext4/indirect.c            |   18 +-
 fs/ext4/inline-test.c         | 1866 ++++++++++++++++++
 fs/ext4/inline.c              |   34 +-
 fs/ext4/inode-test.c          | 3511 ++++++++++++++++++++++++++++++++-
 fs/ext4/inode.c               |  192 +-
 fs/ext4/ioctl-test.c          | 1198 +++++++++++
 fs/ext4/ioctl.c               |  249 ++-
 fs/ext4/mballoc-test.c        | 1940 +++++++++++++++++-
 fs/ext4/mballoc.c             |  181 +-
 fs/ext4/mballoc.h             |   40 +
 fs/ext4/migrate-test.c        | 1384 +++++++++++++
 fs/ext4/migrate.c             |   11 +
 fs/ext4/mmp-test.c            |  661 +++++++
 fs/ext4/mmp.c                 |  117 +-
 fs/ext4/move_extent-test.c    | 1023 ++++++++++
 fs/ext4/move_extent.c         |   22 +
 fs/ext4/namei-test.c          | 2347 ++++++++++++++++++++++
 fs/ext4/namei.c               |  342 ++--
 fs/ext4/namei.h               |  213 ++
 fs/ext4/orphan-test.c         | 2372 ++++++++++++++++++++++
 fs/ext4/orphan.c              |   12 +
 fs/ext4/page-io.c             |    1 +
 fs/ext4/resize-test.c         | 1336 +++++++++++++
 fs/ext4/resize.c              |  102 +-
 fs/ext4/super-test.c          | 1345 +++++++++++++
 fs/ext4/super.c               |  276 ++-
 fs/ext4/sysfs-test.c          |  679 +++++++
 fs/ext4/sysfs.c               |   55 +
 fs/ext4/xattr-test.c          | 1822 +++++++++++++++++
 fs/ext4/xattr.c               |   30 +-
 fs/ext4/xattr.h               |    2 +
 fs/ext4/xattr_hurd.c          |    4 +
 fs/ext4/xattr_security.c      |    4 +
 fs/ext4/xattr_trusted.c       |    4 +
 fs/ext4/xattr_user.c          |    4 +
 59 files changed, 40569 insertions(+), 420 deletions(-)
 create mode 100644 fs/ext4/balloc-test.c
 create mode 100644 fs/ext4/block_validity-test.c
 create mode 100644 fs/ext4/dir-test.c
 create mode 100644 fs/ext4/extents_status-test.c
 create mode 100644 fs/ext4/fast_commit-test.c
 create mode 100644 fs/ext4/fsmap-test.c
 create mode 100644 fs/ext4/ialloc-test.c
 create mode 100644 fs/ext4/indirect-test.c
 create mode 100644 fs/ext4/inline-test.c
 create mode 100644 fs/ext4/ioctl-test.c
 create mode 100644 fs/ext4/migrate-test.c
 create mode 100644 fs/ext4/mmp-test.c
 create mode 100644 fs/ext4/move_extent-test.c
 create mode 100644 fs/ext4/namei-test.c
 create mode 100644 fs/ext4/namei.h
 create mode 100644 fs/ext4/orphan-test.c
 create mode 100644 fs/ext4/resize-test.c
 create mode 100644 fs/ext4/super-test.c
 create mode 100644 fs/ext4/sysfs-test.c
 create mode 100644 fs/ext4/xattr-test.c

base-commit: 008aad6508e30cd1bb6d2c2cf65221ba1f16a065
-- 
2.56.1.708.g77570a6a1d-goog

