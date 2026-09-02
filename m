Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8906930568F
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316967; cv=none; b=PhKmBESQ7rVrsdQTcitAgcmlxip+0mkJ0dQaFDvP2JsH1AJI8SbpjnQl5QY8+GIarszr0rE+MCEWP4+McZfFWo6mQvjEtu4kZxMWe8iPhnWMQdhQ3gvh+y3ygrXKgATSD5F4qzueDqN94+M03QucOStIq0jBnihkbLwywyZKaw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316967; c=relaxed/simple;
	bh=7Q+BiCz1D41Ck7srHi0UujF7LTp9Ph2/j8YAd+gVWbM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kLdBdtWFhUN/PpeKYitUlR/Jq60ixorR2D4N+Egs892ad9ZqR7udsDndkE+e33OiB1LKQELXZJqaVcrYsJTXiLCVu8vW6iEmSl2babylFvfha7we8kXowlKVxEWmfDQqe3LblLKOGHizOnkfeCUxX2Mmedz7OODoTRYWtMmfu3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fun/rDTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fun/rDTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967641F00A3F;
	Wed,  2 Sep 2026 02:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316962;
	bh=7Q+BiCz1D41Ck7srHi0UujF7LTp9Ph2/j8YAd+gVWbM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fun/rDTmQgmoIds+HAh8qOIaLEjqcukQ4cfphiYYANzzsTGe1YzPsbKwmR6/dplvC
	 S5NxAF4oSIeIDZjHaF0IkKuJx2jYs1PzrggIL1Vb6CL3AwZYfMk8MBlA0/RE8LUAiB
	 tfS6AbzQRN13HpH4NWH1egc7xC3j8Qzl3uHJeTgRmDvU3MWfhVpDcKlnns7mDdTuIQ
	 h/EKJ3GAuy7jo034Qy38/w2zYMV0rhEU9JQGzH5mYc/m4GBnBpwy4ZSsdDZYHrD/VL
	 nbW0JMUoa2ZWTCsgmlLUepUzmnZYznbhxkEDd9BMqXhZAErwXRcZVcu/eRqQXNUW6F
	 kiOqebLDJAPow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/12] 8021q: publish vlan_devices_arrays entries
 with acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-13-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-13-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:42 +0000
Message-Id: <20260902024242.967641F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on
> vg->vlan_devices_arrays[pidx][vidx].
>=20
> vlan_group_prealloc_vid() publishes the array pointer via release;
> __vlan_group_get_device() acquires it before accessing the array,
> ensuring the allocated entries are visible.
>=20
> No functional change intended.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Cc: Nicolai Buchwitz <nb@tipi-net.de>
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D12

