Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795632331;
	b=YzYMinmh6szeEqNjx2yaq266ova4zdLXSvEdF0zAgOvri3xwQQePitP8UqnSS4bqNNJ7
	 FyPf3gY2/jtDBPi+esd061fFQG3ymNpKi9zNpuxlxj4wT0/+8mNYXZrLIa20uaKEsl//q
	 6Ty8XeDBAA3f9G629Lw9vAc67Oc1b/JZEjsMA+QDDkjbdC+aQF2EGhHlq5MlkRR0SQ0ct
	 7RGYK9ruRalqmd5u+8XkYuZV+P92HqSSuZp3Ur/awkCgb8c/x2JweHaD0PIt2pls8l/p6
	 RU83YTVef/NOHhWhxKXLU4DGrHiIRsg0mMSq6/E+LNsXzWcd7GijTYgViWzlLzDO28w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795632331;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4K6blBK3gzi+XHE92gbNOeyrHL8jqzaUMWEv78QJWU0=;
	b=IQKrvS1lt0LjUL4iK7b5DQhYke7Bwsa7Yy7F+gqplzcgaRjj85Omj0p8HHmnS8cQUSFf
	 WYiVADrroz+D2A59hVrvXL6vynTLQKJCfwYXe7jNkj6GS3ZMQKP59KeLLW5pkFF3VEy4n
	 Cspajg9FvISO/SMAI2iOxGkwmtArc46N8Go+Suda2+2zEWmjDWcuQek0VpcwqV+bjmOZg
	 9Wd1/3Ckj+W3Yqp4OKl1KVcxleWGZtRF3E3AsKJ4rQV28hN9mBExsQrH4knYEzEFGpUnY
	 +58IcwZ7+tXvSpH10FCUG5vH4m4xQOc1EWwZBPvVVr9OHROC9ntr3tz7fdC2q9dGwXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQZltHOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A59606A327
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 18:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQZltHOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E2B1F000E1;
	Wed, 25 Nov 2026 18:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795632330;
	bh=4K6blBK3gzi+XHE92gbNOeyrHL8jqzaUMWEv78QJWU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AQZltHOdFuoRBPCnoRCaKEmMSpdgbutrMggA2inH8fJcGpTu4YJBa6LMERD5f6Zs8
	 5z/rs1Xb2emncONzUcP9PZw5bG/CJ79I/CnPFOE2lEHwQ17W3PycgDMoOGHj5EkEAS
	 JYulXHCDLlpPgBO+MnYi/LPvrNrunYIdRoY39Y2YqtFH/tm1p4oCylVlsJoK05Y6jd
	 lwPg5aR7k2ZxGsPjHIU/bMNF0lWuO8t80lz9rY2J/EIwrBrBkCron/VWM5oWEKHKE7
	 q0udmwEzCLHtoQCiEbiE++9Y/cQcitVQGzmNMPuehRMlSoPlifBWw1u7mTyGiKi8Oz
	 2r9T/6Q9RNuOw==
Message-ID: <sashiko-outbox-234011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: Document the h_invalid flag of a handle
Reply-To: sashiko-reviews@lists.linux.dev
To: "TAKANO Mitsuhiro" <takano32@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125184027.2402549-1-takano32@gmail.com>
References: <20261125184027.2402549-1-takano32@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 18:45:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] jbd2: inaccurate kernel-doc and changelog description of
  h_invalid
--

commit d4f35738c639ebc73d068c9aba7408601b8ba4ea
Author: TAKANO Mitsuhiro <takano32@gmail.com>

jbd2: Document the h_invalid flag of a handle

This commit adds a kernel-doc entry for the h_invalid member of struct
jbd2_journal_handle to silence kernel-doc warnings.

> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index e3886963ba004..361aa5dbe3954 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -482,6 +482,7 @@ struct jbd2_revoke_table_s;
>   * @h_sync: Flag for sync-on-close.
>   * @h_reserved: Flag for handle for reserved credits.
>   * @h_aborted: Flag indicating fatal error on handle.
> + * @h_invalid: Flag indicating the handle must not be used any more.

[Severity: Low]
Are this kernel-doc description and the commit message accurate about
what h_invalid means?

ext4_get_nojournal() sets h_invalid =3D 1 when allocating a dummy handle in
no-journal mode so current->journal_info can hold saved_alloc_context and
track nested starts via h_ref without a JBD2 journal, and
ext4_handle_valid() checks !handle->h_invalid to test whether an active
handle uses a journal.

Also, __ext4_journal_stop() does not BUG_ON when h_invalid is clear; it
calls ext4_put_nojournal() when h_invalid is set and jbd2_journal_stop()
when h_invalid is clear (the BUG_ON(handle && !handle->h_invalid) check
is in ext4_get_nojournal()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125184027.2402=
549-1-takano32@gmail.com?part=3D1
