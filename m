From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: improve smp scalability for inode generation
Date: Fri, 10 Nov 2017 17:57:21 -0500
Message-ID: <20171110225721.emmi6gaafcdgahxu@thunk.org>
References: <8760bcpdc8.fsf@openvz.org>
 <00F078D1-39E9-4F16-8B5B-6952645846E5@dilger.ca>
 <20171109032320.dnuhngfcvldliysz@thunk.org>
 <87r2t6jay4.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34430 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753825AbdKJW5X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 10 Nov 2017 17:57:23 -0500
Content-Disposition: inline
In-Reply-To: <87r2t6jay4.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 10, 2017 at 08:33:07PM +0300, Dmitry Monakhov wrote:
> I do not forget about your patch but it looks like some very strange
> things happens since last measurements. create_unlink scenario degradates
> significantly from 8-16 threads. It looks like something contented on
> VFS because I see same result on xfs.
> Even more I do not see this contention with 'perf lock record'. Probably
> this is because some crappy locking primitives like hlist_bl which has
> no lockdep/lockstat support. I'll notify you once found something.

OK, I have another version of this patch in response to some concerns
Andreas had over a potential birthday attack issue with using
prandom_u32().  Actually, after looking at this more closely, the
birthday attack doesn't apply, since what matters isn't collisions
between arbitrary generation numbers (or more specifically, NFS file
handles using previousl generation numbers).  The problem only arises
when current incarnation of the inode uses a generation number which
has been used by a previous incarnation of the inode still cached at
some NFS client.

I'm still going back and forth about whether we should use this
version or the one I had posted earlier.  I suspect it's six of one,
half-dozen of the other...

						- Ted

commit f2a95d428e1f6f6fc3d70764d209673047545aa0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Nov 10 16:25:57 2017 -0500

    ext4: improve smp scalability for inode generation
    
    ->s_next_generation is protected by s_next_gen_lock but its usage
    pattern is very primitive.  Replace it with a per-cpu set of
    counters.
    
    Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 53ce95b52fd8..167457109457 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1355,8 +1355,6 @@ struct ext4_sb_info {
 	int s_first_ino;
 	unsigned int s_inode_readahead_blks;
 	unsigned int s_inode_goal;
-	spinlock_t s_next_gen_lock;
-	u32 s_next_generation;
 	u32 s_hash_seed[4];
 	int s_def_hash_version;
 	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
@@ -2371,6 +2369,8 @@ extern int ext4fs_dirhash(const char *name, int len, struct
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
+void __init ext4_generation_setup(void);
+__u32 ext4_new_generation(void);
 extern struct inode *__ext4_new_inode(handle_t *, struct inode *, umode_t,
 				      const struct qstr *qstr, __u32 goal,
 				      uid_t *owner, __u32 i_flags,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ee823022aa34..ccf250343768 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -758,6 +758,24 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 	return 1;
 }
 
+static DEFINE_PER_CPU(__u32, generation_counter);
+
+void __init ext4_generation_setup(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		__u32 *p = per_cpu_ptr(&generation_counter, cpu);
+
+		*p = prandom_u32();
+	}
+}
+
+__u32 ext4_new_generation(void)
+{
+	return this_cpu_inc_return(generation_counter);
+}
+
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -1138,9 +1156,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 			   inode->i_ino);
 		goto out;
 	}
-	spin_lock(&sbi->s_next_gen_lock);
-	inode->i_generation = sbi->s_next_generation++;
-	spin_unlock(&sbi->s_next_gen_lock);
+	inode->i_generation = ext4_new_generation();
 
 	/* Precompute checksum seed for inode metadata */
 	if (ext4_has_metadata_csum(sb)) {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 144bbda2b808..14d41d122907 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -157,10 +157,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
 
-	spin_lock(&sbi->s_next_gen_lock);
-	inode->i_generation = sbi->s_next_generation++;
-	inode_bl->i_generation = sbi->s_next_generation++;
-	spin_unlock(&sbi->s_next_gen_lock);
+	inode->i_generation = ext4_new_generation();
+	inode_bl->i_generation = ext4_new_generation();
 
 	ext4_discard_preallocations(inode);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3a278faf5868..49aef2e30f9d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3982,8 +3982,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sbi->s_gdb_count = db_count;
-	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
-	spin_lock_init(&sbi->s_next_gen_lock);
 
 	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
 
@@ -5793,6 +5791,7 @@ static int __init ext4_init_fs(void)
 
 	/* Build-time check for flags consistency */
 	ext4_check_flag_values();
+	ext4_generation_setup();
 
 	for (i = 0; i < EXT4_WQ_HASH_SZ; i++)
 		init_waitqueue_head(&ext4__ioend_wq[i]);
