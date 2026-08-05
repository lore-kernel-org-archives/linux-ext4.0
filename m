Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3B3C9EEF;
	Wed,  5 Aug 2026 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785905542; cv=none; b=s0/uUKE20JCtAqyPu0Nhs5ozOdh0/DAcjLnSQ4ubtvYLJJuaucxmiR2gtaF4IJED8BhhLW71YdzRbWITC1N1lkqO9m8nuoqLGv8y7pE0L1IjRfG/b9225nFdFZy9OUCo0g6CRAucP6swj3HCT4Uov/JHObkeRbigtxO1c1bUZ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785905542; c=relaxed/simple;
	bh=b4jS/PSKofjywi4GK8miSXk7RD3FvHhZighQMAil6Kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEN3l5b6OXsBpAmPbqwL7KrmAqD7T1F621BEWkocR96+v1nB0RX04yodu+r/6aQfup2fS8vE/9qIZlwN2pkWR5OBvQsy3G3lBws/6NJshJBjhsSq7IH2TR4q7ZflQCuvYcOdzgDJKvFqEwotuTqxC/uy9gLTrAPa4NGGJLLDXm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hFJ146B6wzKHMcm;
	Wed,  5 Aug 2026 12:52:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 90AEB4058D;
	Wed,  5 Aug 2026 12:52:14 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgDn1kV7wXJqFbyuBA--.3256S3;
	Wed, 05 Aug 2026 12:52:14 +0800 (CST)
Message-ID: <ff2f92ab-6c98-42f2-be0b-0c807bc9438e@huaweicloud.com>
Date: Wed, 5 Aug 2026 12:52:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write
 fails
To: Chao Shi <coshi036@gmail.com>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev,
 linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <cover.1785621505.git.coshi036@gmail.com>
 <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgDn1kV7wXJqFbyuBA--.3256S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cry3Gr18CFy3GF1fKFWUCFg_yoW5JrWrpr
	Z8KayDKrWqgF4UArnFkF4fJ3W0yFykuF43CFWru347Zr98Gr97WFy2qw1YgFWUAr9agw4Y
	qr4FgryrCF4UXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	4xRDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/2/2026 6:01 AM, Chao Shi wrote:
> A buffer whose write failed still holds exactly the data the filesystem
> asked to be written.  It is the disk that is out of date, not the buffer.
> Clearing BH_Uptodate says the opposite, and callers act on it:
> 
>  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
>    filesystem that dirties the buffer again after a failed write - which is
>    the normal way to retry - trips it.  That is the warning this series
>    started from.
> 
>  - a buffer that is not up to date gets re-read from disk, which replaces
>    the data the filesystem was trying to write with the stale on-disk copy,
>    silently.
> 
>  - the window between the write completing and the buffer being marked not
>    up to date is visible to anyone holding the folio lock, so the state is
>    not even self consistent while it lasts.
> 
> BH_Write_EIO already records the failure, and by now every place in the
> tree that needs to know about it tests that flag instead: the two core
> helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
> omfs, converted one filesystem at a time in the preceding patches.  The
> private completion handlers in jbd2 and ext4 fast commit were converted
> along with their waiters.  Nothing is left that reads BH_Uptodate to find
> out whether a write failed, so the clears can go.
> 
> Found by FuzzNvme.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>

It looks like after this series, we may need to revisit the necessity of
ext4_buffer_uptodate() in the ext4 filesystem. IIRC, it was originally
introduced as a compromise to address this issue. Now that we no longer
clear the buffer uptodate flag after a failed IO write, this flag will
still remain valid when getting/reading bh. Therefore, the necessity of
ext4_buffer_uptodate() is worth reconsidering.

Thanks,
Yi.

> ---
>  fs/buffer.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ac978d9090c2..0002f0736398 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
>  	} else {
>  		buffer_io_error(bh, ", lost sync page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  	unlock_buffer(bh);
>  }
> @@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
>  	} else {
>  		buffer_io_error(bh, ", lost async page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  
>  	first = folio_buffers(folio);

