From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v4 2/3] ext4: use ext4_get_block_write in buffer write
Date: Sun, 17 Jan 2010 21:25:53 -0800
Message-ID: <5df78e1d1001172125j35bb2925o235c5380ee551d03@mail.gmail.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	 <1263583812-21355-3-git-send-email-tytso@mit.edu>
	 <87zl4c24o5.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:51987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0ARFZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 00:25:57 -0500
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id o0I5PutC016677
	for <linux-ext4@vger.kernel.org>; Sun, 17 Jan 2010 21:25:56 -0800
Received: from pwj12 (pwj12.prod.google.com [10.241.219.76])
	by spaceape23.eur.corp.google.com with ESMTP id o0I5PsP8001940
	for <linux-ext4@vger.kernel.org>; Sun, 17 Jan 2010 21:25:54 -0800
Received: by pwj12 with SMTP id 12so1552400pwj.28
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jan 2010 21:25:53 -0800 (PST)
In-Reply-To: <87zl4c24o5.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I agree that unwritten flag would be a better choice. I was thinking
to use it at the beginning but found it would be tricky to get it work.
See e.g. the unwritten flag usage in the current ext4_get_block.
I guess at some time later, we should clean up the buffer head
flag usage.

Jiaying

On Sun, Jan 17, 2010 at 6:21 AM, Aneesh Kumar K. V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
> On Fri, 15 Jan 2010 14:30:11 -0500, "Theodore Ts'o" <tytso@mit.edu> w=
rote:
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
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> > =A0fs/ext4/ext4.h =A0 =A0 =A0| =A0 12 +++++-
> > =A0fs/ext4/ext4_jbd2.h | =A0 24 ++++++++++++
> > =A0fs/ext4/extents.c =A0 | =A0 22 ++++++-----
> > =A0fs/ext4/inode.c =A0 =A0 | =A0105 +++++++++++++++++++++++++++++++=
+++++++++----------
> > =A0fs/ext4/super.c =A0 =A0 | =A0 30 +++++++++++++--
> > =A05 files changed, 157 insertions(+), 36 deletions(-)
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index b1dcbb7..b8b4887 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -134,6 +134,7 @@ struct mpage_da_data {
> > =A0 =A0 =A0 int retval;
> > =A0};
> > =A0#define =A0 =A0 =A0EXT4_IO_UNWRITTEN =A0 =A0 =A0 0x1
> > +#define =A0 =A0 =A0EXT4_IO_WRITTEN =A0 =A0 =A0 =A0 0x2
> > =A0typedef struct ext4_io_end {
> > =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0list; =A0 =A0 =A0 =A0 =A0=
 /* per-file finished AIO list */
> > =A0 =A0 =A0 struct inode =A0 =A0 =A0 =A0 =A0 =A0*inode; =A0 =A0 =A0=
 =A0 /* file being written to */
> > @@ -370,7 +371,7 @@ struct ext4_new_group_data {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
> > =A0 =A0 =A0 /* Convert extent to initialized after IO complete */
> > =A0#define EXT4_GET_BLOCKS_IO_CONVERT_EXT =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (EXT4_GET_BLOCKS_CONVERT|\
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_GET_BLOCKS_IO_CREATE_EXT)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
> >
> > =A0/*
> > =A0 * Flags used by ext4_free_blocks
> > @@ -761,6 +762,7 @@ struct ext4_inode_info {
> > =A0#define EXT4_MOUNT_QUOTA =A0 =A0 =A0 =A0 =A0 =A0 0x80000 /* Some=
 quota option set */
> > =A0#define EXT4_MOUNT_USRQUOTA =A0 =A0 =A0 =A0 =A00x100000 /* "old"=
 user quota */
> > =A0#define EXT4_MOUNT_GRPQUOTA =A0 =A0 =A0 =A0 =A00x200000 /* "old"=
 group quota */
> > +#define EXT4_MOUNT_DIOREAD_NOLOCK =A0 =A00x400000 /* Enable suppor=
t for dio read nolocking */
> > =A0#define EXT4_MOUNT_JOURNAL_CHECKSUM =A00x800000 /* Journal check=
sums */
> > =A0#define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT =A0 =A0 =A00x1000000 /* =
Journal Async Commit */
> > =A0#define EXT4_MOUNT_I_VERSION =A0 =A0 =A0 =A0 =A0 =A00x2000000 /*=
 i_version support */
> > @@ -1774,6 +1776,14 @@ static inline void set_bitmap_uptodate(struc=
t buffer_head *bh)
> > =A0 =A0 =A0 set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
> > =A0}
> >
> > +/* BH_Uninit flag: blocks are allocated but uninitialized on disk =
*/
> > +enum ext4_state_bits {
> > + =A0 =A0 BH_Uninit =A0 =A0 =A0 /* blocks are allocated but uniniti=
alized on disk */
> > + =A0 =A0 =A0 =3D BH_JBDPrivateStart,
> > +};
> > +
> > +BUFFER_FNS(Uninit, uninit)
> > +
>
>
> I asked this in the last post. Why we need a new buffer head flag ?
> Why can't we use the unwritten flag ?
>
> -aneesh
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
