Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138313;
	b=YhD+RS4LAXib06Xe838+rqVeP+pQZb/gtjJ/T1zUOhD/r5+OVUUm2TXhdrvrzUxIsNdi
	 mQl6iU7DJibBXMhIsVklCmfdHnBgHelS8JBIyIO+E7SKvcuduFUKN4wO+r5S1ftFzy8hS
	 RQnljcUl6WFzQjXeF2eXRhRzmNovtm+TsaroZKBoT1DRE7spW5Rg3TpPx4zNEV+nckHDg
	 gTVsjlb5ok/LwAXUclwlZQQIKSS3ACW+Z7UKHErjWA7XKjBBwTLl01VkFsYUvJGzF2CdX
	 rfXpVOe/oVuhmM2NIHBapuzB8qj+OlGK3az76I67oLTTkNG66Cjesk4rBXoDVmyTJMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138313;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fKH8lEROlToWUaFVk6HBGi+a3bbRsRUnkhgJ3/v+Ess=;
	b=IzpAB2vH+s1I4hhfZf+jEpaI2XKKT2++dqyPixcNFHNqT4SEAL6G9jBMR/1z8wxgB8GB
	 1J/LgeEdM2v1D03406z6I6GnKF/ErW4RHYLJ4BTH0sdBN/ri/yX5BOIhKriFLAfTkV577
	 Ab5qh+DwAnSlP4byigAOSnVMXap3kVMaC7nwfleaqov0w2lB6Y7MbPOBrlfgU2WIVxQ+k
	 GFm9c66fLQ+w138bysIo1TfFUbQrolIQ5a2w1RpbC8FBfBTV7wajk6Wxw3QtPGyidpuQz
	 zjgyHfWeg/05t4OGU57A8AUsJfSsHkeH5b0+zDGhpkMk4HJuyFOdE66ePKKZjgJaLbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kktk5MvT;
	arc=none smtp.remote-ip=209.85.128.170
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DDB606A31D
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6DDB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kktk5MvT
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b0d126f631so3073557b3.2
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138312; x=1793743112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKH8lEROlToWUaFVk6HBGi+a3bbRsRUnkhgJ3/v+Ess=;
        b=Kktk5MvTTmooZ0Q3aCi26vX768BMQ/1m/1iozUmZR0IzIeWf2BuQjazLJfG3476g/r
         8kvrHa8KOzQV8RrLyDJ1RlEwNQ7Be2n0AY1iiRRdIvzRuc1oPn4B9jjY/M5c2//4SLMj
         USKthEZZWMli+0SNU4AVBbstq5kepiLkMHCLjcclCHsvypIYeFeeQS+wYw7Tchrd69SR
         Mqo4l3cOiuk8Ls1Fk9pOGcS/WnltZVnMA+jAYh1/nSwoFzCdA70wDWhzfkrisd+SUrQE
         6YLG1ywmQCVUi4C6A9d96MuXY2i6KxrufWZylWKs6C1OPJqhIo/CTS2nFacO58n+P2BA
         axtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138312; x=1793743112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKH8lEROlToWUaFVk6HBGi+a3bbRsRUnkhgJ3/v+Ess=;
        b=j7CZCC+JjF9Apzq8wKBBEfM8lJijbyf2hA7JFlfLZjRQELBJ0PqTUzQtzBmxV7Cx7u
         LMWOMwcu7dxAw4kRaXp2QAqGgJvQ8u1JIj8m8nwf05u8L8Y5kMBsxxophl3nGVEpvysw
         6MswLKaHl7N50mzVQoLRjCglGXuwyWYhxZ8ZSaGlvz24cTuFAHjrvLDy9V52byhAG5fh
         7suvaWgkm/JPdN8AXgyaKwhBDAII1LP+/OrALzHofP5nF1tWnADhJV3fuueP7zyL9krR
         m9l5gn34MaUfRontNaLVCyBucjCgIk6kLz02eIfZmuoFfneV6IUkVslwK1caFSBagXTY
         mFmg==
X-Forwarded-Encrypted: i=1; AKwUvBwVfA2+mi1PZajZpv7n0WVjlzPDiCSqVXuDeC1aaBfQOy3L4fM5TJzy6BSVzV/JRN/QbAKvKA0Yef61@vger.kernel.org
X-Gm-Message-State: AFq9FYJf/vEuTY60QSBGzkirTTa1WYA5OaPFScWYiKeXFPDSoIiQSvEK
	6aCD9a7zbfROCKLMN6qBwZ6nSgCQXqtIpi73RS0s8+yw5ncyXMDZsQe4
X-Gm-Gg: AYBFou3qcZEpdUWIuylcADfiBE6BeaA+sXtfWP04+A8yhQ9s2Yia1mxfEvNol2sVe5u
	YOdJV2ncUcq7GBJNdaDb+ZLBY/lb3L8IrlBFjFyjmXyI6PmPq7fSFqRr5GzF+13DTX+FE68iSV6
	PHKtmhDxlWAVcRHKlDqVWH0rdlIK8DgL6kKrsT4k2A63mwMvn0BE2JbHtTc3uJT170EQEPjDino
	SpyDq765Tvn3P1jINXp+j2PTqzVzsUkyuZ/dNrNEQB7rp8Y48m8Pw2K9GgTYQ+gunO8YPaj+ygy
	FCEfFBI+7WSZRYRjvFY77gGPOWJ69lNDlv8bYhsvU8t31BRsAlWd7HtKMmSVwSHDvUahlhEAyJD
	GGoM6LEKVYvOmqizRb/nrFkIphuTwt0ugSE7FaAGhghmK+z0UBG+EOkKzZ2afdfDDiShEiDp0uB
	0RfiMypKG3y4IuWdijIN8KpPie7hMtAxeeKHSj8FFi11yeJTLqlRn1Wu/aHSsC63ak8AFt5rPGZ
	j9xdopenth7shyL/iDRB3JInsMyH4kqvGXhpKwkrCsyBen0TxzretM6xUjbb2NkBDCUw8BCQ20E
	Bv++lyXilXZIu8Z2o9RJIUVUkq7YeB+f
X-Received: by 2002:a05:690c:7108:b0:8b0:7c36:4afc with SMTP id 00721157ae682-8b1b5e81826mr2719877b3.58.1793138311531;
        Tue, 27 Oct 2026 14:58:31 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e59400csm19360677b3.22.2026.10.27.14.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:30 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 0/5] iomap: remaining patches for iomap_iter_next conversion
Date: Tue, 27 Oct 2026 14:53:21 -0700
Message-ID: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
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

Hi Christian,

This is a resend of the last 3 patches from the "iomap: convert to in-iter
iomap_next() model" patch series [1].

Those 3 patches are rebased on top of current mainline (commit 83f32c773255
("Merge tag 'erofs-for-7.4-rc1-2' ...")) in Linus's tree. They require two new
preparatory patches (patches 1 and 2 in this series), which are trivial
->iomap_next() conversions of the nilfs2 and fuse iomap code that was added
during this merge window. There were conflicts with "iomap: pass
iomap_iter_next_fn directly instead of struct iomap_ops" (patch 4 in this
series) during the rebase. These are resolved in the patch, which now also
converts the iomap users added this merge window (ext4 iomap buffered I/O,
exfat swap activation, nilfs2, and fuse ext_map). Jan's Acked-by and
Christoph's Reviewed-by on it predate these changes.

These patches are being sent out now in case anyone wants to look at the
preparatory patches or patch 4. This series applies cleanly to both current
mainline and next-20261027. If anything conflicts by the time you pick it up
at the end of the merge window, I'll rebase and resend.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260729192737.3190206-1-joannelkoong@gmail.com/

Joanne Koong (5):
  nilfs2: convert iomap ops to ->iomap_next()
  fuse: convert ext_map iomap ops to ->iomap_next()
  iomap: remove ->iomap_begin()/->iomap_end() legacy path
  iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
  Documentation: iomap: update docs to reflect iomap_iter_next model

 Documentation/filesystems/iomap/design.rst    | 140 +++++++++++++-----
 .../filesystems/iomap/operations.rst          |  68 ++++-----
 Documentation/filesystems/iomap/porting.rst   |  16 +-
 block/fops.c                                  |  10 +-
 fs/btrfs/direct-io.c                          |   8 +-
 fs/dax.c                                      |  48 +++---
 fs/erofs/data.c                               |  28 ++--
 fs/erofs/internal.h                           |   3 +-
 fs/erofs/zmap.c                               |   7 +-
 fs/exfat/file.c                               |  14 +-
 fs/exfat/inode.c                              |   6 +-
 fs/exfat/iomap.c                              |  22 +--
 fs/exfat/iomap.h                              |   6 +-
 fs/ext2/ext2.h                                |   3 +-
 fs/ext2/file.c                                |   4 +-
 fs/ext2/inode.c                               |   9 +-
 fs/ext4/ext4.h                                |  10 +-
 fs/ext4/extents.c                             |   8 +-
 fs/ext4/file.c                                |  22 +--
 fs/ext4/inode.c                               |  58 +++-----
 fs/f2fs/data.c                                |   6 +-
 fs/f2fs/f2fs.h                                |   3 +-
 fs/f2fs/file.c                                |   4 +-
 fs/fuse/dax.c                                 |  10 +-
 fs/fuse/ext_map.c                             |  11 +-
 fs/fuse/file.c                                |  10 +-
 fs/fuse/virtio_fs.c                           |   3 +-
 fs/gfs2/aops.c                                |   6 +-
 fs/gfs2/bmap.c                                |   9 +-
 fs/gfs2/bmap.h                                |   2 +-
 fs/gfs2/file.c                                |   6 +-
 fs/gfs2/inode.c                               |   6 +-
 fs/hpfs/file.c                                |   6 +-
 fs/internal.h                                 |   1 -
 fs/iomap/buffered-io.c                        |  40 ++---
 fs/iomap/direct-io.c                          |   8 +-
 fs/iomap/fiemap.c                             |   8 +-
 fs/iomap/iter.c                               |  13 +-
 fs/iomap/seek.c                               |   8 +-
 fs/iomap/swapfile.c                           |   4 +-
 fs/iomap/trace.h                              |  12 +-
 fs/nilfs2/file.c                              |   2 +-
 fs/nilfs2/iomap.c                             |   4 +-
 fs/nilfs2/iomap.h                             |   4 +-
 fs/ntfs/aops.c                                |   6 +-
 fs/ntfs/file.c                                |  20 +--
 fs/ntfs/inode.c                               |   2 +-
 fs/ntfs/iomap.c                               |  42 ++----
 fs/ntfs/iomap.h                               |  10 +-
 fs/ntfs3/file.c                               |  16 +-
 fs/ntfs3/inode.c                              |  13 +-
 fs/ntfs3/ntfs_fs.h                            |   3 +-
 fs/remap_range.c                              |   6 +-
 fs/xfs/xfs_aops.c                             |   8 +-
 fs/xfs/xfs_file.c                             |  53 +++----
 fs/xfs/xfs_iomap.c                            |  55 ++-----
 fs/xfs/xfs_iomap.h                            |  16 +-
 fs/xfs/xfs_iops.c                             |   4 +-
 fs/xfs/xfs_reflink.c                          |   6 +-
 fs/zonefs/file.c                              |  22 +--
 include/linux/dax.h                           |  18 +--
 include/linux/fs.h                            |   7 +-
 include/linux/iomap.h                         |  66 +++++----
 63 files changed, 492 insertions(+), 557 deletions(-)

-- 
2.52.0

