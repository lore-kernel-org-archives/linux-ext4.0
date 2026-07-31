Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C33ACF1D
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488283; cv=none; b=kwdkybg/s6zRyPFshpt//bJVji5TlOgGUOXESJL4rhnyueOlTSi9DLkJsoO8Tj1yz8wEVr5k6iIF1/5/98AwJ8XfqTxt1Kjvs6LGA2b1HZM54s1S5LL05BuJuqixPV9D53a+UrL/IXU5VEyRADoy1Z2D+BgHfkb+qswI3OrKeDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488283; c=relaxed/simple;
	bh=QjBfmrKaW9lBtkr9V/jT6dSCozcSIeqkColXqlVF0c4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jf8Rz+gQBZojPz6zu08fnEq+Eb5Tzdfu2ezDsBLnD6U/y9jUntCpgtSFyVq+pl7RAaiKa7/mZoGyyUD6oXaaYxvGPJ7ZucGD/mlmI7O2gYYm+wGMP/jFG359bfjFLhsOptJYyvAH16bxSOPeF1+fAsdDqP5LtXHBuue58npRyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=S/Sk+4Hp; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="S/Sk+4Hp"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c96c92c0980so392795a12.3
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 01:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1785488280; x=1786093080; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qamvL2ZAM8jb0jhr4je9ViBel0WjePPdd3Oxb7fUcNQ=;
        b=S/Sk+4HpaPyEvtNl9YpThGxK1Y+syndjoV0YsEOZWsTBP9++siTcSEAoRZ43LdZxZi
         sahvmMmlGYZbtfKLh/+VIRc9bPeZDuwrVKvFWtenBVFQZ7rOLK9mMYPlql6dCWpndsTC
         MAhEvnTFp7igE6J59sCyjLad0HKNUxbHzoc3FzENzTElotU76fIkS4+s5TFyNM0BjxAt
         e0sqlW8Lq0WtTx0KbVlXSqMBIZPvKj3z6R6ZvLfEsAjhJ2S5rZ4EZxLEZCPNiBEQh/FU
         6Z0/wCI1cMkAb8HWQh5+pIgLZqUEko/JOjfzs7GAFoyrldZ5HplGZZWFZ8iQAKTnKzD9
         CYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785488280; x=1786093080;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qamvL2ZAM8jb0jhr4je9ViBel0WjePPdd3Oxb7fUcNQ=;
        b=qfHLDICBI1WHIS+PHTodRwv473w7jaYzLIs5wKwwxHAoHJlu1osNKl9mQfbYYQeSI5
         qHsovCYFk2QPiX2/hmoKYS79fhd11ilS3cpnaJIXOncKxOJhL7zG9R0E1bFLTn7qIRlF
         ZSQ9mGQwRa6MfmH3tMdsaCY8Jv9RTLxa6Tngevpv0w5k+oij74Q7BxUmwKbbnQ8yBlkO
         9cONmVQs4l8aSDqqNUuTTkQvPw5rzvXt6mvvJGBSFm9tvbSP0CEZa8FTsjh6BC0e5RcA
         9skwwPqBU7veEzZKw1jLLqyK4HQiDGcaHJQ9UenyQjWqwyQCTnDSpu+PA7PH3MJpw++6
         XoZQ==
X-Gm-Message-State: AOJu0Yy8fO0PhJWg6+LQymOkLw/8/HqvfZNag5EwjbmHGuwbfRwtgsxL
	1bmWMZ+AZRTmVCl/yaGmVrtZOBul61rtiEXzcxuV+YSmrjWfcmNA3FUKSEhGEkRIm+0=
X-Gm-Gg: AR+sD130nH9kftn0KX1rjb4Vg+xEJk66Iq+y3bA+Z28sAF//R7RI6+1rtQfuKrXEWXa
	2KyfBB3bZ7KzqSiaUSdG1dYt4TO/Ch+LVTx6KWiZ3aCn5JBK5MgR9yoSkU+s6gzT4mCnCjvhoKN
	EtHJzw2tl4Z9WYaax9uwAyg9FGhNi3t8UVJe9LepUQ2yHDIKPiKzCaBYPquWVijKtFje+5lSSlw
	YE6+xiYkA8CF2x4rM/CFe0TsGemzfXXJx6RyAZi5qa/gYBrWLHCmPMzLr0ZEp9UtxG+IruB3wpF
	/avVCPNRuVf8gQpNoHOhTYlynn9H8ZMJefvDdkWzMGODoamWDz7cN3s428ESXtCCNehBe7EGjec
	s+VvzyEA45jNZo9Y6wtPRjleKdCS0mXMqu8W/wUVPS9uSa+7hCh+9uFivEmYaz9yJNX8PEq0r5m
	VAiSspnug5VuM8lsejXdbZphjZ9unZu4JIoSEmHUFMAx+NuXPJ6d1uOAf+QMW2axOf21OUHT5wG
	cX1wiJ71/lBpi49HXI=
X-Received: by 2002:a05:6a20:3282:b0:3bd:4698:e7c4 with SMTP id adf61e73a8af0-3c91b32751bmr1119411637.42.1785488279868;
        Fri, 31 Jul 2026 01:57:59 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:ac28:4325:669e:a7ef])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe396ea5casm307658a12.15.2026.07.31.01.57.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:57:59 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 2/3] fix bitmap byte size calculations
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260731033701.2657758-3-johunt@akamai.com>
Date: Fri, 31 Jul 2026 02:57:48 -0600
Cc: linux-ext4@vger.kernel.org,
 kknox@akamai.com,
 tytos@mit.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <D7B257B1-2BBF-48A4-8D84-BAA012F81DF8@dilger.ca>
References: <20260731033701.2657758-1-johunt@akamai.com>
 <20260731033701.2657758-3-johunt@akamai.com>
To: Josh Hunt <johunt@akamai.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 30, 2026, at 21:37, Josh Hunt <johunt@akamai.com> wrote:
>=20
> From: Kit Knox <kknox@akamai.com>
>=20
> The bitmap byte size calculations use integer division (count / 8) =
without
> rounding up.  When clusters_per_group or inodes_per_group is not a =
multiple
> of 8, this allocates too few bytes.  The bitmap backends copy (num + =
7) / 8
> bytes via ext2fs_get_block_bitmap_range2(), causing a buffer overrun =
of 1-7
> bytes.

Is it ever legal to have clusters_per_group or inodes_per_group in a =
filesystem?
Is this something you've seen in real life or is this a fuzzed =
filesystem image?
It would probably be better to refuse processing such a filesystem =
entirely, since
it is more likely that the superblock is corrupt and a backup superblock =
should be
used instead?

Testing mke2fs it doesn't appear to allow a non-multiple-of-8 value for =
blocks_per_group:

    $ mke2fs -N 77 -g 77 /tmp/tt
    mke2fs: blocks per group must be multiple of 8

and while the inode count is specified as an odd number, it is =
internally rounded
to a multiple of 8 per group:

    $ mke2fs -N 77 -g 800 /tmp/tt
    mke2fs 1.47.3-wc2 (11-Nov-2025)
    :
    Creating filesystem with 262144 4k blocks and 5248 inodes
    Superblock backups stored on blocks:  2400, 194400
    :
    $ dumpe2fs -h /tmp/tt | grep -i group
    dumpe2fs 1.47.3-wc2 (11-Nov-2025)
    Blocks per group:         800
    Fragments per group:      800
    Inodes per group:         16
    Inode blocks per group:   1

even with 4KiB inode size (one inode per block) the number of inodes is
a multiple of 8:

    $ mke2fs -N 77 -I 4096 /tmp/tt
    mke2fs 1.47.3-wc2 (11-Nov-2025)
    :
    Creating filesystem with 262144 4k blocks and 64 inodes
    :
    $ dumpe2fs -h /tmp/tt | grep -i group
    dumpe2fs 1.47.3-wc2 (11-Nov-2025)
    Blocks per group:         32768
    Fragments per group:      32768
    Inodes per group:         8
    Inode blocks per group:   8

Cheers, Andreas

>=20
> Example: With s_clusters_per_group =3D blocksize*8 + 1, the buffer is
> undersized by 1 byte, causing heap corruption when the bitmap is =
copied.
>=20
> Signed-off-by: Kit Knox <kknox@akamai.com>
> ---
> e2fsck/pass5.c          | 10 ++++++----
> lib/ext2fs/rw_bitmaps.c | 13 ++++++-------
> misc/dumpe2fs.c         |  4 ++--
> resize/resize2fs.c      |  3 ++-
> 4 files changed, 16 insertions(+), 14 deletions(-)
>=20
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index c1d45a5f..aad2e76a 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -324,10 +324,12 @@ static void check_block_bitmaps(e2fsck_t ctx)
> int redo_flag =3D 0;
> char *actual_buf, *bitmap_buf;
>=20
> - actual_buf =3D (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
> -     "actual bitmap buffer");
> - bitmap_buf =3D (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
> -     "bitmap block buffer");
> + actual_buf =3D (char *) e2fsck_allocate_memory(ctx,
> + ext2fs_div_ceil(fs->super->s_clusters_per_group, 8),
> + "actual bitmap buffer");
> + bitmap_buf =3D (char *) e2fsck_allocate_memory(ctx,
> + ext2fs_div_ceil(fs->super->s_clusters_per_group, 8),
> + "bitmap block buffer");
>=20
> clear_problem_context(&pctx);
> free_array =3D (unsigned int *) e2fsck_allocate_memory(ctx,
> diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
> index 1da75e4a..211d9ec4 100644
> --- a/lib/ext2fs/rw_bitmaps.c
> +++ b/lib/ext2fs/rw_bitmaps.c
> @@ -72,15 +72,14 @@ static errcode_t write_bitmaps(ext2_filsys fs, int =
do_inode, int do_block)
>=20
> inode_nbytes =3D block_nbytes =3D 0;
> if (do_block) {
> - block_nbytes =3D EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> + block_nbytes =3D ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), =
8);
> retval =3D io_channel_alloc_buf(fs->io, 0, &block_buf);
> if (retval)
> goto errout;
> memset(block_buf, 0xff, fs->blocksize);
> }
> if (do_inode) {
> - inode_nbytes =3D (size_t)
> - ((EXT2_INODES_PER_GROUP(fs->super)+7) / 8);
> + inode_nbytes =3D ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), =
8);
> retval =3D io_channel_alloc_buf(fs->io, 0, &inode_buf);
> if (retval)
> goto errout;
> @@ -230,8 +229,8 @@ static int bitmap_tail_verify(unsigned char =
*bitmap, int first, int last)
> static errcode_t read_bitmaps_range_prepare(ext2_filsys fs, int flags)
> {
> errcode_t retval;
> - int block_nbytes =3D EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> - int inode_nbytes =3D EXT2_INODES_PER_GROUP(fs->super) / 8;
> + int block_nbytes =3D =
ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), 8);
> + int inode_nbytes =3D =
ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), 8);
> char *buf;
>=20
> EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> @@ -289,8 +288,8 @@ static errcode_t =
read_bitmaps_range_start(ext2_filsys fs, int flags,
> dgrp_t i;
> char *block_bitmap =3D 0, *inode_bitmap =3D 0;
> errcode_t retval =3D 0;
> - int block_nbytes =3D EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> - int inode_nbytes =3D EXT2_INODES_PER_GROUP(fs->super) / 8;
> + int block_nbytes =3D =
ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), 8);
> + int inode_nbytes =3D =
ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), 8);
> int csum_flag;
> unsigned int cnt;
> blk64_t blk;
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index b56d15d9..2c45d6bb 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -168,8 +168,8 @@ static void list_desc(ext2_filsys fs, int =
grp_only)
> if (ext2fs_has_feature_bigalloc(fs->super))
> units =3D _("clusters");
>=20
> - block_nbytes =3D EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> - inode_nbytes =3D EXT2_INODES_PER_GROUP(fs->super) / 8;
> + block_nbytes =3D ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), =
8);
> + inode_nbytes =3D ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), =
8);
>=20
> if (fs->block_map)
> block_bitmap =3D malloc(block_nbytes);
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index dfefca1d..ad092244 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -2088,6 +2088,7 @@ static int fix_ea_ibody_entries(ext2_extent =
imap,
>=20
> ea_magic =3D (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
> inode->i_extra_isize);
> +
> if (*ea_magic !=3D EXT2_EXT_ATTR_MAGIC)
> return 0;
>=20
> @@ -2950,7 +2951,7 @@ static errcode_t =
resize2fs_calculate_summary_stats(ext2_filsys fs)
> /*
> * First calculate the block statistics
> */
> - bitmap_buf =3D malloc(fs->blocksize);
> + bitmap_buf =3D =
malloc(ext2fs_div_ceil(fs->super->s_clusters_per_group, 8));
> if (!bitmap_buf)
> return ENOMEM;
> for (group =3D 0; group < fs->group_desc_count; group++) {
> --=20
> 2.34.1
>=20
>=20


Cheers, Andreas





