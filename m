Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496E3B71B7;
	Wed, 24 Jun 2026 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782294800; cv=none; b=Ex7RrbzeK0pk4q3JHDOuEjt9M7MXFs9bMsB8IOxpxxzxX0X6+S+FZc48bH0FZoQzwRgt6n1+XljxBhaHl9pByDCzgz2KfmQfo8+7oUNuEgq8D+YMrTTuofMR/fvEdacUKGGCat5DeNwjjSQ6KGt4AMXPEQQLjnvJ/QMmLOPzBik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782294800; c=relaxed/simple;
	bh=/RsimXtUZeALvhTpnPBGO4O42IfyXVnXJNCQqvgaa7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5U8QxJXgAQH+Krwryu3UkJhbhHGodlMMwlCVWrZgNLfPAOQeqCN9qwFF1eByJ/+pRwaWC7loWzq6rPZsdj7kC+0Uat2czTZmXd2SMZMn6V2wbiJrXcfMOX4eMNRXWZvj5hy4O1DJjZ2nGsr3cvet6XhEy47WZ74mg8skMXoiaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EFxlUVgI; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EFxlUVgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=r5fzx6RclqJpv4vFUryyFQdWO/HXnDdYJq/f+ro6hcc=;
	b=EFxlUVgI0cOTHsqrpEIa8kB60e8KS3mWsJNrk3gNyaGTwc8zEyPXaTYR83XpDa
	qFBBHduEvoK0wC79MPZ/jgig8aeAiocO1HmP3kxMs4q/pGip9i63IH/prLVYTnJk
	YuyqMdtN7E4ThcVXqNK+eu6po2S08H3ROE3QvYWNA0Glw=
Received: from [192.168.127.68] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnb3XZqDtqZczYFQ--.44085S2;
	Wed, 24 Jun 2026 17:52:28 +0800 (CST)
Message-ID: <0360a4a5-07cd-4a21-b247-d55d95b4ab79@163.com>
Date: Wed, 24 Jun 2026 17:52:25 +0800
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
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>
References: <20260524015421.2529617-1-liubaolin12138@163.com>
 <1816234d.8a1b.19ef8ff3f2e.Coremail.liubaolin12138@163.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <1816234d.8a1b.19ef8ff3f2e.Coremail.liubaolin12138@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnb3XZqDtqZczYFQ--.44085S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7trW8Kr45uFyUGw4rWF13CFg_yoW8XFW7pF
	WUKan5GF1UZr13Jrs7Kr4rur4Sqa4fC345JrsFv348uF98tr1ftFZ8trWruFyDCrWq93W8
	Xr4jyr93Cry2yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UY0PhUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwRzKlWo7qNyqAQAA3M

Dear Maintainer,
    I was wondering if there are still any concerns or questions 
regarding this patch series.

    The patches have been updated based on the previous review comments 
and have also passed the Sashiko AI review.
    I would appreciate any further feedback and look forward to your reply.

Best regards,
Baolin

在 2026/6/24 17:38, Baolin Liu 写道:
> 
> 
> 
> 
> 
> 
> 
> At 2026-05-24 09:54:18, "Baolin Liu" <liubaolin12138@163.com> wrote:
>>From: Baolin Liu <liubaolin@kylinos.cn>
>>
>>This series improves mballoc statistics reporting and control by adding
>>blocks_allocated to /proc/fs/ext4/<dev>/mb_stats, using
>>READ_ONCE()/WRITE_ONCE() for concurrent accesses to s_mb_stats, and
>>allowing mballoc stats to be controlled through
>>/proc/fs/ext4/<dev>/mb_stats.
>>
>>Changes in v6:
>> - Serialize proc and sysfs updates to s_mb_stats with a mutex so that
>>   clearing mb_stats through the proc control path cannot race with
>>   concurrent administrative writes.
>>
>>Baolin Liu (3):
>>  ext4: add blocks_allocated to mb_stats output
>>  ext4: use READ_ONCE/WRITE_ONCE for s_mb_stats
>>  ext4: allow controlling mballoc stats through proc mb_stats
>>
>> Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
>> Documentation/admin-guide/ext4.rst      |  9 ++-
>> Documentation/filesystems/proc.rst      | 13 +---
>> fs/ext4/ext4.h                          |  2 +
>> fs/ext4/mballoc.c                       | 58 ++++++++++++++----
>> fs/ext4/sysfs.c                         | 80 ++++++++++++++++++++++++-
>> 6 files changed, 135 insertions(+), 30 deletions(-)
>>
>>-- 
>>2.51.0

