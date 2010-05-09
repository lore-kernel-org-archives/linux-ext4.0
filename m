From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 8 May 2010 22:25:07 -0400
Message-ID: <07F5C185-5595-44B6-8B48-A6A9FEA2EC65@mit.edu>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com> <20100504224226.GE6344@thunk.org> <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com> <87vdaz21b0.fsf@basil.nowhere.org> <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com> <4BE4855E.40808@redhat.com> <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com> <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu> <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com> <20100508172557.GK18762@thunk.org> <AANLkTiniWITctyA7t3IEWM-K-Rla9YJ9AeSqE3klOg41@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:52531 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673Ab0EICZN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 May 2010 22:25:13 -0400
In-Reply-To: <AANLkTiniWITctyA7t3IEWM-K-Rla9YJ9AeSqE3klOg41@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On May 8, 2010, at 3:40 PM, Amir G. wrote:
> 
> Let me state my case then:

You need to justify ALL new fields which are used by Next3, not just the ones which overlap ext4, since they are precious resources, not be squandered for just one new file system feature/extension.

For example, if you have flags that only are used in-memory, they shouldn't be allocated out of i_flags, but instead using the i_state field in the ext4_inode_info structure, referenced via EXT4_I(inode).i_state.   That's what it is there fore.   (And i_flags is overloaded already, since the bit positions are used by the VFS layer as well, so that's something where we do need to be sensitive how bit positions get used).

> 
> Next3 uses 1 assigned field (i_version), but it does not "abuse" it.
> You see, Next3 only tampers with i_version of snapshot files.
> And by tamper I mean: set it to next snapshot inode number on snapshot take.

What do you mean by "next snapshot number"?   How is it used?  Why do you need it?   Given that all snapshot inodes must be stored out of a snapshot directory (why?) can't the snapshot directory name be used to establish some kind of ordering?   Is ordering significant, or do you just need it to find them all?   If it's just to find them all, why not just used a linked list which is stored in memory; does it really need to be in the on-disk structure at all?

> Next3 also uses 9 i_flags bits (0x1FF00000), in snapshot file inodes only,
> some currently overlapping flags recently assigned to Ext4 (you beat me to it).
> There is a big waste in i_flag bits space, for example, the 4 bits
> reserved for compression,

The compression people were amazingly profligate with their flags, yes.  It's one of the reasons why I push back now, and ask people to justify *every* single bit assignment or field usage. 

For example: i_snapshot_blocks_count.  Is that really necessary?   Why can not be computed by looking at i_size of the snapshot inode?   Or by checking to see if the superblock has be COW'ed?  If it hasn't then the s_blocks_count in the fs superblock must be what would have been in i_snapshot_blocks_count.  If the sb has been COW'ed, s_blocks_count in the COW'ed sb must be that value.  Why allocate and waste a full 32-bit field out of _every_ inode in the file system if it's possible to get that value via other places.

I have similar question about bg_cow_bitmap.  Is that really necessary?   The COW bitmap is just a copy of the base file system's block allocation bitmap, right?  (The wiki documentation and the design PDF isn't completely clear on that point, but that seems to be what it is.)   So why do you need to allocate a field out of the bg discriptor field for it?

It's not clear why you need an exclude inode, if you are also storing the address of the exclude bitmap blocks in the bg descriptor.  One or the other, but not both...

If s_snapshot_inum and s_snapshot_id refer to the "active" snapshot, why do they need to be in the on-disk structure.   Why not just have the first item of the linked list whose head is s_last_snapshot be the "active" snapshot (if this needs to be in the on-disk state at all); wouldn't the active snapshot be the most recent one anyway?   Also, as far as i_next_snapshot is concerned, why not just use d_time for the linked list.  That's what we do with the orphaned inode list, so we have code that maintains a linked list using d_time already.   So that way you don't need _any_ new inode fields.

I'm not convinced by all of the fs feature compatibility flags you've defined, either.   In general, if you suspect one part of the file system, you need to check everything.  So do you really need separate ro_compat bits for "fix_snapshot" and "fix_exclude"?    And why do you need "IS_SNAPSHOT"?   

As far as COMPAT_BIG_JOURNAL, we have feature flags in the journal, and that probably is better placed there.   And I assume COMPAT_EXCLUDE_INODE is really "COMPAT_HAS_SNAPSHOTS"?

BTW, if you are free at 11:00 US/Eastern on Monday, maybe you could join the ext4 weekly conference call, and we could try to hash some of this out on the telephone call?  I'm not sure where you are geographically based, so I don't know if this would be a hard time for you to make or not.

-- Ted
 

