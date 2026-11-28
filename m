Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795852351;
	b=N16DH5+DKWUFbJDscyu/lzJMsjO+oSq2jXoX3b6k6snjB1DcBl1mA0rX9F4InlXddT1E
	 uIG0sA3i58e9F5s1v08A+QhhUzlzGvgHD3PgyFRyuIEVkL/qvNueyZdmDHg3JfzSODkqM
	 6PcoXyyr21KcRpXJKEnUrcgkuW9DgiR7y7MJDPht6DZYYUUFfbm6TuR/inoAfU2zoN//j
	 C0aIvizaI1u8LjKMY/iYOc3PPpg7ajU2QfViyUr7zXRVy+5EBI3J56n7uuGaSed8xuYlk
	 aKA6B/xOiBdK0LYriGUF5GWxycwdmoimL8wNW4vlLIXigVBFTvIZYuNbPc6/6NFFiBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795852351;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=LlYXIK9KvSIdLTwITGCpcBHpUXaCTHQut2E55jlNDpI=;
	b=r9otfcBJy9KCY0ZLZYDhoq32mnNsCyp/pmFqqPcp2+X6ab5EyJoJSGoRz+2FnWnHdTbT
	 UDY9lzNb78X7Sa57Zpdhscva585LGoYT6tA8CGq3ABHgNKCQV+AHrFlDqcJKNuVjiH+uH
	 XrR269bfYo+X5aJW7v0dDhhYjuIP7G4KpyuwkrmOHfglLiX8x6eF9qGbWmz7tHaDboxw9
	 r6btQWo+M5ezZZdD11R5xWQn04lUJcBNLzwob3PRyTWqRGpZzaZcYcf0zMNaAVTfn8bZV
	 ugV4cu6w9f0eLJtvGQoeJDMcD81FbIeJxT12efqEb8Sm9GKxuAN9LdJlXGNpFy63cRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD11606A31C
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 07:52:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DD11606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jc2Yk3vlMz1yTc
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 15:52:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2F3B74056D
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 15:52:19 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzewyiAprMbh2GA--.31203S3;
	Sat, 28 Nov 2026 15:52:18 +0800 (CST)
Message-ID: <1569bba9-ed77-4a3d-baae-8ea2b1356f55@huaweicloud.com>
Date: Sat, 28 Nov 2026 15:52:18 +0800
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
Subject: Re: [PATCH v3 2/3] ext4: submit mapped buffers after fatal mapping
 errors
To: Julian Sun <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, riteshh@linux.ibm.com
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
 <20261116064749.194146-1-sunjunchao@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261116064749.194146-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXzewyiAprMbh2GA--.31203S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXrWfZFWxAF4xXrWkWw1DGFg_yoWrXryUpF
	ZxCasxtFWDX3W7Crn7J3yvkry0gw4rXr4UuFy3J3WjvF9xGFnYgr47K3y5u3yIyr93Ja40
	qF40krnrury7AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 11/16/2026 2:47 PM, Julian Sun wrote:
> When the block size is smaller than the folio size, mapping an earlier
> extent in a folio can succeed before mapping a later extent fails.
> mpage_map_and_submit_extent() submits the mapped buffers after retryable
> mapping errors, but discards them along with the rest of the folio after
> fatal errors. Mapped buffers are also left unsubmitted if allocating an
> io_end_vec for a later extent fails.
> 
> Besides losing dirty data that could still be submitted, this can expose
> stale data with dioread_nolock: the mapped ranges remain in io_end's
> unwritten conversion list and can be converted without their data having
> been submitted.
> 
> A failure to map a later extent does not invalidate the mappings already
> established for earlier buffers. Submit those buffers after a fatal
> mapping error when the filesystem is not in an emergency state. Also
> submit them if allocating an io_end_vec for a later extent fails.
> 
> Buffers still needing mapping remain dirty for a later writeback attempt.
> Preserve their extent status entries and delayed allocation reservations,
> and invalidate only the unused folios after the partially submitted folio
> on fatal errors. If a later attempt encounters a fatal mapping error
> before making progress, the existing invalidation path can discard the
> folio.
> 
> Suggested-by: Zhang Yi <yi.zhang@huaweicloud.com>
> Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/inode.c |   43 ++++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6dad9eea7824..ff33ae870b35 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2600,6 +2600,7 @@
>  	int progress = 0;
>  	ext4_io_end_t *io_end = mpd->io_submit.io_end;
>  	struct ext4_io_end_vec *io_end_vec;
> +	bool fatal = false;
>  
>  	io_end_vec = ext4_alloc_io_end_vec(io_end);
>  	if (IS_ERR(io_end_vec))
> @@ -2610,8 +2611,10 @@
>  		if (err < 0) {
>  			struct super_block *sb = inode->i_sb;
>  
> -			if (ext4_emergency_state(sb))
> -				goto invalidate_dirty_pages;
> +			if (ext4_emergency_state(sb)) {
> +				*give_up_on_write = true;
> +				return err;
> +			}
>  			/*
>  			 * Let the uper layers retry transient errors.
>  			 * In the case of ENOSPC, if ext4_count_free_blocks()
> @@ -2619,18 +2622,7 @@
>  			 */
>  			if ((err == -ENOMEM) || (err == -EAGAIN) ||
>  			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
> -				/*
> -				 * We may have already allocated extents for
> -				 * some bhs inside the folio, issue the
> -				 * corresponding data to prevent stale data.
> -				 */
> -				if (progress) {
> -					if (mpage_submit_partial_folio(mpd,
> -								       release_start))
> -						goto invalidate_dirty_pages;
> -					goto update_disksize;
> -				}
> -				return err;
> +				break;
>  			}
>  			ext4_msg(sb, KERN_CRIT,
>  				 "Delayed block allocation failed for "
> @@ -2644,9 +2636,8 @@
>  				 "be lost\n");
>  			if (err == -ENOSPC)
>  				ext4_print_free_blocks(inode);
> -		invalidate_dirty_pages:
> -			*give_up_on_write = true;
> -			return err;
> +			fatal = true;
> +			break;
>  		}
>  		progress = 1;
>  		/*
> @@ -2655,10 +2646,24 @@
>  		 */
>  		err = mpage_map_and_submit_buffers(mpd);
>  		if (err < 0)
> -			goto update_disksize;
> +			break;
>  	} while (map->m_len);
>  
> -update_disksize:
> +	if (err < 0) {
> +		/*
> +		 * We may have already allocated extents for some bhs inside
> +		 * the folio, issue the corresponding data to prevent stale
> +		 * data.
> +		 */
> +		if (progress && mpage_submit_partial_folio(mpd, release_start))
> +			fatal = true;
> +
> +		if (fatal)
> +			*give_up_on_write = true;
> +		if (!progress)
> +			return err;
> +	}
> +
>  	/*
>  	 * Update on-disk size after IO is submitted.  Races with
>  	 * truncate are avoided by checking i_size under i_data_sem.

