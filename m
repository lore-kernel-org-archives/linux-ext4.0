Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846730FC34
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 11:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772038; cv=none; b=BNzMiTKkNQ9Ym0uYPn1WAef22v4LqfZpaMYIgAR0Yv8a4AhvTsYMqdsd+biiz0AnMycU78x1drv0ZYC0yt6HQa3E7lO/vIWJHYBqqkAmyGhGbJBVYgDO9ny5bEe/XycxdS8PTrwc8T2I83wIz/lmP1OFwpr7SNRHp3YlUU5fAkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772038; c=relaxed/simple;
	bh=5ro6CjGzRt0udxEQWaMjsblXN3OGbRvGlqOUOgVGH/s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z/WmzFLd43uWPkVb37X++nMqzCfHrphL0wNFn60bxUKqBYaul1v75l/RNDq/KOrVvPXhmMtAJReXpIAZGKl4YKkLZObwJDoANSEHB4aWrruVb30LwjNMGUnlMavlmvIC4DrIMNP4JL/CbqTp9hpja0Xhmrf2zxyhoKY2grEsVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0LDQ0bDZzKHMVt
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:46:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 2C239405F1
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:47:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL21Y+dp_aHLBA--.55420S4;
	Tue, 21 Apr 2026 19:47:01 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: stable@kernel.org,
	linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	libaokun@linux.alibaba.com,
	adilger.kernel@dilger.ca,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	jack@suse.cz,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	zhangxiaoxu5@huawei.com
Subject: [PATH 6.6 0/3] fix potential ext4 null pointer
Date: Tue, 21 Apr 2026 19:34:13 +0800
Message-Id: <20260421113416.4040274-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHtL21Y+dp_aHLBA--.55420S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4UGr43GF13XryfCF4DArb_yoWrKrWkpF
	1akF4UGr4vqr9xJF47Aw15Jr13Cr4kAa1UW3W7Wr48t3WUu3W5Xr1UJrWjyFZrXr1UWFW3
	tr1DXw4IkrnrAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9mb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x02
	62kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
	0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07ULAwxUUUUU=
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

Our Hulk robot discovered that there were missing 6b854d552711
("ext4: get rid of ppath in get_ext_path()") when backporting the
linux-6.6.y mainline patch set[1], which could potentially trigger
some error branches in ext4 to cause a panic. I also verified this
point during testing using xfstests-bld[2]. Along with this, we
have also backported other related patches from the corresponding
patch set [1].

[1]. https://lore.kernel.org/all/20240822023545.1994557-1-libaokun@huaweicloud.com/
[2]. https://github.com/tytso/xfstests-bld

generic/051 81s ...  [09:20:24][  509.012535] run fstests generic/051 at 2026-04-21 09:20:24
[  509.314026] EXT4-fs (vdb): mounted filesystem d225342d-c437-4a7d-893b-5d02903a5ea4 r/w with ordered data mode. Quota mode: none.
[  509.397019] EXT4-fs (vdc): mounted filesystem 72b9e6ee-4b56-45ee-b71e-ca491d2fd7e9 r/w with ordered data mode. Quota mode: none.
[  509.399614] EXT4-fs (vdc): shut down requested (1)
[  509.400082] Aborting journal on device vdc-8.
[  509.402378] EXT4-fs (vdc): unmounting filesystem 72b9e6ee-4b56-45ee-b71e-ca491d2fd7e9.
[  509.443140] EXT4-fs (vdc): mounted filesystem 03f15f3c-5938-41ea-bbf8-321de40d01ff r/w with ordered data mode. Quota mode: none.
[  539.831842] EXT4-fs (vdc): unmounting filesystem 03f15f3c-5938-41ea-bbf8-321de40d01ff.
[  539.868710] EXT4-fs (vdc): mounted filesystem 03f15f3c-5938-41ea-bbf8-321de40d01ff r/w with ordered data mode. Quota mode: none.
[  552.967466] BUG: unable to handle page fault for address: ffffffffffffffec
[  552.968455] #PF: supervisor read access in kernel mode
[  552.969157] #PF: error_code(0x0000) - not-present page
[  552.969859] PGD 282c067 P4D 282d067 PUD 282f067 PMD 0
[  552.970575] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  552.971179] CPU: 0 PID: 292843 Comm: fsstress Not tainted 6.6.135-xfstests #2
[  552.972143] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc37 04/01/2014
[  552.973284] RIP: 0010:ext4_ext_map_blocks+0x191/0xab0
[  552.973986] Code: 4c 89 e6 48 89 ef 48 8d 54 24 60 e8 89 6c ff ff 85 c0 89 44 24 28 0f 84 59 02 00 00 48 8b 44 24 30 48 85 c0 0f 84 09 06 00 00 <44> 0f b7 78 08 45 31 f6 48 89 1c 24 49 89 c4 44 89 f3 49 89 c6 49
[  552.976362] RSP: 0018:ffa0000006ab3c78 EFLAGS: 00010286
[  552.976862] RAX: ffffffffffffffe4 RBX: ffa0000006ab3de0 RCX: 0000000000000000
[  552.977525] RDX: ffffffff82244590 RSI: ffffffff825d3cfc RDI: ff1100002e5d5068
[  552.978189] RBP: ff110000064f6628 R08: ffffffff825d3ddd R09: ff1100006b74a618
[  552.978850] R10: 00000000d8f693c7 R11: ff11000077f49ff0 R12: ff110000062040c0
[  552.979511] R13: 0000000000000043 R14: 0000000000025b80 R15: ff110000069f1000
[  552.980159] FS:  00007f7685ec8740(0000) GS:ff1100007dc00000(0000) knlGS:0000000000000000
[  552.980906] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  552.981445] CR2: ffffffffffffffec CR3: 0000000006a44005 CR4: 0000000000771ef0
[  552.982091] PKRU: 55555554
[  552.982351] Call Trace:
[  552.982606]  <TASK>
[  552.982818]  ext4_map_blocks+0x23e/0x6b0
[  552.983191]  ext4_alloc_file_blocks.isra.0+0x12b/0x370
[  552.983671]  ext4_fallocate+0x150/0x310
[  552.984034]  vfs_fallocate+0x13e/0x380
[  552.984391]  ioctl_preallocate+0xa4/0xd0
[  552.984769]  __x64_sys_ioctl+0x71/0xd0
[  552.985126]  do_syscall_64+0x38/0x80
[  552.985479]  entry_SYSCALL_64_after_hwframe+0x78/0xe2
[  552.985956] RIP: 0033:0x7f7685fc8c5b
[  552.986291] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  552.987925] RSP: 002b:00007fff16838290 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  552.988571] RAX: ffffffffffffffda RBX: 000000000000991b RCX: 00007f7685fc8c5b
[  552.989186] RDX: 00007fff16838310 RSI: 000000004030582a RDI: 0000000000000003
[  552.989812] RBP: 0000000000000003 R08: 0000000000000002 R09: 00007fff168382fc
[  552.990428] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000000
[  552.991043] R13: 00000000001a6829 R14: 8f5c28f5c28f5c29 R15: 000055c9bd970650
[  552.991655]  </TASK>
[  552.991857] CR2: ffffffffffffffec
[  552.992154] ---[ end trace 0000000000000000 ]---
[  552.992557] RIP: 0010:ext4_ext_map_blocks+0x191/0xab0

Baokun Li (3):
  ext4: get rid of ppath in get_ext_path()
  ext4: get rid of ppath in ext4_force_split_extent_at()
  ext4: get rid of ppath in convert_initialized_extent()

 fs/ext4/extents.c     | 111 +++++++++++++++++++++++-------------------
 fs/ext4/move_extent.c |  34 ++++++-------
 2 files changed, 77 insertions(+), 68 deletions(-)

-- 
2.39.2

