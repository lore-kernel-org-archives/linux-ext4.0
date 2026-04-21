Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647435DA4A;
	Tue, 21 Apr 2026 07:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776755342; cv=none; b=G1EIBC6RmHIfwTEKG00QZmWN7l7+/3U09E4CdwtzDG6rsZly5Sh/5LSG9L1mrEkBk3/EUCBJHpj0UIejfcABv8ulHP+7KJtd/Xf2P5AYPPmrTVo6z/fCMJxkiG1BvshQo11OWcnYcU2cF0+ycQuRh5A9zzaed5gaXeY811PMH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776755342; c=relaxed/simple;
	bh=cSqLvnXdE3oPfgZAPyZSpsNjusysd65wMEiuT/gpeXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Km1uUAh5rndtjD/tCAw1i+j4sJK6Zwo7QmDp2ii4kDrr1xtaUtvNOYx1MDxp0nBMBwJYtiFXuF7upMlaqGC45bHSpd8I23KCxhAjUmARN3LKEE2u2ktI8eem+foTtSuvduXXnuBLi81R3gcO2iapGx4yvU0ZyU9vQzS1z0WY9kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NWGgs0k5; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NWGgs0k5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=DoE2K00jnVGnqULv3QdCbTOVxdnAMRgBBRGam/SYPqQ=;
	b=NWGgs0k5Pv5jN47NAGB6KBxfLscVjVE4A3YE8ZZHzC/A0CoXPzoRyoyOZGNRe5
	FelsdwyDsY15K9A0qbnvN51Xy48316mpMftpAgwxgL2nTXbfnGIRIDRAZjm9gRFC
	XCqnDc0pB6WsTZakZIQuD4Jd8+LZsk5P3iuWaOf1yK0aY=
Received: from [192.168.56.68] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgD3XwVPIudpsTpPAw--.4234S2;
	Tue, 21 Apr 2026 15:08:03 +0800 (CST)
Message-ID: <ab93e1b9-93e5-4988-94db-b861dc47abb0@163.com>
Date: Tue, 21 Apr 2026 15:07:54 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu, wangguanyu@vivo.com,
 yi.zhang@huaweicloud.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Baolin Liu <liubaolin@kylinos.cn>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-3-liubaolin12138@163.com>
 <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <4A904858-8611-42BC-B1BD-9679F284F8EE@dilger.ca>
 <7bq1t1zg.ritesh.list@gmail.com>
 <9a2d25d3-219f-481c-afb8-083c8b9417c1@163.com>
 <aecVCWGL3bUFFiBd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <aecVCWGL3bUFFiBd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgD3XwVPIudpsTpPAw--.4234S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr4kKrWkCr4DKr48XFyUGFg_yoW5tFW3pa
	s5J3W2kan5Xw1rCrnFqr1jvr1Iya4xJ3y7XF98try09F9Iyrn3tr43Kr4j9FyDGrW8XayU
	Xr4IkryayrWYvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UOF4iUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6hTxvGnnIlQ2sAAA3N



在 2026/4/21 14:12, Ojaswin Mujoo 写道:
> On Tue, Apr 21, 2026 at 01:22:31PM +0800, liubaolin wrote:
>> Dear all,
>>     I noticed the discussion about where to document the ext4 proc parameter
>> mb_stats.
>>     I ran:
>>       git grep -n "/proc/fs/ext4" Documentation/
>>     and found that ext4 proc parameters are currently documented in both
>>     Documentation/admin-guide/ext4.rst and
>> Documentation/filesystems/proc.rst.
>>
>>     To be consistent with the existing documentation, I am thinking about
>> documenting mb_stats in both places.
>>     If there are no objections, I will send a v3 shortly.
>>     Compared with v2,the v3 patch will add the mb_stats documentation to both
>> ext4.rst and proc.rst.
> 
> Yes this makes sense to me. Feel free to retain the Reviewed-by since this is
> just a documentation change.

> OK, I will add all the reviewers who helped review my patch with Reviewed-by tags in the v3 version.


> 
> Thanks,
> Ojaswin
> 
>>
>>     Regards,
>>     Baolin
>>
>>
>>
>> 在 2026/4/21 11:40, Ritesh Harjani (IBM) 写道:
>>> Andreas Dilger <adilger@dilger.ca> writes:
>>>
>>>> On Apr 20, 2026, at 03:12, Ojaswin Mujoo <ojaswin@linux.ibm.com> wrote:
>>>>>
>>>>> On Sun, Apr 19, 2026 at 02:34:36PM +0800, Baolin Liu wrote:
>>>>>> From: Baolin Liu <liubaolin@kylinos.cn>
>>>>>>
>>>>>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>>>>>> mballoc statistics when 0 is written.
>>>>>>
>>>>>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
>>>>>> ---
>>>>> Hi Baolin, thanks for the changes.
>>>>>
>>>>> Seems like userspace doesn't have any way to know that writing 0 will
>>>>> clear the that. Well, I guess if you are looking at this file you are
>>>>> anyways debugging kernel code so that should be fine
>>>>
>>>> That could be documented in Documentation/filesystems/ext4/allocators.rst,
>>>> or better would be to add a new file that covers mballoc in more detail.
>>>>
>>>
>>> I started looking for ext4's control knobs for sys-admins in kernel
>>> Documentation where we should ideally document this, and I see those
>>> are declared here..
>>>
>>> Documentation/admin-guide/ext4.rst
>>> Documentation/ABI/testing/sysfs-fs-ext4.rst
>>>
>>> Looking at this and the relevant code, I see all /proc/ entries in ext4
>>> are all readable and sysfs entries for ext4 are mostly the control knobs
>>> which are declared in above admin guide.
>>>
>>> But now this patch adds a control knob to /proc/fs/ext4/<dev>/mb_stats,
>>> to clear the stats :).
>>>
>>> I guess we could have simply documented a new control knob value (e.g.
>>> "2") for clearing the stats via /sys/fs/ext4/<dev>/mb_stats itself or
>>> maybe even having mb_stats_clear file in sysfs wasn't bad either... But
>>> either ways, clearing the stats via the same procfs mb_stats file is not
>>> totally bad and I don't have a strong preference.
>>>
>>>
>>> For documenting this, we can add mb_stats entry under /proc section in
>>> Documentation/admin-guide/ext4.rst and document this change. Something
>>> like -
>>>
>>>     mb_stats
>>>           reports runtime statistics from multiblock allocator (mballoc),
>>>           including allocation request counts, groups scanned,
>>>           per-criteria scan hits (cr_p2_aligned, cr_goal_fast,
>>>           cr_best_avail, cr_goal_slow, cr_any_free), groups / extents
>>>           scanned, goal hits, buddy bitmap generations, and preallocation
>>>           usage etc.
>>>           Writing 0 to this procfs file resets all counters to zero.
>>>
>>>
>>> -ritesh
>>

