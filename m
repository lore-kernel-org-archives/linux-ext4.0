Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95D254781
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 03:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786074855; cv=none; b=fEy9D7U5hQp6YyPDScmdQ761SsFBWT7RDjrA/GyscwvLCOgwJJzjKuo6S1z/iSWbCOp8stZotyvFBKO/512vqGTf7I1icsXQlIf6scENCqEhNx+umAgKZM5Rlo2hSbxnwhnaerMNukg65y1kBPkWWvZZyZ1RbXAhz+ZW1xmL0vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786074855; c=relaxed/simple;
	bh=HmiH2bYVagJvaJOsdGdJ7EixR6R4c9AC7qe2mZFHgvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sylVTd+fm6MKUKbBKowGe9ohhMtkDvcZolDdv/RJfakSgPcu+Chj9MBucaIZNXrf36nsuDvBSTttMbep/S97cR0QHpgEss0C95YJKbXo3Lhxq3Z9nsBYtykFoGhpfyqVzeEmQGE8/m2iYCY71wFk7nlAwGZd1oVEvqIyohXYks8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hGVCz2csJzYQtns
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 11:35:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3356F40579
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 11:36:39 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCX0kHFUnVqfEqdBQ--.7255S3;
	Fri, 07 Aug 2026 11:36:39 +0800 (CST)
Message-ID: <b9567837-045d-4236-8b70-1590018b1c63@huaweicloud.com>
Date: Fri, 7 Aug 2026 11:36:37 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ext4: Fix transaction overflow during writeback
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-5-jack@suse.cz>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260805153605.166545-5-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCX0kHFUnVqfEqdBQ--.7255S3
X-Coremail-Antispam: 1UD129KBjvJXoW7urWrGrWxKw1kJFy7XFy3XFb_yoW8ur4xpa
	n3CF18Wr15u34DuayIk3WUtF1xWayxGr4UWF18Kw45WFZxWrn2gr1DKw1FkFy8Kr4xXrWY
	vF4UArykGwnrAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/5/2026 11:35 PM, Jan Kara wrote:
> Commit 95ad8ee45cdb ("ext4: correct the reserved credits for extent
> conversion") was correct to note that we need to reserve enough credits
> for all extents possibly underlying a large folio. However it was too
> eager to reduce the number of reserved credits. Extent conversion may
> not only need to touch several leaf extent blocks, it may also need to
> split extents - for example a single large unwritten extent may need to
> be split into many small written ones in case of sparse folio dirtying.
> This can thus result not only in extent leaf modifications but also in a
> need to allocate new extent tree nodes. As a result the reserved
> transaction credits were not sufficient in some corner cases. Use
> ext4_meta_trans_blocks() for correct upper bound credit estimate.
> 
> Fixes: 95ad8ee45cdb ("ext4: correct the reserved credits for extent conversion")
> Signed-off-by: Jan Kara <jack@suse.cz>

Indeed, I overlooked that the newly allocated index blocks will modify
bitmaps and group descriptor blocks. Given that the folio length is
capped at 2048 filesystem blocks, calling ext4_meta_trans_blocks(bpf, 0)
shouldn't result in an overly large credits calculation. So,

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f324a54f1dae..ddce319e53c5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2852,10 +2852,10 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
>  	if (ext4_should_dioread_nolock(inode)) {
>  		int bpf = ext4_journal_blocks_per_folio(inode);
>  		/*
> -		 * We may need to convert up to one extent per block in
> -		 * the folio and we may dirty the inode.
> +		 * We may need to convert up to one extent per block in the
> +		 * folio.
>  		 */
> -		rsv_blocks = 1 + ext4_ext_index_trans_blocks(inode, bpf);
> +		rsv_blocks = ext4_meta_trans_blocks(inode, bpf, bpf, 0);
>  	}
>  
>  	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)

