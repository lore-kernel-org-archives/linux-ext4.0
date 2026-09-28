Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCF337CD59
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 21:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631529; cv=none; b=VYiDpCtqztcwKDAqaSyvQ1KLE9M3oQnhky5Igq0JQE1UNjMEBkMhRkiacpKnzj2FusSLDW+aeb5QshqnyPGK7PN0MHV++WZ8VAwVeA554XjcXGPlD7A182M7KTrQyL32MwgSROdoUMtkYn7+EflwSo65bfDHzcuR6Yc8w6jZrHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631529; c=relaxed/simple;
	bh=a/UQu9XoTiJfjIWmOGMgw6Bpz+lB3vHpyS9cOLgaY8I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZjC78CNQ7ssDLjK4F61n95rYzBS5qk+fPZtOTT11cov+ElwTuyN6VC2+rE9nFTqIhisUZcdtrLbBZBNUtS8pAxce3jYg/nNVzDFdKoIyRDL8dyANYVH4d5ZIcHUV5BqcnS6cuXkO1c2YIoIqQquPy+M9M4YehsbeJqK8xYbYCpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMhk0hMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMhk0hMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C841F000FF;
	Mon, 28 Sep 2026 21:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790631527;
	bh=kf6GX7F1lYTUws9nq3xGJllNRClcUbq0lifig4wBGvQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMhk0hMs0MgVLH9k6ibbokbP+ZpcwezazdvxGSFcFH6tvwPGASeAThlQGl+xYTFwV
	 uStx/SWWz0p6pdRQ6Ru5cT9G9WOOeWYuvCC4k2EFx+IuJMvzDf0mVWhiv3T94nvQku
	 tzRkrOdD8wCkxG4z6XNI3B1Bho2Hi4l7M++z6w8z5NSRxO+1LD8O5QTh5hhqs5HcVw
	 pko4E06BYWieIgtWnzHixF4UGpeeglkZJOqFW4YHJXBG8fyDW/Ye7O7BBWU3I9Ui2c
	 rtgKrFIGVmkBRx9SSlgwfJRufI+xZsFVZWYpg2pEHeA9asDFDvcL8+mPu+R/ed4rsO
	 ZYRvxmQ13VSXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] ovl: Add /sys/fs/overlay plumbing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gabriel Krisman Bertazi" <krisman@suse.de>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928213155.2612039-4-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-4-krisman@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 21:38:47 +0000
Message-Id: <20260928213847.B3C841F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> In preparation to expose encoding settings in sysfs, add a subtree for
> overlayfs under /sys/fs.  The only remarkable detail is how we reference
> the volume.  Use major:minor, which is not very human-friendly but it is
> at least discoverable.  I considered uuid, but that would be a problem
> if mounted with uuid=3Doff.
>=20
> Assisted-by: LLM
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928213155.2612=
039-1-krisman@suse.de?part=3D3

