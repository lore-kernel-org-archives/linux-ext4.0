From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
	feature flags
Date: Thu, 22 Sep 2011 12:18:40 -0700
Message-ID: <20110922191840.GM12086@tux1.beaverton.ibm.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <20110920185604.GK12086@tux1.beaverton.ibm.com> <CAOQ4uxiM9uet14rgNN9-ohTW6W1OrQgU4-OoteHYA3iHxtuLAw@mail.gmail.com> <20110921204042.GL12086@tux1.beaverton.ibm.com> <CAOQ4uxjee5XfA9uANys1mO94QbyBAC5zJM+=CmAbuE5ycgS=Gg@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43084 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab1IVTSq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Sep 2011 15:18:46 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8MIsYOQ007270
	for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2011 14:54:34 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8MJIjdY164250
	for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2011 15:18:45 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8MJIiHl030075
	for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2011 15:18:44 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjee5XfA9uANys1mO94QbyBAC5zJM+=CmAbuE5ycgS=Gg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 22, 2011 at 05:12:32AM +0300, Amir Goldstein wrote:
> On Wed, Sep 21, 2011 at 11:40 PM, Darrick J. Wong <djwong@us.ibm.com>=
 wrote:
> > On Wed, Sep 21, 2011 at 11:03:57AM +0300, Amir Goldstein wrote:
> >> On Tue, Sep 20, 2011 at 9:56 PM, Darrick J. Wong <djwong@us.ibm.co=
m> wrote:
> >> > On Thu, Sep 15, 2011 at 06:50:51PM -0400, Theodore Ts'o wrote:
> > <snip>
> >> >> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> >> >> index 4fec5db..1c86cb2 100644
> >> >> --- a/lib/ext2fs/ext2_fs.h
> >> >> +++ b/lib/ext2fs/ext2_fs.h
> >> >> @@ -142,7 +142,9 @@ struct ext2_group_desc
> >> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes =
count */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directorie=
s count */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_flags;
> >> >> - =A0 =A0 __u32 =A0 bg_reserved[2];
> >> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap=
 for snapshots */
> >> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+gr=
p_num+bitmap) LSB */
> >> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+gr=
p_num+bitmap) LSB */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused i=
nodes count */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* cr=
c16(s_uuid+grouo_num+group_desc)*/
> >> >> =A0};
> >> >> @@ -159,7 +161,9 @@ struct ext4_group_desc
> >> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes =
count */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directorie=
s count */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* =
EXT4_BG_flags (INODE_UNINIT, etc) */
> >> >> - =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely b=
lock/inode bitmap checksum */
> >> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap=
 for snapshots */
> >> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+gr=
p_num+bitmap) LSB */
> >> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+gr=
p_num+bitmap) LSB */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused i=
nodes count */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* cr=
c16(sb_uuid+group+desc) */
> >> >> =A0 =A0 =A0 __u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bit=
map block MSB */
> >> >> @@ -169,7 +173,10 @@ struct ext4_group_desc
> >> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count_hi;/* Free inodes co=
unt MSB */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count_hi; =A0/* Directories =
count MSB */
> >> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused ino=
des count MSB */
> >> >> - =A0 =A0 __u32 =A0 bg_reserved2[3];
> >> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap=
 block MSB */
> >> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* crc32c(s_uuid+gr=
p_num+bitmap) MSB */
> >> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+gr=
p_num+bitmap) MSB */
> >> >> + =A0 =A0 __u32 =A0 bg_reserved;
> >> >
> >> > Should we attach a checksum to the exclude bitmap? =A0That would=
, unfortunately,
> >> > put the 64-byte block group pretty close to full, unless we're o=
k with making
> >> > the bg even bigger...
> >>
> >> Good point.
> >> My initial approach (which I probably expressed somewhere) was tha=
t when
> >> exclude_bitmap feature is set, the block bitmap checksum should co=
ver both
> >> block bitmap and exclude bitmap.
> >> The reason being that exclude bitmap adds little entropy over bloc=
k bitmap:
> >> - it should always be a sub set of block bitmap bits
> >> - clearing exclude bit is done together with clearing the block us=
ed bit
> >> - the only case of modifying exclude bitmap only is when a used bl=
ock becomes
> >> =A0 excluded (a.k.a moved to snapshot)
> >>
> >> so how do you feel about compressing 2 blocks into 16bits of check=
sum :-/?
> >
> > Hrm.... is it generally the case that both block and exclude bitmap=
s are loaded
> > at the same time? =A0I don't think it'd be difficult to checksum bo=
th blocks
> > unless it's common that one of the two are not in memory.
> >
>=20
> Hrm indeed. no. exclude bitmap is currently not loaded always togethe=
r with
> block bitmap, so unless this is changed, we'll have to think of somet=
hing else.

Or... does it make sense to preload the exclude bitmap at the same time=
 as the
block bitmap?  If I'm reading you correctly, (block_bitmap | exclude_bi=
tmap)
yields a bitmap of all blocks that are not available, correct?  So in t=
he case
that exclude bitmaps are enabled, you'd need both to be in memory anywa=
y.

> However that brings me to wonder:
> block/inode/exclude bitmap seldom change more than a handful of bits/=
words
> at a time.
> Does it make sense to diff update the CRC of the bitmaps instead of
> recomputing it?

Yes, that would be a good (later) optimization at least to consider.

--D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
