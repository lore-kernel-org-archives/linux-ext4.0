Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6098D3A9636
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802127; cv=none; b=E/1tSc40cii9RBaAxA51oRWD1oWJr+wgVSD/Ngivw380m0eykIYVqKBGPWTFkcA30aCKYOugVsKQgs0ihvX0rLRmrmAQLpbZUMk12kLJh3r/LPC5FEv7o7hsYpTiJJlfPmPqLIbnycH9WlrxmmOvS35QmYTQn1F/eknivIf++FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802127; c=relaxed/simple;
	bh=wiNGeMoE1T2QyDBt3YDA3mLIyw77/1mV6twLabPhNMc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Bqn9OIa69lS+J2CzLHCT5qusRi7TZj3khGEX8EEt8+xmYWskJJz32wQzkTjWhFx6JD61tE2Uhn7eU5BXY2BGJW7YUxw+BKrToB6XR4zQ2mvQbeuQ0mcllmNBjbcNhXeE9Um/C2TvGW+MgEXx9J2QvW3LdbJB9NP0A5VY9K0pES0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGtlOKqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGtlOKqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32781F0089E;
	Mon, 12 Oct 2026 10:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802126;
	bh=wiNGeMoE1T2QyDBt3YDA3mLIyw77/1mV6twLabPhNMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VGtlOKqLWT6JuXOQaEmImPBFwOv8pDwAx4xRAv8Qmw6sT0lD8CNwC0IC3VE/cVHJc
	 cfNhzmYuRrlVNnbymfgwvj1iBvjSIufhnSVhF75CPGRBuFDt+Jb6w/81zy/YrSGlBT
	 yIWEutqJ5dmYWsSpfP6Z/4oOmM3rR7dUw/+YTLlS0hGPB+4fKn35YrRz1lZJ4Bx2iC
	 oUG9EnksC+Vpwgi9NYi37Xqh9OGBhuGj0JwYb8371YSnFkin0uJ7aAglRLYb+3giAA
	 vahx0nWmq0uLBdPcfIz4iiF+byc4HbzpbpBTlztKdhz0Nt6YbLo4PnThj2lbf0qQQa
	 xmmE031tXjZuQ==
Message-ID: <sashiko-outbox-167985@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joel Becker" <jlbec@evilplan.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz, "Mark
 Fasheh" <mark@fasheh.com>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:48:45 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> do_withdraw() sets SB_RDONLY from the withdraw work item without holding
> sb->s_umount. gfs2_withdraw() sets SDF_WITHDRAWN right away and queues
> gfs2_withdraw_func() which runs do_withdraw(). That also happens on a
> frozen filesystem. SDF_JOURNAL_LIVE is still set then because the
> freeze log flush doesn't clear it.
>=20
> freeze_super() and thaw_super() both look at sb_rdonly() to figure out
> whether the s_writers rwsems need to be taken or released. gfs2 doesn't
> even get that far. FITHAW goes through gfs2_thaw_super() to
> gfs2_do_thaw() whose gfs2_freeze_lock_shared() fails with -EIO for a
> withdrawn filesystem. So FITHAW never gets to thaw_super() and the
> filesystem stays frozen. The only ways out are emergency thaw, which
> calls thaw_super_locked() directly, and writing 0 to the gfs2 "freeze"
> sysfs file, which calls thaw_super() directly. Both see SB_RDONLY and
> skip sb_freeze_unlock(). The rwsems stay write-locked, writes through
> [ ... ]
>=20
> Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait fo=
r it to finish")
> Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D21

