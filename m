Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF59C3CB544
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 19:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791487576; cv=none; b=gNvdqdNxhZjR9Mw0wQxnyR8IHOnETxhejSMJkWjpPa99blscjCSAxnwytLJTcGyVm+6E1oQoLZRUXj+7zzb6FRSs6VcaaqY/T0NelSFaQX20WXhnwAFIyInuc8pRzjCDUm/SRh/P+9LdHQ1Up5Fdofvv6cAvudjah8hroq9WmzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791487576; c=relaxed/simple;
	bh=Iwp65sv94mqgOUzKAoXKu1KRGHGcyP5XCKaCc6BWroU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=r+F8+ZpLmwdMUPGbXbATxdA10qjH+Xv8HybPso2u/+YtoEyEmFoOnfiq8oapMhwZru7fMK/Xx72Uam++y2jSiG+j1vIhMfdLTNrgBA3FIhKjj+XtlTpaISF6WeiuXKRXbjkP2epFLFlQmBLMfm/6g52hmUQScgLRudadsW8gLvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIh/Dehx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIh/Dehx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2357A1F000FF;
	Thu,  8 Oct 2026 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791487567;
	bh=qaOEHm9fNEuXtXu1mDOyxurxKB3DEQMWGFccjOCT36c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WIh/Dehxwlj80TTg3h9Suo6qamfAdTvqXb/bnvEP970NlVxa88Iv5tE+NYWEzRRsk
	 rzr8uPfwleJlkl9R9yFMR/J7GhJE7N0l2GtZJdaCNPeQU53i79v55jpzbH2QNSxx3s
	 qQNI58KCuc8e4RjTv+WxHzN08sNqK/ujNIfEO404bjJBYLaEZniM9GGZuWJS7SYXio
	 wzsx9/aUhul2xDabc1x62Deby8EgSxmPIb7zwVWtTPPoW8QrUgGvP2Ae66UKhJO0P6
	 3IOFBZKJWscstB4wkUCVEwIvlfmtdeHwfwq8W5f8bESnYvWN72uOiyeBMoqSdhAm0m
	 Bhoz0zoJLvDUg==
Message-ID: <sashiko-outbox-164517@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y 1/2] jbd2: check need_resched() when skipping busy
 checkpoint buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261008192048.98833-2-artem@trailofbits.com>
References: <20261008192048.98833-1-artem@trailofbits.com>
 <20261008192048.98833-2-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 19:26:06 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Max Kellermann <max.kellermann@ionos.com>
>=20
> [ Upstream commit f213e12ff5c9590b1034ae8da0e6d09665c772d0 ]
>=20
> journal_shrink_one_cp_list() skips busy checkpoint buffers when called
> with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
> skips the need_resched() check at the end of the loop body.
>=20
> Consequently, when a checkpoint list contains mostly busy buffers, the
> shrinker can walk the entire list while holding journal->j_list_lock,
> even when a reschedule has been requested.  Large checkpoint lists under
> memory pressure can therefore cause long lock hold times and leave other
> CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.
>=20
> Route the busy-buffer path through the need_resched() check so that the
> [ ... ]
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://patch.msgid.link/20260713102229.1598812-2-max.kellermann@io=
nos.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Assisted-by: LLM
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008192048.9883=
3-1-artem@trailofbits.com?part=3D1

