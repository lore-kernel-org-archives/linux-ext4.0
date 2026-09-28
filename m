Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFB7332637
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790565686; cv=none; b=OaqnXeqirbjzYfMdzJ795s4aDqJ6AwZw2g/GUjVoio7xWt3foGkPtCtXu+ls/ocNHcd9XnXLiJa//raTb+pJ4USVh2piRk7C3S55leORhHhjMaGlAGixoM5gnKKY7akEwsJn+mIpIIZWWRW1Lsm8aGzl5cmLA2tBLFzk5yUypiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790565686; c=relaxed/simple;
	bh=iMFoUQtOwu714Tuf0MIloCjQqejT5PodMNoYqUE2xyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TKn3lVqJCjYfmefZLtF9cyUtOro0RddBwYO7USVTnBzY200BCZ/u6THJgYCnnJGrcbjjds8CKCcCEEuaHbKtik6EpcoPiCaAE/AJeT9I4FsAoZywpEXRhtQVHlmVbMo27IWAhS2JfjIa3xq+6wxyw6DuglW+13K7Y+jJ4Rwuhaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4htRQl6y7LzYQtmc
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 11:20:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C931D40916
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 11:21:12 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xyon3blqeKTOBw--.64557S3;
	Mon, 28 Sep 2026 11:21:12 +0800 (CST)
Message-ID: <8c6c9e00-7f1a-4687-bc90-5c3fc14c259e@huaweicloud.com>
Date: Mon, 28 Sep 2026 11:21:10 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: mark data=journal as deprecated and will be removed
 in January 2028.
To: Theodore Ts'o <tytso@mit.edu>,
 Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20260924145924.341425-1-tytso@mit.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260924145924.341425-1-tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3xyon3blqeKTOBw--.64557S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1xtF45Ary3JFyxGry8Xwb_yoW8uw18pa
	ykCryIk34kZF1Duw1xWF18tayag3y8CayrGF10g340qrn5AFn5Kry3tF1Sqa48KrW29ayS
	qF4IqF13Ca1aka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgmb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/24/2026 10:59 PM, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Wow, this is a significant and great decision!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  Documentation/admin-guide/ext4.rst | 6 ++++--
>  fs/ext4/super.c                    | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
> index ac0c709ea9e7..7aa586c27e37 100644
> --- a/Documentation/admin-guide/ext4.rst
> +++ b/Documentation/admin-guide/ext4.rst
> @@ -172,7 +172,8 @@ When mounting an ext4 filesystem, the following option are accepted:
>    data=journal
>          All data are committed into the journal prior to being written into the
>          main file system.  Enabling this mode will disable delayed allocation
> -        and O_DIRECT support.
> +        and O_DIRECT support.  This feature is deprecated and support
> +	will be removed in January 2028.
>  
>    data=ordered	(*)
>          All data are forced directly out to the main file system prior to its
> @@ -420,7 +421,8 @@ There are 3 different data modes:
>    consistent state.  This mode is the slowest except when data needs to be read
>    from and written to disk at the same time where it outperforms all others
>    modes.  Enabling this mode will disable delayed allocation and O_DIRECT
> -  support.
> +  support.  The data=journal feature is deprecated and support will be
> +  removed in January 2028.
>  
>  /proc entries
>  =============
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a187112cafaf..8da79cc8593f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5049,6 +5049,7 @@ static int ext4_load_and_init_journal(struct super_block *sb,
>  static int ext4_check_journal_data_mode(struct super_block *sb)
>  {
>  	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
> +		printk(KERN_WARNING "EXT4-fs: The data=journal mount option is deprecated and support will be removed in January 2028\n");
>  		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with "
>  			    "data=journal disables delayed allocation, "
>  			    "dioread_nolock, O_DIRECT and fast_commit support!\n");

