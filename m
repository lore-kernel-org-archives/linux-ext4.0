Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CADD250BF2
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 10:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727174; cv=none; b=cmhviMDsx/B8Tn8No2alpm73munqwG4sEnSPNxNDXPDvUEqnlIandTa87nHkkEgFgy5NCoXCUsIpbxwqNgpKz4EAIQ2B7PbB5bGOmrtiCgWskg8UVm/akp0VM3PAnn3m2Ril8uKriHK5Vb3rIipBocGaDb7pTZlaSMpisNNm340=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727174; c=relaxed/simple;
	bh=fROcsYeifdebroA4XjVpmrG3TpCA38KJ2wdYWuiP5jg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aOhvKDNIBMUfCwd+MMl42rRxFuI3ic6BxAcYkuciGDG18o36y3cegEAK/+vCo1/tFNz0cjKMHP+t1NV5Dm1u3rN+fl5KRLwhgWm0Du4GVZBdzCZ9+7UJA++HTaw8QZSdu7dj950QSdD7BZ77KMJ1r9ztY1kGNXf/quBHZJx3eJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNQGLtds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNQGLtds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B791F000FF;
	Fri, 18 Sep 2026 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727173;
	bh=n80nYTO37W+/wxuvS6aGzneGgdY/uOFg5hlZ3ii7eb0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nNQGLtdsXXEhMTJWqJmumLP0KDemDwmJCKvGlkBS5oEGIVrNyeQehvnA/rDBnIvCR
	 S9OHuXeH36Q4u1GUoxbBoTJESoEy61uhB9M0JED5P158O9rP2bKdCj7+mmEAim3jGx
	 CFoI2VXWWUFvx2PqudOzSnwsD9Z299UliMjM8oQsq5stcPifjiv9tRd6p+f2xFUX6C
	 f0y+meWM6Zu3ktRfRetNOFYnIm9chkIKz+mC2kWiqcy2wX1+4zAFlxaIKFpqGZDl3O
	 gHMqDEEhTB9DkzMz0if/MQ3cqPhf2Ah8b6Ay5CMhYbvCAZ3rA8vggZMfIxoJKahNc9
	 yqx3eokVbETBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't free the tmp_inode tree after a partial
 migration swap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260918101240.3721805-1-chenyichong@uniontech.com>
References: <20260918101240.3721805-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:26:12 +0000
Message-Id: <20260918102613.12B791F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_ext_migrate() cleans up the temporary inode when
> ext4_ext_swap_inode_data() fails:
>=20
> 	retval =3D ext4_ext_swap_inode_data(handle, inode, tmp_inode);
> 	if (retval)
> 		free_ext_block(handle, tmp_inode);
>=20
> ext4_ext_swap_inode_data() switches the inode to extents and copies the
> tree root into it before it frees the old indirect block map, so it can
> return an error after the swap has already happened.  The copied root
> points at index blocks that tmp_inode allocated, and free_ext_block()
> walks that same tree and frees them, leaving the migrated inode with a
> tree node that the block bitmap considers free.
>=20
> Only free the tmp_inode tree when the inode has not been switched to
> extents, which is exactly the case where the swap did not happen.
>=20
> Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918101240.3721=
805-1-chenyichong@uniontech.com?part=3D1

