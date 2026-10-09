Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F795501F4D;
	Fri,  9 Oct 2026 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583254; cv=none; b=Z/5PFMjjO5k6ECVce8gEYESyuV7cKBuzMhRDXBj9I9cNREdvkkEQpAZyPUWDeD8FCkIDFoWJIWzWyUvKEv2X/e4fYeBncXsJW9D4dGsClwRW8krbYlrSD17XzgnSc0pgl4g+6K0c9yehbw7hsDLeN1PFWWy9gSsNg1KQjhHmrX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583254; c=relaxed/simple;
	bh=xGWRDgZOwjTdIG8BEZV/aXzJ22g1KMl6YzIsV1GBpn4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rBs0I0U1dDxMsM944kHg6Co4tf9SJykN7K0RTc6q8pNEDbnApU+tkoAA12o+zvwKdXs4/9daUhjo5k5OCB6an7JGjHrgs0XZm9sYiwR3WKVuRf89Qz0yq+0W8byhz1i9yoslpDpFy/W5odtoy5DVzsRdpqRg7YjSQ7ABFPuSbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+wYyLqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+wYyLqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856311F000FF;
	Fri,  9 Oct 2026 22:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583252;
	bh=xGWRDgZOwjTdIG8BEZV/aXzJ22g1KMl6YzIsV1GBpn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k+wYyLqitr6ObJCnOIP/wiDkNJiepGI2W9ST05xKlJkMtwjmw4awuNU2JkpodzWcN
	 NZ1l6cpq4E3q+r68FsLjwgJDlEE10OrRWf9H22e+M5e/kfB1YmSn7mmAeCQh2/iSml
	 i6X0mCUv8PTWze1q9/l7eqklZ8X8VIIgiVPH07mK0LkE/CHppx4HraTVoP+u7a8Q36
	 ten12QUEU9lEti2pmwgrTfjjs0ZbYTKj988m/mR7FJ8F05EbuBUoA46vD68/OmokSF
	 YFMt3A73ZIR1pAezFI61p6LySGsDBwmMA2UQPwRm80uUyfHRa6NrW5eysPJIzuUYnz
	 Y70MHFT5p/QEg==
Message-ID: <sashiko-outbox-166119@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/8] ipc: drop the mqueue mount with kern_unmount() on
 setup failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261009-work-fixes-rcu-v1-5-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-5-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:00:51 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> mq_init_ns() creates the mqueue mount with fc_mount_longterm(), so its
> ->mnt_ns is MNT_NS_INTERNAL. When setting up the mqueue or ipc sysctls
> or msg_init_ns() fails afterwards, create_ipc_ns() drops it with a plain
> mntput(). With ->mnt_ns set that takes the fast path of
> mntput_no_expire(). The count drops to zero and nothing ever kills the
> mount, so the mount and the mqueue superblock are leaked.
>=20
> Commit dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
> added the first failure path after mq_init_ns() and never dropped the
> mount. Commit 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on
> sysctl setup failure") tried to fix that with a mntput() but that
> doesn't help for a long-term mount.
>=20
> Use kern_unmount(). free_ipc() open-codes the same thing for a namespace
> that made it.
>=20
> Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
> Fixes: 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on sysctl set=
up failure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D5

