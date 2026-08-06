Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC037FF7A
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035536; cv=none; b=q0lfx+O3x2sfVqQL/h7swnduSEV46OG2EiwQ4FvmbCjXgM9XqEWhDuXriVLOlU6ieamlIsZ2yf+RAzgZGkxjSaGuZgvXdKezyBl1XcJ4NKwaDOqdLdRk3dtKw84VnTwSIyPwti7N/G/1OWOtNzKOF22KgNNUQtSQtJciebjycRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035536; c=relaxed/simple;
	bh=mvM/DC9CQyMBW3yHCRsmcgBHyjUfYXhbAAzHDYJ+e9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4ukPXtVWOiVkcWIXg+j64WfZi1Ibee/G1xxyBzL3DyN0OtK7x0obcp50O7NxWY0RQPs+sJieeg7j2Ai4Bz5mE9sqMi+RGsHFPeT4xgvvGlO+eC7QZIMvltbOdNNBivHheCpUhoW/NnzqYtBAQcQ3RMGQkJC4lnhqQGm48TCLdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IiYleEX7; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IiYleEX7"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5bf9466412fso1911377e0c.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035532; x=1786640332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G/9XTgSPVqgohCJtk8emfPisGpE2CTuNA9XLEHalOB4=;
        b=IiYleEX7/0r0PKr8u4WpA8ilyIF9zncQCQ/U3BDs5YY7NlkSy30XBnh4bSKSuEbJLn
         +rIvIIaaMLi3XSkYWRhJPn+vKIofAd9IpDKVsvoKPFQKAmLIsXFemRpEjZ83KzXawVG6
         4WjvjeoPBaEC9EhuPrly7i2CQoJ8PuFyWqctROCnfKtNVyio5nkpLCreuql+Pa/dcuRP
         y8sSOi53SbESHMjjQAkCWF92np9TuNTjgYr8U8mKa8yahRoq53LNYOfdAyIz7I1oXr5/
         DZ+WlUCyvYmnijnHKkoJYFFLNBfVEgF1eh8BPPvbN97mestWgGIublLOjPSNGvVdkvGW
         Hliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035532; x=1786640332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G/9XTgSPVqgohCJtk8emfPisGpE2CTuNA9XLEHalOB4=;
        b=nwesxgbsFmHAlHXWO6mIF1titQhrR/q/ufRGsZLpzDA5Z3oz7yFl3Db4NpkRshf9J0
         8wUjDI5/ziZop6mv6KGyoym5yKWC4LfEUsVSPWL1PZWOx4dhQT/S/IIR3F/e4dNcYNNM
         tIPNb4HWF+p5IwIfgcT5c3t7rgvnd/GJ8/hd8NTuxOkyRS7Vy78JE5AMQ5C1IgR/mUsf
         kuZBhBhDkS2kwl3urYrRYfIh8BqZOF8Pqvw+buzUAMxJ+QOSPd8nCWma3ikGP6qNMyiU
         DKrQaSJ2HKidLTEqZMktl9p+AAcznGXjOD2zG8IGObeM04VfdWGtq9eBg8Hd7XItTkay
         IyDg==
X-Forwarded-Encrypted: i=1; AHgh+Rr1o0Rxdhttp6e4DU5Wi32BqXPSfquEc0gz0h7721hTYIUYp43vRs9ribDf6/ggoYyMfA7q83tRPkn0@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7g3nIEVbvJwJ3YlNJlkeeaJyALL+5p9oy+WqSQ8AgZdlEA+4c
	LbIdBqElyDbBRJWnxTsoTk5epcMSm0EnzEXKbuoYTKSKk1fMVneteJ/H
X-Gm-Gg: AR+sD11zAjaTmkN92OEpNlzVvtxgsxGvtJX9Z54MbaOM93p4WLYlutpImELXWuSpzYy
	zWe0v7WZLjTSyVQijrv3ylvT6W1Oet9wyiBBINkQU/Nq2Y2ZQB1Fha22h3SEJmuCupgJ7Z/+905
	nYOARGTfw5C+dM6WQysT8NXpFduIIf5nA6AdnW+pub8ExGWNz/85ELI401grgglCYFIkuKArONu
	u8y0/4WLZFe6J5uS42wk/6BukjrJBDLpCwx1110xhodpGrpc2Cu6lJS6fixOAAtJpAcbQoNUiSA
	qTo2I2S5t3XGJ7yo3KEb9Jaoqj4XSeLUw+mpUYgxkk1FImWE8vfw4ytk9kNCy03LeQ9hnAB9Lz6
	BHZyvU/YABd/CXSN/vZZXgBbGUlYDGLyvwoRwwqLzO82b+og2liOKPXbPpI1IJi3LHTSor2xa3m
	5VCcbuqPxGIKQEXnfZ2jl7uOQszJZQyhlp4JsnhaOdo/lYZa7vrESHslJTdnjxCTfpoFaiexiQR
	YuiDRU=
X-Received: by 2002:a05:6122:390b:b0:55b:d85:5073 with SMTP id 71dfb90a1353d-5c3d9115c77mr2283685e0c.4.1786035532313;
        Thu, 06 Aug 2026 09:58:52 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:58:51 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH v2 00/21] buffer: stop clearing BH_Uptodate when a write fails
Date: Thu,  6 Aug 2026 12:58:23 -0400
Message-ID: <cover.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a metadata write fails, the buffer_head completion handlers clear
BH_Uptodate.  The buffer still holds exactly the data the filesystem asked
to be written - it is the disk that is stale, not the buffer - and saying
otherwise has consequences:

  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)), so a
    filesystem that dirties the buffer again to retry the write trips it.
    That is the warning that started this.

  - a buffer that is not up to date gets re-read from disk, which silently
    replaces the data the filesystem was trying to write with the stale
    on-disk copy.

  - the state is not self consistent while it lasts: the window between the
    write completing and BH_Uptodate being cleared is visible to anyone
    holding the folio lock.

BH_Write_EIO already records that the last write failed.  This series moves
every consumer over to it, then stops write completion touching BH_Uptodate
at all.

Patches 1-4 are groundwork.  Matthew's patch 1 removes b_page.  Patches 2
and 3 let a buffer_head point at memory outside the page cache and use that
for jbd2's shadow buffers, which today sit on a slab folio - a slab folio
overloads ->mapping, so mark_buffer_write_io_error() cannot be called on
them at all.  That is what blocked the jbd2 conversion.  Patch 4 then drops
the folio_mapping() call that was only there to cope with those slab
folios.

Patches 5-6 make BH_Write_EIO safe to leave set: clear it in bforget() and
discard it on invalidate, so a freed or reused block does not inherit
somebody else's write error.

Patches 7-19 convert the consumers, one filesystem at a time: the two core
helpers in fs/buffer.c, then adfs, ext2, omfs, exfat, fat, ext4, ocfs2,
gfs2 and jbd2.  Patch 20 stops write completion touching BH_Uptodate.
Patch 21 moves the point at which BH_Write_EIO is cleared from submission
to successful completion.

Every patch builds on its own and the tree behaves identically at each step
until patch 20, because a failed write currently sets BH_Write_EIO and
clears BH_Uptodate together.

Changes since v1:

  - 02: changelog reworked - a folio-less buffer is a narrow thing that
    most of the buffer_head API will not tolerate, and keeping it away from
    all of that is the caller's job; NULL just makes getting it wrong loud
    instead of quiet (Jan).

  - 03: jbd2_journal_write_metadata_buffer() simplified.  folio_set_bh() is
    now needed on one path only, so it moved there and new_folio,
    new_offset and the flag that chose between them are gone (Jan).  The two
    checksum helpers now use a new kmap_local_bh()/kunmap_local_bh() pair
    instead of open coding the folio test (Matthew).  The pair does not map
    a folio-less buffer at all: that memory is always mapped, and under
    CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP mapping it would hand back one page,
    which is not enough for a block bigger than a page.

  - 04 is new: read bh->b_folio->mapping directly instead of via
    folio_mapping(), which would hand fscrypt a swap_address_space if a
    buffer ever sat on a swap cache folio (Matthew).  It is a separate patch
    after 03 on purpose - folio_mapping() is also what turns a slab folio
    into NULL, so doing this before jbd2 stops using slab folios would leave
    a window where this path reads slab-internal state as an address_space.

  - 17, 19: the jbd2 and ext4 fast commit completion handlers stop setting
    BH_Uptodate as well, and their local flag is renamed to match
    fs/buffer.c.  ext4's debug messages now describe the write rather than
    the buffer's contents (Jan).

  - 18: the assertion in jbd2_freeze_jh_data() keeps testing BH_Uptodate,
    which is what it is really about; only its message changes.  v1
    converted it to BH_Write_EIO, which was wrong - a buffer with a failed
    write still has valid data here and will be written again (Jan).

  - 20: write completion no longer sets BH_Uptodate either.  Checked rather
    than assumed: an instrumented build with
    WARN_ONCE(success && !buffer_uptodate(bh)) in all four write completion
    handlers, exercised over ext4 in two configurations - data=journal with
    journal_checksum, and fast_commit with -o sync - never fired.  That is
    ext4 evidence only: vfat and exfat were in the same run, but neither
    reached a mount in that image.

  - 21 is new (Jan): clear BH_Write_EIO on successful write completion
    instead of on resubmission, and drop the clear from __bh_submit().  As
    well as being the more honest point to clear it, this closes the case
    Sahiko raised, where a task's write fails and another task's
    resubmission clears the flag before the first task looks at it.

  - Jan's Reviewed-by added to v1's 1, 2, 4, 5, 6, 8, 12, 13, 14, which are
    v2's 1, 2, 5, 6, 7, 9, 13, 14, 15.  The code in those is unchanged; some
    of their changelogs are reworded so that they no longer describe where
    BH_Write_EIO gets cleared, which patch 21 moves.

Three things are worth a second look, and I would rather point at them than
let you find them:

  - gfs2 (patch 16) is not a pure conversion.  gfs2_end_log_write_bh()
    already marks BH_Write_EIO without clearing BH_Uptodate, so the two ail
    checks are blind to log write errors today and start catching them.
    Jan and I agreed that is the desired fix rather than a regression, but
    it is a real behaviour change for gfs2.

  - ocfs2 (patch 14).  ocfs2_write_block() has never removed a block from
    the cluster uptodate cache when its write failed, because the buffer was
    not locally uptodate and so the stale entry could do no harm.  After
    patch 20 it is uptodate, and ocfs2_read_blocks() - which decides whether
    to go to disk on the cluster cache alone - stops returning -EIO for such
    a block and hands back the in-memory copy instead.  Jan asked for ocfs2
    maintainer eyes on that; the ask stands, and I cannot test a real
    cluster here.

  - after patch 20, BH_Write_EIO stays set until the buffer is written
    successfully, forgotten or invalidated.  So a site like ext4's itable
    sync (patch 13) now reports on every subsequent sync rather than only on
    the write that failed.  That is intended, and matches what ocfs2 has
    always done with this flag.  The read path changes too: __bread_gfp()
    and bh_uptodate_or_lock() stop re-reading a buffer whose write failed,
    and return the in-memory data instead.

Zhang Yi pointed out on v1 that ext4_buffer_uptodate() exists for exactly
this reason: it puts BH_Uptodate back on a buffer whose write failed, so
that ext4 does not go and re-read a block whose in-memory copy is the good
one.  That is this series' argument, open coded in one filesystem, and it
can go once the generic behaviour is fixed.  Jan noted there are more such
workarounds about.  I have left every one of them alone here, so that this
series stays a behaviour change rather than a cleanup.

On the original report: patch 20 provably closes that WARN for the write
error case, since the state it warns about can no longer be produced that
way.  I could not reproduce the WARN itself with fail_make_request, which
fails synchronously at submit; the original came from a fuzzer injecting
delayed error completions, which is what opens the window.  So there is no
ready reproducer to offer, only the argument.

Based on vfs.git vfs.all, because Jan's "fs: Fix missed inode write during
fsync" series is in it and rewrites __ext4_handle_dirty_metadata(), which
patch 13 touches.

Testing: each of the 21 patches built individually, warning free;
checkpatch --strict clean.  The jbd2 shadow buffer changes were validated by
crashing with sysrq-b during ext4 data=journal,journal_checksum traffic
engineered to force copy-out into b_frozen_data, then replaying the journal
on the next mount - recovery completed, contents matched, e2fsck -fn clean,
and an instrumented build confirmed the folio-less path was taken.  Write
error detection was compared against an unpatched build under injected write
errors: same error reports, same journal abort, same read-only remount, same
errno to userspace.  All of that is ext4, and so jbd2 underneath it; the
adfs, ext2, exfat, fat, gfs2, ocfs2 and omfs conversions are compile tested
only.

v1: https://lore.kernel.org/linux-fsdevel/cover.1785621505.git.coshi036@gmail.com/

The conversion was asked for here:
  https://lore.kernel.org/linux-fsdevel/xaqwfkwjnp7h2lg7ir6wy2tnyay26t3im3ftkdl64rhys3rhmu@lc5vfh5tc2f5/


Chao Shi (20):
  buffer: allow a buffer_head to point at memory outside the page cache
  jbd2: point the shadow buffer at the frozen data directly
  buffer: read the folio's mapping directly in buffer_set_crypto_ctx()
  buffer: clear BH_Write_EIO when a buffer is forgotten
  buffer: discard BH_Write_EIO along with the rest of the buffer state
  buffer: detect metadata write errors with buffer_write_io_error()
  adfs: check for a directory write error with buffer_write_io_error()
  ext2: check for an xattr block write error with
    buffer_write_io_error()
  omfs: check for an inode write error with buffer_write_io_error()
  exfat: check for a directory write error with buffer_write_io_error()
  fat: check for a metadata write error with buffer_write_io_error()
  ext4: check for a metadata write error with buffer_write_io_error()
  ocfs2: check for a metadata write error with buffer_write_io_error()
  ocfs2: check for a stale write error before reusing a metadata buffer
  gfs2: check for a metadata write error with buffer_write_io_error()
  jbd2: report journal write errors with BH_Write_EIO
  jbd2: say what jbd2_freeze_jh_data()'s assertion is actually checking
  ext4, jbd2: report fast commit write errors with BH_Write_EIO
  buffer: stop touching BH_Uptodate on write completion
  buffer: clear BH_Write_EIO when a write succeeds, not when one starts

Matthew Wilcox (Oracle) (1):
  buffer_head: Remove b_page

 fs/adfs/dir.c               |  2 +-
 fs/buffer.c                 | 37 ++++++++++++++++++++-----------------
 fs/exfat/misc.c             |  2 +-
 fs/ext2/xattr.c             |  2 +-
 fs/ext4/ext4_jbd2.c         |  2 +-
 fs/ext4/fast_commit.c       | 12 ++++++------
 fs/ext4/mmp.c               |  2 +-
 fs/fat/misc.c               |  2 +-
 fs/gfs2/log.c               |  4 ++--
 fs/gfs2/lops.c              |  4 +++-
 fs/jbd2/commit.c            | 22 +++++++++++-----------
 fs/jbd2/journal.c           | 31 ++++++++++++++++++-------------
 fs/jbd2/transaction.c       |  2 +-
 fs/ocfs2/buffer_head_io.c   | 12 +++++++-----
 fs/ocfs2/journal.c          | 25 +++++++++++++------------
 fs/omfs/inode.c             |  4 ++--
 include/linux/buffer_head.h | 36 +++++++++++++++++++++++++++++++-----
 17 files changed, 120 insertions(+), 81 deletions(-)


base-commit: 05c09c9c8a79d5539fef30d42e732eba90a15dcf
-- 
2.43.0

