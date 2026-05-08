Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A841A2F8EA3;
	Fri,  8 May 2026 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230116; cv=none; b=hQYLzsEA7AyAFLOnit52mNv3SlV5QxSgw/t7M8akeLluDo58DfsvL2SaawHXhJEo8M0XrpdD5kPVAXCj8seMUH+5P39YV/YDYovtsM64Ju6sDz8Xy5XoY6wl6MQtHWPqQR7wuXadb0io8pT5Inziyhg0Xx2mi4K6c8o1HLUYr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230116; c=relaxed/simple;
	bh=Jf7SM2waUOR6s6oAxl8TdVOtBZsKvn9jKVopQ2xFx5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YPvCUL+e3M92XdNY6Hkndj13ro6cQ9j4VYcM5Xj7PO95ZQkvbtYaYHtgOSPuEgiYS1jkKzM2vfJz4kzR43/uBfakD5TAALLmek9DOQkcr3L66a09j6mhyCqvQr+GFEdbuaFTyKJpZYQY0p3BXfrPqRpJXWWyDY3xEQlIX2r6JHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gBjS158X9zKKLCS;
	Fri,  8 May 2026 16:47:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8A31A40561;
	Fri,  8 May 2026 16:48:31 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgA3_1peo_1pl0EkBg--.14769S3;
	Fri, 08 May 2026 16:48:31 +0800 (CST)
Message-ID: <e42f3d75-4e38-43b5-a9e4-992428a7836c@huaweicloud.com>
Date: Fri, 8 May 2026 16:48:29 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/22] ext4: simplify error handling in ext4_setattr()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-4-yi.zhang@huaweicloud.com>
 <yueuhejhnqlffyjth5u56japyrgeoa74pasp5zydwrxgbnfrco@iv3gpx33esvu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <yueuhejhnqlffyjth5u56japyrgeoa74pasp5zydwrxgbnfrco@iv3gpx33esvu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3_1peo_1pl0EkBg--.14769S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr18Wr1rZr1UWFyxKw4DJwb_yoW3trg_ua
	1vywsrGw4Fvr1ftrZrZF4ayrsYkrsIgrnrWFyFywnxW3yDta4kAF1FkFy0vr1xGrWfKrsx
	WF18Ja4xZr9FgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOB
	MKDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 4/30/2026 9:03 PM, Jan Kara wrote:
> On Wed 22-04-26 10:10:23, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Remove the redundant rc variable and consolidate error handling.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> One comment below. Otherwise the changes look good.
> 
>> @@ -6073,8 +6073,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>>  
>>  		filemap_invalidate_lock(inode->i_mapping);
>>  
>> -		rc = ext4_break_layouts(inode);
>> -		if (rc) {
>> +		error = ext4_break_layouts(inode);
>> +		if (error) {
> 
> This is wrong. Errors from ext4_break_layouts() just need to be returned
> but they shouldn't be logged with ext4_std_error().

Yeah, I got it, will fix.

Thanks,
Yi.

> 
>>  			filemap_invalidate_unlock(inode->i_mapping);
>>  			goto err_out;
>>  		}
> 
> 								Honza

