Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4C73EDE7C;
	Fri,  9 Oct 2026 21:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582734; cv=none; b=Y2/7RXrwl0pCerDzemKbtECOykhI5axHhdCTy/3YcUQ9c4mhfWc/K1xNk+YvBXISlPMIVQOqcNIEj4M3II6G+gt7WVx/PWi+xP1tWMv3t+kW/qRdBKpKyOAp3DnXyUS2n4cB8/1nHthzZxngU7k0AxyGp6xXvJfkk16e8dFNO5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582734; c=relaxed/simple;
	bh=b5sznnuGKwNIIOu8jPb5MvgGrjryKlj8Lyo/G2S3PgI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bee3Ka8cO8UtulTD304GaqHPgMqUdZu8n8DGWrpt4iLCwZyMkrQto0U3EFMtBN5O1HabChgcRbW7/zh6PNbXNOqm1Uz9Q8j8/UajBuEHEJDL65MMfcV6TO3fRdreTvOS+VnUI1uqwuVS7yn3IENKWQUS/yFUf7WG0UbHzzR2PxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHK8QKqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHK8QKqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3607E1F00893;
	Fri,  9 Oct 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582732;
	bh=tqPy9G2Uq8wX7avKH2lGPNqLtBG6mXN4scFku2RvX80=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iHK8QKqLRXtu/24bu701P/BKdppTaWiEF90AmkYpeBkQu9UyYbAEE/P6MdCBtfXEn
	 IymLCajlExelE1otsRNuzwC6BprWaBrJhY3A4Up6hrOl9iNt7hu0qrQq/BfJYERpJ+
	 KzLIVQLncwK7CHvAX26bImlNQSC8uWtKIMou4WpvRPCZ6CwOuxv9iDJJyZP+lgMmfM
	 pZS+qhWM5A4EiIRBEdbxfM8nfQLT8UdWR/J37AazW90gpzssVX1H5+IdcDznfhe+GB
	 zdFdtEO9Po/+TqBw1O72OlwvrDypuagkjjoGHYNcZUgkmDkmzocnLCun+BLHqhrEmV
	 uVOPTVP7PAQJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:54 +0200
Subject: [PATCH 4/8] eventfs: free the eventfs_inode after an rcu grace
 period too
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-4-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5181; i=brauner@kernel.org;
 h=from:subject:message-id; bh=b5sznnuGKwNIIOu8jPb5MvgGrjryKlj8Lyo/G2S3PgI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPxzrmNd7c95Ozr8YzZWPucVF7qlukLW/UO9Z/Ln+
 4YWD9vYOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACay3ZGR4cMeRvMLU8TqDqVo
 FOR02a5tuHL+2v/D+yzYbh94bnUv9z7D/wRdMYuLLx7bPq1wdjvgp2QXs1xTesUDI+9fCy9fObl
 TkAsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

tracefs_d_revalidate() reads ->is_freed of the eventfs_inode that
dentry->d_fsdata points to, and ->d_revalidate() is called in rcu
pathwalk mode with nothing but rcu_read_lock() held. The dentry itself
stays around for such a walker, but tracefs_d_release() drops its
reference to the eventfs_inode when the dentry is killed, and
release_ei() then frees it after a grace period of eventfs_srcu. An
SRCU grace period doesn't wait for rcu_read_lock() sections, so the
walker can read an eventfs_inode that is already gone.

With a pathwalk held up in tracefs_d_revalidate() while the dentry goes
away:

  BUG: KASAN: slab-use-after-free in tracefs_d_revalidate+0x76/0x90
  Read of size 1 at addr ff1100010152d8d0 by task walker/97
  Call Trace:
   <TASK>
   tracefs_d_revalidate+0x76/0x90
   lookup_fast+0x320/0x640
   path_lookupat+0x160/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
   vfs_fstatat+0x4d/0x90
   __do_sys_newfstatat+0xa0/0x100
   do_syscall_64+0x10e/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [...]
  Allocated by task 1:
   __kmalloc_cache_noprof+0x249/0x560
   eventfs_create_dir+0x7a/0x590
   event_create_dir+0x2fb/0xcf0
   trace_add_event_call+0xbf/0x150
  [...]
  Freed by task 11:
   kfree+0x1db/0x5b0
   srcu_invoke_callbacks+0x3a3/0x620
   process_one_work+0x937/0x1810
   worker_thread+0x4f1/0xd60

Before commit 8e556432477e ("eventfs: Use SRCU for freeing
eventfs_inodes") release_ei() used call_rcu(), which covered the walker,
while eventfs_iterate() needs the SRCU grace period. Wait for both and
chain call_rcu() from the SRCU callback.

Fixes: 8e556432477e ("eventfs: Use SRCU for freeing eventfs_inodes")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Reproducer: delay.c holds a task named walker in tracefs_d_revalidate()
in rcu pathwalk mode for two seconds and repro.c frees the eventfs_inode
of its dentry meanwhile. The keep event keeps the rcuwalk directory
around.

    echo 'p:rcuwalk/keep do_sys_openat2' >> /sys/kernel/tracing/kprobe_events
    echo 'p:rcuwalk/ev do_sys_openat2' >> /sys/kernel/tracing/kprobe_events
    insmod delay.ko
    ./repro

Without this patch that gives the splat above, with it it runs clean.

delay.c:

    #include <linux/delay.h>
    #include <linux/kprobes.h>
    #include <linux/module.h>
    #include <linux/namei.h>

    /* keep a task named "walker" in tracefs_d_revalidate() in rcu pathwalk */
    static int pre(struct kprobe *p, struct pt_regs *regs)
    {
    	if ((regs_get_kernel_argument(regs, 3) & LOOKUP_RCU) &&
    	    !strcmp(current->comm, "walker"))
    		mdelay(2000);
    	return 0;
    }

    static struct kprobe kp = {
    	.symbol_name	= "tracefs_d_revalidate",
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
    #include <fcntl.h>
    #include <pthread.h>
    #include <sched.h>
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

    	pin(1);
    	prctl(PR_SET_NAME, "walker");
    	stat("ev", &st);
    	return NULL;
    }

    int main(void)
    {
    	struct stat st;
    	pthread_t t;
    	int fd;

    	pin(0);
    	chdir("/sys/kernel/tracing/events/rcuwalk");
    	stat("ev", &st);
    	/* sets ->is_freed, the dentry stays hashed and holds the ei */
    	fd = open("/sys/kernel/tracing/kprobe_events", O_WRONLY | O_APPEND);
    	write(fd, "-:rcuwalk/ev\n", 13);
    	close(fd);
    	pthread_create(&t, NULL, walker, NULL);
    	sleep(1);
    	/* ->d_revalidate() says 0, the dentry is killed and drops the ei */
    	stat("ev", &st);
    	pthread_join(t, NULL);
    	return 0;
    }
---
 fs/tracefs/event_inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 6e3513b13cfa..090aca946717 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -91,6 +91,14 @@ static void free_ei_rcu(struct rcu_head *rcu)
 	}
 }
 
+/* read under eventfs_srcu and, by tracefs_d_revalidate(), in rcu pathwalk */
+static void free_ei_srcu(struct rcu_head *rcu)
+{
+	struct eventfs_inode *ei = container_of(rcu, struct eventfs_inode, rcu);
+
+	call_rcu(&ei->rcu, free_ei_rcu);
+}
+
 /*
  * eventfs_inode reference count management.
  *
@@ -112,7 +120,7 @@ static void release_ei(struct kref *ref)
 			entry->release(entry->name, ei->data);
 	}
 
-	call_srcu(&eventfs_srcu, &ei->rcu, free_ei_rcu);
+	call_srcu(&eventfs_srcu, &ei->rcu, free_ei_srcu);
 }
 
 static inline void put_ei(struct eventfs_inode *ei)

-- 
2.53.0

