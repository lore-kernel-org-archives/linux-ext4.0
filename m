Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A4B43F4C2
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702115; cv=none; b=kt4ndKf+RYjdoJzNkV8N15QsnltKRzXsbeVkrYfM6bmlGmq8+2cEU7/8nggfHKmpVZBf55Ajb6p7u6dkpNois/bXqQJyXj78nse6QHe3e9tMIxahbbGuBDntPXpMP3KQOYAF2xoNBdLldRaLC5m2pwXTJJrgFjpdPVMqjV4XU6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702115; c=relaxed/simple;
	bh=woPczuYk/hshaGxskqxSq2iAiK31Wzlgs3ArIYMxLVk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SoCX6uwoNbJ+srCDZ7bKAJ/HCJZKpDaGMwrtepP1K0HFGK/Hf4DACxVd8fiSDHDyn+H6k1g9ERLbr0WBI3dwO35VcpKz4OOpypWzW081w6E9MtsrCHzn5IPSZWGiNszUAsjxiDfFM0EUnxJQ7NLLH2snS/pjwZyYqau+dMwJb1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqYfKqqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqYfKqqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBB31F00A3A;
	Fri, 14 Aug 2026 10:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702096;
	bh=S2QqCrIrS+9VmUMKY+w2ngaYf47iQE3bKiU9/ket/wA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IqYfKqqb3brbdpZ429G0cRX4I1BCJhK7R3oC3UARNDfYZEpOFKLm6PwpX6OjHwnGb
	 UzjEWIRIqU9Y2XkBtGL+s/rgA7OR5BYpHdoufVfNGtJjM0EGdZa0LvoViqecEGhrxW
	 DNyKMiC6RiCPkPuVWzFCSfzCvvGTqClRpQ3D99Ha+WwuFnycKsZvcXednrvJ4pumDx
	 mQDDlq9p5snikc2UUKfvM+ZMRG10/Nrb6VZe3aO8OpjndhkTHmhD3yDxOvgVpMrHWy
	 o5/wgHAWeR9v/kZF5evE1nid7w83iuueZ1QFxeEQCMaJtyo8EKjHJ6/+eBNhGhi+UQ
	 M0qwPW3uEFkOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 05/32] ext4: set EXT4_MAP_NEW flag for delayed
 allocated blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-6-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-6-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:08:15 +0000
Message-Id: <20260814100816.4BBB31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The newly introduced EXT4_MAP_NEW flag is completely ignored by it=
s only caller, rendering the patch ineffective (dead code) and failing to r=
esolve the underlying bug.
--

--- Patch [5]: [PATCH -next v5 05/32] ext4: set EXT4_MAP_NEW flag for delay=
ed allocated blocks ---
commit f71e7357d8a5fa9c83f4d4fc004cfa3640d60291
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: set EXT4_MAP_NEW flag for delayed allocated blocks

This commit sets the EXT4_MAP_NEW flag in ext4_da_map_blocks() to indicate
when a new delayed allocation block has been inserted. This aims to allow
callers to distinguish newly created delayed extents from existing ones.

Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f9555=
d7@huaweicloud.com/

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7601fe3618b1f..9dbece14ae569 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1990,7 +1990,7 @@ static int ext4_da_map_blocks(struct inode *inode, =
struct ext4_map_blocks *map)
>  		}
>  	}
> =20
> -	map->m_flags |=3D EXT4_MAP_DELAYED;
> +	map->m_flags |=3D EXT4_MAP_DELAYED | EXT4_MAP_NEW;

[Severity: High]
Does this code actually allow callers to use the newly added flag?

Looking at ext4_da_get_block_prep(), which calls ext4_da_map_blocks(),
it unconditionally intercepts EXT4_MAP_DELAYED, sets BH_New, and returns
early without checking EXT4_MAP_NEW:

fs/ext4/inode.c:ext4_da_get_block_prep() {
    ...
	if (map.m_flags & EXT4_MAP_DELAYED) {
		map_bh(bh, inode->i_sb, invalid_block);
		set_buffer_new(bh);
		set_buffer_delay(bh);
		return 0;
	}
    ...
}

Because EXT4_MAP_DELAYED is always set alongside EXT4_MAP_NEW, this branch =
is
always taken, and set_buffer_new(bh) is unconditionally called. The code ne=
ver
seems to evaluate map.m_flags & EXT4_MAP_NEW.

Is it possible this patch is incomplete and the underlying issue remains
unfixed because the new flag is ignored?

>  	retval =3D ext4_insert_delayed_blocks(inode, map->m_lblk, map->m_len);
>  	if (!retval)
>  		map->m_seq =3D READ_ONCE(EXT4_I(inode)->i_es_seq);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D5
