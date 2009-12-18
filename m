From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/4] ext4: use ext4_get_block_write in buffer write
Date: Fri, 18 Dec 2009 11:46:38 -0800
Message-ID: <5df78e1d0912181146h56f76710u721d86edac1f9bd2@mail.gmail.com>
References: <5df78e1d0912151739j1f9f8a36j830ee175291d21a@mail.gmail.com>
	 <20091218095444.GA9437@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:36266 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZLRTqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 14:46:47 -0500
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id nBIJkfHp013837
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 19:46:42 GMT
Received: from pzk3 (pzk3.prod.google.com [10.243.19.131])
	by wpaz24.hot.corp.google.com with ESMTP id nBIJkcLh031488
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 11:46:39 -0800
Received: by pzk3 with SMTP id 3so2253856pzk.20
        for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 11:46:38 -0800 (PST)
In-Reply-To: <20091218095444.GA9437@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 18, 2009 at 1:54 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
> On Tue, Dec 15, 2009 at 05:39:08PM -0800, Jiaying Zhang wrote:
> > ext4: use ext4_get_block_write in buffer write
> >
> > Allocate uninitialized extent before ext4 buffer write and
> > convert the extent to initialized after io completes.
> > The purpose is to make sure an extent can only be marked
> > initialized after it has been written with new data so
> > we can safely drop the i_mutex lock in ext4 DIO read without
> > exposing stale data. This helps to improve multi-thread DIO
> > read performance on high-speed disks.
> >
> > Skip the nobh and data=3Djournal mount cases to make things simple =
for now.
> >
> > Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> > ---
> > =A0fs/ext4/ext4.h =A0 =A0| =A0 =A05 +++
> > =A0fs/ext4/extents.c | =A0 10 +++---
> > =A0fs/ext4/fsync.c =A0 | =A0 =A03 ++
> > =A0fs/ext4/inode.c =A0 | =A0 81 +++++++++++++++++++++++++++++++++++=
+++++++++++--------
> > =A0fs/ext4/super.c =A0 | =A0 30 +++++++++++++++++---
> > =A05 files changed, 108 insertions(+), 21 deletions(-)
> >
> > Index: git-ext4/fs/ext4/extents.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- git-ext4.orig/fs/ext4/extents.c =A0 =A0 2009-12-15 16:03:05.000=
000000 -0800
> > +++ git-ext4/fs/ext4/extents.c =A02009-12-15 16:03:15.000000000 -08=
00
> > @@ -3052,6 +3052,7 @@ ext4_ext_handle_uninitialized_extents(ha
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io->flag =3D EXT4_IO=
_UNWRITTEN;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->i_sta=
te |=3D EXT4_STATE_DIO_UNWRITTEN;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_uninit(bh_result);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0/* IO end_io complete, convert the filled extent to =
written */
> > @@ -3291,11 +3292,9 @@ int ext4_ext_get_blocks(handle_t *handle
> > =A0 =A0 =A0 =A0if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_mark_uninitialized(&newex);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* io_end structure was created for=
 every async
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* direct IO write to the middle of=
 the file.
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* To avoid unecessary convertion f=
or every aio dio rewrite
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to the mid of file, here we flag=
 the IO that is really
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* need the convertion.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* io_end structure was created for=
 every IO write to an
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* uninitialized extent. To avoid u=
necessary convertion,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* here we flag the IO that really =
needs the convertion.
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * For non asycn direct IO case, fla=
g the inode state
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * that we need to perform convertio=
n when IO is done.
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> > @@ -3306,6 +3305,7 @@ int ext4_ext_get_blocks(handle_t *handle
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4=
_I(inode)->i_state |=3D
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_STATE_DIO_UNWRITTEN;;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_uninit(bh_result);
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0err =3D ext4_ext_insert_extent(handle, inode, path, =
&newex, flags);
> > =A0 =A0 =A0 =A0if (err) {
> > Index: git-ext4/fs/ext4/ext4.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- git-ext4.orig/fs/ext4/ext4.h =A0 =A0 =A0 =A02009-12-15 16:03:05=
=2E000000000 -0800
> > +++ git-ext4/fs/ext4/ext4.h =A0 =A0 2009-12-15 16:03:15.000000000 -=
0800
> > @@ -134,6 +134,7 @@ struct mpage_da_data {
> > =A0 =A0 =A0 =A0int retval;
> > =A0};
> > =A0#define =A0 =A0 =A0 =A0EXT4_IO_UNWRITTEN =A0 =A0 =A0 0x1
> > +#define =A0 =A0 =A0 =A0EXT4_IO_WRITTEN =A0 =A0 =A0 =A0 0x2
> > =A0typedef struct ext4_io_end {
> > =A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0list; =A0 =A0 =A0 =A0=
 =A0 /* per-file finished AIO list */
> > =A0 =A0 =A0 =A0struct inode =A0 =A0 =A0 =A0 =A0 =A0*inode; =A0 =A0 =
=A0 =A0 /* file being written to */
> > @@ -752,6 +753,7 @@ struct ext4_inode_info {
> > =A0#define EXT4_MOUNT_QUOTA =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x80000 /* =
Some quota option set */
> > =A0#define EXT4_MOUNT_USRQUOTA =A0 =A0 =A0 =A0 =A0 =A00x100000 /* "=
old" user quota */
> > =A0#define EXT4_MOUNT_GRPQUOTA =A0 =A0 =A0 =A0 =A0 =A00x200000 /* "=
old" group quota */
> > +#define EXT4_MOUNT_DIOREAD_NOLOCK =A0 =A0 =A00x400000 /* Enable su=
pport for
> > dio read nolocking */
> > =A0#define EXT4_MOUNT_JOURNAL_CHECKSUM =A0 =A00x800000 /* Journal c=
hecksums */
> > =A0#define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT =A0 =A0 =A0 =A00x1000000=
 /* Journal
> > Async Commit */
> > =A0#define EXT4_MOUNT_I_VERSION =A0 =A0 =A0 =A0 =A0 =A00x2000000 /*=
 i_version support */
> > @@ -1764,6 +1766,9 @@ static inline void set_bitmap_uptodate(s
> > =A0 =A0 =A0 =A0set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
> > =A0}
> >
> > +/* BH_Uninit flag: blocks are allocated but uninitialized on disk =
*/
> > +#define BH_Uninit (BH_JBDPrivateStart + 1)
> > +BUFFER_FNS(Uninit, uninit)
>
>
> Why do we need to add a new buffer_head flag. Why is unwritten flag n=
ot sufficient
> for this ?
>
>
> > =A0#endif /* __KERNEL__ */
> >
> > =A0#endif /* _EXT4_H */
> > Index: git-ext4/fs/ext4/super.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- git-ext4.orig/fs/ext4/super.c =A0 =A0 =A0 2009-12-15 16:03:05.0=
00000000 -0800
> > +++ git-ext4/fs/ext4/super.c =A0 =A02009-12-15 16:03:15.000000000 -=
0800
> > @@ -921,6 +921,9 @@ static int ext4_show_options(struct seq_
> > =A0 =A0 =A0 =A0if (test_opt(sb, NOLOAD))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_puts(seq, ",norecovery");
> >
> > + =A0 =A0 =A0 if (test_opt(sb, DIOREAD_NOLOCK))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(seq, ",dioread_nolock");
> > +
> > =A0 =A0 =A0 =A0ext4_show_quota_options(seq, sb);
> >
> > =A0 =A0 =A0 =A0return 0;
> > @@ -1103,6 +1106,7 @@ enum {
> > =A0 =A0 =A0 =A0Opt_stripe, Opt_delalloc, Opt_nodelalloc,
> > =A0 =A0 =A0 =A0Opt_block_validity, Opt_noblock_validity,
> > =A0 =A0 =A0 =A0Opt_inode_readahead_blks, Opt_journal_ioprio,
> > + =A0 =A0 =A0 Opt_dioread_nolock, Opt_dioread_lock,
> > =A0 =A0 =A0 =A0Opt_discard, Opt_nodiscard, Opt_akpm_lock_hack
> > =A0};
> >
> > @@ -1171,6 +1175,8 @@ static const match_table_t tokens =3D {
> > =A0 =A0 =A0 =A0{Opt_auto_da_alloc, "auto_da_alloc=3D%u"},
> > =A0 =A0 =A0 =A0{Opt_auto_da_alloc, "auto_da_alloc"},
> > =A0 =A0 =A0 =A0{Opt_noauto_da_alloc, "noauto_da_alloc"},
> > + =A0 =A0 =A0 {Opt_dioread_nolock, "dioread_nolock"},
> > + =A0 =A0 =A0 {Opt_dioread_lock, "dioread_lock"},
>
>
>
> I guess this mount option will go away when we are ready to merge thi=
s
> upstream ? If we want to merge i guess we should make this the defaul=
t
> behaviour.

I am not sure yet. It currently only works with bh and data!=3Djournal =
modes.
I am also not sure whether we want to enable this feature on HDs.
AFAICT, we will see performance improvements only on fast SSDs.
Another concern is that with the patch, we need to allocated uninit ext=
ent
first and then do uninit-to-init conversion after the IO is done. So it=
 may
lead to more metadata access, although I didn't see any noticeable
performance difference in my performance testing.

>
> Why version of the kernel are the patches against. I would like to ta=
ke
> a look at the changes after applying the patches.

I am using a kernel synced with Ted's ext4 git tree two weeks ago.
The kernel version is 2.6.32-rc7.

Jiaying

>
> -aneesh
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
