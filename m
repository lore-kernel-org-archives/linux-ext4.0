From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 09/30] ext4: snapshot file
Date: Thu, 2 Jun 2011 14:52:37 +0300
Message-ID: <BANLkTi=DPMtPPk4kEWTyHtv519ZKRDfOXg@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-10-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1FBLwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 07:52:39 -0400
Received: by wwa36 with SMTP id 36so809615wwa.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jun 2011 04:52:38 -0700 (PDT)
In-Reply-To: <1304959308-11122-10-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Naturally, I have already fixed this issue, but in case someone was
going to review
this patch, I just wanted to bring the issue out there.

On Mon, May 9, 2011 at 7:41 PM,  <amir73il@users.sourceforge.net> wrote=
:
> From: Amir Goldstein <amir73il@users.sf.net>
>
> Ext4 snapshot implementation as a file inside the file system.
> Snapshot files are marked with the snapfile flag and have special
> read-only address space ops.
>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/ext4.h =A0 =A0 =A0| =A0 83 +++++++++++++++++++++++++++++++=
++++++++++++++++++--
> =A0fs/ext4/ext4_jbd2.h | =A0 =A02 +
> =A0fs/ext4/ialloc.c =A0 =A0| =A0 =A08 ++++-
> =A0fs/ext4/inode.c =A0 =A0 | =A0 29 ++++++++++++++++++
> =A0fs/ext4/super.c =A0 =A0 | =A0 =A09 +++++
> =A05 files changed, 126 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 013eec2..4072036 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -361,17 +361,23 @@ struct flex_groups {
> =A0#define EXT4_EXTENTS_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x00080000 /* Inode uses extents */
> =A0#define EXT4_EA_INODE_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00200000 /*=
 Inode used for large EA */
> =A0#define EXT4_EOFBLOCKS_FL =A0 =A0 =A0 =A0 =A0 =A0 =A00x00400000 /*=
 Blocks allocated beyond EOF */
> +/* snapshot persistent flags */
> +#define EXT4_SNAPFILE_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x01000000 /* s=
napshot file */
> +#define EXT4_SNAPFILE_DELETED_FL =A0 =A0 =A0 0x04000000 /* snapshot =
is deleted */
> +#define EXT4_SNAPFILE_SHRUNK_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x080=
00000 /* snapshot was shrunk */
> +/* end of snapshot flags */
> =A0#define EXT4_RESERVED_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x80000000 /*=
 reserved for ext4 lib */
>
> -#define EXT4_FL_USER_VISIBLE =A0 =A0 =A0 =A0 =A0 0x004BDFFF /* User =
visible flags */
> -#define EXT4_FL_USER_MODIFIABLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x004=
B80FF /* User modifiable flags */
> +
> +#define EXT4_FL_USER_VISIBLE =A0 =A0 =A0 =A0 =A0 0x014BDFFF /* User =
visible flags */
> +#define EXT4_FL_USER_MODIFIABLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x014=
B80FF /* User modifiable flags */
>
> =A0/* Flags that should be inherited by new inodes from their parent.=
 */
> =A0#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COM=
PR_FL |\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SYNC_FL | EX=
T4_IMMUTABLE_FL | EXT4_APPEND_FL |\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_NODUMP_FL | =
EXT4_NOATIME_FL |\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_NOCOMPR_FL |=
 EXT4_JOURNAL_DATA_FL |\
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_NOTAIL_FL |=
 EXT4_DIRSYNC_FL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_NOTAIL_FL |=
 EXT4_DIRSYNC_FL | EXT4_SNAPFILE_FL)
>
> =A0/* Flags that are appropriate for regular files (all but dir-speci=
fic ones). */
> =A0#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
> @@ -418,6 +424,9 @@ enum {
> =A0 =A0 =A0 =A0EXT4_INODE_EXTENTS =A0 =A0 =A0=3D 19, =A0 /* Inode use=
s extents */
> =A0 =A0 =A0 =A0EXT4_INODE_EA_INODE =A0 =A0 =3D 21, =A0 /* Inode used =
for large EA */
> =A0 =A0 =A0 =A0EXT4_INODE_EOFBLOCKS =A0 =A0=3D 22, =A0 /* Blocks allo=
cated beyond EOF */
> + =A0 =A0 =A0 EXT4_INODE_SNAPFILE =A0 =A0 =3D 24, =A0 /* Snapshot fil=
e/dir */
> + =A0 =A0 =A0 EXT4_INODE_SNAPFILE_DELETED =3D 26, =A0 =A0 =A0 /* Snap=
shot is deleted */
> + =A0 =A0 =A0 EXT4_INODE_SNAPFILE_SHRUNK =3D 27, =A0 =A0 =A0 =A0/* Sn=
apshot was shrunk */
> =A0 =A0 =A0 =A0EXT4_INODE_RESERVED =A0 =A0 =3D 31, =A0 /* reserved fo=
r ext4 lib */
> =A0};
>
> @@ -464,6 +473,9 @@ static inline void ext4_check_flag_values(void)
> =A0 =A0 =A0 =A0CHECK_FLAG_VALUE(EXTENTS);
> =A0 =A0 =A0 =A0CHECK_FLAG_VALUE(EA_INODE);
> =A0 =A0 =A0 =A0CHECK_FLAG_VALUE(EOFBLOCKS);
> + =A0 =A0 =A0 CHECK_FLAG_VALUE(SNAPFILE);
> + =A0 =A0 =A0 CHECK_FLAG_VALUE(SNAPFILE_DELETED);
> + =A0 =A0 =A0 CHECK_FLAG_VALUE(SNAPFILE_SHRUNK);
> =A0 =A0 =A0 =A0CHECK_FLAG_VALUE(RESERVED);
> =A0}
>
> @@ -803,6 +815,14 @@ struct ext4_inode_info {
> =A0 =A0 =A0 =A0struct list_head i_orphan; =A0 =A0 =A0/* unlinked but =
open inodes */
>
> =A0 =A0 =A0 =A0/*
> + =A0 =A0 =A0 =A0* In-memory snapshot list overrides i_orphan to link=
 snapshot inodes,
> + =A0 =A0 =A0 =A0* but unlike the real orphan list, the next snapshot=
 inode number
> + =A0 =A0 =A0 =A0* is stored in i_next_snapshot_ino and not in i_dtim=
e
> + =A0 =A0 =A0 =A0*/
> +#define i_snaplist i_orphan
> + =A0 =A0 =A0 __u32 =A0 i_next_snapshot_ino;
> +
> + =A0 =A0 =A0 /*
> =A0 =A0 =A0 =A0 * i_disksize keeps track of what the inode size is ON=
 DISK, not
> =A0 =A0 =A0 =A0 * in memory. =A0During truncate, i_size is set to the=
 new size by
> =A0 =A0 =A0 =A0 * the VFS prior to calling ext4_truncate(), but the f=
ilesystem won't
> @@ -1158,6 +1178,8 @@ struct ext4_sb_info {
> =A0 =A0 =A0 =A0u32 s_max_batch_time;
> =A0 =A0 =A0 =A0u32 s_min_batch_time;
> =A0 =A0 =A0 =A0struct block_device *journal_bdev;
> + =A0 =A0 =A0 struct mutex s_snapshot_mutex; =A0 =A0 =A0 =A0 =A0/* pr=
otects 2 fields below: */
> + =A0 =A0 =A0 struct inode *s_active_snapshot; =A0 =A0 =A0 =A0/* [ s_=
snapshot_mutex ] */
> =A0#ifdef CONFIG_JBD2_DEBUG
> =A0 =A0 =A0 =A0struct timer_list turn_ro_timer; =A0 =A0 =A0 =A0/* For=
 turning read-only (crash simulation) */
> =A0 =A0 =A0 =A0wait_queue_head_t ro_wait_queue; =A0 =A0 =A0 =A0/* For=
 people waiting for the fs to go read-only */
> @@ -1274,8 +1296,31 @@ enum {
> =A0 =A0 =A0 =A0EXT4_STATE_DIO_UNWRITTEN, =A0 =A0 =A0 /* need convert =
on dio done*/
> =A0 =A0 =A0 =A0EXT4_STATE_NEWENTRY, =A0 =A0 =A0 =A0 =A0 =A0/* File ju=
st added to dir */
> =A0 =A0 =A0 =A0EXT4_STATE_DELALLOC_RESERVED, =A0 /* blks already rese=
rved for delalloc */
> + =A0 =A0 =A0 EXT4_STATE_LAST
> =A0};
>
> +/*
> + * Snapshot dynamic state flags (starting at offset EXT4_STATE_LAST)
> + * These flags are read by GETSNAPFLAGS ioctl and interpreted by the=
 lssnap
> + * utility. =A0Do not change these values.
> + */
> +enum {
> + =A0 =A0 =A0 EXT4_SNAPSTATE_LIST =3D 0, =A0 =A0 =A0 =A0/* snapshot i=
s on list (S) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_ENABLED =3D 1, =A0 =A0 /* snapshot is en=
abled (n) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_ACTIVE =3D 2, =A0 =A0 =A0/* snapshot is =
active =A0(a) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_INUSE =3D 3, =A0 =A0 =A0 /* snapshot is =
in-use =A0(p) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_DELETED =3D 4, =A0 =A0 /* snapshot is de=
leted (s) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_SHRUNK =3D 5, =A0 =A0 =A0/* snapshot was=
 shrunk (h) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_OPEN =3D 6, =A0 =A0 =A0 =A0/* snapshot i=
s mounted (o) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_TAGGED =3D 7, =A0 =A0 =A0/* snapshot is =
tagged =A0(t) */
> + =A0 =A0 =A0 EXT4_SNAPSTATE_LAST
> +};
> +
> +#define EXT4_SNAPSTATE_MASK =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 ((1UL << EXT4_SNAPSTATE_LAST) - 1)
> +
> +
> +/* atomic single bit funcs */
> =A0#define EXT4_INODE_BIT_FNS(name, field, offset) =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0static inline int ext4_test_inode_##name(struct inode *inode, int =
bit) \
> =A0{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0\
> @@ -1290,9 +1335,28 @@ static inline void ext4_clear_inode_##name(str=
uct inode *inode, int bit) \
> =A0 =A0 =A0 =A0clear_bit(bit + (offset), &EXT4_I(inode)->i_##field); =
=A0 =A0 =A0 =A0 =A0 \
> =A0}
>
> +/* non-atomic multi bit funcs */
> +#define EXT4_INODE_FLAGS_FNS(name, field, offset) =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0\
> +static inline int ext4_get_##name##_flags(struct inode *inode) =A0 =A0=
 =A0 =A0 \
> +{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
\
> + =A0 =A0 =A0 return EXT4_I(inode)->i_##field >> (offset); =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> +} =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
\
> +static inline void ext4_set_##name##_flags(struct inode *inode, =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long flags) =A0 =A0\
> +{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
\
> + =A0 =A0 =A0 EXT4_I(inode)->i_##field |=3D (flags << (offset)); =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0\
> +} =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
\
> +static inline void ext4_clear_##name##_flags(struct inode *inode, =A0=
 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long flags) =A0 =A0\
> +{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
\
> + =A0 =A0 =A0 EXT4_I(inode)->i_##field &=3D ~(flags << (offset)); =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 \
> +}
> +

This was not a good idea!
We must not use non-atmoic bit ops to set bits on the inode's flags
fields, which other tasks use atomic bit ops to set.
We can do without the set and clear funcs, so remove them
and use atomic bit ops funcs instead.

> =A0EXT4_INODE_BIT_FNS(flag, flags, 0)
> =A0#if (BITS_PER_LONG < 64)
> =A0EXT4_INODE_BIT_FNS(state, state_flags, 0)
> +EXT4_INODE_BIT_FNS(snapstate, state_flags, EXT4_STATE_LAST)
> +EXT4_INODE_FLAGS_FNS(snapstate, state_flags, EXT4_STATE_LAST)
>
> =A0static inline void ext4_clear_state_flags(struct ext4_inode_info *=
ei)
> =A0{
> @@ -1300,6 +1364,8 @@ static inline void ext4_clear_state_flags(struc=
t ext4_inode_info *ei)
> =A0}
> =A0#else
> =A0EXT4_INODE_BIT_FNS(state, flags, 32)
> +EXT4_INODE_BIT_FNS(snapstate, flags, 32 + EXT4_STATE_LAST)
> +EXT4_INODE_FLAGS_FNS(snapstate, flags, 32 + EXT4_STATE_LAST)
>
> =A0static inline void ext4_clear_state_flags(struct ext4_inode_info *=
ei)
> =A0{
> @@ -1314,6 +1380,7 @@ static inline void ext4_clear_state_flags(struc=
t ext4_inode_info *ei)
> =A0#endif
>
> =A0#define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
> +#define NEXT_SNAPSHOT(inode) (EXT4_I(inode)->i_next_snapshot_ino)
>
> =A0/*
> =A0* Codes for operating systems
> @@ -1781,6 +1848,10 @@ extern int ext4_page_mkwrite(struct vm_area_st=
ruct *vma, struct vm_fault *vmf);
> =A0extern qsize_t *ext4_get_reserved_space(struct inode *inode);
> =A0extern void ext4_da_update_reserve_space(struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0int used, int quota_claim);
> +
> +/* snapshot_inode.c */
> +extern int ext4_snapshot_readpage(struct file *file, struct page *pa=
ge);
> +
> =A0/* ioctl.c */
> =A0extern long ext4_ioctl(struct file *, unsigned int, unsigned long)=
;
> =A0extern long ext4_compat_ioctl(struct file *, unsigned int, unsigne=
d long);
> @@ -2004,6 +2075,12 @@ struct ext4_group_info {
> =A0 =A0 =A0 =A0void =A0 =A0 =A0 =A0 =A0 =A0*bb_bitmap;
> =A0#endif
> =A0 =A0 =A0 =A0struct rw_semaphore alloc_sem;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* bg_cow_bitmap is reset to zero on mount time and o=
n every snapshot
> + =A0 =A0 =A0 =A0* take and initialized lazily on first block group w=
rite access.
> + =A0 =A0 =A0 =A0* bg_cow_bitmap is protected by sb_bgl_lock().
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 unsigned long bg_cow_bitmap; =A0 =A0/* COW bitmap cache=
 */
> =A0 =A0 =A0 =A0ext4_grpblk_t =A0 bb_counters[]; =A0/* Nr of free powe=
r-of-two-block
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 * regions, index is order.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 * bb_counters[3] =3D 5 means
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index ea3a0a0..e0fef0d 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -369,6 +369,8 @@ static inline int ext4_snapshot_should_move_data(=
struct inode *inode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0if (EXT4_JOURNAL(inode) =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> + =A0 =A0 =A0 if (ext4_snapshot_excluded(inode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> =A0 =A0 =A0 =A0/* when a data block is journaled, it is already COWed=
 as metadata */
> =A0 =A0 =A0 =A0if (ext4_should_journal_data(inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 831d49a..ba928a7 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1048,8 +1048,12 @@ got:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail_free_drop;
>
> =A0 =A0 =A0 =A0if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPA=
T_EXTENTS)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* set extent flag only for directory, =
file and normal symlink*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (S_ISDIR(mode) || S_ISREG(mode) || S=
_ISLNK(mode)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Set extent flag only for non-snaps=
hot file, directory
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* and normal symlink
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((S_ISREG(mode) && !ext4_snapshot_fi=
le(inode)) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 S_ISDIR=
(mode) || S_ISLNK(mode)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_set_inode_flag(in=
ode, EXT4_INODE_EXTENTS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_tree_init(han=
dle, inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 866ac36..4ec5f02 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4162,9 +4162,38 @@ static const struct address_space_operations e=
xt4_da_aops =3D {
> =A0 =A0 =A0 =A0.is_partially_uptodate =A0=3D block_is_partially_uptod=
ate,
> =A0 =A0 =A0 =A0.error_remove_page =A0 =A0 =A0=3D generic_error_remove=
_page,
> =A0};
> +static int ext4_no_writepage(struct page *page,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
writeback_control *wbc)
> +{
> + =A0 =A0 =A0 unlock_page(page);
> + =A0 =A0 =A0 return -EIO;
> +}
> +
> +/*
> + * Snapshot file page operations:
> + * always readpage (by page) with buffer tracked read.
> + * user cannot writepage or direct_IO to a snapshot file.
> + *
> + * snapshot file pages are written to disk after a COW operation in =
"ordered"
> + * mode and are never changed after that again, so there is no data =
corruption
> + * risk when using "ordered" mode on snapshot files.
> + * some snapshot data pages are written to disk by sync_dirty_buffer=
(), namely
> + * the snapshot COW bitmaps and a few initial blocks copied on snaps=
hot_take().
> + */
> +static const struct address_space_operations ext4_snapfile_aops =3D =
{
> + =A0 =A0 =A0 .readpage =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_readpage=
,
> + =A0 =A0 =A0 .readpages =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_readpage=
s,
> + =A0 =A0 =A0 .writepage =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_no_write=
page,
> + =A0 =A0 =A0 .bmap =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_bmap=
,
> + =A0 =A0 =A0 .invalidatepage =A0 =A0 =A0 =A0 =3D ext4_invalidatepage=
,
> + =A0 =A0 =A0 .releasepage =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_releasepag=
e,
> +};
>
> =A0void ext4_set_aops(struct inode *inode)
> =A0{
> + =A0 =A0 =A0 if (ext4_snapshot_file(inode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_snapf=
ile_aops;
> + =A0 =A0 =A0 else
> =A0 =A0 =A0 =A0if (ext4_should_order_data(inode) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0test_opt(inode->i_sb, DELALLOC))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_mapping->a_ops =3D &ext4_da_a=
ops;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2c345d1..e3ebd7d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -745,6 +745,8 @@ static void ext4_put_super(struct super_block *sb=
)
> =A0 =A0 =A0 =A0destroy_workqueue(sbi->dio_unwritten_wq);
>
> =A0 =A0 =A0 =A0lock_super(sb);
> + =A0 =A0 =A0 if (EXT4_SNAPSHOTS(sb))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_snapshot_destroy(sb);
> =A0 =A0 =A0 =A0if (sb->s_dirt)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_commit_super(sb, 1);
>
> @@ -3474,6 +3476,9 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
>
> =A0 =A0 =A0 =A0sb->s_root =3D NULL;
>
> + =A0 =A0 =A0 mutex_init(&sbi->s_snapshot_mutex);
> + =A0 =A0 =A0 sbi->s_active_snapshot =3D NULL;
> +
> =A0 =A0 =A0 =A0needs_recovery =3D (es->s_last_orphan !=3D 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_HAS_INCOMPAT_=
=46EATURE(sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
EXT4_FEATURE_INCOMPAT_RECOVER));
> @@ -3676,6 +3681,10 @@ no_journal:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
> =A0 =A0 =A0 =A0};
>
> + =A0 =A0 =A0 if (EXT4_SNAPSHOTS(sb) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_snapshot_load(sb, =
es, sb->s_flags & MS_RDONLY))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* XXX: how can we fail and force read-=
only at this point? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(sb, "load snapshot failed\n"=
);
> =A0 =A0 =A0 =A0EXT4_SB(sb)->s_mount_state |=3D EXT4_ORPHAN_FS;
> =A0 =A0 =A0 =A0ext4_orphan_cleanup(sb, es);
> =A0 =A0 =A0 =A0EXT4_SB(sb)->s_mount_state &=3D ~EXT4_ORPHAN_FS;
> --
> 1.7.0.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
