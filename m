Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F131463B95
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806636; cv=none; b=J73Jlq/Vw6EM7/7yXXhvFkLe76J5EJn77jlsb8OwUblbwFpPGnng+tqUX4IZrZazxbiE7i/IfGMCTF3hBCmV+iImtXdHLhT9Pdmqp3Gd5La5xYwwok6Hv75EhUR8akvhw0nBZ8jUB59JSXGHm+cdW5N9wAelaLJdwg59G8vNFNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806636; c=relaxed/simple;
	bh=iqF2SEn2Mc5n0lL9gliHzRtw8K0+F6qeiP60qn5oTR8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Wm9bGbvpFNcjXkKSqGzC4DMD3qqhbSX4vcxULrlpnCeifY7UFmX2SLbZ6VDUT28dIx2z0C2osD6gHu5sOsvtV6UCd9ODZOTIRc1gFBlEJnYlkLAk/KU9jqeevrThO2f0Hsd2zLmGmlG7zcJzr1I19neJXd4DMAfrd/8rMgKrLjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meUQ59ey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meUQ59ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C1B1F0089B;
	Mon, 12 Oct 2026 12:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806635;
	bh=ou4kaf+CAT6wiD6XFBdIv2v9GaAdJ5GGftyIIRrChDY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=meUQ59eyArj3sJkJAQDNGhNZHh5qUSIc61G8VNge0wRFyuI1qcyxu8XeMpSca08Cx
	 VRJdWbv0YJG+1cqQi8L+x86SocnCYm245c4Y6ntrehxQTMAIbaMpm3RMzMR5WzXElM
	 XWv6G+dLss/xrRDyjq8aRtWQV2FJWZIToUWY8SEl3XjAXO6EF/y6t4mGutPr5zjDaP
	 ZW1CsAaGscb9tUO6UAF35l+yxdbI/e8yI7wyGMS7Cv4XebuTeU0XGcQRtY289ES44/
	 x7uotyqhKlkPh5PwJJgZ1OlBs76a9V3Otu+0tnz9fp5bDEeWlz4ddrbkhJcOupOXR2
	 QHrLdOZNLwxOw==
Message-ID: <sashiko-outbox-168056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] jbd2: check return value of blkdev_issue_flush()
 when checkpointing
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 12:03:54 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> jbd2_cleanup_journal_tail() calls blkdev_issue_flush() on the file
> system device to make sure all checkpointed data are on permanent
> storage before it updates the log tail in the superblock.  However
> the return value of blkdev_issue_flush() is ignored so if the flush
> fails, we still advance the log tail.  After a crash the journal
> recovery will consider the checkpointed transactions as committed
> and skip the replay while their data may have never reached the
> disk, which may lead to a filesystem corruption.
>=20
> Abort the journal when the flush fails, similar to how we abort
> when detecting writeback errors of the file system device.
>=20
> Fixes: 79feb521a447 ("jbd2: issue cache flush after checkpointing even wi=
th internal journal")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114713.4049=
391-1-guolingxing@tju.edu.cn?part=3D1

