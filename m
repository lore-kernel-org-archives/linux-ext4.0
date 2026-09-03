Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21EA390991
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442345; cv=none; b=UKfk8SgSKVcN0g7yUDprVr91U69M5rb11/VlSxnCiVuAd/Oju9lsbAFvkWD/M70D2oOKUM51E448CAi+izYBe3c6+ebylmKv6sJRwZPp1KfMH5AH1iqPe5XHXJaZskYHyASbNV5wjj0jlCzR7ppKho27vJXTTOKNXYnzwvxnpvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442345; c=relaxed/simple;
	bh=vwb4XUVdq81QyIn2gTwcbVimu2VxWuUfQJa8mYifUYg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q9DWR8nD+rlBmhIY9MdUqKsSZGRdtL5h1tvrjvcwibFXxYHDvQm0EX6IVRF8hgYoAUDpIx41DG7P3hv9pS+h0HWb+VlNOV3/ecHrWaw48MvbwFLZgYmZNTq5AduK9Tba2z1bt9zJ9Gog0WDfYlkFmy+w7Z8LQeNK8bH+pk6iyQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rb8zxPBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rb8zxPBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B511F000E9;
	Thu,  3 Sep 2026 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442331;
	bh=JctV5yNhjxzueusxGrWgvOHYGFmP5U2tFMU6Edy2N/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rb8zxPBxByPwnSaX7V6HP7ACGroE419JGOCypgDBVATdZRo5PB4QOXch/pW5R8t7T
	 Won0Qg+XN2DCw7MY1w9HZZaMJEFiQfAdLW1WZ/6jvcnmhkTWGW/vrAbdBCdkh89AAN
	 FBGNtWKhI2GPrVvhQsPYD4/VoCsiovjUCfRg+mR1/iJYjg2QOdR/SVcldphLBw4ep9
	 dOnGTEvqWftUNGFHal3I+pktc7jFU5x+KjreczoHQxH3bE/8nkT/b8zSq198GWDezM
	 D51knFNj7fnlCbk9LkrOg+YjDizSfxjQkevqgeXARFjzuCSLzskqPnkmRiEUNAn6oN
	 l+LHR6MMnQIUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 29/31] ext4: add tracepoints for EOF block zeroing
 and disksize-grow I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903124017.2325538-1-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903124017.2325538-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:32:10 +0000
Message-Id: <20260903133211.53B511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add tracepoints to track the disksize-grow-pending lifecycle in the
> writeback path and the block-zero-EOF entry point:
>=20
> - ext4_iomap_wb_disksize_pending_submit: ioend is marked as
>   DISKSIZE_GROW_IO in ext4_iomap_writeback_submit().
> - ext4_iomap_wb_disksize_pending_complete: ioend of type
>   DISKSIZE_GROW_IO completes in ext4_iomap_finish_ioend().
> - ext4_iomap_wb_disksize_pending_wait: ioend worker waits for the
>   pending zeroed EOF block to complete.
> - ext4_iomap_wb_update_disksize: i_disksize is advanced in
>   ext4_iomap_wb_update_disksize, including the new value and
>   whether the update is a disksize-grow completion.
> - ext4_block_zero_eof: ext4_block_zero_eof is called with the range
>   and zeroing outcome, capturing the producer-side entry point.
>=20
> Together with the previous mark/clear/wait tracepoints, these cover the
> full lifetime of the disksize-grow-pending state.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D29

