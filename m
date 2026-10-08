Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB0238836C
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791487755; cv=none; b=Rw9Fzd24vNfoBI09s4VnfFhkLTnMyLmfl+r3+YGuj1AACodftDHVGzP4QKjLIBkokot9AwvU3mkx9v59ntvyeg+b6+KZlb+f8Nh6QPyerm0quYR1gllfDfbVd0pzRhmT/Io3aMhEpSJlsLDz1QepB3wuduwYAjjT/NylcDfplvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791487755; c=relaxed/simple;
	bh=6V1ZP4+bq+zZZMzDKa5VkVnhBjXREQsHIDWTYK9YHhk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=P0AWCMZX6GD9ir/dLmA2yZnzFFahtprjGZOfPYsXKrb7XQAWZJv+9uwK/zmQvp0Ywnm+OwDMbekBxZaAvQ+nwQWr1vL+aNMGkcka7+Lgce2fZsPHmkXnK+8juZ3sxvPsDGIMYyaMIdOsvPTH7dTbgYoIoUeGr020tkmeGT/STO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5WN6GAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5WN6GAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B6A1F000FF;
	Thu,  8 Oct 2026 19:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791487753;
	bh=AkSNl0NxqWzRneN0RuvR8Ouvo+uRvL1PIYHNtI6kPM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J5WN6GAslUvfVC8D3q3DxgAj4as2b0arhQZzxN6ZNB7de8WAkalwjZA2Oq1As+/en
	 4YGdZo3vh1hTSjxxM1ajaTpBZu4LfNgRlG1Dq3ZLL2AJOZFG6WcIpn+8ZI5mgvS5TZ
	 PD1hn7MM6IeaCBBZAZLUbA/c7TwmDoeFYIh6cc3yOovgjznv5EKZn1d55zXbZFjkQO
	 tlor4a5iI0LaXZNqQgZAOL7PIFYcN4wybEiHnH3P+Sg7R0P7IgjnJUQe9nGxlvg1Bu
	 QcNYMeaNcE9SbjPps+6oMG99fHWa6abOHtfMF3iCRk4MMPraWcr5qqN1vy21YKGf9A
	 dfnwjcj4Vp3Yg==
Message-ID: <sashiko-outbox-164523@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y 2/2] jbd2: bound shrinker scans by examined
 checkpoint buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261008192048.98833-3-artem@trailofbits.com>
References: <20261008192048.98833-1-artem@trailofbits.com>
 <20261008192048.98833-3-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 19:29:13 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Max Kellermann <max.kellermann@ionos.com>
>=20
> [ Upstream commit 15cb16496446b94e67f7abcb049b8e2c75cd3d02 ]
>=20
> The jbd2 shrinker currently accounts only checkpoint buffers that it
> successfully releases against nr_to_scan.  Busy buffers therefore do not
> consume the scan budget.
>=20
> If a checkpoint transaction contains mostly busy buffers, the shrinker
> can scan its entire checkpoint list while holding journal->j_list_lock.
> Large checkpoint lists can result in excessive lock hold times and leave
> other CPUs spinning on j_list_lock, causing soft lockups or RCU stalls.
>=20
> Pass nr_to_scan into journal_shrink_one_cp_list() and decrement it for
> every buffer examined, including busy buffers.  Pass NULL from checkpoint
> [ ... ]
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://patch.msgid.link/20260713102229.1598812-3-max.kellermann@io=
nos.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Assisted-by: LLM
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008192048.9883=
3-1-artem@trailofbits.com?part=3D2

