Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C7F368D66
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 20:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778704458; cv=pass; b=DZmmrdWVXb7nLSPUjyc6JdK7xcvApbmkGKGE3qn4/AeRoz6oNo+J+G2YR4ktTOfhnFbwBRnh7ywk/MbZmJv9uMoVw/Chzv3qQYyMAZF2f5eBZH/rBMUighqlAfFGKOLUTUVdWX8VYjtEFhnYdNyrL2Z9cdST9bQmCCCGhsG72K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778704458; c=relaxed/simple;
	bh=QqaIYA8X3X6Tew9rng99hk3rmPCslU/eWwD53qMGzFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MRJndSIKAIqmM9iyokNuOaNdCBfk4G601cIPRvguc0lG3FZGFcRZxkKq35byWZqfv+JkHzpLibnlZ+hkJImwWay0FkY+8qbVIWB4M4m1b+vog5NbIfK0zmnOwfep9UQ7XS8GdyzrfCK1aKGRGxMj3p5Cdduec//DnWCd5dudtis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AD9fcV9D; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AD9fcV9D"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8b4298d271fso115185716d6.3
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 13:34:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778704455; cv=none;
        d=google.com; s=arc-20240605;
        b=jA6OrZFu+ahQ4HljtcZjsYRTN0A3LSyd43wg5PCGpF0irkN827fdecc7O66UX2k1gs
         VjEz9Pzz28ZjikPOrOsNVB4dImite0tKAGB02hzNp0P4wynDaMiwf+59U9yznGgjiE5X
         uNpEnbtWwJ1J1rZsDr/xsSgo+n5Xv9cBrzaVpq2UmT+/uxguastIBNwMxOD/WJY8tPgg
         igm1AFdezpbGiAa4ipmyz+DaeWuQ/AX8tWOD7YWu8z2zFCpo4cBPEiHrWiwcG7gMjzmS
         Y+lfI1kItXJCun5Y9dkIrOvegImRRbQ5+P4zOV0tTZBP7fkJZpiBl9WpDbg1KnqbGNyv
         Pspg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        fh=7MfO/mfqtM/5lroQAiL/37U2IgU0sXc3IzQyEGnv3us=;
        b=MTUX23ujvDMK2vQcJY0X4Fg5I+QYEb0BreTN++yV2XVAUrMhufR548UzuUhOxYhiMj
         bW4zuyPdeuhCS85NCL3V3zFfsia9GYsPWcuJOHWWQCv6Z5Bou1jnai+V9cyTw0bEI18l
         0hNZby8FtoiYM031o01kau2Tbf/OI4Og4+QOoK7j57k0Mcn1idNQFlMzhiHrSqeL0Kel
         7rApE6DutKTseWAx7dMigT4tp7p8pho/thDTERKHo01DIdCSBGgoL46UllvpgeX9JQ2H
         96VoUms5WBuEYUBg9FrJ40ZA5nslvw6HGcn2ODYGG8SGugWSBXf8jXjGKcJvopKfWOP5
         w8sg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778704455; x=1779309255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        b=AD9fcV9DHYgDCefhJ2zSXZDp5IsgxaGD+U0MOWxRyeVB9HxtlwiRupMCngACCv3gN3
         DM2QnrQXjV+sYmnB7buk4J5Dt6tGrh1OPZBWVQB8b9fCQmOKih3ywWgVh1komLd2T6S9
         Iw0vFCUrddNFBUe65lmXniDofheSzrnXitWFheF975H4HOv5OAkzK3mkvFZBQzbbEFO5
         3CBUV04Gi5ikM28vxU2ZcJDeIaaPgXBzn1SOf42ImQdPsuYoVzWX98ke8U7+4SKfTYHq
         rgiLecCrmAZpjPBD/RK6amLrzQARySCD79r299h/pV/nX/61R2SXk8dj58MY+M4wHe8N
         AnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778704455; x=1779309255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        b=K+lczoEZOKSiyiQPYE1a+7XuYtwR7XGcQXjxj2gwG0lvUeUk0eY3XLmF8+14TcSX8r
         UshcwJmhPmZtzCmfTiDn+eXEv04/VOUHbcbxiegHSM6cd5Th1IvSU1wEIHr7jnglsk4S
         3Ne/fbGAmT4s5lnNUipQn2l2ATEv0uceLVNGCJZ8M3LBalXiIprnGizzOeOAzHCG84jU
         /eopCVJK0hFdsTJKKhTZDrlJwzRLZ5FSvAXSkT4+4ovr8+ad7w1zKLJIxOwUr+GIRIS6
         O2wQ9GadjEItWQd50l64dnIGmgi8XaEpxHkup8BU6hyVPSQejnrFiJ2WaNn+YcKIYBSD
         RKtg==
X-Forwarded-Encrypted: i=1; AFNElJ91mqrhHhtYGbj2CkfDRZy8GgQalKeZ2KqOuLgaF4kKkMvFo/Zua4GFZ1ESGlogfRbFazOCy9OGNlBQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/279w6GXCij5f/X5495VKJ76K70Of9KMHl9H8NapDLt83G+/p
	ihNCMsuhB9/5whSvymG1XPJWkkaKlkj2g1qhfhh4XY9IXffhAC+4C/OGFmZYt14Am/K5hN3L3pP
	8I5hNLzmtKQMzK4GvvOzvBgfTOFMVFsI=
X-Gm-Gg: Acq92OHtfyioF9YuWBfUDnRmZwY4HwY5p1LgKcP3IV2xab3xZPDK3UGGrPxRvnGDa8m
	x+tFHXmcv5jypp0i30+5ks/TmITgtvxcdFaQ6K2EA2f0zo9CuilZKQmNc0AgywrLc2UTsnEnTVY
	caXaelQUhBI6v/sbMS1Rz13jIMCdLPUI5rlHAv0VicAdmlJ9R+8f3ssUBF3bm6vrPN281gy6Jd7
	BRkXvyaktXUMOL6Op9x7Z04iLBUu9txg0zYBuLuTk/jrB2QFwSou8F9meyGCR5spHgL6SUf5MoY
	qz638twgufLc2Bj806B/3IxPLaYpnsTWCgsEzkoyYc5vZQPhAT1mtkViBUlIa44CKIJX//YJgLA
	h72WITJxochV6YFDzvLQkISS2suZvf1Fp44ozAoZVFA/2CfJrKMaD38lCaDtb9W2xNEjzs67uRz
	eIwvTubX4Lv54SJGl9uIuuSg==
X-Received: by 2002:a05:6214:8009:b0:8a0:846e:8850 with SMTP id
 6a1803df08f44-8c7b9d6a34dmr79395336d6.20.1778704455206; Wed, 13 May 2026
 13:34:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de>
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 May 2026 15:34:03 -0500
X-Gm-Features: AVHnY4LdSaGvyovg6RvG5pKhPWnEZkoZnNgrzQdw3V-htIBym1ah9EOHikjxM8Q
Message-ID: <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
Subject: Re: improve the swap_activate interface
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I just tried this on 7.1-rc3 with the swap patches (full kernel build,
on Ubuntu 25,10) and boot failed with out of memory which I had never
seen before.  Any idea how to workaround this with the swap patch
series, or is there a fix for this in the swap series already?

On Tue, May 12, 2026 at 12:41=E2=80=AFAM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> Darrick recently posted iomap support for fuse-iomap, which was trivial
> but a bit ugly, which triggered me into looking how this could be done
> in a cleaner way.  The result of that is this fairly big series that
> reworks how the MM code calls into the file system to activate swap
> files to make it much cleaner and easier to use.
>
> I've tested this with swap devices manually, and using the swap tests
> in xfstests on btrfs, ext3, ext4, f2fs and xfs to exercise the different
> implementation.  Out of those all passed, but f2fs actually notruns all
> tests even in the baseline as it requires special preparation for
> swapfiles which never got wired up in xfstests.
>
> Diffstat:
>  Documentation/filesystems/iomap/operations.rst |    3
>  Documentation/filesystems/locking.rst          |   35 +--
>  Documentation/filesystems/vfs.rst              |   40 ++--
>  block/fops.c                                   |   15 +
>  fs/btrfs/btrfs_inode.h                         |    3
>  fs/btrfs/file.c                                |    4
>  fs/btrfs/inode.c                               |   72 -------
>  fs/ext4/file.c                                 |    6
>  fs/ext4/inode.c                                |   11 -
>  fs/f2fs/data.c                                 |   50 -----
>  fs/f2fs/f2fs.h                                 |    2
>  fs/f2fs/file.c                                 |    4
>  fs/iomap/swapfile.c                            |  165 +++---------------
>  fs/nfs/direct.c                                |    1
>  fs/nfs/file.c                                  |   21 --
>  fs/nfs/nfs4file.c                              |    3
>  fs/ntfs/aops.c                                 |    8
>  fs/ntfs/file.c                                 |    6
>  fs/smb/client/cifsfs.c                         |   18 +
>  fs/smb/client/cifsfs.h                         |    3
>  fs/smb/client/file.c                           |   16 -
>  fs/xfs/xfs_aops.c                              |   48 -----
>  fs/xfs/xfs_file.c                              |   39 ++++
>  fs/zonefs/file.c                               |   30 +--
>  include/linux/fs.h                             |   11 -
>  include/linux/iomap.h                          |    5
>  include/linux/nfs_fs.h                         |    3
>  include/linux/swap.h                           |  129 +-------------
>  mm/page_io.c                                   |   45 ----
>  mm/swap.h                                      |   92 ++++++++++
>  mm/swapfile.c                                  |  227 ++++++++++++++----=
-------
>  31 files changed, 471 insertions(+), 644 deletions(-)
>


--=20
Thanks,

Steve
