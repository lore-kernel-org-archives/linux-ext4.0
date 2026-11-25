Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590979;
	b=NDOegnhHV0HbWFWPyovi+Xq28dnJwkim2pEVV9XEHMikAzxeQX6MedC13mN/37GYwpRd
	 siTL3+8FTWlg/XrqR4UdhS7GuzGGESlM4rbUefizY8hdVtxoZkCzmBBKhOw18KYVHJ6yB
	 dRaUDY86brn4zynLXO7zU9ynHjUiFvhBJcoRLaqPkUP2lDpLG7t7CFyAIhALc2rRPoMWO
	 dHJwrI3CIFw04ilU7fORkWJaaUAQM7ig+BlKIIPqhmVoYQJ3ke4lg99BK7Q2tf6jMFa/Z
	 nvHQK3ksK/bX8hfjazL/0w/Wf/kZciyhRIRr250NtgaNgbWqZvMic+LwTjqEqK9vFqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590979;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3mbPYBf1bzf/ubs5uZlPzYCJKrkEfU6pmG8XvGsckww=;
	b=3X+iEU45b0O9MjHtAAEmiux1xrz64tKMgze03MJuo/GgxXkMuN7SV/8FsFLm0Kg9K9me
	 eDgBAzqJVhNRO0sfX5FB42lytOhKEJSBxX5gr2ON8+Lm/NbgmlB+beN3t1qYSQvI8Vomt
	 oniIiEs/3n9LbehCOsy+zBtrYQnLciAI3X8rw/zYMAlFUkMBmWUkHrGVRiR1zzX084Ct2
	 0lY8Kd1cTD6a6DbXBmJBhr+27gS2TsbymyXA/4xj/yThtCa2TTBhL5mAJRJWkAmOmsl6+
	 vUsUz04ppDCGPmH/LMXSCNSmskB3h8MZFyparcx9K3Q4TPW4LLQMr4mEdht3rMhwMDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfLSOMBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87258606A6B6
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 07:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfLSOMBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27151F000C6;
	Wed, 25 Nov 2026 07:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590979;
	bh=3mbPYBf1bzf/ubs5uZlPzYCJKrkEfU6pmG8XvGsckww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RfLSOMBjRK4arVhda1FN8bZeraF51cboTKmBbiHqdRLg2fMaaJP9PkOyGt2rSv+he
	 x1dhaI4IjaFtPdCV6AK21sd1V5ZzXtUcqHvo3GFe6g+HZk7tC9QwTcdcPWIEQZrr9d
	 RwsZTR9VL0UfGnNvtj6MH8e12kcY6pDwuTqbCxoN+OFgpPXUk96+Rb8GeUADcmzXNy
	 BqShT4jZxuek8d3mcYkMhEOWum1N/82h6vC1uPUSTAdd8rqpH262+ud7g4cgMchF8A
	 CL24MuJz5MB+8mHPJbAEyIGtSpxJnWlcdQi3nNKw575zVHYx+25q/FcJ9en2s6gP9w
	 rz7rzTBIp8RLw==
Message-ID: <sashiko-outbox-232766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125070002.27868-1-arzuagapozosergio@gmail.com>
References: <20261125063023.18022-1-arzuagapozosergio@gmail.com>
 <20261125070002.27868-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:16:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/ext4: missing skip when POSIX ACLs are unsupported
--

commit 192ecd2babbed3287e070bdb6ff5a60be8553a9b
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit drops obsolete journal credit reservations for releasing old
ea_inodes, bounds xattr and new-inode journal credit estimates against the
JBD2 transaction limit, and adds ext4 selftests for these paths.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..450fd52121022
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c
> @@ -0,0 +1,238 @@

[ ... ]

> +TEST_F(ext4_xattr_journal_credits, large_default_acl_respects_journal_li=
mit)
> +{
> +	static const char small_value[] =3D "filesystem-still-writable";
> +	size_t acl_size;
> +	char *acl =3D make_large_default_acl(&acl_size);
> +	int ret;
> +
> +	ASSERT_NE(NULL, acl);
> +	ASSERT_EQ(0, mkdir(self->path, 0700));
> +	ASSERT_EQ(0, setxattr(self->path, "system.posix_acl_default", acl,
> +			      acl_size, 0));

[Severity: Low]
Should this skip the test with SKIP() when setxattr() fails with
errno =3D=3D EOPNOTSUPP?  When the kernel is built without
CONFIG_EXT4_FS_POSIX_ACL, setting "system.posix_acl_default" returns
EOPNOTSUPP and this assertion fails the test instead of skipping for the
missing config prerequisite.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125070002.2786=
8-1-arzuagapozosergio@gmail.com?part=3D1
