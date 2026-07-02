Received: from mail-qv2-f0.google.com (mail-qv2-f0.google.com [74.125.230.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20AB3D5252
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 08:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782979204; cv=pass; b=sFyboyaXyxwV3+GngtpWHldvlq7w5aCET58jbxk0KrbJR1jYBBoeV9IgJ9Dh8ZAdVEdteC2WMXZCXS4i1DIyhVS04mujoBLcdQHEVqTRcSmRekN/H1lkM19Ki6CKeAxIhWazXq8ME+KKt8KXXMJ+ti/mxyDVTktWMQegpcP3QNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782979204; c=relaxed/simple;
	bh=fMNVHl26jzAGhhqWu5URdspFsX2crNxhEW/pe6iBQAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=cQm4+Ls8jdf7+sS+UduK187CSGkxOaihLWdUTwLv08qRv/DBPS3k02zf8NaVVO2gz1oeGI8+MM2VrinwkTQtHRJtoMuh1h31yKaoBja1yRcaygmvSMrF549/knP+/DzSEeUxtVNrELqNWUgPHSKCVE1bptsWaUiwNp1zqIt2KU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjYDegem; arc=pass smtp.client-ip=74.125.230.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjYDegem"
Received: by mail-qv2-f0.google.com with SMTP id 6a1803df08f44-8e89378a3d0so6501176d6.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 01:00:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782979202; cv=none;
        d=google.com; s=arc-20260327;
        b=I49x1HPg0zMgHy0acYyqqK5X+/0NdES/5WG8ogxDmudaEpIocDch+CrS6WBuplyKOW
         LZ18h5B4+4dChLSP/5QtPAIkIvnFeNda6AlmhelwXu4bqnD9dmGT+y4WMDWPa2wth2G1
         fV1lLCDJba+y8kC1WTYGR09l09VAdsBfMpkSgVSpFtxxkoUkSW2qzSohY/S5QfEMZXBy
         pE0Mfw26KpoNAc/bie2YO161eMirlgg9Ib8b/lOuIoF/9Dew+aUCgCvXaIFWBbNW5sCr
         IX8tVmMMpKxV4vNF+Ow6KF7c8msWgoqUOx91o7FSb5i+CXQZRxHxs9PfwxxET/R08KFR
         7esA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=3zRguFLETQxjbmMVsegKMYibB8WCDSZ+gax0ANW7yYw=;
        fh=I5PN7UjtXnoRC8RNFZvdjQlYCHXoJNEXN+cp8mHfIgk=;
        b=PoZ4rRjSXsT09hz3ry7TRG4Nr0J/wNOnz2pUFytLPMjISrQbX9Co7DIa2DeYvt6lbv
         WhDwfyCimFfLntbKHjbf/flcXQxY+nN1TfERQm/bhMkD3UOdP1wu88zeFx/0su5tTQBF
         ATndSE1YceyTu34IXlWJCOGSx2SZWTEoQZ7B4pZ/xdxPNrnIcOWEowc8s+mOJ2+Byh9a
         pNgshQ4uTDUKynDMlwc9QgJTGTno4IYJBq1tIcVdwZ1K07s5sFApo9nu63mgZk0mV7zs
         V/gRYFw5ELFJZ9532Y9f7qXu1BiPggI9aIwiqLvdOHZyek2AGVsxVOvadmKdwk49pGKo
         QYSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782979202; x=1783584002; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3zRguFLETQxjbmMVsegKMYibB8WCDSZ+gax0ANW7yYw=;
        b=LjYDegemq3NhV9/kzfE6+0swW0NyWcf/ffVSymLFHph3+n3KvdCHVyth5SvHCh8ONw
         WwPTn/JPmxU+MttDOUYL6p5YMqkD/H4HYJ1xBQH5S1HofiPokF/8wJPoho9rNKczZULP
         A8c9NTbvBfs+hd5N7Ptg8OeCUemrZT5Xe+c/YZMRg6If6XUxkY97GrJ0nz4UxFomSalL
         ZtbShpCZChGKchq4d9aTfUPTz4VI5BDxStkMnYWnADQSkSgAkECi2rEmo7ck2A4WGHTG
         1KMJj7RAcUeVQh15SlSknj3pep5PAa3RI/qXIqu2EIHfb60XLE02HRRSl2CrHdLQRJd2
         xjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782979202; x=1783584002;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3zRguFLETQxjbmMVsegKMYibB8WCDSZ+gax0ANW7yYw=;
        b=XO6DF2QIbSY3WFyLascMF9J2BifqNrD6Ccxi2DotUQizo8uyyYUxXk5uSC42fDH64E
         9Tghl1QMo9avqhMVMllZ7bEpSYq7fD3j3kCEJ2xooDdMrCkolKU0El3oqEoQBsB59VQS
         jCDGc+fvM2Hg79fQmtCZHqpudcz0ieARFLLcSDM+aWAUIAYzxSMGB9kabft0dMbG/7C7
         n1GAnY0+o2/+cVum+H5XY5Ax3H5Ew7nN3DEUwz7NV6fNRhYX5SW9BB8b3fAUSJ4Arwtv
         VmD5Cc1KF7vB8IB4nuwU7T+R3m1MUfpKTUdyh/Kkxh9kPC6LegZsMPfIcwMI3zehZq9+
         zBig==
X-Forwarded-Encrypted: i=1; AFNElJ9n6hms3WB8bNx0kKhjgxn/CBGYTG3xMVJg97WWhPVRp7ubENm+hEcwo8E10JoRACTnEHefsdqSMxqQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+IIXtVEjwWrYjDOgHIHGqP8fdJUecZh9qVXMLL36gdY1JPAJH
	LEoKI5Q+iSReMVFcuffh35XoMgOfdAP1qmbRJUkin/41a7ugy9H6rV6xMxnkwPGODzMIzfuCj5z
	fgquPEFzFxX63mleG8y53vd9DG7af81Za3wUwt4JclCoE
X-Gm-Gg: AfdE7ckrZHq5GS+v6c2rLJnFkgr7/UAIQoMROMWOsSzYqdsSzypGH66c7MAo51AgVI2
	MX6Jj005NSXxn2c1gy3pdlKVdUz/LZGfDAhqX8c88bjtDUR+SR7kxRV1YJAm1XrDRz6KGQdDd3z
	Aa6+DXEGYg6sNWuyvxOA2Relgy/nMb0mkOVfH2NUBxT9mPs7jnnMx0Wk7ZeKhhjcluHZozv0mps
	GNqdOK2rd9pF1Xsi5aJkm+GqlVhZhpyTJ6/TxF6b3OE/dHmWot+4ByRiKf3lVSWFVt8WuohqpYC
	Q1rPQCEo6ggHGWk41REq
X-Received: by 2002:a05:622a:180d:b0:51a:86f1:5354 with SMTP id
 d75a77b69052e-51c26aef619mr57983271cf.46.1782979201446; Thu, 02 Jul 2026
 01:00:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
 <CAHPqNmzacLWxDM4CSyEorgyh1tEyBfeOVr2gwUvUrtjZRCuh7A@mail.gmail.com> <20260630131011.67546c6e472150e22c3e7c7c@linux-foundation.org>
In-Reply-To: <20260630131011.67546c6e472150e22c3e7c7c@linux-foundation.org>
From: Longxing Li <coregee2000@gmail.com>
Date: Thu, 2 Jul 2026 15:59:48 +0800
X-Gm-Features: AVVi8Cf688C5wvcYC5zc0Dsq-nx4AJL_LVDeIxpScNSuKXwbykYW_56A8G7GrmQ
Message-ID: <CAHPqNmwSgLNVPycS5DCBJe0fiBhOzccBR6_A7wKUQCKQ4QeQyg@mail.gmail.com>
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in filemap_free_folio
To: Andrew Morton <akpm@linux-foundation.org>, syzkaller@googlegroups.com, 
	willy@infradead.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000f1d83006559c31d9"

--000000000000f1d83006559c31d9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear maintainers,

I'm trying to fix this issue. The bug analysis and patch fix are as follows=
.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Bug Summary

ext4_add_complete_io() queues i_rsv_conversion_work without holding an
extra inode reference. If the inode is unlinked & evicted before the
delayed work runs, ext4_do_flush_completed_IO() accesses a freed inode =E2=
=80=94
use-after-free.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Fix

Take igrab(inode) when first queueing the work (detected via
list_empty check), and iput() after processing in
ext4_do_flush_completed_IO(). A per-inode bit (i_rsv_need_iput) tracks
whether the reference was taken.

Changes:
  fs/ext4/ext4.h      - add i_rsv_need_iput bit to struct ext4_inode_info
  fs/ext4/super.c     - init the bit to 0 in ext4_alloc_inode()
  fs/ext4/page-io.c   - igrab() before queue_work, iput() after flush

Full patch is as follows and is attached in the link.

Best regards,
Longxing Li

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Patch: (Standard format patch Please see atachment and the link after
this chunk.)
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 30 Jun 2026
Subject: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion

ext4_add_complete_io() queues the inode's i_rsv_conversion_work without
holding an extra reference to the inode. If the inode is unlinked and
evicted before the delayed work runs, the inode slab object is freed.
When ext4_do_flush_completed_IO() later accesses io_end->inode, it is
accessing a freed/reallocated object =E2=80=94 a use-after-free detected by=
 KASAN.

Fix: take an inode reference in ext4_add_complete_io() (when first queueing
the work), and drop it in ext4_do_flush_completed_IO() after processing
all io_ends. A per-inode flag tracks whether the extra reference was taken.

Signed-off-by: Longxing Li <coregee2000@gmail.com>
---

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1158,10 +1158,12 @@
 #endif
     spinlock_t i_block_reservation_lock;

     /* Lock protecting lists below */
     spinlock_t i_completed_io_lock;
+    /* Track if ext4_add_complete_io() took an extra inode reference. */
+    unsigned short i_rsv_need_iput:1;
     /*
      * Completed IOs that need unwritten extents handling and have
      * transaction reserved
      */
     struct list_head i_rsv_conversion_list;

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1414,10 +1414,11 @@
     memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
     ei->jinode =3D NULL;
     INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
     spin_lock_init(&ei->i_completed_io_lock);
+    ei->i_rsv_need_iput =3D 0;
     ei->i_sync_tid =3D 0;
     ei->i_datasync_tid =3D 0;
     INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
     ext4_fc_init_inode(&ei->vfs_inode);
     spin_lock_init(&ei->i_fc_lock);

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -260,12 +260,16 @@
         !io_end->handle && sbi->s_journal);
     WARN_ON(!io_end->bio);

     spin_lock_irqsave(&ei->i_completed_io_lock, flags);
     wq =3D sbi->rsv_conversion_wq;
-    if (list_empty(&ei->i_rsv_conversion_list))
-        queue_work(wq, &ei->i_rsv_conversion_work);
+    if (list_empty(&ei->i_rsv_conversion_list)) {
+        if (igrab(io_end->inode)) {
+            ei->i_rsv_need_iput =3D 1;
+            queue_work(wq, &ei->i_rsv_conversion_work);
+        }
+    }
     list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
     spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }

 static int ext4_do_flush_completed_IO(struct inode *inode,
@@ -289,10 +293,17 @@

         err =3D ext4_end_io_end(io_end);
         if (unlikely(!ret && err))
             ret =3D err;
     }
+
+    /* Release inode reference from ext4_add_complete_io. */
+    if (ei->i_rsv_need_iput) {
+        ei->i_rsv_need_iput =3D 0;
+        iput(&ei->vfs_inode);
+    }
+
     return ret;
 }

 /*
  * Used to convert unwritten extents to written extents upon IO completion=
,

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Attachment:
https://drive.google.com/file/d/1rPdp91vPxDnc74LxOJcJV3juvWhRxUtR/view?usp=
=3Ddrive_link


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Original Bug Report on Linux kernel v6.18.2:
BUG: KASAN: slab-use-after-free in filemap_free_folio+0x147/0x170
mm/filemap.c:234
Read of size 8 at addr ffff88805e6535a8 by task kworker/u9:28/46327

CPU: 1 UID: 0 PID: 46327 Comm: kworker/u9:28 Not tainted 6.18.2 #1 PREEMPT(=
full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014
Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x630 mm/kasan/report.c:482
 kasan_report+0xe0/0x110 mm/kasan/report.c:595
 filemap_free_folio+0x147/0x170 mm/filemap.c:234
 folio_unmap_invalidate+0x514/0x850 mm/truncate.c:653
 filemap_end_dropbehind+0x17f/0x1d0 mm/filemap.c:1616
 folio_end_dropbehind mm/filemap.c:1637 [inline]
 folio_end_dropbehind+0xbe/0xe0 mm/filemap.c:1624
 folio_end_writeback+0xe4/0x1f0 mm/filemap.c:1695
 ext4_finish_bio+0x78f/0xa20 fs/ext4/page-io.c:144
 ext4_release_io_end+0x119/0x3a0 fs/ext4/page-io.c:159
 ext4_end_io_end+0x13e/0x4a0 fs/ext4/page-io.c:210
 ext4_do_flush_completed_IO fs/ext4/page-io.c:290 [inline]
 ext4_end_io_rsv_work+0x205/0x380 fs/ext4/page-io.c:305
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
 process_scheduled_works kernel/workqueue.c:3346 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 49607:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_lru_noprof+0x254/0x6e0 mm/slub.c:5307
 ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393
 alloc_inode+0x64/0x240 fs/inode.c:346
 new_inode+0x22/0x1c0 fs/inode.c:1145
 __ext4_new_inode+0x392/0x4f00 fs/ext4/ialloc.c:961
 ext4_create+0x303/0x550 fs/ext4/namei.c:2822
 lookup_open.isra.0+0x11d3/0x1580 fs/namei.c:3796
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x893/0x2cb0 fs/namei.c:4131
 do_filp_open+0x20b/0x470 fs/namei.c:4161
 do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x174/0x210 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 49611:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 __kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2543 [inline]
 slab_free mm/slub.c:6642 [inline]
 kmem_cache_free+0x2d4/0x6c0 mm/slub.c:6752
 i_callback+0x46/0x70 fs/inode.c:325
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0x79c/0x1530 kernel/rcu/tree.c:2861
 handle_softirqs+0x219/0x8e0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline=
]
 sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1052
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:=
697

Last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:559
 __call_rcu_common.constprop.0+0xa5/0xa10 kernel/rcu/tree.c:3123
 destroy_inode+0x12c/0x1b0 fs/inode.c:401
 evict+0x5b4/0x920 fs/inode.c:834
 iput_final fs/inode.c:1914 [inline]
 iput.part.0+0x6a9/0xb00 fs/inode.c:1966
 iput+0x35/0x40 fs/inode.c:1929
 do_unlinkat+0x518/0x6a0 fs/namei.c:4744
 __do_sys_unlink fs/namei.c:4783 [inline]
 __se_sys_unlink fs/namei.c:4781 [inline]
 __x64_sys_unlink+0xc5/0x110 fs/namei.c:4781
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Second to last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:559
 insert_work+0x36/0x230 kernel/workqueue.c:2186
 __queue_work+0x97e/0x1160 kernel/workqueue.c:2341
 queue_work_on+0x15f/0x1f0 kernel/workqueue.c:2392
 queue_work include/linux/workqueue.h:669 [inline]
 ext4_add_complete_io fs/ext4/page-io.c:266 [inline]
 ext4_put_io_end_defer fs/ext4/page-io.c:325 [inline]
 ext4_put_io_end_defer+0x398/0x460 fs/ext4/page-io.c:321
 ext4_end_bio+0x2bc/0x580 fs/ext4/page-io.c:385
 bio_endio+0x713/0x860 block/bio.c:1672
 blk_update_request+0x93e/0x15f0 block/blk-mq.c:999
 scsi_end_request+0x7c/0x9c0 drivers/scsi/scsi_lib.c:637
 scsi_io_completion+0x17d/0x14c0 drivers/scsi/scsi_lib.c:1078
 scsi_complete+0x124/0x250 drivers/scsi/scsi_lib.c:1547
 blk_complete_reqs+0xb1/0xf0 block/blk-mq.c:1236
 handle_softirqs+0x219/0x8e0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
 sysvec_call_function_single+0x57/0xc0 arch/x86/kernel/smp.c:266
 asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:=
704

The buggy address belongs to the object at ffff88805e652fd0
 which belongs to the cache ext4_inode_cache of size 2320
The buggy address is located 1496 bytes inside of
 freed 2320-byte region [ffff88805e652fd0, ffff88805e6538e0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5e650
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8880268b4801
flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff888101bc3a00 ffffea0001822400 dead000000000002
raw: 0000000000000000 00000000000d000d 00000000f5000000 ffff8880268b4801
head: 00fff00000000040 ffff888101bc3a00 ffffea0001822400 dead000000000002
head: 0000000000000000 00000000000d000d 00000000f5000000 ffff8880268b4801
head: 00fff00000000003 ffffea0001799401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Reclaimable, gfp_mask
0xd2050(__GFP_RECLAIMABLE|__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__=
GFP_NOMEMALLOC),
pid 15633, tgid 15633 (syz-executor.7), ts 460463106471, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1af/0x220 mm/page_alloc.c:1845
 prep_new_page mm/page_alloc.c:1853 [inline]
 get_page_from_freelist+0x10a3/0x3a30 mm/page_alloc.c:3879
 __alloc_frozen_pages_noprof+0x25f/0x2470 mm/page_alloc.c:5178
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3059 [inline]
 allocate_slab mm/slub.c:3232 [inline]
 new_slab+0x24a/0x360 mm/slub.c:3286
 ___slab_alloc+0xd79/0x1a50 mm/slub.c:4655
 __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4778
 __slab_alloc_node mm/slub.c:4854 [inline]
 slab_alloc_node mm/slub.c:5276 [inline]
 kmem_cache_alloc_lru_noprof+0x443/0x6e0 mm/slub.c:5307
 ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393
 alloc_inode+0x64/0x240 fs/inode.c:346
 new_inode+0x22/0x1c0 fs/inode.c:1145
 __ext4_new_inode+0x392/0x4f00 fs/ext4/ialloc.c:961
 ext4_symlink+0x462/0xde0 fs/ext4/namei.c:3388
 vfs_symlink fs/namei.c:4817 [inline]
 vfs_symlink+0x403/0x680 fs/namei.c:4801
 do_symlinkat+0x261/0x310 fs/namei.c:4843
 __do_sys_symlinkat fs/namei.c:4859 [inline]
 __se_sys_symlinkat fs/namei.c:4856 [inline]
 __x64_sys_symlinkat+0x93/0xc0 fs/namei.c:4856
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88805e653480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805e653500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88805e653580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88805e653600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805e653680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--000000000000f1d83006559c31d9
Content-Type: text/plain; charset="UTF-8"; name="bug-fix.patch.txt"
Content-Disposition: attachment; filename="bug-fix.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mr37ltsy0>
X-Attachment-Id: f_mr37ltsy0

RnJvbTogTG9uZ3hpbmcgTGkgPGNvcmVnZWUyMDAwQGdtYWlsLmNvbT4KRGF0ZTogVHVlLCAzMCBK
dW4gMjAyNgpTdWJqZWN0OiBbUEFUQ0hdIGV4dDQ6IGZpeCB1c2UtYWZ0ZXItZnJlZSBpbiBleHQ0
IGRlbGF5ZWQgSS9PIGNvbXBsZXRpb24KCmV4dDRfYWRkX2NvbXBsZXRlX2lvKCkgcXVldWVzIHRo
ZSBpbm9kZSdzIGlfcnN2X2NvbnZlcnNpb25fd29yayB3aXRob3V0CmhvbGRpbmcgYW4gZXh0cmEg
cmVmZXJlbmNlIHRvIHRoZSBpbm9kZS4gSWYgdGhlIGlub2RlIGlzIHVubGlua2VkIGFuZApldmlj
dGVkIGJlZm9yZSB0aGUgZGVsYXllZCB3b3JrIHJ1bnMsIHRoZSBpbm9kZSBzbGFiIG9iamVjdCBp
cyBmcmVlZC4KV2hlbiBleHQ0X2RvX2ZsdXNoX2NvbXBsZXRlZF9JTygpIGxhdGVyIGFjY2Vzc2Vz
IGlvX2VuZC0+aW5vZGUsIGl0IGlzCmFjY2Vzc2luZyBhIGZyZWVkL3JlYWxsb2NhdGVkIG9iamVj
dCDigJQgYSB1c2UtYWZ0ZXItZnJlZSBkZXRlY3RlZCBieSBLQVNBTi4KCkZpeDogdGFrZSBhbiBp
bm9kZSByZWZlcmVuY2UgaW4gZXh0NF9hZGRfY29tcGxldGVfaW8oKSAod2hlbiBmaXJzdCBxdWV1
ZWluZwp0aGUgd29yayksIGFuZCBkcm9wIGl0IGluIGV4dDRfZG9fZmx1c2hfY29tcGxldGVkX0lP
KCkgYWZ0ZXIgcHJvY2Vzc2luZwphbGwgaW9fZW5kcy4gQSBwZXItaW5vZGUgZmxhZyB0cmFja3Mg
d2hldGhlciB0aGUgZXh0cmEgcmVmZXJlbmNlIHdhcyB0YWtlbi4KClJlcG9ydGVkLWJ5OiBzeXpr
YWxsZXIKU2lnbmVkLW9mZi1ieTogTG9uZ3hpbmcgTGkgPGNvcmVnZWUyMDAwQGdtYWlsLmNvbT4K
LS0tCgotLS0gYS9mcy9leHQ0L2V4dDQuaAorKysgYi9mcy9leHQ0L2V4dDQuaApAQCAtMTE1OCwx
MCArMTE1OCwxMiBAQAogI2VuZGlmCiAJc3BpbmxvY2tfdCBpX2Jsb2NrX3Jlc2VydmF0aW9uX2xv
Y2s7CiAKIAkvKiBMb2NrIHByb3RlY3RpbmcgbGlzdHMgYmVsb3cgKi8KIAlzcGlubG9ja190IGlf
Y29tcGxldGVkX2lvX2xvY2s7CisJLyogVHJhY2sgaWYgZXh0NF9hZGRfY29tcGxldGVfaW8oKSB0
b29rIGFuIGV4dHJhIGlub2RlIHJlZmVyZW5jZS4gKi8KKwl1bnNpZ25lZCBzaG9ydCBpX3Jzdl9u
ZWVkX2lwdXQ6MTsKIAkvKgogCSAqIENvbXBsZXRlZCBJT3MgdGhhdCBuZWVkIHVud3JpdHRlbiBl
eHRlbnRzIGhhbmRsaW5nIGFuZCBoYXZlCiAJICogdHJhbnNhY3Rpb24gcmVzZXJ2ZWQKIAkgKi8K
IAlzdHJ1Y3QgbGlzdF9oZWFkIGlfcnN2X2NvbnZlcnNpb25fbGlzdDsKCi0tLSBhL2ZzL2V4dDQv
c3VwZXIuYworKysgYi9mcy9leHQ0L3N1cGVyLmMKQEAgLTE0MTQsMTAgKzE0MTQsMTEgQEAKIAlt
ZW1zZXQoJmVpLT5pX2RxdW90LCAwLCBzaXplb2YoZWktPmlfZHF1b3QpKTsKICNlbmRpZgogCWVp
LT5qaW5vZGUgPSBOVUxMOwogCUlOSVRfTElTVF9IRUFEKCZlaS0+aV9yc3ZfY29udmVyc2lvbl9s
aXN0KTsKIAlzcGluX2xvY2tfaW5pdCgmZWktPmlfY29tcGxldGVkX2lvX2xvY2spOworCWVpLT5p
X3Jzdl9uZWVkX2lwdXQgPSAwOwogCWVpLT5pX3N5bmNfdGlkID0gMDsKIAllaS0+aV9kYXRhc3lu
Y190aWQgPSAwOwogCUlOSVRfV09SSygmZWktPmlfcnN2X2NvbnZlcnNpb25fd29yaywgZXh0NF9l
bmRfaW9fcnN2X3dvcmspOwogCWV4dDRfZmNfaW5pdF9pbm9kZSgmZWktPnZmc19pbm9kZSk7CiAJ
c3Bpbl9sb2NrX2luaXQoJmVpLT5pX2ZjX2xvY2spOwoKLS0tIGEvZnMvZXh0NC9wYWdlLWlvLmMK
KysrIGIvZnMvZXh0NC9wYWdlLWlvLmMKQEAgLTI2MCwxMiArMjYwLDE2IEBACiAJCSFpb19lbmQt
PmhhbmRsZSAmJiBzYmktPnNfam91cm5hbCk7CiAJV0FSTl9PTighaW9fZW5kLT5iaW8pOwogCiAJ
c3Bpbl9sb2NrX2lycXNhdmUoJmVpLT5pX2NvbXBsZXRlZF9pb19sb2NrLCBmbGFncyk7CiAJd3Eg
PSBzYmktPnJzdl9jb252ZXJzaW9uX3dxOwotCWlmIChsaXN0X2VtcHR5KCZlaS0+aV9yc3ZfY29u
dmVyc2lvbl9saXN0KSkKLQkJcXVldWVfd29yayh3cSwgJmVpLT5pX3Jzdl9jb252ZXJzaW9uX3dv
cmspOworCWlmIChsaXN0X2VtcHR5KCZlaS0+aV9yc3ZfY29udmVyc2lvbl9saXN0KSkgeworCQlp
ZiAoaWdyYWIoaW9fZW5kLT5pbm9kZSkpIHsKKwkJCWVpLT5pX3Jzdl9uZWVkX2lwdXQgPSAxOwor
CQkJcXVldWVfd29yayh3cSwgJmVpLT5pX3Jzdl9jb252ZXJzaW9uX3dvcmspOworCQl9CisJfQog
CWxpc3RfYWRkX3RhaWwoJmlvX2VuZC0+bGlzdCwgJmVpLT5pX3Jzdl9jb252ZXJzaW9uX2xpc3Qp
OwogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmVpLT5pX2NvbXBsZXRlZF9pb19sb2NrLCBmbGFn
cyk7CiB9CiAKIHN0YXRpYyBpbnQgZXh0NF9kb19mbHVzaF9jb21wbGV0ZWRfSU8oc3RydWN0IGlu
b2RlICppbm9kZSwKQEAgLTI4OSwxMCArMjkzLDE3IEBACiAKIAkJZXJyID0gZXh0NF9lbmRfaW9f
ZW5kKGlvX2VuZCk7CiAJCWlmICh1bmxpa2VseSghcmV0ICYmIGVycikpCiAJCQlyZXQgPSBlcnI7
CiAJfQorCisJLyogUmVsZWFzZSBpbm9kZSByZWZlcmVuY2UgZnJvbSBleHQ0X2FkZF9jb21wbGV0
ZV9pby4gKi8KKwlpZiAoZWktPmlfcnN2X25lZWRfaXB1dCkgeworCQllaS0+aV9yc3ZfbmVlZF9p
cHV0ID0gMDsKKwkJaXB1dCgmZWktPnZmc19pbm9kZSk7CisJfQorCiAJcmV0dXJuIHJldDsKIH0K
IAogLyoKICAqIFVzZWQgdG8gY29udmVydCB1bndyaXR0ZW4gZXh0ZW50cyB0byB3cml0dGVuIGV4
dGVudHMgdXBvbiBJTyBjb21wbGV0aW9uLAo=
--000000000000f1d83006559c31d9--
