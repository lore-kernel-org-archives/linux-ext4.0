Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C1368D50;
	Tue, 18 Aug 2026 04:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787028126; cv=none; b=DQXa8r/zHlYjMXtmoLOZzP1v+gtPgIacQQQTgmwcWVugiBknFB7rhezqFVD7elLHH6XQgiuINcOdlaBc8qLhSFQ88Y0yiyhpgs3rX8/VgY4p04z9AuZxzqSnc2fNVwHcJBSUUb+NOtniPcgV71+ZaV9yvBShV9uGoCCwNaIAWaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787028126; c=relaxed/simple;
	bh=yE0mjt+BHppr2Gpe0Bj6qiLM8bY+jd2EWSIM7WUIEwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uXVUAPMT8V/8cwOsrHgs2v5I5iWoxXcgSosSELd6sqJuvSqCX2Ppkg2WJ8R/NQwhFHx4H4rG+MP1DZCLZooTDfvH+PaGBZKD5y9RRmi5NO5HiTrHbTf0H80RqgJT56uMCiuigzFvfvT+fnQFscOJO0ifAc3N0TqiXrzen2dq7yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hPH945PcrzYQv05;
	Tue, 18 Aug 2026 12:41:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 7FA3C4058F;
	Tue, 18 Aug 2026 12:41:59 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0KV4oNqltPqCg--.35150S3;
	Tue, 18 Aug 2026 12:41:59 +0800 (CST)
Message-ID: <1537a281-aa34-49f8-87f1-e5f4fab8eb10@huaweicloud.com>
Date: Tue, 18 Aug 2026 12:41:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] ext4: orphan tracking after a failed truncate
To: Jan Kara <jack@suse.cz>, Guanghui Yang <3497809730@qq.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_3E210B6E71105F311354D53C158A3A9E1E08@qq.com>
 <66vcv4ircw5mqadt4eki52hujmykrrsqp2cux4qvn37v6kzvs7@d7ys45emz3dr>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <66vcv4ircw5mqadt4eki52hujmykrrsqp2cux4qvn37v6kzvs7@d7ys45emz3dr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBHg0KV4oNqltPqCg--.35150S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr15Ww1kZFy5ZF1DArWxXrb_yoW5Ar17pF
	Wqkws8Kw4DK3WYvFs29a18XayFyw1fA34UJr9Y9FyIya4YgrnFyr4Uta4j9FsrKFWFga4j
	qr40qr9FkF4DJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/17/2026 11:56 PM, Jan Kara wrote:
> Hi!
> 
> Quick note for Ted: these kind of reports where LLM complains about
> inconsistencies after IO errors or other catastrophic failures are rather
> frequent. I think that would be a good candidate for an ext4 specific
> prompt for LLMs to explain to it that after metadata IO failure filesystem
> inconsistencies are expected and we should just strive to limit lost data.
> 
> On Sun 09-08-26 13:45:09, Guanghui Yang wrote:
>> I am looking for clarification about the intended orphan handling when a
>> truncate fails after its journal transaction has been restarted.
>>
>> I reproduced the following using the official kernel.org Linux v6.14
>> source:
>>
>> - a large truncate naturally triggers jbd2_handle_restart()
>> - after the restart, a block-layer fault makes ext4_read_bh() return -EIO
>> - ext4_ext_truncate() and the truncate syscall return -EIO
>> - the restarted transaction is committed on disk
>> - before journal replay, e2fsck -fn reports that the orphan file contains
>>   no orphan entries
>> - the inode has i_size 0 but still has allocated blocks beyond EOF
>> - mount-time journal recovery completes, but the inconsistency remains
>>
>> In ext4_truncate(), an error from ext4_ext_truncate() jumps to out_stop.
>> For an inode with a nonzero link count, that path calls
>> ext4_orphan_del(handle, inode) regardless of the error.  In this run, the
>> committed post-restart transaction contains the orphan-file block, and the
>> pre-recovery check reports that the orphan file is clean.
>>
>> The comment above ext4_truncate() says that an incomplete truncate can be
>> restarted from ext4_orphan_cleanup() after a crash.  Should the on-disk
>> orphan entry therefore be retained when block removal fails after the
>> entry has been added?
>>
>> There is a second part to the recovery contract that I am unsure about.
>> The EIO marks the filesystem with EXT4_ERROR_FS, and
>> ext4_orphan_cleanup() skips orphan recovery in that state.  Is an e2fsck
>> repair the intended outcome for this class of error, or should ext4 keep
>> enough orphan state for mount-time recovery to finish the truncate?
> 
> This is expected. If you hit IO error on metadata, all bets are off wrt
> filesystem consistency. Running e2fsck to fix the filesystem is the only
> way to establish filesystem consistency again. So there's nothing to fix in
> the kernel really as the fact that an inode with blocks beyond EOF is not
> on orphan list is just a little nuissance...
> 
> 								Honza

I think we might want to add a small qualifier here: this is only expected
behavior under errors=continue. For the remount-ro case, we immediately
abort the journal to prevent writing out inconsistent metadata after an I/O
error, which helps contain the damage. So after journal replay, the file
system should still be able to maintain a consistent state.

Thanks,
Yi.



