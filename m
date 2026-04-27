Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125E255F28;
	Mon, 27 Apr 2026 01:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253413; cv=none; b=NPJtxJWc0ddqvJ+OpcjCFaAJcyLsdWk8KhuWF1gPJ6XWeuQFP6m5CHuGMlTR7R9sE8Li62yCWWEr0a/x1BZ0ZR7Ytxl9T+Hxg7MlIq39Ta23t1Oo2KNBWzXh4/XPudwhJudzkRr/H7/a1zezIrelv8rQTXd4vdzlPUzsDeNEaCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253413; c=relaxed/simple;
	bh=acjbu6UIaVoWP0uAA66KF2HD4oHsAtt1U3RQzTygfgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHdR3iTdy0ujbKxIxq3ABHBfZ2W1wJgSpGHIeZ53n12hbcRoIsgrWhrhsgBvYDDSU+3EM6ieLkpPcIbKObN3fpnxzybLR/m4Gp58dL+ZDwGQKNqn2cjJbTbSNGHQ5dI4iiiuWraRJ1E/Tp8WTPPCYxvOfZ6/Id7sHjFQ5ACz1Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PJID8kaK; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PJID8kaK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=p3WgPpPfz2Bbmyji9QfrGWWEt38T46v9GT1N7YF6YB8=;
	b=PJID8kaKdsJ2JKKIZcv+EQPWVWkQm6/XMf/rMzAtuy6GW5BpgZNraAZ3/rttR+
	mxDNvvlH8NJ6/pyuR7/l0YrkbQmF0qj+NGBV9Daj554zBjurIJYjNWmkUVMI/YC0
	eB0Fk4Ez/Rl9Y1YUVOQ4ZtKOVm0BAmQuXRAocb1FGHTyg=
Received: from [192.168.100.68] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wCX8n__u+5pkitQBw--.52059S2;
	Mon, 27 Apr 2026 09:29:41 +0800 (CST)
Message-ID: <bd3bf849-d14d-4706-b21a-9bce0abb7659@163.com>
Date: Mon, 27 Apr 2026 09:29:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: Baokun Li <libaokun@linux.alibaba.com>, Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>, Andreas Dilger <adilger@dilger.ca>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
 <20260423161947.GB68318@macsyma-wired.lan>
 <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>
 <5eaa521b-28b0-4c2a-a33d-57d1449f125e@linux.alibaba.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <5eaa521b-28b0-4c2a-a33d-57d1449f125e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCX8n__u+5pkitQBw--.52059S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFy5JFWkuFyxCw4fXF15twb_yoW5Kw1Dpr
	4Yqa42vF45XFyjvwn7KF4kJr1Utr9xJ3y7JrnxC3y29F4DtrySvF1SkrW5tF9Fkry8Zayr
	Zr4j9F9xAayjvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UY0PhUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6QVGEWnuvAW4LAAA3R

Dear Baokun,
    Thank you and Ted for your review and suggestions.
    I will incorporate your suggestions and submit the v4 patch as soon 
as possible.

Thanks,
Baolin

在 2026/4/24 17:34, Baokun Li 写道:
> 
> On 2026/4/24 16:09, liubaolin wrote:
>>
>>
>> 在 2026/4/24 0:19, Theodore Tso 写道:
>>> On Wed, Apr 22, 2026 at 09:50:25AM +0800, Baolin Liu wrote:
>>>> From: Baolin Liu <liubaolin@kylinos.cn>
>>>>
>>>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>>>> mballoc statistics when 0 is written.
>>>
>>> At the moment to enable mb_stats the system administrator needs to
>>> write "1" to /sys/fs/ext4/<dev>/mb_stats, and writing "0" to the sysfs
>>> file will pauce the statistics colleciton (but not clear the
>>> statistics).  Adding a way to clear the statistics by writing to the
>>> procfs file might be confusing to users.
>>>
>>> So.... as a suggestion, if you're adding to the ability to write to
>>> /proc/fs/.../mb_stats, what if we make things work by
>>>
>>>      * Write 1 to /proc/fs/.../mb_stats to  enable statistics collection
>>>      * Write 0 to /proc/fs/.../mb_stats to  disable statistics collection
>>>      * Write -1 to /proc/fs/.../mb_stats to clear statistics counters
>>>
>>> And then deprecate the /sys/fs/.../mb_stats variable (but we probably
>>> won't be able to remove it for at least a year or two).
>>>
>>>                                          - Ted
>> Dear Ted, Baokun,
>>     Thank you for your review and suggestions.
>>     Since you mentioned that /sys/fs/.../mb_stats cannot be deleted in
>> the short term,
>>     I plan to modify and submit a v4 patch according to the following
>> strategy.
>>
>>     1. Change `/proc/fs/.../mb_stats` to read-write mode.
>>      * Read `/proc/fs/.../mb_stats` to show statistics counters.
>>      * Write 0 to `/proc/fs/.../mb_stats` to disable statistics
>> collection.
>>      * Write 1 to `/proc/fs/.../mb_stats` to enable statistics collection.
>>      * Write 2 to `/proc/fs/.../mb_stats` to clear statistics counters.
>>
>>     2. Do not delete the `/sys/fs/.../mb_stats` node for now; implement
>> the same write control logic.
>>      * Write 0 to `/sys/fs/.../mb_stats` to disable statistics collection.
>>      * Write 1 to `/sys/fs/.../mb_stats` to enable statistics collection.
>>      * Write 2 to `/sys/fs/.../mb_stats` to clear statistics counters.
>>
>>      Delete `/sys/fs/.../mb_stats` later when it is possible to delete it.
>>
>>     3. Modify the relevant documentation for `mb_stats`.
>>      Documentation/ABI/testing/sysfs-fs-ext4
>>      Documentation/admin-guide/ext4.rst
>>      Documentation/filesystems/proc.rst
>>
>>     Compared to your suggestion, I recommend using the value 2 for the
>> clear operation because s_mb_stats is an unsigned int variable, and
>> using -1 requires changing the variable type.
>>     I suggest avoiding changing the s_mb_stats variable type unless
>> absolutely necessary.
>>
>>     Do you think this modification is appropriate?
>>     If there are no problems, I will start modifying the code and
>> submit the v4 patch as soon as possible.
> 
> For the clear command, we only handle it without storing it, so s_mb_stats
> remains unchanged and still stores only 0 and non-zero values to represent
> disabled and enabled, respectively. Otherwise, you will have to deal with
> a large number of s_mb_stats checks
> 
> That means the /sys/fs/.../mb_stats interface does not need to support
> clearing, but it might make sense to add a deprecation warning there.
> 
> Then in `/proc/fs/.../mb_stats`, writing 0 or a positive number passes
> it to s_mb_stats, writing -1 performs a reset, and other negative values
> return -EINVAL.
> 
> 
> Cheers,
> Baokun
> 

