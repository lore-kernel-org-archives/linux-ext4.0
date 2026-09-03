Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEC04A840C
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 12:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440178; cv=none; b=Yf3sT3B8MfkfxkYzLBZ2k8p17JcIURLfDM8w5NSVAlCqZl3MhbqiZHyYHQRRxDH9iLqIXWeCbh8y8FYBBFz2anko3jlze7UcB8zQYiWzxizgT7NfGvtT1DeaZqMXAd+oG6b3ZLBTCMI37V5EHxFkyiUqPU0XRKr1IFgTPxZab0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440178; c=relaxed/simple;
	bh=XqXBxvh7EmqQcwdZuJMY58CmYpN9YnTojZJL032hQ3g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z0yBG7qHNQFe4mT9t9KWoAUlJI4jfiivCXqQ2bHcuKu2OSELkLr/k5j0sGxI7hiaicZajkCTbjh/VT+tGxmZYx4VKR/UHnfVoI6VuKfT4owNo5dG4IHeopF7O7jg1NzJ3rbnoijQjEnJwUhLEDjUCuL0qQuGiNIdhMcxf0jzObg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etTJ5IRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etTJ5IRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FBE1F00A3A;
	Thu,  3 Sep 2026 12:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440176;
	bh=XqXBxvh7EmqQcwdZuJMY58CmYpN9YnTojZJL032hQ3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=etTJ5IRhW8YWlLXqC5a5mmhzmav5OFUwnkVjzrG/RH1QV6ELzWbKndk3o3VG2J3pb
	 512JMKn4+9JF7E+ZAfqWBaKo8gzGhle1SNy66NFQKFTKRsGMxwrieiHysPx/R0rGY1
	 K6FYnCAA7nxOZ5wO2ibZPw6EncF416VfElx5CWdXOI+Xi2e/HINRPA52io/bYQWiFS
	 SEydQqvoljA/PKkBoz5lsV+8aq8V0DzLDFycupryHs1cg6My2upbbiihMG6f09VSaI
	 wyIhvFlXueyh2odqc3tPqAlWZYMlvu8j+5pixlbwvpeMABgrnB6QATKdE8zmGaPP7I
	 388F30SZ5XX0A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/31] ext4: simplify size updating in ext4_setattr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-2-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:56:15 +0000
Message-Id: <20260903125615.D4FBE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The logic for updating the file size in ext4_setattr() is currently
> somewhat messy. By directly entering the error-handling path after
> failing to add an orphan inode, the unnecessary recovery process
> involving old_disksize and the file size can be avoided.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D1

