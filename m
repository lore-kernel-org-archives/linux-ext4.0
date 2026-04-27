Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52D43B7763;
	Mon, 27 Apr 2026 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777289031; cv=none; b=fib4xNRYtfwgoud5quFVCL8U0CQ9nErUeXIfAj48G058ELMtcDuWyMxnZfW04gFdIUwfO6MJ4azzIPLoDwqXeBHf22l55eM/D/eTAqdZa/U9jj9UnCWqBRs4aR49ImDi/7GUBZlgD5aKgkjWZB4R9b1GAWV2gGxnZuLPUHorq4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777289031; c=relaxed/simple;
	bh=WO5Jr9BznyWMFDn+xDVYRXzM+mUsKH3DU+dM0XCL7kQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mT9i2zIuaaz8drC5BWKM38YXfIMNtg/ut8MJBiRcB9n+ixVfW8g6m4mIypTrL6hvxcoowT5t7xkqz0397K0w3UQUF7Tq+klQKuXDJgJ/Gw1tZeN0bc0yJ10x8uinzPRhJyYa5+nQ7R5un0SG3G7fGIS2IoS00GaUetCpoye8CpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kLEKjswr; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kLEKjswr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777289024; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UJn4lNe3N+gv4YNs9I/2Ctj5QiiaM6KzePs2I31E4Ec=;
	b=kLEKjswrqnh+lOQvV315VibgGf1cOH52GBMzDDwUKeZPH9o66vuBv0s+LNvVDv5SHYKdRyF57xrM82+cdXSUyOWnMM3aFQgioWGj8xeC7z/mTYnWX1lhAW7uM+/W4WCgNlLdjf472/DziQhP1f+/4UoFEH1hRIs3azNhok+YvtA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X1mqfjD_1777289022;
Received: from 30.221.131.19(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X1mqfjD_1777289022 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Apr 2026 19:23:43 +0800
Message-ID: <3ea5dc18-0ae0-49d3-b89c-f6f9a7c11ab8@linux.alibaba.com>
Date: Mon, 27 Apr 2026 19:23:42 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix LOGFLUSH shutdown ordering to allow
 ordered-mode data writeback
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2026/4/24 18:42, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> In EXT4_GOING_FLAGS_LOGFLUSH mode, the EXT4_FLAGS_SHUTDOWN flag was set
> before calling ext4_force_commit().  This caused ordered-mode data
> writeback (triggered by journal commit) to fail with -EIO, since
> ext4_do_writepages() checks for the shutdown flag.  The journal would
> then be aborted prematurely before the commit could succeed.
>
> Fix this by calling ext4_force_commit() first, then setting the
> shutdown flag, so that pending data can be written back correctly.
>
> Note that moving ext4_force_commit() before setting the shutdown flag
> creates a small window in which new writes may occur and generate new
> journal transactions.  When the journal is subsequently aborted, the
> new transactions will not be able to write to disk.  This is intentional
> because LOGFLUSH's semantics are to flush pre-existing journal entries
> before shutdown, not to guarantee atomicity for writes that race with
> the ioctl.
>
> Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
> This fix addresses my new generic/970 test, which fails during the file
> size verification after shutdown and remount.
>
>  https://lore.kernel.org/fstests/20260424092228.1396658-1-yi.zhang@huaweicloud.com/
>
>  fs/ext4/ioctl.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 1d0c3d4bdf47..110e3fb194ec 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -830,11 +830,17 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
>  		bdev_thaw(sb->s_bdev);
>  		break;
>  	case EXT4_GOING_FLAGS_LOGFLUSH:
> +		/*
> +		 * Call ext4_force_commit() before setting EXT4_FLAGS_SHUTDOWN.
> +		 * This is because in data=ordered mode, journal commit
> +		 * triggers data writeback which fails if shutdown is already
> +		 * set, causing the journal to be aborted prematurely before
> +		 * the commit succeeds.
> +		 */
> +		(void) ext4_force_commit(sb);
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
> -		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
> -			(void) ext4_force_commit(sb);
> +		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
>  			jbd2_journal_abort(sbi->s_journal, -ESHUTDOWN);
> -		}
>  		break;
>  	case EXT4_GOING_FLAGS_NOLOGFLUSH:
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
