Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D6E331EB1;
	Thu,  9 Jul 2026 03:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783566856; cv=none; b=n5BPYKZSnCl7PrSpB4EdSPpWLYw71seQU6Oh8KRGD+n3X/NiDAD3cK8qiU9Rx3V3ZhqWmUakQKrBgZDsG7zGOM/jIYYOw4UCH4+ZSJ07aFVxSTFe47tURVkVMzmLmsWqF9K2Bj4bjZs6toZNOF4fhGgC52x5ziSBOy7EyQLtcag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783566856; c=relaxed/simple;
	bh=sFY3IJPLB3VCnBY4TSr/pQh+xXRRB+4VSytgWoW3MrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3VGKMbTHnaBajrsBpnZzYuhQPkhZyFTTYziPIYFDwAlHVCGvh8uQvruetbChcl9uyO8Svzo/6B4FwOq3lwufX7C+9A447JSfOlohI33h19j1ZsNxMoWgZbZ70PA6Zq40ixmpBRd47dvFlxVIUVAXd9tQJmhhsuTAUPFFmW420I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gwfjz0CYLzKHMN1;
	Thu,  9 Jul 2026 10:56:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E48AC4058F;
	Thu,  9 Jul 2026 10:56:44 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCntnLrDU9qnd1EAg--.32414S3;
	Thu, 09 Jul 2026 10:56:44 +0800 (CST)
Message-ID: <8a980822-fe8f-4497-8202-0eda40f627a9@huaweicloud.com>
Date: Thu, 9 Jul 2026 10:56:43 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] ext4: clarify return semantics of
 ext4_load_tail_bh()
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
 <20260707021338.1182268-3-yi.zhang@huawei.com>
 <fn6frodirjc2zvd3sl5zwh4h7q5dfbbha2le3eylq2sne4k7fm@upemtxsqhsz3>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <fn6frodirjc2zvd3sl5zwh4h7q5dfbbha2le3eylq2sne4k7fm@upemtxsqhsz3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCntnLrDU9qnd1EAg--.32414S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4UuF45Jr45XFyftr47Arb_yoW5GrWrp3
	s8KasrGr4rWa4v9a1xJ3W7Xr1YgasxGr4UWFWrK3W2yas0gr1IvF1IkFyS9F42yrWfKrWY
	qFWjgFy3Ga1DArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
	F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUOBMKDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/8/2026 11:26 PM, Jan Kara wrote:
> On Tue 07-07-26 10:13:34, Zhang Yi wrote:
>> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
>> buffers, but the conditions that lead to this are not obvious from the
>> code alone. Document this behavior to clarify the return value, so that
>> readers do not mistakenly assume that only holes result in a NULL
>> return.
>>
>> Also update the inline comment following the ext4_get_block() call to
>> reflect this, and note that a lookup-only get_block (without
>> EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean unwritten
>> extents, which is why a clean unwritten bh falls through to the
>> "nothing to do" path.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza

Hi, Jan!

Thank you for the review. I have already sent out v3 of this series.
Sorry I forgot to mention it earlier. It includes fixes for some
pre-existing issues in Sashiko. Could you please take a look at that
version?

https://lore.kernel.org/linux-ext4/20260708062049.1982410-1-yi.zhang@huaweicloud.com/

Thanks,
Yi.

> 
>> ---
>>  fs/ext4/inode.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c2c2d6ac7f3d..45a7e6cdb2a1 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>>   * because it might have data in pagecache (eg, if called from ext4_zero_range,
>>   * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>>   * racing writeback can come later and flush the stale pagecache to disk.
>> + *
>> + * Return the loaded bh if it actually needs zeroing - in written, dirty
>> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
>> + * a clean unwritten block).
>>   */
>>  static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>>  {
>> @@ -4065,7 +4069,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>>  	if (!buffer_mapped(bh)) {
>>  		BUFFER_TRACE(bh, "unmapped");
>>  		ext4_get_block(inode, iblock, bh, 0);
>> -		/* unmapped? It's a hole - nothing to do */
>> +		/*
>> +		 * It's a hole or a clean unwritten block - nothing to do.
>> +		 * Note that a lookup-only get_block (without
>> +		 * EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean
>> +		 * unwritten extents.
>> +		 */
>>  		if (!buffer_mapped(bh)) {
>>  			BUFFER_TRACE(bh, "still unmapped");
>>  			goto unlock;
>> -- 
>> 2.52.0
>>

