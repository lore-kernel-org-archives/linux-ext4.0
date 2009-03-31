From: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Tue, 31 Mar 2009 14:40:22 +0200
Message-ID: <b637ec0b0903310540s10ddfdb3vcf8e419ebffa09f9@mail.gmail.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	 <20090211075914.GC20842@skywalker>
	 <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	 <20090212211935.GE6922@mini-me.lan>
	 <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
	 <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
	 <20090331123320.GC13356@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	Fabio Comolli <fabio.comolli@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61578 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbZCaMk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 08:40:26 -0400
In-Reply-To: <20090331123320.GC13356@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK. Now I have on my box the 2.6.27.19 kernel. Do you mean that I have
to apply 19->20, 20->21 and then this patch?

Then mount the fs as ext4dev?

Thanks,
=46abio

On Tue, Mar 31, 2009 at 2:33 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Mar 31, 2009 at 02:02:26PM +0200, Fabio Comolli wrote:
>> Is there a patch for 2.6.27.X for people not using git?
>
> These patches that were referenced in the mail thread which you
> replied against have already been integrated into the latest 2.6.27.X
> series.
>
> There is another batch of patches which is being queued for the stabl=
e
> series, which I sent out last week. =C2=A0The for-stable branch and
> for-stable-2.6.27 branches are for people to do a final round of
> testing before I submit them to the stable series. =C2=A0At the momen=
t,
> they are only available via git, but usually after a week or so, I'll
> send them out to stable@kernel.org, and then usually within a week or
> so (unless Greg and Chris are travelling), a new stable series shows
> up with the latest ext4 bug fixes.
>
> If you really are interested in testing the latest pre-release stable
> patches for 2.6.27 --- these are versus 2.6.27.20, they're small
> enough that I'll include them here.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>
> Eric Sandeen (4):
> =C2=A0 =C2=A0 =C2=A0ext4: fix ext4_free_inode() vs. ext4_claim_inode(=
) race
> =C2=A0 =C2=A0 =C2=A0ext4: fix header check in ext4_ext_search_right()=
 for deep extent trees.
> =C2=A0 =C2=A0 =C2=A0ext4: fix bogus BUG_ONs in in mballoc code
> =C2=A0 =C2=A0 =C2=A0ext4: fix bb_prealloc_list corruption due to wron=
g group locking
>
> Theodore Ts'o (1):
> =C2=A0 =C2=A0 =C2=A0ext4: Print the find_group_flex() warning only on=
ce
>
> =C2=A0fs/ext4/extents.c | =C2=A0 =C2=A06 ++++--
> =C2=A0fs/ext4/ialloc.c =C2=A0| =C2=A0 16 ++++++++++------
> =C2=A0fs/ext4/mballoc.c | =C2=A0 13 +++++++++----
> =C2=A03 files changed, 23 insertions(+), 12 deletions(-)
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b24d3c5..acb98c9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1118,7 +1118,8 @@ ext4_ext_search_right(struct inode *inode, stru=
ct ext4_ext_path *path,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_extent_idx *ix;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_extent *ex;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_fsblk_t block;
> - =C2=A0 =C2=A0 =C2=A0 int depth, ee_len;
> + =C2=A0 =C2=A0 =C2=A0 int depth; =C2=A0 =C2=A0 =C2=A0/* Note, NOT eh=
_depth; depth from top of tree */
> + =C2=A0 =C2=A0 =C2=A0 int ee_len;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(path =3D=3D NULL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0depth =3D path->p_depth;
> @@ -1177,7 +1178,8 @@ ext4_ext_search_right(struct inode *inode, stru=
ct ext4_ext_path *path,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bh =3D=3D =
NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return -EIO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eh =3D ext_blo=
ck_hdr(bh);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ext4_ext_check=
_header(inode, eh, depth)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* subtract from p=
_depth to get proper eh_depth */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ext4_ext_check=
_header(inode, eh, path->p_depth - depth)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0put_bh(bh);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return -EIO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index cce841f..b9457e1 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -188,7 +188,7 @@ void ext4_free_inode (handle_t *handle, struct in=
ode * inode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_group_desc * gdp;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_super_block * es;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_sb_info *sbi;
> - =C2=A0 =C2=A0 =C2=A0 int fatal =3D 0, err;
> + =C2=A0 =C2=A0 =C2=A0 int fatal =3D 0, err, cleared;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t flex_group;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_read(&inode->i_count) > 1) {
> @@ -242,10 +242,12 @@ void ext4_free_inode (handle_t *handle, struct =
inode * inode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto error_ret=
urn;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Ok, now we can actually update the inod=
e bitmaps.. */
> - =C2=A0 =C2=A0 =C2=A0 if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, bl=
ock_group),
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bit, bi=
tmap_bh->b_data))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_error (sb, "e=
xt4_free_inode",
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "bit already cleared for inode %lu", ino);
> + =C2=A0 =C2=A0 =C2=A0 spin_lock(sb_bgl_lock(sbi, block_group));
> + =C2=A0 =C2=A0 =C2=A0 cleared =3D ext4_clear_bit(bit, bitmap_bh->b_d=
ata);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock(sb_bgl_lock(sbi, block_group));
> + =C2=A0 =C2=A0 =C2=A0 if (!cleared)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_error(sb, "ex=
t4_free_inode",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0"bit already cleared for inode %lu", ino);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0gdp =3D ext4_g=
et_group_desc (sb, block_group, &bh2);
>
> @@ -685,6 +687,7 @@ struct inode *ext4_new_inode(handle_t *handle, st=
ruct inode * dir, int mode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t i;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int free =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 static int once =3D 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t flex_group;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Cannot create files in a deleted direct=
ory */
> @@ -704,7 +707,8 @@ struct inode *ext4_new_inode(handle_t *handle, st=
ruct inode * dir, int mode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret2 =3D find_=
group_flex(sb, dir, &group);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret2 =3D=3D=
 -1) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ret2 =3D find_group_other(sb, dir, &group);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ret2 =3D=3D 0 && printk_ratelimit())
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ret2 =3D=3D 0 && once)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 once =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_NOTICE "ext4: fin=
d_group_flex "
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "failed=
, fallback succeeded dir %lu\n",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dir->i_=
ino);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 39d7cc1..f34dada 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1450,7 +1450,7 @@ static void ext4_mb_measure_extent(struct ext4_=
allocation_context *ac,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_free_extent *gex =3D &ac->ac_g=
_ex;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(ex->fe_len <=3D 0);
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(ex->fe_len >=3D EXT4_BLOCKS_PER_GROUP(a=
c->ac_sb));
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->=
ac_sb));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(ex->fe_start >=3D EXT4_BLOCKS_PER_G=
ROUP(ac->ac_sb));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(ac->ac_status !=3D AC_STATUS_CONTIN=
UE);
>
> @@ -3400,7 +3400,7 @@ ext4_mb_normalize_request(struct ext4_allocatio=
n_context *ac,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(start + size <=3D ac->ac_o_ex.fe_lo=
gical &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0start > ac->ac_o_ex.fe_logical);
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(size <=3D 0 || size >=3D EXT4_BLOCKS_PE=
R_GROUP(ac->ac_sb));
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(size <=3D 0 || size > EXT4_BLOCKS_PER_G=
ROUP(ac->ac_sb));
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* now prepare goal request */
>
> @@ -3698,6 +3698,7 @@ static void ext4_mb_put_pa(struct ext4_allocati=
on_context *ac,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct super_block *sb, struct ext4_prealloc_space *pa)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long grp;
> + =C2=A0 =C2=A0 =C2=A0 ext4_fsblk_t grp_blk;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!atomic_dec_and_test(&pa->pa_count) ||=
 pa->pa_free !=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> @@ -3712,8 +3713,12 @@ static void ext4_mb_put_pa(struct ext4_allocat=
ion_context *ac,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0pa->pa_deleted =3D 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&pa->pa_lock);
>
> - =C2=A0 =C2=A0 =C2=A0 /* -1 is to protect from crossing allocation g=
roup */
> - =C2=A0 =C2=A0 =C2=A0 ext4_get_group_no_and_offset(sb, pa->pa_pstart=
 - 1, &grp, NULL);
> + =C2=A0 =C2=A0 =C2=A0 grp_blk =3D pa->pa_pstart;
> + =C2=A0 =C2=A0 =C2=A0 /* If linear, pa_pstart may be in the next gro=
up when pa is used up */
> + =C2=A0 =C2=A0 =C2=A0 if (pa->pa_linear)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 grp_blk--;
> +
> + =C2=A0 =C2=A0 =C2=A0 ext4_get_group_no_and_offset(sb, grp_blk, &grp=
, NULL);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * possible race:
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
