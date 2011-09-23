From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Fri, 23 Sep 2011 08:57:43 +0300
Message-ID: <CAOQ4uxiQck9=eWGLYrrYOO2p9xkAbrfZ6XrfHo8T3c=gpqVKow@mail.gmail.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
	<1316127052-1890-2-git-send-email-tytso@mit.edu>
	<20110920185604.GK12086@tux1.beaverton.ibm.com>
	<CAOQ4uxiM9uet14rgNN9-ohTW6W1OrQgU4-OoteHYA3iHxtuLAw@mail.gmail.com>
	<20110921204042.GL12086@tux1.beaverton.ibm.com>
	<CAOQ4uxjee5XfA9uANys1mO94QbyBAC5zJM+=CmAbuE5ycgS=Gg@mail.gmail.com>
	<20110922191840.GM12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54422 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1IWF5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 01:57:45 -0400
Received: by wyg34 with SMTP id 34so3632795wyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2011 22:57:43 -0700 (PDT)
In-Reply-To: <20110922191840.GM12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 22, 2011 at 10:18 PM, Darrick J. Wong <djwong@us.ibm.com> w=
rote:
> On Thu, Sep 22, 2011 at 05:12:32AM +0300, Amir Goldstein wrote:
>> On Wed, Sep 21, 2011 at 11:40 PM, Darrick J. Wong <djwong@us.ibm.com=
> wrote:
>> > On Wed, Sep 21, 2011 at 11:03:57AM +0300, Amir Goldstein wrote:
>> >> On Tue, Sep 20, 2011 at 9:56 PM, Darrick J. Wong <djwong@us.ibm.c=
om> wrote:
>> >> > On Thu, Sep 15, 2011 at 06:50:51PM -0400, Theodore Ts'o wrote:
>> > <snip>
>> >> >> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> >> >> index 4fec5db..1c86cb2 100644
>> >> >> --- a/lib/ext2fs/ext2_fs.h
>> >> >> +++ b/lib/ext2fs/ext2_fs.h
>> >> >> @@ -142,7 +142,9 @@ struct ext2_group_desc
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes=
 count */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directori=
es count */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_flags;
>> >> >> - =A0 =A0 __u32 =A0 bg_reserved[2];
>> >> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitma=
p for snapshots */
>> >> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+g=
rp_num+bitmap) LSB */
>> >> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+g=
rp_num+bitmap) LSB */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused =
inodes count */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* c=
rc16(s_uuid+grouo_num+group_desc)*/
>> >> >> =A0};
>> >> >> @@ -159,7 +161,9 @@ struct ext4_group_desc
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes=
 count */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directori=
es count */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*=
 EXT4_BG_flags (INODE_UNINIT, etc) */
>> >> >> - =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely =
block/inode bitmap checksum */
>> >> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitma=
p for snapshots */
>> >> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+g=
rp_num+bitmap) LSB */
>> >> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+g=
rp_num+bitmap) LSB */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused =
inodes count */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* c=
rc16(sb_uuid+group+desc) */
>> >> >> =A0 =A0 =A0 __u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bi=
tmap block MSB */
>> >> >> @@ -169,7 +173,10 @@ struct ext4_group_desc
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count_hi;/* Free inodes c=
ount MSB */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count_hi; =A0/* Directories=
 count MSB */
>> >> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused in=
odes count MSB */
>> >> >> - =A0 =A0 __u32 =A0 bg_reserved2[3];
>> >> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitma=
p block MSB */
>> >> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* crc32c(s_uuid+g=
rp_num+bitmap) MSB */
>> >> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+g=
rp_num+bitmap) MSB */
>> >> >> + =A0 =A0 __u32 =A0 bg_reserved;
>> >> >
>> >> > Should we attach a checksum to the exclude bitmap? =A0That woul=
d, unfortunately,
>> >> > put the 64-byte block group pretty close to full, unless we're =
ok with making
>> >> > the bg even bigger...
>> >>
>> >> Good point.
>> >> My initial approach (which I probably expressed somewhere) was th=
at when
>> >> exclude_bitmap feature is set, the block bitmap checksum should c=
over both
>> >> block bitmap and exclude bitmap.
>> >> The reason being that exclude bitmap adds little entropy over blo=
ck bitmap:
>> >> - it should always be a sub set of block bitmap bits
>> >> - clearing exclude bit is done together with clearing the block u=
sed bit
>> >> - the only case of modifying exclude bitmap only is when a used b=
lock becomes
>> >> =A0 excluded (a.k.a moved to snapshot)
>> >>
>> >> so how do you feel about compressing 2 blocks into 16bits of chec=
ksum :-/?
>> >
>> > Hrm.... is it generally the case that both block and exclude bitma=
ps are loaded
>> > at the same time? =A0I don't think it'd be difficult to checksum b=
oth blocks
>> > unless it's common that one of the two are not in memory.
>> >
>>
>> Hrm indeed. no. exclude bitmap is currently not loaded always togeth=
er with
>> block bitmap, so unless this is changed, we'll have to think of some=
thing else.
>
> Or... does it make sense to preload the exclude bitmap at the same ti=
me as the
> block bitmap?

it wouldn't be terrible to do that, since exclude bitmap will normally
be located
right next to block bitmap, but if memory pressure is high, that would
lead to half
the number of block bitmaps in memory at any given time.

>=A0If I'm reading you correctly, (block_bitmap | exclude_bitmap)
> yields a bitmap of all blocks that are not available, correct?

not exactly. if all is sane, then
(block_bitmap | exclude_bitmap) =3D=3D block_bitmap
(block_bitmap & exclude_bitmap) =3D=3D exclude_bitmap

> So in the case
> that exclude bitmaps are enabled, you'd need both to be in memory any=
way.
>

exclude_bitmap is loaded into memory in the following cases:
1. allocating snapshot inode blocks (during COW)
2. deleting snapshot inode blocks (snapshot delete)
3. moving "deleted" blocks to snapshot (MOW)

specifically, exclude_bitmap is NOT loaded into memory in the following=
 cases:
1. allocating regular inode blocks
2. deleting regular inode blocks, which were allocated after last snaps=
hot

=46or example, in kernel compilation benchmark, all temp files
are created and deleted without modifying exclude bitmap (or snapshots)=
=2E

>> However that brings me to wonder:
>> block/inode/exclude bitmap seldom change more than a handful of bits=
/words
>> at a time.
>> Does it make sense to diff update the CRC of the bitmaps instead of
>> recomputing it?
>
> Yes, that would be a good (later) optimization at least to consider.
>
> --D
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
