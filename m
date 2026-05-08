Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238241419A4;
	Fri,  8 May 2026 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778236327; cv=none; b=l40lkETNLWrvYtgj2Qgp7hnjydrgjyXIQmKUpgPdTHgI88Tc8HZSK9WF0/tX3lPc1S330YjZkSgtPKNfOPWuUkiaSCdis8g57COBHwluxkWLohq5GWiQS+kHX0xAcKH1jsgi2fNr1ktcEp0Kiwgtz9ulPRNVmO8/4Th2IFgwQ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778236327; c=relaxed/simple;
	bh=Z/wNQ7oe54AgygQug1Y8kyZ56XgSIdSYCDbpQSh16xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N6JKCxn2Art5qUWo0f8USXn34hTAtTX77qmV11OKgp3ex41U5FqCY5BmNnZ0U13Nb7lVsE84ks7bpyKg63MA/1gudYBeKdFAOiUvgWWVrzVm5ySEzsCFs3Z6HSq90ids/4+SiV9IStvjj8CAjLclSP1hbSnsAQohkf/hfcP1f2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pTOiLM8y; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pTOiLM8y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=c/LvKofPEEUyGe/xHnJLuo4WNzmKyS8YODk1wqBNkP0=;
	b=pTOiLM8yX6ygK/sAp5wN8T4CBDPuPhfky/zJfqQQCCSDFHZCcwR6tNOjlLGDGU
	K1GZ1qO1TVu54P89htNGj164DmSmTmg5hR86fUMsJbgiJHdaUsiPz4XCX+NLTpPg
	9zTTnRnb2A2cvDd8+SpYdYaQBplImdwa7Du1o/7Wn/4+g=
Received: from [192.168.100.68] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wAnFxeFu_1p55fGAA--.10394S2;
	Fri, 08 May 2026 18:31:36 +0800 (CST)
Message-ID: <6635ed59-23b9-4ad6-bca4-f2a8e1e3e400@163.com>
Date: Fri, 8 May 2026 18:31:33 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 v4 0/3] ext4: improve mballoc statistics reporting and
 control
To: tytso@mit.edu, libaokun@linux.alibaba.com
Cc: ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangguanyu@vivo.com, adilger@dilger.ca
References: <20260508093428.5814-1-liubaolin12138@163.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <20260508093428.5814-1-liubaolin12138@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnFxeFu_1p55fGAA--.10394S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFWfuFy3WFyrCryrGrWDCFg_yoW5WF4xpF
	WFqwsIqa1DW3W7GwnrCF4xW343Xa4fCw4UGFnFg348uF98tr9ayF4ftay5ZF9rJrW8ZFWU
	XF42kr95CFW2y37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UOF4iUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6gjqtWn9u4g-zQAA3o

Dear Ted, Baokun,

    I have revised the patch according to your previous comments.
    There are three additional points I would like to clarify:
	1.Ted, you previously suggested considering concurrency issues.
	  After thinking about it, I decided to use an atomic variable for 
s_mb_stats to address the concurrency problem.
	  Using a spinlock would require much larger code changes.
	
	2.Regarding the modification to Documentation/filesystems/proc.rst, I 
previously sent an email to Jonathan, the maintainer of proc.rst:
	  https://lore.kernel.org/all/87ik9bmphp.fsf@trenco.lwn.net/
	  Jonathan replied and agreed with my idea that it is sufficient to 
simply add the following note in proc.rst:
	  “See Documentation/admin-guide/ext4.rst for ext4-specific /proc entries.”
	  If you also agree, Ted, then in the future we will no longer 
duplicate ext4 proc file documentation in proc.rst.
	  All ext4 proc file related documentation will instead be maintained 
centrally in Documentation/admin-guide/ext4.rst.

	3.The functionality of the sys mb_stats file will be retained,
	  but the following note will be added to 
Documentation/ABI/testing/sysfs-fs-ext4:
	  “This sysfs entry is deprecated, and users should prefer 
/proc/fs/ext4//mb_stats.”

    Thank you for your comments and reviews.

Thanks,
Baolin

在 2026/5/8 17:34, Baolin Liu 写道:
> This series improves ext4 mballoc statistics reporting and control.
> Compared with v3, this version adds a new patch to convert s_mb_stats
> to atomic_t and use atomic operations for its accesses, so as to avoid
> potential concurrent accesses to this variable.
> 
> Patch 3 is updated according to comments from Ted and BaoKun. Writing 0
> to /proc/fs/ext4/<dev>/mb_stats disables statistics collection, writing
> 1 enables it, and writing -1 clears the current statistics and enables
> collection. The related documentation is updated accordingly, and the
> sysfs mb_stats entry is documented as deprecated in favor of the proc
> mb_stats entry.
> 
> Changes since v3:
>    - add a new patch to convert s_mb_stats to atomic_t and use atomic
>      operations for its accesses
>    - update /proc/fs/ext4/<dev>/mb_stats write semantics based on comments
>      from Ted and BaoKun
>    - update related documentation and document sysfs mb_stats as deprecated
> 
> Baolin Liu (3):
>    ext4: add blocks_allocated to mb_stats output
>    ext4: use atomic operations for s_mb_stats accesses
>    ext4: allow controlling mballoc stats through proc mb_stats
> 
>   Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
>   Documentation/admin-guide/ext4.rst      |  9 +++-
>   Documentation/filesystems/proc.rst      | 13 +-----
>   fs/ext4/ext4.h                          |  3 +-
>   fs/ext4/mballoc.c                       | 57 +++++++++++++++++++------
>   fs/ext4/sysfs.c                         | 55 ++++++++++++++++++++++--
>   6 files changed, 109 insertions(+), 31 deletions(-)
> 

