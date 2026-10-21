Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.249.212.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792572841;
	b=MEFrKV5N+ppDs9voIRjrfR3/NZQlMCatQ4rJUQlHSj3a3k+mfC6C6GKdzGFcqTQz3oKt
	 FevCyh7gJ3FxzRMr6txrrNDNY4tQ3EzjB30pwqhVxaSy5KdzZQzmhYmrmhsFNxHv2Fitg
	 2UF8qZ8mAM81uow5JCkDSawVLYq+AK6eGl0z4GKkRb8Fm4UtBa4yc9UOFPg8NFSIMNtxX
	 ECBdvpUasfZkTqp+nq+ZwSZed4/Pmfods1JCdExQTFqDDtO022QioeO4ObyJ4NOSkXxiu
	 BtypLo3y+xp+7bNWk6HHwAEVFXBfdYIlkYXePMHcJ9bKpKJy+6hvEHRufSHiNup92og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792572841;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=2/ITxtFm7WzIeL9LaTvhshI8w/pfxnMxNXE8wbtMtC4=;
	b=1VPgC9MO/rDmOkKpijsbk19jUnBxkyXk9pR81fwI3Bo/x5ZPaVn8aynNs1evD1JRXEVl
	 rY88+mEE6zlZm3b654V6M+zqaJ1A29d2bzPYfUpCb4gcBprXtD36yPQVxKPWy0q50FFHy
	 XKBV12x9tlTE3OtXQpjjFlBxaRpkBUQTO0ATuNuRwTTljtW2jnJ9tYmf3119blwI8eXzJ
	 ZFw2C7obRstNMsqrYUZt0ZiRZ7iRPhepsrVaZHC2prvHrlZePjlX2zECX82QBM4rLzC2r
	 LgU3nX5rPpSb1EeR41aQbffNAY3gOjtxt6KPqwTsLwdDhEgXhnttcZIDold6d9lxi+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=45.249.212.56
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC41606A31A;
	Wed, 21 Oct 2026 08:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DC41606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j8jkD13CJzKHMfw;
	Wed, 21 Oct 2026 16:53:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 62C0140576;
	Wed, 21 Oct 2026 16:53:51 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZPOafdhqv4QRBQ--.29944S3;
	Wed, 21 Oct 2026 16:53:47 +0800 (CST)
Message-ID: <8add4484-aed2-4d43-b973-ae1396ee664d@huaweicloud.com>
Date: Wed, 21 Oct 2026 16:53:45 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: ext4: use iomap for regular file's buffered I/O
 path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
 adilger.kernel@dilger.ca, chengzhihao1@huawei.com, djwong@kernel.org,
 hch@infradead.org, jack@suse.cz, libaokun@linux.alibaba.com,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ritesh.list@gmail.com, tytso@mit.edu,
 wangkefeng.wang@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 yizhang089@gmail.com, yukuai@fnnas.com
References: <6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com>
 <34423908-aceb-4c57-9502-7da10b12e4a4@huaweicloud.com>
 <athx6i4FVmzaCWXE@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <athx6i4FVmzaCWXE@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAnZPOafdhqv4QRBQ--.29944S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1kKFWrtw1UJr43CFyrXrb_yoWrZrykpr
	WfKF4qkr4ktr1UAFs2qr1DXr1Utw4akF47XryfWr1xAFn09FyjqFyrJrW8ury7Gry7CF12
	yF45A3s2vr1UtaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/21/2026 4:03 PM, Ojaswin Mujoo wrote:
> On Sat, Oct 10, 2026 at 04:44:52PM +0800, Zhang Yi wrote:
>> On 10/10/2026 1:54 AM, syzbot ci wrote:
>>> syzbot ci has tested the following series
>>>
>>
>> [...]
>>
>>> and found the following issue:
>>> WARNING in ext4_do_writepages
>>>
>>> Full report is available here:
>>> https://ci.syzbot.org/series/3711c951-acf4-4ebe-a920-9cc89b6be2ff
>>>
>>> ***
>>>
>>> WARNING in ext4_do_writepages
>>>
>>> tree:      vfs
>>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
>>> base:      3d399224425573875b6f6f1181bd8cf9a28cc7d1
>>> arch:      amd64
>>> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>> config:    https://ci.syzbot.org/builds/c3c01f8c-846d-4c7a-955a-fd7427af6b0d/config
>>>
>>> ------------[ cut here ]------------
>>> !err
>>> WARNING: fs/ext4/inode.c:2512 at ext4_do_writepages+0x33b3/0x44a0, CPU#0: kworker/u9:3/147
>>> Modules linked in:
>>> CPU: 0 UID: 0 PID: 147 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>> Workqueue: writeback wb_workfn (flush-7:1)
>>> RIP: 0010:ext4_do_writepages+0x33b3/0x44a0
>>> Code: 0f 0b 90 e9 b6 d9 ff ff e8 6a e2 36 ff 90 0f 0b 90 e9 e6 dc ff ff e8 5c e2 36 ff 90 0f 0b 90 e9 94 df ff ff e8 4e e2 36 ff 90 <0f> 0b 90 bb ea ff ff ff e9 ae f8 ff ff e8 3b e2 36 ff 48 8d 3d 64
>>> RSP: 0018:ffffc90003106ce0 EFLAGS: 00010293
>>> RAX: ffffffff8290e912 RBX: 0000000000000000 RCX: ffff8881053f9e00
>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>> RBP: ffffc900031070f0 R08: ffff888025da4a37 R09: 1ffff11004bb4946
>>> R10: dffffc0000000000 R11: ffffed1004bb4947 R12: ffffc900031071a0
>>> R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff11004bb495d
>>> FS:  0000000000000000(0000) GS:ffff88818d6c9000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00005555565a5a28 CR3: 0000000031f66000 CR4: 00000000000006f0
>>> Call Trace:
>>>  <TASK>
>>>  ext4_writepages+0x241/0x3b0
>>>  do_writepages+0x338/0x560
>>>  __writeback_single_inode+0x136/0x1220
>>>  writeback_sb_inodes+0x9de/0x1b00
>>>  wb_writeback+0x41c/0xad0
>>>  wb_workfn+0x431/0x10f0
>>>  process_scheduled_works+0xc3d/0x1630
>>>  worker_thread+0xa47/0xfb0
>>>  kthread+0x38b/0x480
>>>  ret_from_fork+0x514/0xb70
>>>  ret_from_fork_asm+0x1a/0x30
>>>  </TASK>
>>>
>>>
>>
>> This WARNING was newly introduced by patch 8, "ext4: skip block
>> allocation for holes in the data submission path". It doesn't actually
>> cause a new regression, it just appears to expose a pre-existing issue
>> in the buffer_head buffered I/O path, where an inconsistency between
>> the bh and extent state could potentially lead to allocating a block and
>> writing data into a hole. The logic of the patch itself is fine. To
>> avoid noise, I can drop the WARN_ON_ONCE() while still keeping return
>> -EINVAL. Thoughts?
> 
> Hi Zhang,
> 
> I think we can keep the WARN_ON. Failing in writeback here will anyways
> throw out some error messages about data loss so having an extra WARN
> dump should be okay. It will help us find and eliminate paths that cause
> this quickly, like your patch for the inline truncate fix.
> 

Yes, I agree. After all, now that we're encountering holes not being
written, together with the existing logging, this WARN_ON can help us catch
the problem.

Thanks,
Yi.

> Regards,
> ojaswin
> 
>>
>> Thanks,
>> Yi.
>>
>>> ***
>>>
>>> If these findings have caused you to resend the series or submit a
>>> separate fix, please add the following tag to your commit message:
>>>   Tested-by: syzbot@syzkaller.appspotmail.com
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> To test a fix for this bug, please reply with `#syz test`
>>> (on a separate line) and attach the patch to the email.
>>>
>>> Notes:
>>> - The patch will be applied on top of the tested series (as an
>>>   incremental fix).
>>> - To test a new version of the whole series, please send it directly
>>>   to syzbot@lists.linux.dev.
>>> - Arguments like custom git repos and branches are not supported.
>>

