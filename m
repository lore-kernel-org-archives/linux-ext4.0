Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7437CD59
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631575; cv=none; b=VxL962ENa755wNMbS8DThxnmSc9uBNODWxH9LLMOTRhtSTyNgRXMzGkwbg60lImLlKEljAqxNb5mBp1lO4HlJRG6URU6AdD8LmuF9DwKMjRA3190GaAOQRIw3NTIewcG9AN4MSg41VpdQvuCp7URpwlMqDZlNHHKeNWKVinWpbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631575; c=relaxed/simple;
	bh=tih4XquBeogRF0Ma7+OZFpXzl3Of+a9dcGDPYWq6jX4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QVgDkhjurgTnrlSMENj8EAdcqmaXTA2tnuqiyYbtmKQh6VdM7qDkCchbqy/UIaHFjBPB94l/dNBQ6U03AIVxzEl8p2RZISBqnEr6BuEa2Vfp06p4fRN8roepEukiu74rhuH1+OkDcXsJBJHkvmBW7tupbwYs2uKE8Kwady8CiD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuGF8teF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuGF8teF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6BF1F000FF;
	Mon, 28 Sep 2026 21:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790631573;
	bh=2gAqmbX3quTyzMOQtVIB6bedkYAqYOZBiJjU4BIUDTc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kuGF8teFzgNuuh8NaW+3YeRFfvXTAj3cerCaRyv8hXN+0hmyTDdIcTJWh+11e4DIP
	 MFnRpOR7bflywmlDRYfkfJMBLWSZ3w1va60BWDIcnsCtOtPZeERScHmZdqnCPtKWZz
	 F9PSJ+a0NV8RaaSvGJkbO9Tdf83f2oXA3939m9iEbQ2n/OGUAVW/PfcMSKLBW6cUuI
	 Ro/mkdzLXTeQUpLehMP27mLMqOJnt2QOk4+2exMK6kx9g8fmqeYumOPEsMuLOZ3M0I
	 9NqCZ0DZqDZhb23cVyRDk2MijhmavRvIo85CKgq02BCbr8HBx9yoyeaNw1zNyy8LbT
	 Ocrf+zaO2ZDoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] shmem: Report casefold setting in mount options
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gabriel Krisman Bertazi" <krisman@suse.de>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928213155.2612039-2-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-2-krisman@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 21:39:33 +0000
Message-Id: <20260928213933.7D6BF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> For shmem, casefolding is a mount option.  Report the current encoding
> and casefolding flags in /proc/mounts, so userspace can easily check if
> casefolding is supported withour relying on parsing dmesg or trying to
> set +F.
>=20
> Reported-by: Daniel Tang <danielzgtg.opensource@gmail.com>
> Link: https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-des=
ktop3/#R
> Assisted-by: LLM
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928213155.2612=
039-1-krisman@suse.de?part=3D1

