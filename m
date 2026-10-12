Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78801381EA0
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 06:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791786325; cv=none; b=EHGgJk1HGELR246cwQoBhlkXkNT81/CbpGTKH3cdH3v1eFQSgpi3oKKlXfTrUrp5MTAiL6J14hMiaUzSBI4r6BkziWUIGWgpX/PgNr96AFIkQM0hGseXfRLWhjENUtoxnnbQEOKTG0kxlC2F66EhmlByYHfC5JlLuj+JovbF744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791786325; c=relaxed/simple;
	bh=ABCMQn19fZyGkfmN4Pp3uCSJImt3V2H5JRZYOmW8VBU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jM1iASwSS37lQJnfBrNvm8CzmP77itfDaouTDpZWEsu0VDzAaKLxdz+rXalpoO8ZU+IfjT07lXyFBWd8U2UVAxNrWkkQ3pI4iyVr493HcIwAhtY/JfMgRZJAHONi6vaqTv1B/iRTAeTn0rRfmo7Oi6VkLiOvT3Gtf/SvApF5Qtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9GTiMNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9GTiMNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2351F0089B;
	Mon, 12 Oct 2026 06:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791786320;
	bh=mru+Vx6wQUHDqp48nZl8mDxW+IDIMYhtRJP89bZvmNs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n9GTiMNieLpcLzUuGhFextkjvQc94a5XFZmXAZ0+8KAsTJnzva24djYkYwTBNTPgV
	 4pZeGH85CMhm1oqAgJPPSIT5ixtbl8ylJ8eC8uyX4oVlhPyMslSI4gxcOxGzmgy4n9
	 jlDKeA8y3pWZNhpPQ2XXYDCLlhnyw8LiR+BILFwO8EOwAq09yxPr/q97vPO+aGBPPV
	 nou+xv0bCBiXpiLMFTiqR/iaA6V6Vx00ZugJfFSo7dPGVMhFffBQUotn4HfO41IJQ4
	 kKT+efLh+nzQ0zl8bdy5IwXn6oLoHjLJd4W0UxyjKT3j519cGAy1LlRBF9ZdnK8ksx
	 A7iOVlpTieCwQ==
Message-ID: <sashiko-outbox-167731@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: check CAP_SYS_ADMIN in ext4_ioctl_get_tune_sb()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guanglei Zhu" <zhugl3@xiaopeng.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012060844.836001-1-zhugl3@xiaopeng.com>
References: <20261012060844.836001-1-zhugl3@xiaopeng.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 06:25:19 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_ioctl_set_tune_sb() requires CAP_SYS_ADMIN before changing the
> superblock tunables, but the GET side has no permission check.  Any
> user who can open a file on the filesystem read-only can read the
> whole tune struct, including the 64-byte mount_opts string that
> mount(2) stored in the superblock.
>=20
> Require CAP_SYS_ADMIN on the GET side as well.
>=20
> Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock=
 parameters")
> Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012060844.8360=
01-1-zhugl3@xiaopeng.com?part=3D1

