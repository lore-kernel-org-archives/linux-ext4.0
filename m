Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB643B9610
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 01:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856239; cv=none; b=KTak0mukVJqwIhooC2ZSVMU/Oyqj+5ar1fKjeORctM/9EcihmtjUu2XurXosDRuUApz84IB6Mq/cEpjx1U7i2kXWug/Ez8DvT4lXO7OFVKWL86ttDkjqJ2/LTBXY6gGY2z05nP0o4L+KPVEJPt6Ga24kIxeULOnIyCdDujkx7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856239; c=relaxed/simple;
	bh=VB/VVZ1i3Q511fjrCnUIu4NsPn897CedwM/MKULlZGs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=h/DSDP6cnogIw6sBaZPXsOjdhVZdk2age/6mcOEtIj65vtsPy83QNjzTags+Xaj42zfY33jJshDnNTeLWaU38dtcDdfCGB8VEmWU64QGN1RlusguehrH3AqhNs2Vb2g7t4KlypcyJCEN/QWiL3elze5zTGzClH1kzH7egYHdEis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aeRNvGHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aeRNvGHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8769C1F000FF;
	Tue, 13 Oct 2026 01:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791856238;
	bh=/PdbG0b4r4fqoy1BXGLY4t9ZTcuLKHBmnJREpQ7QaNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aeRNvGHF0s/ZTYkva7n3Bd2mL/e7lFJQ8GW9XXSjwfpyxps/nod1VlGppEByPX7UJ
	 DdvDTh/PhHeZXCiIMFj7UpWU2rIlYR3i26ArIqkzZIyAchPdtpCHK0jTzqREz/LEmO
	 JMpVxp1TabJZDWo+N+6oNchdRzAapxlmxvJXD1V8Ze2ghsFxsWwirKkHjTKRGguoTD
	 165aejtIF6yxY3q5lpJIqgEN6EOLsVO8UIofEOMq/cJ86ALRNZ5WmOMcHU5TZ/WNpe
	 3Xo0OB7ZyTIrLosDhijKJdrPi5udSzOF0ySYCYPlv//0kYeQVJro/Yxce1FVQ3ebt/
	 WsdHkpCgw5HDg==
Message-ID: <sashiko-outbox-168844@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] jbd2: check return value of blkdev_issue_flush()
 when checkpointing
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013014028.1152277-2-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-2-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 01:50:38 +0000
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
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013014028.1152=
277-1-guolingxing@tju.edu.cn?part=3D1

