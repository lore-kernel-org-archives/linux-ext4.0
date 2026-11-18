Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794973456;
	b=l0bqn229lYAYoXSHaguzpSQ/oXmEf3WuHqJpOnMrVPmfEcxOrMTrQ2MgL5IDp1aMMmBV
	 6aRiHmpZO9UkFJUPsW+Ukt4Ueb+7nYe+MY05Q0EvKuwuTwGRyBSQgDBBINki1JiAyC8TO
	 kbEiZz1Rf2+PDTUxNl/l9V9L0omxAKg3pGUA8aLAXz6YQaBVVeGRi2jjoQjZoq7nvNNGs
	 bUusrNasV/9u8E6thzrehOXzsQ9NO1hyh4O2a2yLoGxknzEGHx7HM+H/ZX6q1abipc6Sr
	 RwnXFvzH2nEX+93aBDOfW1XucTKX0fHNQCqjkSO+odhcf9Q6TMbal6nLYEQvCsdUgEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794973456;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=IBtTJsR0aB79rlDowaAPzzX1Tl49SYWolIzKHn+hN0I=;
	b=SXR4nXlpxD1t2KZUFUjXR/WP5HwQ8xyzAliOFArPkdewV7AbZ1+yLhJmqO26n0nb77Y+
	 ebeIZdEse2Pr3EuU0UzGpDqR0rfTQHJ60Nevcb3ZhHAAfKW3fs/UCCcOazhhte2dreGmG
	 vfAIUWvkzwiB9CcozmGkWi0U2j4XqArM0PPH//LK00bI/sK15gv9R6Fb/s06NnSaTjKVZ
	 uprxPPYUoyKz13umwQe2m1fdDFd2IW0CVXyqZZAXDR1O6x2F4eAI1AZD0WKAaBuqHLoeL
	 Kt07gvwBHEG2A/vgTnOzR+KXQYUpfqpMMtkDqK2el7/eRKYh4dL4RL2WhTbMLnhCe4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCB606A880;
	Wed, 18 Nov 2026 03:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEFCB606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jTnWD0DhHz1ymk;
	Wed, 18 Nov 2026 11:43:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C04AF40576;
	Wed, 18 Nov 2026 11:44:10 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfQIH_1qxtIpEw--.10239S3;
	Wed, 18 Nov 2026 11:44:10 +0800 (CST)
Message-ID: <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
Date: Wed, 18 Nov 2026 11:44:08 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 guolingxing <guolingxing@tju.edu.cn>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3tfQIH_1qxtIpEw--.10239S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4UWw4Dur4kWr1kKr1rWFg_yoW5JF1fpF
	yF9Fy8Aw4DtF4Iyr97Zw43X3WUAwn3WrW3GrWrGrs8Zay5GFyagr4Sy3yYkFyFkrn5G3Wj
	vFWjq34kCa4qvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/17/2026 10:23 PM, Jose Fernandez (Anthropic) wrote:
> On Tue, Nov 17, 2026 Zhang Yi wrote:
>> I think the solution should be based on Ojaswin's counting approach in
>> [1] or the PENDING_CONVERSION solution we discussed, and then, after
>> extent splitting fails, try to flush the journal and retry.
> 
> Thanks for the quick POC. Our agents ran it on [1] rebased on
> 23c62304dde2 with the report's reproducer, in two separate setups (QEMU
> without KVM). None of 72 files lost data in either, against 42 and 53 of
> 72 with [1] alone.
> 
> They found two gaps:
> 
> - The new branch in ext4_ext_handle_unwritten_extents() skips both
>   ext4_update_inode_fsync_trans() calls, so fdatasync() and O_DSYNC can
>   return before the commit. On a full filesystem mounted with
>   commit=3600, a shutdown test lost the write in all 13 buffered
>   fdatasync() and O_DSYNC cases that reach the zeroout. They pass with
>   [1] alone and with that call added.

Yes, this is a pre-existing issue introduced by 5f1a1cccebf8 ("ext4:
correct the mapping status if the extent has been zeroed"), but it
healed itself after 5f18f60d56c0 when extent splitting was deferred
until after I/O completion.

Now the current POC brings the splitting before submitting I/O logic
back in the bh buffered I/O path, so the issue has resurfaced. I can
address this issue together in the formal fix patch.

> 
> - Direct writes into preallocated files can still get ENOSPC with the
>   POC, on a few percent of files in both setups, with no data lost.
> 

Could you provide a reproducer? My guess is that high concurrency causes
the blocks freed by my current process to be taken by I/O issued by
other processes, since we can no longer simply fall back to zeroing the
entire extent as before, which was basically always effective.

> The POC tries the zeroout before the commit and retry. Should it be the
> other way around? 

I agree that doing zeroout first and then retrying does look a bit odd,
and it is not friendly to large extents. However, since the previous
logic would just do the zeroing directly when space allocation failed
during splitting, the current POC does not break anything.

Besides, Ojaswin plans to refactor this part later and move zeroout into
the fast path, so I suggest we keep it this way for now to reduce the
probability of ENOSPC, and discuss further approaches later.

> And will you take guolingxing's patch ([2] in my report) as well?

Yeah, we should merge this patch as well.

Best Regards,
Yi.

