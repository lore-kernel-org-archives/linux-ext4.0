Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190489;
	b=bNCxg8E0nYOGCyQvjnC6YTr/mPRa/AB7OnfO2lDARwseHWyZGlRwjwvK70YAUtyEqsTc
	 4XpuH56mITA3jEKhN00w89zfTDWDAI3Zx+HtVg566TcPTi0L080l6MfF0VqLJffBXKhHu
	 PU3CJ1PoT/EcZH3uaaBns3kfUIyTAr3LWbawvTUEOzXJ9JmJ74n5As4r2b/YW65P26c1t
	 jOr+5KZGc7csKZPQaRA+yY23sJvtsfGUJSyRTAu5YpSaMTAOSeL4aCWVamXmpMJXltPzm
	 MTiwTaj8l4UP/3go8GRyr90K3c7/Tx3+tgPnAuZEvPlmGp7pbzTd66s/rg3oPJwboLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190489;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r9OA8zv6rtm9iGVmAPLJzAUcQvXCCmJD7rk4n5TeO8k=;
	b=ctRDVwZVKx0Kt82/kK7J/BiSsWKhDQRJNI2YT4pEirDNKvy2paVz4DtabBskoc6oYOwF
	 +S1s/6gIFZuCaaKV/2MQ7R70xwtVCwK5bkSLbAfIoOKz4hqO99dtMq70Qr+5ExYe0/dPE
	 PVmZ7HltFK1CCkZzjVBlZsYYaHv2+wM6MoL/mh9jlNkzZSpmLkPAv2etkiG8+9IL1BWyi
	 qTcSuwiAtYDtDXrXEb95RZrSw+r//ZLhsja0d0IbcMFKyRfN4GYvhP7YYQ+ya5IdaBKh4
	 +PLhLgpYjrkW/E+FPrw6qLRE39F8T8Y5dDGsWNnP5Bwx+p9yHU2LSUa+FLFxU2bgMiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iBmal/AS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E33606A325
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iBmal/AS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8E71F000C0;
	Fri, 20 Nov 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190489;
	bh=r9OA8zv6rtm9iGVmAPLJzAUcQvXCCmJD7rk4n5TeO8k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iBmal/ASPtH4gXeWvJ9FzjiHGSVSg5zahwsPn/qnGB+KNzqwRZL//jdjRMfgbsPgq
	 xSjzl0CBNczXbC/Lfcn06CnHjGpg4Lw2eLYGiWclmiM9fQUTLTlekEX+EkYEFBP6JY
	 U2be5wtwiXW4z0Y/mlHSC42C3B0V90hLJDOUjE2NeAit/eEqEj/ZyjIqseBKWtulVP
	 Rg6ujUrDVHUuY1MiquQicb6493qjTdqud+oUfTfRL5dMmpf5zypwb5/+NV6z/Ler33
	 752ZrNwYIzdNdrxFPK8lr16v4H58US5H+8hhq0YgHz44SKYo0sN+8IdBRPuOmcFDjz
	 AiSvVarWo6VaA==
Message-ID: <sashiko-outbox-225513@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/7] fs,fsverity: add I_VERITY_BUILDING inode state
 flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-4-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-4-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:01:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every filesystem that supports fs-verity keeps a private runtime inode
> flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> They all serve the same two purposes: reject a concurrent enable with
> -EBUSY and let the write paths recognize the special writes done while
> the tree is under construction.
>=20
> Hoist this flag into the VFS as a new inode state flag,
> I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
> enable path. The flag is set after ->begin_enable_verity() succeeds and
> cleared after ->end_enable_verity() returns (both on the success and the
> rollback paths). Add the concurrent-enable guard.
>=20
> A new helper, fsverity_is_building(), is provided for filesystems to
> query the flag. No filesystem uses it yet; the per-fs flags are
> converted in following patches.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-1-aalbersh@kernel.org?part=3D3

