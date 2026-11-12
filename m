Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456421;
	b=x2msHqwkhpBcVIh2lH+gBX0L4ivBopQlUOY0ZJx7+ZdnVsZ2YOT9K66lr7qbgBAgzKLS
	 k6j9EptactG6z5T0xkwAYz49N1ENEjw7r4y6fSAeOV/v4p3+BfOQ7rvo7vh1sDVZ5QjF+
	 9qlACq0C87jmMFDXmSm+UN8x8aXRJonSOn+YLdXtRjni/0SjuAyvy3IYYp9p0NZ4DkRYj
	 rUUERy9zsOG/cXEitzvv12NNJhy0EY+QWTBNiqs6TdRo7aTspF+zrr0Qn+EPmHXAFemXe
	 oJonBE24oWI0ZQtpwokuuL7Dhu49MdgfQhaQJ24ENaw4Z9ruBs7PFNzyb8XGnXAxv7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456421;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oZqnm/5YY+ehpjvJumTN71R/UVx6E3dHA2BgPvQa5jg=;
	b=zW1tDOOs/qOFMV5HKqBm0ngOEf2tpD64rLQ4zPKaculN+9Fa3VWGtzaBIWQCnDnaCwLn
	 u1LD96E/0SxedYO7NzJwRbdzZlrbB1lgyy9Wils7U7L0YYWmMKoAAZZu82hfTLeuPadUU
	 KW+vQ3Kb+igZD/NMNugEwJK3e12+QfNeNEU3xaZ3pW9IUQP3lzsEQmGBPgsqRBsg4lrHZ
	 vQs0eYpr0TcFIj4udGY9zL2+3m9bM4i4qwHky+KU8Rlx3P22NIJdMMsXdtIa0BKpRkfEW
	 Fy03v2PdvKiHrsjb8ZYgaE3i11Emx9vprCZ1sYDvKxU3xofm7l08YNM58+GEeVZTMXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=U+DxB5Hy;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA47606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBA47606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=U+DxB5Hy
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46pT5016765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456412; bh=oZqnm/5YY+ehpjvJumTN71R/UVx6E3dHA2BgPvQa5jg=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=U+DxB5HyE2K028ulZMM+gPcMfbrJm7sMPPawpIODa4ptMexWHvT2Fee2JI/h61mQF
	 /08QFmQnNq8EYgYg98MrRXiCqTtI3R47cHxUEKyiy4n5d9nvncva8yIfUEZaSAKcam
	 Ox5NtYJh9sllrlSp9jk43YYS2lp7F0887SpYdrIC1/m5JClmH+J2H3ampfMzr1AhRL
	 qpOUwgHV9TZVehlY1vKzMhmxocbY4z+0XXjA+gGPhcrgPdge3lHU31yGwdoiJCmeDO
	 Tc/UZoZK8USiKTVoP/S63HvOzcMHE9SkKWD6dl+oXT6H4wpznswDnAyVf3Ulki5eIE
	 yRaBczSA29CIA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 37BC02E00BB; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 00/27] ext4: add lots of KUnit tests!
Date: Wed, 11 Nov 2026 23:06:11 -0500
Message-ID: <20261112040638.1576836-1-tytso@mit.edu>
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
prompt[1], and then lightly reviewed by a human with only a few
fix-ups needed.

[1] https://drive.google.com/file/d/1MVZIhlG79kTRX_A65phWiZkTPJEtypsL/view

While the LLM was busily generating these unit tests, it also found
around two dozen potential bug fixes[2].  Those will be sent in a
separate series.

[2] https://drive.google.com/file/d/1pnTKAVf9pAoCK27619uP4_3_hpE04SkR/view

Hopefully extending ext4's Kunit coverage will make it easier to
sanity check the flood of AI generated patch submissions.  IOW, since
these tests were created Gemeni Pro, I'm hoping that we can use fire
to fight fire.  :-)

So as I process the AI slop backlog, my plan is to do trial merges to
determine whether the patches break the unit tests or not.  Which to
be fair, might be an indication of breakage of the unit tests, and not
necessarily a bug in the patches under review.

The patches in this series are available at the ext4.git tree on the
branch ext4-kunit-tests[3].  The patch series was originally based on
v7.3-rc4, so you want to try merging with with v7.4-rc2 or later, use
the branch ext4-kinit-tests-merge[4].

[3] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=ext4-kunit-tests
[4] https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=ext4-kunit-tests-merge

Theodore Ts'o (27):
  ext4: add KUinit tests for fs/ext4/extents_status.c
  ext4: add KUnit tests for fs/ext4/extents.c
  ext4: add KUnit tests for ext4_ext_split() leaf and index splitting
  ext4: add KUnit tests for fs/ext4/xattr.c
  ext4: add KUnit tests for fs/ext4/namei.c
  ext4: expand KUnit tests for fs/ext4/mballoc.c
  ext4: add KUnit tests for fs/ext4/inline.c
  ext4: zero s_fc_replay_state in ext4_fc_replay_cleanup()
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

 fs/ext4/.kunitconfig          |    7 +
 fs/ext4/Makefile              |   12 +-
 fs/ext4/balloc-test.c         | 2362 ++++++++++++++++++++++
 fs/ext4/balloc.c              |   11 +-
 fs/ext4/bitmap.c              |    5 +
 fs/ext4/block_validity-test.c | 1595 +++++++++++++++
 fs/ext4/block_validity.c      |   11 +-
 fs/ext4/crypto.c              |    4 +
 fs/ext4/dir-test.c            |  992 ++++++++++
 fs/ext4/dir.c                 |   37 +
 fs/ext4/ext4.h                |  251 ++-
 fs/ext4/ext4_extents.h        |   21 +
 fs/ext4/ext4_jbd2.c           |   17 +
 fs/ext4/extents-test.c        | 2601 ++++++++++++++++++++++++-
 fs/ext4/extents.c             |   94 +-
 fs/ext4/extents_status-test.c | 1640 ++++++++++++++++
 fs/ext4/extents_status.c      |   22 +
 fs/ext4/fast_commit-test.c    | 2668 +++++++++++++++++++++++++
 fs/ext4/fast_commit.c         |  181 +-
 fs/ext4/fsmap-test.c          |  787 ++++++++
 fs/ext4/fsmap.c               |    3 +
 fs/ext4/ialloc-test.c         | 2714 ++++++++++++++++++++++++++
 fs/ext4/ialloc.c              |   96 +-
 fs/ext4/indirect-test.c       | 1270 ++++++++++++
 fs/ext4/indirect.c            |   18 +-
 fs/ext4/inline-test.c         | 1839 ++++++++++++++++++
 fs/ext4/inline.c              |   34 +-
 fs/ext4/inode-test.c          | 3460 ++++++++++++++++++++++++++++++++-
 fs/ext4/inode.c               |  191 +-
 fs/ext4/ioctl-test.c          | 1169 +++++++++++
 fs/ext4/ioctl.c               |  249 ++-
 fs/ext4/mballoc-test.c        | 1868 +++++++++++++++++-
 fs/ext4/mballoc.c             |  214 +-
 fs/ext4/mballoc.h             |   49 +
 fs/ext4/migrate-test.c        | 1064 ++++++++++
 fs/ext4/migrate.c             |   11 +
 fs/ext4/mmp-test.c            |  661 +++++++
 fs/ext4/mmp.c                 |  117 +-
 fs/ext4/move_extent-test.c    |  997 ++++++++++
 fs/ext4/move_extent.c         |   22 +
 fs/ext4/namei-test.c          | 2314 ++++++++++++++++++++++
 fs/ext4/namei.c               |  342 ++--
 fs/ext4/namei.h               |  213 ++
 fs/ext4/orphan-test.c         | 2364 ++++++++++++++++++++++
 fs/ext4/orphan.c              |   12 +
 fs/ext4/page-io.c             |    1 +
 fs/ext4/resize-test.c         | 1341 +++++++++++++
 fs/ext4/resize.c              |  102 +-
 fs/ext4/super-test.c          | 1341 +++++++++++++
 fs/ext4/super.c               |  276 ++-
 fs/ext4/sysfs-test.c          |  653 +++++++
 fs/ext4/sysfs.c               |   55 +
 fs/ext4/xattr-test.c          | 1813 +++++++++++++++++
 fs/ext4/xattr.c               |   30 +-
 fs/ext4/xattr.h               |    2 +
 fs/ext4/xattr_hurd.c          |    4 +
 fs/ext4/xattr_security.c      |    4 +
 fs/ext4/xattr_trusted.c       |    4 +
 fs/ext4/xattr_user.c          |    4 +
 59 files changed, 39827 insertions(+), 412 deletions(-)
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

base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.56.0.542.g3ef89b7020-goog

