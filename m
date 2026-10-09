Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653C4C650A
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543534; cv=none; b=NQjsNEVVwRfXj0G8jvRPdFOdnu+LPmecRDfwuLu63frLCfPzg1S7punz6Xvwge5JCHSYmLk1wjZnWH9R8Mq5Ha00V4o1kqgD180hQ2RefhjQa6PhTFbAQIY+ukgZdeIUzhneh3kgGBriBj6yLZ1H4gnBeyaDrKwea5SyDjlFq7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543534; c=relaxed/simple;
	bh=IyJc73MnPf4qid7evQcr86efTi5DOooUOJg+tHdiMQ8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oQFzvwjqoAt+8SrTDH/S6wEQpR1cYw+usllEKcAV2nuX9drDb5rc3mYThRE+R0X5OL9xUiMIIZpPBPIlwEjkB6bDoWhHvXvKm71MuIh/Ep+9Jcbhqi4CHAIqqgfK04qrU7ksKlp0RJUpXFb6HOMyI65sr/nfmSRUbGnTR3LNW8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ozc8bQUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ozc8bQUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1761B1F00898;
	Fri,  9 Oct 2026 10:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543522;
	bh=IyJc73MnPf4qid7evQcr86efTi5DOooUOJg+tHdiMQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ozc8bQUy/Mk3hdy3tNy319oF215SPhd4D6FvzfvnKon1U8Q3knYoQSL5r2nCbMR4n
	 CIal5GmoGtp2wsjBRMJE+OvvT8QgqelZtEuxPmKP1rwI0ASyINjg5OMywhm1XOvtWw
	 mPKu38UdqnOAm5UcxPYRyIImyMb4jhj23Ihm8iXT6xXc7jSDIddPd6WnWi5M9TXi34
	 vRoUQ44wsouvAYR6lL9rk0l9kJTjDViiwHt9XU6aNUo0rGIbLgWDWF3hFHKy8tbtJ7
	 pmXUPsLALcgqmO+6vg/J2XhzIlwKROXWWDPnhq92yFCq+/vwvFvO637IoKoNSctxjA
	 48WrKfLxld43Q==
Message-ID: <sashiko-outbox-165292@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 06/31] ext4: allow ext4_map_blocks() to start its own
 transaction handle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-7-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-7-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:58:41 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Make ext4_map_blocks() start its own transaction handle when the caller
> does not provide one. The handle is started after the lookup path
> confirms that allocation is actually needed, and is stopped at the
> unified out exit path. This avoids unnecessarily starting a handle for
> pure mapping queries. This prepares for the buffered iomap writeback
> conversion, which improves performance for fragile overwrite cases.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/linux-ext4/i536qqwj5eyulec3r2ki2ycnelqdd4bk=
pat2drn7t72t6p622k@ktueynysgo3j/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D6

