Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4206127EC7C;
	Tue,  1 Sep 2026 01:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788226951; cv=none; b=KMw5QatS9viDCrZqM4kNzmzT0RTec6j0uLt1xSjLOb4SkAMnnO/kOq2bDNawrAbQF2SUxU0ELOS7Lew/M/6akoPRVAFnKnpn5w4N43nEojwP+fA1efBWyf2QEdQ42mrq2Ra51+H2XyAfhcNiQjhhAtwlfM0nN3zaxfNEECEa9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788226951; c=relaxed/simple;
	bh=ivKmB6QoDiiQSjmuz0wRnzNXAllAQSwupIkNeKB337c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iN2By/8zvi/kQ9mvdNpANJOTHhEP2lzn3/Yvn20hVYdptNuYbBJvELE2eCexCdB9faE6/x/RDFBkPwYMOaIYVDb9ahBog8kmjX/JB208IN9Sd547lJgmlb2/xsgkzi4UaWbqHIOoGvx0EkxDOfIMbdA8wT2ee7DR1eIi7oEDW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=kztRRxSE; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="kztRRxSE"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FmUs38s23l+JbXkfrYJCAspVpkyYV3TPYuQ5Y22fLOw=;
	b=kztRRxSEBv52FoofIixwylbPRXSaUQNU0bYGR53Rha80RxDk/wjjaWjzm3mIbGHcJRY8TKfbE
	yWiadQ6hpgC/5MfSOMlSVHpLNoqsZsFMP8XoHnwTtr2Boz47HzOkupD9HeEji4WuPxiWVmXyToI
	LmO4glr2/D9W0+EcJYtE6Os=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hYpH76Rn8zLlX5;
	Tue,  1 Sep 2026 09:31:31 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 17D9E40563;
	Tue,  1 Sep 2026 09:42:21 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Sep 2026 09:42:20 +0800
Message-ID: <a2984749-be88-4e69-9a9b-050225d71e4b@huawei.com>
Date: Tue, 1 Sep 2026 09:42:19 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] user_namespace: Use acquire/release for nr_extents
 synchronization
To: <sashiko-reviews@lists.linux.dev>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
	<tytso@mit.edu>, <linux-ext4@vger.kernel.org>, Oliver Hartkopp
	<socketcan@hartkopp.net>, Vincent Mailhol <mailhol@kernel.org>, Oleksij
 Rempel <o.rempel@pengutronix.de>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-2-ruanjinjie@huawei.com>
 <20260826095421.73E0A1F00A3E@smtp.kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260826095421.73E0A1F00A3E@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)



在 2026/8/26 17:54, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The patch missed replacing `READ_ONCE()` and `smp_rmb()` with `smp_load_acquire()` in `copy_mnt_idmap()` within `fs/mnt_idmapping.c`.
> --
> 
> --- Patch [1]: [PATCH 01/11] user_namespace: Use acquire/release for nr_extents synchronization ---
> commit 1bcd6fdf3ca65990e2c5f3f0896df9c586813872
> Author: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> user_namespace: Use acquire/release for nr_extents synchronization
> 
> This commit replaces smp_wmb() and smp_rmb() with smp_store_release() and
> smp_load_acquire() for nr_extents in user namespaces. This aims to improve
> performance on architectures with native acquire/release instructions.
> 
>> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>> index 0bed462e9b2a2..576b667a88136 100644
>> --- a/kernel/user_namespace.c
>> +++ b/kernel/user_namespace.c
> 
> [ ... ]
> 
>> @@ -1098,8 +1100,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>>  		map->forward = new_map.forward;
>>  		map->reverse = new_map.reverse;
>>  	}
>> -	smp_wmb();
>> -	map->nr_extents = new_map.nr_extents;
>> +	/* Pairs with smp_load_acquire() in map_id_range_{up,down}() and m_start(). */
>> +	smp_store_release(&map->nr_extents, new_map.nr_extents);
> 
> [Severity: Medium]
> Does this code miss updating copy_mnt_idmap() in fs/mnt_idmapping.c?
> 
> Since map_write() now uses smp_store_release() to update nr_extents, should
> the reader in copy_mnt_idmap() also be migrated to use smp_load_acquire()?
> 
> Currently it still uses the old barrier pattern and contains a stale comment:
> 
> fs/mnt_idmapping.c:copy_mnt_idmap() {
>     ...
> 	u32 nr_extents = READ_ONCE(map_from->nr_extents);
> 	/* Pairs with smp_wmb() when writing the idmapping. */
> 	smp_rmb();
>     ...
> }

Will fix it in v2.

> 
> While the release-store correctly pairs with the existing smp_rmb() under the
> Linux Kernel Memory Model, leaving the old barrier in place defeats the stated
> goal of avoiding the cost of full one-way barriers on architectures like arm64
> for this specific code path.
> 

