Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055D6165F16
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 03:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781493919; cv=none; b=HnKBDcOZv+4vVGfiPk2YT2P2bUqDm3s1MNgDLMd+0r9g1mOz3QFsPmXLAyn4HZMgX3lBOHrRMfKvsiP+gP/MhB3Jlsy8f2qXo8cjdIg5Mw4nlUIusdBNPlyDbpq0veYe/NwbyQWAYtgEpONKsfnLtUbgGXz4iGhuMQ+E/uwq8x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781493919; c=relaxed/simple;
	bh=gi4Ld0z5ge1OaoMQ8j2pBKsbz5zwCB1bivNZl/w+y0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oG+jKAdbnsaB/ci1eneC++jg8/GyqLCYOfFGlKxwUs9NFQKhvXpW12Dh49JqtcVe0dXffGfP3LI842XmMSifr2y2csP2WN9cDyqr2uAFucfvc5Xy2hbwpmhveBOieDplyjeoDtcE0TOeqnojLhwcr4L9yUYie8BP3+ykEUcCVeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gdwTg1zygzYQtwW
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 11:24:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B87F04056F
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 11:25:05 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgCHij+CcC9qhRteBw--.40950S3;
	Mon, 15 Jun 2026 11:25:05 +0800 (CST)
Message-ID: <664cf918-035d-4ce5-84a3-7080c7ae2b9e@huaweicloud.com>
Date: Mon, 15 Jun 2026 11:24:50 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ext4: skip overwrite check for aligned non-extending
 DIO writes
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-2-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260611163441.2431805-2-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCHij+CcC9qhRteBw--.40950S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy7CrW3ZrWUuFW5ZF13Arb_yoW3Aryrpr
	y3KFnxJryDK348u39ay3W8WF1rWw4kJ3yxJF43Gw1rZFyUuryIgFWIqFyFqa48CrZ7Xw12
	qrWqv3sruas09rJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/12/2026 12:34 AM, Baokun Li wrote:
> Currently, ext4_dio_write_checks() calls ext4_overwrite_io() to
> determine if a write is a pure overwrite, and upgrades to exclusive
> i_rwsem if not. However, ext4_overwrite_io() uses a single
> ext4_map_blocks() call which only returns the first contiguous extent of
> the same type. A write spanning multiple pre-allocated extents (e.g.
> written + unwritten, or two physically discontiguous written extents)
> produces a false negative, forcing an unnecessary exclusive lock upgrade.
> 
> After commit 5d87c7fca2c1 ("ext4: avoid starting handle when dio
> writing an unwritten extent") and commit 012924f0eeef ("ext4: remove
> useless ext4_iomap_overwrite_ops"), ext4_iomap_begin()'s fast path
> accepts both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN without starting a
> journal transaction. The iomap iteration naturally handles multi-extent
> ranges: each call returns the mapping for the current segment, and
> unwritten-to-written conversion is deferred to ext4_dio_write_end_io().
> This means the common case of mixed written/unwritten extents never
> reaches ext4_iomap_alloc() at all.
> 
> Even for the less common case where the range contains a hole and
> ext4_iomap_alloc() is needed, exclusive i_rwsem is still unnecessary for
> aligned non-extending writes:
> 
>  - truncate/punch_hole are kept out: they require exclusive i_rwsem
>    (blocked by our shared lock during allocation), and inode_dio_begin()
>    keeps their inode_dio_wait() blocked until in-flight bios complete.
>  - i_data_sem write-lock inside ext4_map_blocks() serializes concurrent
>    extent tree modifications (parallel writers to the same hole).
>  - The journal handle is per-thread and does not require i_rwsem
>    exclusion.
>  - i_disksize and orphan list are not involved in non-extending writes.
> 
> Skip the ext4_overwrite_io() check entirely for aligned writes by
> initializing overwrite to true and only calling ext4_overwrite_io() for
> unaligned writes. Unaligned writes still need the extent state check
> because concurrent partial block zeroing in the DIO layer requires
> exclusive serialization unless the range is a pure written-extent
> overwrite.
> 
> Performance:
> 
> Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
> Filesystem: ext4 default mkfs
> 
> Aligned 8K DIO writes spanning written+unwritten extent boundaries.
> Each thread writes its own 1G region sequentially; the file is rebuilt
> between runs so every block is written exactly once. Metric: IOPS.
> 
>   JOBS      Before        After    speedup
>   ----    --------    ---------    -------
>      1      42,322       43,329      1.02x
>      2      68,516       70,677      1.03x
>      4      62,489       97,072      1.55x
>      8      58,701      110,819      1.89x
>     16      58,569      116,392      1.99x
>     32      60,860      117,244      1.93x
> 
> Wall time at JOBS=32: 69.2s (Before) -> 35.4s (After), 1.96x faster.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Ha, this is a good idea and a nice speed-up!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/file.c | 52 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index eb1a323962b1..6f3886465ce3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -428,16 +428,27 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
>   * condition requires an exclusive inode lock. If yes, then we restart the
>   * whole operation by releasing the shared lock and acquiring exclusive lock.
>   *
> - * - For unaligned_io we never take shared lock as it may cause data corruption
> - *   when two unaligned IO tries to modify the same block e.g. while zeroing.
> + * The decision is layered, evaluated in this order:
>   *
> - * - For extending writes case we don't take the shared lock, since it requires
> - *   updating inode i_disksize and/or orphan handling with exclusive lock.
> + * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
> + *    to the exclusive lock -- the security update itself requires it,
> + *    regardless of whether the write extends the file or is aligned.
>   *
> - * - shared locking will only be true mostly with overwrites, including
> - *   initialized blocks and unwritten blocks.
> + * 2. If the write extends i_size or i_disksize, upgrade to the exclusive
> + *    lock to safely update i_disksize and the orphan list, regardless of
> + *    alignment.
>   *
> - * - Otherwise we will switch to exclusive i_rwsem lock.
> + * 3. Otherwise, for aligned non-extending writes, shared lock is always
> + *    sufficient regardless of extent state (written, unwritten, or hole).
> + *    truncate/punch_hole cannot run while we hold the shared i_rwsem
> + *    (they need it exclusively); after we release it, inode_dio_begin()
> + *    keeps their inode_dio_wait() blocked until in-flight bios complete.
> + *    i_data_sem serializes concurrent extent tree modifications.
> + *
> + * 4. Otherwise, the write is unaligned and non-extending. Shared lock is
> + *    only safe for pure written-extent overwrites. Unwritten extents or
> + *    holes require exclusive lock because concurrent partial block zeroing
> + *    in the DIO layer could corrupt data.
>   */
>  static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  				     bool *ilock_shared, bool *extend,
> @@ -448,7 +459,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	loff_t offset;
>  	size_t count;
>  	ssize_t ret;
> -	bool overwrite, unaligned_io, unwritten;
> +	bool overwrite = true, unaligned_io, unwritten = false;
>  
>  restart:
>  	ret = ext4_generic_write_checks(iocb, from);
> @@ -460,22 +471,19 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  
>  	unaligned_io = ext4_unaligned_io(inode, from, offset);
>  	*extend = ext4_extending_io(inode, offset, count);
> -	overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
>  
>  	/*
> -	 * Determine whether we need to upgrade to an exclusive lock. This is
> -	 * required to change security info in file_modified(), for extending
> -	 * I/O, any form of non-overwrite I/O, and unaligned I/O to unwritten
> -	 * extents (as partial block zeroing may be required).
> -	 *
> -	 * Note that unaligned writes are allowed under shared lock so long as
> -	 * they are pure overwrites. Otherwise, concurrent unaligned writes risk
> -	 * data corruption due to partial block zeroing in the dio layer, and so
> -	 * the I/O must occur exclusively.
> +	 * For unaligned writes we need to know the extent state to determine
> +	 * whether shared lock is safe. For aligned writes we skip this check
> +	 * entirely since allocation under shared lock is safe.
>  	 */
> +	if (unaligned_io)
> +		overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
> +
> +	/* Determine whether we need to upgrade to an exclusive lock. */
>  	if (*ilock_shared &&
> -	    ((!IS_NOSEC(inode) || *extend || !overwrite ||
> -	     (unaligned_io && unwritten)))) {
> +	    ((!IS_NOSEC(inode) || *extend ||
> +	     (unaligned_io && (!overwrite || unwritten))))) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
>  			ret = -EAGAIN;
>  			goto out;
> @@ -490,8 +498,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	 * Now that locking is settled, determine dio flags and exclusivity
>  	 * requirements. We don't use DIO_OVERWRITE_ONLY because we enforce
>  	 * behavior already. The inode lock is already held exclusive if the
> -	 * write is non-overwrite or extending, so drain all outstanding dio and
> -	 * set the force wait dio flag.
> +	 * write is unaligned non-overwrite or extending, so drain all
> +	 * outstanding dio and set the force wait dio flag.
>  	 */
>  	if (!*ilock_shared && (unaligned_io || *extend)) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {

