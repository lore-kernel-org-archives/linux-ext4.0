Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720838;
	b=wEC32BnXDWQlhD5Tcko7J+GaOrz/u9pt3dtHV2K3mNKyr9VsbKT0tG5TBQaWR4UEarAw
	 M69tIcjBcuieJ/9X/kcCPxtjkSiEokxbOExYhMlGh+r481ZnG2Es44uRxCS16DAwXszT+
	 DdDeUNxA3l2dA8BtOSdSa3ATgI6FGiam2P7HjTN8Yz7OJf9KNYJLq4Uy0rXoqI8I1PI5Q
	 1NtZEQGCsZgZGGo3zqNpZosSNY9mB0AbEw9BmkyiEuzVzWKqBVIhjhj0vjVq60XOqy3DI
	 By1Lb81q9W5Fnp/GB5vZL/FpEjhnBJgo8LHYMAVPfn0rBaDV0Qwvlr4AhIZD8gZ3rEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720838;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=yV6YjCxvJCg1OI6QtufgVN7s7ssucAAyU0b9lZMGRAE=;
	b=ecV552kX9MRctVoqmGaeddAVjU3WMuMPOtO7NXhD+lVdHcOkR1SlOz1bqYGAX4k1Dabb
	 2zSJW8wSs0UBFMuWjXK3Iv9P6RUTdfq32H78OaX9/KUG87io6nudPDQr0utaKEuNieHJV
	 Aa+hzx3hpMvu1fAHWs6aWfzhhtDh3sq3BJ67OC6FaaWFVyWahnpfkywFFl4Ewf/8hmOkU
	 9b+Ij2Mbn4gFGOpi3/Rd8CM68/x2y3jR54usG5d6qzT2qPTTwE4R0hngPd9DQh3IEtZVh
	 nT/tiJYtAyHcjbZJ4E7PQAXzjvuUf4K6u4Wi436ownjaCYUJ1uLB3mlwQE0cRQ1FYKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5B4606A31A;
	Fri, 23 Oct 2026 02:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B5B4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4j9mSP0yvZz1c0Wj;
	Fri, 23 Oct 2026 10:00:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 48E0A40598;
	Fri, 23 Oct 2026 10:00:26 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO+4v9pq6T_rBQ--.13281S3;
	Fri, 23 Oct 2026 10:00:26 +0800 (CST)
Message-ID: <4a0dc078-a3c0-4571-b23c-25a30d988d38@huaweicloud.com>
Date: Fri, 23 Oct 2026 10:00:23 +0800
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
Subject: Re: [PATCH] ext4: do not advance i_size on a buffered write that
 copied nothing
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, dave.hansen@linux.intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261009044656.1993196-1-hengyul@cs.unc.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261009044656.1993196-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXkO+4v9pq6T_rBQ--.13281S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AFyrAFyUtw1UCw1DXrW7XFb_yoW7urW7pr
	WYk3WrArW2vw1UKrs3X3WqqF10ka48JrW7GFyxKayfZFn8AFyIgF1FqFW5GFWUArZ7XF40
	qan5Gr95WF1qy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UAwIDUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/9/2026 12:46 PM, Hengyu Liang wrote:
> Commit 665575cff098 ("filemap: move prefaulting out of hot write path")
> made generic_perform_write() call ->write_begin() and ->write_end()
> before it finds out that the source buffer cannot be read.  In that
> case ->write_end() is called with copied == 0.
> 
> However, ext4_write_end(), ext4_journalled_write_end() and
> ext4_da_do_write_end() set i_size to pos + copied without checking
> copied.  As of now, a buffered write() past EOF that fails with EFAULT
> grows the file to the write offset, and the new size can reach the
> disk.
> 
> The issue can be reproduced on an ext4 mount with:
> 
>     char *p = mmap(NULL, 4096, PROT_NONE,
>                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>     int fd = open("/mnt/ext4/file", O_CREAT | O_TRUNC | O_RDWR, 0600);
>     pwrite(fd, p, 4096, 1024 * 1024);   /* fails with EFAULT */
>     fstat(fd, &st);
> 
> Before that commit, the result is st_size = 0.
> After it, the result is st_size = 1048576.
> 
> This patch will leave i_size alone when nothing was copied, as
> ext4_write_inline_data_end() already does.  The delalloc path does not
> trim after a short write, so in this case it also has to drop the
> folio and the delayed blocks that ->write_begin() set up past i_size.
> Otherwise that folio stays dirty past EOF and writeback never cleans
> it.
> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Hi Hengyu, thank you for the fix patch!

As Jan mentioned, this issue actually also exists on the iomap path,
although in my view the current approach can fix the problem on the
buffer_head path.

IIUC, 665575cff098 only increased the probability of the issue
occurring. Before it, copied could also end up being 0 in some
concurrent scenarios, because in block_write_end(), if the folio is not
uptodate, copied will be set to 0 as long as it is less than len.
Right?

> ---
>  fs/ext4/inode.c | 42 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..36e75c89b8c8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1452,15 +1452,18 @@ static int ext4_write_end(const struct kiocb *iocb,
>  	 * it's important to update i_size while still holding folio lock:
>  	 * page writeout could otherwise come in and zero beyond i_size.
>  	 *
> +	 * If nothing was copied (e.g. the source buffer was unreadable), do
> +	 * not move i_size up to pos.
> +	 *
>  	 * If FS_IOC_ENABLE_VERITY is running on this inode, then Merkle tree
>  	 * blocks are being written past EOF, so skip the i_size update.
>  	 */
> -	if (!verity)
> +	if (copied && !verity)
>  		i_size_changed = ext4_update_inode_size(inode, pos + copied);
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (old_size < pos && !verity)
> +	if (copied && old_size < pos && !verity)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
>  	/*
> @@ -1571,13 +1574,13 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  		if (!partial)
>  			folio_mark_uptodate(folio);
>  	}
> -	if (!verity)
> +	if (copied && !verity)
>  		size_changed = ext4_update_inode_size(inode, pos + copied);
>  	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (old_size < pos && !verity)
> +	if (copied && old_size < pos && !verity)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
>  	if (size_changed) {
> @@ -3210,6 +3213,24 @@ static int ext4_da_should_update_i_disksize(struct folio *folio,
>  	return 1;
>  }
>  
> +/*
> + * Delalloc counterpart of ext4_truncate_failed_write(): ->write_begin() only
> + * reserved delayed blocks, so drop the page cache and the delayed extents
> + * beyond i_size and leave the blocks that are allocated there alone.
> + */
> +static void ext4_da_truncate_failed_write(struct inode *inode)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, inode->i_size);
> +
> +	filemap_invalidate_lock(mapping);
> +	truncate_inode_pages(mapping, inode->i_size);
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +	filemap_invalidate_unlock(mapping);
> +}
> +
>  static int ext4_da_do_write_end(struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned copied,
>  			struct folio *folio)
> @@ -3247,12 +3268,12 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	 * checked, we need to update i_disksize here as certain
>  	 * ext4_writepages() paths not allocating blocks and update i_disksize.
>  	 */
> -	if (new_i_size > inode->i_size) {
> +	if (copied && new_i_size > inode->i_size) {
>  		unsigned long end;
>  
>  		i_size_write(inode, new_i_size);
>  		end = offset_in_folio(folio, new_i_size - 1);
> -		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
> +		if (ext4_da_should_update_i_disksize(folio, end)) {
>  			ext4_update_i_disksize(inode, new_i_size);
>  			disksize_changed = true;
>  		}
> @@ -3261,9 +3282,16 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (pos > old_size)
> +	if (copied && pos > old_size)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
> +	/*
> +	 * A write past i_size that copied nothing leaves i_size alone, so
> +	 * trim what ->write_begin() set up beyond it.
> +	 */
> +	if (!copied && pos > old_size)

I think it should be if (pos + len > old_size) here?

Thanks,
Yi.

> +		ext4_da_truncate_failed_write(inode);
> +
>  	if (!disksize_changed)
>  		return copied;
>  

