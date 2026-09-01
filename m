Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BCF36A364;
	Tue,  1 Sep 2026 06:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788245089; cv=none; b=kQuL0BEMJztELxzf97asS0o7niMNVP+mXytwxHQRlhHbto7Kdi9IPJFtP/mbeZBqj93DlwCprVdi/4muCvnavx5z6rCPf31PMYS/QSY8/l3xXtnxATkgP0UcFDeu5CG5VOqB7poe0C1iMXoDii6LtT2nhypdSME6BhMfYZewS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788245089; c=relaxed/simple;
	bh=LQ8lboYVa03x9leFZ+xv6+nL6jZmGsfVJEscA0ORd2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=JJqmmSgW61PD8QzqQrVX22QXGKrkfBrVmnhos5ILU9uGEpQlC9exsHKsSLN0jRmEAZqv3Ae16oX1BE/Usif/Hi93q6f8XjnKP0kX7doEtuzicQbx6OyHEnow/yucTkUI+gL4ANpPciNSe4UHfecpAqv5nbJK5mKOL7f5zYVcNWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hYxCQ5XMXzKHMZ3;
	Tue,  1 Sep 2026 14:43:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A9B884057D;
	Tue,  1 Sep 2026 14:44:36 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglRdJZqyOlUAQ--.53508S3;
	Tue, 01 Sep 2026 14:44:35 +0800 (CST)
Message-ID: <9ea01177-99ac-40c2-ba51-fcb665e38330@huaweicloud.com>
Date: Tue, 1 Sep 2026 14:44:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] ext4: Fix out-of-bounds read in
 ext4_get_group_info()
To: Jinjie Ruan <ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-8-ruanjinjie@huawei.com>
Content-Language: en-US
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 bcrl@kvack.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 sforshee@kernel.org, pmladek@suse.com, rostedt@goodmis.org,
 andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
 senozhatsky@chromium.org, akpm@linux-foundation.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 kuniyu@google.com, willemb@google.com, jhs@mojatatu.com, jiri@resnulli.us,
 kees@kernel.org, cyphar@cyphar.com, tglx@kernel.org, sdf@fomichev.me,
 nb@tipi-net.de, liuhangbin@gmail.com, da-x@monatomic.org, jeff@garzik.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 netdev@vger.kernel.org
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260901024234.135119-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgA3HglRdJZqyOlUAQ--.53508S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4UArWUWr1DAFW3Kw47CFg_yoW5GryfpF
	sIkF13JrZ5Gr1DCw48G3y0ga48Jw1IgF45Wr93Gw18ZrW7Ar1fCF1fKr1rZFyUtFWkAr4x
	Xw1Y9r15C3ZrCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j6a0PUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/1/2026 10:42 AM, Jinjie Ruan wrote:
> A plain read of s_groups_count in ext4_get_group_info() allows CPU
> load-load reordering. On weak memory models, speculative prefetch of
> s_group_info prior to the boundary check could lead to an out-of-bounds
> read if a concurrent online resize expands the array and increments
> s_groups_count.
> 
> The data race occurs between the ioctl configuration path (holding the
> resize lock via ext4_resize_begin) and the lockless metadata lookup path:
> 
>    CPU 0 (Writer, Resize Lock)                CPU 1 (Reader, Lockless)
>    ---------------------------                ------------------------
>    ext4_ioctl()
>      [EXT4_IOC_GROUP_ADD]
>      ext4_ioctl_group_add()
>        ext4_resize_begin() // Takes lock
>        ext4_group_add()
>          ext4_mb_alloc_groupinfo()
>            // Publishes expanded array via RCU
>            rcu_assign_pointer(s_group_info, ...)
> 
>          ext4_flex_group_add()
>            ext4_update_super()
>                                               ext4_get_group_info()
>                                                 // Speculative / out-of-order read
>                                                 [Loads old/smaller s_group_info pointer]
>              [Plain C store / smp_wmb()]
>              sbi->s_groups_count += ...;
>                                                 // Reads new s_groups_count,
>                                                 // boundary check passes
>                                                 if (group >= s_groups_count)
> 
>                                                 // Out-of-bounds array access!
>                                                 sbi_array_rcu_deref(..., s_group_info)
> 
> Fix this by using ext4_get_groups_count() to enforce acquire semantics.
> 
> Cc: stable@vger.kernel.org
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Baokun Li <libaokun@linux.alibaba.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: Zhang Yi <yi.zhang@huawei.com>
> Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/balloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 52f4c5169f91..778fe8788f06 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -329,7 +329,7 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
>  	struct ext4_group_info **grp_info;
>  	long indexv, indexh;
>  
> -	if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
> +	if (unlikely(group >= ext4_get_groups_count(sb)))
>  		return NULL;
>  	if (unlikely(!EXT4_SB(sb)->s_group_info))
>  		return NULL;

