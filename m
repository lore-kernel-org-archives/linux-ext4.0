Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD1738A28F;
	Tue, 10 Mar 2026 12:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773145415; cv=none; b=s7Gok/HUaEPE161CG02g0Uh1zKHkkEp5gsGcEtHzH1jcvUEBuC6gubP7IxGTIiYaUN5mtGFD/h0Scth2NGLXKPlaAQ3YLys7EGwojmpeDTT7ArWOrWSj8zrOykOGxAKzdgmHcvudehJ7iid9X5ftbYPdRV1ComgqIkT1Tjr9aDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773145415; c=relaxed/simple;
	bh=dfu3luwQicp+280gKKuHDHjH89+NSfz4qXi+IzprZn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BoSFnfQRV6zIRS8cwIKhzMoYGs2E1UUzTpBmbChpsqfuOYYHYAMon6KlXbdtf15wQd8xuYQbyVrBRWQaGkyyr6YierJONNnQgOXBpcwKUeJDf8vbxxaEjcoB5m+FEjRZ9xT22gPC4f1dU0uxL4YP2kh89D3P46vLaQ1tlVuNuD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVY1l0NLGzKHMZR;
	Tue, 10 Mar 2026 20:23:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4408340539;
	Tue, 10 Mar 2026 20:23:22 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgD3+Ng4DbBpmKCYAQ--.16282S3;
	Tue, 10 Mar 2026 20:23:22 +0800 (CST)
Message-ID: <7cbbefaf-28fc-4400-b2da-7ab8d1afc952@huaweicloud.com>
Date: Tue, 10 Mar 2026 20:23:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] Warning in ext4_check_map_extents_env
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <aa7Ms0MzyPKggFGo@fedora>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aa7Ms0MzyPKggFGo@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgD3+Ng4DbBpmKCYAQ--.16282S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr13XF13JF43Zr4kKw48JFb_yoWxCFy8pF
	1YyF4kCw48Ar1UZFy2y3Wq9w1UKr47uFWUGryxGr18A3W8GF13XFy5GF4UKrZxArWDZrW7
	Jw1DAw1kKayUtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jjVbkUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi,

Thank you for the report!

+ add UPROBES list to CC.

On 3/9/2026 9:41 PM, Pedro Demarchi Gomes wrote:
> Hi,
> 
> The warning below occurs when running selftests/mm/merge on a kernel built
> with CONFIG_EXT4_DEBUG=y.
> 
> syzkaller login: [   29.277674] ------------[ cut here ]------------
> [   29.279636] WARNING: fs/ext4/inode.c:436 at ext4_check_map_extents_env+0x389/0x440, CPU#1: merge/365
> [   29.282459] Modules linked in:
> [   29.283497] CPU: 1 UID: 0 PID: 365 Comm: merge Not tainted 7.0.0-rc3 #59 PREEMPT(full)
> [   29.285999] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   29.288850] RIP: 0010:ext4_check_map_extents_env+0x389/0x440
> [   29.290653] Code: ff 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 87 00 00 00 48 8b 45 18 48 85 c0 0f 85 2e fd ff ff 90 <0f> 0b 90 e9 25 fd ff ff e8 8a 2e ca ff e9 e4 fc ff ff 48 89 df e8
> [   29.296623] RSP: 0018:ffff88811876f2a8 EFLAGS: 00010246
> [   29.298288] RAX: 0000000000000000 RBX: ffff888106c66798 RCX: ffffffff81e8ad60
> [   29.300529] RDX: 1ffff11020d8ccf3 RSI: 0000000000000008 RDI: ffff888106c66798
> [   29.302748] RBP: ffff888106c66780 R08: 0000000000000000 R09: ffffed1020d8ccf3
> [   29.305009] R10: ffff888106c6679f R11: 0000000000000001 R12: 00000000001e0c26
> [   29.307226] R13: ffff88811876f494 R14: ffff88811876f498 R15: ffff88811876f488
> [   29.309477] FS:  00007fbe82723780(0000) GS:ffff8883c38aa000(0000) knlGS:0000000000000000
> [   29.312085] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.313749] CR2: 00007fbe82790915 CR3: 000000011880e000 CR4: 00000000000006f0
> [   29.315643] Call Trace:
> [   29.316170]  <TASK>
> [   29.316539]  ext4_map_blocks+0x602/0xb40
> [   29.317204]  ? __pfx_ext4_map_blocks+0x10/0x10
> [   29.317971]  ? __pfx_stack_trace_save+0x10/0x10
> [   29.318719]  ? __filemap_add_folio+0x66f/0xb30
> [   29.319500]  ext4_mpage_readpages.constprop.0.isra.0+0x918/0xe20
> [   29.320501]  ? __pfx_ext4_mpage_readpages.constprop.0.isra.0+0x10/0x10
> [   29.321602]  ? filemap_add_folio+0x11e/0x2c0
> [   29.322325]  ? __pfx_ext4_read_folio+0x10/0x10
> [   29.323107]  ext4_read_folio+0xd9/0x230
> [   29.323762]  ? __pfx_ext4_read_folio+0x10/0x10
> [   29.324552]  ? __pfx_ext4_read_folio+0x10/0x10
> [   29.325321]  filemap_read_folio+0x43/0x150
> [   29.326041]  do_read_cache_folio+0x1b1/0x320
> [   29.326759]  read_cache_page+0x46/0x120
> [   29.327426]  install_breakpoint+0x27d/0x810

It seems this isn't an issue with ext4 itself. Instead, the implementation
in uprobe_mmap() seems not respecting the principle that read_cache_page()
should be called while holding mapping->invalidate_lock.

Although the files tracked through uprobe are generally not modified, so
this should not cause a real stale page cache issue. However, I was
wandering why don't we just follow this rule?

Thanks,
Yi.

> [   29.328123]  uprobe_mmap+0x439/0xeb0
> [   29.328715]  ? __pfx_uprobe_mmap+0x10/0x10
> [   29.329391]  __mmap_region+0x8af/0x2290
> [   29.330074]  ? __pfx___mmap_region+0x10/0x10
> [   29.330793]  ? unwind_get_return_address+0x59/0xa0
> [   29.331630]  ? event_sched_in+0x33f/0xaf0
> [   29.332308]  ? perf_event_groups_next+0x9a/0x200
> [   29.333667]  ? mm_get_unmapped_area_vmflags+0x6c/0xe0
> [   29.335295]  ? mmap_region+0xd3/0x2b0
> [   29.336171]  do_mmap+0x98a/0xec0
> [   29.336713]  ? ipe_mmap_file+0xcf/0xe0
> [   29.337340]  ? __pfx_do_mmap+0x10/0x10
> [   29.337977]  ? __pfx_down_write_killable+0x10/0x10
> [   29.338757]  ? __pfx_mutex_unlock+0x10/0x10
> [   29.339477]  vm_mmap_pgoff+0x1b2/0x310
> [   29.340114]  ? __pfx_vm_mmap_pgoff+0x10/0x10
> [   29.340819]  ? __pfx___do_sys_perf_event_open+0x10/0x10
> [   29.341688]  ? fget+0x189/0x230
> [   29.342223]  ksys_mmap_pgoff+0x2b1/0x5b0
> [   29.342868]  ? __pfx_ksys_mmap_pgoff+0x10/0x10
> [   29.343618]  do_syscall_64+0xe2/0x560
> [   29.344246]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   29.345105] RIP: 0033:0x7fbe82832de2
> [   29.345707] Code: 00 00 00 0f 1f 44 00 00 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 3b 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76 5b 5d c3 0f 1f 00 48 8b 05 f9 8f 0d 00 64
> [   29.348851] RSP: 002b:00007ffd535f3b38 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
> [   29.350309] RAX: ffffffffffffffda RBX: 00007fbe826f9000 RCX: 00007fbe82832de2
> [   29.351526] RDX: 0000000000000004 RSI: 000000000000a000 RDI: 00007fbe826f9000
> [   29.352865] RBP: 0000000000000012 R08: 000000000000000b R09: 0000000000000000
> [   29.354136] R10: 0000000000000012 R11: 0000000000000206 R12: 00007ffd535f4120
> [   29.355357] R13: 0000000000000000 R14: 000000000000000b R15: 0000000000001000
> [   29.356684]  </TASK>
> [   29.357119] ---[ end trace 0000000000000000 ]---
> 
> The warning is triggered by TEST_F(merge, handle_uprobe_upon_merged_vma) in
> selftests/mm/merge.c. It occurs during the first mmap() following the
> __NR_perf_event_open syscall, as shown in the excerpt below:
> 
> TEST_F(merge, handle_uprobe_upon_merged_vma)
> {
> 	const size_t attr_sz = sizeof(struct perf_event_attr);
> 	unsigned int page_size = self->page_size;
> 	const char *probe_file = "./foo";
> 	char *carveout = self->carveout;
> 	struct perf_event_attr attr;
> 	unsigned long type;
> 	void *ptr1, *ptr2;
> 	int fd;
> 
> 	fd = open(probe_file, O_RDWR|O_CREAT, 0600);
> 	ASSERT_GE(fd, 0);
> 
> 	ASSERT_EQ(ftruncate(fd, page_size), 0);
> 	if (read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) != 0) {
> 		SKIP(goto out, "Failed to read uprobe sysfs file, skipping");
> 	}
> 
> 	memset(&attr, 0, attr_sz);
> 	attr.size = attr_sz;
> 	attr.type = type;
> 	attr.config1 = (__u64)(long)probe_file;
> 	attr.config2 = 0x0;
> 
> 	ASSERT_GE(syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0), 0);
> 
> 	ptr1 = mmap(&carveout[page_size], 10 * page_size, PROT_EXEC,
> 		    MAP_PRIVATE | MAP_FIXED, fd, 0); < WARNING!!!
> 	ASSERT_NE(ptr1, MAP_FAILED);
> 
> 	getchar();
> 
> 	ptr2 = mremap(ptr1, page_size, 2 * page_size,
> 		      MREMAP_MAYMOVE | MREMAP_FIXED, ptr1 + 5 * page_size);
> 	ASSERT_NE(ptr2, MAP_FAILED);
> 
> 	ASSERT_NE(mremap(ptr2, page_size, page_size,
> 			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr1), MAP_FAILED);
> 
> out:
> 	close(fd);
> 	remove(probe_file);
> }
> 
> The issue originates from the following call chain:
> 	prepare_uprobe
> 	  -> copy_insn
> 	       -> __copy_insn
> 		    -> read_mapping_page() or shmem_read_mapping_page()
> 
> Both read_mapping_page() and shmem_read_mapping_page() are invoked
> without holding i_rwsem or invalidate_lock. When CONFIG_EXT4_DEBUG
> is enabled, this triggers the warning in ext4_check_map_extents_env().
> 
> 
> 

