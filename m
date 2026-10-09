Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49AB3EEAF4;
	Fri,  9 Oct 2026 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582738; cv=none; b=V1r2szxiLkOZ1rttlCsBDkJb1wNNsVNth91CfmiL6VcsHliOORC4RExVqsizVY0eXIy9iKxrRWlLb0nEoKK4NbnZyvCh+Hn8/Qv+DLgLkO1J5Swb29B86XJsBl8R4ouNRgYr3xs39piWb+1/ft8bCrCuCiMF5JmYehBFyASVQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582738; c=relaxed/simple;
	bh=nBEmiiEoAfQb3/RPfTImmOxn8PBxV0P99lY6N2vclYw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LkmUgImLMUbFa36PItvd6+0d/Z6WfkzvLL7CcJPbzLlg9btKy1hFuIuPA+0kFXVDspOjNEOI2hTTmJ0VnQuvm3i4Yeq2BH061H9LYm1tzwK+sQQJLo6W0VoCbR0OW8D3ea5H2J76sLWZDUXraOirqK7ELFS4iSJPHc+XMgwVGyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bkb5mNQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bkb5mNQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D311F00893;
	Fri,  9 Oct 2026 21:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582737;
	bh=M7QuAsYvBBUyOh4F7fA0Cqn6o4QP0E6xrLJ+y+EX3qw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bkb5mNQrENr/KzawpnhRJOic9aO+817sW3hto+0q3XDSDYcrXmatcsiiCwPO5d1Nr
	 HHGR0rgnjJw+WquXKKY0UW3/89q3eEngQu6wfSo0/r/vCLHYTaGFuvcffvI6dqGE23
	 GN/gGP5V/XrHufuoSBH9oZfVXBqoid7JeWZC6UQUPkm2LflHYyaFaatsWkKiTVxB2o
	 OcdDcGDq5LM4T7KnBOeq38h1OhYM8gxJEx0kWbOsgrhxTaDGSBjl6rn/9j4aYDlI84
	 g4mVPFpbCYkGVzdcNF1raCpA/L/w6jXY6oLmRbAsxUyBvaMpsmpMc1f2UrQfpdB8KK
	 rsmMLd3hJ/AMg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:56 +0200
Subject: [PATCH 6/8] unicode: free the map after a grace period
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=6529; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nBEmiiEoAfQb3/RPfTImmOxn8PBxV0P99lY6N2vclYw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPwrolTeJyk8baJ4W5Pr1hM7RHy7ckwSd0jKhNekf
 ynNnGzeUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJGVCxkZtus9l53zwya/VJcz
 0f5ZlfwjW72DKmrXfiW2Wm+4IrCdjZGh961EkdpWt9y/RlqbrvjILT7QfCX1TM2RvRcypCz2slx
 gAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

generic_ci_d_hash() and generic_ci_d_compare() read sb->s_encoding and
dereference the unicode map while a pathwalk in rcu mode holds nothing
but rcu_read_lock(). The filesystems that use them, ext4, f2fs and
tmpfs, drop the map with utf8_unload() from ->put_super(), which runs
when the last reference to the mount goes away. A lookup that is still
inside such a filesystem at that point reads a freed map.

With a pathwalk held up in utf8_casefold_hash() while the last reference
to a casefolded tmpfs goes away:

  BUG: KASAN: slab-use-after-free in utf8nlookup+0x74c/0x950
  Read of size 8 at addr ff110001030fe658 by task walker/98
  Call Trace:
   <TASK>
   utf8nlookup+0x74c/0x950
   utf8byte+0x160/0x1560
   utf8_casefold_hash+0x167/0x230
   generic_ci_d_hash+0xdd/0x1c0
   link_path_walk+0x11ad/0x1d30
   path_lookupat+0x63/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
  [...]
  Allocated by task 94:
   __kmalloc_cache_noprof+0x249/0x560
   utf8_load+0x4e/0x570
   shmem_parse_opt_casefold.isra.0+0x92/0x270
  [...]
  Freed by task 97:
   kfree+0x1db/0x5b0
   shmem_put_super+0x72/0x170
   generic_shutdown_super+0x14c/0x530
   kill_anon_super+0x3a/0x60
   deactivate_locked_super+0x9c/0xf0
   cleanup_mnt+0x9f/0x130

So far that has been hard to hit. umount(2) waits for a grace period
in namespace_unlock() before it drops the mount, so only a mount whose
last reference goes away elsewhere, like the close of a file or a chdir
out of a lazily unmounted directory, can race a walker. So it is
reachable.

Delay the free until a grace period has passed. The map and the data
table it holds a reference to then outlive any pathwalk that found the
superblock before the mount went away. The reference on the data table
module is dropped from the rcu callback as well. utf8-core is built in
whenever CONFIG_UNICODE is set, so there is no module exit that would
have to wait for the callbacks.

Overlayfs points the s_encoding of an overlay at the map of its first
layer without taking a reference of its own. That stays correct. The
layer is held by the overlay, so its map is dropped only after the
overlay is gone.

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Reproducer: delay.c holds a task named walker in utf8_casefold_hash() in
rcu pathwalk mode for two seconds and repro.c drops the last reference
to a lazily unmounted casefolded tmpfs meanwhile.

    mount -t tmpfs -o casefold tmpfs /mnt
    chattr +F /mnt
    echo hello > /mnt/Foo
    insmod delay.ko
    ./repro

Without this patch that gives the splat above, with it it runs clean.

delay.c:

    #include <linux/delay.h>
    #include <linux/kprobes.h>
    #include <linux/module.h>

    /* keep a task named "walker" in utf8_casefold_hash() in rcu pathwalk */
    static int pre(struct kprobe *p, struct pt_regs *regs)
    {
    	if (!strcmp(current->comm, "walker"))
    		mdelay(2000);
    	return 0;
    }

    static struct kprobe kp = {
    	.symbol_name	= "utf8_casefold_hash",
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
    	stat("FOO", &st);
    	return NULL;
    }

    int main(void)
    {
    	struct stat st;
    	pthread_t t;

    	pin(0);
    	chdir("/mnt");
    	stat("FOO", &st);
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
 fs/unicode/utf8-core.c  | 21 +++++++++++++++++----
 include/linux/unicode.h |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/unicode/utf8-core.c b/fs/unicode/utf8-core.c
index f313532f5e80..74a74a48dd8b 100644
--- a/fs/unicode/utf8-core.c
+++ b/fs/unicode/utf8-core.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 #include <linux/parser.h>
 #include <linux/errno.h>
 #include <linux/stringhash.h>
@@ -183,12 +184,24 @@ struct unicode_map *utf8_load(unsigned int version)
 }
 EXPORT_SYMBOL(utf8_load);
 
+static void utf8_unload_rcu(struct rcu_head *head)
+{
+	struct unicode_map *um = container_of(head, struct unicode_map, rcu);
+
+	symbol_put(utf8_data_table);
+	kfree(um);
+}
+
+/*
+ * A pathwalk in rcu mode may still be in ->d_hash() or ->d_compare() of a
+ * filesystem that is being torn down and read the map through its
+ * superblock, so the map and the tables it points to have to outlive the
+ * grace period.
+ */
 void utf8_unload(struct unicode_map *um)
 {
-	if (um) {
-		symbol_put(utf8_data_table);
-		kfree(um);
-	}
+	if (um)
+		call_rcu(&um->rcu, utf8_unload_rcu);
 }
 EXPORT_SYMBOL(utf8_unload);
 
diff --git a/include/linux/unicode.h b/include/linux/unicode.h
index 64fa44fe180c..3a8cb603eb93 100644
--- a/include/linux/unicode.h
+++ b/include/linux/unicode.h
@@ -53,6 +53,7 @@ struct unicode_map {
 	unsigned int version;
 	const struct utf8data *ntab[UTF8_NMAX];
 	const struct utf8data_table *tables;
+	struct rcu_head rcu;
 };
 
 int utf8_validate(const struct unicode_map *um, const struct qstr *str);

-- 
2.53.0

