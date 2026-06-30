Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BA41B142D
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 01:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781725; cv=none; b=pwEINRDTEb05rKdZqlnY9qvVts/qcW53vAhC3fvLSDtbaCDMuPaiBgQn/pCIsR4lc1bDaPGpm6VC13HosF4dLPBe2+tK1j/RfF/lgz59igqQbHhDpihgemBwlCF5fSabdXh5ZL6isAWlnRKLAYW77UY0E8ukcSyd6X/jcxK8MSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781725; c=relaxed/simple;
	bh=gCmAUHHJ5Er2JEfX5clqlgq1jKzw9rQjdfV1LSRjnV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5nV1Woxei1JRB04OINP+nj+TV3aWoMk4okyuTidjTw8pWPryaPMSqE4c/A4dOaUhKS0PxxMnIhDCBrwteUbuE9nn9bxKcsLGA0wsELYA8u8ZcnUVOmAPMTP+mLtTj5gpCDQdiN+Pzb7qdTSWAQ3+oZZ3ICsjJjOmL9zCA1PUFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gq4kh1Gq7zYQtjb
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 09:07:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 1BCCE4058C
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 09:08:32 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgDnVvQOF0Nq6Xk6AQ--.11311S3;
	Tue, 30 Jun 2026 09:08:31 +0800 (CST)
Message-ID: <202f8c56-db84-490b-8704-9f32b9d731a5@huaweicloud.com>
Date: Tue, 30 Jun 2026 09:08:29 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] ext4: fix NOWAIT semantic violation in DAX
 extending writes
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
 <20260629113827.4074335-7-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260629113827.4074335-7-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnVvQOF0Nq6Xk6AQ--.11311S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw1fWF4ftF48Ww1UAF18Zrb_yoW8Zr1fpF
	y3CF1Dur10v3s29w47WrWUZFyUWw45J347WF9xCF1jqFy7Xw1rGF12yFWxKa1qyrW8C3W8
	XF1q9wsruw4qy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/29/2026 7:38 PM, Baokun Li wrote:
> When a DAX write starts before EOF but extends past i_disksize,
> ext4_write_checks() skips the IOCB_NOWAIT check because
> iocb->ki_pos <= old_size. However, ext4_dax_write_iter() later calls
> ext4_journal_start() to prepare for inode extension, which can sleep
> waiting for journal space or transaction commit.
> 
> This violates NOWAIT semantics and can stall asynchronous I/O frameworks
> like io_uring that rely on non-blocking behavior.
> 
> Fix this by checking IOCB_NOWAIT before calling ext4_journal_start()
> in the extending write path. If NOWAIT is set and extension is needed,
> return -EAGAIN so the caller can retry in blocking context.
> 
> Example scenario:
>   - File: i_size = 1000, i_disksize = 1000
>   - DAX NOWAIT write: offset = 500, count = 2000
>   - ext4_write_checks(): ki_pos (500) <= old_size (1000), skip NOWAIT check
>   - ext4_dax_write_iter(): offset + count (2500) > i_disksize (1000)
>   - ext4_journal_start() → may sleep → violates NOWAIT
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260618125735.4156639-1-libaokun@linux.alibaba.com?part=5
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 0e9448a110dc..9a16071b719d 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -725,6 +725,11 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	count = iov_iter_count(from);
>  
>  	if (offset + count > EXT4_I(inode)->i_disksize) {
> +		if (iocb->ki_flags & IOCB_NOWAIT) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +
>  		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
>  		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);

