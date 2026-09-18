Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934853D9548
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727686; cv=none; b=mlodprBcYUPf8XffW10A3bUTYlX23+DkKoOpaFHsmf1tvVrxtPwMQcM7BF0EKwl8RVCCc6lnilBN7MVPVgPD7Eqnegr9cgGxbxwbS79rBX97NQOexUeRmNVzHB1zwL8YUW0LNdrT0eeRhlm+deai+556+tY5ZZx/bGGXcOUFOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727686; c=relaxed/simple;
	bh=DJlGTLSkC3pRd7r8oFJwmSz1xOFCGOqMe3vCua9+Log=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=me3MnrCmLwn9Sv9b8ESVmFFsuB5bt/bZpfac0CEDbS75GiiuUDkhmOu4VDo1WCrOsMP2W8k1PtckpSfXBERvvMEffp/A0KbZ7i/pIGzDADpaxaYLGZ8RVry/X1lPk3ElCrfYRZW00YSwTJFtpMt28L4+oLx+RiRrnXOSuMnMWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Er4D+uA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Er4D+uA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC2B1F000FF;
	Fri, 18 Sep 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727685;
	bh=DJlGTLSkC3pRd7r8oFJwmSz1xOFCGOqMe3vCua9+Log=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Er4D+uA+hDx5aBxEsywFrvaWICx3VIxDOdOqh7/9ImHeNCmZAiul0/rEdJoHg9iWp
	 D/rv2rUHGm3x4wNQCsM3sE1AHxYbU9WZzAaFb9dUuv1fyPzNmYcW4RJ8uoZ2J3V7Zr
	 8nkwDwjDdd1cJMdBFSplfkiHIZqMI2tb9+Lf+zBaa4e4FYNnwgTvhC9CRuOio9uX2j
	 42RRoE9RbeSD3NxecxFin+fNt6VR4NuBIaYiMabFn4f+fJiqSBQoLO11PstyqyTnRw
	 DwPSZ6SZaSDwDqGkittgRi07BRRFjhhKPIH2wixXjZp75ZsUQf84x4bVHGdMEzymPD
	 KIfipbFO/nmGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix OOB memmove in ext4_xattr_set_entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260918101249.43643-1-zhaogongyi@bytedance.com>
References: <20260918101249.43643-1-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:34:44 +0000
Message-Id: <20260918103445.1CC2B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> A corrupted filesystem can leave an inode marked as having inline data
> while the system.data xattr is missing. ext4_destroy_inline_data_nolock()
> then asks ext4_xattr_set_entry() to remove an entry even though
> ext4_xattr_ibody_find() left the search state at the insertion position.
>=20
> In the syzkaller reproducer, the old xattr value offset is smaller than
> min_offs. ext4_xattr_set_entry() then computes val - first_val for
> memmove(), the length wraps to a huge size_t, and memmove() can run out of
> the xattr buffer. This results in an out-of-bounds memmove and a kernel
> page fault.
>=20
> A crafted corrupted ext4 image can trigger this while inline data is being
> converted out of the inode. Treat the inconsistent inline/xattr state as
> filesystem corruption before updating the xattr entry.
>=20
> [ ... ]
> 120 seconds without triggering KASAN, Oops, a memmove fault, or panic.
>=20
> Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data suppor=
t")
> Cc: stable@vger.kernel.org # v3.8+
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918101249.4364=
3-1-zhaogongyi@bytedance.com?part=3D1

