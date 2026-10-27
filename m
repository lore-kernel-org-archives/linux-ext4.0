Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135719;
	b=uwYvNhUqEuXfjHgo7JDGd5KD46xFMWm+tY2vFaVZCdZ0dgHIUd31SNXN4hVL1zai3PiE
	 YGAGupHsT/g549bEYeJUL0kd+n84fwY1pVRgv020unJ91u3NJ8EZezH9rQytTE+smkGr4
	 ISXagdwhexXZrUoW3lpXa64qNAV0AqPu4QNGZMq78IW1SfskymoTmsDM56DQDJiesmdyy
	 G39KON2BuWkOy27ZkcjRPSlEPMywIhXiq10Jj54J60QEd6BLDBRMSbaRDQKxZ5Vvr6cOJ
	 ppPAnecl5uXzsC1IzDdDfbbpaSs72ak+bF+rnTU8ZhPFof36A4CREHJL0Gjq9pgiKJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135719;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oK60cxy0eaCwxHPjcaHGPaotTqMPo2tkooT3S3vwOm8=;
	b=kb4JE96IVC33iDbGMEZ+gKoQp8YchfVQiHJ2VoiSA9R1UwxiOrEDlh7F+7FwuQYJzRTI
	 rU/6LIehMRbDICD+pl9Sqx3k1ZTV+NkIoZMlFQ+HB7BrTJg1JvN6VF/Ijav1keMdEte9b
	 UrBiiSV4gQRCa/KcaC3rdq8j4Alm4BNzxXWUkjuZT8dKLsEgX65FYyIMjMrnvH3lH/2Wq
	 UC9nqH/BHGIH7Rw2MptWudUB2qVl/0NnEbbAb9MTV6O5teBO7c4mD1Oe7wfYCYBcACSoz
	 bbO8bTVvCeLlqwP0AqLqrE/eE5DS/S+tpHHJsiGNMNT1T35IJz0bMz//h1+tNkZgNTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqY+SMUk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C5C606A321
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqY+SMUk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5932A1F01825;
	Tue, 27 Oct 2026 21:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793135718;
	bh=oK60cxy0eaCwxHPjcaHGPaotTqMPo2tkooT3S3vwOm8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FqY+SMUk+BD+Z1DjM+z8svcP/xDAytZzcZZHN69NWOb0SPL5mGf3ErlyZPegA09fs
	 DiKnzlamTD9G6nWT9ChORgB1CR5OjvlGOmm5eTCyDaOKnzEYAuJRSoi9MfdImJexmt
	 DEjlmCLfilN4SrvnDNtyLscI0+E1pYh8Hny4P+D4XO3VUIUXG9ZgE2RdcWnbuiIUwy
	 WFEeBkSl32jGVvCO2RvpWMvkxPzMKcUR0KzSS2Mj9fvx7Dy0ppk+iLlSEsNpiEAiDi
	 /8s10FVZeS9+GZC/pL/U81dv5T9TRoMW7cT0YLLgSv2FNOi1/1G0cL4IRv7lx5Bg/o
	 WWRUucsoXckcQ==
Message-ID: <sashiko-outbox-187115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/10] ext4: set SB_I_OVL_USE_SYNC_FS if there is a
 journal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-2-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-2-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:15:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With a journal every change of metadata is part of a transaction, and
> ext4_sync_fs() commits the running one.  ext4_write_inode() has nothing to
> add to that, it only forces a commit as well.
>=20
> Without a journal the flag stays clear.
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D2

