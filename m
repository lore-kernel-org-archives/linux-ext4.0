Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521604;
	b=MRsS1/DA5jAGkjX914PfTN2PZAP8mU4DPEJ9QaHc3XXpAE/Mw3z4/PCPm0liKRAfjSTK
	 U5eonfZ0Qikek9E9vnIgbiNHCCrB8bPkWhddVWkOdoMThmBGs8SbVn0G9RWEllxMvxVNm
	 ZeaSeHmFySzzb4Ysi8qER3LfSagaw8BbLbDEnLKlAOUotHZbCQxPHO4Z0CxRLoCVpVCJR
	 uDh3T4wj5UqAsdHPaGxj87DgrqgkgLtpydqcuaMhuNX7rhfXAnFsdgwl1FTANothQQdJJ
	 U4vgjo/9WlZ7UbjG6ji/SKmJTnJuDYqx3TzDo9mS5L1qzje9JsLChfUIcDjOUtbK93w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521604;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RRAnbz1n3kBV7nTwFbWQ1bL5F9+W06OSUXgV8xzoYBg=;
	b=Qo59WoncbbIfEl0d2yEVj5NSXeLQqBuRrmQFfEmo5xGRf9fAxuvpxtDKpPfiyN/F3JmD
	 kzJQ4EXzgh14RlGXDNTkbNp0+PDjD6O/i+O46bAOrKb3hd7aSdP4cTPtqTAT3fUUni6Zp
	 KsE3ksXtDH5Fhx+8Pu0NM6muCYLiSh82q/2fYoQudC5pUrgXoeg7IuqrBHmAeLNoHJsYB
	 yzEf1Yw2YnFgFkDyUrbX/sovxS4qEFhyVR5QNFAZEoDKUk+LX4eMI2hnd0WNxoTMUAKk6
	 +pQ6JmfKHhhDqbro5ltctsdymViLowJ8iG/hGIX1AVuMvwzfk6XJOxTTeyhwyADfmBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=caWnZ1Rz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B820606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=caWnZ1Rz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6071F000C4;
	Thu, 12 Nov 2026 22:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521603;
	bh=RRAnbz1n3kBV7nTwFbWQ1bL5F9+W06OSUXgV8xzoYBg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=caWnZ1RzbqeFnNLsg0y8bVH3OaZ21RZnlV5eGCn13XkFWKv+wSTakDm6OL10uBehC
	 VBqjLHOuClrjlonedUtvgAyh793Hlh3bLYjkvvuVvkxoSrojwXYp5I8X+AgeSGb/Fh
	 r8bL+N45Rb7BDnzIh5I59NHkTDxGzFpkwoFkfueM0P+CBW3TbRBjea/xSL6BeRzQTA
	 KAQfSVyNpV2ll1UqHvuQNWdZ4gJug5aumIdal5gYEigi0CndpvFOQ1/oLpcucdPqlb
	 JgeIS2DBlmLWcOe/HSnxHUw6q6NfuVNIEAcwdjY04FnQ981aJ+ReHjU+7v1CmRFBXi
	 gcY9+kVza/NRw==
Message-ID: <sashiko-outbox-211894@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 11/14] xfs: take the MMAPLOCK in xfs_fileattr_set()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-12-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-12-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:13:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A store through a shared mapping can corrupt a realtime file system on
> disk, or shut a file system down, if FS_IOC_FSSETXATTR changes the
> realtime flag or an extent size hint of the file during the write fault.
>=20
> A write fault reads the flag and the hints more than once: to choose
> delayed allocation, to size the block reservation, and again in the
> allocator. All of these have to see the same values. System calls that
> write do the same, but they hold the IOLOCK, which keeps the ioctl out.
> A fault only holds the MMAPLOCK, which the ioctl does not take:
>=20
>     write fault                         FS_IOC_FSSETXATTR
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                         =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     takes the MMAPLOCK
>     xfs_iomap_write_direct()
>       reserves blocks for the old hint
>                                         takes the ILOCK
>                                         raises the hint
>                                         drops the ILOCK
>       takes the ILOCK
>       xfs_bmapi_write()
>         allocates for the new hint
>         /* more than was reserved */
>=20
> The fix used here is to make the ioctl take the MMAPLOCK of a regular
> file as well.
>=20
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D11

