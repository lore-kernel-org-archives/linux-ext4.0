Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662971;
	b=nkQqchi5taRdsktsuNvsRz/ozVhEC4uBOzfttP70ZS4Vmzylll9J2+dEt5JBkI0JiMd6
	 7xIxxa4r/vltPwIpGlhclqKVEUpkp5IGBKI5H9eC4JUgEAEdriyTEobe5cqoRemH3fmJW
	 u3nV/PRXfz+InNzWWWOTabGmfl0Wh1IoSiz3tIIbdgLYpfT+Hvbxh1njowK57naBNt5PK
	 aN8PB2f17qRKFKnqaRVTTlSZcDIF7n+xUjS8UUAglI1+uGQrqqXFjQ9x8Cqw0cAFnjO4F
	 TcKanXvtn8v9N1wODjHC01L0fpawTIJzNuTznhZxmM1S/cAje+KCVXTd8Qc7xC5RKAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662971;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wc8R6pcetAOysFIliaOJ2VQr+tr2jqU67xiXxMwPvfM=;
	b=Q9eYf9IiuuoqFigZIQjIm9NvhqojFIg5I7j4Y3jYdYCJ17fP2YCYAtRtzNnuyMpfP10x
	 WsW1dAPafEErYJ+ILY2X5Y3CtIjy9QmKXhlDTdF4loe7v2JAYKW8s+LYE0QzvgIpl/l0Y
	 x527uUxheBLZf98TVPIqrU4ayQKTyfMknbFNbQIhsUTH4cQii57E1Sk12/9kU8JpcxEOf
	 3rfHz8+u/MCtfviP1cSTtwlgBtJbtFlzVPyLJ5B7uvs8mdidurhAp9fP2j5i3sZNMgrJt
	 pMwjKqgF57vnVr3R/Va5HDJBXPR+TLu5uwfU15KoC/IylRFpxUsDdRVNypWN8tNT6Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=S6SKAGp8;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05DB606A329
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 09:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E05DB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=S6SKAGp8
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792662961; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wc8R6pcetAOysFIliaOJ2VQr+tr2jqU67xiXxMwPvfM=;
	b=S6SKAGp8BSICqU2kLKb/xtQ5FJMmRjSGeUd4Q66qhAZOi76fU2QRE1B5Z2+kZlZvZA0Y4VzxuKHvpf7vCUoOjMHdTIjfaLT5Iv8RBJlbHUkmft87Vvgd3Wpr84d5ar0Av7uS7h7nl3NUkpq1aWf+SQVlmfAmNMgfgXS2PP25PlI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0XDIrfSv_1792662960;
Received: from 30.221.132.50(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDIrfSv_1792662960 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 17:56:01 +0800
Message-ID: <dd05e858-88f6-40de-b91d-734e171915ca@linux.alibaba.com>
Date: Thu, 22 Oct 2026 17:56:00 +0800
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
Subject: Re: [PATCH] ext4: skip eof zeroing when the zero range covers the eof
 block
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, sashiko-reviews@lists.linux.dev
References: <20261022065342.3569693-1-libaokun@linux.alibaba.com>
 <sashiko-outbox-181121@kernel.org>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-181121@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/22 15:16, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] ext4: stale data in ext4_alloc_file_blocks() on FALLOC_FL_WRITE_ZEROES
> --
>
> commit 5e26fed6c5f3f56bd5013064a243a3a558e3a73d
> Author: Baokun Li <libaokun@linux.alibaba.com>
>
> ext4: skip eof zeroing when the zero range covers the eof block
>
> This commit skips calling ext4_block_zero_eof() in ext4_alloc_file_blocks()
> when EXT4_GET_BLOCKS_CONVERT_UNWRITTEN is set and the allocation range covers
> the EOF block, preventing the dropped EOF page from being read back into the
> page cache with stale data during FALLOC_FL_ZERO_RANGE.
>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 7193429a05e1f..8f7ded6e08299 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4639,8 +4639,15 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  	credits = ext4_chunk_trans_blocks(inode, len_lblk);
>>  	depth = ext_depth(inode);
>>  
>> -	/* Zero to the end of the block containing i_size */
>> -	if (new_size > old_size) {
>> +	/*
>> +	 * Zero to the end of the block containing i_size.
>> +	 * Loading the eof block back before it is converted to unwritten
>> +	 * may leave the page cache inconsistent with the disk, and zeroing
>> +	 * it is redundant, so skip it.
>> +	 */
>> +	if (new_size > old_size &&
>> +	    (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) ||
>> +	     !in_range(old_size >> blkbits, map.m_lblk, map.m_len))) {
>>  		ret = ext4_block_zero_eof(inode, old_size, LLONG_MAX);
>>  		if (ret)
>>  			return ret;
> [Severity: Critical]
> Does this condition also need to check !alloc_zero to cover the
> FALLOC_FL_WRITE_ZEROES path?
>
> In ext4_zero_range(), after ext4_truncate_page_cache_block_range() drops the
> page cache, FALLOC_FL_WRITE_ZEROES calls ext4_alloc_file_blocks() with
> EXT4_GET_BLOCKS_CREATE_ZERO rather than EXT4_GET_BLOCKS_CONVERT_UNWRITTEN:
>
> 	if (align_end > align_start) {
> 		if (mode & FALLOC_FL_WRITE_ZEROES)
> 			flags = EXT4_GET_BLOCKS_CREATE_ZERO | EXT4_EX_NOCACHE;
> 		else
> 			flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
> 				  EXT4_EX_NOCACHE);
> 		ret = ext4_alloc_file_blocks(file, align_start,
> 					     align_end - align_start, new_size,
> 					     flags);
>
> Earlier in ext4_alloc_file_blocks(), EXT4_GET_BLOCKS_ZERO is cleared from
> flags and converted into alloc_zero = true:
>
> 	if (flags & EXT4_GET_BLOCKS_ZERO) {
> 		flags &= ~EXT4_GET_BLOCKS_ZERO;
> 		flags |= EXT4_GET_BLOCKS_UNWRIT_EXT;
> 		alloc_zero = true;
> 	}
>
> When FALLOC_FL_WRITE_ZEROES extends i_size across an unaligned written EOF
> block covered by [align_start, align_end),
> !(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) is true. As a result,
> ext4_block_zero_eof() is still called and reads the dropped EOF block back
> from disk into the page cache with stale data below old_size, marks the
> buffer or folio dirty, and then the loop zeroes the block on disk via
> ext4_issue_zeroout() and leaves the extent mapped as written.
>
> Wouldn't this leave the dirty page cache folio with stale data that is
> returned on buffered reads and written back over the zeroed disk block on
> writeback or fsync?
>

This is indeed another similar issue that can be addressed
in the current patch. I will send version 2 soon.

Thanks,
Baokun


