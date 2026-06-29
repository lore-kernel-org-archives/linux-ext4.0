Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5A13BB9F7
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 07:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782717169; cv=pass; b=UPk4ZFdYUZLc020uWgDwftZ7P1CJ70bXf+w7aULOkrOAKQMOthl0Yje3v+FddEzxU2JDNRq/68owhKX6apSytpAF6jUKwAfBbN19M4NOxJ5BaAbZ4OI3rpt8ojZbdBOjCuvv9ZwVehrg6ATrNJbPkO3uJmiHAlBcIp8xYqhiHh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782717169; c=relaxed/simple;
	bh=5AtjnqjPpev95T2zBJ1oOc1hhxXLSonUYkv6hXpTuos=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EDd0YzsK0zJ2ZqxwZ/zcSOiy7CG+RTWKB0EJElxNujj1i0/nPzIEFc5JMR8zojvpQXQ5wiNk6WVUt8R4ebjFqygSfAd6l4v77s9Jo/HsjK7yElfN8s6sGxRz2vKJdZMdAwL3A6fhSEsBxpfLEqRlO0VOpNh3xzAEDU/dLwSW6hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmy9rT+s; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmy9rT+s"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51af8fda431so17135731cf.0
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 00:12:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782717164; cv=none;
        d=google.com; s=arc-20260327;
        b=VqCOHDr+NGvutDKJOM8Iz8Ue7LzvzZKVSKRQ7ifnqg+P+rtmLr2GJYt8AXoi6qqh64
         n+44cILhcVSVU3uatrzyO/cbA89DAjzJQoKcKP3HUvxvu7vERCurncyV4ZUpybvMb09q
         JFaBgl54gelQm+KwzEjCdlG/xIhrEmRnA0NDD92QGaVx6EzNfQVVzcmR7McS+A+/ouGw
         HMExVIXjKFkt3ffV3yg9qEpCdkc3wwX4kiW3V4e63mS9K7oztybH4InRM9mN//oM7CCb
         pUSNsXYRcf6b7UAKknzC71B7au02Eih5ntur7tAfjNLeq/AZqE1ioS8dV5TTpSrt8s1P
         01VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5AtjnqjPpev95T2zBJ1oOc1hhxXLSonUYkv6hXpTuos=;
        fh=dmDDMAg9YIj5OCNuw4+C3f4fqz/Qb3JTk61fwcreZZk=;
        b=qIlq4uHsvt/Y4ui8MNHaeeKI+zevTifgM0Dty4mkgtKpSzGYIkMaXj5FXmlGPDcVCL
         y2+fQQfifLBlxErBmXcCXKLIti98TImAis5pizTSVcsW4KCosbaM2fXHRNMgAQnYeeWp
         0fP7zrpui8PF1uPDuOi5fN5Krvy8LfMEydx2GEL9UW/2PUKX1DMyrHr/wrmo0MSM4XWd
         nSLKFC97bVzmv9+RLazyhj6cz45ro7/5WhsmsH22p/bRLznLLh28Vg7pjyWp86mirgGc
         AovvHVG7koqouwVYuqaFOS48MIm47ia5fvejPxUUQDhIxEXi03yCcUp0BKcptJoOaH5I
         3yAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782717164; x=1783321964; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5AtjnqjPpev95T2zBJ1oOc1hhxXLSonUYkv6hXpTuos=;
        b=hmy9rT+shs4jg1cz6pLXjeaP7qIvWaINc50BOmcOGjvsF/erqS4TN5fH05nrBMuW/d
         OTN5oKtB7tVbIhaxduTEoUxoAJ2i2Bgc/BKEwJ/JqBagu3oaRL8acDqco+Xu1G+CUxDv
         gLuUUxXSpDI94UOXEQP2vSnl9i+B8WIykXE6YWew1hh6KzmGOyxvQVo9LS8rlrSfYEYi
         yozrYZKKcZXAKhdjfg9/lCy/ICB1GiXIq1bPdON2pb9hfnkhTugKqKyzALRjp8T3JB7L
         fizrq9fV9VQx8WF9s5PUMasC2J07JaP5MGwW3SD3uf2y3vWqYubQqkQDB5jw6njXBSGG
         FJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782717164; x=1783321964;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5AtjnqjPpev95T2zBJ1oOc1hhxXLSonUYkv6hXpTuos=;
        b=QSyojnl1QGzZoIjzTE0bL7q5DfiN9TH6s1q8dy1LA3Oi1ZR9C730gahUBrMx17YvVh
         yRqLxFqWkPD8sN8ryZVXXAhs+dTKlXH2BSDqCUAk6ZxVhJkwDUI/irv1BicdHjd2qCrE
         M3UczNHiwzd29HKNAvVbsbH7qX/OZFaRPAaOYjYkVCcyG/Xkf9zwwZ/o9M9xfjkENUIL
         mSRtOKHvoT57VpOPRr/I0YvTZT/mO0L8Yx0V8m7SEAsxlu3CovXEFKuFFuXdzz8yDIgc
         n8M61wNIhdSb40oD8tqq3I/im0aKr5VpBc1MiKdR7Fe62qZj3dDUXdNhSI08XXXHmEnr
         GhGA==
X-Forwarded-Encrypted: i=1; AFNElJ8e7XaKikJy5XfbOLWhLQhpSfsTEp51eE6l0+LyKMFqSGJ7D+uL6C8qMuAJSGA8BKCjrb7lC8OHhAke@vger.kernel.org
X-Gm-Message-State: AOJu0YzGtmcqEirpHiTmgNngKsyKmDWPnS/ZROUjZ53SdAqhzwv+Brkh
	N5rtqTO1/wg4ONCT/4ApvDxL1RhR5h36LLZJWvBe++RLBsqifNHfc60Sge+d6BqEZz0TMyjC7hf
	eL/SFD2nKrV625jtjnyTnvN4wAwfL7PE68IPUc5Sh6iuRrcA=
X-Gm-Gg: AfdE7cn0nleVnVV41ZId7K3mXsE5usvRKFbLym4P9q//0FFFFCtY6Awm4/mWePFhNmN
	lGsHWhw1RF0epqwiuSa6V/G7TgD1EiW4CRiGWEyy8CzqJ4vjrX1bkBIiXLHN+O8CpJ2iCNgPWDS
	hIWpwCe1FIa9eR/vxDMLy7Nlop/I77JeIpVNSiWD+4n8ca8RTkpctDz2QGs2Z05K7fVi4sfhcO9
	vAz4RQB8nnUGLmBSHTlMaoDTfml8kwOXKNHO0pSOOfKHAEiXQhDM6kU74zVguju6oYB0LxuSSlR
	711PZR0=
X-Received: by 2002:a05:622a:488a:b0:51c:23a:9b03 with SMTP id
 d75a77b69052e-51c023a9d8fmr16355521cf.59.1782717163709; Mon, 29 Jun 2026
 00:12:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Mon, 29 Jun 2026 15:12:32 +0800
X-Gm-Features: AVVi8CejGpEF6ZXTc4jymBWXreXBjS2nipEBSki42QQYh7G-mmnL4l7rNSGcpaw
Message-ID: <CAA2SOT4dBwiw52CSMenZQ+w_qP=vyrmeuwS8SHZuY4MZDjDOeA@mail.gmail.com>
Subject: [BUG] ext4: KASAN slab-use-after-free in __ext4_check_dir_entry
 during getdents64 on corrupted directory
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a KASAN slab-use-after-free triggered by a syzkaller
reproducer on Linux 7.1.0-rc5. The issue is hit while reading an ext4
directory from a crafted filesystem image.

The reproducer mounts a corrupted ext4 image through
syz_mount_image$ext4, opens the current directory, seeks the directory
fd, and then calls getdents64(). The kernel first reports ext4 dx
directory corruption, and then KASAN reports a slab-use-after-free in
__ext4_check_dir_entry().

This looks like ext4 continues directory entry validation after
encountering corrupted dx/htree directory metadata, and
__ext4_check_dir_entry() ends up reading from an invalid/freed object
instead of safely rejecting the corrupted directory.

Reproducer:
C reproducer: https://pastebin.com/PJjfHECH
console output:https://pastebin.com/s9jBugWd
kernel config: https://pastebin.com/raw/fUwrL2uz

Kernel:
HEAD commit: e7ae89a0c97c
kernel version: 7.1.0-rc5 #2 PREEMPT(lazy)
Hardware: QEMU Ubuntu 24.10 PC (i440FX + PIIX, 1996)
Taint: Not tainted

EXT4 warnings before the KASAN report:

EXT4-fs warning (device loop3): dx_probe:800: inode #2: comm syz.3.4:
Unrecognised inode hash code 20
EXT4-fs warning (device loop3): dx_probe:933: inode #2: comm syz.3.4:
Corrupt directory, running e2fsck is recommended

KASAN report:

BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x670/0x720
Read of size 2 at addr ffff88811074d003 by task syz.3.4/2047

Call Trace:
<TASK>
dump_stack_lvl+0x7d/0xa0
print_report+0x10d/0x5d0
kasan_report+0x96/0xd0
__ext4_check_dir_entry+0x670/0x720
ext4_readdir+0xd7b/0x27c0
iterate_dir+0x1c0/0x570
__x64_sys_getdents64+0x134/0x260
do_syscall_64+0x104/0x5b0
entry_SYSCALL_64_after_hwframe+0x77/0x7f
</TASK>

The buggy address belongs to a freed object from the vm_area_struct cache:

The buggy address belongs to the object at ffff88811074d000
which belongs to the cache vm_area_struct of size 192
The buggy address is located 3 bytes inside of
freed 192-byte region [ffff88811074d000, ffff88811074d0c0)

Allocated by task 1892:
__kasan_slab_alloc
kmem_cache_alloc_noprof
vm_area_alloc
__mmap_region
mmap_region
do_mmap
vm_mmap_pgoff
ksys_mmap_pgoff
__x64_sys_mmap
do_syscall_64
entry_SYSCALL_64_after_hwframe

Freed by task 1891:
__kasan_slab_free
slab_free_after_rcu_debug
rcu_core
handle_softirqs
irq_exit_rcu
sysvec_apic_timer_interrupt
asm_sysvec_apic_timer_interrupt

The direct trigger path appears to be:

getdents64()
iterate_dir()
ext4_readdir()
__ext4_check_dir_entry()

Since the reproducer first reports a corrupted ext4 dx directory and
then crashes inside __ext4_check_dir_entry(), the issue seems to be in
ext4 directory iteration / directory entry validation handling of
corrupted directory metadata.

Thanks.
