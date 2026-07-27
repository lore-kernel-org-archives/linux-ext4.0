Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095223CAE99
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187469; cv=none; b=RP0Y3cLAHdJ6cH/8IrR4FRUQ68ZSaNoYd8MVBhoaYhALWzo+JChYS1FSH6lRGyn2xxSbldklgTbYk3vXz6OQ+ABooNwABSRMcAyrbMRZdEV+glwRm8DrFZ4eDhZvUz61a5qUmtK9Ff59QAaQ34vJwa7i7fLfFtDnfRDtejm72Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187469; c=relaxed/simple;
	bh=6coMMzJvMlt96tUiQ+2wIJibJRmGZxsGHGesRSw6xlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=omVQKhPWwqr2H8K6ruo9LuiDOpRvINodX9dEgNxwaE0f3izseLE9UK1pCqMHee9DIvhOsUGhH+HDiVQbOdvjmfG/f5h0jldQkY1aindrjvCnxT5OHhddxBz7nBb+8qXEoMOTdCW4ORb6ViUlpuCKapgUoZlZtZbKyH2ZWFT+RDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PElMfLzj; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PElMfLzj"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cf52d15d88so32227935ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187466; x=1785792266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nwQurP/2xKbuuU+V4mrpMPrFREANrf+WyvNyFFZA9r4=;
        b=PElMfLzjxIsI4Sx4DWhMJH8vVEQIZa52+cHiEW0Os3Rr+xKY40+OI3QKgv55C0AgBi
         ooAXi1uhGiPIDIoZBejv36ABtqxKj+mJMei79ObG/FDXKTaz8+zAp1tCgXwFvOkiXavU
         smKCnRzRKy5Hf0fjlXS7HrdY+Lkr3e7P+xmjofkN6N86uvD/XUsCa2Czd7vqsSr4Arzj
         RN3kEnX73Y1IJLu5+Pzv72OPUa7spL3ul5eJaFshTIbu5n1moOcImguL6Sl9o+1FzMzD
         T0J6evsMPZO/KYJaHo3y8evlAzmpxESPc7KjaTWOO9/yLkbqcvQnNbpwoiFrIAYZ/Igu
         +MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187466; x=1785792266;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwQurP/2xKbuuU+V4mrpMPrFREANrf+WyvNyFFZA9r4=;
        b=iOxpNlkNY7ZjnazuDPIlZI2dwmwU4s5uaRAEa9//mQxNsMsi7zfPlV1tRHxulfmj/u
         mo9QSxTnzx7KywbmNZJTLADSTUQ+Vz3nbcbLh3e7kH1S6C53EbjgJ2TS0Ey2jL0A8rr1
         aCTD2MlBDpAqKZ/rcFdfQ/nqx0UUEnbrpYuvg+m7vsyN75/LS3C+0ljL2wi5dqLrrgFr
         Q3s3b0hcW/t47PU4crQTg3k9Q8sq5qEWPNnHFTEmtwWKdQ4ooueqwJ61qd5VosryWaXb
         cO7nmBFyPfAewk1OVb0DrquXxdO2ZoKL3h/TPFqEOYNXnc/M/hDL2B9LdiIrnQUSfdfq
         sbqg==
X-Forwarded-Encrypted: i=1; AHgh+RrlTKOfbJC+ntiwJBZ4yWJx4gLpda9sOmG6oxOsP5JaiIEQ6YS8V7CpLf8xqG/QeoQ6c1xo7ey10KU5@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0L5npatPxwxML45X/dauSzsi3+UFVb/6JeOwB15DQnjWzcAnJ
	8GjfZwDhh3N+dlt5l/kIrG0XOrV21zdEcK1QaeIC+ExcNi865DpJBD5J
X-Gm-Gg: AR+sD11zob9KwKzpVud5aX42Sz0ChbD2IvAIfZf/G62QNrpv/M6d8IVOTrViQsGBMiN
	TwXmOV9T6rhiMsoFIUuvRmDkJztJZKL9O8vABHcSXa6eHWOYRa32Rmj7cnasXpswWh4qf+MKkmK
	tQGQMNyZ2JBJuoMm9hzOdeJD/5mRoOPmrooQ01sumEUKSxSPP5rRHSprv5wCjSwDrbXJIF0DbR2
	O5ehTthFhlKNrrnuZk7d0hZtSBVRyTkkRxJf114rSJ29q8k/Wp+02I1K46xWBpsVuZoXAmVze2q
	YyDisQhpR4/FrqmmCq1rJhtOU5YhjEETnENI23su+SbkuRKWuHWRnoBj0ZmUKG6SkPKoQoZ+oH4
	AKlRG/vtCXiE3l/ML61YdhjjoxTHk9/fhimWn+JQNJa5G600TJg2HY2B1wT8Y0/qEekI0LU4+kq
	H46AYZM9GFl2f5i/EoljrKEDSjKZASJO9LkOsE2hBGT/2NU9/RFx47IL6jvDrqrHsu/QWcL96P6
	58=
X-Received: by 2002:a17:902:ec81:b0:2cf:afa5:b19a with SMTP id d9443c01a7336-2cfde797554mr88864015ad.11.1785187466278;
        Mon, 27 Jul 2026 14:24:26 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5e3e0asm40597175ad.29.2026.07.27.14.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:25 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 00/21] iomap: convert to in-iter iomap_next() model
Date: Mon, 27 Jul 2026 14:17:37 -0700
Message-ID: <20260727211758.1116539-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements a suggestion by Christoph for finishing the conversion
of iomap to an iterator model. This revives Matthew's previous RFC [1], which
had the same intention.

Every iomap operation currently drives its iteration through a struct
iomap_ops, which contains two callbacks, ->iomap_begin() and ->iomap_end().
iomap_iter() only ever sees these as pointers, so every step of every
iteration is an indirect call, including on the hottest paths. 

This series replaces the begin/end pair with a single ->iomap_next() callback
that finishes the previous mapping (if any) and produces the next one.
Collapsing to one callback lets a performance-critical caller inline its
iteration loop and pass its ->iomap_next() function as a compile-time
constant, where the compiler can devirtualize the callback into a direct and
inlineable call rather than an indirect one. It also allows future callers
more flexibility in expressing custom logic in the IO path for driving the
iteration forward.

This series has no functional changes intended. The patches are broken down as
follows:

1) Patch 1: refactors existing iomap_iter() logic into an iomap_iter_next()
function. Sets up DEFINE_IOMAP_ITER_NEXT/DEFINE_IOMAP_ITER_NEXT_END macro.

2) Patch 2 and 3: Christoph's patches for decoupling simple direct i/o reads
from iomap_dio_rw and improvement for using GFP_NOWAIT for non-blocking iocbs
[2]

3) Patch 4: Adds ->iomap_next() callback as an iomap op

4) Patches 5 to 18: converts each filesystem to ->iomap_next() model

5) Patch 19: Removes the legacy ->iomap_begin()/->iomap_end() path

6) Patch 20: At this point, struct iomap_ops only has one item in it, the
->iomap_next() callback. Gets rid of struct iomap_ops and passes
iomap_iter_next_fn directly.

7) Patch 21: Updates the iomap documentation to match.

This series is submitted against the vfs tree on top of the vfs-7.3.iomap
branch (head commit f166f2d0a0ae "Merge patch series "iomap/fuse: add helper
to keep..."). The changes can also be found in this github link [3]. This
series was run through an ai review system for additional sanity-checking.

As discussed in v2 about the merge logistics [4], the plan is for patches 1 to
18 to be merged in the v7.3-rc1 cycle and for patches 19 to 21 to be merged
after v7.3-rc1 has been tagged, in order to minimize disruption to filesystems
that are currently landing iomap conversions during the 7.3 merge window.
Patches 19 to 21 are included in this series for upstream review, so that they
can be approved / all ready to go when the 7.3 merge window closes.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u
[2] https://lore.kernel.org/linux-fsdevel/20260723050201.3381045-1-hch@lst.de/
[3] https://github.com/joannekoong/linux/tree/iomap_iter_next_v4
[4] https://lore.kernel.org/linux-fsdevel/20260703-nachrangig-gegeben-befestigen-8219a53648c7@brauner/ 

Changelog
---------
v3: https://lore.kernel.org/linux-fsdevel/20260720210202.1163861-1-joannelkoong@gmail.com/
v3 -> v4:
* Fold in Christoph's "decouple simple direct I/O reads from iomap_dio_rw v2"
  series and drop v3's simple dio patch/changes
* Add reviewed-bys

v2: https://lore.kernel.org/linux-fsdevel/20260701000949.1666714-1-joannelkoong@gmail.com/
v2 -> v3:
* Rename iomap_next_fn to iomap_iter_next_fn and iomap_process() to
  iomap_iter_next() (Darrick)
* Add integration with dio simple path, add Fengnan's patch
* Reconstruct patch that adds iomap_iter_next() logic as a refactoring of
  existing code (Christoph)
* Add DEFINE_IOMAP_ITER_NEXT{_END} macro, which nicely simplifies things
  (Christoph)
* Make documentation wording changes and a rename from dops -> next (Darrick)
* Update tracepoint in patch 19 to reflect taking iomap_iter_next_fn instead
  of ops. iomap tracepoints are explicitly called out as non-stable ABI so I
  kept Christoph's reviewed-by for this, but if that should be revoked, please
  let me know
* Add reviewed-bys

v1: https://lore.kernel.org/linux-fsdevel/20260625024723.1611000-1-joannelkoong@gmail.com/
v1 -> v2:
* Implement conversion for all callers

Christoph Hellwig (2):
  iomap: decouple simple direct I/O reads from iomap_dio_rw
  iomap: use GFP_NOWAIT when application for iomap_dio_simple
    allocations

Joanne Koong (19):
  iomap: split iomap_iter() logic into iomap_iter_next()
  iomap: add ->iomap_next()
  xfs: convert iomap ops to ->iomap_next()
  btrfs: convert iomap ops to ->iomap_next()
  ntfs3: convert iomap ops to ->iomap_next()
  ntfs: convert iomap ops to ->iomap_next()
  ext4: convert iomap ops to ->iomap_next()
  erofs: convert iomap ops to ->iomap_next()
  zonefs: convert iomap ops to ->iomap_next()
  ext2: convert iomap ops to ->iomap_next()
  block: convert iomap ops to ->iomap_next()
  f2fs: convert iomap ops to ->iomap_next()
  gfs2: convert iomap ops to ->iomap_next()
  hpfs: convert iomap ops to ->iomap_next()
  fuse: convert iomap ops to ->iomap_next()
  exfat: convert iomap ops to ->iomap_next()
  iomap: remove ->iomap_begin()/->iomap_end() legacy path
  iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
  Documentation: iomap: update docs to reflect iomap_iter_next model

 Documentation/filesystems/iomap/design.rst    | 140 ++++++++---
 .../filesystems/iomap/operations.rst          |  68 +++---
 Documentation/filesystems/iomap/porting.rst   |  16 +-
 block/fops.c                                  |  10 +-
 fs/btrfs/direct-io.c                          |  10 +-
 fs/dax.c                                      |  48 ++--
 fs/erofs/data.c                               |  30 ++-
 fs/erofs/internal.h                           |   3 +-
 fs/erofs/zmap.c                               |   4 +-
 fs/exfat/file.c                               |  18 +-
 fs/exfat/inode.c                              |   6 +-
 fs/exfat/iomap.c                              |  12 +-
 fs/exfat/iomap.h                              |   6 +-
 fs/ext2/ext2.h                                |   3 +-
 fs/ext2/file.c                                |   4 +-
 fs/ext2/inode.c                               |   7 +-
 fs/ext4/ext4.h                                |   9 +-
 fs/ext4/extents.c                             |   8 +-
 fs/ext4/file.c                                |  16 +-
 fs/ext4/inode.c                               |  16 +-
 fs/f2fs/data.c                                |   4 +-
 fs/f2fs/f2fs.h                                |   3 +-
 fs/f2fs/file.c                                |   4 +-
 fs/fuse/dax.c                                 |  12 +-
 fs/fuse/file.c                                |  10 +-
 fs/fuse/virtio_fs.c                           |   3 +-
 fs/gfs2/aops.c                                |   6 +-
 fs/gfs2/bmap.c                                |   7 +-
 fs/gfs2/bmap.h                                |   3 +-
 fs/gfs2/file.c                                |   6 +-
 fs/gfs2/inode.c                               |   6 +-
 fs/hpfs/file.c                                |   6 +-
 fs/internal.h                                 |   1 -
 fs/iomap/buffered-io.c                        |  40 ++--
 fs/iomap/direct-io.c                          | 219 +++++------------
 fs/iomap/fiemap.c                             |   8 +-
 fs/iomap/iter.c                               | 122 +++++-----
 fs/iomap/seek.c                               |   8 +-
 fs/iomap/swapfile.c                           |   4 +-
 fs/iomap/trace.h                              |  12 +-
 fs/ntfs/aops.c                                |   6 +-
 fs/ntfs/file.c                                |  24 +-
 fs/ntfs/inode.c                               |   2 +-
 fs/ntfs/iomap.c                               |  34 +--
 fs/ntfs/iomap.h                               |  15 +-
 fs/ntfs3/file.c                               |  16 +-
 fs/ntfs3/inode.c                              |  11 +-
 fs/ntfs3/ntfs_fs.h                            |   3 +-
 fs/remap_range.c                              |   6 +-
 fs/xfs/xfs_aops.c                             |   8 +-
 fs/xfs/xfs_file.c                             |  58 ++---
 fs/xfs/xfs_iomap.c                            |  50 ++--
 fs/xfs/xfs_iomap.h                            |  28 ++-
 fs/xfs/xfs_iops.c                             |   4 +-
 fs/xfs/xfs_reflink.c                          |   6 +-
 fs/zonefs/file.c                              |  23 +-
 include/linux/dax.h                           |  18 +-
 include/linux/fs.h                            |   7 +-
 include/linux/iomap.h                         | 223 ++++++++++++++----
 59 files changed, 772 insertions(+), 688 deletions(-)

-- 
2.52.0

