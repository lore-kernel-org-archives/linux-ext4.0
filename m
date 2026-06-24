Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB32E7361;
	Wed, 24 Jun 2026 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295417; cv=none; b=YslpmWN1Lhp9Ve9I50DuOjzOPorgGjpnzDfeVGYqe+42tg51oSDqJxqotepp1ItuqhETCeDfSsezUpMpGX9o1A7yMOZRMfKNoHdPjLyUaBQxgAmmW10dvfJeuCHfFzzrWZu/rk+j7CF1dcb6qqrLRAoR3hWeRKh9xSZA7x+VReo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295417; c=relaxed/simple;
	bh=earhrG97he2D9MJ/45RiqS29yXbi67jVvEQOvpIoV8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mU2BXeLRR1/qb8JmGciPyhVwH9DZQE6SAM3uEduSqhaPKdbj3WU9N9o2NiKA4QjC6p6oDX2duMxJA6B9/biAIc46B0eyyyX94YqU/yjON0ZTJil2B+NceZg6ruSaG5VAXlYAAXak+l4/mmP3Gxa1H2zMcmoOYUipwPVXM1ftQ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=o2aaAAdw; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="o2aaAAdw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=1bDy1GsbEXC5unZ/ImRXyj4e1+SE5+u9DHrflSTJ9qw=;
	b=o2aaAAdwcFO1uepKoC9r7HCwrOPKahsoPGLNTWNEw8DR/nxMw/hsn96OFwirRk
	4TLb3fQe5S9U7f9jBYNMsOqplQQJmZh61FOjSVPPUrk9LBut8lEQTNqcAe3R1lBB
	6XXx2IOsBcwd9E3VCGW1OILSnlYlSrWJCaD0gHBe32+E8=
Received: from [IPV6:2409:8900:1ed9:afc:e212:8bd0:caa7:b034] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAXvCBGqztq4nOBDw--.43036S2;
	Wed, 24 Jun 2026 18:02:48 +0800 (CST)
Message-ID: <12aa1fef-cbc5-422f-8207-d06b9bc6040c@163.com>
Date: Wed, 24 Jun 2026 18:02:46 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 v6 0/3] ext4: improve mballoc statistics reporting and
 control
To: corbet@lwn.net, skhan@linuxfoundation.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 liubaolin12138@163.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>, liubaolin12138@163.com
References: <20260524015421.2529617-1-liubaolin12138@163.com>
 <1816234d.8a1b.19ef8ff3f2e.Coremail.liubaolin12138@163.com>
 <51efbdd8-76c1-4577-b5ff-a47658c7c0b2@163.com>
Content-Language: en-US
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <51efbdd8-76c1-4577-b5ff-a47658c7c0b2@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAXvCBGqztq4nOBDw--.43036S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7trW8Kr45uFyUGw4rZryDGFg_yoW8WFWkpF
	WUKan8CF48Zr13Jws7Kr4rur4Fva4fC345XrsFv3409F95tr1ftF9xtrWruF1UGrWUZa18
	Xr42yr93GFy2yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUVKZJUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6QhmMWo7q0gyOQAA3P

Dear Maintainer,
     I was wondering if there are still any concerns or questions
regarding this patch series.

     The patches have been updated based on the previous review comments
and have also passed the Sashiko AI review.
     I would appreciate any further feedback and look forward to your reply.

Best regards,
Baolin

在 2026/6/24 17:59, liubaolin 写道:
> Add recipient: liubaolin12138@163.com
> 
> 在 2026/6/24 17:38, Baolin Liu 写道:
>>
>>
>>
>>
>>
>>
>>
>> At 2026-05-24 09:54:18, "Baolin Liu" <liubaolin12138@163.com> wrote:
>>> From: Baolin Liu <liubaolin@kylinos.cn>
>>>
>>> This series improves mballoc statistics reporting and control by adding
>>> blocks_allocated to /proc/fs/ext4/<dev>/mb_stats, using
>>> READ_ONCE()/WRITE_ONCE() for concurrent accesses to s_mb_stats, and
>>> allowing mballoc stats to be controlled through
>>> /proc/fs/ext4/<dev>/mb_stats.
>>>
>>> Changes in v6:
>>> - Serialize proc and sysfs updates to s_mb_stats with a mutex so that
>>>   clearing mb_stats through the proc control path cannot race with
>>>   concurrent administrative writes.
>>>
>>> Baolin Liu (3):
>>>  ext4: add blocks_allocated to mb_stats output
>>>  ext4: use READ_ONCE/WRITE_ONCE for s_mb_stats
>>>  ext4: allow controlling mballoc stats through proc mb_stats
>>>
>>> Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
>>> Documentation/admin-guide/ext4.rst      |  9 ++-
>>> Documentation/filesystems/proc.rst      | 13 +---
>>> fs/ext4/ext4.h                          |  2 +
>>> fs/ext4/mballoc.c                       | 58 ++++++++++++++----
>>> fs/ext4/sysfs.c                         | 80 ++++++++++++++++++++++++-
>>> 6 files changed, 135 insertions(+), 30 deletions(-)
>>>
>>> -- 
>>> 2.51.0

