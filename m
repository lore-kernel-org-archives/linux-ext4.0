Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190414;
	b=CvjyK6X1IAyWhNTXTahX2K6isYaM++n88B5BI8qljrmFwNYjRSMb68S8M/ig1pbKlsoo
	 XGurZcWJ6/4IaQ0Un20HsTXN4Fgtkk2yyzUv2uXs7HRLxKzDaAhbzfCZ4JajNmHMvPsXj
	 cr6XisNSZqD+kLju3M/sq+kNDUd59ibKGInby0NovG+1UdVE7YRqQPQDRHW/2SS3/3CFF
	 3c1+56YTPGH89MDIZVglQ0yEKJZEA8hKjBzB3FER8amcXcs1danO4KfgmlN32F2p3ksyd
	 2UxJHIc4TLP6drMwquw2snBq/s8k+q7OkFlfILLGfnTMPQbwQc3m0T37DzQl4XCOCtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190414;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4T3/6xIDHE0O9X7AdqXEKlFPOYvO28J73umAhgt7tVA=;
	b=0hczWaYFL1BT27nrdO7Xrksur7Ne9VpI7RLhellzzcpd+lxaPuvR9NvtLdO/lN2BSMJH
	 9L/hIHkHXmvfa7wErdC5PpLoDpx9nAomuOxJx6siO0BkzuhU6TChv0KgajHPFyKwlK7hT
	 p4yRjYksdH79qu1OYehv3MWhGo8LsLbE98mZ8tI6ct1+QNUE4GvDwIzIWY1ri412sallk
	 enwgGVkh8i0uW9JmSt2en+4PRjV1ooFqQFcbGb0nPrNiLrMuwA4TKy0xT8Fxs6rRa/rxp
	 WOMCxtMeEwh2BezfKixyQn0CWa+y6d/PJgXICuNekvZKCXePua7rESbgZNzC2HzT00w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GaT1n0WK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D5606A338
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GaT1n0WK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AA71F000C6;
	Fri, 20 Nov 2026 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190413;
	bh=4T3/6xIDHE0O9X7AdqXEKlFPOYvO28J73umAhgt7tVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GaT1n0WKlpA43wdk4WP5MbWqfAOp/q0pk+U1D6zkjC8fhBdl3AbvfcFdOUUAcewss
	 5Iay92zTKsAjVG2NXL+wuEvX3XQq6zKpsnKgs/+EEMXzAkKc3p1kaWMwz6pVRXlQnU
	 eeWbfbEUDnbh6cSBudGtmZi3JTdbvHpCY1frqUPALd1T+4Iy3hSGMVLex7A8Y7QNCj
	 fKdV1381iRRBsLOHxFt+btkRe3OBkXmFMi+5140c0rciL/veb24J0aAHdoLDJ8wm7S
	 x/UU5ZgNI9q0upqYEd9VkWI4FkD4cYoyazhTt3e70KFwZjARLWopCCTjRwIaDWCPC0
	 XHGX3EiNKoDRQ==
Message-ID: <sashiko-outbox-225503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/7] fs: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-3-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-3-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:00:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
> Filesystems could return verity status with GETFLAGS, attempting to then
> pass FS_VERITY_FL to SETFLAGS is not allowed.
>=20
> The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
> however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
> doesn't work on BTRFS for fsverity inodes.
>=20
> Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
> no-op. The file_get/setattr() path is fine here as this flag is cleared
> right before fileattr_set_prepare(). The future fsverity support in XFS
> would also need it.
>=20
> Cc: Boris Burkov <boris@bur.io>
> Cc: David Sterba <dsterba@suse.com>
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D2

