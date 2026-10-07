Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D833C0A1E
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 04:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791346904; cv=none; b=QQkzlLo3w7TTyjHmVkAFC57i+KgM2gcn3onNaIAzwDnqoIc6R9nf6vOiEW6rnNVuxoMsw77UBYgQ5vAINss3F3RIk+TW0InG1tDytJ8IdhHRTqXVpvLk+9HhBT0rkc/SHW4y+V3WtVTnqb/ERSqzuxPkrxid4aL45datjtOJtRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791346904; c=relaxed/simple;
	bh=a+V79IPLxkkcbjmMrV0Pp0j4dXGVAQ1dJlGMRH6Jpgo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hdSfip+Z1MViBU53V2jfrtY6YlQ7KOwzxeH7rodNAK2qw7wh4sgKBx3Gr9ivk35TYrxF7KrkWzPQU5blcx3mHQACOQl7Y0vhJBZpn+Reux1aI132PQ5PUmEPVoqZ614/ZfBi0ZCbcxpogFYxIMcfm8q4NHfBUauJmZI83cmhYDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRTDLbLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRTDLbLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A472C1F0089B;
	Wed,  7 Oct 2026 04:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791346902;
	bh=8vf/09oKQNooca4xjrK9/j2XpU0R6h6RUbQxc42xZBg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BRTDLbLSqP56bRe5AWuDiWvSFLviNXScoOaMqrI6n4mkGAqj8Wy/OZUzEWO3SPG2r
	 BJf8i5ERFa9Rs3pwaq7nMhY6DUeINqf9g9LcQhaTTfF1gEdQnz2YHvqcsNrexnwZmh
	 B/ASa+yZCWYBzdvMzHitNFP8WhrdwDIXqBjUQh+a1LvyYrUlZRWYFxf3MDAjV49NCW
	 AS+YAkf7eiIx2CdZFbqHtjk/KNpwKRGRj/bND4HxW0HqnmkESuajK5KxuXihufv41M
	 B1OVhIhY7mBOHAMi5dLeAHMBgJIx66GHMfffcUwMnUcimkVe/4sGj4zo1VstifkGlc
	 DzkvHw2Ka78ag==
Message-ID: <sashiko-outbox-162622@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: don't fail journal recovery on an incomplete
 fast commit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hsiu-Hsien Lee" <swinds24@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261007040829.2074386-1-swinds24@gmail.com>
References: <20261007040829.2074386-1-swinds24@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 04:21:42 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> If the system crashes while the first fast commit after a full commit is
> being written, the fast commit area can hold the head of that fast
> commit without a valid tail.  ext4_fc_replay_scan() treats this as an
> error as long as no valid tail has been seen: an invalid tag length or
> an unknown tag returns -ECANCELED, a tail with a wrong tid or checksum
> returns -EFSBADCRC.  jbd2_journal_recover() then fails, the file system
> can be mounted neither read-write nor read-only, and the regular journal
> transactions committed before the fast commit are not replayed either:
>=20
>   JBD2: journal recovery failed
>   EXT4-fs (sdb): error loading journal
>=20
> The tail is written last and fsync() does not return before it has
> completed, so an incomplete fast commit was never reported as durable.
> Handle it like jbd2 handles a transaction without a valid commit block:
> [ ... ]
> which case the full commit is now replayed as well.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Assisted-by: Claude Opus 5.5
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007040829.2074=
386-1-swinds24@gmail.com?part=3D1

