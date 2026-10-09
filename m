Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690333DDAF3;
	Fri,  9 Oct 2026 21:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582741; cv=none; b=HgyRGVtOlOX1rL78QjHaM5r+0A3TpAXd9ziCW7pvHUxtgRJWwbKDSimo/cidnFouUTitElb0Kig1fNTpPyv3Yt8CU3/h2sZd4dsdMASyuejrLiTw9CwClMqJMXZAwlxu/HelrOOv1VpFG04+lA+K64l2XkS58ud3hvIl9OKHZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582741; c=relaxed/simple;
	bh=VnWfyb0ZT9sPVSKVJk5yZT0KTpddNQcauKDZq07uqD4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hamZKoHxfa/nlKo4uxn9hGsC6Xb55WoiyWLRnrRW4go1mdNSwVFK6COJW2jx8rxJERIfI5ghQmzdDsWqI7535E+5Fs8PS3p82u43/U+sCT0zQeMFeEZvZs8UZj6k0XxpJ5bfJ4PqgUQxSZVpIQDFFz054dkIH7WHV+1GDGhkhws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPRX8NFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPRX8NFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90C91F00898;
	Fri,  9 Oct 2026 21:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582740;
	bh=8/6zzt/oY1g+TICbYKfbQSyUzDWPivWDgAFH1nbqIas=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RPRX8NFBfShl/9aRwkn2xq3f0m5ra1+ATik9Ke/QiUubI+I93gM+ygv8xYDoxZjoB
	 IV3t8+ikg401OEaaV1M7i22B1zJe3AOy7qE7vdJdhm73w8qRz0awlhewVB7xgAZoQv
	 UlY5/7IIGNDwuIFqd+kkZEM5FXA3Z5B+ioiA7s4x+Puo540+ZnV36VPEWF5BN1GpQd
	 sOYnLKrSThAoi/WGlhcq/f/VUWh8UcUFEZOx6E39LcJ6WMYkYFdaYj6EJoBkB1umz2
	 wPdVy/sKzQ5G34jqz2a0i9U3Yf3SHNjzq8LWW6R5RkG6rhWKRxed4+AhRhgVvOOIek
	 uYek194wLdavQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:57 +0200
Subject: [PATCH 7/8] ntfs3: free the sbi after a grace period
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-7-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=7278; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VnWfyb0ZT9sPVSKVJk5yZT0KTpddNQcauKDZq07uqD4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPxrfimGK7Ky7p/V2SPH/q6uN1KtjlXjuvo7uaC5Y
 d6v6K+rOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTAC6yneG/o+OBx1tXxIjm3zGb
 b3Z08cLTFz5P5FWvO5m/d+lsueu11xh+MsYqqpRId8fpxoZGSiUGFyy23jvX4ttL91rTqxJnQgt
 4AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

If the "nocase" mount option ntfs3 uses custom hash and dentry compare
functions. Both access ntfs3 superblock private information in rcu
pathwalk. ntfs_put_super() and ntfs3_kill_sb() drop the info without any
rcu delay. A lookup that's still inside the filesystem when the last
reference to the mount is dropped causes a UAF. With a pathwalk held up
in ntfs_d_hash() while the last reference to the mount goes away:

  BUG: KASAN: slab-use-after-free in ntfs_nls_to_utf16+0x752/0x940
  Read of size 8 at addr ff1100010453c850 by task walker/99
  Call Trace:
   <TASK>
   ntfs_nls_to_utf16+0x752/0x940
   ntfs_d_hash+0x22b/0x500
   link_path_walk+0x11ad/0x1d30
   path_lookupat+0x63/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
  [...]
  Allocated by task 95:
   __kmalloc_cache_noprof+0x249/0x560
   ntfs_init_fs_context+0x2db/0x5a0
   alloc_fs_context+0x52e/0xc70
  [...]
  Freed by task 98:
   kfree+0x1db/0x5b0
   deactivate_locked_super+0x9c/0xf0
   cleanup_mnt+0x9f/0x130
   task_work_run+0x131/0x250

The bug is currently masked by the grace period in namespace_unlock()
for umount(2). Keep the necessary information until the filesystem
private info is freed and free it with an rcu delay.

ntfs3_free_sbi() now runs from an rcu callback and drops the upcase
table via ntfs_put_shared(). So switch s_shared_lock over to
spin_lock_bh(). Otherwise the callback can deadlock against a task
holding the lock on the same cpu.

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Reproducer: delay.c holds a task named walker in ntfs_d_hash() in rcu
pathwalk mode for two seconds and repro.c drops the last reference to a
lazily unmounted ntfs3 meanwhile. The name is not ascii, so
ntfs_d_hash() goes through the sbi.

    mkntfs -F -f -Q /dev/vdb
    mount -t ntfs3 -o nocase,noatime /dev/vdb /mnt
    echo hello > /mnt/$(printf '\303\244')
    insmod delay.ko
    ./repro

Without this patch that gives the splat above, with it it runs clean.

delay.c:

    #include <linux/delay.h>
    #include <linux/kprobes.h>
    #include <linux/module.h>

    /* keep a task named "walker" in ntfs_d_hash() in rcu pathwalk */
    static int pre(struct kprobe *p, struct pt_regs *regs)
    {
    	if (!strcmp(current->comm, "walker"))
    		mdelay(2000);
    	return 0;
    }

    static struct kprobe kp = {
    	.symbol_name	= "ntfs_d_hash",
    	.pre_handler	= pre,
    };

    static int __init delay_init(void)
    {
    	return register_kprobe(&kp);
    }

    static void __exit delay_exit(void)
    {
    	unregister_kprobe(&kp);
    }

    module_init(delay_init);
    module_exit(delay_exit);
    MODULE_LICENSE("GPL");

repro.c:

    #define _GNU_SOURCE
    #include <pthread.h>
    #include <sched.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <sys/mount.h>
    #include <sys/prctl.h>
    #include <sys/stat.h>
    #include <unistd.h>

    static void pin(int cpu)
    {
    	cpu_set_t set;

    	CPU_ZERO(&set);
    	CPU_SET(cpu, &set);
    	sched_setaffinity(0, sizeof(set), &set);
    }

    static void *walker(void *arg)
    {
    	struct stat st;
    	char *p;

    	/*
    	 * The delay spins. Empty this cpu's lru batches so that an
    	 * lru_add_drain_all() on the other side has no work to wait for here.
    	 */
    	pin(1);
    	p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    	memset(p, 1, 4096);
    	madvise(p, 4096, MADV_COLD);

    	prctl(PR_SET_NAME, "walker");
    	stat("\xc3\xa4", &st);
    	return NULL;
    }

    int main(void)
    {
    	struct stat st;
    	pthread_t t;

    	pin(0);
    	chdir("/mnt");
    	stat("\xc3\xa4", &st);
    	/* the cwd now holds the last reference to the mount */
    	umount2("/mnt", MNT_DETACH);
    	pthread_create(&t, NULL, walker, NULL);
    	sleep(1);
    	/* drop it, ->kill_sb() runs before chdir() returns */
    	chdir("/");
    	pthread_join(t, NULL);
    	return 0;
    }
---
 fs/ntfs3/ntfs_fs.h |  1 +
 fs/ntfs3/super.c   | 33 +++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 5811d89d67b3..bbcd2e02bf63 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -211,6 +211,7 @@ struct ntfs_index {
 /* Ntfs file system in-core superblock data. */
 struct ntfs_sb_info {
 	struct super_block *sb;
+	struct rcu_head rcu;
 
 	u32 discard_granularity;
 	u64 discard_granularity_mask_inv; // ~(discard_granularity_mask_inv-1)
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index f4a42a0c73a4..841f9068d82f 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -196,7 +196,7 @@ void *ntfs_set_shared(void *ptr, u32 bytes)
 	void *ret = NULL;
 	int i, j = -1;
 
-	spin_lock(&s_shared_lock);
+	spin_lock_bh(&s_shared_lock);
 	for (i = 0; i < ARRAY_SIZE(s_shared); i++) {
 		if (!s_shared[i].cnt) {
 			j = i;
@@ -214,7 +214,7 @@ void *ntfs_set_shared(void *ptr, u32 bytes)
 		s_shared[j].cnt = 1;
 		ret = ptr;
 	}
-	spin_unlock(&s_shared_lock);
+	spin_unlock_bh(&s_shared_lock);
 
 	return ret;
 }
@@ -231,7 +231,7 @@ void *ntfs_put_shared(void *ptr)
 	void *ret = ptr;
 	int i;
 
-	spin_lock(&s_shared_lock);
+	spin_lock_bh(&s_shared_lock);
 	for (i = 0; i < ARRAY_SIZE(s_shared); i++) {
 		if (s_shared[i].cnt && s_shared[i].ptr == ptr) {
 			if (--s_shared[i].cnt)
@@ -239,7 +239,7 @@ void *ntfs_put_shared(void *ptr)
 			break;
 		}
 	}
-	spin_unlock(&s_shared_lock);
+	spin_unlock_bh(&s_shared_lock);
 
 	return ret;
 }
@@ -708,6 +708,8 @@ static noinline void ntfs3_put_sbi(struct ntfs_sb_info *sbi)
 
 static void ntfs3_free_sbi(struct ntfs_sb_info *sbi)
 {
+	if (sbi->options)
+		put_mount_options(sbi->options);
 	kfree(sbi->new_rec);
 	kvfree(ntfs_put_shared(sbi->upcase));
 	kvfree(sbi->def_table);
@@ -719,6 +721,11 @@ static void ntfs3_free_sbi(struct ntfs_sb_info *sbi)
 	kfree(sbi);
 }
 
+static void ntfs3_free_sbi_rcu(struct rcu_head *head)
+{
+	ntfs3_free_sbi(container_of(head, struct ntfs_sb_info, rcu));
+}
+
 static void ntfs_put_super(struct super_block *sb)
 {
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
@@ -728,11 +735,11 @@ static void ntfs_put_super(struct super_block *sb)
 	/* Mark rw ntfs as clear, if possible. */
 	ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
 
-	if (sbi->options) {
-		put_mount_options(sbi->options);
-		sbi->options = NULL;
-	}
-
+	/*
+	 * The mount options stay until the sbi is freed: ->d_hash() and
+	 * ->d_compare() of a pathwalk in rcu mode read the nls table through
+	 * them.
+	 */
 	ntfs3_put_sbi(sbi);
 }
 
@@ -1939,9 +1946,11 @@ static void ntfs3_kill_sb(struct super_block *sb)
 
 	kill_block_super(sb);
 
-	if (sbi->options)
-		put_mount_options(sbi->options);
-	ntfs3_free_sbi(sbi);
+	/*
+	 * A pathwalk in rcu mode may still be in ->d_hash() or ->d_compare()
+	 * and read the upcase table and the nls table through the sbi.
+	 */
+	call_rcu(&sbi->rcu, ntfs3_free_sbi_rcu);
 }
 
 // clang-format off

-- 
2.53.0

