Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793594336;
	b=twveHbjxCKbT1jgo0ALpwZ0zjGERhEdtUGLiKp30ZW4sqL7k4Cn2yKoPUFkRPmpMwJ1m
	 w1HQCjxeL/GI253Q99hRLWX1qyectaQE4LsJK4F0mvGZCDh6+H5tIKbSP5gZTJAHoGo+7
	 Sx5EhY8GYfxlgzh6sP1rkkQP0rDpT5khwjlicO54+VMCRfeHP8WHT1hQ/J+bHIjBaIDKA
	 SptSJxqe+Rr3WM06mKpG7ZEmyNxDqRVBQkEnamkWWAdQo7ctfqjNLlnVN3ma8eMu7IlIC
	 zH6LO7sQt10UlYPffsjoZ+M1FKdBcz/e4297A28Iq56kIBv0W27zLJz2+m/YN+5tRDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793594336;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Qy+xVR3pJ/TomO9AIO8Xn6TZWFiR1xrx8gjLY2J3ZmE=;
	b=YPgiOXzfroYB2sDjCafJibeATbfkQz12p5C+Mo1E9IoJ9Cf76wW5rZzEyO4IK6cb/0mT
	 sy7rU04g1qF+LKGikcmfVvoQ8bciL0wDnYZ7CJFLQ841WGA4mQcopT64HSLrlKq3ez1AI
	 VKHnUeI16YSuZJznBwtNN8mIzZjWyfCSXInreBY630rNExwZt9DNA8hCTpp2M1RhTt7rX
	 1FKomWJq08/MaUgDw9+Jd8yOxmkjC3J0osyc0kSduYEq9ALpxB+d5JDElxV1Z8QI0B0ue
	 MH6/QLJQOnSBvt5dgS9ZPX7/bZIREYdT1SyPdpDtjiem3vI5q3g08y1JQ+qT95twqkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlehNi4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55873606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlehNi4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3281F000C1;
	Mon,  2 Nov 2026 04:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793594336;
	bh=Qy+xVR3pJ/TomO9AIO8Xn6TZWFiR1xrx8gjLY2J3ZmE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nlehNi4mFLPVEDDBNECple19AzFKtKsxred/TAWBsnGMssehIn7XkmQtXCViQzvfW
	 D9i6QA9VDmvodUq4hjO+tnm4QUIBm1+uV38fEU7q0sER+KW14gP7ZlCv5jsgS8JDBh
	 nZGulEVcxObzFMvcoI8I6/6rfA3VcN0ZW3frBpaItNd8mlgE8lh7FKsx4D4zjrli3F
	 uLknTXvyrU3ucmPJfVcLqu9tAXmX51Pj/Mkx6/vDqMMDri6+GXsxlIqFDWO2ZjfBDW
	 O/LIg67Z5BHuLrO899RQuvW7p54qojm/MXyQyOEy51NDS3aCmgfSXENNX869vMJcwy
	 zFsjHeXu+4q8g==
Message-ID: <sashiko-outbox-192904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: reject impossible group free cluster counts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261102042428.65204-1-zhaogongyi@bytedance.com>
References: <20261102042428.65204-1-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 04:38:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: journal replay bypasses ext4_check_replayed_free_clusters()
--

commit 57978228cd9b85af900a61d55a732ad888e33b8c
Author: Zhao Gongyi <zhaogongyi@bytedance.com>

ext4: reject impossible group free cluster counts

This commit rejects group descriptor free cluster counts that exceed the
group's cluster capacity during mount-time descriptor validation, and
rechecks the free cluster counts after journal replay when recovery is
needed.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7d8aedfbbb87f..b7dd1d4a3b179 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3355,6 +3355,36 @@ void ext4_group_desc_csum_set(struct super_block *=
sb, __u32 block_group,
>  	gdp->bg_checksum =3D ext4_group_desc_csum(sb, block_group, gdp);
>  }
> =20
> +static bool ext4_check_group_free_clusters(struct super_block *sb,
> +					   ext4_group_t group,
> +					  struct ext4_group_desc *gdp)
> +{
> +	unsigned int free_clusters =3D ext4_free_group_clusters(sb, gdp);
> +	unsigned int group_clusters =3D ext4_num_clusters_in_group(sb, group);
> +
> +	if (free_clusters > group_clusters) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "%s: group %u has invalid free clusters count %u > %u",
> +			 __func__, group, free_clusters, group_clusters);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static int ext4_check_replayed_free_clusters(struct super_block *sb)
> +{
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	ext4_group_t group;
> +
> +	for (group =3D 0; group < sbi->s_groups_count; group++) {
> +		struct ext4_group_desc *gdp =3D ext4_get_group_desc(sb, group, NULL);
> +
> +		if (!ext4_check_group_free_clusters(sb, group, gdp))
> +			return -EFSCORRUPTED;
> +	}
> +	return 0;
> +}

[ ... ]

> @@ -5567,6 +5599,12 @@ static int __ext4_fill_super(struct fs_context *fc=
, struct super_block *sb)
>  		err =3D ext4_load_and_init_journal(sb, es, ctx);
>  		if (err)
>  			goto failed_mount3a;
> +		/* Journal replay may change descriptors after the initial check. */
> +		if (needs_recovery) {
> +			err =3D ext4_check_replayed_free_clusters(sb);
> +			if (err)
> +				goto failed_mount_wq;
> +		}

[Severity: High]
Can a journal transaction that replays both the superblock buffer and a
group descriptor buffer bypass ext4_check_replayed_free_clusters()?

During __ext4_fill_super(), ext4_check_geometry() and
ext4_group_desc_init() -> ext4_check_descriptors() validate the initial
superblock and group descriptors before journal recovery. Next,
ext4_load_and_init_journal() -> ext4_load_journal() ->
jbd2_journal_load() -> jbd2_journal_recover() -> jbd2_do_replay() replays
journal blocks into the block device buffer cache.

Because sbi->s_es points directly into sbi->s_sbh->b_data, a journal
transaction containing logical_sb_block can overwrite s_blocks_count_lo,
s_blocks_count_hi, and s_first_data_block in sbi->s_es (ext4_load_journal()
only saves and restores the EXT4_S_ERR_START..EXT4_S_ERR_END range).

When ext4_check_replayed_free_clusters() subsequently calls
ext4_check_group_free_clusters() -> ext4_num_clusters_in_group() for the
final block group:

fs/ext4/balloc.c:ext4_num_clusters_in_group() {
	if (block_group =3D=3D ext4_get_groups_count(sb) - 1) {
		blocks =3D ext4_blocks_count(EXT4_SB(sb)->s_es) -
			ext4_group_first_block_no(sb, block_group);
	} else
		blocks =3D EXT4_BLOCKS_PER_GROUP(sb);
	return EXT4_NUM_B2C(EXT4_SB(sb), blocks);
}

blocks is computed from the live, unvalidated sbi->s_es buffer. If the
replayed s_blocks_count is smaller than ext4_group_first_block_no(sb,
block_group), the unsigned int blocks calculation underflows to near
UINT_MAX; if larger, blocks can exceed EXT4_BLOCKS_PER_GROUP(sb).
EXT4_NUM_B2C() then returns an inflated group_clusters upper bound, allowing
an impossible replayed bg_free_blocks_count to pass the free_clusters <=3D
group_clusters check and corrupt in-memory free-cluster accounting as well
as bitmap initialization in ext4_init_block_bitmap() and
ext4_valid_block_bitmap_padding().

In addition, only calling ext4_check_replayed_free_clusters() after
recovery leaves any replayed changes to bg_block_bitmap, bg_inode_bitmap,
bg_inode_table, bg_checksum, and bg_flags (EXT4_BG_INODE_ZEROED for
first_not_zeroed) unvalidated. Should superblock geometry and full group
descriptors via ext4_check_descriptors() be revalidated after journal
replay instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102042428.6520=
4-1-zhaogongyi@bytedance.com?part=3D1
