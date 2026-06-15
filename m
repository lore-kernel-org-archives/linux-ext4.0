Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C725F994
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 03:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781494105; cv=none; b=cwegbbyYzQ6RZiDnKEO7P63xHxl01M9DSvcneMa14TswFoP2k5+2jpGrF8zww0wZMYPAauQai/I2TkXSAz60QCW2YTlw3r2ri4P3H76hibYVQwLp19VVrKbLmh/YRdygAg6SHlK5ZOwrrPx1lNJACr3CxGW5SC2X+vz5UXztziw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781494105; c=relaxed/simple;
	bh=0dhq5Rtn7mrfRPrENLZ+8EhfzkNps4fyDtVrKPZUhyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PJT9GZOc1xeCIWelejzwEXxQ+0JmtV64IHijVTz4fvYgdYKMI8QSX5ifa8SmyMlXjV1grgPlHr93teV7Z1H5h+eLSF6Q4ubalY4gag/4/LvJf1y1JDdpxtClr99jCUfC7a9Ou6r6MARz22wXSZu8wp4XUB59YwxIyWjz2JsmqGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gdwXv3j5TzKHMWP
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 11:27:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 10D134058D
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 11:28:12 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgA3hzxLcS9qlWNeBw--.15300S3;
	Mon, 15 Jun 2026 11:28:11 +0800 (CST)
Message-ID: <e6d8cb99-564a-4789-9224-d6da8c85d955@huaweicloud.com>
Date: Mon, 15 Jun 2026 11:28:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260611163441.2431805-3-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgA3hzxLcS9qlWNeBw--.15300S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtFyktF1rGw1xJrykJryUGFg_yoWfCr43pF
	y3tFnxCr47K3y09rWxK3WxZr1Ygw1kJrW7A3y3Gr15Z348Z3WxKF92qFyFqa4FvrZ7X3WI
	vF4qvry7CFn0krJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbiF4tUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/12/2026 12:34 AM, Baokun Li wrote:
> For unaligned DIO writes, the previous ext4_overwrite_io() required the
> entire range to fall within a single written extent.  This was overly
> conservative: the DIO layer only performs partial block zeroing for the
> head and tail blocks when they are partially covered by the write.
> Middle blocks that are fully covered are written as whole blocks
> without any zeroing, so they are safe regardless of extent state.
> 
> Therefore exclusive lock is only required when partial block zeroing
> will actually happen:
>  - The head partial block (if any) lands on a hole or unwritten extent.
>  - The tail partial block (if any) lands on a hole or unwritten extent.
> 
> Middle full-cover blocks can be in any state (hole, unwritten, or
> written) - block allocation under shared lock is safe per the previous
> patch's analysis (inode_dio_begin + i_data_sem protection).
> 
> Replace ext4_overwrite_io() with ext4_dio_needs_zeroing(), which
> directly answers the question driving the lock decision.  It uses at
> most two ext4_map_blocks() calls: one for the head partial block (also
> catching the case where it spans through the tail), and one for the
> tail partial block if not already covered.
> 
> This enables shared lock for previously-rejected scenarios such as:
>  - Unaligned write spanning written extent + mid-range hole + written
>    extent at the tail.
>  - Unaligned write where the partial blocks land on written extents but
>    the middle has unwritten extents.
> 
> Performance:
> 
> Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
> Filesystem: ext4 default mkfs
> 
> Unaligned DIO writes (14336 bytes at +512 within each 16K stripe).
> Each stripe is laid out as [written][unwritten][unwritten][written],
> so the head and tail partial blocks land on written extents but the
> middle is unwritten.  Metric: IOPS.
> 
>   JOBS      Before        After    speedup
>   ----    --------    ---------    -------
>      1      15,547       17,381      1.12x
>      2      15,910       34,172      2.15x
>      4      15,014       57,567      3.83x
>      8      15,022       81,947      5.46x
>     16      14,586       99,126      6.80x
>     32      14,047       92,519      6.59x
> 
> Wall time at JOBS=32: 149.3s (Before) -> 22.7s (After), 6.58x faster.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

A nice conclusion and a solid speed-up.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/file.c | 108 +++++++++++++++++++++++++++++++++----------------
>  1 file changed, 73 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 6f3886465ce3..aa926e641739 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -213,31 +213,60 @@ ext4_extending_io(struct inode *inode, loff_t offset, size_t len)
>  	return false;
>  }
>  
> -/* Is IO overwriting allocated or initialized blocks? */
> -static bool ext4_overwrite_io(struct inode *inode,
> -			      loff_t pos, loff_t len, bool *unwritten)
> +/*
> + * Does an unaligned DIO write require partial block zeroing?
> + *
> + * Partial block zeroing is performed only for the head and tail blocks
> + * when they are partially covered by the write and the underlying extent
> + * is a hole or unwritten. Middle blocks (fully covered by the write)
> + * are written as whole blocks without zeroing.
> + *
> + * When zeroing is required, two concurrent unaligned DIO writes to the
> + * same partial block can race and corrupt each other's data, so the
> + * caller must take the exclusive i_rwsem and drain in-flight DIO. When
> + * zeroing is not required, shared lock is safe -- block allocation and
> + * unwritten conversion for middle blocks are protected by i_data_sem
> + * and inode_dio_begin().
> + */
> +static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  {
>  	struct ext4_map_blocks map;
>  	unsigned int blkbits = inode->i_blkbits;
> -	int err, blklen;
> +	unsigned long blockmask = inode->i_sb->s_blocksize - 1;
> +	bool head_partial, tail_partial;
> +	ext4_lblk_t head_lblk, tail_lblk;
> +	int err;
>  
>  	if (pos + len > i_size_read(inode))
> -		return false;
> +		return true;
>  
> -	map.m_lblk = pos >> blkbits;
> -	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
> -	blklen = map.m_len;
> +	head_partial = (pos & blockmask) != 0;
> +	tail_partial = ((pos + len) & blockmask) != 0;
> +	head_lblk = pos >> blkbits;
> +	tail_lblk = (pos + len - 1) >> blkbits;
> +
> +	/* Check the head partial block. */
> +	if (head_partial) {
> +		map.m_lblk = head_lblk;
> +		map.m_len = tail_lblk - head_lblk + 1;
> +		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
> +			return true;
> +		/* If this mapping already covers the tail block, we're done. */
> +		if (!tail_partial || map.m_lblk + err > tail_lblk)
> +			return false;
> +	}
>  
> -	err = ext4_map_blocks(NULL, inode, &map, 0);
> -	if (err != blklen)
> -		return false;
> -	/*
> -	 * 'err==len' means that all of the blocks have been preallocated,
> -	 * regardless of whether they have been initialized or not. We need to
> -	 * check m_flags to distinguish the unwritten extents.
> -	 */
> -	*unwritten = !(map.m_flags & EXT4_MAP_MAPPED);
> -	return true;
> +	/* Check the tail partial block. */
> +	if (tail_partial) {
> +		map.m_lblk = tail_lblk;
> +		map.m_len = 1;
> +		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
> +			return true;
> +	}
> +
> +	return false;
>  }
>  
>  static ssize_t ext4_generic_write_checks(struct kiocb *iocb,
> @@ -446,9 +475,10 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
>   *    i_data_sem serializes concurrent extent tree modifications.
>   *
>   * 4. Otherwise, the write is unaligned and non-extending. Shared lock is
> - *    only safe for pure written-extent overwrites. Unwritten extents or
> - *    holes require exclusive lock because concurrent partial block zeroing
> - *    in the DIO layer could corrupt data.
> + *    safe unless the DIO layer needs to perform partial block zeroing --
> + *    i.e. the head or tail partial block sits on a hole or unwritten
> + *    extent. In that case upgrade to the exclusive lock and drain
> + *    in-flight DIO to avoid races with concurrent partial block zeroing.
>   */
>  static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  				     bool *ilock_shared, bool *extend,
> @@ -459,7 +489,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	loff_t offset;
>  	size_t count;
>  	ssize_t ret;
> -	bool overwrite = true, unaligned_io, unwritten = false;
> +	bool needs_zeroing = false;
>  
>  restart:
>  	ret = ext4_generic_write_checks(iocb, from);
> @@ -469,21 +499,22 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	offset = iocb->ki_pos;
>  	count = ret;
>  
> -	unaligned_io = ext4_unaligned_io(inode, from, offset);
>  	*extend = ext4_extending_io(inode, offset, count);
>  
>  	/*
> -	 * For unaligned writes we need to know the extent state to determine
> -	 * whether shared lock is safe. For aligned writes we skip this check
> -	 * entirely since allocation under shared lock is safe.
> +	 * For unaligned writes, check whether partial block zeroing will be
> +	 * needed. If so, exclusive lock is required to serialize against
> +	 * concurrent DIO that could race with the zeroing.
> +	 *
> +	 * For aligned writes we skip this check entirely since allocation
> +	 * under shared lock is safe.
>  	 */
> -	if (unaligned_io)
> -		overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
> +	if (ext4_unaligned_io(inode, from, offset))
> +		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count);
>  
>  	/* Determine whether we need to upgrade to an exclusive lock. */
>  	if (*ilock_shared &&
> -	    ((!IS_NOSEC(inode) || *extend ||
> -	     (unaligned_io && (!overwrite || unwritten))))) {
> +	    (!IS_NOSEC(inode) || *extend || needs_zeroing)) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
>  			ret = -EAGAIN;
>  			goto out;
> @@ -497,16 +528,23 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	/*
>  	 * Now that locking is settled, determine dio flags and exclusivity
>  	 * requirements. We don't use DIO_OVERWRITE_ONLY because we enforce
> -	 * behavior already. The inode lock is already held exclusive if the
> -	 * write is unaligned non-overwrite or extending, so drain all
> -	 * outstanding dio and set the force wait dio flag.
> +	 * behavior already. When holding the exclusive lock for a write that
> +	 * needs partial block zeroing or is extending the file, we must wait
> +	 * for the I/O to complete synchronously:
> +	 *
> +	 *  - needs_zeroing: drain in-flight DIO whose end_io could race with
> +	 *    our partial block zeroing, and force synchronous completion so we
> +	 *    don't leave in-flight zeroing bios for the next writer to drain.
> +	 *
> +	 *  - extend: the caller must update i_disksize after I/O completion,
> +	 *    which requires the data to be on disk first.
>  	 */
> -	if (!*ilock_shared && (unaligned_io || *extend)) {
> +	if (!*ilock_shared && (needs_zeroing || *extend)) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
>  			ret = -EAGAIN;
>  			goto out;
>  		}
> -		if (unaligned_io && (!overwrite || unwritten))
> +		if (needs_zeroing)
>  			inode_dio_wait(inode);
>  		*dio_flags = IOMAP_DIO_FORCE_WAIT;
>  	}

