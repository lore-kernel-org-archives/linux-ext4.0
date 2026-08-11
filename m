Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66487203710
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 03:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786420549; cv=pass; b=EHgyGmkidI71w5lzRSmg7+5qptdTXqUacojpXvenNCb/0G94FcUM/tZ+S0PCHoBUeDCdyIFYWuuWMlj8KljFUBoMfPKvfxmAxp6N15jktJUl2AuqpA90BxV8flAE3nZUrGGbjCFLRp6Lu2g2Q3klyWseSu72U1Va4Y9e19KyiUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786420549; c=relaxed/simple;
	bh=Twg4FKHKaJxudO0QB/2kVgHJus4ff1/lz4GENIwiuRY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UQEQ1wjTIiyLgoCo9LXzpMfn6axbr9NPM6mRdF7u7wAUEeK7+gEbNHF3SJH5MP7mcH9KWT0rXj2d2brCX8Jf5fVpFTC8VE58g6n3t8upA9JC0XONdAOhjNRilyjf9gt78SuKjvb+z3kIacyrKxA02KnuV4OGlSj5cwpfMu8vENw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWbARoOx; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWbARoOx"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-52d56b08213so619951cf.1
        for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 20:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786420547; cv=none;
        d=google.com; s=arc-20260327;
        b=grXSz40Eqx7yPAeraGEomipqoge7zUzY5DLtWQdV7MWhwBAoIuK/D7YhROoSbpBJzL
         90lQzwaWdpWkRGlBKz9H9dcOYwf6fvA+kK5TsDbp05HNOMNorUbgPNmSxHowMeGvCCNP
         IeCpBOjv29CPkWuKu4q28NcKqIAyqaeEVihIl/1iwc+UqWGSdd24i4u3bldp9KNsbxKP
         AoBdKoiLed5+hgb24Q/U31HdI0NtACBSx9WVAEeXD+UwNWuMsAmGTi21YlW1Rb96DM7D
         jQ1QnXp2+Yx9bamtQdyhgc/GSV0n/yNCYMlJ9vSQ12JCnwR+x5Ie7ktx2w9jrbG7O5Au
         aSPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Twg4FKHKaJxudO0QB/2kVgHJus4ff1/lz4GENIwiuRY=;
        fh=REsBPymG8TuwTZkKVSitnSnqhzbukjMmbBnIjls3xXY=;
        b=iDBjlqvx3YDSsGZ4v0K6GWJLBC2vforo+eXoQxNs8CxEOsZEJ3jDq2gsezBTOM/u24
         +tUuQQNGVPkrGVGEPELC3Ia6//pssxfnVJZI+cSQ/nldV+nKYZGRghAWrb7WWmzx0uW2
         4T9XxxgGv6pLkK3b89Xs4xyhFbiS6fml8WE+o2G1AVHGlc3AAhy+UBS/b2GcaGO1WGcV
         rSUzuGHa4waLXTmyPr41uNjoQw2fwcbRoJ/+ZGuJSf4Th07ccHLRmLBLqcZU9LST5y9l
         jBCXjA6g43kLFID4vcDsJ9R68yTrN3YS4kNVaAlZEucLWTdDxhbhVnQtchbkkUf9mWXR
         xmVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786420547; x=1787025347; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Twg4FKHKaJxudO0QB/2kVgHJus4ff1/lz4GENIwiuRY=;
        b=aWbARoOxZw+Pcc0pOpzODcXzut2CghEv/XQRkVzs0medxRmpPPFgvup6bkcE5LAxO8
         EkKjt3nyVH1KwKHBx5Z7f9hBoFQQTsu9RGS+f9MGbaa+KRK3ccN6lcKIfn8A2e6T9+vV
         PprDxcwTr+1jtM6pGOowYJ8mCotz6+2JWja5oeYaIFQSuIqz5U0cubBq4iLTD3GyJXjz
         +ivR7OZEL5TNRP+SmxC2TqQctsN2B40F/R8GUXI0V5bL5b/QmqYnsi+mn80J7VG9EHYT
         OkOb+zF1NxtZoGYUDinzu+EziG4yI/w/iXCVJ4/vhoD2uFprZ6NxYWLY6PsLRlo06aEX
         331A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786420547; x=1787025347;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Twg4FKHKaJxudO0QB/2kVgHJus4ff1/lz4GENIwiuRY=;
        b=eD7fuELxRSQKjP4eZDRWkN0dyMkytVQH5z8xx1gCNPzD1Atr94bYljEIf7yH4THw/r
         GVGIfBOsK51YYQzJloU6aPGsEReeMn8rsj+GP2v2oneJrti+BfMFZVH3m+E+JDZcC9qU
         6nnJ+UzEcAWRMPRvYjNbfUUaMcYR04+EvszHWKvuM+FCyuOEE8MzWuS6D79BKwQCBqxv
         U+nKEDY0/I08onDvkBVS00NgBRSJM22cp+0FexvYEJKpg6FBXThW4IuojRymGzHblIAh
         L0sggp6nKFCgnT7VXG0r/2U7QNun/5ChjcHD2iMghltu8kUZEdGaExX5dihLejntJxma
         tiWw==
X-Forwarded-Encrypted: i=1; AHgh+RpGxcKc46yuJzv8OjFAFlU8DxA7nboj9U7EUEwelzcaxmM630IWL9c78R6MfeL3K9s6FQpm0bc6w510@vger.kernel.org
X-Gm-Message-State: AOJu0YxlYYgICa+iAcBK4ikOkF1bNzfMOslGmJYdsZP4KEu9QOWCGNVd
	7J+2VjLfMNW/UmqWsb+mTI5IHBMv5dhUZ2+CmD3A/M/jWPjt7rtf9iKuVXYtrsDcNceqsgEEBDw
	ZtYbfDznVkoqew9B2Pdp+zRwVc3t0QRA=
X-Gm-Gg: AR+sD11M1+6BP7jUQlljKtPajQsBrAu/ZQ4i5qrgK2pBwuHTGZekSNLePC/6DKgISoy
	qyrcm3FNmML6MyXfVaNDHuLpy4OAUtU0/ofw5fSpdHg9R0rOOLO5kmku36pW8OJoa6ZUHe6cEXY
	ZwUIJt1tOnob4m0RCk/m9QEpkT+AG6AqE4JZeuYycqt46STJ8gMtRQbEFHzA1Ldvi0OU5VNyIE0
	dku4FqEf9XmNKhrPehbkZkCRrGtO/mTBQp/6qAl2PFw0Nc7CUN4jbAX7lE0Ae/3vvvgr7TzCfE6
	I83TbusXEgMkVj1asorsrhwHeYbQamrXhMItWDtwqBgXfL6N3xp+VgZb
X-Received: by 2002:a05:622a:53c5:b0:517:87a9:6a89 with SMTP id
 d75a77b69052e-52d59a6f6bdmr414011cf.6.1786420547092; Mon, 10 Aug 2026
 20:55:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Tue, 11 Aug 2026 11:55:35 +0800
X-Gm-Features: AUfX_mxZO6Y4b595eRcGrTf3oPH6xp4RrNe-szRvDYFRVos6ky3X2KR08ZYEKTY
Message-ID: <CAA2SOT5a_Lo4E7nWNoWk9Re5dx-vYDmQpCi_8cJjVps7DDL-rQ@mail.gmail.com>
Subject: [BUG] ext4: possible circular locking dependency between xattr_sem
 and s_writepages_rwsem
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a possible circular locking dependency triggered by a
syzkaller reproducer on Linux 7.2-rc3.

The warning is reported by lockdep in the ext4 writeback / xattr path.
The task is mounting a crafted ext4 image and enters orphan cleanup
during ext4_fill_super(). During inode eviction, ext4_evict_inode()
calls __ext4_mark_inode_dirty(), which holds &ei->xattr_sem. The same
path then reaches ext4_xattr_block_set(), iput(), write_inode_now(),
writeback_single_inode(), do_writepages(), and finally
ext4_writepages(), where it tries to acquire &sbi->s_writepages_rwsem.

Lockdep reports that this creates a circular dependency, because
another dependency chain already exists in the reverse order:
ext4_writepages() / ext4_do_writepages() can acquire
&sbi->s_writepages_rwsem first and later acquire &ei->xattr_sem
through ext4_destroy_inline_data().

This looks like a potential ext4 lock-ordering issue between inode
xattr expansion / inline-data handling and writeback during mount-time
orphan cleanup, rather than a generic VFS or lockdep issue.

Reproducer:
syz reproducer: https://pastebin.com/raw/FspxvagG
console output: https://pastebin.com/raw/kQeWyFgs
kernel config: https://pastebin.com/raw/XUJkfYA0

Kernel:
kernel version: 7.2.0-rc3 #1 PREEMPT(full)
HEAD commit: 1137d8b5df06137fb49513cc923b3b24d94cb809
environment: QEMU Ubuntu 24.10
taint: Not tainted

Relevant warning:

WARNING: possible circular locking dependency detected
7.2.0-rc3 #1 Not tainted

syz.4.27/12346 is trying to acquire lock:
&sbi->s_writepages_rwsem, at: do_writepages+0x241/0x5b0

but task is already holding lock:
&ei->xattr_sem, at: __ext4_mark_inode_dirty+0x5c6/0x860

Existing dependency chain:

-> #1 (&ei->xattr_sem):
down_write
ext4_destroy_inline_data
ext4_do_writepages
ext4_writepages
do_writepages
filemap_writeback
file_write_and_wait_range
mmb_fsync_noflush
ext4_fsync_nojournal
ext4_sync_file
vfs_fsync_range
ext4_buffered_write_iter
ext4_file_write_iter
vfs_write
ksys_pwrite64

-> #0 (&sbi->s_writepages_rwsem):
ext4_writepages
do_writepages
__writeback_single_inode
writeback_single_inode
write_inode_now
iput
ext4_xattr_block_set
ext4_expand_extra_isize_ea
__ext4_expand_extra_isize
__ext4_mark_inode_dirty
ext4_evict_inode
evict
iput
ext4_orphan_cleanup
ext4_fill_super
get_tree_bdev_flags
vfs_get_tree
fc_mount
path_mount
do_mount
__x64_sys_mount

Lockdep also reports the following possible unsafe locking scenario:

CPU0 CPU1

lock(&ei->xattr_sem);
lock(&sbi->s_writepages_rwsem);
lock(&ei->xattr_sem);
rlock(&sbi->s_writepages_rwsem);

*** DEADLOCK ***

The reproducer mounts crafted ext4 images with options including
grpid, auto_da_alloc, lazytime, dioread_nolock, init_itable,
debug_want_extra_isize, bsdgroups, and min_batch_time, and then
performs a pwrite64() before mounting another crafted ext4 image. The
log also shows ext4 metadata errors before the warning, including
invalid indirect mapped block, invalid block bitmap, delayed block
allocation failures, and bad extra_isize, which appear to drive the
mount/orphan-cleanup and xattr expansion paths.

Thanks
