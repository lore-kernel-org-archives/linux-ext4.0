Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657427;
	b=cusr4sN8ppEiu8nlROsUHhpqE6+VVvedNb4prijkI9DxPPqK0w1GP4YnRO3mUXXArHt/
	 MqFETAYi6mvDDMFEuQoCjkoipis4WD18qVi9yzrZ9vg6smOk/4fHvCsZ2RHymjxI6zA1X
	 zxOs314qBW+LLwzhOuDNFEOGUoJoPpKPb/oWmXAJRLQsAP8FmXU9X8JaEsv3/rnDnq6m8
	 4vQNhdAFq38y9XegUzDB8f3r6/BshzDYxLt0cj171i62zRqM76Bl7lHQws33xn4cPUBFj
	 n9BzYxKbyJsDXSuBo/bERcp/vM7wPQ6Pz4kjbdUOYyHj5kSlwykUEXQ+lb9At2iQSFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657427;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Content-Type:
	 Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=mVbYNGcEKVi2Ryiv8CDqgNXOLHmXsJsrIxCit/L/4J0=;
	b=GHwm+U0uajRIoEEiE1PtdSpTYTfF6vjFfdvKScIZ1xvcp/fE3xlru0sBEB7wEO/m+8tk
	 epw9EyufBx0m4Wd6yPFglQcac3FdRmdhKu2by7rLnR5n4Fok9TOdCC79nUcwJIRgTv0mA
	 YGlQAYzrJYSByFcl5cQIUtMY/beov4aSOmNemsxHvvTBJKDyBAZiAZYjA4eL+2TwxWlhv
	 sfWy0OLYCJ7JMWwQ+IBtL7IDWtzjXFzF9q8894MJbpy7fmZ/65wyTHdjZvzYuW2ckiVB5
	 81894oBXGJmlXjxVw64lYSF7JldujiCpMjbgSN/bJth5dJWx+q/hftA3Gh2nUVR6ahg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dilger.ca;
	spf=pass smtp.mailfrom=dilger.ca;
	dkim=pass header.d=dilger-ca.20260707.gappssmtp.com header.i=@dilger-ca.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PJa8cTbZ;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D73606A329
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 22:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8D73606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dilger-ca.20260707.gappssmtp.com header.i=@dilger-ca.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PJa8cTbZ
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e95bd1c14cso32053935ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2026 14:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20260707.gappssmtp.com; s=20260707; t=1793657425; x=1794262225; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mVbYNGcEKVi2Ryiv8CDqgNXOLHmXsJsrIxCit/L/4J0=;
        b=PJa8cTbZfleI4DErsiJ4xwCm1ztzwfNbaCMymQZmXSAmjJ4J0bqourlRY9o6TkV32Y
         K3BH/oqbHE1m1wwcDist9Js/iZtxXU2YRoDK0sDGFMeR+u8D3v5ZOVZ7cEL4B0D1+3iY
         DAyBjnMZdgMO5e7XbKWfmyHFr4LG9Lx5i/PuOcLA6b+RYA9lzn2/qVzqVYHSt6cNT6wE
         GH6QYYSd/gSy2TGyV8pDwZqLVp7wnZ/ygvAFKT/8u4VLvr2aqi9pO39Ug0BzSNYfjAVy
         y5xCvxBbLwazBoH+802drvNe1COuO7PLyDjcBQmS2wc7pPd1GLZZW5F/UzGHCOfmKs0w
         j5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793657425; x=1794262225;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mVbYNGcEKVi2Ryiv8CDqgNXOLHmXsJsrIxCit/L/4J0=;
        b=jJmU00qa/SnzcJbz62IZ8J8wK70NOqsnQQyXNkpVbvxgZRCjHcWistRdIacsy1pWc9
         hy08Vm+r7Lh3jXkqeQEZakhvmI9MwskmU56IVX2h4XYY8gyLGhWfYZLbI7g6PQwqploN
         138jV+QGXnxVPYTrngR4DpJk6LaTflZugxzP0cz19KkqJQ2PQleGDynJGze1vE17chlj
         AGP8IdNacQCiqLOrVkN+V5nL4SuCycSFM8mB6RwRxwCsiozuE5T4Re7REcxm69AzEBxB
         djoA6+q/NQ2IX1kBo1HXHRi6qK5PAj5XY/Cp/izluTM97vZAcukiaqGbpJS/sKJoEkZz
         V7Qg==
X-Gm-Message-State: APuU4Z8oCwEd4S2/f64unPXzh9dEKF8FOVAZvTSipmWYGMa+vj5Tv1w2
	onyFuRh6aFEZhDQlLkfqSNdcqYsNCaH3bfY8Ox15cmAYMQkEnGnE4S3NXhSE2PGPC5g=
X-Gm-Gg: AYBFou0pxlFBj6YxzDLGE+cZbn3HeJ98P6SH5IAT7H7w6u6lQV4vYAIhwCBT/IKUQmD
	aFOkMDpFOtYUtyRopLlVzMl75/kctFGRD8fZsi2ZjJ2DqMrb+qWUjrvvUX4/67mU+qog+vry6uq
	ahqNPrpitybRLdKHnmnY1IbWMb53W8t7AWWrwOyg/Z+8Mnh3pOLu3a6QHhLyWFcTIABLog2z013
	PNIrpp0khgMep6Pqw8OH9Hh9EdjX7Pjdw57vzYx+9b7GU6CHPyiLCpWEXaze0uwPYB78DWsJUkk
	A7bYw5rfjnQxQjjY2QT0+QDbkXdGJ7ZJzYc4u8TPnuG0AcOsFBmMjBm/E0kvNtyhUpeJlnv+p0W
	K90cgMSDum80fj8+pc36Iv2UAdpHSq7qUiBvrNmc6RzRlyJYljmD6G6zXwElOb5tfosFL+QxeMW
	pIP3CHnuAfA3qvK1/nJE4L7b2vC2jcQLy3mprRTc0/jyOb15TEU6XqdBjSota4nIdS9BSWi5AuL
	AevEYCMPykO1t5H6PqcIllgn+DcwAVvDPWPhq0Jnc+ZTQOQoNV8acgkUPSG0QBnL09tILXf8Ag8
	lgdUJjDe8nRUx2845ZEgzUfBcFAB7a9E/pFIe8ElQ39sqNLiSwvUpAB6S8KSv0oeBA1q/hMXCV0
	cEMBC3jU=
X-Received: by 2002:a17:902:ce81:b0:2ea:dacd:1663 with SMTP id d9443c01a7336-2eb364f23a4mr119485125ad.47.1793657425228;
        Mon, 02 Nov 2026 14:10:25 -0800 (PST)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [24.64.171.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39247e32sm32583445ad.27.2026.11.02.14.10.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Nov 2026 14:10:24 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: [PATCH] ext4: reject impossible group free cluster counts
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20261102042428.65204-1-zhaogongyi@bytedance.com>
Date: Mon, 2 Nov 2026 16:10:13 -0600
Cc: linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 libaokun@linux.alibaba.com,
 jack@suse.cz,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 yi.zhang@huawei.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F238B62D-6BED-4D64-B099-B956B820BA44@dilger.ca>
References: <20261102042428.65204-1-zhaogongyi@bytedance.com>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Mailer: Apple Mail (2.3864.700.51.1.3)


On Nov 1, 2026, at 22:24, Zhao Gongyi <zhaogongyi@bytedance.com> wrote:
>=20
> ext4_count_free_clusters() initializes global free-space accounting =
from
> group descriptors. A corrupt bigalloc image advertises 201327130 free
> clusters in a 32-cluster group. The mount succeeds and delayed
> allocation later sees an impossible free-space total.
>=20
> Reject counts above the group's cluster capacity during descriptor
> validation. Reuse the existing capacity calculation so bigalloc and
> short final groups use the same bound as the block bitmap.
>=20
> Journal replay can overwrite a descriptor after the initial check. A
> crafted transaction changes a valid count to 32769 in a 32768-cluster
> group; a pre-replay-only check lets both read-only and read-write =
mounts
> succeed. Recheck after recovery, before initializing free-space
> counters. Limit the second scan to mounts needing recovery.
>=20
> Apply the bound to read-only mounts too, since they use the descriptor
> count for in-memory accounting.
>=20
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>

I think a lot of this class of bug could be avoided by doing very =
minimal
checks on the group descriptors initially (and other metadata, enough to
load and validate the journal inode itself is sane). The journal inode =
is
otherwise read-only so its allocations should never be modified.  Then
replaying the journal if it is dirty, and restarting the superblock/GDT
checks from the beginning to validate the _current_ blocks are sane.

That should only be done once per mount. To keep sanity after checks, we
could validate the journal never contains updates to its own inode (or =
at
least not until an SMR "wandering journal/log structure" feature =
exists).=20

Cheers, Andreas

> ---
> fs/ext4/balloc.c | 10 +++++-----
> fs/ext4/ext4.h   |  2 ++
> fs/ext4/super.c  | 38 ++++++++++++++++++++++++++++++++++++++
> 3 files changed, 45 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 778fe87..0f36630 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -159,8 +159,8 @@ static unsigned ext4_num_overhead_clusters(struct =
super_block *sb,
> return num_clusters;
> }
>=20
> -static unsigned int num_clusters_in_group(struct super_block *sb,
> -  ext4_group_t block_group)
> +unsigned int ext4_num_clusters_in_group(struct super_block *sb,
> + ext4_group_t block_group)
> {
> unsigned int blocks;
>=20
> @@ -228,7 +228,7 @@ static int ext4_init_block_bitmap(struct =
super_block *sb,
> * the blocksize * 8 ( which is the size of bitmap ), set rest
> * of the block bitmap to 1
> */
> - ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
> + ext4_mark_bitmap_end(ext4_num_clusters_in_group(sb, block_group),
>     sb->s_blocksize * 8, bh->b_data);
> return 0;
> }
> @@ -240,7 +240,7 @@ unsigned ext4_free_clusters_after_init(struct =
super_block *sb,
>       ext4_group_t block_group,
>       struct ext4_group_desc *gdp)
> {
> - return num_clusters_in_group(sb, block_group) -
> + return ext4_num_clusters_in_group(sb, block_group) -
> ext4_num_overhead_clusters(sb, block_group, gdp);
> }
>=20
> @@ -313,7 +313,7 @@ static ext4_fsblk_t =
ext4_valid_block_bitmap_padding(struct super_block *sb,
> {
> ext4_grpblk_t next_zero_bit;
> unsigned long bitmap_size =3D sb->s_blocksize * 8;
> - unsigned int offset =3D num_clusters_in_group(sb, block_group);
> + unsigned int offset =3D ext4_num_clusters_in_group(sb, block_group);
>=20
> if (bitmap_size <=3D offset)
> return 0;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8d3af06..3956545 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3468,6 +3468,8 @@ extern ext4_fsblk_t ext4_inode_bitmap(struct =
super_block *sb,
>      struct ext4_group_desc *bg);
> extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
>     struct ext4_group_desc *bg);
> +unsigned int ext4_num_clusters_in_group(struct super_block *sb,
> + ext4_group_t block_group);
> extern __u32 ext4_free_group_clusters(struct super_block *sb,
>      struct ext4_group_desc *bg);
> extern __u32 ext4_free_inodes_count(struct super_block *sb,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7d8aedf..83e4ef6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3355,6 +3355,36 @@ void ext4_group_desc_csum_set(struct =
super_block *sb, __u32 block_group,
> gdp->bg_checksum =3D ext4_group_desc_csum(sb, block_group, gdp);
> }
>=20
> +static bool ext4_check_group_free_clusters(struct super_block *sb,
> +   ext4_group_t group,
> +  struct ext4_group_desc *gdp)
> +{
> + unsigned int free_clusters =3D ext4_free_group_clusters(sb, gdp);
> + unsigned int group_clusters =3D ext4_num_clusters_in_group(sb, =
group);
> +
> + if (free_clusters > group_clusters) {
> + ext4_msg(sb, KERN_ERR,
> + "%s: group %u has invalid free clusters count %u > %u",
> + __func__, group, free_clusters, group_clusters);
> + return false;
> + }
> + return true;
> +}
> +
> +static int ext4_check_replayed_free_clusters(struct super_block *sb)
> +{
> + struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> + ext4_group_t group;
> +
> + for (group =3D 0; group < sbi->s_groups_count; group++) {
> + struct ext4_group_desc *gdp =3D ext4_get_group_desc(sb, group, =
NULL);
> +
> + if (!ext4_check_group_free_clusters(sb, group, gdp))
> + return -EFSCORRUPTED;
> + }
> + return 0;
> +}
> +
> /* Called at mount-time, super-block is locked */
> static int ext4_check_descriptors(struct super_block *sb,
>  ext4_fsblk_t sb_block,
> @@ -3467,6 +3497,8 @@ static int ext4_check_descriptors(struct =
super_block *sb,
> }
> }
> ext4_unlock_group(sb, i);
> + if (!ext4_check_group_free_clusters(sb, i, gdp))
> + return 0;
> if (!flexbg_flag)
> first_block +=3D EXT4_BLOCKS_PER_GROUP(sb);
> }
> @@ -5567,6 +5599,12 @@ static int __ext4_fill_super(struct fs_context =
*fc, struct super_block *sb)
> err =3D ext4_load_and_init_journal(sb, es, ctx);
> if (err)
> goto failed_mount3a;
> + /* Journal replay may change descriptors after the initial check. */
> + if (needs_recovery) {
> + err =3D ext4_check_replayed_free_clusters(sb);
> + if (err)
> + goto failed_mount_wq;
> + }
> if (bdev_read_only(sb->s_bdev))
>    needs_recovery =3D 0;
> } else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&
>=20
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
> --=20
> 2.39.5 (Apple Git-154)


Cheers, Andreas





