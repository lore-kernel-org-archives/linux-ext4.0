Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410125;
	b=iIUK50T85vEWlBYy92+iuvCUtFclEdsBNdQKHl+LbYrADtjdt8rp15CHnypfEJXMDcH2
	 IZQTM2CkNWsEDXtTBhwpXmhDwpCFSy1nebXzDC0yxhsWTW8nCXpT49fshSw7NqsTZwNos
	 nSTAxu5/PcUNJ/mr4OmXxD9k/QtMNH2vC5x9ZbDtqG8WycL9H1iuq/gKLZtxuNmgVe0+F
	 fRuE86+bK2kMHpcQ8uAg3RL3jprqn1ErvhU+M2ySLyfMielXE0NF+oJirc6H8/+qfZsfR
	 0/Ultnve55e+HluQ9rtV8gZPjQ9qqoScPi1AkWHqH93qxDGyLGPvJDgEhjeBzxUmZEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410125;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=j4CE4PBz0nzgfzRAB+io5gMNhUCne1H8gnhPP/T5RI0=;
	b=ZlYHDOofJd5z+oNDoIN0ZYTvW90ZrrJAPQc5UuD0uFm5F24LFGcK9WzckaRm3WdEOjO7
	 h6WJ6uroMiv4geoy8LuYQ6UIegIG38Q4Co9hbl+HbF9xAMQQPUZQA0wy3mQ442qVpeRhG
	 AskzOfBi275ewWIoAM7oQdTjWeWiW0eJFhT71j5Djd7vGwAnOAlEeQPQ3R621pa8ZmFHQ
	 XF1dH/WxHuO+dRROEk017e8LEcVHxg09lfRVm5IC2wFLDDMes53L8uIpanKkOhmRR93sg
	 4ORy0PbWJ5BHGqe47jZmzIaQgjj7lhtyPHnKe3NHuP674+6bYuXm3VNE5tHMKidchuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047ED606A31A
	for <linux-ext4@vger.kernel.org>; Sat, 31 Oct 2026 01:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 047ED606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jGgMg0HnXz1c18Q
	for <linux-ext4@vger.kernel.org>; Sat, 31 Oct 2026 09:28:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9743940573
	for <linux-ext4@vger.kernel.org>; Sat, 31 Oct 2026 09:28:34 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvVAROVqLNHwCQ--.26394S3;
	Sat, 31 Oct 2026 09:28:34 +0800 (CST)
Message-ID: <4f570560-ded4-4488-a9fa-450bbcb5060d@huaweicloud.com>
Date: Sat, 31 Oct 2026 09:28:32 +0800
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
Subject: Re: AW: ext4 data=journal deprecation: long-standing industrial use
 case
To: "Korber, Markus" <markus.korber@anton-paar.com>,
 Zhang Yi <yizhang089@gmail.com>, Andreas Dilger <adilger@dilger.ca>
Cc: Theodore Tso <tytso@mit.edu>, Gabriele Moabiti <gabmoa@gmail.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
 <AM0PR03MB57141FD8462BD0C6D075863DDE672@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <8B27CFE7-E4AD-4679-B772-6473C3849964@dilger.ca>
 <3e774e32-fa5c-43ad-bc2a-c6d29f7ec7df@gmail.com>
 <VE1PR03MB572567B1A74FD7DA9FC6BB59DE6D2@VE1PR03MB5725.eurprd03.prod.outlook.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <VE1PR03MB572567B1A74FD7DA9FC6BB59DE6D2@VE1PR03MB5725.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAnZvVAROVqLNHwCQ--.26394S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF45JrWkuF15ArWkuFykZrb_yoW5XFWDpF
	W5Ga4DtrsYqFy7Zrn7Z3WxWF1Yyw48JFW3Xr98Xr18Za15JryakFsIgrWruFW8Gr1xW3WY
	vrWrtF9rWayqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/30/2026 8:28 PM, Korber, Markus wrote:
>> On Oct 23, 2026, Andreas Dilger wrote:
>>
>>> What I mean is that if you *do* disable delalloc then this might stop
>>> the appearance of NULs at the end of a file after a crash. The normal
>>> "ordered" mode writes should sync data to the filesystem before the
>>> size is updated in the inode, but delalloc does not do that.
>>
>> Yi wrote:
>>
>>> I think this is caused by the default dioread_nolock behavior. Once
>>> dioread_nolock is enabled, the extents allocated during writeback are
>>> unwritten, so ordered mode doesn't take effect, and the transaction
>>> that updates i_disksize may hit the disk before the data I/O is
>>> persisted.
> 
> Hi Andreas, Yi,
> 
> we did some additional power-fail testing based on your suggestions.
> 
> The tests intentionally use normal file I/O without our application-level
> file helpers, in order to isolate the filesystem behavior.
> 
> Our intermediate results are:
> 
> - With data=ordered we can still get NULs at the end of files that are
>   being written in a streaming/append fashion when power is removed.
> - nodelalloc makes this significantly less likely, but does not eliminate
>   the NUL tails completely.
> - dioread_nolock/nodioread_nolock did not show a noticeable influence in
>   our tests.
> 
> So, at least with our workload, neither disabling delayed allocation nor
> changing dioread_nolock is sufficient by itself to prevent this failure
> mode.
> 

Yes, AFAIK, there are multiple reasons why a NULL at the end of a file
can appear after a power-cut. For the ext4 implementation specifically,
streaming writes can be divided into two cases: appending writes to
newly allocated blocks, and appending writes within already allocated
blocks.

First, for writes to newly allocated blocks, using nodioread_nolock does
help, because newly allocated blocks are directly allocated as written
extents, so data=ordered takes effect, and jbd2 guarantees that the data
is persisted before the file size is updated. Conversely, if the newly
allocated blocks are unwritten extents, since they do not affect
filesystem consistency, data=ordered does not take effect here, and the
file size update can reach disk before the data.

Second, for appending writes to already allocated blocks, data=ordered,
nodioread_nolock, and disabling delalloc all don't work. Because, IIRC,
for performance reasons, this newly written data is not taken over by
jbd2's ordered list, so there is no way to guarantee the write ordering
between data and metadata.

As things stand, only the recently merged buffered_iomap option can
solve this problem, though it still has quite a few limitations and will
need time to verify its reliability.

Best Regards,
Yi.

