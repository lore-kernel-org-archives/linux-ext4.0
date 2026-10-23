Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792766651;
	b=nqQB6SA+N5bELe/u9znhzIgSjE02lefqBKn2qYcAq6fJOMF7o1QeXa7DwgFLTnUZUoH4
	 KUS4ZOXEVciHXUXHaDGsdMK2wQPU98q/xC0hgyXgFxPz/m4RV2qwl91XElqGObAEvsF8V
	 v0S8J4/xxJ+r7rsahAIJf6IlbwKGDROruGd18w7hA2UgkzRPAUFWJ8K7X5BMtW4Ljr8hV
	 W0iBKGgj9Agum6qrk/j44WwGXZDaHcD3lVE+5WDl4wzhUWOamTVJSL2uwjTRpWakIqOOw
	 lV33C7uLLNm/fdanPF4XiXXI+Qjw8x7HG9+XllaZc0Ma37TqT69Mu0RJWCmMacIJ4pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792766651;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=UzoPARaK93napsnGqG5eeO6IinVxNQh5GRiEnSU8yyY=;
	b=aSFSb6ie8hVoEhXhj7UFY477ctckMW5xjJZ7zypdf2enBdfv53DJpRdMPrwkU2VuiCgO
	 ZNHMaFGEt+ppIvkvHPTXqk1MhKMeHmkjTAryOb3EhwMrXtjEXIqPJERFlHNXCoObaIVY5
	 S+oyXzPoN1bp0bI7lTce/r7SSecV9/cLfVw9vSvCzq25fv/gauLm28d31eJJVYilf7kcl
	 0hQCYUanFcoIZXIQtzqQjsQ6yl9fd5ASZ1SgTkGUdNFZdNsijtHa3SCzucFF1Y+GWoiwz
	 agackyoHx7JenQxsId5wOotyZViAn5PigLTExuzd+oro/9znYYuXHCFU85MFZTteVnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EEpaWNqZ;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B9C606A31A;
	Fri, 23 Oct 2026 14:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52B9C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EEpaWNqZ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792766645; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UzoPARaK93napsnGqG5eeO6IinVxNQh5GRiEnSU8yyY=;
	b=EEpaWNqZplxCjJvePXbwsM56qM2d7sAY+RubeXQHMGDoVx8dCikxA8Ci1/PeqZ5ewzGigM8uA/3csF0GFUWaIg5EfJCg/TvrAiFGtXqvndnduf9jTEUcgFRqQBsNptOgGvnZOTzUiNY2kRqKRifxZoGvrIIW/XFUArDXaKMAssc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDMK9Hz_1792766643;
Received: from 30.134.34.157(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDMK9Hz_1792766643 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 22:44:04 +0800
Message-ID: <0e1f16c4-9b4e-414a-bb5e-996812e68986@linux.alibaba.com>
Date: Fri, 23 Oct 2026 22:44:03 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: skip eof zeroing when the zero range covers the
 eof block
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <sashiko-outbox-181121@kernel.org>
 <20261022122625.1744363-1-libaokun@linux.alibaba.com>
 <fc8f09e1-02b6-4d76-95d8-d19c5635f4d5@huaweicloud.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <fc8f09e1-02b6-4d76-95d8-d19c5635f4d5@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/10/23 17:23, Zhang Yi wrote:
> On 10/22/2026 8:26 PM, Baokun Li wrote:
>> ext4_zero_range() drops the page cache of the range before allocating,
>> to avoid exposing stale cached data.  However, the dropped page can be
>> read back by the eof zeroing:
>>
>>   fallocate(fd, FALLOC_FL_ZERO_RANGE, 0, 4096)
>>     ext4_zero_range()
>>       ext4_truncate_page_cache_block_range(0, 4096)
>>         truncate_pagecache_range(0, 4095)
>>           truncate_inode_pages_range()
>>             delete_from_page_cache_batch()  # drops the page
>>       ext4_alloc_file_blocks(..., 4096)
>>         ext4_block_zero_eof(512, LLONG_MAX) # not block aligned
>>           ext4_load_tail_bh()
>>              __filemap_get_folio(FGP_WRITEBEGIN | FGP_ACCESSED)
>>              # FGP_CREAT reads the dropped page back
>>              # zeroes [512,1024), marks the buffer dirty
>>         ext4_map_blocks(...)  # converts the extent to unwritten
>>         ext4_update_inode_size(4096)
>>
>> The bytes below the old EOF keep the stale disk content.  The page is
>> left dirty, so read() returns old data while O_DIRECT reads zeroes, and
>> a write into the same block is not converted and is lost until the page
>> is dropped:
>>
>>   page [0, 4096), 1k block size, file ends at 512
>>    0            512          1024                      4096
>>    |--- data ----|-- tail ---|---- zero range ----------|
>>    | old data    |           |                          |
>>
>> For example:
>>
>>   $ xfs_io -f -c "pwrite -S 1 0 512" f
>>   $ sync
>>   $ fallocate -z -o 0 -l 4096 f
>>   $ xfs_io -c "pread -v 0 16" f  # old data, not zeroes
>>
>> FALLOC_FL_WRITE_ZEROES hits the same path.  ext4_issue_zeroout() zeroes
>> the block on disk without updating the page cache, and the block stays
>> written.  Therefore, writeback of the dirty page overwrites the zeroes
>> with old data.
>>
>> Since the whole eof block is converted to unwritten or zeroed out,
>> zeroing it here is redundant.  Therefore, skip the zeroing when this
>> allocation covers the eof block entirely.
>>
>> Fixes: c4602a1d09ec ("ext4: move zero partial block range functions out of active handle")
>> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> 
> Hi Baokun,

Hi Yi,

> 
> Thank you for the fix, this is a nice catch. This makes sense to me.
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> 

Thank you for your review!

> One small point, the condition you added looks a bit confusing. I'm
> wondering whether, in the future, it would be more straightforward to
> extract ext4_block_zero_eof() from ext4_alloc_file_blocks() into
> ext4_zero_range() and ext4_do_fallocate()?

That sounds great. By writing zeros before truncating the page,
we won’t have to worry about the page cache being read back,
which means we won’t need to check the position of the EOF block
anymore.

I’ll send this out as a separate refactoring patch.

Thanks for the suggestion.


Cheers,
Baokun

