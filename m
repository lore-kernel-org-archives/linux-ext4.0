Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795409668;
	b=aGkR9bOjiSyhtAyEd9/ixu5L5gElNtsmwZf+po0u91gGUn4R+2aqKmNFGRFAbNNx2bia
	 9KyoM8SeIOfCEEiJFbLFd8BVvRO2PtkeJBvmC23SmZEXQPzWYTjbCIoGolTMmyuEwxW4J
	 CFxqUwXXQ9HZbTb4q5sdh4Rk/ummBAnqv4qqIULuBiX84yGK3R0L1MNKawp9kgf6NkejB
	 wVWdo9QYA0Nd+KMt6XRSELDvfFw9HZ+YwnB3Oq1lXg6ZPaz1kke6vjmd3XFYSfLWs+j2X
	 tTp+NXU/ZggGr8uZPsn4AGzr1ahb3Iy+S/FRU9eR/KkaBm3X9Z2+euk/Ra4Jqga3+aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795409668;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pwYSxZWHAHOgALZ1TKzXapXDJ37omnct3a2qG2VymfU=;
	b=N2r7+60lNm5JuLo3LiD2R/nNF8TU7QIaNjB26whRR1cImV65QJyYCee3fJYDLAz+whxH
	 5ODGLU+rC7mLNno6OLyw28ZOa+eurTLl7BmQiwKKRkHNdi9X5FXDGgqlxhllgUC0OYOK3
	 lgFlqShbf+6mXTfFtPiQbVrnJgIiU+4v58NJKUBVJEAuraM/cWtv3VEH1IsTTRHoeRDOw
	 FtSzjzK7jX3S/4aZbxVRl0yv07q7OVC9x7w4WvX1pIJOkREvlIOKZMtS3S6w1HCvbCgPV
	 6z+Ka0nFQFKvuRK3L/Ng5VofIYcYI3cbqy02x4hcAxo20vRxV52+l/0NvgXRxSqDEIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHrax4Vk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D956D606A332
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 04:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHrax4Vk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07BD1F000C6;
	Mon, 23 Nov 2026 04:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795409668;
	bh=pwYSxZWHAHOgALZ1TKzXapXDJ37omnct3a2qG2VymfU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OHrax4VkHdDbZtgoU5JQ8PM5InKaDdp9objkT6gYIBCEtVj0maJEz0w5/ZW+gMwe3
	 iGSHRCql8Mf7RoRKrLA0Oe17g+gOQAmxi5mKrYz/hBkTbBQ8x87BAtEXAZ66/EwRGH
	 b0O1MimWglbVI8bujLP+Rx96h6yl9UFdhIpCQL7gFQLxlVP4NLH1yuExnZ8vqFp3l1
	 iQcw+FnWB4TrOWj7BBXPIoBVWW16NM2czd7IHpDzByXqhr5LCvubcErxCia4kPZrjH
	 Zg+qJeatZG+bVl8S3cbnU5uPgKiLBnKR41XWjhWUvpDO08SejhJyV4I5y4QJT7kY95
	 zP7wzmQtwrDbA==
Message-ID: <sashiko-outbox-228677@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: Set the superblock UUID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261123044826.93953-1-flyingpeng@tencent.com>
References: <20261123044826.93953-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:54:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] ext2: integer underflow in ext2_get_inode() when s_first_ino is
  0 [1]
--

commit b9543efa7f637c4ab3ed734748dff30bc4e4d9aa
Author: Peng Hao <flyingpenghao@gmail.com>

ext2: Set the superblock UUID

This commit populates sb->s_uuid from the on-disk ext2 superblock in
ext2_fill_super() via super_set_uuid().

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 54a6c26d0388a..0c6edc68a94e2 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1010,6 +1010,7 @@ static int ext2_fill_super(struct super_block *sb, =
struct fs_context *fc)
>  	sb->s_max_links =3D EXT2_LINK_MAX;
>  	sb->s_time_min =3D S32_MIN;
>  	sb->s_time_max =3D S32_MAX;
> +	super_set_uuid(sb, es->s_uuid, sizeof(es->s_uuid));
> =20
>  	if (le32_to_cpu(es->s_rev_level) =3D=3D EXT2_GOOD_OLD_REV) {
>  		sbi->s_inode_size =3D EXT2_GOOD_OLD_INODE_SIZE;

[Severity: High]
This problem wasn't introduced by this patch, but can loading
sbi->s_first_ino from es->s_first_ino in the else branch right below cause
an integer underflow in ext2_get_inode() [1]?

fs/ext2/super.c:ext2_fill_super() {
	...
	if (le32_to_cpu(es->s_rev_level) =3D=3D EXT2_GOOD_OLD_REV) {
		sbi->s_inode_size =3D EXT2_GOOD_OLD_INODE_SIZE;
		sbi->s_first_ino =3D EXT2_GOOD_OLD_FIRST_INO;
	} else {
		sbi->s_inode_size =3D le16_to_cpu(es->s_inode_size);
		sbi->s_first_ino =3D le32_to_cpu(es->s_first_ino);
	...
}

fs/ext2/inode.c:ext2_get_inode() {
	...
	if ((ino !=3D EXT2_ROOT_INO && ino < EXT2_FIRST_INO(sb)) ||
	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
		goto Einval;

	block_group =3D (ino - 1) / EXT2_INODES_PER_GROUP(sb);
	gdp =3D ext2_get_group_desc(sb, block_group, NULL);
	...
}

If a corrupted filesystem image has es->s_first_ino =3D=3D 0 (or >=3D 0x800=
00000,
which sign-extends the signed int sbi->s_first_ino), looking up ino 0 via
open_by_handle_at() -> ext2_fh_to_dentry() -> ext2_nfs_get_inode() ->
ext2_iget() -> ext2_get_inode() passes the ino < EXT2_FIRST_INO(sb) check.
Computing ino - 1 then underflows unsigned ino_t to ULONG_MAX, triggering a
WARN(1) in ext2_get_group_desc() or reading an unintended group descriptor
if 32-bit truncation of block_group wraps below s_groups_count.

[1] https://sashiko.dev/#/bug/linux-5ea0eb49-c55e-4623-9285-ee790480d577

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123044826.9395=
3-1-flyingpeng@tencent.com?part=3D1
