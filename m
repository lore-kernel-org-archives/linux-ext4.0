Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794368332;
	b=omC5yjDy0QXlm9OhRt+j/0PDEnjy0lppDrTtWRHlWfbxETHRS5fpC4BUWkCQRYb8hH79
	 cd27X0ldiuIzMLpzhkKYsiR5NDyo5IYogzk4jpSHRVHrVDNs/4gZ2oRx3qYWLPBL0y5+8
	 Y1Rt0e1PKeBWn21ENqNHQTipx5Rqmd7wpwevrAAQ6DFJdpN8l8kpRd6eKvcYwcKpPCOj8
	 ZJVPwRa83TP/o3quNmMPEB5XG49yBBmduf6ioTg1OIfvV4bTZIQGWZZ9NLjllCbsvacLP
	 ldzvurVhcLP65KEjdsgoMdxk9dpb9gpJJ1OJHGUVQI+AoF/1/Uw1WMwnRJYL7VypoYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794368332;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uDxehLcqtDum2NvD10EWmZpSN+a+/1/QST6UpsvyZlg=;
	b=D/H71WNsJ61HJ7S9nxAvuXFqWFSDPLDiq1qf66T1vnebjv3A1ESXKZdFOrxjiluXH8Rr
	 EkOWXfRHxeCxaYpkQiof/y3a6reG+fWyiVGgKiC6eaLh2LiEFhQo9Pb+sG7DUGQDbob1e
	 +UBQTEAqi2VM52EsSv5ykqP9qIaUE1INnakptFLT4UDdz4pkefVcWkXZVNFFgL5Sg3lL4
	 o5ATefeF0523DswnSmKQNvkZx/ZLLc+FCXkxMzHNGoQGSsPKjhImlQcXiwh79obyy1L1Z
	 jg/HFfZFlp0UiO22hXzMOpwtCHP4piIdsJFpPFuACKIm3Bu0w/Dh74jt7PG7kZTCgxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yv9Khm6R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C758606A31C
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 03:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yv9Khm6R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821601F0089F;
	Wed, 11 Nov 2026 03:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794368331;
	bh=uDxehLcqtDum2NvD10EWmZpSN+a+/1/QST6UpsvyZlg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yv9Khm6RXa3u82Vi4ipHYRo+nmbVoSg399X/gdgy7YP5cR579vZVTyhgSctuCNtH8
	 nxyqjDNQalCak3qq2tObrWnW4rsZiynkorm9RVo8i30Lag8FtOtdzqoV/lYcAvSAQv
	 TdcAGfl0jnFLw6dI/4kMOWh2EAs+1vTLqm7t0ReqFDsVZ1lwxtoS4GKVn6rohHwVFO
	 igpFq2seaeUCwAdrzax++M+4T0MEzgokSVfwISNOFzRb2uXl1dBtLWxFIheUEL7r0r
	 J28iLH2us7AQYyLfJNbYMMulsOAzZ/qQp+o7qMVkwZBhgeLKItz7k8reeQn3f6UkNH
	 b9CUooutDVdTQ==
Message-ID: <sashiko-outbox-208211@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: make concurrent DEFAULT shutdown waits killable
Reply-To: sashiko-reviews@lists.linux.dev
To: diasyzhangqing@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261111032743.549426-1-diasyzhangqing@gmail.com>
References: <6af1e75f.3e87765f.91969.0010.GAE@google.com>
 <20261110132118.11265-1-diasyzhangqing@gmail.com>
 <glup36pqwuh2wsxjozp3x4kne2spsud65ftlw744p72hmh54mx@hi2s256gr3iy>
 <20261111032743.549426-1-diasyzhangqing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:38:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] block: missing Signed-off-by trailer and real author name in
  commit
- [Medium] block: commit message is a raw ext4 email reply with wrong
  bdev_freeze() info
--

commit b7fc68757e7a71c50d74a009f283890518f74c9a
Author: diasyzhangqing@gmail.com <diasyzhangqing@gmail.com>

> ext4: make concurrent DEFAULT shutdown waits killable
>
> On Tue 10-11-26 21:35:56, Jan Kara wrote:
> > Err, no. This is really syzkaller self-inflicted damage we aren't going=
 to
> > work around. If anything you could make the wait on bd_fsfreeze_mutex
> > in bdev_freeze() killable. That will actually be a sensible change and
> > should address syzbot warning as well.
>
> Thanks, that's indeed simpler.  All current callers of bdev_freeze()
> (the generic FIFREEZE ioctl, ext4, ntfs, ntfs3, xfs) already propagate
> the error, so only the wait itself needs to change:

[Severity: High]
This commit is missing a Signed-off-by: trailer, and the Author header uses
an email address instead of the author's real name.

[Severity: Medium]
Does the commit title and message match the change being made?

The patch modifies bdev_freeze() in block/bdev.c rather than ext4, and the
changelog is formatted as an email reply rather than a standalone commit
description.  In addition, ioctl_fsfreeze() calls freeze_super() rather than
bdev_freeze(), other callers exist (lock_fs(), exfat_force_shutdown(), and
f2fs_do_shutdown()), and xfs_fs_goingdown() ignores non-zero returns from
bdev_freeze() and returns 0 without calling xfs_force_shutdown().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111032743.5494=
26-1-diasyzhangqing@gmail.com?part=3D1
