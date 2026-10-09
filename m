Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71373F413F;
	Fri,  9 Oct 2026 21:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582743; cv=none; b=OiWTGA3PNnwcRTW+FYcyGlGa6RmNfohve888clRH3pJ2W2SPcKIRem4cMAKxv2gUAgF4p7yPtbI0R+mRa4EZvpOKLhfmkvJtgF/aAYgCUiwI9JP9LsVk6Oo8gdPX0wZlXFeaok8FBHZoRBnUTqE4BHPDm5Tt/Cl2jAgsWXsm+vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582743; c=relaxed/simple;
	bh=0Iol97tQCUvcN8jAcnsQ+kb60LhcDEWu3pxXG2d40jQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AdzU4VMWgY86VnN1uO9foCGO0tYlOdKqUFV7OBotjkvTabCdUNZwdMM3K0pWPZOhSFWFwf1I5RtJ0WPAmZjl2q+61RIt2ffTXannF3CZcshm+BNiJ01xVfmvJifZYnh+Hz8uSDUcXX73aVaINMXYdTOKvYjZ4/UfbxzW2wmX170=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArES8upI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArES8upI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D651F00893;
	Fri,  9 Oct 2026 21:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582742;
	bh=6GhFd4Olb54zm78lphh6MElYuVt+s1T2KsqxnUZWj7o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ArES8upIAkp2mameMbCiEIiZKWD1yPJ40R465Z/mdmkod7b3TEJboskdpPod9VB3p
	 2hNjZsse/ruOiPVfoqOqEq6EMTayDCT7R7PaUeVGjVWYZol8tW5vWfEjIljJDBYYJk
	 5VV7+YSI1FhcJ2muA8o+G0FWsIzzuGIyc4X6gnkvXYwGDQgoomhq/L0NSRoPJiLsTk
	 EhKS5NfUAEI90NiPv3TmKg3l4TyNloUDdcu9zbZHmLpHt1TJwT3nwhUKKqcJXIl0TP
	 LDuKnjCKz0ez1SjyXpMjRUg6Mih0s45VrmElH2ca8bBwQEMpX/aeMIgeIBghLD9XP5
	 ZMVc2YI8FyfjA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:58 +0200
Subject: [PATCH 8/8] ntfs3: free replaced mount options after a grace
 period
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-8-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=6630; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0Iol97tQCUvcN8jAcnsQ+kb60LhcDEWu3pxXG2d40jQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPz74FTlb22VM1dSi1O3vbpacPXI2f7sg02Gset6P
 e/c67j9u6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi16cwMixVXDV7sYDbFi6Z
 p4d47qtGBE6q2RGRP32zaNBBjb3eX1IZGTan/lT7NKki7KWEeA/roj1Rrv0JHvK3Q1h49/01vja
 VnQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ntfs_fs_reconfigure() replaces the old mount options with new mount
options in sbi->options. The old mount options land in fs_context and
are freed as soon as remount returns. With a pathwalk held up in
ntfs_nls_to_utf16() between loading sbi->options and dereferencing it
while a remount replaces them:

  BUG: KASAN: slab-use-after-free in ntfs_nls_to_utf16+0x7ae/0x7c0
  Read of size 8 at addr ff110001044fd448 by task walker/98
  Call Trace:
   <TASK>
   ntfs_nls_to_utf16+0x7ae/0x7c0
   ntfs_d_hash+0x22b/0x500
   link_path_walk+0x11ad/0x1d30
   path_lookupat+0x63/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
  [...]
  Allocated by task 95:
   __kmalloc_node_track_caller_noprof+0x2a2/0x730
   kmemdup_noprof+0x25/0x50
   ntfs_fill_super+0x1e5/0x4550
  [...]
  Freed by task 97:
   kfree+0x1db/0x5b0
   put_fs_context+0x13c/0x7d0
   path_mount+0x54a/0x2130
   __x64_sys_mount+0x20c/0x270

That info is needed in rcu lookup in the dentry hash and dentry compary
methods for ntfs3 and causes a UAF today. Delay freeing with an rcu
grace period.

ntfs_nls_to_utf16() reads ->nls and ->ads once under rcu_read_lock() so
the hooks pair with the release in ntfs_fs_reconfigure(). That also
covers callers outside of rcu pathwalk such as ntfs_lookup(). They don't
hold rcu_read_lock() themselves and wouldn't be protected by the grace
period otherwise. Remount refuses to change the iocharset so ->nls stays
valid after rcu_read_unlock().

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Reproducer: the window is the load of sbi->options in
ntfs_nls_to_utf16() and the dereference right after it, so widen it in
the kernel: split

    struct nls_table *nls = sbi->options->nls;

into a load of sbi->options, an mdelay(2000) when current->comm is
"walker", and the load of ->nls from the options read before the delay.
repro.c then remounts while a task named walker sits in that delay. The
name is not ascii, so ntfs_d_hash() goes through the options.

    mkntfs -F -f -Q /dev/vdb
    mount -t ntfs3 -o nocase,noatime /dev/vdb /mnt
    echo hello > /mnt/$(printf '\303\244')
    ./repro

Without this patch that gives the splat above, with it (and the same
delay between the READ_ONCE() and ->nls) it runs clean.

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
    	pthread_create(&t, NULL, walker, NULL);
    	sleep(1);
    	/* replaces sbi->options and frees the old ones */
    	mount("none", "/mnt", NULL, MS_REMOUNT, "nocase");
    	pthread_join(t, NULL);
    	return 0;
    }
---
 fs/ntfs3/dir.c     | 13 +++++++++++--
 fs/ntfs3/ntfs_fs.h |  2 ++
 fs/ntfs3/super.c   | 16 +++++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index eb9152e9fa22..14ca54e54578 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -186,11 +186,20 @@ int ntfs_nls_to_utf16(struct ntfs_sb_info *sbi, const u8 *name, u32 name_len,
 {
 	int ret, slen, i;
 	const u8 *end;
-	struct nls_table *nls = sbi->options->nls;
+	struct ntfs_mount_options *opts;
+	struct nls_table *nls;
+	bool ads;
 	u16 *uname = uni->name;
 
 	static_assert(sizeof(wchar_t) == sizeof(u16));
 
+	/* ntfs_fs_reconfigure() may replace the options, but not ->nls */
+	rcu_read_lock();
+	opts = READ_ONCE(sbi->options);
+	nls = opts->nls;
+	ads = opts->ads;
+	rcu_read_unlock();
+
 	if (!nls) {
 		/* utf8 -> utf16 */
 		ret = _utf8s_to_utf16s(name, name_len, endian, uname, max_ulen);
@@ -230,7 +239,7 @@ int ntfs_nls_to_utf16(struct ntfs_sb_info *sbi, const u8 *name, u32 name_len,
 
 	uni->len = ret;
 	uni->ads_len = 0;
-	if (ret > 0 && sbi->options->ads) {
+	if (ret > 0 && ads) {
 		uname = uni->name;
 		/* Find delimiter in range [1 : ret-2). */
 		for (i = 1; i + 1 < ret; i++) {
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index bbcd2e02bf63..44d59b444648 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -91,6 +91,8 @@ enum utf16_endian;
 struct ntfs_mount_options {
 	char *nls_name;
 	struct nls_table *nls;
+	/* ->d_hash() and ->d_compare() read the options in rcu pathwalk */
+	struct rcu_head rcu;
 
 	kuid_t fs_uid;
 	kgid_t fs_gid;
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 841f9068d82f..58ef6be3286b 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -251,6 +251,11 @@ static inline void put_mount_options(struct ntfs_mount_options *options)
 	kfree(options);
 }
 
+static void put_mount_options_rcu(struct rcu_head *head)
+{
+	put_mount_options(container_of(head, struct ntfs_mount_options, rcu));
+}
+
 enum Opt {
 	Opt_uid,
 	Opt_gid,
@@ -444,6 +449,7 @@ static int ntfs_fs_reconfigure(struct fs_context *fc)
 	struct super_block *sb = fc->root->d_sb;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	struct ntfs_mount_options *new_opts = fc->fs_private;
+	struct ntfs_mount_options *old_opts;
 	int ro_rw;
 
 	ro_rw = sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY);
@@ -473,7 +479,15 @@ static int ntfs_fs_reconfigure(struct fs_context *fc)
 	}
 
 	sync_filesystem(sb);
-	swap(sbi->options, fc->fs_private);
+	old_opts = sbi->options;
+	/* pairs with the READ_ONCE() in ntfs_nls_to_utf16() */
+	smp_store_release(&sbi->options, new_opts);
+	fc->fs_private = NULL;
+	/*
+	 * ntfs_d_hash() and ntfs_d_compare() of a pathwalk in rcu mode may
+	 * still read the old options through the sbi.
+	 */
+	call_rcu(&old_opts->rcu, put_mount_options_rcu);
 
 	return 0;
 }

-- 
2.53.0

