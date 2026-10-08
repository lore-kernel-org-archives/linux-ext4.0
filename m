Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1AB31716D;
	Thu,  8 Oct 2026 06:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791441322; cv=none; b=dm2AnOcvPcnnRe0p8SE5D4zjRpQAEmQgkVXp2JfD75AiC+A03w43XXZuFmEMakhrnGX/ly0MrRzureS6EP003h8VjaMRDLJDzC/T/9HUXcfD8QVQ3K9yum3Cjvtd84XMXcjEQ77HjPZVr7fiTPVPl/QP6pxwGUr62dr0rYSinbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791441322; c=relaxed/simple;
	bh=I+rBECfhMRi7b4iq6NMmlFbEfsUx63FrXLW970ILfJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYUiL/HajJvOAWIw0Njr40ZX5BhbwPfR4M3uePuB2HmIKVlNgzj4vaC0N7RlMoj1NGmMAPRgUe8UCoElqR/vUlzV0U3H9pEOgYpLuplUTB+Y7J6amkEjTNa2m0kXqT0ku8GVbNG00yiZBtBLaWl+L00yD6goqwFFVb85we6esiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j0gFZ4cjDzKHMp6;
	Thu,  8 Oct 2026 14:34:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A81894056F;
	Thu,  8 Oct 2026 14:35:16 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3ximiOcdqZjfLDA--.22468S3;
	Thu, 08 Oct 2026 14:35:16 +0800 (CST)
Message-ID: <06d4da83-2655-495f-b317-6a2985989fdd@huaweicloud.com>
Date: Thu, 8 Oct 2026 14:35:14 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: don't start a fast commit while the journal is
 marked empty
To: daejun7.park@samsung.com
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.com>, Jan Kara <jack@suse.cz>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huaweicloud.com>,
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Li Chen <me@linux.beauty>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3ximiOcdqZjfLDA--.22468S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurWxCF4UAw15WFyrWFyrtFb_yoWrGr45pF
	WrJFy8trWvvr1Utrs5Wr18XFWFq3yvyFWUWr1ku3Wqqa15Jrn7Kw42qrnxJF1UJFsY9w4Y
	gF4jk3s8K34Yka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/7/2026 8:41 AM, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> jbd2_journal_flush() checkpoints everything, and
> jbd2_mark_journal_empty() then writes the journal superblock with
> s_start == 0 and the fast commit feature cleared. It sets JBD2_FLUSHED
> so that the next commit writes the log tail and the feature back, but
> only jbd2_journal_commit_transaction() looks at that flag. A fast commit
> started before the next full commit writes its blocks while the
> superblock on disk still says the log is empty: jbd2_journal_recover()
> returns at once and the fast commit is never replayed.
> 
> On ext4 with -O fast_commit this happens after ext4_freeze(), and after
> a remount to read-only, which flushes the journal in
> ext4_mark_recovery_complete(), once the file system is read-write again.
> EXT4_IOC_CHECKPOINT and online resize flush it as well. An fsync that a
> fast commit handles after one of them is lost if the system crashes
> before the next full commit, which can be up to the commit interval
> later:
> 
>   mount -o commit=60 (-O fast_commit file system)
>   echo first > a; sync
>   fsfreeze -f; fsfreeze -u      # or: remount ro, then rw
>   write b; fsync b              # one fast commit, s_start still 0
>   crash (kill the VM), mount
>   b is missing
> 
> Refuse to start a fast commit while JBD2_FLUSHED is set, as is already
> done before the first full commit. ext4 then falls back to a full
> commit, which writes the log tail, and the fast commits after it are
> recovered again. fc_info counts the refused fast commit as ineligible,
> as it does for the existing check.
> 
> Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

This makes sense to me!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
> Tested in QEMU on ext4 dev 9091c97be340, crashing by killing QEMU: the
> sequence above loses b without this change and keeps it with it, both
> after fsfreeze and after a remount ro then rw. A second fsync after the
> fallback is a fast commit again and is recovered. xfstests ext4/044
> ext4/045 generic/455 generic/456 generic/482 with -O fast_commit, and
> generic/068 generic/085 generic/390, give the same results as without
> the change (generic/455 fails on both).
> ---
>  fs/jbd2/journal.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d..22576af8c8 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -695,7 +695,8 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
>   * it to complete. Returns 0 if a new fast commit was started. Returns -EALREADY
>   * if a fast commit is not needed, either because there's an already a commit
>   * going on or this tid has already been committed. Returns -EINVAL if no jbd2
> - * commit has yet been performed.
> + * commit has yet been performed, or none since the journal was last marked
> + * empty.
>   */
>  int jbd2_fc_begin_commit(journal_t *journal, tid_t tid)
>  {
> @@ -714,6 +715,16 @@ int jbd2_fc_begin_commit(journal_t *journal, tid_t tid)
>  		return -EALREADY;
>  	}
>  
> +	/*
> +	 * The log was emptied and the superblock on disk says so, which makes
> +	 * recovery skip the fast commit area as well. Only a full commit
> +	 * records the log tail again.
> +	 */
> +	if (journal->j_flags & JBD2_FLUSHED) {
> +		write_unlock(&journal->j_state_lock);
> +		return -EINVAL;
> +	}
> +
>  	if (journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
>  	    (journal->j_flags & JBD2_FAST_COMMIT_ONGOING)) {
>  		DEFINE_WAIT(wait);
> 
> ---
> base-commit: 9091c97be34083587a75db174aab51551d8e8543
> change-id: 20261006-jbd2-fc-after-flush-2ef9bbc32cea
> 
> Best regards,

