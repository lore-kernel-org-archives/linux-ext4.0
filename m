Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44271E2606
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 03:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782186360; cv=none; b=kyVejpRECUQv3TkiKxs1Aku4Wn2hhNp4miOScAHR2VJ7DOa5xQTnk8uXgOTK/onTxTuNE0UFi5PS8nOs/MoURHqOy6ePhjBBplVreSIBxsVhWa3QLwctMcX97C8bIlIK7oov1/iRCTMwtgwuFy+9iW1kkoQWBRqXzH98IGxT3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782186360; c=relaxed/simple;
	bh=87N87jEamJvoI/Qr/uYeyaF5fldzs4WolKVKKKPGFaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f/qufqemEd/tqNo+QnBftGYt1aoQOUj3XuZHklHrSMpLKepPJSqyfrfVdLNkxQ5qw7YZq7GNelZuQDN2hVRJdGpLCcUeqXF8ZZ8skrEcrnCxbvmAhXXM+m4BB/XJ+p3H1i5IkjAUiUpRFFrhjWUulP72B4b+alz8YZylPNp7zfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gkrYk566WzYQtwx
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:45:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D9AB04099E
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:45:54 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgCHij9yATpq5FUiCw--.58601S3;
	Tue, 23 Jun 2026 11:45:54 +0800 (CST)
Message-ID: <537ca4c0-e63e-4399-9760-e963b01b16e9@huaweicloud.com>
Date: Tue, 23 Jun 2026 11:45:53 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] ext4: handle IOCB_NOWAIT in
 ext4_dio_needs_zeroing() with cache-only lookup
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-9-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260618125735.4156639-9-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCHij9yATpq5FUiCw--.58601S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF1xXryDtrWDXFW7GFWUtwb_yoW5ZrW7pa
	45XF13uF13W34kurWfGr15Zr4Fgwn8GFZ8Ca43K3s8Za40qr1xtF10vFyYy3WjvrWxAw1j
	qFnYyF13uFW8JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUotCzDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/18/2026 8:57 PM, Baokun Li wrote:
> Add a nowait parameter to ext4_dio_needs_zeroing() and pass
> EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
> IOCB_NOWAIT is set. This ensures the needs_zeroing check only uses
> cached extent info. If cache misses, ext4_map_blocks() returns
> -EAGAIN, causing ext4_dio_needs_zeroing() to conservatively return
> true (needs zeroing). The caller then tries to upgrade to exclusive
> lock, which returns -EAGAIN for NOWAIT, avoiding potential sleep on
> down_read(i_data_sem).
> 
> The caller in ext4_dio_write_checks() is updated to pass the
> IOCB_NOWAIT flag from the kiocb.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/file.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 5ffc1afd8050..44d1658d2b5a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -228,7 +228,8 @@ ext4_extending_io(struct inode *inode, loff_t offset, size_t len)
>   * unwritten conversion for middle blocks are protected by i_data_sem
>   * and inode_dio_begin().
>   */
> -static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
> +static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len,
> +				   bool nowait)
>  {
>  	struct ext4_map_blocks map;
>  	unsigned int blkbits = inode->i_blkbits;
> @@ -236,10 +237,14 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  	bool head_partial, tail_partial;
>  	ext4_lblk_t head_lblk, tail_lblk;
>  	int err;
> +	int map_flags = 0;
>  
>  	if (pos + len > i_size_read(inode))
>  		return true;
>  
> +	if (nowait)
> +		map_flags = EXT4_GET_BLOCKS_CACHED_NOWAIT;
> +
>  	head_partial = (pos & blockmask) != 0;
>  	tail_partial = ((pos + len) & blockmask) != 0;
>  	head_lblk = pos >> blkbits;
> @@ -249,7 +254,7 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  	if (head_partial) {
>  		map.m_lblk = head_lblk;
>  		map.m_len = tail_lblk - head_lblk + 1;
> -		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		err = ext4_map_blocks(NULL, inode, &map, map_flags);
>  		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
>  			return true;
>  		/* If this mapping already covers the tail block, we're done. */
> @@ -261,7 +266,7 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  	if (tail_partial) {
>  		map.m_lblk = tail_lblk;
>  		map.m_len = 1;
> -		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		err = ext4_map_blocks(NULL, inode, &map, map_flags);
>  		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
>  			return true;
>  	}
> @@ -516,7 +521,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	 * under shared lock is safe.
>  	 */
>  	if (ext4_unaligned_io(inode, from, offset))
> -		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count);
> +		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count,
> +						iocb->ki_flags & IOCB_NOWAIT);
>  
>  	/* Determine whether we need to upgrade to an exclusive lock. */
>  	if (*ilock_shared &&

