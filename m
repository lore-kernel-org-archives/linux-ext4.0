From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sun, 9 May 2010 13:56:54 +0200
Message-ID: <AANLkTikdhvWOsO1JG3r2p27hHCEoJ-PRFVG8-f0iJdYp@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <87vdaz21b0.fsf@basil.nowhere.org>
	 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
	 <4BE4855E.40808@redhat.com>
	 <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
	 <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
	 <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com>
	 <20100508172557.GK18762@thunk.org>
	 <AANLkTiniWITctyA7t3IEWM-K-Rla9YJ9AeSqE3klOg41@mail.gmail.com>
	 <07F5C185-5595-44B6-8B48-A6A9FEA2EC65@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51173 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0EIL44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 May 2010 07:56:56 -0400
Received: by bwz19 with SMTP id 19so1279469bwz.21
        for <linux-ext4@vger.kernel.org>; Sun, 09 May 2010 04:56:54 -0700 (PDT)
In-Reply-To: <07F5C185-5595-44B6-8B48-A6A9FEA2EC65@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 9, 2010 at 5:25 AM, Theodore Tso  wrote:
>
> For example, if you have flags that only are used in-memory, they sho=
uldn't be allocated out of i_flags, but instead using the i_state field=
 in the ext4_inode_info structure, referenced via EXT4_I(inode).i_state=
=2E =A0 That's what it is there fore.
>

I have 4 non-persistent flags. I will move them to i_state.
I've kept them in i_flags out of laziness, since I use lsattr -X
to read non-persistent snapshot flags along with persistent snapshot fl=
ags.

>>
>> Next3 uses 1 assigned field (i_version), but it does not "abuse" it.
>> You see, Next3 only tampers with i_version of snapshot files.
>> And by tamper I mean: set it to next snapshot inode number on snapsh=
ot take.
>
> What do you mean by "next snapshot number"? =A0 How is it used? =A0Wh=
y do you need it? =A0 Given that all snapshot inodes must be stored out=
 of a snapshot directory (why?) can't the snapshot directory name be us=
ed to establish some kind of ordering? =A0 Is ordering significant, or =
do you just need it to find them all? =A0 If it's just to find them all=
, why not just used a linked list which is stored in memory; does it re=
ally need to be in the on-disk structure at all?
>

i_version is used to chain the snapshot list on-disk, similar to orphan=
 list.
I used i_dtime in the past, but I was concerned that a bug would
result in cleanup of all snapshots,
so I started using i_version instead.
I can revert back to using i_dtime (snapshot files are non-truncatable
non-unlinkable) instead of i_version.

the snapshot file directory entry name is arbitrary and may be used by
a "snapshot management system" as it wishes,
to organize and display snapshots.
As far as the snapshot sub-system is concerned, the on-disk snapshot
list is the only reference to the snapshot files.

>
> For example: i_snapshot_blocks_count. =A0Is that really necessary? =A0=
 Why can not be computed by looking at i_size of the snapshot inode? =A0=
 Or by checking to see if the superblock has be COW'ed? =A0If it hasn't=
 then the s_blocks_count in the fs superblock must be what would have b=
een in i_snapshot_blocks_count. =A0If the sb has been COW'ed, s_blocks_=
count in the COW'ed sb must be that value. =A0Why allocate and waste a =
full 32-bit field out of _every_ inode in the file system if it's possi=
ble to get that value via other places.
>

very well, I can read snapshot_blocks_count from COWed superblock (it
is always COWed on snapshot take) and release i_snapshot_blocks_count.

> I have similar question about bg_cow_bitmap. =A0Is that really necess=
ary? =A0 The COW bitmap is just a copy of the base file system's block =
allocation bitmap, right? =A0(The wiki documentation and the design PDF=
 isn't completely clear on that point, but that seems to be what it is.=
) =A0 So why do you need to allocate a field out of the bg discriptor f=
ield for it?
>
> It's not clear why you need an exclude inode, if you are also storing=
 the address of the exclude bitmap blocks in the bg descriptor. =A0One =
or the other, but not both...
>

bg_cow_bitmap/bg_exculde_bitmap are used by Next3 as non-persistent
cache for the address of a bitmap blocks,
which can be read from active_snapshot/exclude_inode.
in other words, instead of allocating per group in-memory structure, I
used the 2 unused fields in the in-memory group descriptor.
the only side effect for the ext* on-disk format is that those fields
are no longer 0 after mounting a volume with Next3.
is that a problem? can the CSUM feature resolve that problem?

in e2fsprogs, I only reference those fields for debugging purpose
(dumpe2fs displays them).
also create_exclude_inode and resize2fs set the bg_exclude_bitmap, but
they don't have to,
because Next3 re-reads all exclude_bitmap block addresses from exclude
inode on mount time.
so please feel free to reject those field assignments. I can include
them in a seperate debug only patch.


> If s_snapshot_inum and s_snapshot_id refer to the "active" snapshot, =
why do they need to be in the on-disk structure. =A0 Why not just have =
the first item of the linked list whose head is s_last_snapshot be the =
"active" snapshot (if this needs to be in the on-disk state at all); wo=
uldn't the active snapshot be the most recent one anyway?

good question. again, there use to be only 1 field s_last_snapshot,
but I split it into 2 field to recover from crash in the middle
of snapshot take.
a half taken snapshot is set as s_last_snapshot, but only a ready
snapshot is set as s_snapshot_inum.
Next3 will cleanup a half taken snapshot on mount time.
tune2fs -O ^has_snapshot will cleanup (discard) all snapshot files,
including the half taken snapshot.

> Also, as far as i_next_snapshot is concerned, why not just use d_time=
 for the linked list. =A0That's what we do with the orphaned inode list=
, so we have code that maintains a linked list using d_time already. =A0=
 So that way you don't need _any_ new inode fields.
>

I don't know if you noticed, but I reused the code of
add/del_orphan_list() to manipulate the snapshot list...
And as I said a few lines back, I can revert to using i_dtime instead
of i_next_snapshot.

> I'm not convinced by all of the fs feature compatibility flags you've=
 defined, either. =A0 In general, if you suspect one part of the file s=
ystem, you need to check everything. =A0So do you really need separate =
ro_compat bits for "fix_snapshot" and "fix_exclude"?

no, not really. these are informational only. I didn't even use
fix_snapshot yet.

> And why do you need "IS_SNAPSHOT"?
>

I "fix" the COWed superblock to make it look like ext2 superblock and
set the is_snapshot feature, so fsck would know it is checking a Next3
snapshot image (and not report wrong block counts).

> As far as COMPAT_BIG_JOURNAL, we have feature flags in the journal, a=
nd that probably is better placed there.

I will look into that.

>And I assume COMPAT_EXCLUDE_INODE is really "COMPAT_HAS_SNAPSHOTS"?

logically, it means that the exclude inode/bitmap is allocated.
currently, the only feature that uses the exclude bitmap is the
snapshot feature,
so I don't mind bundling them together.

but I do recommend to mke2fs -o exclude_inode if you intend to switch
from Ext3 to Next3 at some point.
it will guarenty that exclude bitmap blocks are allocated their
corresponding block bitmap.

>
> BTW, if you are free at 11:00 US/Eastern on Monday, maybe you could j=
oin the ext4 weekly conference call, and we could try to hash some of t=
his out on the telephone call? =A0I'm not sure where you are geographic=
ally based, so I don't know if this would be a hard time for you to mak=
e or not.
>

I would be happy to join the weekly call. I am located in Israel. How
does this work exactly?
Should I call in? to which number? need credentials?

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
