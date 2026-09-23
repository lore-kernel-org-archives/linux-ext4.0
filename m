Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8299F36A342
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 11:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161984; cv=none; b=CiG52hf/IbxpUid7QSFRlCl2e11DGgMXiPkMsBuxl9LbKmESy/o63WGL2Vpkw5ArM0HXggghyu3Ye60mA1etFUJpUtCa/OjVWN6YBpJwsxOkv0hmte/XRfnuW4OLcCEqAPHQg7AjdFdka6mFFRBQb9HhM61lv1UJWVme7nQ4AoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161984; c=relaxed/simple;
	bh=I1VPha1h/129D0VO7tx4zSRxRoS9a0rUYi9Sj6NL4RM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RvYG/xaQlIkTUQmbWOM/r6j6S/WvVvHK3j4gtz8OY8+ad59ihu+mq+ltM1hGSM3cbQ73zHot8MC7JmiEpDN0j5UyOpB4ZG0AJCgaGfbYkxq/Pj49oJAjPE0VBZKLeT8AzQ2nEGKnt4KPIUPRdxuQRJTpVIweeAnHCTxZjDcf/wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=Z+f2CG77; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="Z+f2CG77"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:From:
	Reply-To; bh=tr2RJ9rGBLQuqNg+y3LzKDrB2BKqyXWnr/YIoAAMX/Y=; b=Z+f2CG77jKofa+P+
	GzEbVlySha+O4upj3HBjBWYVNh3H3geYNGRRqOplZSMrJ766kAA2ucEA/ibdvQ5+3Ghi/MaSSN+ky
	O8bBMhZmlXmGgl68isDL3SbM3l5aVNpMJw4sqNVb9Kgik3L4czkyBpgGMmP5A+phL3GasTBQVpgi+
	RBA0jTfklYr2Ip6aTDjEmg9SOYZlhII0Co6w0CFxH3D/ZYOXX/fT9NPeTJVpQUQjoNhIsAwQM+XQg
	CSSO1ZYl47sP7V4zPjJE9D5eTzA/Fbfyo7JrBmQHZmd5ksrKUaSLXebu7NMmI9FXMPIFU3VX0/cvZ
	4e6Uq92t7Um13gWHbg==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x9Ku1-0066M6-Re; Wed, 23 Sep 2026 13:12:41 +0200
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1x9Ku0-00846v-Gx; Wed, 23 Sep 2026 13:12:41 +0200
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1x9Ku0-004oHO-19;
	Wed, 23 Sep 2026 11:12:40 +0000
Date: Wed, 23 Sep 2026 13:12:40 +0200
From: Alberto Garcia <berto@igalia.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <arO0KE9_Jf8rNRwN@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Report: NO, Score=-2.1, Tests=ALL_TRUSTED=-3,BAYES_50=0.8,KAM_DMARC_NONE=0.125,KAM_DMARC_STATUS=0.005
X-Spam-Score: -20
X-Spam-Bar: --

Hi,

I'd like to report a bug in the ext4 code. I confirm that it happens
with the latest stable kernel (7.2.7), but mainline (7.3-rc4) does not
seem to be affected.

The problem is very easy to reproduce:

1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
2) Create an empty directory and encrypt it (fscrypt encrypt /foo or whatever).
3) Write some data to it (head -c head -c 10M /dev/urandom > /foo/file.bin)
4) sync

[   42.962615] BUG: kernel NULL pointer dereference, address: 0000000000000028
[   42.965440] #PF: supervisor read access in kernel mode
[   42.967480] #PF: error_code(0x0000) - not-present page
[   42.969475] PGD 0 P4D 0 
[   42.970460] Oops: Oops: 0000 [#1] SMP NOPTI
[   42.972141] CPU: 0 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 7.2.7-vanilla #2 PREEMPT(lazy) 
[   42.975502] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   42.977650] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
[   42.978499] RIP: 0010:ext4_finish_bio+0xf8/0x400
[   42.979452] Code: 38 00 00 00 00 48 8b 44 24 08 4c 01 f8 48 89 04 24 48 83 7b 18 00 0f 84 d7 02 00 00 41 0f b6 7d 1a 40 84 ff 0f 85 7d 02 00 00 <4c> 8b 63 28 45 31 f6 49 8d 44 24 5c 48 89 c7 48 89 44 24 20 e8 6f
[   42.982351] RSP: 0018:ffffd0290006bd40 EFLAGS: 00010246
[   42.983090] RAX: 0000000000001000 RBX: 0000000000000000 RCX: 000fffffc0000201
[   42.984204] RDX: fffff64a40226f00 RSI: fffff64a400afcc0 RDI: 0000000000000000
[   42.985203] RBP: 0000000000001000 R08: 0000000000001000 R09: ffffffff8a49cb8a
[   42.986203] R10: 0000000000001fff R11: ffff8b4f81926200 R12: ffff8b4f8521b540
[   42.987213] R13: ffff8b4f81927f00 R14: 0000000000000001 R15: 0000000000000000
[   42.988351] FS:  0000000000000000(0000) GS:ffff8b507105e000(0000) knlGS:0000000000000000
[   42.989478] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.990292] CR2: 0000000000000028 CR3: 000000000bcb9000 CR4: 0000000000350ef0
[   42.991291] Call Trace:
[   42.991709]  <TASK>
[   42.992042]  ext4_release_io_end+0x55/0x120
[   42.992650]  ext4_end_io_end+0x4c/0xe0
[   42.993194]  ext4_end_io_rsv_work+0xaa/0x100
[   42.993807]  process_one_work+0x19e/0x370
[   42.994382]  worker_thread+0x1a6/0x310
[   42.994925]  ? __pfx_worker_thread+0x10/0x10
[   42.995806]  kthread+0xe4/0x120
[   42.996313]  ? __pfx_kthread+0x10/0x10
[   42.996856]  ret_from_fork+0x2b1/0x340
[   42.997397]  ? __pfx_kthread+0x10/0x10
[   42.997941]  ret_from_fork_asm+0x1a/0x30
[   42.998505]  </TASK>

The problem does not happen if you unmount the filesystem after
setting the encryption feature, and then mount it again.

The cause seems to be that encryption does not support large folios,
but after commit 709f0f1f1bf5c ("ext4: add checks for large folio
incompatibilities when BS > PS") this is only checked at mount time,
so enabling encryption on a mounted fs bypasses this check.

This solves the crash for me, but I suppose that it also needs an
additional check to decide whether encryption can be enabled on a
filesystem (i.e. if sb->s_blocksize > PAGE_SIZE).

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5287,7 +5287,8 @@ void ext4_set_inode_mapping_order(struct inode *inode)
 	if (!min_order && !S_ISREG(inode->i_mode))
 		return;
 
-	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) ||
+	    ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT))
 		max_order = min_order;
 
 	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);

Regards,

Berto
