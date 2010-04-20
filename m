From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Tue, 20 Apr 2010 17:21:03 -0400
Message-ID: <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <1271674527-2977-2-git-send-email-lczerner@redhat.com>
	 <1271674527-2977-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Mark Lord <kernel@teksavvy.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62148 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0DTV22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Apr 2010 17:28:28 -0400
Received: by pvg13 with SMTP id 13so355272pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Apr 2010 14:28:28 -0700 (PDT)
In-Reply-To: <1271674527-2977-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mark,

This is the patch implementing the new discard logic.

You did the benchmarking last year, but I thought you found calling
trim one contiguous sector range at a time was too inefficient.

See my highlight below:

On Mon, Apr 19, 2010 at 6:55 AM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> Create an ioctl which walks through all the free extents in each
> allocating group and discard those extents. As an addition to improve
> its performance one can specify minimum free extent length, so ioctl
> will not bother with shorter extents.
>
> This of course means, that with each invocation the ioctl must walk
> through whole file system, checking and discarding free extents, whic=
h
> is not very efficient. The best way to avoid this is to keep track of
> deleted (freed) blocks. Then the ioctl have to trim just those free
> extents which were recently freed.
>
> In order to implement this I have added new bitmap into ext4_group_in=
fo
> (bb_bitmap_deleted) which stores recently freed blocks. The ioctl the=
n
> walk through bb_bitmap_deleted, compare deleted extents with free
> extents trim them and then removes it from the bb_bitmap_deleted.
>
> But you may notice, that there is one problem. bb_bitmap_deleted does
> not survive umount. To bypass the problem the first ioctl call have t=
o
> walk through whole file system trimming all free extents.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A04 +
> =A0fs/ext4/mballoc.c | =A0207 +++++++++++++++++++++++++++++++++++++++=
+++++++++++---
> =A0fs/ext4/super.c =A0 | =A0 =A01 +
> =A03 files changed, 202 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bf938cf..e25f672 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1437,6 +1437,8 @@ extern int ext4_mb_add_groupinfo(struct super_b=
lock *sb,
> =A0extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4=
_group_t);
> =A0extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ext4_group_t, int);
> +extern int ext4_trim_fs(unsigned int, struct super_block *);
> +
> =A0/* inode.c */
> =A0struct buffer_head *ext4_getblk(handle_t *, struct inode *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t, int, int *);
> @@ -1682,6 +1684,8 @@ struct ext4_group_info {
> =A0#ifdef DOUBLE_CHECK
> =A0 =A0 =A0 =A0void =A0 =A0 =A0 =A0 =A0 =A0*bb_bitmap;
> =A0#endif
> + =A0 =A0 =A0 void =A0 =A0 =A0 =A0 =A0 =A0*bb_bitmap_deleted;
> + =A0 =A0 =A0 ext4_grpblk_t =A0 bb_deleted;
> =A0 =A0 =A0 =A0struct rw_semaphore alloc_sem;
> =A0 =A0 =A0 =A0ext4_grpblk_t =A0 bb_counters[]; =A0/* Nr of free powe=
r-of-two-block
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 * regions, index is order.
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bde9d0b..fbc83fe 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2255,6 +2255,9 @@ int ext4_mb_add_groupinfo(struct super_block *s=
b, ext4_group_t group,
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
> =A0 =A0 =A0 =A0init_rwsem(&meta_group_info[i]->alloc_sem);
> =A0 =A0 =A0 =A0meta_group_info[i]->bb_free_root =3D RB_ROOT;
> + =A0 =A0 =A0 meta_group_info[i]->bb_deleted =3D -1;
> +
> +
>
> =A0#ifdef DOUBLE_CHECK
> =A0 =A0 =A0 =A0{
> @@ -2469,6 +2472,7 @@ int ext4_mb_release(struct super_block *sb)
> =A0#ifdef DOUBLE_CHECK
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(grinfo->bb_bitma=
p);
> =A0#endif
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(grinfo->bb_bitmap=
_deleted);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_lock_group(sb, i)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_mb_cleanup_pa(gri=
nfo);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_unlock_group(sb, =
i);
> @@ -2528,6 +2532,7 @@ static void release_blocks_on_commit(journal_t =
*journal, transaction_t *txn)
> =A0 =A0 =A0 =A0int err, count =3D 0, count2 =3D 0;
> =A0 =A0 =A0 =A0struct ext4_free_data *entry;
> =A0 =A0 =A0 =A0struct list_head *l, *ltmp;
> + =A0 =A0 =A0 void *bitmap_deleted =3D NULL;
>
> =A0 =A0 =A0 =A0list_for_each_safe(l, ltmp, &txn->t_private_list) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D list_entry(l, struct ext4_fr=
ee_data, list);
> @@ -2543,6 +2548,14 @@ static void release_blocks_on_commit(journal_t=
 *journal, transaction_t *txn)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* there are blocks to put in buddy to=
 make them really free */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count +=3D entry->count;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count2++;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(sb, DISCARD) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (db->bb_bitmap_deleted =
=3D=3D NULL) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (db->bb_deleted >=3D 0)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bitmap_deleted =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmalloc=
(sb->s_blocksize, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_lock_group(sb, entry->group);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Take it out of per group rb tree */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rb_erase(&entry->node, &(db->bb_free_r=
oot));
> @@ -2555,17 +2568,24 @@ static void release_blocks_on_commit(journal_=
t *journal, transaction_t *txn)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(e4b=
=2Ebd_buddy_page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(e4b=
=2Ebd_bitmap_page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_unlock_group(sb, entry->group);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(sb, DISCARD)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t discard_bl=
ock;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 discard_block =3D entry=
->start_blk +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_gr=
oup_first_block_no(sb, entry->group);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_ext4_discard_bloc=
ks(sb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (unsigned long long)discard_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 entry->count);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb_issue_discard(sb, di=
scard_block, entry->count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(sb, DISCARD) && (db->bb_de=
leted >=3D 0)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (db->bb_bitmap_delet=
ed =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 db->bb_=
bitmap_deleted =3D bitmap_deleted;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(=
db->bb_bitmap_deleted =3D=3D NULL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bitmap_=
deleted =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_clea=
r_bits(db->bb_bitmap_deleted,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0, EXT4_BLOCKS_PER_GROUP(sb));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 db->bb_deleted +=3D ent=
ry->count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_set_bits(db->bb_bitm=
ap_deleted, entry->start_blk,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entr=
y->count);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_unlock_group(sb, entry->group);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(bitmap_deleted);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmem_cache_free(ext4_free_ext_cachep, =
entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_mb_release_desc(&e4b);
> =A0 =A0 =A0 =A0}
> @@ -4639,3 +4659,170 @@ error_return:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmem_cache_free(ext4_ac_cachep, ac);
> =A0 =A0 =A0 =A0return;
> =A0}
> +
> +/* Trim "count" blocks starting at "start" in "group"
> + * This must be called under group lock
> + */
> +void ext4_trim_extent(struct super_block *sb, int start, int count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t group, struct ext4_buddy *=
e4b)
> +{
> + =A0 =A0 =A0 ext4_fsblk_t discard_block;
> + =A0 =A0 =A0 struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> + =A0 =A0 =A0 struct ext4_free_extent ex;
> +
> + =A0 =A0 =A0 assert_spin_locked(ext4_group_lock_ptr(sb, group));
> +
> + =A0 =A0 =A0 ex.fe_start =3D start;
> + =A0 =A0 =A0 ex.fe_group =3D group;
> + =A0 =A0 =A0 ex.fe_len =3D count;
> +
> + =A0 =A0 =A0 mb_mark_used(e4b, &ex);
> + =A0 =A0 =A0 ext4_unlock_group(sb, group);
> +
> + =A0 =A0 =A0 discard_block =3D (ext4_fsblk_t)group *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_GROUP(s=
b)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + start
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + le32_to_cpu(es->s_fir=
st_data_block);
> + =A0 =A0 =A0 trace_ext4_discard_blocks(sb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)dis=
card_block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count);
> + =A0 =A0 =A0 sb_issue_discard(sb, discard_block, count);
> +
> + =A0 =A0 =A0 ext4_lock_group(sb, group);
> + =A0 =A0 =A0 mb_free_blocks(NULL, e4b, start, ex.fe_len);
> +}

Mark, unless I'm missing something, sb_issue_discard() above is going
to trigger a trim command for just the one range.  I thought the
benchmarks you did showed that a collection of ranges needed to be
built, then a single trim command invoked that trimmed that group of
ranges.

Greg

> +
> +/* Trim all free blocks, which have at least minlen length */
> +ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4=
_buddy *e4b,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_grpblk_t minblocks)
> +{
> + =A0 =A0 =A0 void *bitmap;
> + =A0 =A0 =A0 ext4_grpblk_t max =3D EXT4_BLOCKS_PER_GROUP(sb);
> + =A0 =A0 =A0 ext4_grpblk_t start, next, count =3D 0;
> + =A0 =A0 =A0 ext4_group_t group;
> +
> + =A0 =A0 =A0 BUG_ON(e4b =3D=3D NULL);
> +
> + =A0 =A0 =A0 bitmap =3D e4b->bd_bitmap;
> + =A0 =A0 =A0 group =3D e4b->bd_group;
> + =A0 =A0 =A0 start =3D 0;
> + =A0 =A0 =A0 ext4_lock_group(sb, group);
> +
> + =A0 =A0 =A0 while (start < max) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D mb_find_next_zero_bit(bitmap,=
 max, start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (start >=3D max)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D mb_find_next_bit(bitmap, max, =
start);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((next - start) >=3D minblocks) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=3D next - start=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_trim_extent(sb, st=
art,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next - =
start, group, e4b);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D next + 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 e4b->bd_info->bb_deleted =3D 0;
> + =A0 =A0 =A0 ext4_unlock_group(sb, group);
> +
> + =A0 =A0 =A0 return count;
> +}
> +
> +/* Trim only blocks which is free and in bb_bitmap_deleted */
> +ext4_grpblk_t ext4_trim_deleted(struct super_block *sb, struct ext4_=
buddy *e4b,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_grpblk_t minblocks)
> +{
> + =A0 =A0 =A0 void *bitmap;
> + =A0 =A0 =A0 struct ext4_group_info *grp;
> + =A0 =A0 =A0 ext4_group_t group;
> + =A0 =A0 =A0 ext4_grpblk_t max, next, count =3D 0, start =3D 0;
> +
> + =A0 =A0 =A0 BUG_ON(e4b =3D=3D NULL);
> +
> + =A0 =A0 =A0 bitmap =3D e4b->bd_bitmap;
> + =A0 =A0 =A0 group =3D e4b->bd_group;
> + =A0 =A0 =A0 grp =3D ext4_get_group_info(sb, group);
> +
> + =A0 =A0 =A0 if (grp->bb_deleted < minblocks)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 ext4_lock_group(sb, group);
> +
> + =A0 =A0 =A0 while (start < EXT4_BLOCKS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D mb_find_next_bit(grp->bb_bitm=
ap_deleted,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_GROUP(s=
b), start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 max =3D mb_find_next_zero_bit(grp->bb_b=
itmap_deleted,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_GROUP(s=
b), start);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (start < max) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D mb_find_next_=
zero_bit(bitmap, max, start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (start >=3D max)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D mb_find_next_b=
it(bitmap, max, start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (next > max)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D=
 max;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((next - start) >=3D=
 minblocks) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=
=3D next - start;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_tr=
im_extent(sb, start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 next - start, group, e4b);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_clea=
r_bits(grp->bb_bitmap_deleted,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 start, next - start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D next + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 grp->bb_deleted -=3D count;
> +
> + =A0 =A0 =A0 ext4_unlock_group(sb, group);
> +
> + =A0 =A0 =A0 ext4_debug("trimmed %d blocks in the group %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 count, group);
> +
> + =A0 =A0 =A0 return count;
> +}
> +
> +int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
> +{
> + =A0 =A0 =A0 struct ext4_buddy e4b;
> + =A0 =A0 =A0 struct ext4_group_info *grp;
> + =A0 =A0 =A0 ext4_group_t group;
> + =A0 =A0 =A0 ext4_group_t ngroups =3D ext4_get_groups_count(sb);
> + =A0 =A0 =A0 ext4_grpblk_t minblocks;
> +
> + =A0 =A0 =A0 if (!test_opt(sb, DISCARD))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 minblocks =3D DIV_ROUND_UP(minlen, sb->s_blocksize);
> + =A0 =A0 =A0 if (unlikely(minblocks > EXT4_BLOCKS_PER_GROUP(sb)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 for (group =3D 0; group < ngroups; group++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_mb_load_buddy(sb, group, &=
e4b);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(sb, "Error i=
n loading buddy "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "information for %u", group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 grp =3D ext4_get_group_info(sb, group);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (grp->bb_deleted < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* First run after moun=
t */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_trim_all_free(sb, =
&e4b, minblocks);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (grp->bb_deleted >=3D minbloc=
ks) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Trim only blocks del=
eted since first run */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_trim_deleted(sb, &=
e4b, minblocks);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mb_release_desc(&e4b);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e14d22c..253eb98 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1109,6 +1109,7 @@ static const struct super_operations ext4_sops =
=3D {
> =A0 =A0 =A0 =A0.quota_write =A0 =A0=3D ext4_quota_write,
> =A0#endif
> =A0 =A0 =A0 =A0.bdev_try_to_free_page =3D bdev_try_to_free_page,
> + =A0 =A0 =A0 .trim_fs =A0 =A0 =A0 =A0=3D ext4_trim_fs
> =A0};
>
> =A0static const struct super_operations ext4_nojournal_sops =3D {
> --
> 1.6.6.1
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
