Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793089214;
	b=cFjcyS2ODyWIcdKraF+Fi3/2voa5UFNX/xmukKfpZ8gkehvsMecJBcVQlYJn65aGIYfT
	 +W+ivJa8bUTDzgo4MLTrSovqgQ11QoJ/bRhwIi83eJOCYqk4Yu9g7qYuvC93IBAuBFhXc
	 XCPlbpcvBgF11R05pV2geEgTB/2NY9lx9wEYtVpv1Q57sm1DKscP+Ivl33kjfzbE4+qxY
	 vVi68/2pqrFxyY64AolSOWtqjmWwLRR90nFllGteNRQHrWWmibzKl91CVdi2SkTXoAgVy
	 YF51FNfnAKoYFPE7Jgdt2c/qo8e4T4E/da1pLFz73D4RfdYywVjC1DJiu5AopuJ+ROg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089214;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=mF5SJD69a3HlW4ReVj2JO8TQdc2ATRCwqzLg4ody7s4=;
	b=ARccwK2oROsmFXBYf3lbGEEPUEayN112ZLF4RBICAqs26r1V4lXtGU+wE2zt7WRq3jJw
	 T4pTlenI8oANYjo4pAHHu79pN4el9v7VuD1cBg3hkG8Ty9IQz2GogUvDOODrrKKPqQp68
	 hw15HwftjVQW71bvNsDNGzdHk8k9qnBm7iJ3KaHQmM/Ryu0gYgcPeRdxgPRqZ3IFjuvIP
	 UcYi7HKMVW94sxCHWNWvl7HftpeseVybCffgMeSTwfmACkOw5VqEREPgwkjZLZZ88GQON
	 N4Rc12wGmFdLpWUgUZzvSr9gxVQNs3Z4cfSNjgRkPXehqAH635Z1m/nj1M5CiT6nKJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73842606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 08:20:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73842606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jDNhW5fmTz1c0Xj
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 16:19:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A63B640561
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 16:20:08 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu22XuBqTi0MCA--.64198S3;
	Tue, 27 Oct 2026 16:20:08 +0800 (CST)
Message-ID: <7e1e7913-223b-4382-95ef-c00e7890729d@huaweicloud.com>
Date: Tue, 27 Oct 2026 16:20:06 +0800
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
Subject: Re: [PATCH 3/4] ext4: add inode to orphan list before extent
 conversion
To: sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
 <20261026115131.1735014-4-yi.zhang@huaweicloud.com>
 <sashiko-outbox-185275@kernel.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <sashiko-outbox-185275@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAXTu22XuBqTi0MCA--.64198S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurWUWw4xtr4DCr4xWrWrGrg_yoWrCr15pr
	WrAr15Ka1FqasY9rsaq3WDZF1jk347Kr45XryagrWrZasxJF1xK345Ka429as5trW8XF4Y
	vF40yryUCan8ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgqb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVj
	vjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/26/2026 9:10 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4: silent false success on ENOSPC retry in ext4_alloc_file_blocks()
> --
> 
> commit af54a86e4faf105f27b9869fc053a46b111dbda1
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: add inode to orphan list before extent conversion
> 
> This commit moves the ext4_orphan_add() call in ext4_alloc_file_blocks()
> before ext4_convert_unwritten_extents() so that transaction restarts during
> extent conversion do not leave written extents beyond i_disksize uncovered by
> the orphan list. It also adjusts the post-conversion progress and cleanup
> handling when conversion fails before converting any blocks.
> 
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 7193429a05e1f..677749f0c9c68 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4701,6 +4701,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  				break;
>>  			}
>>  
>> +			/*
>> +			 * Add the inode to the orphan list before the
>> +			 * conversion, as it may restart the transaction and
>> +			 * commit the extents converted so far.  Written
>> +			 * extents must stay covered by the orphan list until
>> +			 * i_disksize catches up.
>> +			 */
>> +			if (new_size) {
>> +				ret2 = ext4_orphan_add(handle, inode);
>> +				orphan = true;
>> +				if (unlikely(ret2)) {
>> +					ret = ret2;
>> +					ext4_journal_stop(handle);
>> +					break;
>> +				}
>> +			}
>> +
>>  			ret = ext4_convert_unwritten_extents(handle,
>>  					inode, (loff_t)map.m_lblk << blkbits,
>>  					(loff_t)map.m_len << blkbits,
>> @@ -4708,23 +4725,19 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  			if (ret)
>>  				map.m_len = converted;
>>  
>> -			/*
>> -			 * If blocks beyond i_disksize are converted, add
>> -			 * the inode to the orphan list and advance the epos.
>> -			 */
>> -			if (new_size && converted) {
>> -				ret2 = ext4_orphan_add(handle, inode);
>> -				ret = ret ? ret : ret2;
>> -				orphan = true;
>> -			}
>> -
>>  			ret3 = ext4_journal_stop(handle);
>>  			ret = ret ? ret : ret3;
>>  		}
>>  
>> -		map.m_lblk += map.m_len;
>> -		map.m_len = len_lblk = len_lblk - map.m_len;
>> -		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
>> +		/*
>> +		 * The conversion may have failed without converting
>> +		 * anything.
>> +		 */
>> +		if (map.m_len) {
>> +			map.m_lblk += map.m_len;
>> +			map.m_len = len_lblk = len_lblk - map.m_len;
>> +			epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
>> +		}
>>  		if (ret)
>>  			break;
>>  	}
>> @@ -4732,12 +4745,13 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>>  		goto retry;
> 
> [Severity: High]
> What happens on the goto retry path if ext4_convert_unwritten_extents() fails
> with -ENOSPC and converted == 0?
> 
> When ret is non-zero and converted is 0, map.m_len is set to 0:
> 
> 	if (ret)
> 		map.m_len = converted;
> 
> Previously, map.m_len = len_lblk = len_lblk - map.m_len ran unconditionally,
> which restored map.m_len to len_lblk when map.m_len was 0. With that update
> now guarded by if (map.m_len), map.m_len remains 0 while len_lblk > 0.
> 
> If ret == -ENOSPC and ext4_should_retry_alloc() returns true, jumping to
> retry calls ext4_map_blocks() with map.m_len == 0:
> 
> fs/ext4/extents.c:ext4_alloc_file_blocks() {
> 	...
> 	while (len_lblk) {
> 		...
> 		ret = ext4_map_blocks(handle, inode, &map, flags);
> 		if (ret <= 0) {
> 			...
> 			ext4_mark_inode_dirty(handle, inode);
> 			ext4_journal_stop(handle);
> 			break;
> 		}
> }
> 
> Because map.m_lblk already maps to the unwritten extent allocated before the
> retry, both the extent status tree lookup in ext4_map_blocks() and
> ext4_ext_handle_unwritten_extents() clamp the returned block count to
> map.m_len (0). That causes ext4_map_blocks() to return 0, breaking out of the
> loop with ret == 0 and silently returning success to the caller without
> converting the unwritten extent or finishing the remaining allocation.
> 
> Should map.m_len be reset to len_lblk when map.m_len is 0 (or before jumping
> to retry)?
> 

Yeah, sashiko is right. We should always update map.m_len as before.
I will send to fix this.

Thanks,
Yi.



