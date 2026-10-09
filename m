Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993384D4896
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543288; cv=none; b=HpjsNI8/Fr2IgQOeRpo9b9wjl09AOaIB4EfCY3v5rdSg/2yITyc2ndsPLjzNri5EfIBPD3QnJDp2b/QzlAZRcA0hNbvNSgg1NMXXoMLjaWqXxmh7RaBC4AWz3LHoeHd46FGQy1kOMAJJwmIfLB7TdXlDyi/4V+rty22dZWXzhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543288; c=relaxed/simple;
	bh=7KaSkdl4M0O71Y8yyx2rSd7eoVRV2CuvSVRcwFrYP20=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=obZQJrRZ3SAOK9+ppkRwQIEzAz6KgPmfToP2GbUhPRudpWUNcM+vWq3WIkrNl/jSl+Fc/UBIDpx56PRWLKbwoETAodqnyQZFSuSpVsIhObrieii1NlthiBR6W82+rzhGMwtkz3KiE4972pnwili834KpLD9OmYVSIRQlPBU7E34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVzAzejq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVzAzejq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE121F000FF;
	Fri,  9 Oct 2026 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543278;
	bh=9tUehLK/YtiR6jvBR2PpeqidJ/39MQmdfWcAsMP4lp4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YVzAzejqA3UiDq6QhxcEVFGOxXFM3rGdqLOtxYY72e1cwwK30FLw1rEhZivfLYFwa
	 x38lL51XTJaQiICpiH2CpaSs5JLpWs4nRWhA2tSTfDTv2p729JX53szKFuF3JRen+H
	 nJ1nys93L6RCTXqeO2jKKooQV6I3T5M6IlBw14bdq2/xrDABYVO3jwGmZ2txxgsWIB
	 DHR0d3suzB4bPriC4Qit+qirLbIw+JdymDqWdmHzyh47Pbl2hcQXiM30BZBzNRI6b8
	 XUNOOOttbfxg7CFAlR6WO5rdnGBFFvGLRJkodB5PkAB5F9jBbgLA89IrWgKIDQ89Nq
	 a1ZC+gZu6S89w==
Message-ID: <sashiko-outbox-165284@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 09/31] ext4: add iomap address space operations for
 buffered I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-10-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-10-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:54:37 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce initial support for iomap in the buffered I/O path for regular
> files on ext4.
>=20
>   - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
>     inode uses iomap instead of buffer_head for buffered I/O
>   - Add helper ext4_inode_buffered_iomap() to check the flag
>   - Add new address space operations ext4_iomap_aops with callbacks that
>     will use generic iomap implementations
>   - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
>=20
> The following callbacks(read_folio(), readahead(), writepages()) are
> provided as placeholders and will be implemented in later patches.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D9

