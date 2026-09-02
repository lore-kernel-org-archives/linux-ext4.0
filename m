Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E543C9EE9
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333105; cv=none; b=B+aiKMD4BFRoy6tbg8C2JN9VQLTkFIU3biuFNiiu8A8XyMNbELRW9281NB/a6uaTEc/bmhbRkfwLWmCu6EmJyPAoRXpk4Gm0mnEwBYaUOcXW+sNYK3sonuy8va81eqKmHmlnCQfGJ66xEW+MmxmxOFzjhqnxc0cN9xnbaB3Z8cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333105; c=relaxed/simple;
	bh=xOJmq3A8Lzt0PpcblhrX8SYShBSGE8NUYrDxCoyJl3c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k4omOL7H4+5MPO3Lpie+jZ7tCZrecDtskM9VGMRImqeGn2UHp7XB1LK/U9MD5+lL4cPzSgU0RbKTQsbsnA0GjgggD3/AzdNhQ29C3FhBBZNxbBO7Y/q9GeG9rkDo6U/VXO2dhBdusr5//n9FgSxTCglRR7gphnf4OpifmeYkqD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfXxFLPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfXxFLPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BCE1F000E9;
	Wed,  2 Sep 2026 07:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788333104;
	bh=xOJmq3A8Lzt0PpcblhrX8SYShBSGE8NUYrDxCoyJl3c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RfXxFLPgAFSpF2+iQweqxaPgGSqNYdyHI5qdNuVix1URex+IWhlSWGrGHOs5wLpor
	 Dl85TiJaHfwuHvUOrizmt3KdCFP05u/4WcgeONNHIn88eq3mapd3Pi3s5xevVjUh63
	 sWIrKF+mQw9uKK0V32/Gq1jfG4ThrBZyPlflaoowSXl0POLcTa7mPg+mb918ySyHJI
	 YwLbZhTRWK7Sh3QytiKCM/v3+jpmz9d1SWxCqcuGDXkV0Wtgn8RqUhfb1CbPvLZb0H
	 zRJUXm+Opj7ScJfRp/eoTWJnUk3q3SsE0yc8dVh1b6XnffmvYVNQVJlfVzzEkOKJHI
	 L4U8V8ApU+ltw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: avoid false sharing with j_state_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902070331.820322-1-jonaszhou-oc@zhaoxin.com>
References: <20260902070331.820322-1-jonaszhou-oc@zhaoxin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:11:43 +0000
Message-Id: <20260902071143.F2BCE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> is_journal_aborted() reads journal->j_flags from ext4 and JBD2 hot
> paths. At the same time, transaction start and stop paths repeatedly
> acquire and release j_state_lock. read_lock() and read_unlock() update
> the lock word, so this traffic invalidates the cache line containing
> j_flags.
>=20
> On the tested x86-64 build, j_flags, j_errno, and j_state_lock occupy
> the same 64-byte cache line. j_flags starts at offset 0, j_errno at
> offset 8, and j_state_lock at offset 56.
>=20
> Align j_state_lock to a cacheline boundary on SMP builds. This moves it
> to offset 64 and prevents lock traffic from invalidating j_flags and
> j_errno. Tests were run on Linux 7.3-rc1.
>=20
> On a two-socket Intel Xeon Silver 4208 system with SMT disabled, CPUs
> fixed at 2 GHz, and 16 stress-ng workers, ten-run average bogo-ops/s for
> stress-ng.utime, stress-ng.access, stress-ng.file-ioctl, and
> stress-ng.open increased by 9.60%, 5.42%, 2.05%, and 4.65%,
> respectively. In separate five-run perf c2c measurements, average
> Remote HITM samples for the affected j_flags/j_errno line decreased
> from 1996, 2041, 1555, and 383 to zero, respectively.
>=20
> Signed-off-by: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902070331.8203=
22-1-jonaszhou-oc@zhaoxin.com?part=3D1

