Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839826;
	b=SMUTcBacTSSOpE4OW4iwkg9E5X3LlGDbnI1C6v+gueVDB7nb/dVoWu76AjK3zx9E76DC
	 aEr1sMR+dsWfMla0W0ecbSFme0xnkyR2xIMNWNzT5CGYYnkPvM/2s/f92LUrJB2rQxIrm
	 55ZtSf0LUw/M4zZHF8q/PE5Hcgwoj0bzG8Ixh7X6jcwXkyhV0hNGBO1BrJVzndpKYwnRi
	 VmSk9bPUuKfTXC5oK1Vl8N63xUU11iBeF+/SDEAczEBO738z7Sg0j4ExIt3OZms4JJlyz
	 WyMevNNhI0RErTUqCFBWODo0MKVCZ8BBevzVVoQW5XJr2cuQWRnHyFbUXFqGb0B6VDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839826;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HPCL7W4QCrWx747VewgKLeBq9vBbqSZ1CoPrkscZa/I=;
	b=bfWWsdp3c6g+Pc2outP4a4XDu8U5XAKVtxCz5xiEnhophbVwM1KDJZ80Oa2ZGYmUCl/T
	 NbcmZnArHhixWKpczhHU0lHkETMiBFtq3SWtXf/jkTWiY7ZCYlLYT8pkddyTyGbnGDgSW
	 3e59WdTj1SyN76fw4YMhj+o2yuaee4bMl7dRtD0FlqULUp7JsVHl0Ys/tAK8PuCeScUVv
	 ErwcuhhBoWf7qhLepKwobJYmm95V48HVHO9qpbI2811S25EqUN/KSiSi8Z302pEodJ+ft
	 2MN1adeks9lKMTAX/sahNuObNUVa1V1tFHRIRHuGJwv1533RW+0qh/pn95tE5a21eJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZnfAul54;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D40606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZnfAul54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5241F000C1;
	Thu,  5 Nov 2026 00:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793839825;
	bh=HPCL7W4QCrWx747VewgKLeBq9vBbqSZ1CoPrkscZa/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZnfAul54MHmakCRGN7XLkNXWU4OvCkH4BTfadY8JMEwz2cPjc5tuo4yVy05Yqsp97
	 awe6QMPN+KV8ZBxzxOvlK/QTXqtLYddicte64uMAKvlXinTZsX4NIG07QYURi+EOKn
	 HbB9+MF4z7xwtUKBZCHHtfs+2DGSrx2HYs47dgq0YPb/dK6i4AeFOoD2W0HyF3zgy2
	 M60NJNFt0h4joHiakonqkTICDxZmp5yu/2HTdTEhjD32nQDL41IAQW4Mt+4tdRMFE4
	 fZyb/TAF0YisC8tUoosBR5POqMpqCtfx6/1svW8u7t7yJ82KY+xFSn11373BxJcKI1
	 mMuOzfwNmIVSQ==
Message-ID: <sashiko-outbox-198371@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_75A7137EEE37D2E72C50F2284D95B85A6208@qq.com>
References: <sashiko-outbox-197106@kernel.org>
 <tencent_75A7137EEE37D2E72C50F2284D95B85A6208@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 00:50:24 +0000
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
- [High] ext4: incomplete bh2 alias check in ext4_dx_add_entry() index split
--

commit 24061820362e4d33d4d9d2657a26970aa2569b92
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This commit adds buffer_head aliasing checks in make_indexed_dir(),
ext4_dx_add_entry(), and do_split() to prevent directory and htree index
blocks from aliasing each other when allocating or reading blocks on a
filesystem with a corrupted block bitmap.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..79f7f0073d9da 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -2549,6 +2597,18 @@ static int ext4_dx_add_entry(handle_t *handle, str=
uct ext4_filename *fname,
>  			err =3D PTR_ERR(bh2);
>  			goto cleanup;
>  		}
> +		for (f =3D frames; f <=3D frame; f++) {
> +			if (bh2 =3D=3D f->bh)
> +				break;
> +		}
> +		if (f <=3D frame || bh2 =3D=3D bh) {
> +			ext4_error_inode_block(dir, bh2->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "cannot split aliased index block");
> +			brelse(bh2);
> +			err =3D -EFSCORRUPTED;
> +			goto cleanup;
> +		}

[Severity: High]
As reported by Sashiko on v5 [1], in ext4_dx_add_entry() in fs/ext4/namei.c,
when the leaf index block is full and an ancestor index block is also full,
the preceding loop walks up the htree and decrements frame:

	if (dx_get_count(entries) =3D=3D dx_get_limit(entries)) {
		ext4_lblk_t newblock;
		int levels =3D frame - frames + 1;
		...
		while (frame > frames) {
			if (dx_get_count((frame - 1)->entries) <
			    dx_get_limit((frame - 1)->entries)) {
				add_level =3D 0;
				break;
			}
			frame--; /* split higher index block */
			at =3D frame->at;
			entries =3D frame->entries;
			restart =3D 1;
		}

By the time ext4_append() allocates bh2, frame may point to frames[0] (or an
intermediate frame) while the lower-level index blocks in
frames[(frame - frames) + 1 .. levels - 1] remain active in the htree and h=
eld
in frames[] until dx_release(frames) runs at cleanup.

Because the alias check loop bounds f by frame rather than
frames + levels - 1 (and testing f < frames + levels), can bh2 alias one of
those skipped lower-level index frames (such as frames[1].bh when splitting
the root index)? If so, wouldn't the subsequent memset and memcpy into
node2 overwrite the active lower index buffer in place and create a cycle in
the htree before jumping to again?

[1] https://lore.kernel.org/r/tencent_4EAEF2024D7BB83D62E41306EED8D2112C08@=
qq.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_75A7137EEE3=
7D2E72C50F2284D95B85A6208@qq.com?part=3D1
