Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE2942902E;
	Fri,  9 Oct 2026 21:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583095; cv=none; b=pHpiuNK15ToGKDoyJkZaCRdrOPF089xRWKCBTvx8iV1oHYvFIjkRIOGP6KIsdPrKUDxWk5Z7an9OT12+8ZrzuBceGjPQJtrq9uOYmFBS2YvstptOlvwyBVZgp2G8SzFGL/wTZnAXQ+jVy+o7gSQTtL0wvf6AeD9L+YNIyZewR6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583095; c=relaxed/simple;
	bh=CB9sIRtNXsNnFd3UHxrlRaeDRBtD0EI33RPKasDiAsA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QdJBKkkoMY0gsUM+c6/uz9yHG8IGOH8emzRcnq5AftnOyD44LJ4bjeXEjVxA83zy9MZL0P1DVgS3NnKvHqx9BYlsS6334Q1v9ECL1LlfFSOqR6BC4bmDsGDSHPhMMcjQ3LXWjcVqih6oPGbxgb3k1Aia8Eh/qXUciz3OHRQu+zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hszm8lK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hszm8lK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378A11F000FF;
	Fri,  9 Oct 2026 21:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583091;
	bh=ERYMkD2oX2e5tpcUcj5LQdUKF7Bc1EQLUzHyl3Z2Pk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hszm8lK6+Ftpx+6nPyovykbXvhHvAsb9udiNoagn8J+65/GAR8pu/hk8K7crnczMO
	 WumyVJmhOzerllsp3dQvXhVbzWNB/KnGFc7d84qra/34OkoLJeYMBJBAL/RcI68R+v
	 V4BHBNBCj17LXe2zaQQGTGYVRfR5R2c/IepQDuo6TwPueJ/FI3o0jXXn/GrFqosCXp
	 grALYCoay2yBPWJbcZE/PTfIQY6prwER9oHprdcyF1TdX+yoY/vH9kF8FBDHo33ys/
	 QkBgbRVnPiCS52qSMpLqBxAzweCmVtlMrMqugzZ47IwlIg661HMtVwjVUPzc/kewhp
	 o5a2CCJQ+qk0w==
Message-ID: <sashiko-outbox-166116@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] eventfs: free the eventfs_inode after an rcu grace
 period too
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009-work-fixes-rcu-v1-4-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-4-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:58:10 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> tracefs_d_revalidate() reads ->is_freed of the eventfs_inode that
> dentry->d_fsdata points to, and ->d_revalidate() is called in rcu
> pathwalk mode with nothing but rcu_read_lock() held. The dentry itself
> stays around for such a walker, but tracefs_d_release() drops its
> reference to the eventfs_inode when the dentry is killed, and
> release_ei() then frees it after a grace period of eventfs_srcu. An
> SRCU grace period doesn't wait for rcu_read_lock() sections, so the
> walker can read an eventfs_inode that is already gone.
>=20
> With a pathwalk held up in tracefs_d_revalidate() while the dentry goes
> away:
>=20
>   BUG: KASAN: slab-use-after-free in tracefs_d_revalidate+0x76/0x90
>   Read of size 1 at addr ff1100010152d8d0 by task walker/97
>   Call Trace:
> [ ... ]
> chain call_rcu() from the SRCU callback.
>=20
> Fixes: 8e556432477e ("eventfs: Use SRCU for freeing eventfs_inodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D4

