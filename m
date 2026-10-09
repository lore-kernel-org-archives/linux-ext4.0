Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5F036F8E9;
	Fri,  9 Oct 2026 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582726; cv=none; b=J2v8i8nkr71fcq/D+72RPGYrza7cyl63aIJ4/7mlFL+PQvQRJts5uVsbAu9Gn06cytmSH3JoVDKTqhvXsP5GyqCYQnSDhNENK+bwt1zYZcxK26ttV8RQar1BlP6LnuuXqsNxr9WYY1vH7ix+3BhIJh1qazcEBuW29HhnZXR1Ebc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582726; c=relaxed/simple;
	bh=jkUbUrAzGZu0djnsMN6jWLTHWGxFyEvsE9VpbgS6HxU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aomFeKiWAnijwoeMh3neaZDOhF2pARmXnnGVKgR4go/iXbxnF6rUDurier+Zr2Gc8CuUTON7UOlPuadjkuMq+BBjHCaM67LcRZEi8PLdhkpCPSViz63KuXASsjvBsUy1fzUpqvyiNUpwv6AtO1hDEdQFTjkzqzMW+j4/SCj7BAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g95n4tGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g95n4tGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4651F00893;
	Fri,  9 Oct 2026 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582724;
	bh=smBKIAw2rS3I+9juNZ6FxdTDGFKYtH85NTTeRyhtyBo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g95n4tGMoxparogaFz1Lgo+xIHindRpX7hOIywAekQtTgWIvAZb5lZZQLV67XGTcQ
	 qkmEPR3pdxuQos+eQnvN09H3PbBr4eIGZ64uFXYN5VlNMO696xDcvQRr+J/v6b/Ypi
	 ndkwS+XTXn/NCUcUDsi9cmm5jnHDba2RyRjgXnwZR/mIx1oXOdMOxhMSeGuuZYfFt7
	 LAh3Jmr9uOXXvdCjAwDlgr0bzDwOct7V4f+zmTcuASVi9W0h8+4CXn9eXjWQtEXrkT
	 sVvLuSleBT6QFL2IChoJ/qinwI5g2RqSjW3zYeysCvJRPAtQw5R0GZ7jkvh08YNzQ/
	 yx7FpJwPPaH+w==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:51 +0200
Subject: [PATCH 1/8] ext4: free the sbi after a grace period
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-1-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=9532; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jkUbUrAzGZu0djnsMN6jWLTHWGxFyEvsE9VpbgS6HxU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPzjqM1vkLLtU0fcrjD9xY922t2bf1byjs3sD/7dU
 ok3C5Y96yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI8zaG//ULo0P/9smuSF4t
 v28vz9twzuud25ysDiT69J4+vqzrTRPDPzUtwcrAZVEpp9jy3giFHdrV8rlDSoC3Z5Xwu+cLch5
 dYwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext4_get_link() follows a symlink that keeps its target in a data block
in rcu pathwalk mode with ext4_getblk(EXT4_GET_BLOCKS_CACHED_NOWAIT).
That reads s_mount_state in the ASSERT() of ext4_getblk() and again in
ext4_es_lookup_extent(), and the lookup bumps the extent status hit or
miss counter, all through sb->s_fs_info.

ext4_put_super() destroys those counters, clears sb->s_fs_info and frees
the sbi without waiting for a grace period. A pathwalk that is still in
ext4_get_link() when the last reference to the mount goes away then
dereferences a NULL s_fs_info, the freed sbi or the destroyed percpu
counters.

With a pathwalk held up in ext4_get_link() while the last reference
goes away:

  KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
  RIP: 0010:ext4_getblk+0xf0/0x640
  Call Trace:
   <TASK>
   ext4_get_link+0x26c/0x410
   pick_link+0xf96/0x1780
   step_into_slowpath+0x9b8/0x1250
   path_lookupat+0x484/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
   vfs_fstatat+0x4d/0x90
   __do_sys_newfstatat+0xa0/0x100
   do_syscall_64+0x10e/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

So far that has been hard to hit. umount(2) waits for a grace period in
namespace_unlock() before it drops the mount, so only a mount whose last
reference goes away elsewhere, like the close of a file or a chdir out of
a lazily unmounted directory, can race a walker.

Keep sb->s_fs_info and free the sbi together with the extent status
counters after a grace period. Split the counters out of
ext4_es_unregister_shrinker() for that. The shrinker still gets wasted
in ext4_put_super(), the counters go with the sbi.

Fixes: 6493792d3299 ("ext4: convert symlink external data block mapping to bdev")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Reproducer: delay.c holds a task named walker in ext4_get_link() in rcu
pathwalk mode for two seconds and repro.c drops the last reference to a
lazily unmounted ext4 meanwhile. Use an ext4 without a journal or a
kernel without lockdep: jbd2_journal_destroy() calls
lockdep_unregister_key(), which waits for a grace period on lockdep
kernels and hides this for a journaled ext4.

    mkfs.ext4 -O ^has_journal /dev/vdb
    mount -o noatime /dev/vdb /mnt
    ln -s /$(printf 'x%.0s' $(seq 100)) /mnt/link
    insmod delay.ko
    ./repro

The symlink target is too long for the inode, so ext4_get_link() reads it
from its block. Without this patch that gives the splat above, with it
it runs clean.

delay.c:

    #include <linux/delay.h>
    #include <linux/kprobes.h>
    #include <linux/module.h>

    /* keep a task named "walker" in ext4_get_link() in rcu pathwalk */
    static int pre(struct kprobe *p, struct pt_regs *regs)
    {
    	if (!regs_get_kernel_argument(regs, 0) && !strcmp(current->comm, "walker"))
    		mdelay(2000);
    	return 0;
    }

    static struct kprobe kp = {
    	.symbol_name	= "ext4_get_link",
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
    	 * The delay spins with preemption disabled. Empty this cpu's lru
    	 * batches so that lru_add_drain_all() from invalidate_bdev() has no
    	 * work to wait for here.
    	 */
    	pin(1);
    	p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    	memset(p, 1, 4096);
    	madvise(p, 4096, MADV_COLD);

    	prctl(PR_SET_NAME, "walker");
    	stat("link", &st);
    	return NULL;
    }

    int main(void)
    {
    	struct stat st;
    	pthread_t t;

    	pin(0);
    	chdir("/mnt");
    	stat("link", &st);
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
 fs/ext4/ext4.h           |  2 ++
 fs/ext4/extents-test.c   |  2 ++
 fs/ext4/extents.c        |  1 +
 fs/ext4/extents_status.c |  7 ++++++-
 fs/ext4/extents_status.h |  1 +
 fs/ext4/super.c          | 13 +++++++++++--
 6 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 724a27e8be61..af70bb26bb54 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1774,6 +1774,8 @@ struct ext4_sb_info {
 	struct list_head s_es_list;	/* List of inodes with reclaimable extents */
 	long s_es_nr_inode;
 	struct ext4_es_stats s_es_stats;
+	/* ext4_get_link() reads the sbi in rcu pathwalk */
+	struct rcu_head s_rcu;
 	struct mb_cache *s_ea_block_cache;
 	struct mb_cache *s_ea_inode_cache;
 
diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index c3836ecb89f9..2e997f228330 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -151,6 +151,7 @@ static void extents_kunit_exit(struct kunit *test)
 
 	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
 	ext4_es_unregister_shrinker(sbi);
+	ext4_es_destroy_stats(sbi);
 	deactivate_super(sbi->s_sb);
 	kfree(sbi);
 	kfree(k_ctx.k_ei);
@@ -340,6 +341,7 @@ static int extents_kunit_init(struct kunit *test)
 	k_ctx.k_data = NULL;
 
 	ext4_es_unregister_shrinker(sbi);
+	ext4_es_destroy_stats(sbi);
 out_deactivate:
 	deactivate_locked_super(sb);
 	kfree(sbi);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c3655..3bf0a6cdbec2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6409,6 +6409,7 @@ EXPORT_SYMBOL_FOR_EXT4_TEST(__ext4_ext_dirty);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_zeroout);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_register_shrinker);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_unregister_shrinker);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_destroy_stats);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_map_create_blocks);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_init_tree);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_lookup_extent);
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e8219..018b6146b9d8 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1881,12 +1881,17 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 }
 
 void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
+{
+	shrinker_free(sbi->s_es_shrinker);
+}
+
+/* ext4_get_link() bumps the hit and miss counters in rcu pathwalk */
+void ext4_es_destroy_stats(struct ext4_sb_info *sbi)
 {
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_hits);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
-	shrinker_free(sbi->s_es_shrinker);
 }
 
 /*
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f3396cf32b44..01cddcaaa68e 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -238,6 +238,7 @@ static inline void ext4_es_store_pblock_status(struct extent_status *es,
 
 extern int ext4_es_register_shrinker(struct ext4_sb_info *sbi);
 extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
+extern void ext4_es_destroy_stats(struct ext4_sb_info *sbi);
 
 extern int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bca0dc87d0b7..f028c5835c5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1279,6 +1279,14 @@ static void ext4_flex_groups_free(struct ext4_sb_info *sbi)
 	}
 }
 
+static void ext4_put_sbi_rcu(struct rcu_head *head)
+{
+	struct ext4_sb_info *sbi = container_of(head, struct ext4_sb_info, s_rcu);
+
+	ext4_es_destroy_stats(sbi);
+	kfree(sbi);
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1374,7 +1382,6 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_stop_mmpd(sbi);
 
 	brelse(sbi->s_sbh);
-	sb->s_fs_info = NULL;
 	/*
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
@@ -1387,7 +1394,8 @@ static void ext4_put_super(struct super_block *sb)
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
-	kfree(sbi);
+	/* ext4_get_link() reads the sbi and the counters in rcu pathwalk */
+	call_rcu(&sbi->s_rcu, ext4_put_sbi_rcu);
 }
 
 static struct kmem_cache *ext4_inode_cachep;
@@ -5805,6 +5813,7 @@ failed_mount8: __maybe_unused
 	/* Drain deferred EA inode iputs from journal replay */
 	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_es_unregister_shrinker(sbi);
+	ext4_es_destroy_stats(sbi);
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
 	flush_work(&sbi->s_sb_upd_work);

-- 
2.53.0

