Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B77B37F72E;
	Fri, 24 Apr 2026 09:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777023287; cv=none; b=Ug1/mUgBreqcgGPNuBq7vzOPfXBOyQeX8Oilh2la7jzQh2vNvyZ+Pu1JTGG3k7U/h1rnDJ+EuAhLSRW6Z26qkdrpm/vCwmjoYTiV0rWpeF5spEopwA84zRCdg+yybvJjm/j8tMq1Ti7oIT5yG4G4n1FZtKbl0KuNxR8agDdefCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777023287; c=relaxed/simple;
	bh=dLSzeyFx0+AAFSsCC4/WD6B7SjxKCRxJHNw6NWSH2fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTuyOa36Qxg6ooLuQygk8CgptswYE9bFfij0/I7pflgkdnblBwfLQqKX3z/GfGZzbgpys7187RtYODg2Grg/y+out2p3SUlPYLPZpeU7q4Q0ZojzWVDxLy09CpYgPnLhguYNikXkjUlFkyPfZLeLjeEoxF4p0pwdkPvVI0bjY1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ih5TeC6w; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ih5TeC6w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777023280; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dLSzeyFx0+AAFSsCC4/WD6B7SjxKCRxJHNw6NWSH2fg=;
	b=ih5TeC6wl8/SoyiFdW0Kv7TZ9V/fMXm795ZJFz3lcxYcX+anyxdnavBEdYmuYR7QXAN1NxUem9tTbUpSTTa13vhLgmbVShItKMyavHvGvjlBnS1BRmr8Nie+ZqQvyufg1UasU0FjLmCqa+V8TkkKY+ifJNQjVN2s081tF0NdtzM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X1cF4fu_1777023279;
Received: from 30.221.130.231(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X1cF4fu_1777023279 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Apr 2026 17:34:40 +0800
Message-ID: <5eaa521b-28b0-4c2a-a33d-57d1449f125e@linux.alibaba.com>
Date: Fri, 24 Apr 2026 17:34:39 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: liubaolin <liubaolin12138@163.com>, Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>, Andreas Dilger <adilger@dilger.ca>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
 <20260423161947.GB68318@macsyma-wired.lan>
 <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 2026/4/24 16:09, liubaolin wrote:
>
>
> 在 2026/4/24 0:19, Theodore Tso 写道:
>> On Wed, Apr 22, 2026 at 09:50:25AM +0800, Baolin Liu wrote:
>>> From: Baolin Liu <liubaolin@kylinos.cn>
>>>
>>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>>> mballoc statistics when 0 is written.
>>
>> At the moment to enable mb_stats the system administrator needs to
>> write "1" to /sys/fs/ext4/<dev>/mb_stats, and writing "0" to the sysfs
>> file will pauce the statistics colleciton (but not clear the
>> statistics).  Adding a way to clear the statistics by writing to the
>> procfs file might be confusing to users.
>>
>> So.... as a suggestion, if you're adding to the ability to write to
>> /proc/fs/.../mb_stats, what if we make things work by
>>
>>     * Write 1 to /proc/fs/.../mb_stats to  enable statistics collection
>>     * Write 0 to /proc/fs/.../mb_stats to  disable statistics collection
>>     * Write -1 to /proc/fs/.../mb_stats to clear statistics counters
>>
>> And then deprecate the /sys/fs/.../mb_stats variable (but we probably
>> won't be able to remove it for at least a year or two).
>>
>>                                         - Ted
> Dear Ted, Baokun,
>    Thank you for your review and suggestions.
>    Since you mentioned that /sys/fs/.../mb_stats cannot be deleted in
> the short term,
>    I plan to modify and submit a v4 patch according to the following
> strategy.
>
>    1. Change `/proc/fs/.../mb_stats` to read-write mode.
>     * Read `/proc/fs/.../mb_stats` to show statistics counters.
>     * Write 0 to `/proc/fs/.../mb_stats` to disable statistics
> collection.
>     * Write 1 to `/proc/fs/.../mb_stats` to enable statistics collection.
>     * Write 2 to `/proc/fs/.../mb_stats` to clear statistics counters.
>
>    2. Do not delete the `/sys/fs/.../mb_stats` node for now; implement
> the same write control logic.
>     * Write 0 to `/sys/fs/.../mb_stats` to disable statistics collection.
>     * Write 1 to `/sys/fs/.../mb_stats` to enable statistics collection.
>     * Write 2 to `/sys/fs/.../mb_stats` to clear statistics counters.
>
>     Delete `/sys/fs/.../mb_stats` later when it is possible to delete it.
>
>    3. Modify the relevant documentation for `mb_stats`.
>     Documentation/ABI/testing/sysfs-fs-ext4
>     Documentation/admin-guide/ext4.rst
>     Documentation/filesystems/proc.rst
>
>    Compared to your suggestion, I recommend using the value 2 for the
> clear operation because s_mb_stats is an unsigned int variable, and
> using -1 requires changing the variable type.
>    I suggest avoiding changing the s_mb_stats variable type unless
> absolutely necessary.
>
>    Do you think this modification is appropriate?
>    If there are no problems, I will start modifying the code and
> submit the v4 patch as soon as possible.

For the clear command, we only handle it without storing it, so s_mb_stats
remains unchanged and still stores only 0 and non-zero values to represent
disabled and enabled, respectively. Otherwise, you will have to deal with
a large number of s_mb_stats checks

That means the /sys/fs/.../mb_stats interface does not need to support
clearing, but it might make sense to add a deprecation warning there.

Then in `/proc/fs/.../mb_stats`, writing 0 or a positive number passes
it to s_mb_stats, writing -1 performs a reset, and other negative values
return -EINVAL.


Cheers,
Baokun


