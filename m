Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D8F2F6565
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316964; cv=none; b=DY3tENjOFaPx+01NhxTIsMMaoqDknzEUxps81f+rSfnHnwTHBXNj50b0++8zkzlUl2KvFqI2SKQb57UO0SfITcwpsbJgoDA4P3Z4oa0f+vAyn3QK83Y7j6QHtO1Tkbjrxtyp4l7k4WXBaYW8N1JcN9Z1LWbNwjZMDTRdhX1lZus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316964; c=relaxed/simple;
	bh=vVQaG+KHvXuTtzsnAGTaBXLHMRmQfGpWWk357quD5K0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eSS3yTxbDBqtZ/GHXeDZVxfWgyktdHXE/nFZBGvc8nDF0TjWiNgBHytdK6ynR3nM5bX+oNAxagHriYljFUgfBx/WFI6RvFKMKKVToSYrzgCJM/hzS7IJP8pwd0BHFSTxTz4nuHzyyLavpMnu7bYPt3CPGS0BUHlPpvh3oZGc/0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRWuvHlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRWuvHlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4C61F000E9;
	Wed,  2 Sep 2026 02:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316961;
	bh=AaSHl74Roly8m0cXGrnUVMKN/jGJ0qZdy00IKhYZSHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NRWuvHlqHUnVzaiwF579U6vC8vkxP1T/zQzCE/ZQpDgX2SKuqy2UNp50FO/1WgKJe
	 vkVg0KJjSbcxI9NTNJVcUv26M5KVdDVnX71ISDFRIiBNdasLD4g+QrALipWc9Hdtmp
	 pEp9YBKqm0Je9JEsrIszkXHBRo9VoWEE0XNYLoJ1P1aelBGLT+NZYUUThJwPnvbaaG
	 NvKJyRVgiZ2y+SJZSfHKxNTQkN0C7zMuQueVb/39B0kZs82b3WypaZdWjtz/GAt2kf
	 NVDw3e31mlk7SHd3Dx5X4UAUJLI561FxPOa2wITzC7HE5MQOsY5QVTRZE0cj2pbc+p
	 QRL9nHN1z8scw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/12] 8021q: Fix data race when publishing vlan
 net_device pointers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-12-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-12-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:40 +0000
Message-Id: <20260902024241.3E4C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch introduces `rcu_assign_pointer()` on an array element tha=
t is not annotated with `__rcu`, which will trigger a sparse address-space =
mismatch warning.
--

commit 373a743fcdc81042ad984fe48b83c68516eeaeea
Author: Jinjie Ruan <ruanjinjie@huawei.com>

8021q: Fix data race when publishing vlan net_device pointers

This commit attempts to fix a data race in the vlan_devices_arrays leaf
entries by introducing rcu_dereference_raw() and rcu_assign_pointer() to
enforce proper ordering and memory atomicity.

Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40=
huawei.com

> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
> index c41caaf94095f..8030d616cb16e 100644
> --- a/net/8021q/vlan.h
> +++ b/net/8021q/vlan.h
[ ... ]
> @@ -88,7 +88,7 @@ static inline void vlan_group_set_device(struct vlan_gr=
oup *vg,
>  		return;
>  	array =3D vg->vlan_devices_arrays[pidx]
>  				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
> -	array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] =3D dev;
> +	rcu_assign_pointer(array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN], dev);

[Severity: Low]
Will this trigger a Sparse address-space mismatch warning?

Looking at struct vlan_group in net/8021q/vlan.h, the vlan_devices_arrays
field is an array of struct net_device ** and lacks the __rcu annotation on
the inner pointer:

struct vlan_group {
	unsigned int		nr_vlan_devs;
	struct hlist_node	hlist;	/* linked list */
	struct net_device **vlan_devices_arrays[VLAN_PROTO_NUM]
					       [VLAN_GROUP_ARRAY_SPLIT_PARTS];
};

When compiling the kernel with Sparse enabled (make C=3D1), the
rcu_check_sparse(p, __rcu) check within the newly introduced
rcu_assign_pointer() macro will evaluate the unannotated
struct net_device * and emit a "different address spaces" warning.=20

Does this array need an __rcu annotation to satisfy the static analysis
tooling?

>  }
> =20
>  /* Must be invoked with rcu_read_lock or with RTNL. */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D11
