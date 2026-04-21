Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF1F40DFA1;
	Tue, 21 Apr 2026 05:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776748999; cv=none; b=spvZzJ/KjSYOS/segEIbObUPQus2lEiJ9577xektmmzhVO8v9PLZWWSX7RMkAgV/iqoSGAnFoSV2aIU+FQ0hwrAvXdMFWIBRZ1FVZMkJc0fQQQnDsAsu8Z0dU2prpB2wxW9PMqwFzLZ1B9Rm+QrpcCtYfS+uz1dKwlwW1ST0MT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776748999; c=relaxed/simple;
	bh=yY6fDhQ4+iPHN/3upmOTR70u/G9+iVdTgD8FB1drufo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QANRG0eF2Ai6GjWZQvZ/trDgKs0L9soJY3r+A0B9672foZ0nevp+/w3EJx1S118j1x0lVBAXEmG6XDe+atcICRz4fNzT0Oq/N8RL5Ia0vGgALHnJWTXPmnNRt0cn5X5X8KKmzNLaPNYgfJmKhYMA4qeYmj+MI7PKrAOAHpap95s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=clT9M3Jx; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="clT9M3Jx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=HCS6x1JRUTCy0ckaCCFUQUUmkPxGZvQy7ARpuUKsSos=;
	b=clT9M3JxRWOHUAJGvtzM3m9M6a9zucbVKnmZCeoJ/Ep7XNE5Gh0mV44G7P3DgL
	z/gY+gJOsVXLlzOzszXZAf60iPQkKDXo8Y+i94ijvu8MQq+SOv8sZPf1qvs1en+k
	ITYXef3pRs99PGzVA6C/jsYnI++XuDSO+vU8F1A4r49a4=
Received: from [192.168.56.68] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3QrKZCedp8MeaAw--.3767S2;
	Tue, 21 Apr 2026 13:22:41 +0800 (CST)
Message-ID: <9a2d25d3-219f-481c-afb8-083c8b9417c1@163.com>
Date: Tue, 21 Apr 2026 13:22:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Andreas Dilger <adilger@dilger.ca>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: tytso@mit.edu, wangguanyu@vivo.com, yi.zhang@huaweicloud.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-3-liubaolin12138@163.com>
 <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <4A904858-8611-42BC-B1BD-9679F284F8EE@dilger.ca>
 <7bq1t1zg.ritesh.list@gmail.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <7bq1t1zg.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3QrKZCedp8MeaAw--.3767S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFy8JrWDKFyUWw4fGF1rJFb_yoW5AF1Upa
	4DA3W2y3Z5Xw1fCrnFqr10vr1Iya4fJay7JF90qry8uF9IyFn3tF43Kr4Y9FyDGrW8XayU
	XrW2kryakrW2vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UO2-5UUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6gG+iWnnCaFm8gAA3u

Dear all,
    I noticed the discussion about where to document the ext4 proc 
parameter mb_stats.
    I ran:
      git grep -n "/proc/fs/ext4" Documentation/
    and found that ext4 proc parameters are currently documented in both
    Documentation/admin-guide/ext4.rst and 
Documentation/filesystems/proc.rst.

    To be consistent with the existing documentation, I am thinking 
about documenting mb_stats in both places.
    If there are no objections, I will send a v3 shortly.
    Compared with v2,the v3 patch will add the mb_stats documentation to 
both ext4.rst and proc.rst.

    Regards,
    Baolin



在 2026/4/21 11:40, Ritesh Harjani (IBM) 写道:
> Andreas Dilger <adilger@dilger.ca> writes:
> 
>> On Apr 20, 2026, at 03:12, Ojaswin Mujoo <ojaswin@linux.ibm.com> wrote:
>>>
>>> On Sun, Apr 19, 2026 at 02:34:36PM +0800, Baolin Liu wrote:
>>>> From: Baolin Liu <liubaolin@kylinos.cn>
>>>>
>>>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>>>> mballoc statistics when 0 is written.
>>>>
>>>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
>>>> ---
>>> Hi Baolin, thanks for the changes.
>>>
>>> Seems like userspace doesn't have any way to know that writing 0 will
>>> clear the that. Well, I guess if you are looking at this file you are
>>> anyways debugging kernel code so that should be fine
>>
>> That could be documented in Documentation/filesystems/ext4/allocators.rst,
>> or better would be to add a new file that covers mballoc in more detail.
>>
> 
> I started looking for ext4's control knobs for sys-admins in kernel
> Documentation where we should ideally document this, and I see those
> are declared here..
> 
> Documentation/admin-guide/ext4.rst
> Documentation/ABI/testing/sysfs-fs-ext4.rst
> 
> Looking at this and the relevant code, I see all /proc/ entries in ext4
> are all readable and sysfs entries for ext4 are mostly the control knobs
> which are declared in above admin guide.
> 
> But now this patch adds a control knob to /proc/fs/ext4/<dev>/mb_stats,
> to clear the stats :).
> 
> I guess we could have simply documented a new control knob value (e.g.
> "2") for clearing the stats via /sys/fs/ext4/<dev>/mb_stats itself or
> maybe even having mb_stats_clear file in sysfs wasn't bad either... But
> either ways, clearing the stats via the same procfs mb_stats file is not
> totally bad and I don't have a strong preference.
> 
> 
> For documenting this, we can add mb_stats entry under /proc section in
> Documentation/admin-guide/ext4.rst and document this change. Something
> like -
> 
>    mb_stats
>          reports runtime statistics from multiblock allocator (mballoc),
>          including allocation request counts, groups scanned,
>          per-criteria scan hits (cr_p2_aligned, cr_goal_fast,
>          cr_best_avail, cr_goal_slow, cr_any_free), groups / extents
>          scanned, goal hits, buddy bitmap generations, and preallocation
>          usage etc.
>          Writing 0 to this procfs file resets all counters to zero.
> 
> 
> -ritesh

