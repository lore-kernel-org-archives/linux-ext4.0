Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EC754DAD6
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995558; cv=none; b=UFVKs/tKbjUA0m8G3h+JrqucSdUXvjDe5bTXB/yIvPUj4a9ubHXLAx/bg2fuPPxXck0UKHUR9VupBkheu7BLAq361SlmQGYeic1a+j6OYPeqoF4f8yLug+uVSGz07gXizxF5fNMcwQSp8VxQ51+BA/Eu/mq+OFgc5JCz6kUuwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995558; c=relaxed/simple;
	bh=vuuWdK74DsQlLIWsdvAUwMKMmRYlZVe1gAHAfIHarAg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IBnuFmuWXaVsxPMIAO+r2F7PhBcE+qs/Gz7vuply7XsuB14GmUfnYelrTU0PFq/5KUIaVd1sYQFC0Zggw4Ce30YOfTPj3HPEKD/vQ5PkY9/kyQaAviNYjBvM3dAte5Y4Qg2K6WnvtVnA6MrseO2OntH/J5CFqc6PE6t+MUfDuPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6dUt+4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6dUt+4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405B11F000C5;
	Wed, 14 Oct 2026 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791995557;
	bh=vuuWdK74DsQlLIWsdvAUwMKMmRYlZVe1gAHAfIHarAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R6dUt+4rC9YRZedXCXkPCugjYnb7cGUpgLSN/rpa9WUkAiLoxRktaGS2hx/x7CUEp
	 sbJ26ZZtU6k3dggz1+V5VAwueWcIJg2cDw2UxxgdsjWYN/V/hA0ffclgfILnXLRWpe
	 +xttGgcZozx6WAFQHU6hdYw2WZl8UjbKDIJc6/RFlbCLlB4FHEwU6Pbi/krmkxL4SK
	 VP1MyUAtPsavLn/X8yM/gkl/GucqgU7FKiokMS8iOPYrqLFJ7+zQVGj1IBzPrpvtnN
	 kGJSE5tMsSabhAmbB+F/bo3La4jQpEHoK9rCKHk7lOZ8q3NhBG48B+DbmDEhXszdMm
	 gX7veRAjdMVOA==
Message-ID: <sashiko-outbox-171535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] docs: ext4 filesystems can be converted to 64-bit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stephen Kitt" <steve@sk2.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261014162921.450235-1-steve@sk2.org>
References: <20261014162921.450235-1-steve@sk2.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 16:32:36 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Since commit fe12931 ("resize2fs: convert fs to and from 64bit mode")
> in e2fsprogs, which shipped in version 1.43, resize2fs can convert
> filesystems from 32-bit to 64-bit and back, so the mention in the
> checksum documentation that this is impossible is obsolete. This fixes
> that.
>=20
> Signed-off-by: Stephen Kitt <steve@sk2.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014162921.4502=
35-1-steve@sk2.org?part=3D1

