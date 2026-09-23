Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8364651EDE0
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 12:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168091; cv=none; b=WYAo2d0oA3BYQ0FxN79nlmwovT6Z4J9TIidCFO95P7S4qOS2pk4eWW2lkJGNsp80Aqo/nyucwZgWBAISd8Y1vNAdOK6hTaBjP9+snNdx/+35okENYfFGDDfFwVjtJ2SOYmRieMFUtWTQHeHeVtTjpBNOBvewNXE3udW2nV6jyrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168091; c=relaxed/simple;
	bh=Zx/zASwng4eAeMQ6fde2oAI+Yd/IiVV1LTddyWl4HxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fvwLqWPK4KyldIIz4XZ8s3o9OEkTx5elAc0djvvG2czeyO1z0bDdH/1jm2VqkKA6NZ+jEWu7Mq+4XYy1FkNYn4T3wA/pGE1fIR24v07oUO6IK2037Z0xnljhVtG4mVeBOVdKiq63xQBdLdV+4iAfcBldsyiereYCGbobo5ivyrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htUUN0QD; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htUUN0QD"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8692a856865so399266b3a.2
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 05:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790168081; x=1790772881; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eH1PKGunx3MHUYSKzUdOGw8jJHjZCuP1JnlKtRRHVto=;
        b=htUUN0QDk0OQXl2r657SZf1pC2Sp8Rh6/WLFNZbwuKsd7lZ0qieVpmMtz665ZvWCLu
         4/ACE+xurWqsMVjwMcyQbbkavRsil1NeyZbicsR4Du66UOGUMJ95J+3Qx+xQUxU2jGRO
         D8l7UXwSqMACKU5x11kVd5mYYbK01fdLGFhUwkPevDZNG2IR0sU7ejQdSICUsw2yIg/m
         eW/rDHRKjmClUlbP8BuDmopxy3Qi+8inn9xWqTt0ZMQHm1+FlGu0KWsEQubZhDsa53lP
         AiIgIj7hDM0fiTbJbgPqs8/TL5eq5/2VKGN8lgQOAPPv6GGR4ZnCMYDEWlcT0tdLJSHS
         hDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168081; x=1790772881;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eH1PKGunx3MHUYSKzUdOGw8jJHjZCuP1JnlKtRRHVto=;
        b=mtg+ns4Vk06X2Udt57JSD+UWeNonp8GDZ9esUIpN+NrwZVrF2Cm1U+NHcYYu2YrakQ
         B+Qbz7AdVRr1aPdCmthS9be+wE8TvreeI2y/R3zZ9VAGOnyjgUR9DmYxG1ECBvr73jpz
         nROc3D87TTvij3ue6h1SVRI/+3mM4Zh6fRqynW2JOMUXW8OdedhnQIf6yEJcY5635vsJ
         kAapOFOtOIdXX90QU9FNsHm9r6iIy94yG/Je2WWM3uOClB36fLrjyUWaxgw//Lbs0Fi6
         ma5xAl+nDoymOx2IpkFR7XE05+EW/nKBoT6lZJrJkmeqMJ1uLWfwrGhhT1UOTqPB9HHr
         Xx0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzrrNBiFjdZFqvuHSio5OyIC2AjtbLLNZItQcfoNwSZQtOcgB1vxaoB227K7sN1i2/j+WxlDA2mr9m+@vger.kernel.org
X-Gm-Message-State: AFuF++lr8uwkzglC/mcbeaw8VyoYBn7XHSSZYBi9PVruG0ZnMdy+0Y01
	lSL+cyFMbnVCtPmfg5x/EIP1eGQW2jgoRa2JJVKRV7F5lltNuSmCc/RK
X-Gm-Gg: AYBFou00cZWHjh+TOAgv3dFI8EV5q2xK/NrHeQrGtDfzkL1eVYZdnUU+9JLxK6wmfg6
	icPbzANCZrJBMQN36RsC77s+m6IKa1mQhlNxLx5xDCmAk2AWqSEIin0+4ApuIjz4y1eVRWyDU8f
	sVIU3erBj55zkKEe/8vMlY4KakRjzMyyi5dt+29z5uHyf/ZemjZehSEmuTUe2d9KlxU1Ex/CYCU
	Sw6UL6dv3NrKkVBY2Jd6a1CD4q9fLmzv0z9acXQoeCmLC79vmAMr3WpBvU9/Vb05o8RZAxyFehG
	7YS8rp+GPibArN9u+f0sTuDBYdikLxifAxjFKx7tgIoaG4MTetWl8LrFBnyyLtr+82XcYX6iDCG
	Qq15GBAlgCwYMyA7jWkUCk4Pp+Ee47oiJz+DTmqU7+CFQgk1ZlHiSLKocnyfDKDhMS+JyIJAixF
	Rn+EpGHJloJFA7sjCoIPOqM+0NJcjXT8i0dSPWI/UXNhI7R2NZXXALjS40WL3+8RfMeD4RDqZ50
	rMR9aClBVE0pPgNR7A=
X-Received: by 2002:a05:6a21:8287:b0:3dd:85a8:4c56 with SMTP id adf61e73a8af0-3ddf7e52ca6mr2589348637.29.1790168080565;
        Wed, 23 Sep 2026 05:54:40 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc75f3d67bbsm1007180a12.13.2026.09.23.05.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 05:54:40 -0700 (PDT)
Message-ID: <f36a8d04-206d-4836-b95c-2f144803b195@gmail.com>
Date: Wed, 23 Sep 2026 20:54:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Ritesh Harjani <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ye Bin <yebin10@huawei.com>, kernel test robot <lkp@intel.com>
References: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/2026 9:58 PM, Ojaswin Mujoo wrote:
> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:
> 
>>> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>     declared. Should it be static?
> 
> Fix this by declaring it as static.
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>   fs/ext4/extents-test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index bd7795a82607..9669b2197fca 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -48,7 +48,7 @@
>   #define EXT_DATA_LBLK 10
>   #define EXT_DATA_LEN 3
>   
> -struct kunit_ctx {
> +static struct kunit_ctx {
>   	/*
>   	 * Ext4 inode which has only 1 unwrit extent
>   	 */

