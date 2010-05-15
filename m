From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 15 May 2010 08:14:30 +0200
Message-ID: <AANLkTin5ctEU4VSnibjBd7urrfCznnSTJvJ1b8DpYazJ@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
	 <4BE4855E.40808@redhat.com>
	 <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
	 <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
	 <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com>
	 <20100508172557.GK18762@thunk.org>
	 <AANLkTiniWITctyA7t3IEWM-K-Rla9YJ9AeSqE3klOg41@mail.gmail.com>
	 <07F5C185-5595-44B6-8B48-A6A9FEA2EC65@mit.edu>
	 <AANLkTikdhvWOsO1JG3r2p27hHCEoJ-PRFVG8-f0iJdYp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60175 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0EOGOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 May 2010 02:14:32 -0400
Received: by fxm6 with SMTP id 6so2156191fxm.19
        for <linux-ext4@vger.kernel.org>; Fri, 14 May 2010 23:14:31 -0700 (PDT)
In-Reply-To: <AANLkTikdhvWOsO1JG3r2p27hHCEoJ-PRFVG8-f0iJdYp@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 9, 2010 at 1:56 PM, Amir G. <amir73il@users.sourceforge.net=
> wrote:
> On Sun, May 9, 2010 at 5:25 AM, Theodore Tso =A0wrote:
>>
>> For example, if you have flags that only are used in-memory, they sh=
ouldn't be allocated out of i_flags, but instead using the i_state fiel=
d in the ext4_inode_info structure, referenced via EXT4_I(inode).i_stat=
e. =A0 That's what it is there fore.
>>
>
> I have 4 non-persistent flags. I will move them to i_state.
> I've kept them in i_flags out of laziness, since I use lsattr -X
> to read non-persistent snapshot flags along with persistent snapshot =
flags.
>
>>
>> For example: i_snapshot_blocks_count. =A0Is that really necessary? =A0=
 Why can not be computed by looking at i_size of the snapshot inode? =A0=
 Or by checking to see if the superblock has be COW'ed? =A0If it hasn't=
 then the s_blocks_count in the fs superblock must be what would have b=
een in i_snapshot_blocks_count. =A0If the sb has been COW'ed, s_blocks_=
count in the COW'ed sb must be that value. =A0Why allocate and waste a =
full 32-bit field out of _every_ inode in the file system if it's possi=
ble to get that value via other places.
>>
>
> very well, I can read snapshot_blocks_count from COWed superblock (it
> is always COWed on snapshot take) and release i_snapshot_blocks_count=
=2E
>
>> I have similar question about bg_cow_bitmap. =A0Is that really neces=
sary? =A0 The COW bitmap is just a copy of the base file system's block=
 allocation bitmap, right? =A0(The wiki documentation and the design PD=
=46 isn't completely clear on that point, but that seems to be what it =
is.) =A0 So why do you need to allocate a field out of the bg discripto=
r field for it?
>>
>> It's not clear why you need an exclude inode, if you are also storin=
g the address of the exclude bitmap blocks in the bg descriptor. =A0One=
 or the other, but not both...
>>
>
> bg_cow_bitmap/bg_exculde_bitmap are used by Next3 as non-persistent
> cache for the address of a bitmap blocks,
> which can be read from active_snapshot/exclude_inode.
> in other words, instead of allocating per group in-memory structure, =
I
> used the 2 unused fields in the in-memory group descriptor.
> the only side effect for the ext* on-disk format is that those fields
> are no longer 0 after mounting a volume with Next3.
> is that a problem? can the CSUM feature resolve that problem?
>
> in e2fsprogs, I only reference those fields for debugging purpose
> (dumpe2fs displays them).
> also create_exclude_inode and resize2fs set the bg_exclude_bitmap, bu=
t
> they don't have to,
> because Next3 re-reads all exclude_bitmap block addresses from exclud=
e
> inode on mount time.
> so please feel free to reject those field assignments. I can include
> them in a seperate debug only patch.
>
>
>
>> Also, as far as i_next_snapshot is concerned, why not just use d_tim=
e for the linked list. =A0That's what we do with the orphaned inode lis=
t, so we have code that maintains a linked list using d_time already. =A0=
 So that way you don't need _any_ new inode fields.
>>
>
> I don't know if you noticed, but I reused the code of
> add/del_orphan_list() to manipulate the snapshot list...
> And as I said a few lines back, I can revert to using i_dtime instead
> of i_next_snapshot.
>
>> I'm not convinced by all of the fs feature compatibility flags you'v=
e defined, either. =A0 In general, if you suspect one part of the file =
system, you need to check everything. =A0So do you really need separate=
 ro_compat bits for "fix_snapshot" and "fix_exclude"?
>
> no, not really. these are informational only. I didn't even use
> fix_snapshot yet.
>
>> And why do you need "IS_SNAPSHOT"?
>>
>
> I "fix" the COWed superblock to make it look like ext2 superblock and
> set the is_snapshot feature, so fsck would know it is checking a Next=
3
> snapshot image (and not report wrong block counts).
>
>> As far as COMPAT_BIG_JOURNAL, we have feature flags in the journal, =
and that probably is better placed there.
>
> I will look into that.
>
>>And I assume COMPAT_EXCLUDE_INODE is really "COMPAT_HAS_SNAPSHOTS"?
>
> logically, it means that the exclude inode/bitmap is allocated.
> currently, the only feature that uses the exclude bitmap is the
> snapshot feature,
> so I don't mind bundling them together.
>
> but I do recommend to mke2fs -o exclude_inode if you intend to switch
> from Ext3 to Next3 at some point.
> it will guarenty that exclude bitmap blocks are allocated their
> corresponding block bitmap.
>

I have started making some changes to on-disk format based on the
points we seem to agree upon.

I would like to register only 1 ro_compat feature (has_snapshot) and 1
compat feature (exclude_inode).
the rest of the "informational features" I would like to move to
s_flags, including NEXT3_FLAGS_BIG_JOURNAL.

A Next3 big journal can be created with the option -J big or by
mkfs.next3/mkn3fs.

I will evacuate all the fields that Next3 can do without (i.e.,
{s_snapshot_blocks_count,bg_{cow,exclude}_bitmap}).

I will move the non-persistent snapshot flags to i_state.

I would like to stick with i_version list chaining and not revert to
using i_dtime. awaiting further discussion on that topic.

Awaiting permanent assignments for the rest of the fields/flags.

Per your request, I have added the information above to the Next3 wiki.
Please find the TODO items in red and WIP items in green (implemented
and not published):
http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DCode_docu=
mentation#Reserved_fields_and_bits_in_on-disk_structures

Also, if you could please drop a line about your view of how to
progress with Next3
(something in the lines of what you said in the conference call), that
would be nice.
Some people may have gotten the impression that the fork from Ext3 is
a show stopper for you,
see: http://lwn.net/SubscriberLink/387231/1310b1360769c12b/

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
