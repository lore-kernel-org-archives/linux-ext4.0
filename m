Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2AA317153
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 03:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782184616; cv=none; b=XOJtQNaSlmsBKfhKT9xN9uZuJ0kG1332o/diYBp/ZhxuyWTobBLXRC+HNCN6jP4j7qTb4uuzPFpRXYuwxJwgsuzpRqxO3Af1+y06l13hrr4n9OemPukMvGFFx5PC5fK+TcBZ9fDxOVgGsUFFqrAtQeDSXxShlC6rBKlIHhg+m10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782184616; c=relaxed/simple;
	bh=14crBbb2QRLaNlgqVx6iY2Oe8G589VGx0xJz/VMX7f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=meF/EsvI1ktpa5dw02Yyt0g1yMbUV6SRu3HKNxEC6e2i6mRSoOVPQByk0zkheVa9GGbvU1d3SMfAKt/XrkVyJ8jMN5dGdw4Qo5LBr0EwGHfB+SkvkvRjm1c4vimdboZ6BmAQA8UVubHOij2tp/UzYwpDVa4WbaI/67UY3ZVbnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gkqw80yHqzYQtyH
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:16:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 44325406B9
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:16:48 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgCHij+f+jlq4OkfCw--.58233S3;
	Tue, 23 Jun 2026 11:16:48 +0800 (CST)
Message-ID: <63f68d80-2aa3-4f91-a770-b9481dba9719@huaweicloud.com>
Date: Tue, 23 Jun 2026 11:16:47 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] ext4: use kiocb_modified instead of file_modified
 in DIO/DAX write path
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-6-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260618125735.4156639-6-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCHij+f+jlq4OkfCw--.58233S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw43CrW5WrW8GF4rJF17Awb_yoW8ZF15pF
	sxKF1Yqr1UtrnruFyrJFyUuFyYgws8tr47WrZ3W3WUJFySyr1FgF1Iy3W09a1rtrZ5Zr1j
	vF4I9r9rZa1jyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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

On 6/18/2026 8:57 PM, Baokun Li wrote:
> file_modified() passes flags=0 which drops IOCB_NOWAIT, causing
> file_update_time() to sleep in ext4_journal_start() via
> ext4_dirty_inode() even in non-blocking contexts.
> 
> kiocb_modified(iocb) propagates iocb->ki_flags so that
> generic_update_time() correctly returns -EAGAIN when IOCB_NOWAIT
> is set and ->dirty_inode could block, matching the behavior
> already adopted by XFS, FUSE, and ext2.
> 
> Affected paths:
> - ext4_dio_write_checks(): DIO NOWAIT write
> - ext4_write_checks(): shared by buffered (rejects NOWAIT upfront)
>   and DAX write (supports NOWAIT)
> 
> ext4_fallocate() in extents.c is not affected as it has no kiocb.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Ha, this looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/file.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2681f148e7b8..5ffc1afd8050 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -307,7 +307,7 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	if (count <= 0)
>  		return count;
>  
> -	ret = file_modified(iocb->ki_filp);
> +	ret = kiocb_modified(iocb);
>  	if (ret)
>  		return ret;
>  
> @@ -465,7 +465,7 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
>   *
>   * The decision is layered, evaluated in this order:
>   *
> - * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
> + * 1. If kiocb_modified() needs to update security info (!IS_NOSEC), upgrade
>   *    to the exclusive lock -- the security update itself requires it,
>   *    regardless of whether the write extends the file or is aligned.
>   *
> @@ -555,7 +555,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  		*dio_flags = IOMAP_DIO_FORCE_WAIT;
>  	}
>  
> -	ret = file_modified(file);
> +	ret = kiocb_modified(iocb);
>  	if (ret < 0)
>  		goto out;
>  

