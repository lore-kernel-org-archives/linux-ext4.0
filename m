Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125AE1A6827;
	Tue, 24 Mar 2026 03:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774322210; cv=none; b=CCjo0XfSFazxjJhTEH/EBIG4OZz+IMn08DZKG56+ZGFXdPOkP2+LGTJbCj1tQur7TmAWuHaXbvx6NHDWxZXKWjLpkOCHZuUMIt7k+2kA7JJGoiFtvtmwLGsprph29rfr5/lfvpolvfcEh+84rERwZBjSOSnrqbO52DrCsiQ6szU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774322210; c=relaxed/simple;
	bh=Rg2Wgh3fGpaQDmkFpoBaKTThKZj0sRPlDukBKZ0pTyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AG/zto5FVwF3BAK4r/8MQxPxTz306tbnj2hF6pNvLFItuQJCxvntO1/kCnU9VqK9fnIDxMpb5qYep394iU6QfV4EqiN9yBk4bawc1Lvslen8hHjTDyUgXwdQU2DqFnsaVT6xU5uZLikkc4qNcnd6UY3znlUK/kzy3aoyLWIZ8nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ffwDj6yMSzYQtgY;
	Tue, 24 Mar 2026 11:16:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EDA6540562;
	Tue, 24 Mar 2026 11:16:45 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBHSdkcAsJp6MINCA--.24754S3;
	Tue, 24 Mar 2026 11:16:45 +0800 (CST)
Message-ID: <e76ef975-1821-4ca2-a2f7-ff84d3b2165c@huaweicloud.com>
Date: Tue, 24 Mar 2026 11:16:44 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] ext4: factor out journalled block zeroing range
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-5-yi.zhang@huaweicloud.com>
 <gvsj27lkqxs6xy7rdiyarw5ocjuvqrrn2knx5jo45eoc7tw6no@kow27zlgjy5r>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <gvsj27lkqxs6xy7rdiyarw5ocjuvqrrn2knx5jo45eoc7tw6no@kow27zlgjy5r>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHSdkcAsJp6MINCA--.24754S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ur15JFyfXr4DtF4xXF17trb_yoW8Ar43pF
	yrKa1xWwsrWFWv9a1IqFnrXryI9a1kur4rWry3Gryjva4YqF929Fy0g3WFgFyjvrW3G340
	qFyjq342gwn0yFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	0PfPUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/24/2026 12:48 AM, Jan Kara wrote:
> On Tue 10-03-26 09:40:55, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Refactor __ext4_block_zero_page_range() by separating the block zeroing
>> operations for ordered data mode and journal data mode into two distinct
>> functions:
>>
>>   - ext4_block_do_zero_range(): handles non-journal data mode with
>>     ordered data support
>>   - ext4_block_journalled_zero_range(): handles journal data mode
>>
>> Also extract a common helper, ext4_block_get_zero_range(), to handle
>> buffer head and folio retrieval, along with the associated error
>> handling. This prepares for converting the partial block zero range to
>> the iomap infrastructure.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Just one nit below. Otherwise feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 52c6a86ad9f9..d63d455831b9 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4002,13 +4002,12 @@ void ext4_set_aops(struct inode *inode)
>>   * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>>   * racing writeback can come later and flush the stale pagecache to disk.
>>   */
>> -static int __ext4_block_zero_page_range(handle_t *handle,
>> -		struct address_space *mapping, loff_t from, loff_t length,
>> -		bool *did_zero)
>> +static struct buffer_head *ext4_block_get_zero_range(struct inode *inode,
>> +				      loff_t from, loff_t length)
> 
> I'd call this function ext4_load_tail_bh() and AFAICT the 'length' argument
> is unused so it can be dropped.
> 
> 								Honza

Ha, sounds better, will do in my next iteration.

Thanks,
Yi.

