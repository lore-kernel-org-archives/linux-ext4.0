Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8AC40F8D0
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701886; cv=none; b=rTUzzEl51EIMUmmrTirMAPWVv3/mf7oVr9F13Fb63y1VLJ27/Ot5AAKtEfpRqGOS3ImbunMH8ERLHPKB4L8bPgMaKGWg3iPIF5CHhJQKuk4GB6hj+yUEEAOZ9mLtWelkjih7qrsTa3pNfuq+Lih0wifmyFe64Ent8xgY7ST9hwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701886; c=relaxed/simple;
	bh=uIHqMxBJ/4cGypOC3j09Wge3AtsqmpBfLVvogDXIZ4Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jp2CbHiFy6VI9grdF8uI2mAw/Wyhe5WssrIiAGdrClq7sdaTsZw/7fIn9lkJVxPU/P+OAVEKh6W2iqX4PWZB/hPeZr069ilo89NDcQFuHSuTs0AFZrRC9smHO46bBSKZ7jnn+BXqdl8j9jsKwJ6qq25nf5zsACx3ObEtXFnNPPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJUnvu7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJUnvu7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28651F00A3D;
	Fri, 14 Aug 2026 10:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786701873;
	bh=Q45L5RB/MaU4YJAvngBEY61hPofTdvE2SidRP9pp0fg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VJUnvu7o1yAtwBgmW+2SYfyVJy0zIj46tge+v7hfOUIF9IxCMiMCmSl/unCgkFf4H
	 CxkFAPTQBs/mkD2yRYWMnfXlPDRLqqG8o+khK22ki0kx9lJ0CMIhtDLpkm1tq0qXWE
	 3gHJ+zZLLFUMi2rpQritjlLasehQC+9MdUtIT1O6FBbQCr2ZVUpWlG7Dba8//DIOTo
	 OveX5ipyF2bdTXmwlwN9LwyYize0gm2zabLlQU1M7C5A7usIwQ+CgFmGhEWgDL0+np
	 52kSR3c0FXvsWIXIJIE5iQOlmf4cWtUmnKd3Yg+dqJqIndK6pROOGMzHXikD1VYakm
	 nRfmhJVik/7VA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 11/32] ext4: add iomap address space operations
 for buffered I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-12-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-12-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:04:32 +0000
Message-Id: <20260814100432.D28651F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D11

