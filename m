Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795113;
	b=2e6HD82Y2F+usN26FPiDWEDbWDO+P4n+ADNDufOOEvUbfanSJC5DRkrrpiG5NsptT2XK
	 2JfARECfJS1Ql6CvsC16VN9+MYv2DxC58rby6ZZCeRzsR4QPvhwi/yIWrOX3bPTI0pGtX
	 2rMviU+u3rBbSA6x4KGHnOr/rJn5JruU7DgbxXZi25515xcSmKSS6wjYWgXDrZ280ofyT
	 o5SDYHevnRUgC/KUxbkooF6vPf/Mwfrv9jBXcdcHq+47xkmoj7Z0RCRpb8m29e7kP+s4b
	 DO1M4uoJiPpbwrx08Ddh9ypnQXAVOKVh/swC9+Z+XzESXz8H3USqWLb7U7G/+AutoFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795113;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pP+FWsr4a6JvvK4G7miFFVRpbhDvzNYpBM0Og6/OrIM=;
	b=d3iHqV1JRm83ZS4QPfCS7NNBeklW8COjw+qO8G4DAXUIuBT+1r2B3+8/3uv9+gMCP1CE
	 xolAcIMfLdMz69+srxlf6ttTXaidUp096Ing12Mw3sG9VXiXRUtXNEIkRT/MAsI53TkOn
	 /eQoKaWCnTXZZz5J25DoVuTqVkrbyuDt+uUnw1zpNVe22Z2rCwKjpU9SAxAH0nCZn38Xg
	 hk+guEk3nErYkGAufPm2PTvj2r5PfY+PTA/9yWZPrcEbXbg3m6J6tEZzOB6Ea6rrVsDL+
	 gRDgKR9SErUMP9fReDdXNRVKeekIYt2N2IG5lFkvYclHomRzVlooEhkhYhpIaGz5XdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH0vJbXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46D0606A321
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH0vJbXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848711F00897;
	Fri, 27 Nov 2026 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795113;
	bh=pP+FWsr4a6JvvK4G7miFFVRpbhDvzNYpBM0Og6/OrIM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TH0vJbXMP13jdA6hIm4XOgrg0hp7hGrCfW/v5dpKKp1kQBJSFrpTMkN7E6gx24fPq
	 Faxo4bdmEzfa4khbk/QZXD5h50XvGaUfVuCfoMztSYr4MZvadb2uiioK3KVxKM0zQI
	 MRAyRV2Wg+4kHYOtv04w8U3QYARBMJTv6fiZ6zJR4Z7B6cj20Cb22hen7qhfigNu0w
	 H0jJo/HrHDbw1PuGSH3y0S/BL1KXwJ/Fza+BnaPBfnWKdk/+Aj0xdElRd3mBFDJJhE
	 X9u+6HVBR7lHTMs4mkcbOLJLu0ZTPdMvjXzZ4eF4vTfC/kNlrQxZw/frDlDHHHPerp
	 7xzmeQUBW/RWw==
Message-ID: <sashiko-outbox-237799@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/13] ext4: introduce CONVERT_PENDING extent status
 type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-2-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-2-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 15:58:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext4: double reservation update on ENOMEM retry in
  ext4_es_insert_extent()
--

commit 574b0ce6804297f971eb1e0a8136bb02463b4f9a
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: introduce CONVERT_PENDING extent status type

This commit adds the EXTENT_STATUS_CONVERT_PENDING extent status type to
track unwritten extents undergoing disk I/O before endio converts them to
written.

> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index b7fb8502f9d46..28528f19be1df 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -529,6 +529,9 @@ static inline bool ext4_es_must_keep(struct extent_st=
atus *es)
>  	if (ext4_es_is_delayed(es))
>  		return true;
> =20
> +	if (ext4_es_is_convert_pending(es))
> +		return true;
> +
>  	return false;
>  }

[Severity: Medium]
Can making EXTENT_STATUS_CONVERT_PENDING a must-keep extent cause
ext4_es_insert_extent() to call ext4_da_update_reserve_space() twice with
the same resv_used count on an -ENOMEM retry?

Previously, ext4_es_must_keep() only returned true for delayed extents,
which are not inserted through ext4_es_insert_extent(), so err2 =3D=3D -ENO=
MEM
was always cleared to 0.  Now, when ext4_es_insert_extent() replaces a
delayed extent with a convert-pending extent, __es_remove_extent() removes
the delayed extent and sets resv_used > 0.  If __es_insert_extent() then
fails its initial GFP_ATOMIC allocation with -ENOMEM, execution jumps to
error: and updates the reservation before retrying:

fs/ext4/extents_status.c:ext4_es_insert_extent() {
	...
	err1 =3D __es_remove_extent(inode, lblk, end, 0, &resv_used, NULL, es1);
	if (err1 !=3D 0)
		goto error;
	...
	err2 =3D __es_insert_extent(inode, &newes, es2);
	if (err2 =3D=3D -ENOMEM && !ext4_es_must_keep(&newes))
		err2 =3D 0;
	if (err2 !=3D 0)
		goto error;
	...
error:
	write_unlock(&EXT4_I(inode)->i_es_lock);
	...
	resv_used +=3D pending;
	if (resv_used)
		ext4_da_update_reserve_space(inode, resv_used,
					     delalloc_reserve_used);

	if (err1 || err2 || err3 < 0)
		goto retry;
}

On the retry pass, no extents remain in [lblk, end], so
__es_remove_extent() returns 0 early without writing *reserved, leaving
resv_used at its value from the first pass.  After __es_insert_extent()
succeeds with the preallocated es2, ext4_da_update_reserve_space() runs a
second time with the stale resv_used, underflowing i_reserved_data_blocks
(triggering WARN_ON(1)) and double-claiming or double-releasing quota.

Resetting resv_used =3D 0 (and pending =3D 0) before goto retry would avoid
applying the reservation update twice.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D2
