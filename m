Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C193935DA75
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785132610; cv=none; b=K45IVSEzCjZWneOPrt7zx/qT7TnixRQGnOwk+YGBXfwZZqG7RmbKHyiUVvZb2LB4uQyL8a+e3KiuSHa4AWTRqmiPjC2xFwhrwunrCRHzTV8FbQ/H5p7TfMZt2CRYQ3lW8Yf9cWVLbYDX37T9+1vcQkJfcsvsw0KX7ykjRQHQXfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785132610; c=relaxed/simple;
	bh=PpUktY2NKWWxihik00aO4fnJENz3hIRZ0QSD3aWKrLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SZsUYY0Jo8pHx+fg0BX3cGSG7qy+jCQczrSlE3+7jlgr3v5azEJhvxlZ72dzNCGLQJ2qlvVT6VuRk0GhHiga4Eo9SwNc4U9xEB5sZ9+Z6Ga8m0qRfKRpRhqs/QqiHhKQyP7OUEplln7WE369x0+nwTljP3HB51O6uhSnCmdI9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h7p894Jp4zKHMVs
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:09:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id EA6364058C
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:10:04 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgAXBUQ79mZqDUdsAA--.18868S3;
	Mon, 27 Jul 2026 14:10:04 +0800 (CST)
Message-ID: <1d1ea032-8725-4abb-8b25-cf3e631d3879@huaweicloud.com>
Date: Mon, 27 Jul 2026 14:10:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] ext4: protect WRITE_ZEROES written extents with
 orphan list
To: Theodore Tso <tytso@mit.edu>
Cc: sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
 <20260714080044.4038124-10-yi.zhang@huaweicloud.com>
 <20260714084203.971381F000E9@smtp.kernel.org> <amD3fZPiCKwUqhGd@mit.edu>
 <6213263f-27e4-4d2a-b6ef-f63093f89e69@huaweicloud.com>
 <amJAxFjWXiSzjNd7@mit.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <amJAxFjWXiSzjNd7@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgAXBUQ79mZqDUdsAA--.18868S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr13XFyDWF4kXF48Kry7Awb_yoWkJrg_WF
	n0qa1vyw1kXFn3Ja1vkr9rAFZ2va15GryUGrn5Jw17J34rtrZ8ur1qyrZ3u3y8KF48Arn8
	WFZ7ZFyxu34aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbOxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVj
	vjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/24/2026 12:31 AM, Theodore Tso wrote:
> On Thu, Jul 23, 2026 at 11:29:44AM -0500, Zhang Yi wrote:
>> Therefore, I think the correct approach is to modify
>> ext4_convert_unwritten_extents() so that it returns the actual
>> conversion length, and only returns an error code when no conversion has
>> taken place at all. This way, ext4_alloc_file_blocks() can use the
>> returned conversion length to decide whether to add the orphan list
>> (within the same handle as the conversion operation).
>>
>> What do you think?
> 
> Yes, that makes sense.
> 
> I've checked the challers of ext4_alloc_file_blocks(), and at the
> moment, in the case where there is a partial allocation, we return the
> error, not the number of partially allocated files.  But given that
> the callers are doing fallocate() that seems to be fine.
> 
> I'd suggest we should explicit about documenting how
> ext4_alloc_file_blocks() will handle partial allocations before it
> runs into an problem, so it's helpful for future people who are making
> changes here.
> 

Sure, I'll add this document as well.

Thanks,
Yi.



