Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278AB303CA0
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 06:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773296777; cv=none; b=BSyBUyV+4eUanaIRv+QY1FveDxTcMeFyES+XVBPC+R1be52irirhRMoBMkRr0wLNIGuUDWKEbFE5+6C73pUm6GcILS53rU6HCoUY2AwMO01QJQgheLfa0Qk8EtV0q3yTpQAD6eb6/2kniRGCPaQ31t+kYu9IeOnhgkV7Nrt+a0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773296777; c=relaxed/simple;
	bh=Hg+t9ImrjYRJND/bThtqbmx3VAXf4guI0GS/U9ji948=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q9HeKfsXmlDqNXjbAB8AZY5puc5Ua7CyXMoLsBfDFW6fR0Zu7Au3Rgfw8TVwRuUujhQllxsmelsDvmOJxPGASjLI2mH/mfSCX70AzPxlbHAAfJqJiQzUR252KJ/dwtTYah/M98mzSJLQZZa6GhsnOwSMR6zNQrq/GP3kHnqI6jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DjDmmUHz; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DjDmmUHz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773296770; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zpL0fy+8+07I4Grw7EBc35F7vHYAt40E9I1RMA9Txp4=;
	b=DjDmmUHz3HkxR3ka/87M+PhEXlg62tpX6Exk0zF9IuvB+V0+fT8rbjEwvL0LPDf8jFUMWu0QAY3sfmee0nC2e7P7GC58lvLz9c10LGp4WVsbxL+CbUTInRrRzseYnKy8DaFh+lSvHtlK4eQ6M+Mu3l4zki9WlWPNT4KP2hIrgoU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X-nRygG_1773296769;
Received: from 30.221.147.203(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-nRygG_1773296769 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Mar 2026 14:26:09 +0800
Message-ID: <8382fe78-5b3f-4c1a-96eb-62494835f693@linux.alibaba.com>
Date: Thu, 12 Mar 2026 14:26:08 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH e2fsprogs] lib/quota: fix checksum mismatch on
 uninitialized PRJQUOTA inode
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
 libaokun@linux.alibaba.com
References: <20251210081558.2714709-1-libaokun@huaweicloud.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20251210081558.2714709-1-libaokun@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A gentle ping...

On 12/10/25 4:15 PM, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
>
> In quota_inode_init_new(), we attempt to read and truncate an existing
> quota inode before proceeding with its initialization.
>
> This read operation verifies the inode's checksum. This works fine for
> USRQUOTA and GRPQUOTA inodes because write_reserved_inodes() is always
> called during ext4 image creation to set appropriate checksums for these
> reserved inodes.
>
> However, the PRJQUOTA inode is not reserved, and its corresponding inode
> table block may not have been zeroed, potentially containing stale data.
> Consequently, reading this inode can fail due to a checksum mismatch.
>
> This can be reproduced by running the following sequence:
>
>   dd if=/dev/random of=$DISK bs=1M count=128
>   mkfs.ext4 -F -q -b 1024 $DISK 5G
>   tune2fs -O quota,project $DISK
>
> Which results in the following error output:
>
>  tune2fs 1.47.3 (8-Jul-2025)
>  [ERROR] quotaio.c:279:quota_inode_init_new: ex2fs_read_inode failed
>  [ERROR] quotaio.c:341:quota_file_create: init_new_quota_inode failed
>  tune2fs: Inode checksum does not match inode while writing quota file (2)
>
> While running `kvm-xfstests -c ext4/1k -C 1 generic/383`, the test itself
> does not fail, but checksum verification failures are reported even
> without fault injection, which led to discovering this issue.
>
> To fix this, we stop attempting to read the quota inode that is about
> to be initialized inside quota_inode_init_new(). Instead, the logic
> to attempt truncation of an existing quota inode is moved to be handled
> inside quota_file_create().
>
> Fixes: 080e09b4 ("Add project quota support")
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  lib/support/quotaio.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
> index f5f2c7f7..827df85b 100644
> --- a/lib/support/quotaio.c
> +++ b/lib/support/quotaio.c
> @@ -274,18 +274,6 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
>  	errcode_t err = 0;
>  	time_t now;
>  
> -	err = ext2fs_read_inode(fs, ino, &inode);
> -	if (err) {
> -		log_err("ex2fs_read_inode failed");
> -		return err;
> -	}
> -
> -	if (EXT2_I_SIZE(&inode)) {
> -		err = quota_inode_truncate(fs, ino);
> -		if (err)
> -			return err;
> -	}
> -
>  	memset(&inode, 0, sizeof(struct ext2_inode));
>  	ext2fs_iblk_set(fs, &inode, 0);
>  	now = fs->now ? fs->now : time(0);
> @@ -319,6 +307,10 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
>  	if (fmt == -1)
>  		fmt = QFMT_VFS_V1;
>  
> +	err = ext2fs_read_bitmaps(fs);
> +	if (err)
> +		goto out_err;
> +
>  	h->qh_qf.fs = fs;
>  	qf_inum = quota_type2inum(qtype, fs->super);
>  	if (qf_inum == 0 && qtype == PRJQUOTA) {
> @@ -330,15 +322,19 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
>  		ext2fs_mark_ib_dirty(fs);
>  	} else if (qf_inum == 0) {
>  		return EXT2_ET_BAD_INODE_NUM;
> +	} else {
> +		err = quota_inode_truncate(fs, qf_inum);
> +		if (err) {
> +			log_err("quota_inode_truncate failed, ino=%u, type=%d",
> +				qf_inum, qtype);
> +			return err;
> +		}
>  	}
>  
> -	err = ext2fs_read_bitmaps(fs);
> -	if (err)
> -		goto out_err;
> -
>  	err = quota_inode_init_new(fs, qf_inum);
>  	if (err) {
> -		log_err("init_new_quota_inode failed");
> +		log_err("init_new_quota_inode failed, ino=%u, type=%d",
> +			qf_inum, qtype);
>  		goto out_err;
>  	}
>  	h->qh_qf.ino = qf_inum;
