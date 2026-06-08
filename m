Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF3019067C
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 02:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780885535; cv=none; b=q0KLQzGJkg7oMRIwEC5rpjFJUzmPSohaiLzXXls8suA5zM0gZulhkA97hSqCOI6LDRy8X004fD/EsrfhIoNaADyxiG/vMMS39lfqZpqAuqcexC0QPNxYLUPwzGUm4da73X76zrIovRNOG+nmbNzogh0TcHekBNUtWQCidfH5zJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780885535; c=relaxed/simple;
	bh=wPr7eHkIzzAJ/ndEIFBt7VCNY42bWr3NAFpOyOfgcPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n7kfCIRfOEPug2Fm/8Z5GnZEgWrmE4Ogh7uMXK1c3JKIh+zZRx/xTo0ehDe8UHHhojj0Xatxfhb02kHYO+E4ULkZoVR2cdAc8YioF1XwUN5Q8fBHFheel3O1WnD/LocBWfkSOpGdDwSndt4nhqjH5KLv5xUAMJi3gcCnqkFD4W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FanNQLIm; arc=none smtp.client-ip=47.90.199.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FanNQLIm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780885519; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ibLIHe6qXST5SgeBSCnsVIhz9BmvrbQSYderMAFaXCA=;
	b=FanNQLImev8tdOYuT+RM/Oppfmokkh0+E1Ni4VkBPf8Fchralcbpxu1Nllhvkk98v6EqnI6wquBHlSmDn5SJld7zjmiqIPVDrmwRO2MyJTKfy5jvIo7sLgymQ3jCdDj6OmKcBBfCnzVDJYyr/E07aB9ospvWKih8HQHJmAlRJGc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X4J3Rja_1780885518;
Received: from 30.221.148.53(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4J3Rja_1780885518 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 10:25:18 +0800
Message-ID: <93c7ae39-08f4-4ce6-a2ae-704296eaed49@linux.alibaba.com>
Date: Mon, 8 Jun 2026 10:25:17 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ext4: fix false-negative overwrite check for DIO
 spanning extent boundaries
To: Peng Wang <peng_wang@linux.alibaba.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 linux-ext4@vger.kernel.org, inux-kernel@vger.kernel.org
References: <20260607124935.6168-1-peng_wang@linux.alibaba.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260607124935.6168-1-peng_wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/6/7 20:49, Peng Wang wrote:
> ext4_overwrite_io() decides whether a direct I/O write is an overwrite
> (all target blocks already allocated) so the write can proceed under a
> shared inode lock.  It calls ext4_map_blocks() once and returns false
> if the mapped length is shorter than the requested length.
>
> ext4_map_blocks() maps at most one extent per call.  When a write
> straddles two extents (e.g. a written extent and an adjacent unwritten
> extent created by fallocate), the single call returns only the first
> extent's length.  ext4_overwrite_io() then mis-classifies the write as
> non-overwrite and forces the caller to cycle i_rwsem from shared to
> exclusive.

For the aligned case, the overwrite check can now be skipped entirely.

For non-aligned cases, you can optimistically hold the read lock and then
use the IOMAP_DIO_OVERWRITE_ONLY flag to upgrade to a write lock if needed.


