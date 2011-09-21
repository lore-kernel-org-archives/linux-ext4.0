From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
	feature flags
Date: Wed, 21 Sep 2011 13:40:42 -0700
Message-ID: <20110921204042.GL12086@tux1.beaverton.ibm.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <20110920185604.GK12086@tux1.beaverton.ibm.com> <CAOQ4uxiM9uet14rgNN9-ohTW6W1OrQgU4-OoteHYA3iHxtuLAw@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:53719 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUUlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Sep 2011 16:41:16 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 21 Sep 2011 14:41:06 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8LKehMl177110
	for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2011 14:40:44 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8LKehXL002918
	for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2011 14:40:43 -0600
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiM9uet14rgNN9-ohTW6W1OrQgU4-OoteHYA3iHxtuLAw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 21, 2011 at 11:03:57AM +0300, Amir Goldstein wrote:
> On Tue, Sep 20, 2011 at 9:56 PM, Darrick J. Wong <djwong@us.ibm.com> =
wrote:
> > On Thu, Sep 15, 2011 at 06:50:51PM -0400, Theodore Ts'o wrote:
<snip>
> >> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> >> index 4fec5db..1c86cb2 100644
> >> --- a/lib/ext2fs/ext2_fs.h
> >> +++ b/lib/ext2fs/ext2_fs.h
> >> @@ -142,7 +142,9 @@ struct ext2_group_desc
> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes cou=
nt */
> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories c=
ount */
> >> =A0 =A0 =A0 __u16 =A0 bg_flags;
> >> - =A0 =A0 __u32 =A0 bg_reserved[2];
> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap fo=
r snapshots */
> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_n=
um+bitmap) LSB */
> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_n=
um+bitmap) LSB */
> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inod=
es count */
> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16=
(s_uuid+grouo_num+group_desc)*/
> >> =A0};
> >> @@ -159,7 +161,9 @@ struct ext4_group_desc
> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes cou=
nt */
> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories c=
ount */
> >> =A0 =A0 =A0 __u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* EXT=
4_BG_flags (INODE_UNINIT, etc) */
> >> - =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely bloc=
k/inode bitmap checksum */
> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap fo=
r snapshots */
> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_n=
um+bitmap) LSB */
> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_n=
um+bitmap) LSB */
> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inod=
es count */
> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16=
(sb_uuid+group+desc) */
> >> =A0 =A0 =A0 __u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bitmap=
 block MSB */
> >> @@ -169,7 +173,10 @@ struct ext4_group_desc
> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count_hi;/* Free inodes count=
 MSB */
> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count_hi; =A0/* Directories cou=
nt MSB */
> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused inodes=
 count MSB */
> >> - =A0 =A0 __u32 =A0 bg_reserved2[3];
> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap bl=
ock MSB */
> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_n=
um+bitmap) MSB */
> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_n=
um+bitmap) MSB */
> >> + =A0 =A0 __u32 =A0 bg_reserved;
> >
> > Should we attach a checksum to the exclude bitmap? =A0That would, u=
nfortunately,
> > put the 64-byte block group pretty close to full, unless we're ok w=
ith making
> > the bg even bigger...
>=20
> Good point.
> My initial approach (which I probably expressed somewhere) was that w=
hen
> exclude_bitmap feature is set, the block bitmap checksum should cover=
 both
> block bitmap and exclude bitmap.
> The reason being that exclude bitmap adds little entropy over block b=
itmap:
> - it should always be a sub set of block bitmap bits
> - clearing exclude bit is done together with clearing the block used =
bit
> - the only case of modifying exclude bitmap only is when a used block=
 becomes
>   excluded (a.k.a moved to snapshot)
>=20
> so how do you feel about compressing 2 blocks into 16bits of checksum=
 :-/?

Hrm.... is it generally the case that both block and exclude bitmaps ar=
e loaded
at the same time?  I don't think it'd be difficult to checksum both blo=
cks
unless it's common that one of the two are not in memory.

--D

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
