From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH -v2] ext4: Dynamically allocate the jbd2_inode in
 ext4_inode_info as necessary
Date: Fri, 7 Jan 2011 22:46:29 +0200
Message-ID: <AANLkTikNqeX-e0uLwxG39TW0=qmr21jFs_-rJ1QOxOm2@mail.gmail.com>
References: <20110106221404.GB2857@thunk.org>
	<1294367763-16275-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38641 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AGUqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jan 2011 15:46:30 -0500
Received: by qwa26 with SMTP id 26so18199860qwa.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jan 2011 12:46:29 -0800 (PST)
In-Reply-To: <1294367763-16275-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 7, 2011 at 4:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Replace the jbd2_inode structure (which is 48 bytes) with a pointer
> and only allocate the jbd2_inode when it is needed --- that is, when
> the file system has a journal present and the inode has been opened
> for writing. =A0This allows us to further slim down the ext4_inode_in=
fo
> structure.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>
> I looked into release the jinode structure in ext4_release_file(), bu=
t
> that doesn't work because we need to wait until the delayed allocatio=
n
> is completed. =A0At some point I'll look into adding something that c=
hecks
> to see if we have finished doing the background writeout, but I'm goi=
ng
> to save that for another patch.
>
> =A0fs/ext4/ext4.h =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/ext4/ext4_jbd2.h =A0| =A0 =A02 +-
> =A0fs/ext4/file.c =A0 =A0 =A0 | =A0 22 ++++++++++++++++++++++
> =A0fs/ext4/inode.c =A0 =A0 =A0| =A0 17 ++++++++++++-----
> =A0fs/ext4/super.c =A0 =A0 =A0| =A0 16 +++++++---------
> =A0fs/jbd2/journal.c =A0 =A0| =A0 20 +++++++++++++-------
> =A0include/linux/jbd2.h | =A0 20 ++++++++++++++++++--
> =A07 files changed, 74 insertions(+), 25 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2569c23..2d20424 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -811,7 +811,7 @@ struct ext4_inode_info {
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0struct rw_semaphore i_data_sem;
> =A0 =A0 =A0 =A0struct inode vfs_inode;
> - =A0 =A0 =A0 struct jbd2_inode jinode;
> + =A0 =A0 =A0 struct jbd2_inode *jinode;
>
> =A0 =A0 =A0 =A0struct ext4_ext_cache i_cached_extent;
> =A0 =A0 =A0 =A0/*
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index b0bd792..d8b992e 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -253,7 +253,7 @@ static inline int ext4_journal_force_commit(journ=
al_t *journal)
> =A0static inline int ext4_jbd2_file_inode(handle_t *handle, struct in=
ode *inode)
> =A0{
> =A0 =A0 =A0 =A0if (ext4_handle_valid(handle))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return jbd2_journal_file_inode(handle, =
&EXT4_I(inode)->jinode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return jbd2_journal_file_inode(handle, =
EXT4_I(inode)->jinode);
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 5a5c55d..b1b4884 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -104,6 +104,7 @@ static int ext4_file_open(struct inode * inode, s=
truct file * filp)
> =A0{
> =A0 =A0 =A0 =A0struct super_block *sb =3D inode->i_sb;
> =A0 =A0 =A0 =A0struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> + =A0 =A0 =A0 struct ext4_inode_info *ei =3D EXT4_I(inode);
> =A0 =A0 =A0 =A0struct vfsmount *mnt =3D filp->f_path.mnt;
> =A0 =A0 =A0 =A0struct path path;
> =A0 =A0 =A0 =A0char buf[64], *cp;
> @@ -127,6 +128,27 @@ static int ext4_file_open(struct inode * inode, =
struct file * filp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_mark_super_dirty(=
sb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Set up the jbd2_inode if we are opening the inode =
for
> + =A0 =A0 =A0 =A0* writing and the journal is present
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (sbi->s_journal && !ei->jinode && (filp->f_mode & FM=
ODE_WRITE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct jbd2_inode *jinode =3D jbd2_allo=
c_inode(GFP_KERNEL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&inode->i_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ei->jinode) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!jinode) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&inode->i_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ei->jinode =3D jinode;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_journal_init_jbd_i=
node(ei->jinode, inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jinode =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(jinode !=3D NULL))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_inode(jinode)=
;

actually, I though, jbd2_free_inode would be better off outside the spi=
nlock,
but if you're going to do it here you might just as well change this to=
:
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_inode(jinode);


> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&inode->i_lock);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return dquot_file_open(inode, filp);
> =A0}
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d34ddc6..fb5fe73 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -55,10 +55,17 @@ static inline int ext4_begin_ordered_truncate(str=
uct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0loff_t new_size)
> =A0{
> =A0 =A0 =A0 =A0trace_ext4_begin_ordered_truncate(inode, new_size);
> - =A0 =A0 =A0 return jbd2_journal_begin_ordered_truncate(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_SB(inode->i_sb)->s_journal,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &EXT4_I(inode)->jinode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 new_size);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If jinode is zero, then we never opened the file f=
or
> + =A0 =A0 =A0 =A0* writing, so there's no need to call
> + =A0 =A0 =A0 =A0* jbd2_journal_begin_ordered_truncate() since there'=
s no
> + =A0 =A0 =A0 =A0* outstanding writes we need to flush.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!EXT4_I(inode)->jinode)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 return jbd2_journal_begin_ordered_truncate(EXT4_JOURNAL=
(inode),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->jinode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_size);
> =A0}
>
> =A0static void ext4_invalidatepage(struct page *page, unsigned long o=
ffset);
> @@ -4054,7 +4061,7 @@ int ext4_block_truncate_page(handle_t *handle,
> =A0 =A0 =A0 =A0if (ext4_should_journal_data(inode)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_handle_dirty_metadata(han=
dle, inode, bh);
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_should_order_data(inode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_should_order_data(inode) && EX=
T4_I(inode)->jinode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_jbd2_file=
_inode(handle, inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mark_buffer_dirty(bh);
> =A0 =A0 =A0 =A0}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f5960d6..1cd4326 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -818,12 +818,6 @@ static struct inode *ext4_alloc_inode(struct sup=
er_block *sb)
> =A0 =A0 =A0 =A0memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext=
_cache));
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&ei->i_prealloc_list);
> =A0 =A0 =A0 =A0spin_lock_init(&ei->i_prealloc_lock);
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* Note: =A0We can be called before EXT4_SB(sb)->s_jo=
urnal is set,
> - =A0 =A0 =A0 =A0* therefore it can be null here. =A0Don't check it, =
just initialize
> - =A0 =A0 =A0 =A0* jinode.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode=
);
> =A0 =A0 =A0 =A0ei->i_reserved_data_blocks =3D 0;
> =A0 =A0 =A0 =A0ei->i_reserved_meta_blocks =3D 0;
> =A0 =A0 =A0 =A0ei->i_allocated_meta_blocks =3D 0;
> @@ -832,6 +826,7 @@ static struct inode *ext4_alloc_inode(struct supe=
r_block *sb)
> =A0#ifdef CONFIG_QUOTA
> =A0 =A0 =A0 =A0ei->i_reserved_quota =3D 0;
> =A0#endif
> + =A0 =A0 =A0 ei->jinode =3D NULL;
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&ei->i_completed_io_list);
> =A0 =A0 =A0 =A0spin_lock_init(&ei->i_completed_io_lock);
> =A0 =A0 =A0 =A0ei->cur_aio_dio =3D NULL;
> @@ -900,9 +895,12 @@ void ext4_clear_inode(struct inode *inode)
> =A0 =A0 =A0 =A0end_writeback(inode);
> =A0 =A0 =A0 =A0dquot_drop(inode);
> =A0 =A0 =A0 =A0ext4_discard_preallocations(inode);
> - =A0 =A0 =A0 if (EXT4_JOURNAL(inode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_journal_release_jbd_inode(EXT4_SB(=
inode->i_sb)->s_journal,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&EXT4_I(inode)->jinode);
> + =A0 =A0 =A0 if (EXT4_I(inode)->jinode) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_journal_release_jbd_inode(EXT4_JOU=
RNAL(inode),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->jinode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_inode(EXT4_I(inode)->jinode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(inode)->jinode =3D NULL;
> + =A0 =A0 =A0 }
> =A0}
>
> =A0static inline void ext4_show_quota_options(struct seq_file *seq,
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 2447bd8..9e46869 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -94,6 +94,7 @@ EXPORT_SYMBOL(jbd2_journal_file_inode);
> =A0EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
> =A0EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
> =A0EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
> +EXPORT_SYMBOL(jbd2_inode_cache);
>
> =A0static int journal_convert_superblock_v1(journal_t *, journal_supe=
rblock_t *);
> =A0static void __journal_abort_soft (journal_t *journal, int errno);
> @@ -2286,17 +2287,19 @@ static void __exit jbd2_remove_jbd_stats_proc=
_entry(void)
>
> =A0#endif
>
> -struct kmem_cache *jbd2_handle_cache;
> +struct kmem_cache *jbd2_handle_cache, *jbd2_inode_cache;
>
> =A0static int __init journal_init_handle_cache(void)
> =A0{
> - =A0 =A0 =A0 jbd2_handle_cache =3D kmem_cache_create("jbd2_journal_h=
andle",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
handle_t),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, =A0 =
=A0 =A0 =A0 =A0 =A0 =A0/* offset */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SLAB_TE=
MPORARY, /* flags */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL); =
=A0 =A0 =A0 =A0 =A0/* ctor */
> + =A0 =A0 =A0 jbd2_handle_cache =3D KMEM_CACHE(jbd2_journal_handle, S=
LAB_TEMPORARY);
> =A0 =A0 =A0 =A0if (jbd2_handle_cache =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD: failed to creat=
e handle cache\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD2: failed to crea=
te handle cache\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 jbd2_inode_cache =3D KMEM_CACHE(jbd2_inode, 0);
> + =A0 =A0 =A0 if (jbd2_inode_cache =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD2: failed to crea=
te inode cache\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmem_cache_destroy(jbd2_handle_cache);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return 0;
> @@ -2306,6 +2309,9 @@ static void jbd2_journal_destroy_handle_cache(v=
oid)
> =A0{
> =A0 =A0 =A0 =A0if (jbd2_handle_cache)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmem_cache_destroy(jbd2_handle_cache);
> + =A0 =A0 =A0 if (jbd2_inode_cache)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmem_cache_destroy(jbd2_inode_cache);
> +
> =A0}
>
> =A0/*
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 2ae86aa..27e79c2 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -94,7 +94,7 @@ extern void jbd2_free(void *ptr, size_t size);
> =A0*
> =A0* This is an opaque datatype.
> =A0**/
> -typedef struct handle_s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle_t; =A0=
 =A0 =A0 /* Atomic operation type */
> +typedef struct jbd2_journal_handle handle_t; =A0 /* Atomic operation=
 type */
>
>
> =A0/**
> @@ -416,7 +416,7 @@ struct jbd2_revoke_table_s;
> =A0* in so it can be fixed later.
> =A0*/
>
> -struct handle_s
> +struct jbd2_journal_handle
> =A0{
> =A0 =A0 =A0 =A0/* Which compound transaction is this update a part of=
? */
> =A0 =A0 =A0 =A0transaction_t =A0 =A0 =A0 =A0 =A0 *h_transaction;
> @@ -1158,6 +1158,22 @@ static inline void jbd2_free_handle(handle_t *=
handle)
> =A0 =A0 =A0 =A0kmem_cache_free(jbd2_handle_cache, handle);
> =A0}
>
> +/*
> + * jbd2_inode management (optional, for those file systems that want=
 to use
> + * dynamically allocated jbd2_inode structures)
> + */
> +extern struct kmem_cache *jbd2_inode_cache;
> +
> +static inline struct jbd2_inode *jbd2_alloc_inode(gfp_t gfp_flags)
> +{
> + =A0 =A0 =A0 return kmem_cache_alloc(jbd2_inode_cache, gfp_flags);
> +}
> +
> +static inline void jbd2_free_inode(struct jbd2_inode *jinode)
> +{
> + =A0 =A0 =A0 kmem_cache_free(jbd2_inode_cache, jinode);
> +}
> +
> =A0/* Primary revoke support */
> =A0#define JOURNAL_REVOKE_DEFAULT_HASH 256
> =A0extern int =A0 =A0 =A0 =A0jbd2_journal_init_revoke(journal_t *, in=
t);
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
