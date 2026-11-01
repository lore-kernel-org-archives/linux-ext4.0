Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793538091;
	b=NEW4TjOMiWDdN6g2Xy4RsV1W/amJW/bHBQGpsSAwtgHzRLWyN0K2ZxY40eJC3M4uZsuR
	 NMmrxMFPG3VR+rnBK4ZrBnMP46NToXUpJE0c7D48xwu5gqGQ3B56Lj2s5vHC4GmzxSsdk
	 weZnxTudNmXcId7vJ10JzbdsEli5euCWbkyytLcGTE16MFgZtgndXuxIbHRYtCsMrt/vd
	 x26YiNAItjprGw+J1Aq3r5Pr8GROXanYnckoNWfemSLwelOHAAYJytdpV0Yt77kVg8qlz
	 7rtAhKIsU1/9NhyZ9HBf6UmDKGgtprB4o7EWgB1335iFAzJqif8HA6wH4iAy5IArBgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793538091;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nZD/eY9MwTnRg581iGUn0EVc5DoymYXIexH7Bwkg5HA=;
	b=4R/AVVfcUzbelKnfWtiobkmfjXE6FDnZW6DG9Mc3eyqZH8+8QJdpzqWcXpXTUCDlvt2H
	 Yzr4fIbxCznktZHC/+xBUH38iKGsXhoR8M+wTybF1JpML3+StY0sm3urPV9BppIbtWc88
	 qh8Ne2Ri1v7FU+AYYA3fMWO2vIuqjxgpQ9oXa8Nqgdk1fFCImLo43nf2puR43Q1LQwQAz
	 9AJYYMDxkPjJq//Ig1GGLazugMDQmpCp3MsK4IXcdv3d4eO/ujYFnJT6grmspNikIy5+h
	 WZWOKSen219eLomC17Nrf26nLYVLr4nyDtI7Q2VHEWHxOpeKLj78p7i0dP25eqPtLqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LrpcX0sQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22188606A324
	for <linux-ext4@vger.kernel.org>; Sun,  1 Nov 2026 13:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LrpcX0sQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789F91F000C1;
	Sun,  1 Nov 2026 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793538090;
	bh=nZD/eY9MwTnRg581iGUn0EVc5DoymYXIexH7Bwkg5HA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LrpcX0sQF6h+y/HHEL0a2qjf9KuLIeDWSRLT9Zd7o5b7TBMZwq+Zmj7np3ngDofzo
	 fFG3+Hd49ijbw1c+VrKtK7NAOyYmc4CoRWIRE8+Ym0KbPlAlNCIx6jBL4O2QkrPELm
	 /iJHJKYnJKBXmkKeW+gjsqjOEJ1fqnn4fh9NiaYWhttlwLaA2KSbX9DwST+xfaMnid
	 ogdhdp2T+krtI1XcVR69WVuRtnev0bYbcAZMlN+4aCilEuOL0wC50yA/9+8mueS7Qk
	 VXQ8LUvB21+tWZbMAXhQPiT19YOLbBdC5g0Wj5j5A/lSt1jRDCyKuiIzLZr6exOONY
	 VWhsTgblzwRBQ==
Message-ID: <sashiko-outbox-192417@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: report sub-block project quotas in statfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261101125847.54531-1-dennylin0707@gmail.com>
References: <20261101125847.54531-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 13:01:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_statfs_project() converts the selected space limit from bytes to
> filesystem blocks before checking whether it is nonzero. A nonzero quota
> smaller than one block therefore skips the project space adjustments.
>=20
> For example, a valid 1 KiB hard limit on a 4 KiB-block filesystem leaves
> statvfs() and df reporting the underlying filesystem's space, even when
> unprivileged data allocation fails with EDQUOT.
>=20
> Test the byte limit before converting it to filesystem blocks. The
> resulting zero block limit then clamps the project space statistics to
> zero. Keep the existing rounding and the rule that a zero byte limit
> means no quota.
>=20
> Fixes: 689c958cbe6b ("ext4: add project quota support")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101125847.5453=
1-1-dennylin0707@gmail.com?part=3D1

