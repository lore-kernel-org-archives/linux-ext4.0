Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08E83E92A6;
	Tue, 24 Mar 2026 11:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774350039; cv=none; b=gg551ioW8YWdCTzkIEv2RjHMoUuBfvvoNPHU5QGNFN19WeKArccKBCuVodQ/IcGwd1pothgtuJof1+zL8ecsrf9Z3HapARGJGdklOViiMzDZxZoPgvHzh4AjQmyvC4d8maFJ5Zy2UOEATlkvw4oZsmpxkf0O7PYrz1jfCKbifnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774350039; c=relaxed/simple;
	bh=hkPccoDD3wwAsrOYocTQZLWOFYY1JDCxpR9Q1bWWSP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikwtJr/BgPuV/J9JUtzpKFpJA9U9rtW6Q4EuE4dyfYc5NQVXWA8uK5dozWmm91xxJbY7yDsLqDnTqaN37z3gwyz7Z4HjGM6hZOUiDHzUodaPTIjcGox8qeVo9XdFo/yRFnZcjveyGHSe2cndiTR6B5SQUa5BXwbtrbp6OsfLOs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=i/2BJSF+; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="i/2BJSF+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774350031; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R5+HI63vns9irSYBpzTGS3kRRols7k3i+h9tt1469vM=;
	b=i/2BJSF+UBhvCTh131srz6f+K4y/W5U1CHZHO6ihWrdvD/UhaMoeyC5WhWNBvuv97G3Mak9wKr6swWC+9jx5GLn/uY/f4hXign0YSB1QeM6f6ymKwjprNTddEg+Xtf5pun8C3WVddN2KeL9jZGEBYz+hU6pcltlgmwlwMULKioA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.eEVSz_1774350030;
Received: from 30.221.131.178(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X.eEVSz_1774350030 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 19:00:31 +0800
Message-ID: <d7a82737-a293-4e72-b5e4-1c8492d06e8c@linux.alibaba.com>
Date: Tue, 24 Mar 2026 19:00:30 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] e2fsprogs 1.47.4: mke2fs creates oversized orphan
 file for 1k blocksize (breaks mount)
To: Yi Zhang <yi.zhang@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-block <linux-block@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Theodore Ts'o <tytso@mit.edu>, libaokun@linux.alibaba.com
References: <CAHj4cs8o5HExeOX2YCYrWH86iz4xwL52YtsJNV2YOyDPbyEffg@mail.gmail.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <CAHj4cs8o5HExeOX2YCYrWH86iz4xwL52YtsJNV2YOyDPbyEffg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/24/26 8:54 AM, Yi Zhang wrote:
> Hi
>
> I'm reporting a regression in e2fsprogs-1.47.4 where mke2fs creates an
> orphan file[2] that exceeds the kernel's maximum allowed size for
> filesystems with a 1KB block size[1]. This causes subsequent mount
> operations to fail.
>
> This issue is currently causing blktests loop/007 to fail on latest
> Fedora. Downgrading to e2fsprogs 1.47.3 resolves the issue.
> And revert [3] fixed this issue, here is the reproducer[4].
>
> [1]
> Kernel limit for 1KB blocks: 512 * 1024 = 512 KB
> [2]
> Orphan file created by e2fsprogs 1.47.4: 1024 KB (1 MB)
> [3]
> 6f03c698 libext2fs: fix orphan file size > kernel limit with large blocksize

Refer to the discussion in [a], you can revert [3] and apply [b] to fix
this issue.

[a]:
https://lore.kernel.org/linux-ext4/d4d64000-6b55-449e-83bb-be438aaa5146@linux.alibaba.com/
[b]:
https://lore.kernel.org/linux-ext4/20251120135514.3013973-1-libaokun@huaweicloud.com/


Cheers,
Baokun

> [4]
> # dd if=/dev/zero of=test.img bs=1M count=1024
> # mkfs.ext4 -b 1024 test.img  -F
> mke2fs 1.47.4 (6-Mar-2025)
> test.img contains a ext4 file system
>         last mounted on Mon Mar 23 20:32:40 2026
> Discarding device blocks: done
> Creating filesystem with 1048576 1k blocks and 65536 inodes
> Filesystem UUID: 16683060-ed47-46cc-a040-c5e049785831
> Superblock backups stored on blocks:
>         8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553,
>         1024001
>
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: done
> # mount test.img /mnt
> mount: /mnt: fsconfig() failed: Structure needs cleaning.
>        dmesg(1) may have more information after failed mount system call.
>
> # dmesg
> [ 5985.339637] loop0: detected capacity change from 0 to 2097152
> [ 5985.347473] EXT4-fs (loop0): orphan file too big: 1048576
> [ 5985.352939] EXT4-fs (loop0): mount failed
>
>

