Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795417812;
	b=OSEPRFPwRDV72FxtmqzNg5BaeEwtgRVcW6OUswgd8GkBWCd4iglH2zqB8FOWG5ci73tM
	 Nka0PiPEY9JuJNfv9FgpgKWsgAC9hdTVzxAXmnXI5LP7eJsyQRAj1DfPKHUa/+deC4u1o
	 hBOiT8VyuIPc9Iw9JkwLLWW5ZaRfs9cESDx7sRxFU83Pajn5DoyGlPC5DyNQby/pw3hIl
	 KySn0UYnLE+a61QOyeIaSZL7OP9+zQ8K8+Gvmh8K7LohZCNSaiFZYPj3B+WbGZ5RQAcjb
	 3ev3GJLXzICcVWZw5sou+E1c50UcHOrmx2PHsr/5Mk6cRuPk1SAZT0t3a8HfpxVGydQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795417812;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cIzuGK6KlVOOqNlghPQXp3KsnAzmYLmzFR9ZB01yW9o=;
	b=EVPO7aT/aMV34+eYbeTKNN9vgMb5T8HpRY6ykHAkuLlmchBNsCWIR9cHi+vxKfT/GRqe
	 I2vnaSzUSVyIR0wOQKginiC0GLR0dcpmL5ZVeb91ITPwb+UZtseV0HjKIlYTwDwAO8uGD
	 vcepaGd2nFj1Y6hyW2ZmtVoUJd+28YgrdOdvAYyPS0QYb2pEX/EzrjSnZJV1MNi7nJRTl
	 PwSNPZ9HIvfAX/6T3CcAfdvtQHZXHdkGGbC/TLJZd8AAlGihbx3Z6vlvpktFzxgmlb+9z
	 WmCttTfFvc8cH4gasGvKsHtgv4pWOAj+6uGVqXUchkG6MMu8ouN0k0CNb6NkDRmO9CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGEfHCsA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D79606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 07:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGEfHCsA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638621F000CA;
	Mon, 23 Nov 2026 07:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795417811;
	bh=cIzuGK6KlVOOqNlghPQXp3KsnAzmYLmzFR9ZB01yW9o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UGEfHCsABgj1QzWeN8DHz4+hLn5S++tVCYOFBukv7EdCpu9vGiiicQnswSVbhKS50
	 FFud6jiF8ITHj5BT4kHT/7trcVvnACqfn0EwcGYRFo+9KcXLkr16hezAfAy/Bguoll
	 sEfczMk3vIPXU7wHRHJbmiB8H3UuSdsbinZZbFRHYOtYM12ScY0dw+TqJDDztECyNW
	 24/o82e0kDURwO7C1UXNhk06p7isCCHmDtdEVbUolO4jzIA4TUeNcQcepM326gnFp2
	 4wcv0SgCnzniTE3Eb0B84SmcxyPNLp26UVMqa3NnyOSLaykamhVfHu32GIyaOwX5c8
	 um75tZU2dtQYQ==
Message-ID: <sashiko-outbox-228796@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: preserve EXT4_STATE_MAY_INLINE_DATA on failed
 inline data conversion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arbab Haider" <arbabhaider649@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261123065448.60742-2-arbabhaider649@gmail.com>
References: <20261123065448.60742-2-arbabhaider649@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 07:10:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] ext4: race and stale data in ext4_convert_inline_data_nolock()
  when !may_inline
- [Medium] ext4: transient EXT4_STATE_MAY_INLINE_DATA in
  ext4_restore_inline_data()
--

commit 8c43e34008561b523f81b41ad4705762c74a86fc
Author: Arbab Haider <arbabhaider649@gmail.com>

ext4: preserve EXT4_STATE_MAY_INLINE_DATA on failed inline data conversion

This commit saves the initial EXT4_STATE_MAY_INLINE_DATA state in
ext4_convert_inline_data_nolock() and clears it again after
ext4_restore_inline_data() if the flag was not set on entry.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 2e14ee9b4241b..1694346f74c7c 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1121,6 +1121,8 @@ static int ext4_convert_inline_data_nolock(handle_t=
 *handle,
>  	struct buffer_head *data_bh =3D NULL;
>  	struct ext4_map_blocks map;
>  	int inline_size;
> +	bool may_inline =3D ext4_test_inode_state(inode,
> +						EXT4_STATE_MAY_INLINE_DATA);
> =20
>  	inline_size =3D ext4_get_inline_size(inode);
>  	buf =3D kmalloc(inline_size, GFP_NOFS);

[Severity: High]
Should ext4_convert_inline_data_nolock() proceed at all when may_inline is
false?

When EXT4_STATE_MAY_INLINE_DATA is cleared,
ext4_da_convert_inline_data_to_extent() has already moved the inline data
into dirty folio 0 with a delayed-allocation buffer head.  If
ext4_convert_inline_data_nolock() runs while that writeout is still
pending, two problems occur:

1. If ext4_convert_inline_data_nolock() succeeds, it reads stale on-disk
inline data via ext4_read_inline_data() and copies it into the newly
allocated block buffer head, ignoring the newer dirty data in folio 0.

2. If ext4_map_blocks() fails, ext4_destroy_inline_data_nolock() has
temporarily cleared EXT4_INODE_INLINE_DATA and set EXT4_INODE_EXTENTS
before out_restore restores EXT4_INODE_INLINE_DATA.  Because
ext4_do_writepages() checks ext4_has_inline_data(inode) without holding
xattr_sem, it can miss ext4_destroy_inline_data() during that window and
proceed to map blocks after EXT4_INODE_EXTENTS is cleared again:

CPU0                                  CPU1
ext4_convert_inline_data()
  filemap_flush()
  ext4_write_lock_xattr()
  ext4_convert_inline_data_nolock()
    ext4_destroy_inline_data_nolock()
      /* clears INLINE_DATA,
         sets EXTENTS */
                                      ext4_do_writepages()
                                        if (ext4_has_inline_data(inode))
                                          /* false, skipped */
    ext4_map_blocks() -> fails
    ext4_restore_inline_data()
      /* clears EXTENTS,
         restores INLINE_DATA */
  ext4_write_unlock_xattr()
                                        mpage_prepare_extent_to_map()
                                          ...
                                          ext4_map_blocks()
                                            ext4_ind_map_blocks()
                                              <-- maps inline data as
                                                  indirect blocks

> @@ -1197,8 +1199,12 @@ static int ext4_convert_inline_data_nolock(handle_=
t *handle,
>  	}
> =20
>  out_restore:
> -	if (error)
> +	if (error) {
>  		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
> +		if (!may_inline)
> +			ext4_clear_inode_state(inode,
> +					       EXT4_STATE_MAY_INLINE_DATA);
> +	}
> =20
>  out:
>  	brelse(data_bh);

[Severity: Medium]
Does clearing EXT4_STATE_MAY_INLINE_DATA after ext4_restore_inline_data()
still leave a window where both EXT4_INODE_INLINE_DATA and
EXT4_STATE_MAY_INLINE_DATA are set?

ext4_restore_inline_data() re-creates the inline data (setting
EXT4_INODE_INLINE_DATA) and unconditionally sets
EXT4_STATE_MAY_INLINE_DATA before returning to
ext4_convert_inline_data_nolock():

fs/ext4/inline.c:ext4_restore_inline_data() {
	ret =3D ext4_create_inline_data(handle, inode, inline_size);
	if (ret) {
    ...
	}
	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
}

Because ext4_do_writepages() checks ext4_has_inline_data(inode) and
BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) before
ext4_destroy_inline_data() acquires xattr_sem, a concurrent writeback can
still hit that BUG_ON() in the window before ext4_clear_inode_state() runs:

CPU0                                  CPU1
ext4_convert_inline_data_nolock()
  ext4_restore_inline_data()
    ext4_create_inline_data()
      /* sets EXT4_INODE_INLINE_DATA */
    ext4_set_inode_state(...,
      EXT4_STATE_MAY_INLINE_DATA)
                                      ext4_do_writepages()
                                        if (ext4_has_inline_data(inode))
                                          ...
                                          BUG_ON(ext4_test_inode_state(
                                            inode,
                                            EXT4_STATE_MAY_INLINE_DATA))
                                            <-- kernel BUG
  if (!may_inline)
    ext4_clear_inode_state(...,
      EXT4_STATE_MAY_INLINE_DATA)

Passing may_inline into ext4_restore_inline_data() (which has no other
callers) and only setting EXT4_STATE_MAY_INLINE_DATA when may_inline is
true would avoid publishing the flag when it was already cleared.  Also,
note that the commit message says ext4_create_inline_data() sets
EXT4_STATE_MAY_INLINE_DATA, whereas ext4_create_inline_data() only sets
EXT4_INODE_INLINE_DATA.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123065448.6074=
2-2-arbabhaider649@gmail.com?part=3D1
