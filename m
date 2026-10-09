Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A6543F0AA;
	Fri,  9 Oct 2026 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583467; cv=none; b=KIJi+c3uO85ZSzMU1Q4hlpXd8xI8fexiEY8HHSuAKzCm17ro2d6vZ14vlqvanwOypnb8kBTgQog//ZQK+LdghaqiFdUujyN3AwC4lIp3kSbz0iZZRlAKRD3aPBs4JcObRjQzkWEDgt4SwPVKWDQ47YRnddSqkkhB6jbtMv0RpxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583467; c=relaxed/simple;
	bh=GZaSOTdL3rpy1YeXSQ85aB3pHlWaEXs7u503VJzFjMs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LWygwmXbf15zIysdyREP5yx6R1nMxfmGKthD+3Uovpmt/0E1DOwgiq+ODm2YoQTGEnCIT8YIRkcRAxeWyeT2bFYCgKGbk7k/xSETThZNFVo/ACSb5VDPBAnq/pAXqvaQ8SsRc1wTXhshF8/k3XLoI7Hyn5imPSoQPJ3V5I2Wk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DojtoKX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DojtoKX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803B11F000FF;
	Fri,  9 Oct 2026 22:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583466;
	bh=qBX/J+Zf4HhKSuAiSxQz+ZN6Kjgxksq5pywca7Zx5Cg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DojtoKX4+tzCbZvlIEJNHiBU6eH/VQwVwaRNHmb/v7KtrziNMHam3m4VA7jc3a+rH
	 b6cS0J3plz7skAYDrYdclS3KHxbFynfzSqdniRNJdkPo6dvBw5l1rHPnZxSaJ923fn
	 1U20Dn5UifcY46giPHYpfJfz0KsHtzD49HBurXd/1gAfzvwVhQNaRMKCrlLxBXN29C
	 4yJ5QWlcV2WR3w6Ggc8UlXrwqeGtBfKzHpdgbNh+zHw/PsBtHlccE3u06l5n4dMWPU
	 1knaat4wT5zkniV8cJHq307SsXx53U79pH/gu7/JvaC4/tH5c7KaXBXQA0QmX7eLxI
	 jzNID8WO17qnA==
Message-ID: <sashiko-outbox-166123@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/8] unicode: free the map after a grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:04:26 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> generic_ci_d_hash() and generic_ci_d_compare() read sb->s_encoding and
> dereference the unicode map while a pathwalk in rcu mode holds nothing
> but rcu_read_lock(). The filesystems that use them, ext4, f2fs and
> tmpfs, drop the map with utf8_unload() from ->put_super(), which runs
> when the last reference to the mount goes away. A lookup that is still
> inside such a filesystem at that point reads a freed map.
>=20
> With a pathwalk held up in utf8_casefold_hash() while the last reference
> to a casefolded tmpfs goes away:
>=20
>   BUG: KASAN: slab-use-after-free in utf8nlookup+0x74c/0x950
>   Read of size 8 at addr ff110001030fe658 by task walker/98
>   Call Trace:
>    <TASK>
>    utf8nlookup+0x74c/0x950
> [ ... ]
> overlay is gone.
>=20
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D6

