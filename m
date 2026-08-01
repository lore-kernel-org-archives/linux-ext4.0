Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA2D17A300
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621670; cv=none; b=tlGYbAwP+ygiu2bLfvCE2xicl/07ISzXDcb3ZZoZiUpvJ3a69VwfBzoY7RbLobldzu+2ptIrDkQkP+2vtV0e/gq7mSVkdsrB7ccJTy/zJHXOrnUNVY6eerPIew4eHO50yrvaiBx2V0HrqZgDYeUEolkFBZTWko2e/ND0yfrXH/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621670; c=relaxed/simple;
	bh=5kc6aoUsPCWVQ7ZpkvBoTWz6LMN5kOsplmsUduRg5zA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m3Xt6TuDn5X3McXM4CZ+JFdbdm8GNdG0DaMhOb59AQKkd11MlXNy8hCR+A+y57g4xsxqFQy9R0VUA+QPlNoZQdjfFtGPh4iw+YkbYZAHo+NK/5s8KwjG808rh74K2NK6Z3Y3XLeGJqw/b1hL0eCbs11QRcCh6vHv75mqjjkjZyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLTzTx2t; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLTzTx2t"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7dbcb505578so19118287b3.3
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621666; x=1786226466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5qxson1aVl1hwzPiVPzIspxxMcycj2MEcHwvaNE0XYM=;
        b=NLTzTx2tAdIDOJDEQVz7sQFlXidVwJdB1FKgKW7/wJR4rk8r6ZV3zsIPVjtG2CFZ6D
         KeHCVCIACN7m7hMtM4S40mZtvdEm6Qua55wzn4iTzV/PTPWTsi/gi+sXGP5j8yQtB49E
         Yfb7V7zoG583YJI+jh48jARS2c/1QA08dCj4j0umP4ogQakxD/lJ36ua9c6dpW+7/opg
         dIkNbY5815yGzgrzg4ZtlV1JxMENfmxLt/4X4GAaClHe+DzC2a+8/jIDKWHuQcgRfji4
         4C/EA3OGm2sXcamU/0joH2EycQf7wEzrUumsKri71nkUVFBkyqi7YEN+Pij0Ou8Wis9E
         Y33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621666; x=1786226466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5qxson1aVl1hwzPiVPzIspxxMcycj2MEcHwvaNE0XYM=;
        b=Lbjn9M9bevWX4hEYKGVP3qhHCQPfR+6BtD10CM5IsUS/hIY6AtjwMD2NTU1S+nSr88
         iwKLZl7CYfDhBoLiAl8Lt3L9Hw9W742eqb+xbiFEiSS/ckTRQewY8XMaFCj+lBO5Z5A7
         Ai4GdQCQ46HYh3Y0JGAgT6+TiCoLY84Q5oEPKshnoYdXKE3yISGL6nnKPppe09C2NyvX
         jHc4q53xJcXoKGErEigZCi5HnSJ3D7h/xt+vkK/IoZQ9G1s2LCZi4yt19OZAn6arVc/w
         TRVkiPMdN8G/ArXjbE79Pw+PRkUQqHfVBIb0frBVVM80TV6teLAtBf5PYr9/YhX1jc+y
         OQ1g==
X-Forwarded-Encrypted: i=1; AHgh+RrHcASsRsnTFDjntKXJiXWaEvCXWQKLLwJmtUES3/H80JQI+Ty4rODJKq+i0JGZ78EbhfxSYaON4mB8@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7nmao0dxMQu8Q9H/06SVvYOlZeHO5Z0285kVSTIoI0AtyvW+E
	AZPb9LGwqzyagVUF1Xm+sieT4j0nrZeeFEZxA0cd6ou2cvx+SKniEbwe
X-Gm-Gg: AR+sD13TCDoTAAwe+Qr3LeDYsdM8QUprPp1If/3Xpg0TTAGzoY6w6/a7ukk4gxoNSMm
	ZCIE/uVaRmkSt80MDcqRlhqJixTYSVl5cQuV705I0YBCf/q9bkJfnMcrBAOKaNchRdR4gGOLg/8
	rNssG3H0DHzA+Nu2mKu1lEEBVCpPS5oD1dXcLcJNGkNePTQe6cd11KaromcxcsU5K01ZYlbJiZB
	gCigc4ftS7SStLMTwRIRDS2xid3Y88Ubv3Ksi0c7BTCzQVkGxaHbbQBVh8+aWHjBq6JkkWF/UFu
	CdzlD4yVq/7euSxMSsZJl0oP9TYHkOiAQpILDg5vFWA28GuUGb11GxT9MLtcxqqbceH7PQzoZMF
	F4UZw8n1PZvpsQtykXqPImd8q7tjoNilwy04QfWghVf6nUR+A42DR+cSINVO46fCcEChaIgezaN
	0P+QXbKDT4RsUuBxPNALH00iEtako+GgnwPMh4xwLmEvI2MiUNYoZ4yq+wT6Qv9DMlq39h5ih/f
	syFB0U=
X-Received: by 2002:a05:690c:60c6:b0:81e:45a6:bd53 with SMTP id 00721157ae682-81fd4a4996fmr64558587b3.8.1785621666321;
        Sat, 01 Aug 2026 15:01:06 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:05 -0700 (PDT)
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
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 00/19] buffer: stop clearing BH_Uptodate when a write fails
Date: Sat,  1 Aug 2026 18:00:44 -0400
Message-ID: <cover.1785621505.git.coshi036@gmail.com>
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
every consumer over to it, then removes the clears.

Patches 1-3 are groundwork.  Matthew's patch 1 removes b_page.  Patches 2
and 3 let a buffer_head point at memory outside the page cache and use that
for jbd2's shadow buffers, which today sit on a slab folio - a slab folio
overloads ->mapping, so mark_buffer_write_io_error() cannot be called on
them at all.  That is what blocked the jbd2 conversion.

Patches 4-5 make BH_Write_EIO safe to leave set: clear it in bforget() and
discard it on invalidate, so a freed or reused block does not inherit
somebody else's write error.

Patches 6-18 convert the consumers, one filesystem at a time: the two core
helpers in fs/buffer.c, then adfs, ext2, omfs, exfat, fat, ext4, ocfs2,
gfs2 and jbd2.  Patch 19 removes the clears.

Every patch builds on its own and the tree behaves identically at each step
until patch 19, because a failed write currently sets BH_Write_EIO and
clears BH_Uptodate together.

Four things are worth a second look, and I would rather point at them than
let you find them:

  - gfs2 (patch 15) is not a pure conversion.  gfs2_end_log_write_bh()
    already marks BH_Write_EIO without clearing BH_Uptodate, so the two ail
    checks are blind to log write errors today and start catching them.
    Jan and I agreed that is the desired fix rather than a regression, but
    it is a real behaviour change for gfs2.

  - ocfs2 (patch 14) has a check that turns the filesystem read-only when a
    buffer whose previous write failed is handed back to a transaction.  It
    sits inside an if (!buffer_uptodate(bh)) that goes dead, so it has to be
    hoisted or ocfs2 silently stops making that check.  The code in that
    patch is Jan's.

  - after patch 19, BH_Write_EIO stays set until the buffer is written
    again, forgotten or invalidated.  So a site like ext4's itable sync
    (patch 12) now reports on every subsequent sync rather than only on the
    write that failed.  That is intended, and matches what ocfs2 has always
    done with this flag.

  - the read path changes too.  __bread_gfp() and bh_uptodate_or_lock()
    currently re-read a buffer whose write failed, replacing the
    filesystem's data with the stale on-disk copy.  After patch 19 they
    return the in-memory data.  Better, but different.

On the original report: patch 19 provably closes that WARN for the write
error case, since the state it warns about can no longer be produced that
way.  I could not reproduce the WARN itself with fail_make_request, which
fails synchronously at submit; the original came from a fuzzer injecting
delayed error completions, which is what opens the window.  So there is no
ready reproducer to offer, only the argument.

Based on vfs.git vfs.all, because Jan's "fs: Fix missed inode write during
fsync" series is in it and rewrites __ext4_handle_dirty_metadata(), which
patch 12 touches.

Testing: built and booted with all of the above filesystems enabled;
checkpatch --strict clean on all 19; each patch built individually.
Patches 2 and 3 were validated by crashing with sysrq-b during ext4
data=journal,journal_checksum traffic engineered to force copy-out into
b_frozen_data, then replaying the journal on the next mount - recovery
completed, file contents matched, e2fsck -fn clean, and an instrumented
build confirmed the folio-less path was actually taken.  I have not
exercised the adfs, omfs or exfat paths beyond compiling them.

The conversion was asked for here:
  https://lore.kernel.org/linux-fsdevel/xaqwfkwjnp7h2lg7ir6wy2tnyay26t3im3ftkdl64rhys3rhmu@lc5vfh5tc2f5/
and the shape of it was settled in the two exchanges after it:
  https://lore.kernel.org/linux-fsdevel/CACd_6n17-pJuNoCLsstP7goocedrr5F8T8BwTjRUNx8frKEPgA@mail.gmail.com/
  https://lore.kernel.org/linux-fsdevel/bnchcfog427eo3bxt5h6qautlq7sb2o4ww7cjgad73biycdn5f@np7qkbyqizup/
Per-filesystem maintainers were not on that thread, hence the summary above.

The earlier attempt at this, which Jan correctly rejected, was
  https://lore.kernel.org/linux-fsdevel/20260430053645.1466196-1-coshi036@gmail.com/


Chao Shi (18):
  buffer: allow a buffer_head to point at memory outside the page cache
  jbd2: point the shadow buffer at the frozen data directly
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
  jbd2: assert on a failed write, not on a buffer that is not up to date
  ext4, jbd2: report fast commit write errors with BH_Write_EIO
  buffer: stop clearing BH_Uptodate when a write fails

Matthew Wilcox (Oracle) (1):
  buffer_head: Remove b_page

 fs/adfs/dir.c               |  2 +-
 fs/buffer.c                 | 26 +++++++++++++++++---------
 fs/exfat/misc.c             |  2 +-
 fs/ext2/xattr.c             |  2 +-
 fs/ext4/ext4_jbd2.c         |  2 +-
 fs/ext4/fast_commit.c       |  2 +-
 fs/ext4/mmp.c               |  2 +-
 fs/fat/misc.c               |  2 +-
 fs/gfs2/log.c               |  4 ++--
 fs/gfs2/lops.c              |  2 +-
 fs/jbd2/commit.c            | 20 +++++++++++++-------
 fs/jbd2/journal.c           | 21 +++++++++++++++------
 fs/jbd2/transaction.c       |  2 +-
 fs/ocfs2/buffer_head_io.c   | 12 +++++++-----
 fs/ocfs2/journal.c          | 25 +++++++++++++------------
 fs/omfs/inode.c             |  4 ++--
 include/linux/buffer_head.h |  7 ++-----
 17 files changed, 80 insertions(+), 57 deletions(-)


base-commit: 05c09c9c8a79d5539fef30d42e732eba90a15dcf
-- 
2.43.0

