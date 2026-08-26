Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44203DE425;
	Wed, 26 Aug 2026 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738070; cv=none; b=dp87/ic5QICx8pw0NO9UXfEB93ckpgNnfWmxCHLHKlI5G+pS05diFSKw436rYaysX74CNmklX1EJv0AS/JyQ7TFqEmWkoB+71ipnlaN7qTKXnJlvOJxze7G0oxUObmLKk811KgoiPpPjpsRs7smfHRbsAY1u1V1XXMURA5DYsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738070; c=relaxed/simple;
	bh=D7DX2/Y6LrROTMv6r6cOQKU+LYxe6xp6JWuvZjgoWyA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bCUEQMSZsk9WZSDUijKjoy5dcn+wTOYUWEkIgUjWRjxqlmRP8S+sFl7I6oda+j+hy55kZTo0XCx88KhJQHerIDhyU3bilX1YZdlkd8pbLVzCHk2wog2mmW1oX+ku8EaNhHnlTOi2kdiSE81wWBm1KZ9hBpSrkdLWw0AUl9IDxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INa6vmxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INa6vmxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1854E1F000E9;
	Wed, 26 Aug 2026 09:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738069;
	bh=poS2Lgmoeil5CXOeotFlf9kGYtHPUMlxXs5yMGepyd4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=INa6vmxKKUygSgul+1G2wA9Qc+F/G+Pr8U1NY/pNPvpVVHlhGxbxdM1JqDaStwOV5
	 nPxCOBIj/ZD6tPOiU6ixk+n2Di71UgqD7TGeiiiH/GzUjAY6YORd53hwkEAZEhKEuX
	 3HqCCmBDwK/POU1MkEdQbokQIQMNAbHh/eJkLBPvbgrdFTRpx2Ydew59VB/UXuVPAO
	 PdaMyVd+Lawkro3jBeuz6RZ6RdBfEnDGPX8MQd9+jM9TJBAeX8dhjRWIBWJoaDNiOA
	 MIIVt/JX1+1up99k7Xa2TsqXKzASCRgMIOn0m8PQjF4tGgfkonTyR4BcbA+Ht85NQL
	 LIz7u8XMRt0og==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/11] 8021q: publish vlan_devices_arrays entries with
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-can@vger.kernel.org, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, "Oliver Hartkopp" <socketcan@hartkopp.net>, "Vincent
 Mailhol" <mailhol@kernel.org>
In-Reply-To: <20260825095422.3166067-11-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-11-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:28 +0000
Message-Id: <20260826095429.1854E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing RCU synchronization when publishing and reading VLAN net_d=
evice pointers.
--

--- Patch [10]: [PATCH 10/11] 8021q: publish vlan_devices_arrays entries wi=
th acquire/release ---
commit f29c587f5f1e59d66c0cd64be52269fbafa24e47
Author: Jinjie Ruan <ruanjinjie@huawei.com>

8021q: publish vlan_devices_arrays entries with acquire/release

This patch replaces the smp_wmb() and smp_rmb() barrier pair with
smp_store_release() and smp_load_acquire() for publishing and reading the
VLAN device sub-arrays. This ensures the allocated array entries are proper=
ly
visible when acquired by __vlan_group_get_device().

[ ... ]

> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
> index c41caaf94095f..6db7172bdaacc 100644
> --- a/net/8021q/vlan.h
> +++ b/net/8021q/vlan.h
> @@ -56,11 +56,9 @@ static inline struct net_device *__vlan_group_get_devi=
ce(struct vlan_group *vg,
>  {
>  	struct net_device **array;
> =20
> -	array =3D vg->vlan_devices_arrays[pidx]
> -				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
> -
> -	/* paired with smp_wmb() in vlan_group_prealloc_vid() */
> -	smp_rmb();
> +	/* Pairs with smp_store_release() in vlan_group_prealloc_vid() */
> +	array =3D smp_load_acquire(&vg->vlan_devices_arrays[pidx]
> +				 [vlan_id / VLAN_GROUP_ARRAY_PART_LEN]);
> =20
>  	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] : NULL;

[Severity: High]
This is a pre-existing issue, but does this array read lack RCU protection?

While the patch correctly handles publishing the array itself, the individu=
al
net_device pointer in the array is accessed via a plain C read here. It is
also written via a plain assignment in vlan_group_set_device():

    array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] =3D dev;

Could this allow lockless RCU readers in the receive fast-path, such as
vlan_do_receive(), to read a partially initialized net_device pointer due to
compiler load tearing or missing data dependency barriers?

Should these accesses use rcu_dereference() and rcu_assign_pointer() to
ensure safe RCU traversal and prevent potential memory corruption?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D10
