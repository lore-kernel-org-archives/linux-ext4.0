Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866AC23BD1B;
	Sun, 28 Jun 2026 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782673060; cv=none; b=muNwUnE5zMjGHEMcLaFYKIag75s9UPfqNOALP5smSInv1oncr5B59BjlDOmW5bDXFzpSxpDm8onIOrZgrgxPR5LH0dMUlB229H+qEYysKY9yTyYEAkG2uojAJ2NA4bJA9w0bvMUCoJ6hgPJH9CYLTiFsokW058lwVYl4TREZ+x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782673060; c=relaxed/simple;
	bh=XF7RcKuQCaaaQyV7TgTh/Dh3UR5tR0JCU/b/DlBCZzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TiRIMlaRxXD4ln4tkIDmIrk7h9ZheNrFc3wfPHIjAisXcb7yCfqu6iTWyeAFVJqtqz6DQt5SEQ67BlQFawzE7eHryyGAqST8JB6slwOWh2ddkCREf5pHEqgo620PiCGY6EyscccX0CCju/P0499CZPJ1lz8pNPGE0oVBCY+Ezhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=rQjD09NM; arc=none smtp.client-ip=43.163.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="rQjD09NM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782673048; bh=Vec2D5eQKzQ74gZxdAs44uQsPqe5tItUtvWLO7lctY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=rQjD09NMcbIrHIHqJDmyFnWTD1jxDIeYFU7hW+uGw4fs5zd5Y4BFYV7Im6g//5p0b
	 /36A6g5q9qtqGqpnWf5ozlMuhUv6tSr4iBjTdrXLi9LSwCggGQTVp8kD71FrPcaIvh
	 C4sUQW1Wx1N0r6QKdBI32Erut9ndK8ArGjLx3Rd4=
Received: from [192.168.1.102] ([223.77.180.178])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id E583D820; Mon, 29 Jun 2026 02:57:24 +0800
X-QQ-mid: xmsmtpt1782673044tc5qh6a6x
Message-ID: <tencent_B515F296245B20D721AEC2C9367AA188940A@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuRORqMjrekPGZUXgzah05C82kWrxNL6IqhCnA4n5bMsn76dV1OP
	 X7G1mY/Fql/qvyU0hYMWVWMXSBbsDLh1ng6HL+FCmYz3ZEORrJJeRRJbEGvn8mz4ZbthbpvOXTg2
	 aPR1T9Oi1IHXPfU2G4Q+923HXaB8E7dgqzXeQ+0xVDbz2pErRda9fywdKEkAjoP12DKY78lis3uf
	 uqRH2pmVT/dUd7k6CKIiYDaal1c6+eH1OgfwMedoiF30HI57HhhlnoXY0s337nti63m8aFUV+BMW
	 GS8rNnqv1fWFpIK2cvP20iu2gd2HipcfYHGCUr4jz5PMS8YYrp/+2/ywrnfxX/gUf0SXuqbXLPiI
	 lgKGXejsiVqXmgFM3wg/4zBm5ubOBzJR1v4MjJf9xa5u+by/HchLsjAoyYkqtXqv6oqH/9YE1WUM
	 aJ3i+SEPZEJf9l4DLYnZMbSgPeDrflDE1+5MvxD84sBhI9if6X6AgT0yGdOBllXbxtOFG8t+9yJr
	 Gko0sp+qr6HEnGyrV3wYv4RW/yY1Ye2NwEJgq8Px90dDazC/DFBBn/XeoWxxhanbE02d1Bb+fnOQ
	 mMDKNW+4v+jtUvRkDhhDYFyb6q6Yyk7PGKoZgYGoIKaMh1Jml8DCSep7zrh6+yOB6cI3U0dIa/2B
	 tDvGKfAqKB4Ctbl+xMB+FeoGxu5Ci3zebonZIoSf/wiHqQjGD6hSRn128d/s4CrGSSY4R3Rumx1e
	 tWhmgN0xrBB6+iaygEXYkslHoXo3oH8ZpHIKf+dL3tgGaNKMiLf4v8ki/nPK7A0wPSGShuVdwvzf
	 F8iUaCHNQ0NzfXaHRj8Su6E90hrHnjb42VLrKQS2R5WCEwgwkFTGTtsde2AWOSjhzypUi9X7g0ka
	 ClchT5WT/BmKQ3GpQIoxt6WKr81Oc5+XmMsViBf3OALit72q5wziZYIuGvWdSXk0RxE1FF9RSCA6
	 u+K2O+UMvg23sdrWCMeCIYTzhiLacJhdvwp7ou+Nt9Iytzf6ZZ8W+VfsAbhqiagyViqwtnSKvwFJ
	 wrFcabrPCRZ4uAYQpk7HoHFA95pbfRENYQZQdP79763hY68h5qe2N2zLpVi4WxcEt6p8O0Bw==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-OQ-MSGID: <5eccf43d-3e9b-48d7-83d8-54fdae452962@qq.com>
Date: Mon, 29 Jun 2026 02:57:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 5/5] ext4: prevent deadlock from duplicate EA inode
 references on corrupted fs
To: Yun Zhou <yun.zhou@windriver.com>, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-6-yun.zhou@windriver.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260625152941.24788-6-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I've been following the sashiko-bot reviews on this series and was able
to reproduce the llist corruption issue that the bot has flagged — it
triggers a kernel BUG at ext4_put_super() when an EA inode is leaked
onto the orphan list at unmount.

The sashiko review is at:
https://sashiko.dev/#/patchset/20260625152941.24788-1-yun.zhou@windriver.com

 > +/* Put all EA inodes on a processed llist via ext4_put_ea_inode. */
 > +static void ext4_put_ea_inode_llist(struct super_block *sb,
 > +                                    struct llist_head *processed)
 > +{
 > +    struct llist_node *node = llist_del_all(processed);
 > +    struct llist_node *next;
 > +
 > +    while (node) {
 > +        struct ext4_inode_info *ei = container_of(node,
 > +                        struct ext4_inode_info, i_ea_iput_node);
 > +        next = node->next;
 > +        ext4_put_ea_inode(sb, &ei->vfs_inode);
 > +        node = next;
 > +    }
 > +}

The per-call `processed` llist is declared on the stack of
ext4_xattr_delete_inode().  If two threads concurrently evict files
that share the same EA inode (same large xattr value), both threads
call llist_add() on the SAME embedded i_ea_iput_node, each trying to
add it to their own stack-local llist head.

Since llist_add() unconditionally writes `node->next = head->first`
(which is a stack address from the caller's frame), the two threads
corrupt each other's `node->next` pointer.  When
ext4_put_ea_inode_llist() later traverses the list, it follows a
dangling next pointer into freed/concurrent stack memory, causing the
EA inode to be silently skipped during deferred iput processing.

=== Reproduction ===

Kernel: 7.1.0-next-20260624-gb27bd6a65c17 #1 SMP PREEMPT_RT
Config: CONFIG_EXT4_FS=y, CONFIG_EXT4_FS_POSIX_ACL=y, CONFIG_KASAN=y
QEMU:   QEMU Standard PC (Q35 + ICH9, 2009)

The PoC creates two files sharing the same large xattr value (thus
sharing the same EA inode), then concurrently unlinks them from two
pthreads synchronized by a barrier on the same CPU.  This triggers the
llist_add() race on the shared i_ea_iput_node, leaving the EA inode
unprocessed.  The EA inode (nlink=0) sits on the orphan list, and
umount hits the BUG() assertion.

=== Crash Log ===

[  959.127015][T10365] EXT4-fs (loop0): unmounting filesystem...
[  959.217461][T10365] EXT4-fs (loop0): sb orphan head is 15
[  959.217516][T10365] sb_info orphan list:
[  959.217516][T10365]   inode loop0:15 at ffff88802e27be40: mode 
100600, nlink 0, next 0
[  959.217530][T10365] Assertion failure in ext4_put_super() at 
fs/ext4/super.c:1354: 'list_empty(&sbi->s_orphan)'
[  959.217704][T10365] ------------[ cut here ]------------
[  959.217708][T10365] kernel BUG at fs/ext4/super.c:1354!
[  959.217757][T10365] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[  959.217832][T10365] CPU: 0 UID: 0 PID: 10365 Comm: umount Not tainted 
7.1.0-next-20260624-gb27bd6a65c17 #1
[  959.217843][T10365] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
[  959.217849][T10365] RIP: 0010:ext4_put_super+0xf41/0x12c0
[  959.217978][T10365] Call Trace:
[  959.217978][T10365]  ? __pfx_ext4_put_super+0x10/0x10
[  959.217987][T10365]  generic_shutdown_super+0x163/0x390
[  959.218042][T10365]  kill_block_super+0x40/0xa0
[  959.218061][T10365]  ext4_kill_sb+0x6f/0xb0
[  959.218103][T10365]  deactivate_locked_super+0xc6/0x1a0
[  959.218125][T10365]  deactivate_super+0xe3/0x110
[  959.218148][T10365]  cleanup_mnt+0x22a/0x460
[  959.218197][T10365]  task_work_run+0x155/0x250
[  959.218381][T10365]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  959.218511][T10365] ---[ end trace 0000000000000000 ]---

The orphan inode (loop0:15, nlink=0) is an EA inode that was not
processed by ext4_put_ea_inode_llist() due to the corrupted llist.

=== PoC ===

Build:  gcc -o poc poc.c -static -lpthread
Run:    ./poc [iterations]   (requires root for mount/loop)

// SPDX-License-Identifier: GPL-2.0-only
/*
  * PoC: llist race in ext4 EA inode deferred iput (patch 5/5)
  *
  * Two threads concurrently unlink files sharing the same EA inode,
  * racing on llist_add() to the shared i_ea_iput_node.  The corrupted
  * llist causes the EA inode to be leaked -> orphan list BUG at umount.
  */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/mount.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <sched.h>
#include <signal.h>
#include <pthread.h>

#define EA_VALUE_SIZE 4032
#define MAX_ITER 2000

static const char *mnt = "/mnt/ea_race";
static const char *f1 = "/mnt/ea_race/f1";
static const char *f2 = "/mnt/ea_race/f2";
static const char *loopdev = "/dev/loop0";
static const char *img = "/tmp/ea_race.img";

static volatile int stop = 0;
static int iterations = MAX_ITER;
static pthread_barrier_t barrier;
static char shared_value[EA_VALUE_SIZE];

static int do_setxattr(const char *path, const char *name,
                        const void *value, size_t size, int flags)
{
     int ret = syscall(SYS_setxattr, path, name, value, size, flags);
     if (ret < 0 && errno == ENODATA) return ret;
     return ret;
}

static void pin_cpu(int cpu)
{
     cpu_set_t cpuset;
     CPU_ZERO(&cpuset);
     CPU_SET(cpu, &cpuset);
     sched_setaffinity(0, sizeof(cpuset), &cpuset);
}

static int create_file_with_xattr(const char *path,
                                    const void *value, size_t valuelen)
{
     int fd = open(path, O_CREAT | O_WRONLY, 0644);
     if (fd < 0) return -1;
     close(fd);
     if (do_setxattr(path, "user.large", value, valuelen, 0) < 0) {
         unlink(path);
         fd = open(path, O_CREAT | O_WRONLY, 0644);
         if (fd < 0) return -1;
         close(fd);
         if (do_setxattr(path, "user.large", value, valuelen, 0) < 0)
             return -1;
     }
     return 0;
}

struct racer_data {
     const char *file;
     int thread_id;
     int *setup_done;
     pthread_mutex_t *setup_lock;
};

static void *racer_thread(void *arg)
{
     struct racer_data *rd = (struct racer_data *)arg;
     pin_cpu(0);

     for (int i = 0; i < iterations && !stop; i++) {
         if (create_file_with_xattr(rd->file, shared_value, 
EA_VALUE_SIZE) < 0) {
             char alt_val[EA_VALUE_SIZE];
             memset(alt_val, 'A' + rd->thread_id, EA_VALUE_SIZE);
             create_file_with_xattr(rd->file, alt_val, EA_VALUE_SIZE);
             do_setxattr(rd->file, "user.large", shared_value, 
EA_VALUE_SIZE, 0);
         }

         pthread_mutex_lock(rd->setup_lock);
         (*rd->setup_done)++;
         pthread_mutex_unlock(rd->setup_lock);

         pthread_barrier_wait(&barrier);
         unlink(rd->file);    /* RACE: concurrent eviction of shared EA 
inode */
         pthread_barrier_wait(&barrier);
     }
     return NULL;
}

static void sig_handler(int sig) { stop = 1; }

static void setup_fs(void)
{
     char cmd[512];
     remove(img); mkdir(mnt, 0755);
     snprintf(cmd, sizeof(cmd),
              "dd if=/dev/zero of=%s bs=1M count=64 2>/dev/null", img);
     system(cmd);
     snprintf(cmd, sizeof(cmd),
              "mkfs.ext4 -F -O ea_inode -b 4096 %s 2>/dev/null", img);
     system(cmd);
     snprintf(cmd, sizeof(cmd), "losetup %s %s 2>/dev/null", loopdev, img);
     system(cmd);
     snprintf(cmd, sizeof(cmd), "mount %s %s 2>/dev/null", loopdev, mnt);
     system(cmd);
     printf("Filesystem ready at %s\n", mnt);
}

static void cleanup_fs(void)
{
     char cmd[512];
     snprintf(cmd, sizeof(cmd), "umount %s 2>/dev/null", mnt);
     system(cmd);
     snprintf(cmd, sizeof(cmd), "losetup -d %s 2>/dev/null", loopdev);
     system(cmd);
     remove(img); rmdir(mnt);
}

int main(int argc, char *argv[])
{
     pthread_t t1, t2;
     struct racer_data rd1, rd2;
     int setup_done = 0;
     pthread_mutex_t setup_lock = PTHREAD_MUTEX_INITIALIZER;

     if (argc > 1) iterations = atoi(argv[1]);
     if (iterations < 1) iterations = 1;
     if (iterations > MAX_ITER) iterations = MAX_ITER;

     signal(SIGINT, sig_handler);
     signal(SIGTERM, sig_handler);

     printf("=== ext4 EA inode llist Race PoC ===\n");
     printf("Iterations: %d\n", iterations);

     setup_fs();

     memset(shared_value, 'Z', EA_VALUE_SIZE);
     pthread_barrier_init(&barrier, NULL, 2);

     rd1 = (struct racer_data){ f1, 1, &setup_done, &setup_lock };
     rd2 = (struct racer_data){ f2, 2, &setup_done, &setup_lock };

     printf("Starting race threads...\n");
     pthread_create(&t1, NULL, racer_thread, &rd1);
     pthread_create(&t2, NULL, racer_thread, &rd2);

     pthread_join(t1, NULL);
     pthread_join(t2, NULL);
     pthread_barrier_destroy(&barrier);

     printf("\nRace loop complete.\n");
     printf("Check dmesg for crash evidence.\n");
     system("dmesg | tail -50 | grep -E 'KASAN|BUG:|orphan|RIP:' || echo 
'(none)'");

     cleanup_fs();
     printf("Done.\n");
     return 0;
}

I see that Jan suggested leaving this patch out for now and that you're
planning an improved version for v11.  This PoC should help verify
whether the improved llist handling in v11 resolves the race.

Thanks,
Xiao


