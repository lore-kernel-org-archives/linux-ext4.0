Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1737F10D;
	Tue,  3 Feb 2026 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770101008; cv=none; b=f3e4htE5sejGo5216B3VV/YP2ZTF5bUMu8jlHGeScV7i72E461lW8v6SL2lpPs/fpUnKzZYwCoLmG8gTD0sgvs+8ZO8e3krixRP6AXmrecMhp3gevjZGo+g3bT+dwmZhgEDhjYCK3kNCbvXqHjfx7ltdqhN2Jak8PZYqUCvX7yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770101008; c=relaxed/simple;
	bh=YxnLEDFvxUI7l36+T8EekjNNMUgD0xYWyK83awG3GWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hpp/O7+QdI1Ydlhdmz0yB0uhydprFvRmHwUHA/q+KlPysUm/1EZt3jUvy2RjzK5KODy7yN80iedsWf05bmt0j5ryI2fgwTcb0LssBdW7h4FUQFLvl500zgBjs+GvFK2uPLZufZ4cWXBQdLmWarslQtp2Fp+9vbJj3GA7UU312+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IqYpjmZ9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IqYpjmZ9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3mIYYnmGWQthU0VsUBlRairb/xoImbcJWcAdyZ3LfIQ=; b=IqYpjmZ9xcRBPhMG5DRB1fGaKI
	wZ3htFSGptgohTgwCq4Gj+p/VM2pfewBfZFugiT2rZ1cMz5Fkp3SUUh3yvZWpk/9VxH2XGEs0/ZO5
	3/NJnvWx6rY22ExCZyPj6RuKoSc1CYlAIJyG5WmmzBppvQssbact0IdGCMH6NtomgwA73zLNkaQWO
	MlyUOS7J5QlHJNlaIpsXZgCeUZPC1V1sLRyoyZkMGD/SSC77ebgkOhn1T6AYjFLuL1lIL2Ee7eJDJ
	yDOrBrN9u0+I/RS/v9Dl4S9O9SoAR9fldeWqw9NYY3q3B8Yt7MjMelxwiBW3gNlQTK13GOcXLC9oj
	NjVBM01Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnA87-00000006Cnk-3hNU;
	Tue, 03 Feb 2026 06:43:19 +0000
Date: Mon, 2 Feb 2026 22:43:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, jack@suse.cz, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, hch@infradead.org, djwong@kernel.org,
	yi.zhang@huaweicloud.com, yizhang089@gmail.com,
	libaokun1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH -next v2 00/22]  ext4: use iomap for regular file's
 buffered I/O path
Message-ID: <aYGZB_hugPRXCiSI@infradead.org>
References: <20260203062523.3869120-1-yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203062523.3869120-1-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> Original Cover (Updated):

This really should always be first.  The updates are rather minor
compared to the overview that the cover letter provides.

> Key notes on the iomap implementations in this series.
>  - Don't use ordered data mode to prevent exposing stale data when
>    performing append write and truncating down.

I can't parse this.

>  - Override dioread_nolock mount option, always allocate unwritten
>    extents for new blocks.

Why do you override it?

>  - When performing write back, don't use reserved journal handle and
>    postponing updating i_disksize until I/O is done.

Again missing the why and the implications.

>  buffered write
>  ==============
> 
>   buffer_head:
>   bs      write cache    uncached write
>   1k       423  MiB/s      36.3 MiB/s
>   4k       1067 MiB/s      58.4 MiB/s
>   64k      4321 MiB/s      869  MiB/s
>   1M       4640 MiB/s      3158 MiB/s
>   
>   iomap:
>   bs      write cache    uncached write
>   1k       403  MiB/s      57   MiB/s
>   4k       1093 MiB/s      61   MiB/s
>   64k      6488 MiB/s      1206 MiB/s
>   1M       7378 MiB/s      4818 MiB/s

This would read better if you actually compated buffered_head
vs iomap side by side.

What is the bs?  The read unit size?  I guess not the file system
block size as some of the values are too large for that.

Looks like iomap is faster, often much faster except for the
1k cached case, where it is slightly slower.  Do you have
any idea why?

>  buffered read
>  =============
> 
>   buffer_head:
>   bs      read hole   read cache      read data
>   1k       635  MiB/s    661  MiB/s    605  MiB/s
>   4k       1987 MiB/s    2128 MiB/s    1761 MiB/s
>   64k      6068 MiB/s    9472 MiB/s    4475 MiB/s
>   1M       5471 MiB/s    8657 MiB/s    4405 MiB/s
> 
>   iomap:
>   bs      read hole   read cache       read data
>   1k       643  MiB/s    653  MiB/s    602  MiB/s
>   4k       2075 MiB/s    2159 MiB/s    1716 MiB/s
>   64k      6267 MiB/s    9545MiB/s     4451 MiB/s
>   1M       6072 MiB/s    9191MiB/s     4467 MiB/s

What is read cache vs read data here?

Otherwise same comments as for the write case.

