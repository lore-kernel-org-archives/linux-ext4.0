Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478683D9674;
	Fri,  9 Oct 2026 22:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583442; cv=none; b=CNGDC3osV+ulT1HQr8jdbhHBYBagizKxGD2I9ze+fTPjUz8XiLwUKI7BBKWpzm+qB1G+Y+d0K+jwtZnJysgr+aMk2uHzSQJuXWMJ6yWLkdBlAE0eQs6xoVYnU/NA1HRaLtW6rOqVW1BFLB37C1QK5nprxhzGuWXM8wua6cZYX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583442; c=relaxed/simple;
	bh=Ef8Q8V5kq+LrKUKbxlBtkqFwTHJcxF53RnpJRHWH+VE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=PFO6mgPT5qO1k3IvfHlqmcC6K60StKTAOgP3x785EkKgz9aQIR3NeKQNHMjYe9WOpKP/mPmg+z2OglQDBxJhQryJZSrlSpjJAFUllyLSG/k5swbxyALfk+0+/YfKdETa0gojNBGnz53TiGfxLCFPBERwErwJ/YRWPPXQs1CTeo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzrNZtp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzrNZtp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3351F000FF;
	Fri,  9 Oct 2026 22:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583440;
	bh=Ef8Q8V5kq+LrKUKbxlBtkqFwTHJcxF53RnpJRHWH+VE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KzrNZtp7Bcwig9jHax7okKr+3lz0SG2CqOpnpTLwBr3afeowK0tWi0q3o8+gvA/bD
	 elAQhHhRJuQWfCB9g4UbUmbt/uNsC8P1COh9b9fBd2SHjOFW4r7EGa4WE4wtxyAx9f
	 +Rk7DLcXgYrl9U9WMbv0P3a0UD0c9FIUhxhOAPFwEQh9YCL0bRYo+iYFvjNXLnW08R
	 4oQi3xZkbuoWTaNAn2lpuEd8cpDSgpgG7BYzUh1CU58DVzdcCGYcrpxXwX1OEvwAJS
	 cREQ1a+oLNxwaUdEk+E//RQKpiR1nUVvWtPpdOnDqUYR1ND+eYRnEEEWF2SmxhoUZv
	 6gzbezVtjKgJQ==
Message-ID: <sashiko-outbox-166122@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/8] 9p: free the session after a grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009-work-fixes-rcu-v1-3-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-3-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:03:59 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> v9fs_vfs_get_link_dotl() reads ->cache from the v9fs_session_info in
> sb->s_fs_info to decide whether the symlink target sits in the page
> cache. It does that before it looks at the dentry, so it also does it in
> rcu pathwalk mode. Without loose or metadata caching the dentries have
> no ->d_revalidate() that would make the walk leave rcu mode before it
> gets there.
>=20
> v9fs_kill_super() frees the session and clears sb->s_fs_info without
> waiting for a grace period. Right now a pathwalk can't still be in
> v9fs_vfs_get_link_dotl() at that point, but only by accident. umount(2)
> waits for a grace period in namespace_unlock() before it drops the
> mount. And a mount whose last reference goes away elsewhere, like the
> chdir out of a lazily unmounted directory, still gets a grace period
> from bdi_unregister(). v9fs_fill_super() sets up a private bdi, so
> generic_shutdown_super() unregisters it from kill_anon_super() and
> bdi_remove_from_list() waits in synchronize_rcu_expedited() before
> v9fs_kill_super() frees the session. That grace period protects the rcu
> readers of bdi_list in the writeback code. It has nothing to do with
> pathwalk.
>=20
> Don't rely on it. Keep sb->s_fs_info and free the session after a grace
> period.
>=20
> Fixes: 712da38d134b ("9p: Enable symlink caching in page cache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D3

