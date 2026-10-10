Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76C83AFD11;
	Sat, 10 Oct 2026 08:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621910; cv=none; b=t7I4ZmL2OuzHKUkv/mRSWOvYm/j+ccsBjiDj7lUYvpf70UWu4J1zStRgOXPiRU7++7tpCbCPWlyP3UaPXJzOssuomhN9M4FcVCNKYOJUgjgBUzh86ZvxR8c9r+cYID6BRxH2KrrXjvUAKUfucYu/6PcgO2fO8i6J1XRX5dRhfy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621910; c=relaxed/simple;
	bh=HueVlU6wofq0ki2OUV2xZU+Y4v/BBnx8UUmOYBJZLsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ht7H7Fd55jsC/LhhCJ1BdnrxJhqB4VY/We7/626v2tNrwjzJVjN9Ks/a8N/+3j6ZWmiEN0JT5V3m97sNav5LFFVA/ebMn9sAj1Hcq6+jLpd7zS1/GGiH/ukr1yTAHurOnfDV82Wmad/5SlMxM56+hqUTErnwPqr/G/v4jLrSs5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1y2N33mHzYQvY8;
	Sat, 10 Oct 2026 16:44:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3A8084056B;
	Sat, 10 Oct 2026 16:44:58 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAX5ykE+8lq38nSDQ--.10478S3;
	Sat, 10 Oct 2026 16:44:54 +0800 (CST)
Message-ID: <34423908-aceb-4c57-9502-7da10b12e4a4@huaweicloud.com>
Date: Sat, 10 Oct 2026 16:44:52 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: ext4: use iomap for regular file's buffered I/O
 path
To: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
 adilger.kernel@dilger.ca, chengzhihao1@huawei.com, djwong@kernel.org,
 hch@infradead.org, jack@suse.cz, libaokun@linux.alibaba.com,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 tytso@mit.edu, wangkefeng.wang@huawei.com, yangerkun@huawei.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yukuai@fnnas.com
References: <6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAX5ykE+8lq38nSDQ--.10478S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuFy5Gw4DCr4fZry5tFyxKrg_yoW5KFy7pr
	W3Kr47Kr48tr18AFs7Zr1UXr18Gr43Ca1UJryfGr1xAFn8uFyjgFyrtrWUZryUJryUCFy2
	yan8Z34ktw1qqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIa
	0PDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/10/2026 1:54 AM, syzbot ci wrote:
> syzbot ci has tested the following series
> 

[...]

> and found the following issue:
> WARNING in ext4_do_writepages
> 
> Full report is available here:
> https://ci.syzbot.org/series/3711c951-acf4-4ebe-a920-9cc89b6be2ff
> 
> ***
> 
> WARNING in ext4_do_writepages
> 
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
> base:      3d399224425573875b6f6f1181bd8cf9a28cc7d1
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/c3c01f8c-846d-4c7a-955a-fd7427af6b0d/config
> 
> ------------[ cut here ]------------
> !err
> WARNING: fs/ext4/inode.c:2512 at ext4_do_writepages+0x33b3/0x44a0, CPU#0: kworker/u9:3/147
> Modules linked in:
> CPU: 0 UID: 0 PID: 147 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: writeback wb_workfn (flush-7:1)
> RIP: 0010:ext4_do_writepages+0x33b3/0x44a0
> Code: 0f 0b 90 e9 b6 d9 ff ff e8 6a e2 36 ff 90 0f 0b 90 e9 e6 dc ff ff e8 5c e2 36 ff 90 0f 0b 90 e9 94 df ff ff e8 4e e2 36 ff 90 <0f> 0b 90 bb ea ff ff ff e9 ae f8 ff ff e8 3b e2 36 ff 48 8d 3d 64
> RSP: 0018:ffffc90003106ce0 EFLAGS: 00010293
> RAX: ffffffff8290e912 RBX: 0000000000000000 RCX: ffff8881053f9e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc900031070f0 R08: ffff888025da4a37 R09: 1ffff11004bb4946
> R10: dffffc0000000000 R11: ffffed1004bb4947 R12: ffffc900031071a0
> R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff11004bb495d
> FS:  0000000000000000(0000) GS:ffff88818d6c9000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005555565a5a28 CR3: 0000000031f66000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ext4_writepages+0x241/0x3b0
>  do_writepages+0x338/0x560
>  __writeback_single_inode+0x136/0x1220
>  writeback_sb_inodes+0x9de/0x1b00
>  wb_writeback+0x41c/0xad0
>  wb_workfn+0x431/0x10f0
>  process_scheduled_works+0xc3d/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> 

This WARNING was newly introduced by patch 8, "ext4: skip block
allocation for holes in the data submission path". It doesn't actually
cause a new regression, it just appears to expose a pre-existing issue
in the buffer_head buffered I/O path, where an inconsistency between
the bh and extent state could potentially lead to allocating a block and
writing data into a hole. The logic of the patch itself is fine. To
avoid noise, I can drop the WARN_ON_ONCE() while still keeping return
-EINVAL. Thoughts?

Thanks,
Yi.

> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> 
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
> 
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.

