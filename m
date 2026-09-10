Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2543C09F8
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 10:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035013; cv=none; b=INDJk6UDgCYbjBHLyQY6gn8+lJ5tP6fyxgqddp3JXpIp77rYAUB0avIzWGexEH4yuEr9HYhT6Md0bPuNIaN+19jILgrKAzmg1ewLZbn1ymwXrPwQkKPL9mzpYz7WFLzb0PiytUZiRZetTIjW77lqJvKGmlCFANxqZ9g/O418NTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035013; c=relaxed/simple;
	bh=sYSG7l/Pl2UbsZ0TPVbTkcynEBpTEGZPvCF5eMZJn8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PnK5srHVMmk7Du/AKN+hv4nXnCIjEDdBDWTZ756OGo62PBnUlDVXCbTw2IOa4zWOZD45MwElw4ShOOHJ95AqDdhkAgpojMr34QTkJKhLX54lKSYCFCpGzuQUKPWeKaMOXZ9csFof3wNw6Ared1o15CPTNRYLaS+CO5QhxDJrHuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LkgPRphy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LkgPRphy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747DA1F000FF;
	Thu, 10 Sep 2026 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035005;
	bh=sYSG7l/Pl2UbsZ0TPVbTkcynEBpTEGZPvCF5eMZJn8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LkgPRphyYdqSK2V4kiEaZQIxcW3eWgcUgJo3iVgYm/k63hYre9CNIjZuIunmyUDWv
	 5+xYUJGMC68hbE23Nh/JGgbUavvVMj/y0UYbMhfli/sommFeMtfQf6iFdJuC8ya4q2
	 fvaxZBvTiw4Qdlg2tjTrqNIpzUyV2xQqUP1YvTO7bqckFR0MpaFoO3WXY5z0RbYjrD
	 YokxQBZveh6g5+0sHX3hUjC7GvMVOP3ja1aJXVGnnPYPdiXAKXPws0VAia35ZRazC3
	 FHXFi6YIoLXKSiBusaHEXrG220bP1kIaCqni70FkGgJ26v3eoPEpVezLMvfxuJ+TuM
	 Z83RWOMNM4YOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: set awu_max_opt to awu_max
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pankaj Raghav" <p.raghav@samsung.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260910100829.2532894-1-p.raghav@samsung.com>
References: <20260910100829.2532894-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:10:04 +0000
Message-Id: <20260910101005.747DA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
> added atomic write max optimal to statx. As XFS can support large atomic
> writes through SW, max_opt exposes the value that will be HW accelerated
> atomics.
>=20
> As ext4 does not support SW atomics, set awu_max_opt to awu_max.
>=20
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910100829.2532=
894-1-p.raghav@samsung.com?part=3D1

