Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5402236F2;
	Wed, 24 Jun 2026 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782268967; cv=none; b=plP8yqKEuI2MGC4zk5F4yD0N8Q1KLPdANaoE1R27xWU2i3T8LsNIBx6HkQb9Pc5PiHez8BuEM8MScij+YQPv7HNYNMT834+JUxM+6CSWshHxlAZAk5xq8eaFVwMH+oNyyock+x0NaL77FWzBgZ2DdNKTB5rIiaB8FL+3MA4ZSCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782268967; c=relaxed/simple;
	bh=H+VAdzoYcBCOTqRLAgLu3om/vSIqHBZemX0zFErI4BQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hInK49mT5DxnYhAj+yNtBsLE1LBkliSsfOIuN2gGQygFO0VnsArElYwKFfWbOiuLKCeUQ3oLcvWYTRhj1l9HFIeMHVSZ12QhvszEN0uVNe1b0PXHbTIwsMmDt9vKgxDPfS8wIbSwd+FHh5BjpS9QQaFJHR6Xy2ESREmYUkkwpKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4glR5s2PPSzKHMWY;
	Wed, 24 Jun 2026 10:41:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 551B640583;
	Wed, 24 Jun 2026 10:42:36 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBXWj8YRDtqzDGVCw--.10897S3;
	Wed, 24 Jun 2026 10:42:34 +0800 (CST)
Message-ID: <d94027e3-53e7-4317-bc8d-c72bbd49186f@huaweicloud.com>
Date: Wed, 24 Jun 2026 10:42:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4, jbd2: abort journal on file data write error under
 data_err=abort
To: Aditya Srivastava <aditya.ansh182@gmail.com>, tytso@mit.edu
Cc: jack@suse.cz, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, Zhang Yi
 <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Anthony Rebello <arebello@redhat.com>
References: <20260623161131.2189-1-aditya.ansh182@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260623161131.2189-1-aditya.ansh182@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBXWj8YRDtqzDGVCw--.10897S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1rtrW8JrWUZw48ZF1DJrb_yoWrGF47pF
	95Z342yrWDAry8Cws7ursrJFW5Z3yFkFy7Gr1DWwsFva17t3Z7trZFqw13Kas0vrsY93W0
	qFyDC3srCr9FvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/24/2026 12:11 AM, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> The "data_err=abort" mount option in ext4 is designed to abort the
> journal and force the filesystem into read-only mode if a file data
> writeback failure is detected (to prevent silent data loss and stale
> data exposure).
> 
> However, in standard data=ordered mode, file data writeback is executed
> and waited for during transaction commit in
> journal_finish_inode_data_buffers(). When
> filemap_fdatawait_range_keep_errors() detects and returns a data writeback
> error (e.g. -EIO), JBD2 merely prints a warning message and then
> discards the error. This results in the transaction committing
> successfully, exposing stale/corrupted data and defeating the purpose
> of the data_err=abort option.

Hi, Aditya!

Thanks for the patch. However, after commit ce51afb8cc5e ("ext4: abort
journal on data writeback failure if in data_err=abort mode"), has
already moved the abort logic into the end IO workqueue. In that case,
it seems the journal abort would be triggered properly upon a data
writeback failure. The issue described in this Bugzilla looks like an
outdated one. Have you encountered any actual issues for now?

Thanks,
Yi.

> 
> Fix this by:
> 1. Defining a new JBD2 configuration flag, JBD2_ABORT_ON_DATA_ERR.
> 2. In JBD2, if JBD2_ABORT_ON_DATA_ERR is set, abort the transaction commit
>    and the journal thread via jbd2_journal_abort() if writeback fails.
> 3. In ext4, configure JBD2_ABORT_ON_DATA_ERR on the journal based on the
>    ext4 "data_err=abort" mount option in ext4_init_journal_params().
> 
> Reported-by: Anthony Rebello <arebello@redhat.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=207729
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  fs/ext4/super.c      | 4 ++++
>  fs/jbd2/commit.c     | 2 ++
>  include/linux/jbd2.h | 1 +
>  3 files changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7283108d7609..de34490a5b68 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5875,6 +5875,10 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
>  		journal->j_flags |= JBD2_BARRIER;
>  	else
>  		journal->j_flags &= ~JBD2_BARRIER;
> +	if (test_opt(sb, DATA_ERR_ABORT))
> +		journal->j_flags |= JBD2_ABORT_ON_DATA_ERR;
> +	else
> +		journal->j_flags &= ~JBD2_ABORT_ON_DATA_ERR;
>  	/*
>  	 * Always enable journal cycle record option, letting the journal
>  	 * records log transactions continuously between each mount.
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index d8577725a2fb..49acc9d0809e 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -768,6 +768,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		printk(KERN_WARNING
>  			"JBD2: Detected IO errors %d while flushing file data on %s\n",
>  			err, journal->j_devname);
> +		if (journal->j_flags & JBD2_ABORT_ON_DATA_ERR)
> +			jbd2_journal_abort(journal, err);
>  		err = 0;
>  	}
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 7e785aa6d35d..e39679656de6 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1410,6 +1410,7 @@ JBD2_FEATURE_INCOMPAT_FUNCS(fast_commit,	FAST_COMMIT)
>  #define JBD2_FLUSHED	0x008	/* The journal superblock has been flushed */
>  #define JBD2_LOADED	0x010	/* The journal superblock has been loaded */
>  #define JBD2_BARRIER	0x020	/* Use IDE barriers */
> +#define JBD2_ABORT_ON_DATA_ERR	0x040	/* Abort the journal on file data write errors */
>  #define JBD2_CYCLE_RECORD		0x080	/* Journal cycled record log on
>  						 * clean and empty filesystem
>  						 * logging area */

