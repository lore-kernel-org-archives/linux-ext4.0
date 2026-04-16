Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA99D3890F8;
	Thu, 16 Apr 2026 07:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776323828; cv=none; b=Nqa11hWobEYDuUVGIEeg1MsjAVz8I+ncFnBhN4c0/izVJag2c/80E1lQ4yjC5/wS+pGCglRiQNjiwtV/S6YRZnQ8hIsZyIRiJhaaf11/feeG9dMT8Apo9HqkJYAq+BiXYQ9X0sUrVtWrQcmBXznWA00vVzcTMwou7dSM7+rlquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776323828; c=relaxed/simple;
	bh=NwfLGHYFdb5O5foi5Zj2yT0QzLf5LiM98srI8tmX5B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HVKIyANLdlEVJFz7FUGgOBXgLE+StEOzCdaGEcCJTHeHPm4Sl8eJz9nw/kl6GWefyGRxgDGXKv5yd060g7wofLrraZsEEiWz33QsjUtUTS4pTXvdeCxp+j9pqok//GQ/HVagfVGSKeezwevy1bgzPHeASaM3115UM2ZcID60gzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VMyj2cX0; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VMyj2cX0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=dpcMwWN6wfvZWsRzEglGoYfk3QQ0TAkfu5uyMy5pr98=;
	b=VMyj2cX0gkEuhO9seCyGAjrkmP0BaJ3IfIc0WnyALVFuT3Mj67RKqhRDA5pEGX
	auLEUrDk1GMtl72esw7DKQh+DCs0bYOMQHmLeCzRBwr415zFRLwymHTflVAJuC4z
	YIhKhHowby34+LT3m3sfbjE9nXjBJysj4E5lEZ5QJfy8w=
Received: from [192.168.52.68] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wAnTjfAjOBpj93QFQ--.34787S2;
	Thu, 16 Apr 2026 15:16:39 +0800 (CST)
Message-ID: <0e075abc-11f2-40f3-9dd3-566cd54a2bae@163.com>
Date: Thu, 16 Apr 2026 15:16:08 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ext4: add mb_stats_clear for mballoc statistics
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, tytso@mit.edu,
 adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangguanyu@vivo.com, Baolin Liu <liubaolin@kylinos.cn>
References: <20260414100212.95209-1-liubaolin12138@163.com>
 <mrz3u1a4.ritesh.list@gmail.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <mrz3u1a4.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnTjfAjOBpj93QFQ--.34787S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4xJrWxZry3AF1kWw4fuFg_yoWfWFb_WF
	WYyrn7WF4UtF4xGan3Cr1xGrZY9Fy2vFs8t3s5Arn5Gas093ZYvF95WrsIvr18GF409Fs3
	tan7XF9ayFy7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjJ5r3UUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6hfqtWngjNcoKAAA3w

> Dear Ritesh,
> Thank you for your review. I will revise the patch according to Andreas's comments and submit a second version. 
> When the second version is submitted, you are welcome to review it. 
> Once the patch is finalized, the maintainer will add the Reviewed-by tag.
> 
> Regards,
> Baolin



在 2026/4/16 9:44, Ritesh Harjani (IBM) 写道:
> Baolin Liu <liubaolin12138@163.com> writes:
> 
>> From: Baolin Liu <liubaolin@kylinos.cn>
>>
>> Add a write-only mb_stats_clear sysfs knob to reset ext4 mballoc
>> runtime statistics.This makes it easier to inspect allocator
>> activity for a specific workload instead of using counters
>> accumulated since mount.
>>
>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> 
> Make sense to me. The changes looks good and works fine at my end.
> So please feel free to add:
> 
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

