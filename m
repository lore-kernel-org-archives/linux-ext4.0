Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020220;
	b=Y7glq70+0qbm19CMUqssLlIdj5IUJ24avoiBjcv4JJ48I6/ez9JXRQmBUZvnlZuGjvUk
	 OlazQNef2zwIq3HTx8/8e10wYxuuSXbreTVoStBcgg7UPGHF7YiGo43OpLZe2atUjvekB
	 9CL4HlRYSfHntFOP7x6iqw6k0oQgwsdQI/sVHU9KMJaoSNtCeQ2AffpSKbPePvwS/F/5I
	 snEC8EbFzEpu3UgnQao9gZ7J4SyntQlx4JlXDAIJvmYOoVikMT3MmytTbGE8lWnZ9B/u2
	 KY4skj5EqecStughwLhYgolGfUuxGhEmRtes+PKCd9MqT1Y75Xvsum/YzdTw+yMyarw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020220;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ITFAyJ525IUZE3se9RMM+6u+nYO5qRtNtzAq7jowC+4=;
	b=PsqcrvjhiqJoy8nC68meXBnjN9m5zl4dsEKcE/mZPh+H2c61VaT67a6zosS+ybDy6OIi
	 OHTWkCoRy+SYRkx1WiZh6GYeIZuLLsp5CYno2/pe9FBCuRtO5pepfKlnbE77fq2s/SdEf
	 fl8/+YSKhUiWWfU6XOQz9/M64asOflahRNbn2Nz/vlrhWXy+HL/N0nRSFR/KFJ3V+IdqY
	 h2OYeYZB6OpIPw4Bra9nDeN+oj+C6T+AobgbF4NclzjoFlvi6zLqlO8/ycunFYYD6xBER
	 yVYO2oOhVjKuF/3WjVP+4mnjj4JN5RLToAhBXlQ5Hv8eEBzFBDSvP7sZjAwPWjq7ODQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3vDzGe6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9224D606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3vDzGe6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D821F01828;
	Mon, 26 Oct 2026 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020220;
	bh=ITFAyJ525IUZE3se9RMM+6u+nYO5qRtNtzAq7jowC+4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h3vDzGe6MoHx2UwWFNJUNatSzWHe+Lsnle0RBJ6m3HuBFcuAUyIwotOE/pzl+wvYv
	 n/JIuZv3BcW+KR4pU9L9u8vCZCx2LCUs7hCQwl7FDNyfWqBuKowxFmlGmhJFN8BfnO
	 uHAchZ/PIY/blPUBiKYgxzclF+2iDU2vF1xoyHt2GKJEi+MYQilklt6EY1gOkASLsT
	 +RQBsbp7nL2be6ArzCuP7z8eEaflrxOAd/Y+qoqNYDaN5NY8uy5Mu8odElMqA4kt+y
	 223QHHTWuqaj/uQzLSHuHol2SXVHAkEK9y+Al99gpIJqxgNSkXv3+citXmXKVMD9+y
	 BWfUUqaqBjZPA==
Message-ID: <sashiko-outbox-185275@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] ext4: add inode to orphan list before extent
 conversion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261026115131.1735014-4-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
 <20261026115131.1735014-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 13:10:19 +0000
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
- [High] ext4: silent false success on ENOSPC retry in ext4_alloc_file_bloc=
ks()
--

commit af54a86e4faf105f27b9869fc053a46b111dbda1
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: add inode to orphan list before extent conversion

This commit moves the ext4_orphan_add() call in ext4_alloc_file_blocks()
before ext4_convert_unwritten_extents() so that transaction restarts during
extent conversion do not leave written extents beyond i_disksize uncovered =
by
the orphan list. It also adjusts the post-conversion progress and cleanup
handling when conversion fails before converting any blocks.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7193429a05e1f..677749f0c9c68 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4701,6 +4701,23 @@ static int ext4_alloc_file_blocks(struct file *fil=
e, loff_t offset, loff_t len,
>  				break;
>  			}
> =20
> +			/*
> +			 * Add the inode to the orphan list before the
> +			 * conversion, as it may restart the transaction and
> +			 * commit the extents converted so far.  Written
> +			 * extents must stay covered by the orphan list until
> +			 * i_disksize catches up.
> +			 */
> +			if (new_size) {
> +				ret2 =3D ext4_orphan_add(handle, inode);
> +				orphan =3D true;
> +				if (unlikely(ret2)) {
> +					ret =3D ret2;
> +					ext4_journal_stop(handle);
> +					break;
> +				}
> +			}
> +
>  			ret =3D ext4_convert_unwritten_extents(handle,
>  					inode, (loff_t)map.m_lblk << blkbits,
>  					(loff_t)map.m_len << blkbits,
> @@ -4708,23 +4725,19 @@ static int ext4_alloc_file_blocks(struct file *fi=
le, loff_t offset, loff_t len,
>  			if (ret)
>  				map.m_len =3D converted;
> =20
> -			/*
> -			 * If blocks beyond i_disksize are converted, add
> -			 * the inode to the orphan list and advance the epos.
> -			 */
> -			if (new_size && converted) {
> -				ret2 =3D ext4_orphan_add(handle, inode);
> -				ret =3D ret ? ret : ret2;
> -				orphan =3D true;
> -			}
> -
>  			ret3 =3D ext4_journal_stop(handle);
>  			ret =3D ret ? ret : ret3;
>  		}
> =20
> -		map.m_lblk +=3D map.m_len;
> -		map.m_len =3D len_lblk =3D len_lblk - map.m_len;
> -		epos =3D EXT4_LBLK_TO_B(inode, map.m_lblk);
> +		/*
> +		 * The conversion may have failed without converting
> +		 * anything.
> +		 */
> +		if (map.m_len) {
> +			map.m_lblk +=3D map.m_len;
> +			map.m_len =3D len_lblk =3D len_lblk - map.m_len;
> +			epos =3D EXT4_LBLK_TO_B(inode, map.m_lblk);
> +		}
>  		if (ret)
>  			break;
>  	}
> @@ -4732,12 +4745,13 @@ static int ext4_alloc_file_blocks(struct file *fi=
le, loff_t offset, loff_t len,
>  	if (ret =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries=
))
>  		goto retry;

[Severity: High]
What happens on the goto retry path if ext4_convert_unwritten_extents() fai=
ls
with -ENOSPC and converted =3D=3D 0?

When ret is non-zero and converted is 0, map.m_len is set to 0:

	if (ret)
		map.m_len =3D converted;

Previously, map.m_len =3D len_lblk =3D len_lblk - map.m_len ran uncondition=
ally,
which restored map.m_len to len_lblk when map.m_len was 0. With that update
now guarded by if (map.m_len), map.m_len remains 0 while len_lblk > 0.

If ret =3D=3D -ENOSPC and ext4_should_retry_alloc() returns true, jumping to
retry calls ext4_map_blocks() with map.m_len =3D=3D 0:

fs/ext4/extents.c:ext4_alloc_file_blocks() {
	...
	while (len_lblk) {
		...
		ret =3D ext4_map_blocks(handle, inode, &map, flags);
		if (ret <=3D 0) {
			...
			ext4_mark_inode_dirty(handle, inode);
			ext4_journal_stop(handle);
			break;
		}
}

Because map.m_lblk already maps to the unwritten extent allocated before the
retry, both the extent status tree lookup in ext4_map_blocks() and
ext4_ext_handle_unwritten_extents() clamp the returned block count to
map.m_len (0). That causes ext4_map_blocks() to return 0, breaking out of t=
he
loop with ret =3D=3D 0 and silently returning success to the caller without
converting the unwritten extent or finishing the remaining allocation.

Should map.m_len be reset to len_lblk when map.m_len is 0 (or before jumping
to retry)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026115131.1735=
014-1-yi.zhang@huaweicloud.com?part=3D3
