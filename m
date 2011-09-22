From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 22 Sep 2011 05:12:32 +0300
Message-ID: <CAOQ4uxjee5XfA9uANys1mO94QbyBAC5zJM+=CmAbuE5ycgS=Gg@mail.gmail.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
	<1316127052-1890-2-git-send-email-tytso@mit.edu>
	<20110920185604.GK12086@tux1.beaverton.ibm.com>
	<CAOQ4uxiM9uet14rgNN9-ohTW6W1OrQgU4-OoteHYA3iHxtuLAw@mail.gmail.com>
	<20110921204042.GL12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40504 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1IVCMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Sep 2011 22:12:34 -0400
Received: by wyg34 with SMTP id 34so2517596wyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2011 19:12:32 -0700 (PDT)
In-Reply-To: <20110921204042.GL12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 21, 2011 at 11:40 PM, Darrick J. Wong <djwong@us.ibm.com> w=
rote:
> On Wed, Sep 21, 2011 at 11:03:57AM +0300, Amir Goldstein wrote:
>> On Tue, Sep 20, 2011 at 9:56 PM, Darrick J. Wong <djwong@us.ibm.com>=
 wrote:
>> > On Thu, Sep 15, 2011 at 06:50:51PM -0400, Theodore Ts'o wrote:
> <snip>
>> >> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> >> index 4fec5db..1c86cb2 100644
>> >> --- a/lib/ext2fs/ext2_fs.h
>> >> +++ b/lib/ext2fs/ext2_fs.h
>> >> @@ -142,7 +142,9 @@ struct ext2_group_desc
>> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes co=
unt */
>> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories =
count */
>> >> =A0 =A0 =A0 __u16 =A0 bg_flags;
>> >> - =A0 =A0 __u32 =A0 bg_reserved[2];
>> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap f=
or snapshots */
>> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
>> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
>> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused ino=
des count */
>> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc1=
6(s_uuid+grouo_num+group_desc)*/
>> >> =A0};
>> >> @@ -159,7 +161,9 @@ struct ext4_group_desc
>> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes co=
unt */
>> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories =
count */
>> >> =A0 =A0 =A0 __u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* EX=
T4_BG_flags (INODE_UNINIT, etc) */
>> >> - =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely blo=
ck/inode bitmap checksum */
>> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap f=
or snapshots */
>> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
>> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
>> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused ino=
des count */
>> >> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc1=
6(sb_uuid+group+desc) */
>> >> =A0 =A0 =A0 __u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bitma=
p block MSB */
>> >> @@ -169,7 +173,10 @@ struct ext4_group_desc
>> >> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count_hi;/* Free inodes coun=
t MSB */
>> >> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count_hi; =A0/* Directories co=
unt MSB */
>> >> =A0 =A0 =A0 __u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused inode=
s count MSB */
>> >> - =A0 =A0 __u32 =A0 bg_reserved2[3];
>> >> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap b=
lock MSB */
>> >> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_=
num+bitmap) MSB */
>> >> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_=
num+bitmap) MSB */
>> >> + =A0 =A0 __u32 =A0 bg_reserved;
>> >
>> > Should we attach a checksum to the exclude bitmap? =A0That would, =
unfortunately,
>> > put the 64-byte block group pretty close to full, unless we're ok =
with making
>> > the bg even bigger...
>>
>> Good point.
>> My initial approach (which I probably expressed somewhere) was that =
when
>> exclude_bitmap feature is set, the block bitmap checksum should cove=
r both
>> block bitmap and exclude bitmap.
>> The reason being that exclude bitmap adds little entropy over block =
bitmap:
>> - it should always be a sub set of block bitmap bits
>> - clearing exclude bit is done together with clearing the block used=
 bit
>> - the only case of modifying exclude bitmap only is when a used bloc=
k becomes
>> =A0 excluded (a.k.a moved to snapshot)
>>
>> so how do you feel about compressing 2 blocks into 16bits of checksu=
m :-/?
>
> Hrm.... is it generally the case that both block and exclude bitmaps =
are loaded
> at the same time? =A0I don't think it'd be difficult to checksum both=
 blocks
> unless it's common that one of the two are not in memory.
>

Hrm indeed. no. exclude bitmap is currently not loaded always together =
with
block bitmap, so unless this is changed, we'll have to think of somethi=
ng else.
However that brings me to wonder:
block/inode/exclude bitmap seldom change more than a handful of bits/wo=
rds
at a time.
Does it make sense to diff update the CRC of the bitmaps instead of
recomputing it?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
