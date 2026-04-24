Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C742421D596;
	Fri, 24 Apr 2026 03:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777000331; cv=none; b=BzmWYDJhpg4mXstPPr9gVnMuOMa+D1DaUq1DqeicUBMF70bEv278Su9ir7rO+sB78ZlOZ9j+B/b0P/aZUU6GQuf7xug2ClvODbv8KdU6PUcGN/pqqclsYKksGA/+BzqkLVQALxONzkfOiRibP73KvW/dfidMlGMTVynPbL6NkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777000331; c=relaxed/simple;
	bh=BunZlHSPns/AEpAE9FiIGKpSPfYhy6FrZBs1AYeBlSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OneKy610nF5huzcKWlr3h3a8RYX46OE+qoTWnshEeoWlekW0uPLOZudehun4FPyAbueQRXq+ExHRB/pkvK/3y0fCEMvltpxjNWcDOn1U7SE8v3j4lsKw8JX4WN8UnFqhEzX4ltb/7sO8HTRQUr4stAoqKnqgWqwloZSU4lr+dG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KLrpyUJT; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KLrpyUJT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777000326; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OClGHb/5KCZ0g7trwYIAKkLfAs2r7GF2pA1o7AG/KKU=;
	b=KLrpyUJT90GQ/ONZvPBfj1VvpA2RJG2sqR99qgehF2X1oSJ+3MBSNJPyDc2ZPGyR9ULga1VgftgvA95/VLGLJdNB3znf2owaW98jCUddkuphmXHMWSA8TaHtgvfTb4NXGeB1RQc5/tr3tbCFz8YYrirmktUIaV+EzXQNOo7I/pU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X1b7UoB_1777000325;
Received: from 30.221.130.231(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X1b7UoB_1777000325 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Apr 2026 11:12:05 +0800
Message-ID: <38a32a36-705f-4996-a49b-621dfdc5bb26@linux.alibaba.com>
Date: Fri, 24 Apr 2026 11:12:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: Theodore Tso <tytso@mit.edu>, Baolin Liu <liubaolin12138@163.com>
Cc: adilger.kernel@dilger.ca, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>, Andreas Dilger <adilger@dilger.ca>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
 <20260423161947.GB68318@macsyma-wired.lan>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260423161947.GB68318@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2026/4/24 00:19, Theodore Tso wrote:
> On Wed, Apr 22, 2026 at 09:50:25AM +0800, Baolin Liu wrote:
>> From: Baolin Liu <liubaolin@kylinos.cn>
>>
>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>> mballoc statistics when 0 is written.
> At the moment to enable mb_stats the system administrator needs to
> write "1" to /sys/fs/ext4/<dev>/mb_stats, and writing "0" to the sysfs
> file will pauce the statistics colleciton (but not clear the
> statistics).  Adding a way to clear the statistics by writing to the
> procfs file might be confusing to users.
>
> So.... as a suggestion, if you're adding to the ability to write to
> /proc/fs/.../mb_stats, what if we make things work by
>
>    * Write 1 to /proc/fs/.../mb_stats to  enable statistics collection
>    * Write 0 to /proc/fs/.../mb_stats to  disable statistics collection
>    * Write -1 to /proc/fs/.../mb_stats to clear statistics counters
>
> And then deprecate the /sys/fs/.../mb_stats variable (but we probably
> won't be able to remove it for at least a year or two).

I like this idea. Consolidating everything into /proc/fs/.../mb_stats
and using -1 to reset the counters is much cleaner than the current
split approach.


Cheers,
Baokun

