Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3503E7BA8;
	Fri,  9 Oct 2026 22:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583430; cv=none; b=QuoAHQ6Q8wQ0YX/DD+tlVqq6YiJs2AABkGfhWEaxib84UyDhwPWLxq4BLkHqgLPcJlL6//kpteuaTRFYfMBlJG45kDYlMPrI6/N3WHXyqgYTMPiEB5sRA3FtcfbXP4E+QN7CUkpQbCAzxmQ+FThNA643qqod8n5ZIcJDUMDNzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583430; c=relaxed/simple;
	bh=wiCtlW7FFmnoDeYAO6D/q8NgkjN50RTiB6a5QQisbZ8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Q09iArqZTsTUk8ml0SlBHXBo8vz8n88kTefzZ10yl6gxPz9kiBnbnvBNcbjwO5iehGD7AoUdvmdD74JA+bnTjEixaxYSasYSMtOItMzg6QDgMPS21c+MNlUl+gdaxWtZlXJrajl9VxAAPoSynOAUBW+sNHCdt4dMCzu9T9wYntc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YLD9ZS12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLD9ZS12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC001F000FF;
	Fri,  9 Oct 2026 22:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583429;
	bh=Y1k2ZeKyE6Y9KqA1Fw1PO2UdQZynZujFpmrDULxNxLY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YLD9ZS12kam9StuBXa4GVFLxWEPi/ded+9XgbFlGffgsnhX2OZvUahYlfVgsPRchi
	 GESswVlie/ETRZvJbhH7WGqYEKIMj55sWf4+sNBtccPSLQ+dznCi7UhUYFdLg77YH6
	 zxjkxLBjp6M2g2jzHfWVjNUsRPcOhP4cuzsmF+y9BEpc62iAZl4nGqb00Xa6SFs2Ow
	 gxcuQLC/GuHKCIk9t4xVw7UT6YW9NZBE2HcA+Sa2JQEnLWQZ+wD+8DZhFScv446YVs
	 ro73y3bU3/DWdkO4iFAVQcL/rsctYiCv5lYfRQsdZQGzqO4saFsJk6ORIFJHVhe5kV
	 ZPhBikWoM3h5g==
Message-ID: <sashiko-outbox-166121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] ntfs3: free the sbi after a grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261009-work-fixes-rcu-v1-7-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-7-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:03:48 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> If the "nocase" mount option ntfs3 uses custom hash and dentry compare
> functions. Both access ntfs3 superblock private information in rcu
> pathwalk. ntfs_put_super() and ntfs3_kill_sb() drop the info without any
> rcu delay. A lookup that's still inside the filesystem when the last
> reference to the mount is dropped causes a UAF. With a pathwalk held up
> in ntfs_d_hash() while the last reference to the mount goes away:
>=20
>   BUG: KASAN: slab-use-after-free in ntfs_nls_to_utf16+0x752/0x940
>   Read of size 8 at addr ff1100010453c850 by task walker/99
>   Call Trace:
>    <TASK>
>    ntfs_nls_to_utf16+0x752/0x940
>    ntfs_d_hash+0x22b/0x500
>    link_path_walk+0x11ad/0x1d30
>    path_lookupat+0x63/0xb00
> [ ... ]
> holding the lock on the same cpu.
>=20
> Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D7

